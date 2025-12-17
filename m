Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B695350A35
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992167; cv=none; b=M254XBATBLdT6Yq9T2PoAPFCvxDONdxu8VBJg0uFPVB5XXsUfNpcKZ2wAHnNgWCnK3ooB2SmiqzCrcGUm1y8U4CF7ZYSsTgpV0I6nUV1kvWVKOQiWrzyhbaY1ltXLYxxp+XdjYrjCZzkH+D0qNOofBclJlyDuRmufrdN8BXX11c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992167; c=relaxed/simple;
	bh=jPHwp4YKJEadHkcqYXPD1A4NHC1lj2kucKhD7xZrTVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIP10VVO0bSpRIrO7idVgb3MYQpgZIL/gWS4yZcFTbj2u6hMxySjiKuuZ32jsHZ5bTrjwoJrqELL9Tv+FvrHHypmyD6pCryVLINm0rP+bpoyTTJLEIehdb4aJypz2UhOKJiZ13PYKDCFXiEVv9O1LiuIbCr8FPIu6AJxhsFDFJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FDGs1aI7; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FDGs1aI7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992155; x=1797528155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jPHwp4YKJEadHkcqYXPD1A4NHC1lj2kucKhD7xZrTVE=;
  b=FDGs1aI7ZhtK2eqNH6E9zI47bJjULflNHcbrwiXNp666jpKpuiuUmuMA
   PslUwC3cPtR3VfaUIVGYwGdZI4qswi85pps3OOhkwazMAllKCSfDnWMvy
   m8ue8G61LTz2hBG8yoa59T1PR7O/SBZuvEGTcwNDjZxeh+rh5AiM5IAUf
   llxu0ARbptZ1ZiaQPSDJUGm4RPzu9Ti77DNDIEFQscm/Fa+yMvYh79RF1
   O3AsdtDgHZuZi1GR132P8CX3Jrjd9DGf/pu+j52Qa8mI1Yc19bdFUzO/B
   7teVVu8u4oIhdsvB9kR94ojlZ0ze5zh/VJfgf72/VUqA94jIY94bDU4zD
   Q==;
X-CSE-ConnectionGUID: 3PJe8+WYRe+cZJkjR/hHwQ==
X-CSE-MsgGUID: kQNEO/OlSXKw9c0UJNALrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594861"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594861"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:38 -0800
X-CSE-ConnectionGUID: fBlg96yFRzSL8ZlXQMiAdw==
X-CSE-MsgGUID: Fg50ZT+nRhGVGFdbDI3SLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748285"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:37 -0800
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
Subject: [PATCH v17 31/32] x86/resctrl: Add debugfs files to show telemetry aggregator status
Date: Wed, 17 Dec 2025 09:21:18 -0800
Message-ID: <20251217172121.12030-32-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each telemetry aggregator provides three status registers at the top end of
MMIO space after all the per-RMID per-event counters:

  data_loss_count: This counts the number of times that this aggregator
  failed to accumulate a counter value supplied by a CPU core.

  data_loss_timestamp: This is a "timestamp" from a free running
  25MHz uncore timer indicating when the most recent data loss occurred.

  last_update_timestamp: Another 25MHz timestamp indicating when the
  most recent counter update was successfully applied.

Create files in /sys/kernel/debug/resctrl/info/PERF_PKG_MON/x86_64/ to display
the value of each of these status registers for each aggregator in each enabled
event group. The prefix for each file name describes the type of aggregator,
the guid, which package it is located on, and an opaque instance number to
provide a unique file name when there are multiple aggregators on a package.

The suffix is one of the three strings listed above. An example name is:

	energy_0x26696143_pkg0_agg2_data_loss_count

These files are removed along with all other debugfs entries by the call to
debugfs_remove_recursive() in resctrl_exit().

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  2 +
 arch/x86/kernel/cpu/resctrl/core.c      |  2 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 60 +++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index df09091f7c6c..e538174fe193 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -236,6 +236,7 @@ void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
+void intel_aet_add_debugfs(void);
 bool intel_aet_option(bool force_off, char *tok);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
@@ -247,6 +248,7 @@ static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64
 
 static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 					      struct list_head *add_pos) { }
+static inline void intel_aet_add_debugfs(void) { }
 static inline bool intel_aet_option(bool force_off, char *tok) { return false; }
 #endif
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 829633bc54e5..62e96aad060d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -788,6 +788,8 @@ void resctrl_arch_pre_mount(void)
 		domain_add_cpu_mon(cpu, r);
 	mutex_unlock(&domain_list_lock);
 	cpus_read_unlock();
+
+	intel_aet_add_debugfs();
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 3ee51b05a297..ba5a64a74bd6 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -15,8 +15,11 @@
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/cpumask.h>
+#include <linux/debugfs.h>
+#include <linux/dcache.h>
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 #include <linux/gfp_types.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
@@ -29,6 +32,7 @@
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
 #include <linux/slab.h>
+#include <linux/sprintf.h>
 #include <linux/stddef.h>
 #include <linux/topology.h>
 #include <linux/types.h>
@@ -227,6 +231,46 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
 	return true;
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
+	char name[80];
+
+	sprintf(name, "%s_0x%x_pkg%u_agg%d_data_loss_count", e->pfname, e->guid, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 24, &status_fops);
+
+	sprintf(name, "%s_0x%x_pkg%u_agg%d_data_loss_timestamp", e->pfname, e->guid, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 16, &status_fops);
+
+	sprintf(name, "%s_0x%x_pkg%u_agg%d_last_update_timestamp", e->pfname, e->guid, pkg, instance);
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
@@ -411,3 +455,19 @@ void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
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
+	for_each_event_group(peg)
+		if ((*peg)->pfg)
+			create_debug_event_status_files(infodir, *peg);
+}
-- 
2.52.0

