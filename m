Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041988;
	b=nxGMq+Z6QKMPiFlJzC7o0BP7QQWtgWe0s0IKPhFtTe08z0ocE3lx/RnU8xFeIEJsU7mr
	 1BCRf3JCkMhBO0v3c0awQufKv1yGc9Bd/xvFpDhn+HvKJqzKhLzduPA64/PTAD89g+dF1
	 D8CYDrC31Bm+AhOlHj8LFxmtSx0LRpV/79gymiwB0/1csBpUtpP6Cf4q5GG6VzysEAqYc
	 GS1nLHRZO2sUkzEtjA1de9pMUW7Y5RGOtkKwm+B5UWWpCQSJzkuesiVwoHwyIK06nblV7
	 JumkvcDViLmVy1lNiAwdULPRAnHy3nbjKgfkGBl5091KJakSpNvYvSZwss9RbXMaMEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cPiD7+c0D8CNzFJ1yETfLXRw9vKe8y0aIj5pjjSeSoQ=;
	b=m+YIBW+NKfmXQFejdxif41yMlb+qgeEvyrBtddLKfXg0+hLaj3RjP09FvGBVtHq8aVmc
	 fwr8/RkSBH/ceDULxINM/qirZM7s39Jqj4Jql2xPHtRFtj7M+uZ0zD0yF5JKXwPL5zIcg
	 SFBKYDzLgjcD3hfo1DQFTPYAWAH/WClsYo6LmuvBBtRFmp8DZT8MJPS7pjFesR9+PVTG9
	 KpD/lnotpSMZ+8KEv02bkWlXQWu937uxmvYsyP1ce+s6oEPApIgt2tEU4etxo+KDPO4Fp
	 oEvt5zm3o6hF43OyTx2Zg5EbYsWDkIpANN1B50xtmjLAkM5xaBCFtsOc/q+01mjLbiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2UaIHzC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9103606A320;
	Wed, 18 Nov 2026 22:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2UaIHzC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8781F000C4;
	Wed, 18 Nov 2026 22:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041988;
	bh=cPiD7+c0D8CNzFJ1yETfLXRw9vKe8y0aIj5pjjSeSoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2UaIHzCb5NNxIKVAMWzJraeNEhDNOo6TG4H6a0wR34AFP/PADTfQ9XCfY6WZsO+L
	 CQNynHUVBQde0WoZcqPWYgBd0rzoiYvgntUPpiAzP/ushXVqvZs/o8Z/ciPWr7k0Lq
	 om2oIAegTbKeX1guUY3CHhgIKwGZjtZ/45EPazQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3009/3318] selftests: netfilter: conntrack_vrf.sh: move to lib.sh infra
Date: Wed, 18 Nov 2026 16:00:31 +0100
Message-ID: <20261118150450.510066504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 954398b4d83759244656d37b4b626e912dc0969c ]

swap test for "ip" with "conntrack", former is already accounted for
via setup_ns helper.  Also switch to bash.

Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20240411233624.8129-8-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a20a01ae8981 ("selftests: netfilter: fix return value in zone subtest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/netfilter/conntrack_vrf.sh      | 101 +++++++-----------
 1 file changed, 39 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
index 8b5ea92345882..f7417004ec714 100755
--- a/tools/testing/selftests/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/netfilter/conntrack_vrf.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # This script demonstrates interaction of conntrack and vrf.
 # The vrf driver calls the netfilter hooks again, with oif/iif
@@ -28,84 +28,65 @@
 # that was supposed to be fixed by the commit mentioned above to make sure
 # that any fix to test case 1 won't break masquerade again.
 
-ksft_skip=4
+source lib.sh
 
 IP0=172.30.30.1
 IP1=172.30.30.2
 PFXL=30
 ret=0
 
-sfx=$(mktemp -u "XXXXXXXX")
-ns0="ns0-$sfx"
-ns1="ns1-$sfx"
-
 cleanup()
 {
 	ip netns pids $ns0 | xargs kill 2>/dev/null
 	ip netns pids $ns1 | xargs kill 2>/dev/null
 
-	ip netns del $ns0 $ns1
+	cleanup_all_ns
 }
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
+if ! nft --version > /dev/null 2>&1;then
 	echo "SKIP: Could not run test without nft tool"
 	exit $ksft_skip
 fi
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-ip netns add "$ns0"
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $ns0"
+if ! conntrack --version > /dev/null 2>&1;then
+	echo "SKIP: Could not run test without conntrack tool"
 	exit $ksft_skip
 fi
-ip netns add "$ns1"
 
 trap cleanup EXIT
 
-ip netns exec $ns0 sysctl -q -w net.ipv4.conf.default.rp_filter=0
-ip netns exec $ns0 sysctl -q -w net.ipv4.conf.all.rp_filter=0
-ip netns exec $ns0 sysctl -q -w net.ipv4.conf.all.rp_filter=0
+setup_ns ns0 ns1
 
-ip link add veth0 netns "$ns0" type veth peer name veth0 netns "$ns1" > /dev/null 2>&1
-if [ $? -ne 0 ];then
+ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.default.rp_filter=0
+ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.all.rp_filter=0
+ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.all.rp_filter=0
+
+if ! ip link add veth0 netns "$ns0" type veth peer name veth0 netns "$ns1" > /dev/null 2>&1; then
 	echo "SKIP: Could not add veth device"
 	exit $ksft_skip
 fi
 
-ip -net $ns0 li add tvrf type vrf table 9876
-if [ $? -ne 0 ];then
+if ! ip -net "$ns0" li add tvrf type vrf table 9876; then
 	echo "SKIP: Could not add vrf device"
 	exit $ksft_skip
 fi
 
-ip -net $ns0 li set lo up
-
-ip -net $ns0 li set veth0 master tvrf
-ip -net $ns0 li set tvrf up
-ip -net $ns0 li set veth0 up
-ip -net $ns1 li set veth0 up
+ip -net "$ns0" li set veth0 master tvrf
+ip -net "$ns0" li set tvrf up
+ip -net "$ns0" li set veth0 up
+ip -net "$ns1" li set veth0 up
 
-ip -net $ns0 addr add $IP0/$PFXL dev veth0
-ip -net $ns1 addr add $IP1/$PFXL dev veth0
+ip -net "$ns0" addr add $IP0/$PFXL dev veth0
+ip -net "$ns1" addr add $IP1/$PFXL dev veth0
 
-ip netns exec $ns1 iperf3 -s > /dev/null 2>&1&
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not start iperf3"
-	exit $ksft_skip
-fi
+ip netns exec "$ns1" iperf3 -s > /dev/null 2>&1 &
 
 # test vrf ingress handling.
 # The incoming connection should be placed in conntrack zone 1,
 # as decided by the first iteration of the ruleset.
 test_ct_zone_in()
 {
-ip netns exec $ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f - <<EOF
 table testct {
 	chain rawpre {
 		type filter hook prerouting priority raw;
@@ -126,21 +107,21 @@ table testct {
 	}
 }
 EOF
-	ip netns exec $ns1 ping -W 1 -c 1 -I veth0 $IP0 > /dev/null
+	ip netns exec "$ns1" ping -W 1 -c 1 -I veth0 "$IP0" > /dev/null
 
 	# should be in zone 1, not zone 2
-	count=$(ip netns exec $ns0 conntrack -L -s $IP1 -d $IP0 -p icmp --zone 1 2>/dev/null | wc -l)
-	if [ $count -eq 1 ]; then
+	count=$(ip netns exec "$ns0" conntrack -L -s $IP1 -d $IP0 -p icmp --zone 1 2>/dev/null | wc -l)
+	if [ "$count" -eq 1 ]; then
 		echo "PASS: entry found in conntrack zone 1"
 	else
 		echo "FAIL: entry not found in conntrack zone 1"
-		count=$(ip netns exec $ns0 conntrack -L -s $IP1 -d $IP0 -p icmp --zone 2 2> /dev/null | wc -l)
-		if [ $count -eq 1 ]; then
+		count=$(ip netns exec "$ns0" conntrack -L -s $IP1 -d $IP0 -p icmp --zone 2 2> /dev/null | wc -l)
+		if [ "$count" -eq 1 ]; then
 			echo "FAIL: entry found in zone 2 instead"
 		else
 			echo "FAIL: entry not in zone 1 or 2, dumping table"
-			ip netns exec $ns0 conntrack -L
-			ip netns exec $ns0 nft list ruleset
+			ip netns exec "$ns0" conntrack -L
+			ip netns exec "$ns0" nft list ruleset
 		fi
 	fi
 }
@@ -153,12 +134,12 @@ test_masquerade_vrf()
 	local qdisc=$1
 
 	if [ "$qdisc" != "default" ]; then
-		tc -net $ns0 qdisc add dev tvrf root $qdisc
+		tc -net "$ns0" qdisc add dev tvrf root "$qdisc"
 	fi
 
-	ip netns exec $ns0 conntrack -F 2>/dev/null
+	ip netns exec "$ns0" conntrack -F 2>/dev/null
 
-ip netns exec $ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain rawout {
@@ -179,17 +160,15 @@ table ip nat {
 	}
 }
 EOF
-	ip netns exec $ns0 ip vrf exec tvrf iperf3 -t 1 -c $IP1 >/dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" ip vrf exec tvrf iperf3 -t 1 -c $IP1 >/dev/null; then
 		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on vrf device"
 		ret=1
 		return
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2' &&
-	ip netns exec $ns0 nft list table ip nat |grep -q 'untracked counter packets [1-9]'
-	if [ $? -eq 0 ]; then
+	ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 2' &&
+	if ip netns exec "$ns0" nft list table ip nat |grep -q 'untracked counter packets [1-9]'; then
 		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device ($qdisc qdisc)"
 	else
 		echo "FAIL: vrf rules have unexpected counter value"
@@ -197,7 +176,7 @@ EOF
 	fi
 
 	if [ "$qdisc" != "default" ]; then
-		tc -net $ns0 qdisc del dev tvrf root
+		tc -net "$ns0" qdisc del dev tvrf root
 	fi
 }
 
@@ -206,8 +185,8 @@ EOF
 # oifname is the lower device (veth0 in this case).
 test_masquerade_veth()
 {
-	ip netns exec $ns0 conntrack -F 2>/dev/null
-ip netns exec $ns0 nft -f - <<EOF
+	ip netns exec "$ns0" conntrack -F 2>/dev/null
+ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain postrouting {
@@ -216,16 +195,14 @@ table ip nat {
 	}
 }
 EOF
-	ip netns exec $ns0 ip vrf exec tvrf iperf3 -t 1 -c $IP1 > /dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" ip vrf exec tvrf iperf3 -t 1 -c $IP1 > /dev/null; then
 		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on veth device"
 		ret=1
 		return
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2'
-	if [ $? -eq 0 ]; then
+	if ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 2'; then
 		echo "PASS: iperf3 connect with masquerade + sport rewrite on veth device"
 	else
 		echo "FAIL: vrf masq rule has unexpected counter value"
-- 
2.53.0



