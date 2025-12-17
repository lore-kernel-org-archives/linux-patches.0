Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AB34A3CB
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992144; cv=none; b=SzzlimYg6O7Kc4PLW8Ff5I2HRNFCHNUozVf/1VtpK8yuSWkbbH30HdMFrttNIYgszJAHh5dZNpKpf4LCQsaqhYPaCfuZa370usdJdvOnTfLsoK3y6/AY7yftrHu9fDYLOz4nEAwNC45ibuMpznzhH98ub9R3T70IGAwJ4NnTflg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992144; c=relaxed/simple;
	bh=GeQeTu0vdIZFDhTL97UkQ4etZOCh7MLXNDywONiyyMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmMbIyo0sfvkvpXtqD5oscu05jsfLPMXtK3TDmvfWorQLPq64fgeubttyAAioAr/hLSPNH60eT6Z17OWRnNWJFYfAHHfdYVIWuy9zTuH6oJAzlSIdQarT3JivNNP4f8Ivt2tPkTAR2XeaAv8ydjevT4rbD8D2zd0AOrs6w3Eji8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I/lIBBg5; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I/lIBBg5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992135; x=1797528135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GeQeTu0vdIZFDhTL97UkQ4etZOCh7MLXNDywONiyyMA=;
  b=I/lIBBg5TJUF0WQMrFkjaxmYo18OF+8L/jjxImsFKNT+rGwLZvo9H7Xo
   MyaXIbwtIhZCYHJ6Yn3uw+IjZAV8EznkMh5In0HZ23hNLtEDnLIGGZmAi
   fKwGsp11BZxu8P8rivHRU+RUXYTcL0CjYnIppKiJsYm4hkQAKUWvGdHhJ
   4G7a2PaZaaRzNveykh5qGXHN3ON04G9i/Gi8BgxaOo+ejK8UbCP4ibZNU
   Rb1EokwKN0Ec44HxaxmjcCMVGVFLlNlDTxSf/MTMFQZBI1d1IzzbKAjKD
   9qVcapvp50qkfgoOYwi48AX1Vla6GwM0uUoDcL3oVIBqLtAvp0J+imh72
   g==;
X-CSE-ConnectionGUID: SNPZPmTmQvSiGEV4igS08Q==
X-CSE-MsgGUID: Nq7d+lmBTmSSyIaKXhqXSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594808"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594808"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:36 -0800
X-CSE-ConnectionGUID: /bCPDCT/TRqkSiqnkoV0Vg==
X-CSE-MsgGUID: 6ci1xULORZyGX5j59V/oMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748236"
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
Subject: [PATCH v17 21/32] fs/resctrl: Refactor mkdir_mondata_subdir()
Date: Wed, 17 Dec 2025 09:21:08 -0800
Message-ID: <20251217172121.12030-22-tony.luck@intel.com>
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

Population of a monitor group's mon_data directory is unreasonably complicated
because of the support for Sub-NUMA Cluster (SNC) mode.

Split out the SNC code into a helper function to make it easier to add support
for a new telemetry resource.

Move all the duplicated code to make and set owner of domain directories
into the mon_add_all_files() helper and rename to _mkdir_mondata_subdir().

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/rdtgroup.c | 108 +++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 50 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index dce1f0a6d40b..c0db5d8999ee 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3259,57 +3259,65 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	}
 }
 
-static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
-			     struct rdt_resource *r, struct rdtgroup *prgrp,
-			     bool do_sum)
+/*
+ * Create a directory for a domain and populate it with monitor files. Create
+ * summing monitors when @hdr is NULL. No need to initialize summing monitors.
+ */
+static struct kernfs_node *_mkdir_mondata_subdir(struct kernfs_node *parent_kn, char *name,
+						 struct rdt_domain_hdr *hdr,
+						 struct rdt_resource *r,
+						 struct rdtgroup *prgrp, int domid)
 {
-	struct rdt_l3_mon_domain *d;
 	struct rmid_read rr = {0};
+	struct kernfs_node *kn;
 	struct mon_data *priv;
 	struct mon_evt *mevt;
-	int ret, domid;
+	int ret;
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-		return -EINVAL;
+	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
+	if (IS_ERR(kn))
+		return kn;
+
+	ret = rdtgroup_kn_set_ugid(kn);
+	if (ret)
+		goto out_destroy;
 
-	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	for_each_mon_event(mevt) {
 		if (mevt->rid != r->rid || !mevt->enabled)
 			continue;
-		domid = do_sum ? d->ci_id : d->hdr.id;
-		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
-		if (WARN_ON_ONCE(!priv))
-			return -EINVAL;
+		priv = mon_get_kn_priv(r->rid, domid, mevt, !hdr);
+		if (WARN_ON_ONCE(!priv)) {
+			ret = -EINVAL;
+			goto out_destroy;
+		}
 
 		ret = mon_addfile(kn, mevt->name, priv);
 		if (ret)
-			return ret;
+			goto out_destroy;
 
-		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
+		if (hdr && resctrl_is_mbm_event(mevt->evtid))
 			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
-	return 0;
+	return kn;
+out_destroy:
+	kernfs_remove(kn);
+	return ERR_PTR(ret);
 }
 
-static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
-				struct rdt_domain_hdr *hdr,
-				struct rdt_resource *r, struct rdtgroup *prgrp)
+static int mkdir_mondata_subdir_snc(struct kernfs_node *parent_kn,
+				    struct rdt_domain_hdr *hdr,
+				    struct rdt_resource *r, struct rdtgroup *prgrp)
 {
-	struct kernfs_node *kn, *ckn;
+	struct kernfs_node *ckn, *kn;
 	struct rdt_l3_mon_domain *d;
 	char name[32];
-	bool snc_mode;
-	int ret = 0;
-
-	lockdep_assert_held(&rdtgroup_mutex);
 
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
+	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
 	kn = kernfs_find_and_get(parent_kn, name);
 	if (kn) {
 		/*
@@ -3318,41 +3326,41 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		 */
 		kernfs_put(kn);
 	} else {
-		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
+		kn = _mkdir_mondata_subdir(parent_kn, name, NULL, r, prgrp, d->ci_id);
 		if (IS_ERR(kn))
 			return PTR_ERR(kn);
+	}
 
-		ret = rdtgroup_kn_set_ugid(kn);
-		if (ret)
-			goto out_destroy;
-		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
-		if (ret)
-			goto out_destroy;
+	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
+	ckn = _mkdir_mondata_subdir(kn, name, hdr, r, prgrp, hdr->id);
+	if (IS_ERR(ckn)) {
+		kernfs_remove(kn);
+		return PTR_ERR(ckn);
 	}
 
-	if (snc_mode) {
-		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
-		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
-		if (IS_ERR(ckn)) {
-			ret = -EINVAL;
-			goto out_destroy;
-		}
+	kernfs_activate(kn);
+	return 0;
+}
 
-		ret = rdtgroup_kn_set_ugid(ckn);
-		if (ret)
-			goto out_destroy;
+static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
+				struct rdt_domain_hdr *hdr,
+				struct rdt_resource *r, struct rdtgroup *prgrp)
+{
+	struct kernfs_node *kn;
+	char name[32];
 
-		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
-		if (ret)
-			goto out_destroy;
-	}
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	if (r->rid == RDT_RESOURCE_L3 && r->mon_scope == RESCTRL_L3_NODE)
+		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
+
+	sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	kn = _mkdir_mondata_subdir(parent_kn, name, hdr, r, prgrp, hdr->id);
+	if (IS_ERR(kn))
+		return PTR_ERR(kn);
 
 	kernfs_activate(kn);
 	return 0;
-
-out_destroy:
-	kernfs_remove(kn);
-	return ret;
 }
 
 /*
-- 
2.52.0

