Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056555;
	b=QwaGXSdVnf5kLI7uKz48dcWuEWqkiX4W3xrzbsHc7e63L5QQicEKPyg58oQWBxusfFdK
	 p3A+4h6ZPAAEVqBmim5PfW9H/sd1iFM8/TvPecub4j9AhYAytYcXSgB4ujq9mjeaqLIuH
	 FabR7a8DpzAsj0rvO7o3ym7dSBI2igHhAKJk5G6Zf9vpJMouFWhPVQCmGu9HqWuDZfkaq
	 7esRRePtOBoRg5X4akGEG5FEZ/FyUHUHRuhTndtjvlMqnvZs15vzU7Pxw4U8rH2rnLb3B
	 GhfH1gaaFXMdb/foVh1etIE512u8qNQ8gRX6Xr7i2zeDN35WGlL2CVTYYeFccGXds3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9f+1jotSRmXhCqElBDdi8Vwyh25esqSSxwZt1J29H4Y=;
	b=xuvs8Yi2iiHQc3R3AJ0frmhYDhcGkSpKjBIYWv8HuF6267GmZkwrM2ZSS3rFi/LZqN+U
	 XUXaiGK1PRucBJvGZ2dyMCjS3mK7EJBeIbmd4pg/9wOrQXnrhUQTv6ZXmtF7W2sMrLOhe
	 o1NK9uw2mNGz56nVJbvTMUK+fwWfYtmK2kpucCiPEXm6SUvcT+VcUlcxGuouc0Yp0Wzlp
	 mlbciJCkHoVjxQVqagCy3kj8dS98rw82xL75qPuA6OmiiY5PU/0VOAkx1LJ/QbUg2ZgP+
	 bYxcJWQ+tY00WxachJ1XKW6iN9hQE/jUwnBR8LWrvgXO/BCzRATiIPaE9ypxsK3lupQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GV4uTRm9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D167606A330;
	Thu, 19 Nov 2026 02:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GV4uTRm9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D0D1F000C5;
	Thu, 19 Nov 2026 02:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056555;
	bh=9f+1jotSRmXhCqElBDdi8Vwyh25esqSSxwZt1J29H4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GV4uTRm94x9Kv+ejdogLF0S/NwKNUF7AO/baS8o6C9xbiXCcim+6n4wc+hFIUXPjt
	 7Vy6oNMWrXH2o8ebGACrYsE/SKO9Tq96f6RmTYGMf5m6R0iiPfCPLiYE9UwJCWu0wN
	 FsYdNy6TXy+nrnTUf30LecRF1wmUbo1LUie8rqFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2028/2214] selftests: netfilter: conntrack_vrf.sh: prefer socat, not iperf3
Date: Wed, 18 Nov 2026 16:01:44 +0100
Message-ID: <20261118150131.883995863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 99bc5950ebd4f84e48b5d1c53c13cf117031de82 ]

Use socat, like most of the other scripts already do.  This also makes
the script complete slightly faster (3s -> 1s).

iperf3 establishes two connections (1 control connection, and 1+x
depending on test), so adjust expected counter values as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20240423130604.7013-8-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a20a01ae8981 ("selftests: netfilter: fix return value in zone subtest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/netfilter/conntrack_vrf.sh      | 40 ++++++++++---------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
index f7417004ec714..073e8e62d350b 100755
--- a/tools/testing/selftests/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/netfilter/conntrack_vrf.sh
@@ -43,15 +43,9 @@ cleanup()
 	cleanup_all_ns
 }
 
-if ! nft --version > /dev/null 2>&1;then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
-
-if ! conntrack --version > /dev/null 2>&1;then
-	echo "SKIP: Could not run test without conntrack tool"
-	exit $ksft_skip
-fi
+checktool "nft --version" "run test without nft"
+checktool "conntrack --version" "run test without conntrack"
+checktool "socat -h" "run test without socat"
 
 trap cleanup EXIT
 
@@ -79,7 +73,15 @@ ip -net "$ns1" li set veth0 up
 ip -net "$ns0" addr add $IP0/$PFXL dev veth0
 ip -net "$ns1" addr add $IP1/$PFXL dev veth0
 
-ip netns exec "$ns1" iperf3 -s > /dev/null 2>&1 &
+listener_ready()
+{
+        local ns="$1"
+
+        ss -N "$ns" -l -n -t -o "sport = :55555" | grep -q "55555"
+}
+
+ip netns exec "$ns1" socat -u -4 TCP-LISTEN:55555,reuseaddr,fork STDOUT > /dev/null &
+busywait $BUSYWAIT_TIMEOUT listener_ready "$ns1"
 
 # test vrf ingress handling.
 # The incoming connection should be placed in conntrack zone 1,
@@ -160,16 +162,16 @@ table ip nat {
 	}
 }
 EOF
-	if ! ip netns exec "$ns0" ip vrf exec tvrf iperf3 -t 1 -c $IP1 >/dev/null; then
-		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on vrf device"
+	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
+		echo "FAIL: connect failure with masquerade + sport rewrite on vrf device"
 		ret=1
 		return
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 2' &&
-	if ip netns exec "$ns0" nft list table ip nat |grep -q 'untracked counter packets [1-9]'; then
-		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device ($qdisc qdisc)"
+	if ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 1' &&
+	   ip netns exec "$ns0" nft list table ip nat |grep -q 'untracked counter packets [1-9]'; then
+		echo "PASS: connect with masquerade + sport rewrite on vrf device ($qdisc qdisc)"
 	else
 		echo "FAIL: vrf rules have unexpected counter value"
 		ret=1
@@ -195,15 +197,15 @@ table ip nat {
 	}
 }
 EOF
-	if ! ip netns exec "$ns0" ip vrf exec tvrf iperf3 -t 1 -c $IP1 > /dev/null; then
-		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on veth device"
+	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
+		echo "FAIL: connect failure with masquerade + sport rewrite on veth device"
 		ret=1
 		return
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	if ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 2'; then
-		echo "PASS: iperf3 connect with masquerade + sport rewrite on veth device"
+	if ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 1'; then
+		echo "PASS: connect with masquerade + sport rewrite on veth device"
 	else
 		echo "FAIL: vrf masq rule has unexpected counter value"
 		ret=1
-- 
2.53.0



