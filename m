Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018118;
	b=G4LtT5s6vB3hNeadAfNX1pivPUr1ChvyONEHyIG0mnKm2OSQTWoMUcLsxYEL949+Fczf
	 XtZQK7aa2432qI5SLPfUPu1z7KlNqyCr04Al2DNeSJf+zcI0kvytWRBs3VsbSvXnDoq5O
	 RWGkZsKRiIJmN9Pz5e4PN8akksJyQm09hH4/3eP32t4SG9NHxuHevGT6S5eqsC82ASNRf
	 ReFm83GKPkvyaDtAuUDO3q8p82yF4qBhHLlewigdfZCJBg+ZrQDWwmdOqm9a4Gi6rGbTW
	 bROaHuBU1FxCaqVVj9N7YI6Eh0uWSa/cmM/1m94nJNCpLJTpBn1JhAd/uTp8TiaWa5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MlZFHSdmjtU2oZNzmJfwZsOYjVHJVvXcs5QGN4m+UyA=;
	b=GgDJgtk+wUCufSZkFFPiQzk0SuVf7uxcFEGdh2D8CPVG7pJ+H+SHz3Ve2qZFr0FMi0Xk
	 elVljsHaHudHo9aLULeD0OeRfY+8kgLmNPJeVJaB9oJa6/DBoQ/LlD08Es8nBBsNRGcq5
	 jOg9mP5L+q7sYGjFxpD9Y+xAtLEXdnLfjDsY1FL+hE5z5oMuRDQH/XAw6TR3Y6R9mGVjv
	 er1bismw6HWFiw80sEyh8N0h4SL7fh8KnQ3p/FsFyF8KQ6A82phkHKq8rW+5uN9wv1PaT
	 RVZDbivm5mAzLQ45ItWVEhn5w/SW6X731qMhgBDu8hEM/SbNvuGsKiYvmZKbtcnDIZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDJXuo70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731A9606A332;
	Wed, 18 Nov 2026 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDJXuo70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2DB1F000C4;
	Wed, 18 Nov 2026 16:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018118;
	bh=MlZFHSdmjtU2oZNzmJfwZsOYjVHJVvXcs5QGN4m+UyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDJXuo70EplP5hEoCtBCuR36hDqF2wHOdthTaXVnt23/ZZnIxhHGOPpP4jFEj5ZDF
	 1TKshCJRMuUhYqAWrHadorFlLDMjm5XkVhV0rymUoLH9DFkyByDZQZ51EWzxn+gQMz
	 ERMhLtY/TTSTv3syiAgLU/ZNXiUm1xl4Q4Zfnt4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1127/2651] selftests/rdma: Skip rxe_sent_rcvd_bytes when rdma_rxe is missing
Date: Wed, 18 Nov 2026 15:39:27 +0100
Message-ID: <20261118150328.588421995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

[ Upstream commit d2c08575500145dc5cb55075cd9b177626531613 ]

On a kernel built without CONFIG_RDMA_RXE the test exits 1 instead of
skipping:

  # modprobe: FATAL: Module rdma_rxe not found in directory ...
  not ok 467 selftests: rdma: rxe_sent_rcvd_bytes.sh # exit=1

Every other test in this directory probes with modinfo and exits
$KSFT_SKIP. Apply the same guard, identical to the one in the otherwise
near-identical rxe_socket_with_netns.sh.

Fixes: c67bd973695c3 ("selftest/rxe: Add selftests for perf")
Assisted-by: kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Link: https://patch.msgid.link/20260930135530.881281-1-doebel@amazon.de
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh b/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh
index 0e4fbfeebd228..89218ccfba4c1 100755
--- a/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh
+++ b/tools/testing/selftests/rdma/rxe_sent_rcvd_bytes.sh
@@ -4,6 +4,8 @@
 PORT=4791
 MODS=("tun" "rdma_rxe")
 
+source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
+
 exec > /dev/null
 
 # --- Helper: Cleanup Routine ---
@@ -24,6 +26,10 @@ if [[ $EUID -ne 0 ]]; then
 fi
 
 for m in "${MODS[@]}"; do
+    if ! modinfo "$m" >/dev/null 2>&1; then
+        echo "SKIP: Kernel module '$m' not found." >&2
+        exit $KSFT_SKIP
+    fi
     modprobe "$m" || { echo "Error: Failed to load $m"; exit 1; }
 done
 
-- 
2.53.0



