Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7946F2EBDFA
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 00:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583593; cv=none; b=p+/mIpFmbmQOz1girHGSA2cX8NotWddzImz7f98jx9Hr0D8HHtKkimpxMVk2zuHnHU8TQF3EyMQnzCaE70Zl4dNmBP/RzDk2HbRul8+tqmxT6ZY1My4AhAWPj0brCwDd8/fy/xMqW5sX91cFapArSctTkewvkihmpcFYwtvs1Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583593; c=relaxed/simple;
	bh=cBIUYkcTaLcFGaaS2gjR42fcrLXFw9Kcvy5bKM/KiC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkyzEY47u4g3tBVj9SeF4dyghiSff96XDvi/l5ASOUPHjOHOfW9OkbKNEFwenkzBaGqUg7sm6qBqpgibmNEU2NrOhD82CM7i5oH4RXMqhn1GheOpz8MItllL0taVmFd1PbuWInjd9TN97BuzNHw23zLUfZu3Ibv18bAYc2Ms6rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pin5FH6r; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pin5FH6r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772583592; x=1804119592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cBIUYkcTaLcFGaaS2gjR42fcrLXFw9Kcvy5bKM/KiC8=;
  b=Pin5FH6rB60bBvnMEXZzOKgifoMmJ3JmxB475EEpMACazNzLmKXdlwuu
   yaRbBTkLYCyqlZX7sPwAfAcRFFwo4d2OVZWTUewqIEZJbgNo067iX3lh9
   b6Op2nETro25HFNdpEG9MFnET8Idh8VjsaHel8SsLQy1Ri7ZbDMJMydKL
   TlU73s21ybpepXLcEDx+P0fdWYR74eASKwrULp1i+jkkRn0G+QHaC3C1Q
   yn8vnJXkkWyJnyWXAT5qrXIX73D6VBcqw+aHO8XP5nylzsdX+DU+YOsqF
   eLF/VdxrOLecoVEteqpNZxqWGC24yDBgrmtADgqBdo5KE1/WZejf5ppg4
   Q==;
X-CSE-ConnectionGUID: MUqnU3i2S5issAMhUbGtow==
X-CSE-MsgGUID: JQ3SsNypT5O3LJWG64Jhyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73545044"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73545044"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
X-CSE-ConnectionGUID: +N+uQ2N4SXSYV95RFeDglA==
X-CSE-MsgGUID: 11b0snK6QLWNaiYU1Kb7+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218120407"
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
Subject: [PATCH v2 8/9] selftests/resctrl: Simplify perf usage in CAT test
Date: Tue,  3 Mar 2026 16:19:37 -0800
Message-ID: <42ea6df7c8c8aceecdd1037f09b13b4cc34521f6.1772582958.git.reinette.chatre@intel.com>
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

The CAT test relies on the PERF_COUNT_HW_CACHE_MISSES event to determine if
modifying a cache portion size is successful. This event is configured to
report the data as part of an event group, but no other events are added to
the group.

Remove the unnecessary PERF_FORMAT_GROUP format setting. This eliminates
the need for struct perf_event_read and results in read() of the associated
file descriptor to return just one value associated with the
PERF_COUNT_HW_CACHE_MISSES event of interest.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/resctrl/cache.c    | 17 +++++------------
 tools/testing/selftests/resctrl/cat_test.c |  4 +---
 tools/testing/selftests/resctrl/resctrl.h  | 11 +----------
 3 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cache.c b/tools/testing/selftests/resctrl/cache.c
index 1ff1104e6575..03313a5ff905 100644
--- a/tools/testing/selftests/resctrl/cache.c
+++ b/tools/testing/selftests/resctrl/cache.c
@@ -10,7 +10,6 @@ void perf_event_attr_initialize(struct perf_event_attr *pea, __u64 config)
 	memset(pea, 0, sizeof(*pea));
 	pea->type = PERF_TYPE_HARDWARE;
 	pea->size = sizeof(*pea);
-	pea->read_format = PERF_FORMAT_GROUP;
 	pea->exclude_kernel = 1;
 	pea->exclude_hv = 1;
 	pea->exclude_idle = 1;
@@ -37,19 +36,13 @@ int perf_event_reset_enable(int pe_fd)
 	return 0;
 }
 
-void perf_event_initialize_read_format(struct perf_event_read *pe_read)
-{
-	memset(pe_read, 0, sizeof(*pe_read));
-	pe_read->nr = 1;
-}
-
 int perf_open(struct perf_event_attr *pea, pid_t pid, int cpu_no)
 {
 	int pe_fd;
 
 	pe_fd = perf_event_open(pea, pid, cpu_no, -1, PERF_FLAG_FD_CLOEXEC);
 	if (pe_fd == -1) {
-		ksft_perror("Error opening leader");
+		ksft_perror("Unable to set up performance monitoring");
 		return -1;
 	}
 
@@ -132,9 +125,9 @@ static int print_results_cache(const char *filename, pid_t bm_pid, __u64 llc_val
  *
  * Return: =0 on success. <0 on failure.
  */
-int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
-		       const char *filename, pid_t bm_pid)
+int perf_event_measure(int pe_fd, const char *filename, pid_t bm_pid)
 {
+	__u64 value;
 	int ret;
 
 	/* Stop counters after one span to get miss rate */
@@ -142,13 +135,13 @@ int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
 	if (ret < 0)
 		return ret;
 
-	ret = read(pe_fd, pe_read, sizeof(*pe_read));
+	ret = read(pe_fd, &value, sizeof(value));
 	if (ret == -1) {
 		ksft_perror("Could not get perf value");
 		return -1;
 	}
 
-	return print_results_cache(filename, bm_pid, pe_read->values[0].value);
+	return print_results_cache(filename, bm_pid, value);
 }
 
 /*
diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index 8bc47f06679a..6aac03147d41 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -135,7 +135,6 @@ static int cat_test(const struct resctrl_test *test,
 		    struct resctrl_val_param *param,
 		    size_t span, unsigned long current_mask)
 {
-	struct perf_event_read pe_read;
 	struct perf_event_attr pea;
 	cpu_set_t old_affinity;
 	unsigned char *buf;
@@ -159,7 +158,6 @@ static int cat_test(const struct resctrl_test *test,
 		goto reset_affinity;
 
 	perf_event_attr_initialize(&pea, PERF_COUNT_HW_CACHE_MISSES);
-	perf_event_initialize_read_format(&pe_read);
 	pe_fd = perf_open(&pea, bm_pid, uparams->cpu);
 	if (pe_fd < 0) {
 		ret = -1;
@@ -192,7 +190,7 @@ static int cat_test(const struct resctrl_test *test,
 
 			fill_cache_read(buf, span, true);
 
-			ret = perf_event_measure(pe_fd, &pe_read, param->filename, bm_pid);
+			ret = perf_event_measure(pe_fd, param->filename, bm_pid);
 			if (ret)
 				goto free_buf;
 		}
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 861bf25f2f28..e04b313dd7f7 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -148,13 +148,6 @@ struct resctrl_val_param {
 	struct fill_buf_param	*fill_buf;
 };
 
-struct perf_event_read {
-	__u64 nr;			/* The number of events */
-	struct {
-		__u64 value;		/* The value of the event */
-	} values[2];
-};
-
 /*
  * Memory location that consumes values compiler must not optimize away.
  * Volatile ensures writes to this location cannot be optimized away by
@@ -210,11 +203,9 @@ unsigned int count_bits(unsigned long n);
 int snc_kernel_support(void);
 
 void perf_event_attr_initialize(struct perf_event_attr *pea, __u64 config);
-void perf_event_initialize_read_format(struct perf_event_read *pe_read);
 int perf_open(struct perf_event_attr *pea, pid_t pid, int cpu_no);
 int perf_event_reset_enable(int pe_fd);
-int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
-		       const char *filename, pid_t bm_pid);
+int perf_event_measure(int pe_fd, const char *filename, pid_t bm_pid);
 int measure_llc_resctrl(const char *filename, pid_t bm_pid);
 void show_cache_info(int no_of_bits, __u64 avg_llc_val, size_t cache_span, bool lines);
 
-- 
2.50.1

