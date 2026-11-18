Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056560;
	b=Ts3l453j04pl2x65txrM9yvlabLWLbCdRxmvqARkpJLu0g4zKb7TkMVspymHyqStivPO
	 G2GqG0z2hA1G7bKmGmL2tzOgCS33kR6+GU1hjv268u96VbsZXun56EHOzFsHE0EYWdhVE
	 1SgwPxbPsDERT3tIhQUcb/YD0ws1YhvjD5PgqD1k4iatQnbV6Xl91cI1lJd8Bqh0wPV3f
	 V/gIzJRH80fxf798IzCZXBv6ZPEIcrxj92kWY1CAneZf7aD2bjJEYe3Lbm97xiiuZf5o5
	 jHDk0tnh4haS6EAr83ScuGquZBIpOtAGUepFVwy18HbA3d5ab1Uu2DrMzspjpbAtj6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ajY/VcSC3XGev3Zkw8hjk2sGh0DDov4mldzNz3VUnBQ=;
	b=wEZ01ut3qYKPc/ui487NQrCXiym/i0S1b+7xrsxP9BJ9bHrftndPRNhj4fK8lmohI0Om
	 8v/xD31N5LU+PCr1QR3tp6JXVFGsexhBC5Hv1kNd6+SuGtp0DcYtVfSQmqLVPCsOzAadl
	 WzTMfcVsB1Owlp/lSOKYirk/Dav6jD1Ym9YPRNYDigkJxKL9R0RRF4VWd2W0VZ4P45Kbv
	 UUMd9K568RCvSEAfTtNamt2hE4ut6ij0PmYGKqCn0eKAgqZByxx48IB5jzoVavjSUL3gd
	 T2/d1MG7V6PrDGzDRd6ihgyHczsgkGvPvAcyjNQAZ+xQJ5WTyj6Ac9zpezIgDc4/3RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsZRKs66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91FA606A32A;
	Thu, 19 Nov 2026 02:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsZRKs66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B791F000C5;
	Thu, 19 Nov 2026 02:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056560;
	bh=ajY/VcSC3XGev3Zkw8hjk2sGh0DDov4mldzNz3VUnBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsZRKs66oZAbdWlPeIqKI53Cv2bq+c4DYmer0h/t4DgiTxYEGE5dBphR43hlbf0ex
	 V6lpq0Qe4rRGhF3b1avp8s/xNc1O5MbKl9PEFX/UREZFBRVD1YckjDLg9WAwOdxRYW
	 nEab7qHybkwgxWL+0zJVDLCXveQuJo2KEA4vnCCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2029/2214] selftests: netfilter: fix return value in zone subtest
Date: Wed, 18 Nov 2026 16:01:45 +0100
Message-ID: <20261118150131.930394031@linuxfoundation.org>
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

[ Upstream commit a20a01ae89813ef493dc416d69f2b2ad17afb54c ]

zone subtest prints FAIL, but did not set 'ret=1', so kselftest
framework reports success.

While at it, also fail when "nft -f" returns an error.

Noticed thanks to a (broken) local patch that should have caused this
selftest (resp. the kselftest framework) to report a failure.

Fixes: 33b8aad21ac1 ("selftests: netfilter: add a vrf+conntrack testcase")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/netfilter/conntrack_vrf.sh      | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
index 073e8e62d350b..e099221acbcc7 100755
--- a/tools/testing/selftests/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/netfilter/conntrack_vrf.sh
@@ -88,7 +88,7 @@ busywait $BUSYWAIT_TIMEOUT listener_ready "$ns1"
 # as decided by the first iteration of the ruleset.
 test_ct_zone_in()
 {
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 table testct {
 	chain rawpre {
 		type filter hook prerouting priority raw;
@@ -109,6 +109,12 @@ table testct {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load testct nft ruleset"
+		ret=1
+		return
+	fi
+
 	ip netns exec "$ns1" ping -W 1 -c 1 -I veth0 "$IP0" > /dev/null
 
 	# should be in zone 1, not zone 2
@@ -117,6 +123,7 @@ EOF
 		echo "PASS: entry found in conntrack zone 1"
 	else
 		echo "FAIL: entry not found in conntrack zone 1"
+		ret=1
 		count=$(ip netns exec "$ns0" conntrack -L -s $IP1 -d $IP0 -p icmp --zone 2 2> /dev/null | wc -l)
 		if [ "$count" -eq 1 ]; then
 			echo "FAIL: entry found in zone 2 instead"
@@ -141,7 +148,7 @@ test_masquerade_vrf()
 
 	ip netns exec "$ns0" conntrack -F 2>/dev/null
 
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain rawout {
@@ -162,6 +169,12 @@ table ip nat {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load ip nat nft ruleset"
+		ret=1
+		return
+	fi
+
 	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
 		echo "FAIL: connect failure with masquerade + sport rewrite on vrf device"
 		ret=1
@@ -188,7 +201,7 @@ EOF
 test_masquerade_veth()
 {
 	ip netns exec "$ns0" conntrack -F 2>/dev/null
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain postrouting {
@@ -197,6 +210,12 @@ table ip nat {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load ip nat postrouting ruleset"
+		ret=1
+		return
+	fi
+
 	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
 		echo "FAIL: connect failure with masquerade + sport rewrite on veth device"
 		ret=1
-- 
2.53.0



