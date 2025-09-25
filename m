Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185A3323416
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830662; cv=none; b=aIioR5F0SMhPLV7xnv9MX//QWeE/kqCsHnpWqwpuq9Tg/Nr7mXlLMMMUrGWpIj6uiYWxvjgy/JfOVyhIp/QsiAz87WFoN9/1fjceONBwlaWv/FpLr/1WqcGWJC007ae6hADM173Om5kWvcRROWvlDiYvXenmm67zmih8z6tPOX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830662; c=relaxed/simple;
	bh=xo1ybD9cfc9M4Kz+Mli/XGLt6Z6TLya4Q1mtqhvg5Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeWPhljqg/C79KBkgZtL/xaOy8zmAtAo1505EuA09MxkJngQouepiHecplf9JnX3tj8WfCLEtGnOAvqNSRDSm9bWMrc82OeQHeuo0PqTV2BVeOZBY5dkooyKtXOP9z3Skl69XZwju7d2zbHxh6qZ8mA+ETK2Qdzf34NRP50p7O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M6xkY4v4; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M6xkY4v4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830661; x=1790366661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xo1ybD9cfc9M4Kz+Mli/XGLt6Z6TLya4Q1mtqhvg5Ss=;
  b=M6xkY4v49rfFtA1CLxyo0XjSeMguMDI6z+CO+DB7MPYHF0qJ+8EFv4nQ
   xUzc4fRGP3wEFPcj+6vUo+K79a35EGYRJX2WDWnztlCYOj0oSQlbI3DPL
   vE3jw3vDK66qWEVbJqB4+NR1+JO8VAJMSEQ9WjzAjHCvdvInEOpPp15QT
   prZTV7+Rv1xOCyiwoDxUfbcYDmSywrSi3ygeY1VLT5JcyuEfnqCPDKpLo
   Fy03pCflcewdSpyqJSzJ6e7CZp6PC+jOqG6L7ZPRQkNRytCDTt0D3RRBN
   RtetSi+lBQaBn4c4Kzse0qKnVw1EjLhf7RZEPDiJx22jw1dKdiw8ZhlZ+
   w==;
X-CSE-ConnectionGUID: 57CyG/y3SgKpwAXkmVHs9Q==
X-CSE-MsgGUID: oqGtN6GVRf6LUxgJSq1Bmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074304"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074304"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:12 -0700
X-CSE-ConnectionGUID: 0emR60+lTDyhXRLzgb6wXw==
X-CSE-MsgGUID: kgh+EWWrStOZFYXYw4EALQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003671"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:12 -0700
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
Subject: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in mkdir/rmdir code flow
Date: Thu, 25 Sep 2025 13:03:14 -0700
Message-ID: <20250925200328.64155-21-tony.luck@intel.com>
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

SNC is only present in the RDT_RESOURCE_L3 domain.

Refactor code that makes and removes directories under "mon_data" to
special case the L3 resource.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/rdtgroup.c | 50 +++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 6e8937f94e7a..cab5cb9e6c93 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3155,6 +3155,7 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
 		return;
 	kernfs_put(kn);
 
+	/* Subdirectories are only present on SNC enabled systems */
 	if (kn->dir.subdirs <= 1)
 		kernfs_remove(kn);
 	else
@@ -3171,19 +3172,24 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 					   struct rdt_domain_hdr *hdr)
 {
 	struct rdtgroup *prgrp, *crgrp;
-	struct rdt_l3_mon_domain *d;
+	int domid = hdr->id;
 	char subname[32];
-	bool snc_mode;
 	char name[32];
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-		return;
+	if (r->rid == RDT_RESOURCE_L3) {
+		struct rdt_l3_mon_domain *d;
 
-	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
-	if (snc_mode)
-		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+			return;
+
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
+		/* SNC mode? */
+		if (r->mon_scope == RESCTRL_L3_NODE) {
+			domid = d->ci_id;
+			sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
+		}
+	}
+	sprintf(name, "mon_%s_%02d", r->name, domid);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
@@ -3213,7 +3219,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 		if (ret)
 			return ret;
 
-		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
+		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
 			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
@@ -3225,19 +3231,27 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
 	struct kernfs_node *kn, *ckn;
-	struct rdt_l3_mon_domain *d;
+	bool snc_mode = false;
+	int domid = hdr->id;
 	char name[32];
-	bool snc_mode;
 	int ret = 0;
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-		return -EINVAL;
+	if (r->rid == RDT_RESOURCE_L3) {
+		snc_mode = r->mon_scope == RESCTRL_L3_NODE;
+		if (snc_mode) {
+			struct rdt_l3_mon_domain *d;
+
+			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+				return -EINVAL;
+
+			d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
+			domid = d->ci_id;
+		}
+	}
+	sprintf(name, "mon_%s_%02d", r->name, domid);
 
-	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
 	kn = kernfs_find_and_get(parent_kn, name);
 	if (kn) {
 		/*
@@ -3253,7 +3267,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		ret = rdtgroup_kn_set_ugid(kn);
 		if (ret)
 			goto out_destroy;
-		ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, snc_mode);
+		ret = mon_add_all_files(kn, hdr, r, prgrp, domid, snc_mode);
 		if (ret)
 			goto out_destroy;
 	}
-- 
2.51.0

