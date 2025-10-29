Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A8934BA33
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754906; cv=none; b=Hcc2Ad/WQoBrkm1eEQTvWmql4hI6QMm3+aLR50fJbjy4m0+AycFyPQyKBi7qyEZED7knuiG0regpm/JmRbDkTVqmAXKB+3R8BVjQGKaLGVO7E5XOSnKQNWjrEmlNEvlBWjOoH3KvNV1yEccK0O+Q810lVIHLk1SUq/97Fbnr8rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754906; c=relaxed/simple;
	bh=S04DLKChqtxVIfbayGN7vRQzulAjFbTzMk1BBDVs9H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCHcnn7ypQEX124tnYPrQ3OBcVFNq2sm0wLA6wkIuRETa6r2iU7avO4jLBzP6BeW9ddN4gD4vDchBmhk0l2iZ407S+TF3XGUwvCOJgu/hHbVlrumNgWmSVB7msMv400xnlvAEjrqhOd8EqxPrrab0Fco69I6hUm+PYtAQ+LFdDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G7Xc+vl3; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G7Xc+vl3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754905; x=1793290905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S04DLKChqtxVIfbayGN7vRQzulAjFbTzMk1BBDVs9H4=;
  b=G7Xc+vl3/rVkZKEXz+NnPoTklVanYLVGzWxqA3xM+Gf+FYKOVYWvh8Vz
   1hFsh/1P8OngIR1bjcFZPoqO5rBe1igAYudhgITJS1ZujWBaxgUpbOR7Y
   izEQ1j/bRF83h2+qszZNLRDv/+Bql5tgnS8UHsvKSInic7oRErcea+hhd
   ICX+cWSIZfoP0koLh8eR7ytdP/vBQ6wmourGwgOTa0CVZqVN6RyURkuUe
   +ixfuYQGlVgbGn9aFEEHrK+P0fWtA8Otj1K7bphlGJfWwXE5IuuZTjSOP
   mBg5NWyPDpfC+bRBMIIBwAoLaL6o4/ZEYuCzBFPCF12dJcStGYcRwKnaY
   w==;
X-CSE-ConnectionGUID: Ava3Y42qSNakFYW3LVP0eg==
X-CSE-MsgGUID: NEdRzuC3Taql5gq4CV2mLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481337"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481337"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:33 -0700
X-CSE-ConnectionGUID: NUgfyV/+RRunMeXsmFfWmA==
X-CSE-MsgGUID: /T5OW1BBRliYjUuJw9JTQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901385"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:33 -0700
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
Subject: [PATCH v13 22/32] fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp()
Date: Wed, 29 Oct 2025 09:21:05 -0700
Message-ID: <20251029162118.40604-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clearing a monitor group's mon_data directory is complicated because of the
support for Sub-NUMA Cluster (SNC) mode.

Refactor the SNC case into a helper function to make it easier to add support
for a new telemetry resource.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/rdtgroup.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index bcb76dc818c0..4f461ec773d6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3163,28 +3163,24 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
 }
 
 /*
- * Remove all subdirectories of mon_data of ctrl_mon groups
- * and monitor groups for the given domain.
- * Remove files and directories containing "sum" of domain data
- * when last domain being summed is removed.
+ * Remove files and directories for one SNC node. If it is the last node
+ * sharing an L3 cache, then remove the upper level directory containing
+ * the "sum" files too.
  */
-static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_domain_hdr *hdr)
+static void rmdir_mondata_subdir_allrdtgrp_snc(struct rdt_resource *r,
+					       struct rdt_domain_hdr *hdr)
 {
 	struct rdtgroup *prgrp, *crgrp;
 	struct rdt_l3_mon_domain *d;
 	char subname[32];
-	bool snc_mode;
 	char name[32];
 
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
-	if (snc_mode)
-		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
+	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
+	sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
@@ -3194,6 +3190,30 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	}
 }
 
+/*
+ * Remove all subdirectories of mon_data of ctrl_mon groups
+ * and monitor groups for the given domain.
+ */
+static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
+					   struct rdt_domain_hdr *hdr)
+{
+	struct rdtgroup *prgrp, *crgrp;
+	char name[32];
+
+	if (r->rid == RDT_RESOURCE_L3 && r->mon_scope == RESCTRL_L3_NODE) {
+		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
+		return;
+	}
+
+	sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
+		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
+
+		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
+			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
+	}
+}
+
 /*
  * Create a directory for a domain and populate it with monitor files. Create
  * summing monitors when @hdr is NULL. No need to initialize summing monitors.
-- 
2.51.0

