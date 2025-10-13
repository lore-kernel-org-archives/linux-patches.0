Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818E230F524
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394864; cv=none; b=IJh01Atxs8wH2Ntfw1K+FmJnEuGQ4p4s5Wa8uSuQQb4uE5+MumbH6sjrwGShlgjsoGD5JFZW9NGw2znRGUjpqFU/OBk9kMfhc4QUwR1ecelk8N/uvgOf3+bX+/+Qc9r84Ab9yF1zX4sxc6SNFVcsy7qgiSzboS6NgeEPyzfctDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394864; c=relaxed/simple;
	bh=qiylo3Pj0+5Qg2JphvKyg3NBjflTZC1R7ys+XbHnNQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiNlTCbP2IC1J7MB7O1Pr0cC4oT+sfUagJPUNvX+popUQD17HyOY0DmmUpmq8pf4i2jg3NVcSWlAV9hP1m49UbWvPcisMIWOR4z+FYXGwjERFGnlpIe5QVyH5F7jFLBw557+hJTHsMY2yPI287Tbf48692atUYi1+LZKeLYlzLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SqFKcleN; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SqFKcleN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394861; x=1791930861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qiylo3Pj0+5Qg2JphvKyg3NBjflTZC1R7ys+XbHnNQg=;
  b=SqFKcleNB7ziu8AB8ZZ2Z6UvdX5IR+/fURWZkiFGoYTaA1fWij2XxiV7
   WykctElUriyiE7p+ayK6V67HFsLVxdQV+XP9tTvTlA/dDTtUEyeVBR1Xj
   blkI1hCRAlngK2UCUx0NnGMGNFhDdh85fIXkyL0DNcgfPw/er8ZsosEd9
   8afbC1JStElbkhN6mtap4qhi19+POFdvnm8HyesWwId9VVFL703OKUsDW
   AD/CtzeKQYYslB66yn2ZKl06HYu6eawcH7z4Rnx8wMs2w+OwcrPGB8gi3
   J+joanUBP2HJmA2+UovLOTDz+qT8Q7I5FfoIu74FUYVZDSNdK5AnYJBPO
   A==;
X-CSE-ConnectionGUID: q9kclKv1SUCJbmHVc3Bv1w==
X-CSE-MsgGUID: MYSO/oShTMi7AkexOKYPAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168967"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168967"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:04 -0700
X-CSE-ConnectionGUID: J3QhgdnYQ1moq/pduQcXTg==
X-CSE-MsgGUID: 2gkHVdaiRPClq1X63UqCIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145345"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:04 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v12 30/31] x86/resctrl: Add debugfs files to show telemetry aggregator status
Date: Mon, 13 Oct 2025 15:33:44 -0700
Message-ID: <20251013223348.103390-31-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each telemetry aggregator provides three status registers at the top
end of MMIO space after all the per-RMID per-event counters:

  data_loss_count: This counts the number of times that this aggregator
  failed to accumulate a counter value supplied by a CPU core.

  data_loss_timestamp: This is a "timestamp" from a free running
  25MHz uncore timer indicating when the most recent data loss occurred.

  last_update_timestamp: Another 25MHz timestamp indicating when the
  most recent counter update was successfully applied.

Create files in /sys/kernel/debug/resctrl/info/PERF_PKG_MON/x86_64/
to display the value of each of these status registers for each aggregator
in each enabled event group. The prefix for each file name describes
the type of aggregator, which package it is located on, and an opaque
instance number to provide a unique file name when there are multiple
aggregators on a package.

The suffix is one of the three strings listed above. An example name is:

	energy_pkg0_agg2_data_loss_count

These files are removed along with all other debugfs entries by the
call to debugfs_remove_recursive() in resctrl_exit().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  2 +
 arch/x86/kernel/cpu/resctrl/core.c      |  2 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 62 +++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index cea76f88422c..8d4bdae735e4 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -236,6 +236,7 @@ int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id evtid,
 			 void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
+void intel_aet_add_debugfs(void);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
@@ -247,6 +248,7 @@ static inline int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_i
 
 static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 					      struct list_head *add_pos) { }
+static inline void intel_aet_add_debugfs(void) { }
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2d8c20819ec3..94ca7902420b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -783,6 +783,8 @@ void resctrl_arch_pre_mount(void)
 		domain_add_cpu_mon(cpu, r);
 	mutex_unlock(&domain_list_lock);
 	cpus_read_unlock();
+
+	intel_aet_add_debugfs();
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index bc0a4d84a4e0..0834538f7ddf 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -18,8 +18,11 @@
 #include <linux/container_of.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/debugfs.h>
+#include <linux/dcache.h>
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 #include <linux/gfp_types.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
@@ -33,6 +36,7 @@
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
 #include <linux/slab.h>
+#include <linux/sprintf.h>
 #include <linux/stddef.h>
 #include <linux/topology.h>
 #include <linux/types.h>
@@ -188,6 +192,46 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
 	return ret;
 }
 
+static int status_read(void *priv, u64 *val)
+{
+	void __iomem *info = (void __iomem *)priv;
+
+	*val = readq(info);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(status_fops, status_read, NULL, "%llu\n");
+
+static void make_status_files(struct dentry *dir, struct event_group *e, u8 pkg,
+			      int instance, void *info_end)
+{
+	char name[64];
+
+	sprintf(name, "%s_pkg%u_agg%d_data_loss_count", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 24, &status_fops);
+
+	sprintf(name, "%s_pkg%u_agg%d_data_loss_timestamp", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 16, &status_fops);
+
+	sprintf(name, "%s_pkg%u_agg%d_last_update_timestamp", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 8, &status_fops);
+}
+
+static void create_debug_event_status_files(struct dentry *dir, struct event_group *e)
+{
+	struct pmt_feature_group *p = e->pfg;
+	void *info_end;
+
+	for (int i = 0; i < p->count; i++) {
+		if (!p->regions[i].addr)
+			continue;
+		info_end = (void __force *)p->regions[i].addr + e->mmio_size;
+		make_status_files(dir, e, p->regions[i].plat_info.package_id,
+				  i, info_end);
+	}
+}
+
 static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
@@ -359,3 +403,21 @@ void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 		kfree(d);
 	}
 }
+
+void intel_aet_add_debugfs(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	struct event_group **peg;
+	struct dentry *infodir;
+
+	infodir = resctrl_debugfs_mon_info_arch_mkdir(r);
+
+	if (IS_ERR_OR_NULL(infodir))
+		return;
+
+	for_each_enabled_event_group(peg, known_energy_event_groups)
+		create_debug_event_status_files(infodir, *peg);
+	for_each_enabled_event_group(peg, known_perf_event_groups)
+		create_debug_event_status_files(infodir, *peg);
+
+}
-- 
2.51.0

