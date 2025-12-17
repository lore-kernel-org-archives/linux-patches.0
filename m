Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F428346FDF
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992146; cv=none; b=hZ+LiZIBIJLCyv/vrQD483L3LVAqu4oFlTuZ7F7fJA5URmRvDaGv2iuHSOdwVIyZuNQZL0iGe5yx4+R5G0eAVrh17ehNeDsKQcZ51OnbIqFHSkJNoNMAAjgg8/KP6zvQx71hnIxz/rGF3g8P4no8nnYKqZg8uPgQlJZpvmK1I3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992146; c=relaxed/simple;
	bh=6eDfgjELhcmSW90C74/6awyAJ2/BjysR0ixtjTPYPbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF6NrsLMU5vNk1nqpCxm4hbUxYxk8u3x9BKoSDBbkvyJ2kla/gtyNicsUyUYZmW0X6G1WUwItWxq7jppVPVZterQ5tnzqOL3xwxKGCUEx+P0eJGqHpcJBj6Bts07WhlvCNjCL9IlfBL6Gsxw71OQEpfX1SAxhkXKhB79BcWmYRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WVNy+Mw4; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WVNy+Mw4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992140; x=1797528140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6eDfgjELhcmSW90C74/6awyAJ2/BjysR0ixtjTPYPbM=;
  b=WVNy+Mw4dZ0ybsqr6NxpqSyP/QQFqPatmpDmVyPjwksDblUIbkM8YXxt
   qZjqrTzT1zhuxt7cf6iz+jXXpCLNaKfnW7Q73KFoiPcqmhHrHj/Aw5Gbf
   pUFfp9f0Qj4ChDxu4iYZR3Zqhvuv9J+2jnp8QPUOGzjgoscuaNgrkUsIm
   TRhSL+8dcdYM0w4QYYy1dv97wPGfT5aKCHbcWO9Wi19ij3XzHgVgCjbG9
   ek99VZPyZvsnFSRvrJ3xAGfZ7/BwYgPEJZrMyGG1SaFmGpuMmyuosTaDN
   LPZ27QTy34D43IkCl+ammASSctilqVLdBD3RaTHUsROCdXu/3nhYIKeKk
   w==;
X-CSE-ConnectionGUID: zrTWdcbzTf+u33MtXw7/QQ==
X-CSE-MsgGUID: iZhknDHvTMWZTnPHqxcFsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594812"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594812"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:37 -0800
X-CSE-ConnectionGUID: bAflHPHoT/Gj7eqN+1qrbQ==
X-CSE-MsgGUID: BcxbriBqSfKv3hD9pYnnvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748240"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:35 -0800
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
Subject: [PATCH v17 22/32] fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp()
Date: Wed, 17 Dec 2025 09:21:09 -0800
Message-ID: <20251217172121.12030-23-tony.luck@intel.com>
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
2.52.0

