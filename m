Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122732E612A
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936274; cv=none; b=aJsudOSFu6bOaCTpyEZ4d0k/SfcBe9JdR/AhKN+hYB8EhHMGkwTcmrxhyNIW9bJNKucm5mOC3c2MJNGUO0qIhekGvhpje/WcAnsk69WuGjyTGq74kxYQOItdw5DLCa9Fgr2j9bLM986iEWiXBRWKsrtyCT2uH5w2gT+q4hveoiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936274; c=relaxed/simple;
	bh=47HI7bCkBNvQJ+DtUST6W3uW4FMOR3SyHta8tGZ5LJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7vYFyq9bKyrb3yr90coa86kQx1qNX9RsXvOIQl31LpamH6Z7V+BswjbtPgsHbKtela8uL+o2fe5VtUu4YtRsoLqRMGGTdnKn8IH18RCBkWSNwIU4zSd4W0zXO4AKMqmNU38TTRNRMEqwDBQT724CKIsT6Fka18+XNVGoN6yN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y3jyZmKB; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y3jyZmKB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936272; x=1786472272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=47HI7bCkBNvQJ+DtUST6W3uW4FMOR3SyHta8tGZ5LJM=;
  b=Y3jyZmKB2bm6AKQktlzQy3rUU2i1W0rYnNVAYiKhLY+aDgU0lm/H4Ghu
   graXKkG/ncZqgrq99X3yt0S7iRo5kvHpKj9R3VepK/FwuQj0BmwRtEbXa
   ekny4R/+AgNQHA4LdgJ5VHkFB0Q0EIhmqq7iFUDh8E4sQ8tTCdA62WQZi
   vbB0YPOp9OiaTKMx0g4TjxbEhUbSxomIHg/aYwA25vJKgZFuavaZ85Z7e
   PGYz0MB1JEXcq8rfowDuiW/wZu25xsaOleX/hQgHJDSMUbCDIldRKBi6F
   PqL2ezVQ97D6L/9HV3v0oKONCxXcXLBHtXHqv7A9cJLk/e5K4AnB/beyZ
   Q==;
X-CSE-ConnectionGUID: Sg8N/E5YSkaOokL/kVdv3g==
X-CSE-MsgGUID: tqy9NKu0SXyfY1wgWv3qFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277585"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277585"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:28 -0700
X-CSE-ConnectionGUID: VB9MA2rvSBGOEPbA8oYohw==
X-CSE-MsgGUID: 4+yvT43TR0qx8FG1fov7pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825717"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
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
Subject: [PATCH v8 31/32] x86/resctrl: Add debugfs files to show telemetry aggregator status
Date: Mon, 11 Aug 2025 11:17:05 -0700
Message-ID: <20250811181709.6241-32-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
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
index 4afc99e74cef..ff70f2b18165 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -13,6 +13,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
+#include <linux/debugfs.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
@@ -299,6 +300,55 @@ static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **ev
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
@@ -314,6 +364,9 @@ bool intel_aet_get_events(void)
 			       known_perf_event_groups,
 			       ARRAY_SIZE(known_perf_event_groups));
 
+	if (ret1 || ret2)
+		create_debugfs_status_file();
+
 	return ret1 || ret2;
 }
 
-- 
2.50.1

