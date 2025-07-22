Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08A42EAB82;
	Tue, 22 Jul 2025 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193547; cv=none; b=l5Axd2B4Ovmghg5Tmtw0fw8qHGpOGHq0tCshdnNGqLkTC3qpp/Y9olA2VJe0/byuk5Vz8BbaqqHZqzwC+rD2vX1hAXIzqHhTlUuZdvYQOY1nqy8Q32ekkSqLv73piB8ytUT+pMsxrkkPu/Wf5CgToIclSQ3w0zOTm96la6pHPb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193547; c=relaxed/simple;
	bh=RQ8fPRYpIkqXWlugnrqNug3wi3iPJ1YBFzXda/Rdn4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWSinCscum0b/Tw1ygTTTqn5ENkb8SM/Q/1PkdAodzRQS8Bzeow6/81kbf1/sQ0HEis912NTtFXtDSn5p2JQunvKT1vcFHuew9nvLFhYef6fu+ZV6SzwPQdg8MVlK6AX91tl7RhP0IRA97lMkXZyPluqLF4juTEhe4kt/GT5bgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXxWBP+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXxWBP+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11728C4CEF1;
	Tue, 22 Jul 2025 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193546;
	bh=RQ8fPRYpIkqXWlugnrqNug3wi3iPJ1YBFzXda/Rdn4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXxWBP+OZLwhNIviE8YqNOJj732tJFvNZ1owIhOuLMis/8r2M0mMMZw94Zw96esBj
	 D/HIJRx4XQW0bzY1izoohis2BHvpVcLuWkws5I2SytKL6T8h/J4bWGTBw2rRSNp2GR
	 P8vgQXjH61J0gkPFYQNpTkhjRxbXIFAIHJFCQxRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 125/187] selftests: net: increase inter-packet timeout in udpgro.sh
Date: Tue, 22 Jul 2025 15:44:55 +0200
Message-ID: <20250722134350.403019525@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d5ffd8c9172e1..799dbc2b4b01c 100755
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



