Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C916A2356AB
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598991; cv=none; b=BRwYN2NPxZ7XAJS6rEqy/4HroSDNtfgErwxYow/doONuk2/9e+lhUQ3oYw27wBhDAtW/swWIq31PFl9t7oapcMBa9ADejnMJwf9MaQPoOM5j2SAwCKubNOy6bgpEeNy0hxj+3xjfxTCi2JSKS73VPfhzl96O3bb53RRzxq9kSqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598991; c=relaxed/simple;
	bh=BR6sWBYhLeThHSd8a037VGUJ8PncGE9yf9kQ19l3VcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg2CMVk8VaGdqBr/U9EGooJk7eHRgSL/ayquOMeGd5q2YSf5pHaXKV3o1x/Qfk8vDFckmomckY33of2JZ/CaRkaNJbbMGEQfwlFwC9yjpA6HZYMNQxaPxbQ+Q45esgF3Ked4pGdQIR3L2h5uSx51xiI5x4Xn5UTYflqgIkI/xoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AUzNKA5S; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AUzNKA5S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598989; x=1774134989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BR6sWBYhLeThHSd8a037VGUJ8PncGE9yf9kQ19l3VcM=;
  b=AUzNKA5S9N0YH3SwHnWPMVCtGj3G5QM6mUOIFrr6G0csGUZOFcgeHXIC
   AcWp4RGowRdDz8ws0ePNQsCj2EZsIntYcLuuR1dXtWYtp4wO2t5Ox9sKN
   1ozgPb1QqRBTPXOYTnXPQ+lgP7lPRDW8F8iY8U5P9b1TBQxHOtSYBSre5
   YMFPAnzOtDBiXcScnkfMHmon//FXvhGniP1q1U2qPxiTQUUG5/AA8WZDX
   PqMS8kvEEQc+SVZrz3MYqVTfcmeD6zI2hHIRVSEJMc37/5Ntmpf7uT/+/
   E7PAG+cCbSecRCKCNDcnDq7KLyI2rppI5MF0v69MvKrqFeWkWYKa5SvPc
   Q==;
X-CSE-ConnectionGUID: 8NHtIcqwQxmvtYiO7/41qA==
X-CSE-MsgGUID: ZuNQ09ijR4ecuHC6Lmgiig==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604634"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604634"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:24 -0700
X-CSE-ConnectionGUID: rThT7eakTeGuDAPmGIyFIA==
X-CSE-MsgGUID: qtszo6s7SHqERPEChTqo0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354327"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 13/16] x86/resctrl: Add code to display core telemetry events
Date: Fri, 21 Mar 2025 16:16:03 -0700
Message-ID: <20250321231609.57418-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These can be read from any CPU. Rely on the smp_call*() functions
picking the current CPU when given a free choice from cpu_online_mask.

There may be multiple devices tracking each package, so scan all of them
and add up counters.

Output format depends on the data type. Either a 63 bit integer, or a
fixed point decimal.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  3 ++
 fs/resctrl/internal.h                   |  4 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 +++++++++++++++++++++++++
 fs/resctrl/ctrlmondata.c                | 23 ++++++++++-
 fs/resctrl/monitor.c                    | 23 +++++++++--
 5 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 999e0802a26e..e900764393f4 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -532,8 +532,11 @@ void resctrl_exit(void);
 
 #ifdef CONFIG_INTEL_AET_RESCTRL
 void rdt_get_intel_aet_mount(void);
+bool intel_aet_read_event(int domid, int rmid, int evtid, u64 *val, bool *fptype);
 #else
 static inline void rdt_get_intel_aet_mount(void) { }
+static inline bool intel_aet_read_event(int domid, int rmid, int evtid, u64 *val,
+					bool *fptype) { return false; }
 #endif
 
 #endif /* _RESCTRL_H */
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index f5a698b49e97..4d65a781034e 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -98,6 +98,7 @@ struct mon_data {
  *	   domains in @r sharing L3 @ci.id
  * @evtid: Which monitor event to read.
  * @first: Initialize MBM counter when true.
+ * @fptype:If true indicates @val is in 46.18 fixed point format
  * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
  * @val:   Returned value of event counter. If @rgrp is a parent resource group,
@@ -112,6 +113,7 @@ struct rmid_read {
 	struct rdt_mon_domain	*d;
 	unsigned int		evtid;
 	bool			first;
+	bool			fptype;
 	struct cacheinfo	*ci;
 	int			err;
 	u64			val;
@@ -343,7 +345,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first);
+		    const cpumask_t *cpumask, int evtid, int first);
 
 int resctrl_mon_resource_init(void);
 
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index bab8e4de26b3..41ebb2ee9b41 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -357,3 +357,56 @@ void rdt_get_intel_aet_mount(void)
 		r->mon_capable = false;
 	}
 }
+
+#define VALID_BIT	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Walk the array of telemetry groups on a specific package.
+ * Read and sum values for a specific counter (described by
+ * guid and offset).
+ * Return failure (~0x0ull) if any counter isn't valid.
+ */
+static u64 scan_pmt_devs(int package, int guid, int offset)
+{
+	u64 rval, val;
+	int ndev = 0;
+
+	rval = 0;
+
+	for (int i = 0; i < pkg_info[package].count; i++) {
+		if (pkg_info[package].regions[i].guid != guid)
+			continue;
+		ndev++;
+		val = readq(pkg_info[package].regions[i].addr + offset);
+
+		if (!(val & VALID_BIT))
+			return ~0ull;
+		rval += val & DATA_BITS;
+	}
+
+	return ndev ? rval : ~0ull;
+}
+
+/*
+ * Read counter for an event on a domain (summing all aggregators
+ * on the domain).
+ */
+bool intel_aet_read_event(int domid, int rmid, int evtid, u64 *val, bool *fptype)
+{
+	u64 evtcount;
+	int offset;
+
+	if (rmid >= EVT_NUM_RMIDS(evtid))
+		return false;
+
+	offset = rmid * EVT_STRIDE(evtid);
+	offset += EVT_OFFSET(evtid);
+	evtcount = scan_pmt_devs(domid, EVT_GUID(evtid), offset);
+	*fptype = evtid == PMT_EVENT_ENERGY || evtid == PMT_EVENT_ACTIVITY;
+
+	if (evtcount != ~0ull || *val == 0)
+		*val += evtcount;
+
+	return evtcount != ~0ull;
+}
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index d56b78450a99..5612f5f64574 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -548,7 +548,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first)
+		    const cpumask_t *cpumask, int evtid, int first)
 {
 	int cpu;
 
@@ -585,6 +585,21 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
 }
 
+#define NUM_FRAC_BITS	18
+#define FRAC_MASK	GENMASK(NUM_FRAC_BITS - 1, 0)
+
+static void show_fp_value(struct seq_file *m, u64 val)
+{
+	u64 frac;
+
+	frac = val & FRAC_MASK;
+	frac = frac * 1000000;
+	frac += 1ul << (NUM_FRAC_BITS - 1);
+	frac >>= NUM_FRAC_BITS;
+
+	seq_printf(m, "%llu.%06llu\n", val >> NUM_FRAC_BITS, frac);
+}
+
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
@@ -594,6 +609,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	u32 resid, evtid, domid;
 	struct rdtgroup *rdtgrp;
 	struct rdt_resource *r;
+	const cpumask_t *mask;
 	struct mon_data *md;
 	int ret = 0;
 
@@ -642,7 +658,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			goto out;
 		}
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
-		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
+		mask = (resid == RDT_RESOURCE_L3) ? &d->hdr.cpu_mask : cpu_online_mask;
+		mon_event_read(&rr, r, d, rdtgrp, mask, evtid, false);
 	}
 
 checkresult:
@@ -651,6 +668,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		seq_puts(m, "Error\n");
 	else if (rr.err == -EINVAL)
 		seq_puts(m, "Unavailable\n");
+	else if (rr.fptype)
+		show_fp_value(m, rr.val);
 	else
 		seq_printf(m, "%llu\n", rr.val);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 3fe21dcf0fde..f4049ae5344c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -447,6 +447,24 @@ static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	m->prev_bw = cur_bw;
 }
 
+static int mon_event_count_one_group(int closid, int rmid, struct rmid_read *rr)
+{
+	bool ret;
+
+	switch (rr->r->rid) {
+	case RDT_RESOURCE_L3:
+		rr->fptype = false;
+		return __mon_event_count(closid, rmid, rr);
+	case RDT_RESOURCE_INTEL_AET:
+		ret = intel_aet_read_event(rr->d->hdr.id, rmid, rr->evtid, &rr->val, &rr->fptype);
+		if (!ret)
+			rr->err = -EINVAL;
+		return ret ? 0 : -EINVAL;
+	}
+
+	return -EINVAL;
+}
+
 /*
  * This is scheduled by mon_event_read() to read the CQM/MBM counters
  * on a domain.
@@ -460,7 +478,7 @@ void mon_event_count(void *info)
 
 	rdtgrp = rr->rgrp;
 
-	ret = __mon_event_count(rdtgrp->closid, rdtgrp->mon.rmid, rr);
+	ret = mon_event_count_one_group(rdtgrp->closid, rdtgrp->mon.rmid, rr);
 
 	/*
 	 * For Ctrl groups read data from child monitor groups and
@@ -471,8 +489,7 @@ void mon_event_count(void *info)
 
 	if (rdtgrp->type == RDTCTRL_GROUP) {
 		list_for_each_entry(entry, head, mon.crdtgrp_list) {
-			if (__mon_event_count(entry->closid, entry->mon.rmid,
-					      rr) == 0)
+			if (mon_event_count_one_group(entry->closid, entry->mon.rmid, rr) == 0)
 				ret = 0;
 		}
 	}
-- 
2.48.1

