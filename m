Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A4215A8;
	Tue, 26 Aug 2025 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215470; cv=none; b=i+lGFA9Uul/MTMnpcaqkGC+psnbkugBzL8/BvxFnQQb1uxB7wWjx+7ku8huLdotu4A96dxce0LZGuI4B1XSD9vR+GsC5yBVdmbbE+9o9ZWX+tR0gaPR9f+pswZ3eQN/J3FnfLyL/c/+cPUxeKiunaU17NC/Sb5m/+u7hlHLhqUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215470; c=relaxed/simple;
	bh=cofqVa0eT3VOp7HUauyFuClQYHII1TiIZs6WpKxjf9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAM/DDNfKftpuAOoTlTnMJ3pnnrDrHuIn4Obm/00IHnoyxciQN009upG3I6rrjrNf+sWWEUY2Wcrop3CueNvlr2Dn58VLyCKjM44AzZ/zNFECIJu4m6KsHE6kfWSxBgFcsi+th8c7k1fUFJynmHybJJ2HeB40ZX+BCHHeanLXcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiX8glU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiX8glU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0948C4CEF1;
	Tue, 26 Aug 2025 13:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215470;
	bh=cofqVa0eT3VOp7HUauyFuClQYHII1TiIZs6WpKxjf9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiX8glU2Y+ZvgWkva2kG9wYEbTqrqmnOIRPrRFrpX439yv/KwWKANJZpNdNYqel4R
	 Js3CGZyio64iOn/f+GT3qrfszJTY+KYiwe0AFgUluVHMnVRSTN6tA9Zv1KE4aDZuDv
	 gAUPCoF/l960agE1P6SYvp/Wx1qRjF5bAroNASFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/644] selftests: net: increase inter-packet timeout in udpgro.sh
Date: Tue, 26 Aug 2025 13:02:16 +0200
Message-ID: <20250826110947.622623098@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0e9418961f897be59b1fab6e31ae1b09a0bae902 ]

The mentioned test is not very stable when running on top of
debug kernel build. Increase the inter-packet timeout to allow
more slack in such environments.

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/b0370c06ddb3235debf642c17de0284b2cd3c652.1752163107.git.pabeni@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index 398f3bf969262..b38efda51b636 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -48,7 +48,7 @@ run_one() {
 
 	cfg_veth
 
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${rx_args} &
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 100 ${rx_args} &
 	local PID1=$!
 
 	wait_local_port_listen ${PEER_NS} 8000 udp
@@ -95,7 +95,7 @@ run_one_nat() {
 	# will land on the 'plain' one
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -G ${family} -b ${addr1} -n 0 &
 	local PID1=$!
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${family} -b ${addr2%/*} ${rx_args} &
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 100 ${family} -b ${addr2%/*} ${rx_args} &
 	local PID2=$!
 
 	wait_local_port_listen "${PEER_NS}" 8000 udp
@@ -117,9 +117,9 @@ run_one_2sock() {
 
 	cfg_veth
 
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${rx_args} -p 12345 &
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 100 ${rx_args} -p 12345 &
 	local PID1=$!
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 2000 -R 10 ${rx_args} &
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 2000 -R 100 ${rx_args} &
 	local PID2=$!
 
 	wait_local_port_listen "${PEER_NS}" 12345 udp
-- 
2.39.5



