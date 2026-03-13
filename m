Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A1F378811
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 20:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433983; cv=none; b=E9h+M+JntlSiBiAkrp9O129xxdBpwuHCtxrA+MIOHz+czZq27XsPNJFzagsHrkHWcFIEJwgF/fYNDCRLSSGxibD1hfisHAT8QIJxuAW4B5b6qQ+0rxSEG/eeQdGesu5J9RdPrXz1R/sAqrFcHp957r4uVWXO/TFcD/SYl5C9u4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433983; c=relaxed/simple;
	bh=Vnn+i8nVsH/EVmGtp2eUU58NjAstKrKZ6qtPgrztQYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL4zJNP/5EEVUGaFa9SIdMmHoSzXa/3IqFIp+1J2tFv7FHDP51GnVRrNpxAwOhpnEHWPtEEvEEZhkDaiN4JK6/uKYyumN+Y/oebXcYylIxdpBgFvRs7nRACw9kPNAre1vZ2reqcYdB0HePt1wk5+FXhDcw2RVFcqAs8CMg0tG60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mtc2hG6W; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mtc2hG6W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773433980; x=1804969980;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vnn+i8nVsH/EVmGtp2eUU58NjAstKrKZ6qtPgrztQYI=;
  b=Mtc2hG6WOp2lxNw93l2vrGz3bejPr7g8ICRJbUlOV6QzLQpkCndQbOBZ
   62gfZNpDqf3aaa3LuZ7gbDQaalR8JgWpdyrxO2W7nn4oQ1lB1aaQrI+Yy
   eTzvb/L6jm1yyk6fAjzfABQv+ddC4shmd68GMbOsAThJA8MpoMzIVYqcR
   wZlivl+SlP/pjgpL4AuLTWlCmnfNJsnrOISFZF2IkuURwAXRvGEJY6RWn
   Z2GCaup64nEHGZi1mCqIqViIzR8ZwVoO3RIpdGZdbrdQcmNV+5Gg7tp7x
   2ksE0yoBgT+bQpT7EIRxtBzNDC1illlVr6sR+f+mUKcz98ob/k0przOSi
   A==;
X-CSE-ConnectionGUID: gULNz6Q6TNmvU1CD8HZIGA==
X-CSE-MsgGUID: 3uj/JO6sTAecjGtQUUr5Rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="74519303"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="74519303"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:55 -0700
X-CSE-ConnectionGUID: YpLeoj5HTA6sEBqI4AFP6w==
X-CSE-MsgGUID: 5JbJIoMsRHaXlRSC2H29ow==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:54 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	ben.horgan@arm.com,
	yu.c.chen@intel.com,
	jason.zeng@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 08/10] selftests/resctrl: Remove requirement on cache miss rate
Date: Fri, 13 Mar 2026 13:32:35 -0700
Message-ID: <1fc79420f76d585231252e59d4fcf19b3e704ee3.1773432891.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1773432891.git.reinette.chatre@intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com>
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
Tested-by: Chen Yu <yu.c.chen@intel.com>
---
Changes since v2:
- Add Chen Yu's tag.
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

