Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65CE604A2;
	Tue, 13 Feb 2024 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845705; cv=none; b=Zkiq5WdoUSJjkMjm2l0kY7Sgua6BS/hpTm+uy4wBjib00LMpU3NY8V8CTMTS4cO7E5vIoZWsk6YJqSXwSdETDphtnzskG/RrGZPKAwtzpH31EsVqM8PP+6gS3jUHmvmjfY2whZqg7Cerb0oLCsyk4/r5+It7xth0pBqUZSnxC4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845705; c=relaxed/simple;
	bh=jiplrRBAbriW+aJem5kzACGGHOYqV6tl68AWzmcrB54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tmv7KA7QbvF6tFordXHvY6D+Q8gKixZ1Pwdj/fQRoOE41muHElYlvGYTlP4Bz3EsMLsWfiqtCrYUJZ5yAu7xQvdUTvP4jD296xQQ4PaSCkmElit8fCLRWhzX/jOudUy6wy6WIZDmE+VAYBISg6CtVbtBkLGXaitcbFMx8+Pnd1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WITzLOxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WITzLOxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB30C433F1;
	Tue, 13 Feb 2024 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845705;
	bh=jiplrRBAbriW+aJem5kzACGGHOYqV6tl68AWzmcrB54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WITzLOxsN/5T33E+DXRYZKaJDRcL/kyRJ5MDKLmc6OuEx1MKrkEtGP2kFIHk0ttHj
	 mpyev5sfRtkLd6f1uk14it5cejKUoo/NpCA46QE7qrLaGU7NlJsHaTCIlm2EUEUtuO
	 g3ord8AYWHLQgNzpdWGJE5u9htxmNVH8yPcjp4+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 035/124] selftests/net: convert pmtu.sh to run it in unique namespace
Date: Tue, 13 Feb 2024 18:20:57 +0100
Message-ID: <20240213171854.758439078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 378f082eaf3760cd7430fbcb1e4f8626bb6bc0ae ]

pmtu test use /bin/sh, so we need to source ./lib.sh instead of lib.sh
Here is the test result after conversion.

 # ./pmtu.sh
 TEST: ipv4: PMTU exceptions                                         [ OK ]
 TEST: ipv4: PMTU exceptions - nexthop objects                       [ OK ]
 TEST: ipv6: PMTU exceptions                                         [ OK ]
 TEST: ipv6: PMTU exceptions - nexthop objects                       [ OK ]
 ...
 TEST: ipv4: list and flush cached exceptions - nexthop objects      [ OK ]
 TEST: ipv6: list and flush cached exceptions                        [ OK ]
 TEST: ipv6: list and flush cached exceptions - nexthop objects      [ OK ]
 TEST: ipv4: PMTU exception w/route replace                          [ OK ]
 TEST: ipv4: PMTU exception w/route replace - nexthop objects        [ OK ]
 TEST: ipv6: PMTU exception w/route replace                          [ OK ]
 TEST: ipv6: PMTU exception w/route replace - nexthop objects        [ OK ]

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e71e016ad0f6 ("selftests: net: fix tcp listener handling in pmtu.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 4a5f031be232..8518eaacf4b5 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -198,8 +198,7 @@
 # - pmtu_ipv6_route_change
 #	Same as above but with IPv6
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source ./lib.sh
 
 PAUSE_ON_FAIL=no
 VERBOSE=0
@@ -268,16 +267,6 @@ tests="
 	pmtu_ipv4_route_change		ipv4: PMTU exception w/route replace	1
 	pmtu_ipv6_route_change		ipv6: PMTU exception w/route replace	1"
 
-NS_A="ns-A"
-NS_B="ns-B"
-NS_C="ns-C"
-NS_R1="ns-R1"
-NS_R2="ns-R2"
-ns_a="ip netns exec ${NS_A}"
-ns_b="ip netns exec ${NS_B}"
-ns_c="ip netns exec ${NS_C}"
-ns_r1="ip netns exec ${NS_R1}"
-ns_r2="ip netns exec ${NS_R2}"
 # Addressing and routing for tests with routers: four network segments, with
 # index SEGMENT between 1 and 4, a common prefix (PREFIX4 or PREFIX6) and an
 # identifier ID, which is 1 for hosts (A and B), 2 for routers (R1 and R2).
@@ -543,13 +532,17 @@ setup_ip6ip6() {
 }
 
 setup_namespaces() {
+	setup_ns NS_A NS_B NS_C NS_R1 NS_R2
 	for n in ${NS_A} ${NS_B} ${NS_C} ${NS_R1} ${NS_R2}; do
-		ip netns add ${n} || return 1
-
 		# Disable DAD, so that we don't have to wait to use the
 		# configured IPv6 addresses
 		ip netns exec ${n} sysctl -q net/ipv6/conf/default/accept_dad=0
 	done
+	ns_a="ip netns exec ${NS_A}"
+	ns_b="ip netns exec ${NS_B}"
+	ns_c="ip netns exec ${NS_C}"
+	ns_r1="ip netns exec ${NS_R1}"
+	ns_r2="ip netns exec ${NS_R2}"
 }
 
 setup_veth() {
@@ -839,7 +832,7 @@ setup_bridge() {
 	run_cmd ${ns_a} ip link set br0 up
 
 	run_cmd ${ns_c} ip link add veth_C-A type veth peer name veth_A-C
-	run_cmd ${ns_c} ip link set veth_A-C netns ns-A
+	run_cmd ${ns_c} ip link set veth_A-C netns ${NS_A}
 
 	run_cmd ${ns_a} ip link set veth_A-C up
 	run_cmd ${ns_c} ip link set veth_C-A up
@@ -944,9 +937,7 @@ cleanup() {
 	done
 	socat_pids=
 
-	for n in ${NS_A} ${NS_B} ${NS_C} ${NS_R1} ${NS_R2}; do
-		ip netns del ${n} 2> /dev/null
-	done
+	cleanup_all_ns
 
 	ip link del veth_A-C			2>/dev/null
 	ip link del veth_A-R1			2>/dev/null
-- 
2.43.0



