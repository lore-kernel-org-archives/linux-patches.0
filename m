Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5918A2F2C5C
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956614; cv=none; b=USkz7kb123fb/10vNzmGcpQY/Egje6sNXHxTb9x+khiUXJ2IcaOeM+82PW4qTVFs750c7BYQivuKZNgHQR9MstFelbAewEDRiCgAgjAh9SwqNcPj4lL6wXR0ynKFja0g33ISeg7yJhhSqQqsqSxhzPpE8G9ZE1g0MRp+oRtOjc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956614; c=relaxed/simple;
	bh=jUnwPXX0D6xX5B28rZv1irDlFeIdA43bvGw3/BaWN9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mq/tBbZAFJ3O9gvwKRfFRSajMMTinGtgrb9RVqxAdt21RubZMRZDO9HAcp6NewBWLJUxBZZXKq2thFg5Z6FTBzYIciryuJ4YwER9aq+zX1rvswMMmvJ3VjATWUCVvpQAFlMvmidPlS4/BFMcpFVMXTIMlYyye8KN0Nqtf4SXJuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l56bnwL3; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l56bnwL3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956613; x=1782492613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jUnwPXX0D6xX5B28rZv1irDlFeIdA43bvGw3/BaWN9o=;
  b=l56bnwL3SJARZtN3LqnS3M8Nh6XKjx6Eg8FmPp2b0Fh/xDvaI4dUwYD8
   cPelqpBTjWYMHOU2yok3czA/D3O3SjadkH+DqtO1Re5iHrQshYrdo9MGA
   2YmsLH1iQ+MNPI88Vzw49cDdfPhhECwsjlS3p4Oejs1xqUNmy3jBap3uL
   8TyYHPLFkk1+u3NqNV3FSaJ2aXh+prcIWWoeH1C6hPjLcs1O43iWrj8XG
   ouHEvsE6oHuZYxkg4kubJqzurquab7GFda+iN2txHB4ZMw3Z2FOuU0Xtw
   jRqHM0lLFsq9DncOGDkTEKCozABHy+t6pYRuv//L9C8HV8Ng1ulExmKk9
   g==;
X-CSE-ConnectionGUID: yb3spm4QS2iyau0gxx2rEw==
X-CSE-MsgGUID: r2r7zv+tTu6GKVjE1HnkqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136552"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136552"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:05 -0700
X-CSE-ConnectionGUID: ni0ARSdCTd64cV+uEIPyeQ==
X-CSE-MsgGUID: YjL/FA7/S4OfOBwomw8tug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069362"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:03 -0700
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
Subject: [PATCH v6 29/30] x86/resctrl: Add debug info/PERF_PKG_MON/status files
Date: Thu, 26 Jun 2025 09:49:38 -0700
Message-ID: <20250626164941.106341-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
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

Create files in /sys/kernel/debug/resctrl/info/PERF_PKG_MON/arch/
to display the value of each of these status registers for each aggregator
in each enabled event group.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 56 +++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 090e7b35c3e2..422e3e126255 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -13,6 +13,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
+#include <linux/debugfs.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
@@ -275,6 +276,58 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
 	return false;
 }
 
+static ssize_t status_read(struct file *f, char __user *buf, size_t count, loff_t *off)
+{
+	void __iomem *info = (void __iomem *)f->f_inode->i_private;
+	char status[32];
+	int len;
+
+	len = sprintf(status, "%llu\n", readq(info));
+
+	return simple_read_from_buffer(buf, count, off, status, len);
+}
+
+static const struct file_operations status_fops = {
+	.read = status_read
+};
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
+static void create_debugfs_status_file(struct rdt_resource *r)
+{
+	struct event_group **eg;
+	struct dentry *infodir;
+
+	infodir = resctrl_debugfs_mon_info_arch_mkdir(r);
+	for (eg = &known_event_groups[0]; eg < &known_event_groups[NUM_KNOWN_GROUPS]; eg++) {
+		if (!(*eg)->pfg)
+			continue;
+		create_debug_event_status_files(infodir, *eg);
+	}
+}
+
 /*
  * Ask OOBMSM discovery driver for all the RMID based telemetry groups
  * that it supports.
@@ -300,6 +353,9 @@ bool intel_aet_get_events(void)
 		r->mon_capable = true;
 	}
 
+	if (ret1 || ret2)
+		create_debugfs_status_file(r);
+
 	return ret1 || ret2;
 }
 
-- 
2.49.0

