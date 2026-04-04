Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E112D593E
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 01:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267811; cv=none; b=U1hp0djfYesezwSdIvsLcSgEjfPjan/YdEzp5JxJekQjOBzsR9bEHERXyZy8h2pPNQdI+fhxqY/7RVCVxYPJg5sXxIYMRl6TVCEVQ2b6SO2ApzfkCJOfDR15WYFEDKj/lnIWiVjlC0LEuI2GgRJ5cQ/9svzh92/hBvwCBxysKAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267811; c=relaxed/simple;
	bh=CyQqMUHLIJLOniMbFZD78eS2kKM4fFn2foPveBaayYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BUNCdBvN38TEx0YXArmaoMxBw+buW94HAEko3R2GzRRXlCQ4uOPSz6AqDhS9v59AYWG1DvW6VWqhqidhC6sRiB8E9ULKDP5q28V6BD0NWhcNYEuQpEo/CuePmtbWxypJ5R5hQohW4Z7hb//7nH5w4xYMLmslxDKgZbR0WtyI0L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TT6fKHSm; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TT6fKHSm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775267810; x=1806803810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CyQqMUHLIJLOniMbFZD78eS2kKM4fFn2foPveBaayYE=;
  b=TT6fKHSmSVvngQdROF2KTM2MkzwLnx0zVuI4hcg94/InSb0aBx0+ABSP
   L60grQUynMI+uZXr9QQhdjCbZVhsWrkZ+DNJ1FpZ79vxDSMVnXLg9zgzi
   e6EY7Ho+g52x2T23heRNtSyXiBZQ7DHUySvlSmq55/GLQ5Djm9HxLpOue
   dQIu4DPbjEoKcFioQ48LtsYIvJcgKQBI3iMasne8lAvBu8v6JBSZn+Qhl
   e7ZfKAsIBn4GBPRWzQ5We9+xy4zgULy0wAiV9k60NK5p/5CG/hqUAPIUb
   nnz6ngxb/1d4tTzCFFje1dbo7v/mtnACx99t4i9C4yhB0wZDqrHlBPAZy
   Q==;
X-CSE-ConnectionGUID: RGdsqe/iTeC4WdE0gpTLkQ==
X-CSE-MsgGUID: P+915CDYSV+/QRiN69iEBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76219369"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76219369"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:44 -0700
X-CSE-ConnectionGUID: hVAtZnmcT4GRzUf00XeD/w==
X-CSE-MsgGUID: JFmitjh2S6efCUVC5DnnRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224121549"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:19 -0700
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
Subject: [PATCH v4 09/10] selftests/resctrl: Simplify perf usage in CAT test
Date: Fri,  3 Apr 2026 18:56:08 -0700
Message-ID: <fb69325eba5031b735fa79effaaacd797c9c6040.1775266384.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775266384.git.reinette.chatre@intel.com>
References: <cover.1775266384.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Tested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
Changes since v2:
- Add Chen Yu's tag.

Changes since v3:
- Add Ilpo's RB tag.
---
 tools/testing/selftests/resctrl/cache.c    | 17 +++++------------
 tools/testing/selftests/resctrl/cat_test.c |  4 +---
 tools/testing/selftests/resctrl/resctrl.h  | 11 +----------
 3 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cache.c b/tools/testing/selftests/resctrl/cache.c
index bef71b6feacc..df9bea584a2d 100644
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
index 3bad2d80c09b..175101022bf3 100644
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
 int minimize_l2_occupancy(const struct resctrl_test *test,
 			  const struct user_params *uparams,
-- 
2.50.1

