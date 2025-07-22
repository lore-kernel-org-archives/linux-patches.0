Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE71D154457;
	Tue, 22 Jul 2025 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192229; cv=none; b=Z2eCDOiJl7tkXIdVVHfHxXAuB6+GxqQS+ByWFuGa1BjB2g8csbukAm/WAL8pn+kYRXJlDI9uY1a87L8I0Mhme3ep67J22Vh1Rpcqmi9gvY0xsRIpUeETgA2Pn81UdLQvHLHGj5h8iSDa212aDMaDK7Az2YJtub9PBV1kw6u8Tl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192229; c=relaxed/simple;
	bh=snJSgwxlR2GTWtau0XXLksW9hZrgrhl+DGqkFYzSHVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQvkLucSKLZo9ozQ7T3fb7OTN2+3t5FdjofLAEuXPQp6OnYbSX7RVEjQWffjkcrB5Bao5UaGjiXtgSJq0hnYxGxfC/mbKk2bi2r/Pzg7kD1ti9NUJJ4NPfxQxxsqJ3pnBkOumhEmCzU2y/vOoMUMC5lFWPUBkqwpo5UMcLzEhTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djVyGn6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djVyGn6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B32DC4CEEB;
	Tue, 22 Jul 2025 13:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192229;
	bh=snJSgwxlR2GTWtau0XXLksW9hZrgrhl+DGqkFYzSHVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djVyGn6ZHMbOXRw0uLkfAATPs2DqhgZfrZ6HFmCLowBfK4T7/v/YRoz8VlGJsK2fj
	 f8bO6J+4d3k3WPQQ/Zh+IfXOxg8M01I80YJtfC2e8IESV9oB2QKarnZO5dKFesB/Th
	 6JlH7Px06cMdQmT6xffGQjbAGnpPrYXJ1NuJPHzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/79] selftests: net: increase inter-packet timeout in udpgro.sh
Date: Tue, 22 Jul 2025 15:44:45 +0200
Message-ID: <20250722134330.181901200@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 241c6c37994d8..f6e50824c5eb9 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -50,7 +50,7 @@ run_one() {
 
 	cfg_veth
 
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${rx_args} &
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 100 ${rx_args} &
 	local PID1=$!
 
 	wait_local_port_listen ${PEER_NS} 8000 udp
@@ -97,7 +97,7 @@ run_one_nat() {
 	# will land on the 'plain' one
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -G ${family} -b ${addr1} -n 0 &
 	local PID1=$!
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${family} -b ${addr2%/*} ${rx_args} &
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 100 ${family} -b ${addr2%/*} ${rx_args} &
 	local PID2=$!
 
 	wait_local_port_listen "${PEER_NS}" 8000 udp
@@ -119,9 +119,9 @@ run_one_2sock() {
 
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



