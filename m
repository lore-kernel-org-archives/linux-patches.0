Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1619E34AAEF
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496056; cv=none; b=UCG9XgK862N9z012Hde4v1lM1AS0RRC13HAR0/QaUW3zulezFgwZ7IKTWE6EsTEwXoX7zD4k52vEzb/rr3XGyWl/12YbOduN06qKzLgzBJKc46mNqgEqFMTuypGYQAZIY+ojP6Jvvy/rJf9FcakqXQeOYNroHgt+AErpgIRyUXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496056; c=relaxed/simple;
	bh=6J4t4ZqSvIOQlimIaNA+dRiQRrM8o8SuCHxndp0yuh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3Dgo6LgUWayYuY1Dp4xoVIaOxeOOUqH2Y6NQRMoqEefeESH+jK6TYlqoOkkgbiFoLKD587OZL0FxpgvwUmKYMgDBCLS14Z6KdsoPFGWua1XL3vAHYMJP68bce0MPLFfMxYAlg9vAL8/+cgh6PCvRtg9aBrV7cZD38pKwj0r8aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=loIcH8sc; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="loIcH8sc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496054; x=1788032054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6J4t4ZqSvIOQlimIaNA+dRiQRrM8o8SuCHxndp0yuh0=;
  b=loIcH8scbef8LWm/f8GnKcw+WMq7sjkPyEV/Pk5GD/NqB9nSyXLOHqLc
   SW+GROHMlZJzpSjqt6nEP1zzb8Xk3uQGY0ukFpnnbaJnbA2l+x7ExNHAu
   yYodjA7530Ti3hvt4a0+Jjs1jn367pwb4PjdsbjV2elYTsLMJwUl/ZX20
   QoNWoP2xmZn+5S4ENJRu0n2HsbsiFbElhljLOBO33fRgIZGfSQ4JkDTj6
   /umhnSuvsauw8cbTngCnknfl90EeXNZqIK97ZbT8KBJXzJ5uVy0WHj8XN
   UsSZEO3fWLg39N2l21MHrsONc1ZOLCoyEb9ZtiYWiHrASOMuPGDVdftce
   g==;
X-CSE-ConnectionGUID: xXBhvR/zTMK+nEr9K2nqlQ==
X-CSE-MsgGUID: Il/PeWXXQNuCSOLIHRw/bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625393"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625393"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:57 -0700
X-CSE-ConnectionGUID: 2H6N4oVAQQi8FdoucUqQNA==
X-CSE-MsgGUID: HZT1EiILQPmL2JIKag8sLg==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:57 -0700
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
Subject: [PATCH v9 30/31] x86/resctrl: Add debugfs files to show telemetry aggregator status
Date: Fri, 29 Aug 2025 12:33:42 -0700
Message-ID: <20250829193346.31565-31-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
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
the type of aggregator and its location. The suffix is one of the
three strings listed above. An example name is:

	energy_pkg0_agg2_data_loss_count

These files are removed along with all other debugfs entries by the
call to debugfs_remove_recursive() in resctrl_exit().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 48 +++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 35670ef07478..ee6418517324 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -13,6 +13,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
+#include <linux/debugfs.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
@@ -148,9 +149,50 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
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
@@ -194,6 +236,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 		resctrl_enable_mon_event(e->evts[j].id, true,
 					 e->evts[j].bin_bits, &e->evts[j]);
 
+	if (!infodir)
+		infodir = resctrl_debugfs_mon_info_arch_mkdir(r);
+
+	if (infodir)
+		create_debug_event_status_files(infodir, e, p);
+
 	pr_info("%s %s monitoring detected\n", r->name, e->name);
 
 	return true;
-- 
2.50.1

