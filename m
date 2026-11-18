Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061855;
	b=WZUTs2H4se2qE7seKAGtkzc9DjVMZ0csR3hR+Z21vtCnO9yfU7HwalML6dUwcFzXP5nO
	 aK1gUDTxVRE+0Olb+w5KuwGikxR9g5k3fnTlCmLm6I0eSZeZwG2UZj5O3wrp8tX8bK3DG
	 seNVx5UYedSePCz5Rsccyu1nqEgVTYXRwaZ9pe3QciwNzCRDDUPGNkiPY/4OLebyujMlw
	 d9grEnfbbEKvdTARzxJPqZLWTFV7E9N9i4qKMwEjEtBB86iPl8bhgmz4c+xA0TSKIhKAi
	 R+iHBuG18xu+ImRcCsLNemBAwVbKqSd7W307HpkVRHbUucmatHUcZlHtt8VUZRT899Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zRljP7HDxrNDofWZ45N6t/Fh3X+U+e3bUWrpN5V2tsU=;
	b=Ti3OCdEDls5r0Sz92thd77owV2Xr+esBIM4Zljl6D/8pgNxbEIRm1wv/Zmvwu8Ep5j9R
	 QOYE8kw59mlXT8VAxVYByBwbosqojERRjfcH36fuiCuyxJ9laZvj4Vq5TYPaMN41EjUCK
	 Fp0L5OBWtHfGxzJquMTRd5hw9u/hLJKh80SIEBiOD+g8ILOkkxVAeKNarBPGOSIzl9lpE
	 ZqR6O9OCgvxw5dTgMwViK3Q8+J8ttIzLdLbyEXoQl+H88qvwW5eNSeFhG1GePlbFY4s3L
	 5iaW2ppNxfY2jf4S2PD8YP7NeCdWtgXGvphNGEnzgZRasEk+zDIhdez4vG3pwOpzAdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+RKI6ID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715A7606A325;
	Thu, 19 Nov 2026 04:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+RKI6ID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4531F000C4;
	Thu, 19 Nov 2026 04:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061855;
	bh=zRljP7HDxrNDofWZ45N6t/Fh3X+U+e3bUWrpN5V2tsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+RKI6IDq/LyyGB9p1SNDyBR7jPOdWgktRUv7qmbcvURQD9FOqt9Mwv0pjhZdfGyy
	 7+XZK79o3XZzh9CXzrVhg/WjWOS5k6t6sGcFxdKhD87v+x+w+Xh6bZYJwlvMFlWiOa
	 zyyaI207E2iXu0746YE2HEkxwV27elRSfPDeIrjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1703/1848] selftests: netfilter: conntrack_vrf.sh: prefer socat, not iperf3
Date: Wed, 18 Nov 2026 16:02:21 +0100
Message-ID: <20261118150031.025650138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



