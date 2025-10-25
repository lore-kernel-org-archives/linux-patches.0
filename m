Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4456E3064B8;
	Sat, 25 Oct 2025 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409690; cv=none; b=FLDxwEbGgeE2Y3y9EH+6v9DPxYmpcmg4hQinTpl3XqmVeeSL2RZJhEi2GXWlLgRKOcZHShek9AiZiRHvIYKtypygkexm32lkDjPJAGFyIPK82IqFwl0E6cCFPHlJusHn3chL6pasK0VMARNO6Kb+9TfJw8Rca9CihbQksbyzlm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409690; c=relaxed/simple;
	bh=iuZmFdFjt50jJxvCiEYJsLp46HCo0ssm5byWpcsg4aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D0lSVUdwksLQCKU/uKVQ4iavMMaskaLgtsHmd3SuEG7PvyeOzJxnIc6gU5O3xHZjChMWfHQE873+2hRK9Ynms0kETyl1JEsqyZvO4PKyNpY0t65Xjc5NVLkKSyKuyhduf0Mvj/RZzmt4A/VhlCuZyiw/rK82xSTaO9dQjbD2GXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkN4bpKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkN4bpKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCDBC4CEF5;
	Sat, 25 Oct 2025 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409690;
	bh=iuZmFdFjt50jJxvCiEYJsLp46HCo0ssm5byWpcsg4aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkN4bpKKmlLnaQno4PuCswKt+/Hzsj7qu5It/VrrzFjYcXynxRz4j2w3CXj3ztu9+
	 aeUh8PnZSWcBYqTHF3vTGu5J2VsT8Od6tr2Ns66iTFhMx152xByN3v6FP97mGI9aFa
	 DgQqLHql6kcxZnT9xt/3U3TN2EXLlrQRnDmiS5J9VD/AKqXBqwWQqM5ajFX5wCzVEz
	 GmgxdD2mCy87pnmmhHWNu0PLXOFQo3IReDr8qP5Kxi3sql2aMJmkgrBoJyNC7K8gxg
	 DchLsB/VBpGZkRRk0H9gnlowYqCmOJ40OOl4AqMqNVJ7CVzy8LafdwXyNlxS6G/kSD
	 VHtvZMDRIDUBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	skhan@linuxfoundation.org,
	amcohen@nvidia.com,
	horms@kernel.org,
	shuali@redhat.com,
	alessandro.zanni87@gmail.com,
	liuhangbin@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] selftests: forwarding: Reorder (ar)ping arguments to obey POSIX getopt
Date: Sat, 25 Oct 2025 12:00:51 -0400
Message-ID: <20251025160905.3857885-420-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES – This change fixes real breakage in the forwarding selftests on
musl-based systems by making every `(ar)ping` invocation conform to
POSIX `getopt`, letting mandatory options actually be parsed instead of
being ignored once the destination argument appears.

- In `tools/testing/selftests/net/forwarding/lib.sh:1279`, `ping_do()`
  now places `$args` before the `-c/-i/-w` switches and the destination,
  ensuring loops that rely on `-c $PING_COUNT` terminate. On musl, the
  old ordering (`dest -c …`) caused `getopt` to stop parsing at the
  destination, so the count limit was silently dropped and tests could
  hang.
- The same reordering is applied to IPv6 helpers and stress loops such
  as `send_flowlabel()` in `custom_multipath_hash.sh:226`,
  `gre_custom_multipath_hash.sh:227`, and
  `ip6gre_custom_multipath_hash.sh:228`, as well as the IPv6 stats tests
  in `ip6_forward_instats_vrf.sh:98:153`. Without it, options like `-F
  0` or `-c 1` were ignored, so these scripts failed immediately under
  musl’s strict `getopt`.
- `mirror_gre_bridge_1q_lag.sh:241` and
  `mirror_gre_vlan_bridge_1q.sh:199/293` now pass the target host last
  to `arping`, guaranteeing that `-qfc 1` takes effect. Previously, `-c
  1` was never seen on musl, leaving `arping` running indefinitely and
  stalling the tests.

The fix is tiny, self-contained, and purely in user-space test scripts,
but it restores the ability to run the forwarding selftests on musl-
based distros (e.g., Alpine) without changing behaviour on glibc
systems. Given the clear user impact and negligible regression risk,
it’s a good candidate for stable backporting. Consider running the
forwarding selftest suite once on a musl environment after backporting
to confirm the improvement.

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

