Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD8A32825E
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010517; cv=none; b=KhoFCSakXK6xeavpw5b8FfPcmXwDqHujjPMmk+33dRn+K3E7cDgxzZivoaLE3rVzNfb1eWf0UhILhlxJiyzaejmpdTsuFIXntZOR5fxHa0oWNHUgg94sMQl28Lczm5VFf1qCuQfFh1wfL0HdNCFlHiH0kTaRf5AHV2GVsUDAu+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010517; c=relaxed/simple;
	bh=uAnkQlLU3vWsmm5FFgB7ke1atYw5vOlVrS4bysI7COU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtYlRp5y+UznPO7Rq0wibVJfotKEE0CaaSdg3vk+DyhAmfD/iJGB+uKhrtEmNksNjuNiosCioEXcwPDKsC1VLoyaCeXbJd3++DQ4TxBxJkPT+7j6gmv3xMqWw9yqfdRQfi+Uyu6U9k30z2ES/Zzq8ITAB7KdpQ1Et7pgetP2qj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YQQVufS+; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YQQVufS+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010515; x=1795546515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uAnkQlLU3vWsmm5FFgB7ke1atYw5vOlVrS4bysI7COU=;
  b=YQQVufS+hnjTuGPoI6S8PlpqL1+pEekPCaR2rF8h1bU7qZny/zO06ajJ
   SDvWledz47xQr7Z7Cs0lQCGNqz7T2oduww/dDHZCY78hR0PBGgiEIQUDq
   SDcXh+22zjv2GR5VB0qXzDv5M0GhT2LLcPrTTaccs+eXGjP1eU0gvZZaT
   oQ+q3DPNE2JwQhp4aYjnXeEYVX5WIFADccPniBIvO2p2wYZOVYPkXvjZ4
   6BqgqSdoOPde2+Dv1cqtLiezqS5g84z5UrE2L3DzcwnP6jeRwD/2XdhQu
   0BUAtGxO2GyItsKPV85DfNQomXwhP+VbB4Lgzk3UVr/CapwafQOH+pUfq
   g==;
X-CSE-ConnectionGUID: 8s8TlaiPQN+3GbD1FbR+iQ==
X-CSE-MsgGUID: okxKKui8RFi1gxiaDWo3UA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636967"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636967"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:33 -0800
X-CSE-ConnectionGUID: SMQyxvLBSlqKAdfOrH0HZg==
X-CSE-MsgGUID: tMVxjBm+Q36KPBpM8mRICQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192225049"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:33 -0800
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
Subject: [PATCH v14 31/32] x86/resctrl: Add debugfs files to show telemetry aggregator status
Date: Mon, 24 Nov 2025 10:54:08 -0800
Message-ID: <20251124185412.24155-32-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
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
index 304e6e341905..96ee016f2012 100644
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
index 83d0bab4d6f5..5e0c0b1ff6a7 100644
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
@@ -232,6 +236,46 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
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
+	char name[80];
+
+	sprintf(name, "%s_0x%x_pkg%u_agg%d_data_loss_count", e->name, e->guid, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 24, &status_fops);
+
+	sprintf(name, "%s_0x%x_pkg%u_agg%d_data_loss_timestamp", e->name, e->guid, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 16, &status_fops);
+
+	sprintf(name, "%s_0x%x_pkg%u_agg%d_last_update_timestamp", e->name, e->guid, pkg, instance);
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
@@ -400,3 +444,19 @@ void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
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
2.51.1

