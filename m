Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C9C30171E
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408524; cv=none; b=GBCYh1Ps92pM9aVk9eocwo+VdXiK0ckiRbPn3RFYHfIaHKX2q328cPsggGgJ3cxd4G6dcD2HSByCIwHOFIB+fRW/lFXNin20BYEKtdLG7rzGbDHEjCBZvXFdde8CStj/kc/ucqvPi1KXIndUJ5aNkoKGX/0lrJw7HKcq/JmJs4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408524; c=relaxed/simple;
	bh=miRJzo1AWfZUKy+ImvgvbTXaJITzgINN7ynFnTS9zo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnvzxQG14MNCW0D3meCxrQGKTyEm14itYM6s+9BL7OGf1UdYvfUg85v3cmbIiFiNNj53iZgk2a9N4MejMqsKYG1yVlV25tCZeQFlZhLIMgFBRlwET6l9Gy966NV13qQ2ROF7YNTOYzfTGy4z5agLGHD3yN2jr5CstkwTS51Wilw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S3orzUhg; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S3orzUhg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408515; x=1796944515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=miRJzo1AWfZUKy+ImvgvbTXaJITzgINN7ynFnTS9zo4=;
  b=S3orzUhgaq7kM2N7YHftcUFoHAmGmaIDLv2EyLUwvuS0MhecVVve6jZG
   z1WpjrvN5YUnvhfsr6V5iay1pDPFz9O6GStZ4fB368jHnhn8l/LGH7SJ3
   G7rI3pGgLCtmp6zaaOgHQE+JFIYU32rLH6j+ae/FWUh8WhdjaDM3q58AB
   rdpp9SNr//6fuVENZsBAoJB5Dh4Zsexg0BdKA8k3Qo5Dlp1SFBa5y3CxX
   zzDrwgARo+Mur0ILybiumWBiUZJw1fHmw8FJrXiLOM8zWTrZH3Nu/ZtiZ
   BxW1ONLpnNnZ9FB3+LlzaEAh+yv+nfe4kurIuGCIpaEOzMY4pxZeDjsto
   g==;
X-CSE-ConnectionGUID: a2hAKouKRoa1eitTK1i6Lw==
X-CSE-MsgGUID: aH/BBDVITbOkiueLoq0zVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973656"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973656"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:39 -0800
X-CSE-ConnectionGUID: bqfp0dwNRXqLec4BwDe+sg==
X-CSE-MsgGUID: Dj9MeepqSieNtEO4a1aDJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297121"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:38 -0800
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
Subject: [PATCH v16 22/32] fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp()
Date: Wed, 10 Dec 2025 15:14:01 -0800
Message-ID: <20251210231413.59102-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/rdtgroup.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index c0db5d8999ee..679247c43b1a 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3228,28 +3228,24 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
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
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : hdr->id);
-	if (snc_mode)
-		sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
+	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
+	sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
@@ -3259,6 +3255,30 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
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
2.51.1

