Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2294A328563
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830669; cv=none; b=AR1DP0FQcBVOo3oAymTGhyd6pfoIHgztgH9Gp1dDGcKwAATZ2qZ0tpm4kdpL7+XbV+bMQbMaeu0/b/LgmoHGon7A+IYTnzk6dVNNEn2UbIw57g5BLHNU8RFpDLZc0vS8aWBMU2TyumYAP+nNhVlHnOooWey2tG80LXMI756WN1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830669; c=relaxed/simple;
	bh=KUB65dBQVze38qJ3dYR+jdqsRXWXGNnAMDUO6kvsa2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy7Oc6FZ+2YYj/XtETU7ZArdNlged6FPGwOvLU4EdHo3ggkDzS0Ly+vyr2SjsPyYEOL3rMiWC6OqMCc7R7wdWGbHgpXw/xa3S0DHTzOWzrxnzpJYqXIl1EZSj8FYMFXl/8VsIBGUPpkgejj2ERM/53tYKLkt8s9SJ+DGxYok0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jaRBH7vH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jaRBH7vH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830668; x=1790366668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KUB65dBQVze38qJ3dYR+jdqsRXWXGNnAMDUO6kvsa2k=;
  b=jaRBH7vHa1QRcvvbIkki700t8t1w+Jrrgig9e1mTxud/1/GCjsIMamS9
   L8ZBa6VEao+9YfRyLFBAZ8QQm+AJ+0kwWTFYJ6LcC23qzINJvIj81Czbv
   lZQbpihRUsodg5Z+P6nesWRNixb5dwg5J3YCbC6c7OVcSfZOPG6gY9Lvn
   S2NGZTs4sHaPYLN6vwPZQWNAP7ovOumKvEcPy7hOdXntnr/9gFW4GrbkB
   2NPALb2mMDiWJjXYpk56eAeDzH4vi4cLc1pvXkwtGNfW2cO1/Oog1WPu9
   HIFtyAfX7b2RtETik0j6WP0yfR34zuuCiXacp+rkCQkcwPFoOV8lT9YP2
   w==;
X-CSE-ConnectionGUID: o5KJMWXtT3ebZDRHgoAlpQ==
X-CSE-MsgGUID: aqMUSZysR0Sj8b0PFtnaxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074391"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074391"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:16 -0700
X-CSE-ConnectionGUID: UWWSSLsCSNmGNZ3GpdMlNw==
X-CSE-MsgGUID: +riKI2dDQPKG5D81Yk9/MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003705"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:15 -0700
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
Subject: [PATCH v11 29/31] x86/resctrl: Add debugfs files to show telemetry aggregator status
Date: Thu, 25 Sep 2025 13:03:23 -0700
Message-ID: <20250925200328.64155-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 51 +++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index f6afe862b9de..f84935c57b67 100644
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
@@ -184,9 +188,50 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
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
+static void make_status_files(struct dentry *dir, struct event_group *e, int pkg,
+			      int instance, void *info_end)
+{
+	char name[64];
+
+	sprintf(name, "%s_pkg%d_agg%d_data_loss_count", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 24, &status_fops);
+
+	sprintf(name, "%s_pkg%d_agg%d_data_loss_timestamp", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 16, &status_fops);
+
+	sprintf(name, "%s_pkg%d_agg%d_last_update_timestamp", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info_end - 8, &status_fops);
+}
+
+static void create_debug_event_status_files(struct dentry *dir, struct event_group *e,
+					    struct pmt_feature_group *p)
+{
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
+	static struct dentry *infodir;
 	bool usable_events = false;
 
 	/* Disable feature if insufficient RMIDs */
@@ -226,6 +271,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 		resctrl_enable_mon_event(e->evts[j].id, true,
 					 e->evts[j].bin_bits, &e->evts[j]);
 
+	if (!infodir)
+		infodir = resctrl_debugfs_mon_info_arch_mkdir(r);
+
+	if (!IS_ERR_OR_NULL(infodir))
+		create_debug_event_status_files(infodir, e, p);
+
 	pr_info("%s %s monitoring detected\n", r->name, e->name);
 
 	return true;
-- 
2.51.0

