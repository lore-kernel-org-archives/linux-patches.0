Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C865630DEB0
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394858; cv=none; b=r489jVe8MKF9X0f7aTx0Qqjxga7xc2jMmJ0Ro1WmcXiKCybmHXWUTsoy0+awJYgg7xIqVTyGbqiJ31PiLweVflNdWia7PLf5CtviTY3xwDGvj5YjgplwXSB+uXxZm58/cmYzJo2+qcHv+wwCPCaue520iPbW5fOuZpDkPPDiVSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394858; c=relaxed/simple;
	bh=tkKjneMjkAKhQ2DMKRriXTuPPq69NgdK6JOt5IQgoK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grWEO5Z/gwukbZObuyyGsrQTW5ergce9YvCbl5f/v560PapF+92GCpGcraDBokVhOx5vZU16SnmTwkkeN0k15RXWBhEcdxxP3XmUsKPrh23SpVXcKJpLv/abUpdc/bw6KGlwGpXYZNHDqcmzoP681BcblaJjPMPRVzXM4MPr9dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l5ZLEQZM; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l5ZLEQZM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394856; x=1791930856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tkKjneMjkAKhQ2DMKRriXTuPPq69NgdK6JOt5IQgoK0=;
  b=l5ZLEQZMqF39RRevtjvBUKDHsOnS7aLyOOZmvzfy35elSlvpbYMf8juK
   aRJHDK3dipghYlKXDdkablRREgXYBXupcNhXhnC5uG6XKvWToRDGheyJb
   ySPqY2GHW+Ap92+hK+HU3HU07BRTWgmlOL7YCSJ3bGQ8WqC2LzzhDADjv
   0R1rSyov5Y+Ih/Y+OTYSGHru5sev/BNxzR3j2+nysrKE/UdYosv2HFefu
   xV20W9B1CGbpwRgHnI8evXzWbZK/jLrXbDD06RVshVKmMfVRUAk+ZeSgz
   jfjrPEvHeuIbu5TlzbkBj3R3E5paepQWOS2clr7LorycyaGjPFXmy79fw
   w==;
X-CSE-ConnectionGUID: HBfbRkAhREaWR6fQvQHfbQ==
X-CSE-MsgGUID: 7RjQOy1OQ3KaUFwfSXR4uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168898"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168898"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:03 -0700
X-CSE-ConnectionGUID: GejNULltT5iMJLJ2b3l8BQ==
X-CSE-MsgGUID: P4fsl1GlS0eRsMdCQFPjWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145313"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:02 -0700
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
Subject: [PATCH v12 20/31] fs/resctrl: Refactor mkdir_mondata_subdir()
Date: Mon, 13 Oct 2025 15:33:34 -0700
Message-ID: <20251013223348.103390-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mkdir_mondata_subdir() is unreasonably complicated because of the support for
Sub-NUMA Cluster (SNC) mode.

Split out the SNC code into a helper function to make it easier to add support
for a new telemetry resource.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/rdtgroup.c | 83 +++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 31 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index c9d2cc1fd8bf..b7eaa4388768 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3196,22 +3196,16 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 
 static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			     struct rdt_resource *r, struct rdtgroup *prgrp,
-			     bool do_sum)
+			     int domid, bool do_sum)
 {
 	struct rmid_read rr = {0};
-	struct rdt_l3_mon_domain *d;
 	struct mon_data *priv;
 	struct mon_evt *mevt;
-	int ret, domid;
-
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-		return -EINVAL;
+	int ret;
 
-	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	for_each_mon_event(mevt) {
 		if (mevt->rid != r->rid || !mevt->enabled)
 			continue;
-		domid = do_sum ? d->ci_id : d->hdr.id;
 		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
 		if (WARN_ON_ONCE(!priv))
 			return -EINVAL;
@@ -3227,24 +3221,20 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 	return 0;
 }
 
-static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
-				struct rdt_domain_hdr *hdr,
-				struct rdt_resource *r, struct rdtgroup *prgrp)
+static int mkdir_mondata_subdir_snc(struct kernfs_node *parent_kn,
+				    struct rdt_domain_hdr *hdr,
+				    struct rdt_resource *r, struct rdtgroup *prgrp)
 {
 	struct kernfs_node *kn, *ckn;
 	struct rdt_l3_mon_domain *d;
 	char name[32];
-	bool snc_mode;
 	int ret = 0;
 
-	lockdep_assert_held(&rdtgroup_mutex);
-
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
+	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
 	kn = kernfs_find_and_get(parent_kn, name);
 	if (kn) {
 		/*
@@ -3260,27 +3250,58 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		ret = rdtgroup_kn_set_ugid(kn);
 		if (ret)
 			goto out_destroy;
-		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
+		ret = mon_add_all_files(kn, hdr, r, prgrp, d->ci_id, true);
 		if (ret)
 			goto out_destroy;
 	}
 
-	if (snc_mode) {
-		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
-		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
-		if (IS_ERR(ckn)) {
-			ret = -EINVAL;
-			goto out_destroy;
-		}
+	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
+	ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
+	if (IS_ERR(ckn)) {
+		ret = -EINVAL;
+		goto out_destroy;
+	}
 
-		ret = rdtgroup_kn_set_ugid(ckn);
-		if (ret)
-			goto out_destroy;
+	ret = rdtgroup_kn_set_ugid(ckn);
+	if (ret)
+		goto out_destroy;
 
-		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
-		if (ret)
-			goto out_destroy;
-	}
+	ret = mon_add_all_files(ckn, hdr, r, prgrp, hdr->id, false);
+	if (ret)
+		goto out_destroy;
+
+	kernfs_activate(kn);
+	return 0;
+
+out_destroy:
+	kernfs_remove(kn);
+	return ret;
+}
+
+static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
+				struct rdt_domain_hdr *hdr,
+				struct rdt_resource *r, struct rdtgroup *prgrp)
+{
+	struct kernfs_node *kn;
+	char name[32];
+	int ret = 0;
+
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	if (r->mon_scope == RESCTRL_L3_NODE)
+		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
+
+	sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
+	if (IS_ERR(kn))
+		return PTR_ERR(kn);
+
+	ret = rdtgroup_kn_set_ugid(kn);
+	if (ret)
+		goto out_destroy;
+	ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, false);
+	if (ret)
+		goto out_destroy;
 
 	kernfs_activate(kn);
 	return 0;
-- 
2.51.0

