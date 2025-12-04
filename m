Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A2332936E
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881678; cv=none; b=ggV9a1vby/Nl81DW/x/Ii3UKewhVbFVUfC6i9WHYrsprb/HxZ7lAmtuMrBuaCNTOo8kn8KhDAN3jqz7yU7kCH3URUckCj2zUZfCi4Y1cdSs4q3p6E0hvNw3Dd2jFA86qdOaRPzXEpsPRAoCY89FCUs/tmIj4MiQ5G0vTa3fvtDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881678; c=relaxed/simple;
	bh=miRJzo1AWfZUKy+ImvgvbTXaJITzgINN7ynFnTS9zo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK4PYAC1AWhWRv7TCjuRt8HQaM7kSZQTjFtV4DwCqZOdKvPE+l+CWtLPPs3UaGjALfaDu4hEcf+fyMb0c8Grd8oAQKrVbc9108fMLkUevJHsF6GxDoSiWw28bflZS8DvnaK6cWmnX3JB2kdG0tMZqNe5MkKPZ6XDcoFNsHJs/vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YqOIhTKC; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YqOIhTKC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881676; x=1796417676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=miRJzo1AWfZUKy+ImvgvbTXaJITzgINN7ynFnTS9zo4=;
  b=YqOIhTKCoAA1cp8Zc11ha++LOAiGgMEldMRADA5YdoL1sFvSir7veNcP
   OubO+ffx8lF6ZQtXh2coUVKZri03UW62j0utqQLq+KaWm5hgVtt6bqqUp
   nYgpLutsPcjSOdBjwzYKaHkx+J+J1cPF4psgZ0webMH4OifDTtgs6VLKH
   nF9lRUUQ1nBsaY7QV/WHtQlWzmFpebsmZ+yJbYI5p/P6EbNzuOQXLFkTV
   UETizMDo3I2jjDnmAL+CRnZ+KE7yqP3mjoW/pSlLghAUIOrTCkMLQM9FC
   zWxT+9JreYukk2elmsfFA+VZpWK+ZnXwR2SBRIzfASwe4FmuqMXomNXmV
   Q==;
X-CSE-ConnectionGUID: jHFpp5MiQW2bPCJCND7F5Q==
X-CSE-MsgGUID: +any79L9RIGQ4Es83kN0pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69511037"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69511037"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:28 -0800
X-CSE-ConnectionGUID: vqmTcI+hTran4Ekk1jDC4g==
X-CSE-MsgGUID: rSTNl2dmRVKzDFfmhUeO/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752839"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:27 -0800
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
Subject: [PATCH v15 22/32] fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp()
Date: Thu,  4 Dec 2025 12:53:52 -0800
Message-ID: <20251204205404.12763-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
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

