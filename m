Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85832459C7
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278054; cv=none; b=LY69qtGlWmEOTVhbkliSc+m8FtsDCXRXDdU3Q5dcuV7D4sEdytFGCgegJLn9+gxfdYLfL9Q1p8RQelzcNfCrsbaMLxaYadNXNJkxbtn/NTVmHQpNja+ZJClhYVTjvUIvpz7ACeQwliB8LrF7fUooY5+rlRnw8ry1ovUZE2HqecY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278054; c=relaxed/simple;
	bh=gLar5ZRKiMAaC3yYXa32e6XFMtB7dKx3x45Z6LOkJR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twE9mUPbMny+CZOWMHnF0q6OadJbtVtvNoVe24FOtRjRYSo4GOBwrUv7UEs0mK9Rf2KZ4U00ldKe4oJiz/UNOR0++ki9IxdRnTupJPIalKNyhEQqKY++49ceFHecf6KSD/JgSqIMUVbQE1X1FvjwakoExSC9WGW+9MOQFo+Gizc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=McImdprQ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="McImdprQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278053; x=1783814053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gLar5ZRKiMAaC3yYXa32e6XFMtB7dKx3x45Z6LOkJR4=;
  b=McImdprQE09IIF8xIxuw/CZRcBrS0BnrdQ8Cu9ijOFqPXo3WxPfbCwCl
   EzGjXbH0LRrtypkmEGcxykVH//xGmcJuB8inRCVM3v0F1S2pJE4c5z/yS
   uFsF18/zinZy1FWv+L3MDhLx27VfWBckPwRawtzMQ+G9evvw0+V2+fExU
   oZHys13q5pqNKnhKFoo8UP0u18uN7VnwoxMq1Kq0NZbxC5h2OxmITBkRp
   /Oe0OSlvQyJM884nnDZCa53BnE/GR/tBzovJxTzeZufYHNW7UdXwl4GFX
   IoLCZiAhMiPTBb+8STWWfcSurKMt9V6kLqYbCUJTQokBZiP8xScqaAGEo
   Q==;
X-CSE-ConnectionGUID: 63VJ+fyUTKaMWe1PSyLitA==
X-CSE-MsgGUID: y3rsMo3bRu6Amll5lPirGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292822"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292822"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:09 -0700
X-CSE-ConnectionGUID: PM5aAW9CQEWX6loXqa8/rQ==
X-CSE-MsgGUID: YQXFY8QpS+ypEAJpTfsJgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902178"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 30/31] x86/resctrl: Add debugfs files to show telemetry aggregator status
Date: Fri, 11 Jul 2025 16:53:37 -0700
Message-ID: <20250711235341.113933-31-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each telemetry aggregator provides three status registers at the top
end of MMIO space after all the per-RMID per-event counters:

  agg_data_loss_count: This counts the number of times that this aggregator
  failed to accumulate a counter value supplied by a CPU core.

  agg_data_loss_timestamp: This is a "timestamp" from a free running
  25MHz uncore timer indicating when the most recent data loss occurred.

  last_update_timestamp: Another 25MHz timestamp indicating when the
  most recent counter update was successfully applied.

Create files in /sys/kernel/debug/resctrl/info/PERF_PKG_MON/x86_64/
to display the value of each of these status registers for each aggregator
in each enabled event group.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 +++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index ea7a782c1661..80c0dbe33150 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -13,6 +13,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
+#include <linux/debugfs.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
@@ -305,6 +306,55 @@ static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **ev
 	return false;
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
+static void make_status_files(struct dentry *dir, struct event_group *e, int pkg, int instance)
+{
+	void *info = (void __force *)e->pkginfo[pkg]->addrs[instance] + e->mmio_size;
+	char name[64];
+
+	sprintf(name, "%s_pkg%d_agg%d_data_loss_count", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info - 24, &status_fops);
+
+	sprintf(name, "%s_pkg%d_agg%d_data_loss_timestamp", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info - 16, &status_fops);
+
+	sprintf(name, "%s_pkg%d_agg%d_last_update_timestamp", e->name, pkg, instance);
+	debugfs_create_file(name, 0400, dir, info - 8, &status_fops);
+}
+
+static void create_debug_event_status_files(struct dentry *dir, struct event_group *e)
+{
+	int num_pkgs = topology_max_packages();
+
+	for (int i = 0; i < num_pkgs; i++)
+		for (int j = 0; j < e->pkginfo[i]->num_regions; j++)
+			make_status_files(dir, e, i, j);
+}
+
+static void create_debugfs_status_file(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	struct event_group *evg;
+	struct dentry *infodir;
+
+	infodir = resctrl_debugfs_mon_info_arch_mkdir(r);
+	if (!infodir)
+		return;
+
+	list_for_each_entry(evg, &active_event_groups, list)
+		create_debug_event_status_files(infodir, evg);
+}
+
 /*
  * Ask OOBMSM discovery driver for all the RMID based telemetry groups
  * that it supports.
@@ -318,6 +368,9 @@ bool intel_aet_get_events(void)
 	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM,
 			       known_perf_event_groups, NUM_KNOWN_PERF_GROUPS);
 
+	if (ret1 || ret2)
+		create_debugfs_status_file();
+
 	return ret1 || ret2;
 }
 
-- 
2.50.0

