Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B9A33C534;
	Tue, 11 Nov 2025 01:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825003; cv=none; b=US/fzw5O4v5qkppLCTL47Y+MEG+7tYS3Cf/gFZ6cKPPY8ejBxNecdFy65AnUnOSBiC6ki9/rk0JhbOCl28a8p/vrJIEc0TnmKi80MO4L650I/ufwa0/Xdu6Hk/Y3ygvi/QVuJIKE6HvTNGm0RxLmB/B4EIIXCU6Lu6AEDTozkM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825003; c=relaxed/simple;
	bh=/j9J07NaJUJdf0AGNqLLZ78dlNHAu+xdDjeDjwi46dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI9a5aLgSe1vUvltXY0IE5LlgFVPT8Otz+28kjQZVq8uBdvGTMUypOP+gHyIl34H64TT6Qed+ccHpEc03PLaiUagXdUDHuKnGqPVvUlPkQaxaMSo1niY6Qp+KWuQD9DkNdQPx2maZSDdvay5mb/DZA5kBdWlyNqTxyV4Xn6BrRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+HOvfU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+HOvfU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE5AC19422;
	Tue, 11 Nov 2025 01:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825002;
	bh=/j9J07NaJUJdf0AGNqLLZ78dlNHAu+xdDjeDjwi46dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+HOvfU8ZWpsqIuTNiL/pzQ8s4hSGLMw3TfzW1QHQrxmyVue1BJU79x97ZBx7YL6G
	 0aelkEWb99HR/Jx16FYKBlgoj1yOqnoULfvjv2MCFy4k/dFNQHMjHn13fgkt3KTB7N
	 zQS+bwy1F/G/9gmrBOnDtLWchnbfwafaODFDSnZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 614/849] selftests: forwarding: Reorder (ar)ping arguments to obey POSIX getopt
Date: Tue, 11 Nov 2025 09:43:04 +0900
Message-ID: <20251111004551.270335225@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit 50d51cef555ee42fe47dd51b71366a77895e5f0b ]

Quoted from musl wiki:

  GNU getopt permutes argv to pull options to the front, ahead of
  non-option arguments. musl and the POSIX standard getopt stop
  processing options at the first non-option argument with no
  permutation.

Thus these scripts stop working on musl since non-option arguments for
tools using getopt() (in this case, (ar)ping) do not always come last.
Fix it by reordering arguments.

Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250919053538.1106753-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/forwarding/custom_multipath_hash.sh     | 2 +-
 .../selftests/net/forwarding/gre_custom_multipath_hash.sh | 2 +-
 .../selftests/net/forwarding/ip6_forward_instats_vrf.sh   | 6 +++---
 .../net/forwarding/ip6gre_custom_multipath_hash.sh        | 2 +-
 tools/testing/selftests/net/forwarding/lib.sh             | 8 ++++----
 .../selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh  | 2 +-
 .../selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh | 4 ++--
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
index 7d531f7091e6f..5dbfab0e23e3d 100755
--- a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
@@ -226,7 +226,7 @@ send_flowlabel()
 	# Generate 16384 echo requests, each with a random flow label.
 	ip vrf exec v$h1 sh -c \
 		"for _ in {1..16384}; do \
-			$PING6 2001:db8:4::2 -F 0 -c 1 -q >/dev/null 2>&1; \
+			$PING6 -F 0 -c 1 -q 2001:db8:4::2 >/dev/null 2>&1; \
 		done"
 }
 
diff --git a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
index dda11a4a9450a..b4f17a5bbc614 100755
--- a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
@@ -321,7 +321,7 @@ send_flowlabel()
 	# Generate 16384 echo requests, each with a random flow label.
 	ip vrf exec v$h1 sh -c \
 		"for _ in {1..16384}; do \
-			$PING6 2001:db8:2::2 -F 0 -c 1 -q >/dev/null 2>&1; \
+			$PING6 -F 0 -c 1 -q 2001:db8:2::2 >/dev/null 2>&1; \
 		done"
 }
 
diff --git a/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh b/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
index 49fa94b53a1ca..25036e38043c8 100755
--- a/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
+++ b/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
@@ -95,7 +95,7 @@ ipv6_in_too_big_err()
 
 	# Send too big packets
 	ip vrf exec $vrf_name \
-		$PING6 -s 1300 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+		$PING6 -s 1300 -c 1 -w $PING_TIMEOUT 2001:1:2::2 &> /dev/null
 
 	local t1=$(ipv6_stats_get $rtr1 Ip6InTooBigErrors)
 	test "$((t1 - t0))" -ne 0
@@ -131,7 +131,7 @@ ipv6_in_addr_err()
 	# Disable forwarding temporary while sending the packet
 	sysctl -qw net.ipv6.conf.all.forwarding=0
 	ip vrf exec $vrf_name \
-		$PING6 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+		$PING6 -c 1 -w $PING_TIMEOUT 2001:1:2::2 &> /dev/null
 	sysctl -qw net.ipv6.conf.all.forwarding=1
 
 	local t1=$(ipv6_stats_get $rtr1 Ip6InAddrErrors)
@@ -150,7 +150,7 @@ ipv6_in_discard()
 	# Add a policy to discard
 	ip xfrm policy add dst 2001:1:2::2/128 dir fwd action block
 	ip vrf exec $vrf_name \
-		$PING6 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+		$PING6 -c 1 -w $PING_TIMEOUT 2001:1:2::2 &> /dev/null
 	ip xfrm policy del dst 2001:1:2::2/128 dir fwd
 
 	local t1=$(ipv6_stats_get $rtr1 Ip6InDiscards)
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
index e28b4a079e525..b24acfa52a3a7 100755
--- a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
@@ -323,7 +323,7 @@ send_flowlabel()
 	# Generate 16384 echo requests, each with a random flow label.
 	ip vrf exec v$h1 sh -c \
 		"for _ in {1..16384}; do \
-			$PING6 2001:db8:2::2 -F 0 -c 1 -q >/dev/null 2>&1; \
+			$PING6 -F 0 -c 1 -q 2001:db8:2::2 >/dev/null 2>&1; \
 		done"
 }
 
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 890b3374dacda..593077cf05937 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1291,8 +1291,8 @@ ping_do()
 
 	vrf_name=$(master_name_get $if_name)
 	ip vrf exec $vrf_name \
-		$PING $args $dip -c $PING_COUNT -i 0.1 \
-		-w $PING_TIMEOUT &> /dev/null
+		$PING $args -c $PING_COUNT -i 0.1 \
+		-w $PING_TIMEOUT $dip &> /dev/null
 }
 
 ping_test()
@@ -1322,8 +1322,8 @@ ping6_do()
 
 	vrf_name=$(master_name_get $if_name)
 	ip vrf exec $vrf_name \
-		$PING6 $args $dip -c $PING_COUNT -i 0.1 \
-		-w $PING_TIMEOUT &> /dev/null
+		$PING6 $args -c $PING_COUNT -i 0.1 \
+		-w $PING_TIMEOUT $dip &> /dev/null
 }
 
 ping6_test()
diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
index a20d22d1df362..8d4ae6c952a1f 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
@@ -238,7 +238,7 @@ test_lag_slave()
 	ip neigh flush dev br1
 	setup_wait_dev $up_dev
 	setup_wait_dev $host_dev
-	$ARPING -I br1 192.0.2.130 -qfc 1
+	$ARPING -I br1 -qfc 1 192.0.2.130
 	sleep 2
 	mirror_test vrf-h1 192.0.2.1 192.0.2.18 $host_dev 1 ">= 10"
 
diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
index 1b902cc579f62..a21c771908b33 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
@@ -196,7 +196,7 @@ test_span_gre_forbidden_egress()
 
 	bridge vlan add dev $swp3 vid 555
 	# Re-prime FDB
-	$ARPING -I br1.555 192.0.2.130 -fqc 1
+	$ARPING -I br1.555 -fqc 1 192.0.2.130
 	sleep 1
 	quick_test_span_gre_dir $tundev
 
@@ -290,7 +290,7 @@ test_span_gre_fdb_roaming()
 
 	bridge fdb del dev $swp2 $h3mac vlan 555 master 2>/dev/null
 	# Re-prime FDB
-	$ARPING -I br1.555 192.0.2.130 -fqc 1
+	$ARPING -I br1.555 -fqc 1 192.0.2.130
 	sleep 1
 	quick_test_span_gre_dir $tundev
 
-- 
2.51.0



