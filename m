Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041994;
	b=KnJiYmKgkZcUMe8n8w4FAQ/L6UG7zWGOMC1IcKbnAtAxBZ9YOpGsk3Y3EyDUFklGX+re
	 kRkMAbkyu7F2R3zNw4VPRYZsTJXAoF5dS5v0gijo3HjoVCDbdcCkLi0BXpWWF7fugbrQD
	 Y2SMViSfsNXZkemm3vVTkvwmjfFlt55qaSWN5VpSHssvt00Y+/FIxKchJlKw3HSHd6b8c
	 lDE/neWvHiVx8hefumBsGoLr5V3uuU4J8vRpfCg5H3JetYjhGuUPgP9xoKo0Puuo37tyG
	 aFKfwbFCQTknkTP4idKuZqeOnnPEX/BsaHDP8OuEGy1ypPeRG1C9lgdZsAOnWAHXhUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wlthHVAWbniudCuQoDVMGLNyn2DG5b4cEW1vfbSBrvE=;
	b=Eqt1C6xWXrl1YCHf3WvEQWbRyT/igV6B9TXD9P0uN67LuAfN19+fq8e0P0irkRXyWwcl
	 wBC1zaWIBjJEaOF/kamqhFULNtuMTTP7nMLfK8VEw1QNE1seU8oCeJHr/Mo11DULn6hvx
	 VruWPiz9YBFHmEqburPJdSkgdZGKgcWDck7fdo6eH4HFE2kBgefujGYg2sZZj1MFbSgoU
	 z3lREzAX+VxougNH38a6He1RzW9CuZ2u5/Ql4uFjmaOSnpcJq8H1nUfkknZ3XH1CWESwn
	 tySgwVL4v7MsekfX7BipEG6awUOKuPjOTm20WNE9Lvsh7SYs5LYSNVZcSdTrZcasghQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ckiAuLAh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783B6606A320;
	Wed, 18 Nov 2026 22:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ckiAuLAh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEB41F000C4;
	Wed, 18 Nov 2026 22:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041994;
	bh=wlthHVAWbniudCuQoDVMGLNyn2DG5b4cEW1vfbSBrvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckiAuLAhXUxfvQZ/tnDZTGMiDW0Fb6n33aGZobYcwepHVDH+dyPOkJZAfab+6bNeA
	 AGYNuvRgT9HVdkOLJA7jzl3eF8eIArnkpujEDEV5SiogPk8MgprTh3enNH+eHktTuZ
	 sjcMNSe59TmmX1wqa5SY6i3I0O1JRP9ihUnVMq64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3011/3318] selftests: netfilter: fix return value in zone subtest
Date: Wed, 18 Nov 2026 16:00:33 +0100
Message-ID: <20261118150450.562926827@linuxfoundation.org>
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



