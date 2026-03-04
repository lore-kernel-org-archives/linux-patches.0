Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF42F5A13
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 00:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583591; cv=none; b=peFXig4QowTqmtmXzlVhu7ll3GW0fdCw+9oQ0+m1JtaTi0CWDVOIYEQ0B697UL4eWrpeL4IYQ2jpiv0KZlq41655kL5xbvfJmZMUKQYf9KDgdXFXTbNbByvViF0vDRSHg2rl8bEyUwWj4T1/CKZC1FuxRz3gUGpjqy6SUgb0Tkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583591; c=relaxed/simple;
	bh=p4hBr88k1cRQj/oM4nrRI2Q/ltvVnJYt8NL4L6JrEo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBwEAvGr27tqVzmTxLwo2cGyCHCoujzpP0ecnJq/GUQa51XUfSMFmn6AgiXg7/D4aOIcjoX4JMSci6BP1E+GyEhf8vtrgW2apxj7TILXhWD8Ww0IzHNeO9q/CAYJPlyMajCu7LxkFqhKJ3yZv7/wQeM30jw3x+ZUejj9GWXEaD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QwBjegxf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QwBjegxf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772583591; x=1804119591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p4hBr88k1cRQj/oM4nrRI2Q/ltvVnJYt8NL4L6JrEo8=;
  b=QwBjegxfKfnwVIZ4Yd9mQTV1swRxxEg2Jjy2SA3T0QnbcwXC8ccYnDP5
   Tl2rXPMaDYySjAeNeJMJGN/Qu1Rr2myWdZFYRsN8IhnRTUQlea3pRTlT/
   kes2zfQtBFjjq1G2EQdYxGlrasWsRtwFkMbLOYbY8TyEI1p3ko4pZmGcA
   jwUgX7N+lycjqNN0hRYO/TqpwpTrwZ3QzEs+4pt+E67yb6ZfTtpCDGG9Z
   hKcIHqssiGDU6TF8EwMQsa4SAX3fuNgXphg+mKpqjp8IWSfXp9VsU0Xud
   BAg0Utt47qE56LparjtW+HETj3AxMDC5Y+KZpBnFBWGpWVij0j+qG2NcO
   A==;
X-CSE-ConnectionGUID: vg9uI/krTmqvFssL8D4aFA==
X-CSE-MsgGUID: RU32GHzaRrKShMYiY8I4Ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73545037"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73545037"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
X-CSE-ConnectionGUID: JbREEryDRQWFXWmRPcn5eg==
X-CSE-MsgGUID: PHjZHtpCTuuulGxUrxOgRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218120403"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
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
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 7/9] selftests/resctrl: Remove requirement on cache miss rate
Date: Tue,  3 Mar 2026 16:19:36 -0800
Message-ID: <f8d8d034c7ae4cf942bb7f13df85a7aab5c1be3b.1772582958.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772582958.git.reinette.chatre@intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com>
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

