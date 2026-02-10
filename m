Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4530CD80
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 16:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770741393; cv=none; b=hpI5F9xR5C492uJp+tpf7+sNXVaA13fLIMQQnF2tej7WH1vm5pzeP6E3DwUGRpwcOjPVpvl6M7tj7viB1Nr8gre3U5Ub9llqLfj35TolMyYO9bWsh3XxmDEgvFiTEn6s7wtdztkGMdSuvw0A+1+Ht+/prLoxaKO++H58pIIImJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770741393; c=relaxed/simple;
	bh=p4hBr88k1cRQj/oM4nrRI2Q/ltvVnJYt8NL4L6JrEo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMYrYFYMRAvMS09xRQ+M4hkPoLNafBCnpnNOXjJle0iehKMB1X1ac49iULjVCqGQrLaoc8DkdT93yW14cJMTjHmg9xyIKi/ZOYXq4cauOb9ec913MkblMchIxJADi2qEBepox/MK7AMKg+6w+Ij7XyJ7DsiFLH9Ou9ow9+YbBcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H6pDVx1l; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H6pDVx1l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770741392; x=1802277392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p4hBr88k1cRQj/oM4nrRI2Q/ltvVnJYt8NL4L6JrEo8=;
  b=H6pDVx1l9UgybQTxhsMrcYalZ5Nm9KnXBCeNOWLeWDlrxk5ulpPD9r6U
   2gUsRsjyKUo3iAtSUYgJ9IeV4dUknZq+AVRtk+nz8DgIsvJivrfAtHhxx
   GiIN2GlCqsu+0ygO9DRaIk8eE4tsX+eb5OdYxiLwddGjPx6+N4//OzK3g
   BI3FA0ty2gK12Pbgq/fVBPkHTwpfTrs8dAAVYfd29x8GPTf31hfac/RaL
   Eus5yWk58p3msRpKMPt+9ZSRZRYvxESqKXrEkzMaojurtz7T+nK0PFyEg
   uJTW77AuXF0PGTfQHZgbzYPjbP0xcEXlOAYpxFsZpfTQdCPQTxJ2HI9K3
   Q==;
X-CSE-ConnectionGUID: D5eSsRyhRaulbKOSFtXrPg==
X-CSE-MsgGUID: Ke+t9yZURHqCy2uIw7Sq1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="74476855"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="74476855"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:28 -0800
X-CSE-ConnectionGUID: t7bUpeyeRKe7qPgrcnZODg==
X-CSE-MsgGUID: 4gLRrIuXSaCRC1PybS138w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212003469"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:27 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	peternewman@google.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	fenghuay@nvidia.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 6/8] selftests/resctrl: Remove requirement on cache miss rate
Date: Tue, 10 Feb 2026 08:50:45 -0800
Message-ID: <1730081d5b8c88d6c7f2696a9cce1eae34f6f810.1770406608.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1770406608.git.reinette.chatre@intel.com>
References: <cover.1770406608.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the CAT test reads the same buffer into different sized cache portions
it compares the number of cache misses against an expected percentage
based on the size of the cache portion.

Systems and test conditions vary. The CAT test is a test of resctrl
subsystem health and not a test of the hardware architecture so it is not
required to place requirements on the size of the difference in cache
misses, just that the number of cache misses when reading a buffer
increase as the cache portion used for the buffer decreases.

Remove additional constraint on how big the difference between cache
misses should be as the cache portion size changes. Only test that the
cache misses increase as the cache portion size decreases. This remains
a good sanity check of resctrl subsystem health while reducing impact
of hardware architectural differences and the various conditions under
which the test may run.

Increase the size difference between cache portions to additionally avoid
any consequences resulting from smaller increments.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/resctrl/cat_test.c | 33 ++++------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index f00b622c1460..8bc47f06679a 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -14,42 +14,20 @@
 #define RESULT_FILE_NAME	"result_cat"
 #define NUM_OF_RUNS		5
 
-/*
- * Minimum difference in LLC misses between a test with n+1 bits CBM to the
- * test with n bits is MIN_DIFF_PERCENT_PER_BIT * (n - 1). With e.g. 5 vs 4
- * bits in the CBM mask, the minimum difference must be at least
- * MIN_DIFF_PERCENT_PER_BIT * (4 - 1) = 3 percent.
- *
- * The relationship between number of used CBM bits and difference in LLC
- * misses is not expected to be linear. With a small number of bits, the
- * margin is smaller than with larger number of bits. For selftest purposes,
- * however, linear approach is enough because ultimately only pass/fail
- * decision has to be made and distinction between strong and stronger
- * signal is irrelevant.
- */
-#define MIN_DIFF_PERCENT_PER_BIT	1UL
-
 static int show_results_info(__u64 sum_llc_val, int no_of_bits,
 			     unsigned long cache_span,
-			     unsigned long min_diff_percent,
 			     unsigned long num_of_runs, bool platform,
 			     __s64 *prev_avg_llc_val)
 {
 	__u64 avg_llc_val = 0;
-	float avg_diff;
 	int ret = 0;
 
 	avg_llc_val = sum_llc_val / num_of_runs;
 	if (*prev_avg_llc_val) {
-		float delta = (__s64)(avg_llc_val - *prev_avg_llc_val);
-
-		avg_diff = delta / *prev_avg_llc_val;
-		ret = platform && (avg_diff * 100) < (float)min_diff_percent;
-
-		ksft_print_msg("%s Check cache miss rate changed more than %.1f%%\n",
-			       ret ? "Fail:" : "Pass:", (float)min_diff_percent);
+		ret = platform && (avg_llc_val < *prev_avg_llc_val);
 
-		ksft_print_msg("Percent diff=%.1f\n", avg_diff * 100);
+		ksft_print_msg("%s Check cache miss rate increased\n",
+			       ret ? "Fail:" : "Pass:");
 	}
 	*prev_avg_llc_val = avg_llc_val;
 
@@ -58,10 +36,10 @@ static int show_results_info(__u64 sum_llc_val, int no_of_bits,
 	return ret;
 }
 
-/* Remove the highest bit from CBM */
+/* Remove the highest bits from CBM */
 static unsigned long next_mask(unsigned long current_mask)
 {
-	return current_mask & (current_mask >> 1);
+	return current_mask & (current_mask >> 2);
 }
 
 static int check_results(struct resctrl_val_param *param, const char *cache_type,
@@ -112,7 +90,6 @@ static int check_results(struct resctrl_val_param *param, const char *cache_type
 
 		ret = show_results_info(sum_llc_perf_miss, bits,
 					alloc_size / 64,
-					MIN_DIFF_PERCENT_PER_BIT * (bits - 1),
 					runs, get_vendor() == ARCH_INTEL,
 					&prev_avg_llc_val);
 		if (ret)
-- 
2.50.1

