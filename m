Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD6B19645B;
	Thu,  6 Jun 2024 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683027; cv=none; b=Yqg8zE328395JiDl3KTwaspy/upC0vMC2iBx6sop0+KA2xhBGxF+Z+cQbSG9pyya9pnsQltzjg1htUtcqH6t4l0euPWaXUQOd3GCqEks/G3inpvXUkVRG0ebjes0DuHXz98TaC6IrvHBYle0/JOdP4GavVgyjuFd0K4BcdOj9/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683027; c=relaxed/simple;
	bh=+np5vvRhAccdRO4sgrtg7XHvFHmxVd4y1dQpTYkOu+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noW1lPseKm9cMdl/125xhKNaWvnilKW9t9OPL1cW6WwaCgl/aGUIQNfsGeNFfoUMJpuQwSHOl/tP7YJ0OzwtJ6DKuf7p0sd3HYK1AyKI413WyMIwgCMvyM4esJAvaBkqgxDjfHHAd8AQD2FohcsEd7J/whj/52x85KardJ6aw0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RR6UBlKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RR6UBlKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FA0C32786;
	Thu,  6 Jun 2024 14:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683027;
	bh=+np5vvRhAccdRO4sgrtg7XHvFHmxVd4y1dQpTYkOu+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RR6UBlKkcYCzM80F19+/lOmilK/B2L9BVQQ07ZTJHTwRoGXkjpdX7H79QGlOATZ6C
	 dda7VTQy2nuKCtNz91zI3IMpHYItaUlf80UZLV3+WxS7dBOu9849qNemg7W8NlftA6
	 eULa8uOecyqr5WJwFdASrs4wcETR5FCa6uLvvD3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Waldekranz <tobias@waldekranz.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 247/374] selftests: forwarding: Change inappropriate log_test_skip() calls
Date: Thu,  6 Jun 2024 16:03:46 +0200
Message-ID: <20240606131700.095416275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 677f394956e808c709c18b92bd01d19f14a96dd5 ]

The SKIP return should be used for cases where tooling of the machine under
test is lacking. For cases where HW is lacking, the appropriate outcome is
XFAIL.

This is the case with ethtool_rmon and mlxsw_lib. For these, introduce a
new helper, log_test_xfail().

Do the same for router_mpath_nh_lib. Note that it will be fixed using a
more reusable way in a following patch.

For the two resource_scale selftests, the log should simply not be written,
because there is no problem.

Cc: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/3d668d8fb6fa0d9eeb47ce6d9e54114348c7c179.1711464583.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ea63ac142925 ("selftests/net: use tc rule to filter the na packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh   | 2 +-
 .../drivers/net/mlxsw/spectrum-2/resource_scale.sh       | 1 -
 .../drivers/net/mlxsw/spectrum/resource_scale.sh         | 1 -
 tools/testing/selftests/net/forwarding/ethtool_rmon.sh   | 4 ++--
 tools/testing/selftests/net/forwarding/lib.sh            | 9 +++++++++
 .../selftests/net/forwarding/router_mpath_nh_lib.sh      | 2 +-
 6 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh b/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
index 6369927e9c378..48395cfd4f958 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
@@ -42,7 +42,7 @@ __mlxsw_only_on_spectrum()
 	local src=$1; shift
 
 	if ! mlxsw_on_spectrum "$rev"; then
-		log_test_skip $src:$caller "(Spectrum-$rev only)"
+		log_test_xfail $src:$caller "(Spectrum-$rev only)"
 		return 1
 	fi
 }
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index a88d8a8c85f2e..899b6892603fd 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -47,7 +47,6 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 		RET=0
 		target=$(${current_test}_get_target "$should_fail")
 		if ((target == 0)); then
-			log_test_skip "'$current_test' should_fail=$should_fail test"
 			continue
 		fi
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index f981c957f0975..482ebb744ebad 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -52,7 +52,6 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 			RET=0
 			target=$(${current_test}_get_target "$should_fail")
 			if ((target == 0)); then
-				log_test_skip "'$current_test' [$profile] should_fail=$should_fail test"
 				continue
 			fi
 			${current_test}_setup_prepare
diff --git a/tools/testing/selftests/net/forwarding/ethtool_rmon.sh b/tools/testing/selftests/net/forwarding/ethtool_rmon.sh
index 41a34a61f7632..e78776db850f1 100755
--- a/tools/testing/selftests/net/forwarding/ethtool_rmon.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool_rmon.sh
@@ -78,7 +78,7 @@ rmon_histogram()
 
 		for if in $iface $neigh; do
 			if ! ensure_mtu $if ${bucket[0]}; then
-				log_test_skip "$if does not support the required MTU for $step"
+				log_test_xfail "$if does not support the required MTU for $step"
 				return
 			fi
 		done
@@ -93,7 +93,7 @@ rmon_histogram()
 		jq -r ".[0].rmon[\"${set}-pktsNtoM\"][]|[.low, .high]|@tsv" 2>/dev/null)
 
 	if [ $nbuckets -eq 0 ]; then
-		log_test_skip "$iface does not support $set histogram counters"
+		log_test_xfail "$iface does not support $set histogram counters"
 		return
 	fi
 }
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index e579c2e0c462a..9042fe92ca465 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -429,6 +429,15 @@ log_test_skip()
 	return 0
 }
 
+log_test_xfail()
+{
+	local test_name=$1
+	local opt_str=$2
+
+	printf "TEST: %-60s  [XFAIL]\n" "$test_name $opt_str"
+	return 0
+}
+
 log_info()
 {
 	local msg=$1
diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh_lib.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh_lib.sh
index 7e7d62161c345..b2d2c6cecc01e 100644
--- a/tools/testing/selftests/net/forwarding/router_mpath_nh_lib.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh_lib.sh
@@ -69,7 +69,7 @@ nh_stats_test_dispatch_swhw()
 		nh_stats_do_test "HW $what" "$nh1_id" "$nh2_id" "$group_id" \
 				 nh_stats_get_hw "${mz[@]}"
 	elif [[ $kind == veth ]]; then
-		log_test_skip "HW stats not offloaded on veth topology"
+		log_test_xfail "HW stats not offloaded on veth topology"
 	fi
 }
 
-- 
2.43.0



