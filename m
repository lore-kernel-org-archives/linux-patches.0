Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530F422ACC6
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069252; cv=none; b=oF66WELGjkNq2cS8qk12YpwGvvIydAHmAYxZhw8GWsbjjHRaM6XEIMFWjmJFkz2Ff66gwmPaW8orhCTPPMNl7giBoJYgGus/70MWKVTdB9V18bd+rwxnGnncpbY/Qb1LzEB8CMhdvw2iIR/pN3Drpm1ngbL3QTZ3Uz8PwRPeVBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069252; c=relaxed/simple;
	bh=kAA1NPfA0qoxNeR5YO7tA3WBky/aNtheiKAM1Wb+ug8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=le4glPpE0iNSFqSBUceYdzHGqriarAr/vGNdHpwKD/hT1F2oukwbgOeTd2TQyAY8867WmC3g2pvGAc4zBghTITIZTABoyBYr/Vzl7H6gd4Ulr/HkwUlPJINnYLwTOCm88KBI8k5eIpdXQAcdlXhOYCrkeYIbSGyumP5rGepTIfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CKH6iX5h; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CKH6iX5h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069250; x=1775605250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kAA1NPfA0qoxNeR5YO7tA3WBky/aNtheiKAM1Wb+ug8=;
  b=CKH6iX5h/IUPwYA5vm4kwwgxwNMvMJm3Sx5F5S+F/WXawmg9B7nZD/Fk
   J0lWyNa430azc4/FgrIn84PXzRUbsA9gckZl94FwJ2qdboiz7A/0K8eCj
   WLF4+uZRwJB+DvN79T2f2Pj8BcMn/YNdMoPQKWoPX/B+8O16G9lSiNPHY
   YuoTBmSOollYJ9Rnw55Y0vZ9qFbyxPEC+xOEIXx5Qg3w2NFoVnCbeW8uh
   M5EKOFmwt/Jfgu1G551Fz1U1RaC5q198UIa70oHpzXCrtuNzZVz/JJXfY
   SNmN1HJr0bZnEVk5JA6c98zyfh7RmR7uacNk1mG6czAlkc+vDCKbTI2yJ
   g==;
X-CSE-ConnectionGUID: uhTSUK2MQuiUd2wa+iFcvw==
X-CSE-MsgGUID: 8JMddvWOTH6dJfaHWkgY6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193115"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193115"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:44 -0700
X-CSE-ConnectionGUID: qNyCGEiOSjOOr5h2w4IEYA==
X-CSE-MsgGUID: XidpWL+OTq6NV5PDZP8MFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315444"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:44 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 01/26] fs/resctrl: Simplify allocation of mon_data structures
Date: Mon,  7 Apr 2025 16:40:03 -0700
Message-ID: <20250407234032.241215-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of making a special case to allocate and attach these structures
to kernfs files in the default control group, simply allocate a structure
when a new combination of <rid, domain, mevt, do_sum> is needed and
reuse existing structures when possible.

Free all structures when resctrl filesystem is unmounted.

Partial revert of commit fa563b5171e9 ("x86/resctrl: Expand the width
of dom_id by replacing mon_data_bits")

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h |   2 +
 fs/resctrl/rdtgroup.c | 138 ++++++++++++------------------------------
 2 files changed, 40 insertions(+), 100 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index ec3863d18f68..e5976bd52a35 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -83,6 +83,7 @@ struct mon_evt {
 
 /**
  * struct mon_data - Monitoring details for each event file.
+ * @list:            List of all allocated structures.
  * @rid:             Resource id associated with the event file.
  * @evtid:           Event id associated with the event file.
  * @sum:             Set when event must be summed across multiple
@@ -96,6 +97,7 @@ struct mon_evt {
  * rdtgroup_mutex.
  */
 struct mon_data {
+	struct list_head list;
 	unsigned int rid;
 	enum resctrl_event_id evtid;
 	unsigned int sum;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 234ec9dbe5b3..338b70c7d302 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -69,6 +69,8 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx);
 
 static void rdtgroup_destroy_root(void);
 
+static void mon_put_kn_priv(void);
+
 struct dentry *debugfs_resctrl;
 
 /*
@@ -2873,6 +2875,7 @@ static void rdt_kill_sb(struct super_block *sb)
 		resctrl_arch_reset_all_ctrls(r);
 
 	rmdir_all_sub();
+	mon_put_kn_priv();
 	rdt_pseudo_lock_release();
 	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
 	schemata_list_destroy();
@@ -2895,107 +2898,54 @@ static struct file_system_type rdt_fs_type = {
 	.kill_sb		= rdt_kill_sb,
 };
 
+static LIST_HEAD(kn_priv_list);
+
 /**
- * mon_get_default_kn_priv() - Get the mon_data priv data for this event from
- *                             the default control group.
+ * mon_get_kn_priv() - Get the mon_data priv data for this event
  * Called when monitor event files are created for a domain.
- * When called with the default control group, the structure will be allocated.
- * This happens at mount time, before other control or monitor groups are
- * created.
- * This simplifies the lifetime management for rmdir() versus domain-offline
- * as the default control group lives forever, and only one group needs to be
- * special cased.
+ * The same values are used in multiple directories. Keep a list
+ * of allocated structures and reuse an existing one with the same
+ * list of values for rid, domain, etc.
  *
- * @r:      The resource for the event type being created.
- * @d:	    The domain for the event type being created.
- * @mevt:   The event type being created.
- * @rdtgrp: The rdtgroup for which the monitor file is being created,
- *          used to determine if this is the default control group.
- * @do_sum: Whether the SNC sub-numa node monitors are being created.
+ * @rid:	The resource for the event type being created.
+ * @domid:	The domain for the event type being created.
+ * @mevt:	The event type being created.
+ * @do_sum:	Whether the SNC sub-numa node monitors are being created.
  */
-static struct mon_data *mon_get_default_kn_priv(struct rdt_resource *r,
-						struct rdt_mon_domain *d,
-						struct mon_evt *mevt,
-						struct rdtgroup *rdtgrp,
-						bool do_sum)
+static struct mon_data *mon_get_kn_priv(int rid, int domid, struct mon_evt *mevt, bool do_sum)
 {
-	struct kernfs_node *kn_dom, *kn_evt;
 	struct mon_data *priv;
-	bool snc_mode;
-	char name[32];
 
-	lockdep_assert_held(&rdtgroup_mutex);
-
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	if (!do_sum)
-		sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
-	else
-		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
-
-	kn_dom = kernfs_find_and_get(kn_mondata, name);
-	if (!kn_dom)
-		return NULL;
-
-	kn_evt = kernfs_find_and_get(kn_dom, mevt->name);
-
-	/* Is this the creation of the default groups monitor files? */
-	if (!kn_evt && rdtgrp == &rdtgroup_default) {
-		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-		if (!priv)
-			return NULL;
-		priv->rid = r->rid;
-		priv->domid = do_sum ? d->ci->id : d->hdr.id;
-		priv->sum = do_sum;
-		priv->evtid = mevt->evtid;
-		return priv;
+	list_for_each_entry(priv, &kn_priv_list, list) {
+		if (priv->rid == rid && priv->domid == domid &&
+		    priv->sum == do_sum && priv->evtid == mevt->evtid)
+			return priv;
 	}
 
-	if (!kn_evt)
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return NULL;
 
-	return kn_evt->priv;
+	priv->rid = rid;
+	priv->domid = domid;
+	priv->sum = do_sum;
+	priv->evtid = mevt->evtid;
+	list_add_tail(&priv->list, &kn_priv_list);
+
+	return priv;
 }
 
 /**
- * mon_put_default_kn_priv_all() - Potentially free the mon_data priv data for
- *                                 all events from the default control group.
- * Put the mon_data priv data for all events for a particular domain.
- * When called with the default control group, the priv structure previously
- * allocated will be kfree()d. This should only be done as part of taking a
- * domain offline.
- * Only a domain offline will 'rmdir' monitor files in the default control
- * group. After domain offline releases rdtgrp_mutex, all references will
- * have been removed.
- *
- * @rdtgrp:  The rdtgroup for which the monitor files are being removed,
- *           used to determine if this is the default control group.
- * @name:    The name of the domain or SNC sub-numa domain which is being
- *           taken offline.
+ * mon_put_kn_priv() - Free all allocated mon_data structures
+ * Called when resctrl file system is unmounted.
  */
-static void mon_put_default_kn_priv_all(struct rdtgroup *rdtgrp, char *name)
+static void mon_put_kn_priv(void)
 {
-	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	struct kernfs_node *kn_dom, *kn_evt;
-	struct mon_evt *mevt;
+	struct mon_data *priv, *tmp;
 
-	lockdep_assert_held(&rdtgroup_mutex);
-
-	if (rdtgrp != &rdtgroup_default)
-		return;
-
-	kn_dom = kernfs_find_and_get(kn_mondata, name);
-	if (!kn_dom)
-		return;
-
-	list_for_each_entry(mevt, &r->evt_list, list) {
-		kn_evt = kernfs_find_and_get(kn_dom, mevt->name);
-		if (!kn_evt)
-			continue;
-		if (!kn_evt->priv)
-			continue;
-
-		kfree(kn_evt->priv);
-		kn_evt->priv = NULL;
+	list_for_each_entry_safe(priv, tmp, &kn_priv_list, list) {
+		kfree(priv);
+		list_del(&priv->list);
 	}
 }
 
@@ -3029,16 +2979,12 @@ static void mon_rmdir_one_subdir(struct rdtgroup *rdtgrp, char *name, char *subn
 	if (!kn)
 		return;
 
-	mon_put_default_kn_priv_all(rdtgrp, name);
-
 	kernfs_put(kn);
 
-	if (kn->dir.subdirs <= 1) {
+	if (kn->dir.subdirs <= 1)
 		kernfs_remove(kn);
-	} else {
-		mon_put_default_kn_priv_all(rdtgrp, subname);
+	else
 		kernfs_remove_by_name(kn, subname);
-	}
 }
 
 /*
@@ -3081,7 +3027,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 		return -EPERM;
 
 	list_for_each_entry(mevt, &r->evt_list, list) {
-		priv = mon_get_default_kn_priv(r, d, mevt, prgrp, do_sum);
+		priv = mon_get_kn_priv(r->rid, do_sum ? d->ci->id : d->hdr.id, mevt, do_sum);
 		if (WARN_ON_ONCE(!priv))
 			return -EINVAL;
 
@@ -3165,17 +3111,9 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	struct rdtgroup *prgrp, *crgrp;
 	struct list_head *head;
 
-	/*
-	 * During domain-online create the default control group first
-	 * so that mon_get_default_kn_priv() can find the allocated structure
-	 * on subsequent calls.
-	 */
-	mkdir_mondata_subdir(kn_mondata, d, r, &rdtgroup_default);
-
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		parent_kn = prgrp->mon.mon_data_kn;
-		if (prgrp != &rdtgroup_default)
-			mkdir_mondata_subdir(parent_kn, d, r, prgrp);
+		mkdir_mondata_subdir(parent_kn, d, r, prgrp);
 
 		head = &prgrp->mon.crdtgrp_list;
 		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
-- 
2.48.1

