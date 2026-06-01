Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADCE37107E
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343803; cv=none; b=r77tkAUg53Q4Ihzoe3TupLPSIF3kWgdnerhcyEp+hhPLM7TJHoz6L24USV3Y3pBo3Al4Q+aIfjDxJ1SqnaxldugECYyUftJlVmTbb8GMe+merqRjBo7Z7onr9Z78SM1kqY2Yd6HNxNOFOVC0QbV1DGAUyJAfI9W3XWIUEW3Hpyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343803; c=relaxed/simple;
	bh=zPG4u17CSmDapJsSjj03W/tkwWISS3PaKghXdND+0pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1EBbO4PxEmh9f1olyun4d8QVLdtRuKrmIM5Xx1NYYoFmnJ0oArUUVqEy8hEhGIjg4JBXZzUBFvgwOtUqBPT4UL0JKf5MdgS8QWV3SyVVWBJYNVnwoaYcoedwDDzlxrAdE+zxrcgXkKxHDRvelVN2KkYfilP/n89zMFrywnGTyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fWa3YD0U; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fWa3YD0U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343801; x=1811879801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zPG4u17CSmDapJsSjj03W/tkwWISS3PaKghXdND+0pI=;
  b=fWa3YD0UCuOEKimAOWuXbNcwLF98LzZrH8q5Nl2khVYZ4TMtfkBaAfSO
   DDjbQnV95vCMffc4xUATYXtebo5BbVLHQHIzrZeTAMcyD8HVu6UnCH8Ww
   flx2zAgno99N2JWLkTAc+JIxG7bl+55ROrQ3vYudircoALjrgJXe7raL+
   5nNbdmd8l1/BOIDaR/HiP8Ddqxwq2t/42akxJvhXqRp1ArOea5fQzw6sT
   TLAZztN89UyViveLn/WpXud/GPOrc59QE3QQ0yE/D/dpklLTs2dO99y+l
   yU7SypDE/KDVVVnyMpLR+hWusPA74OOGdiCdz5JD2AQrqTmp1QO3AhIFX
   g==;
X-CSE-ConnectionGUID: vtCFX9qmQ9OrB23tyJjj9A==
X-CSE-MsgGUID: EbZ5pXujSVmCrt5Dcrakkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011559"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011559"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:40 -0700
X-CSE-ConnectionGUID: fpnQP2SVTrSXGloqeKVDOg==
X-CSE-MsgGUID: ysw3RAWaQ1CZupdO/ev81Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946489"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v7 01/14] fs/resctrl: Move functions to avoid forward references in subsequent fixes
Date: Mon,  1 Jun 2026 12:56:19 -0700
Message-ID: <20260601195632.15876-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601195632.15876-1-tony.luck@intel.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rdt_get_tree() manages resctrl fs mount and rdt_kill_sb() manages resctrl
fs unmount.

There is significant overlap between error cleanup during resctrl mount
failure and cleanup on resctrl unmount yet the cleanup is not done
consistently in these two flows.

Pull some cleanup functions before rdt_get_tree() in preparation for
a new helper that can be shared between mount and unmount.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
 fs/resctrl/rdtgroup.c | 376 +++++++++++++++++++++---------------------
 1 file changed, 188 insertions(+), 188 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dfdaa6f9d8f..a6376a3fc4c3 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2782,6 +2782,194 @@ static void schemata_list_destroy(void)
 	}
 }
 
+/*
+ * Move tasks from one to the other group. If @from is NULL, then all tasks
+ * in the systems are moved unconditionally (used for teardown).
+ *
+ * If @mask is not NULL the cpus on which moved tasks are running are set
+ * in that mask so the update smp function call is restricted to affected
+ * cpus.
+ */
+static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
+				 struct cpumask *mask)
+{
+	struct task_struct *p, *t;
+
+	read_lock(&tasklist_lock);
+	for_each_process_thread(p, t) {
+		if (!from || is_closid_match(t, from) ||
+		    is_rmid_match(t, from)) {
+			resctrl_arch_set_closid_rmid(t, to->closid,
+						     to->mon.rmid);
+
+			/*
+			 * Order the closid/rmid stores above before the loads
+			 * in task_curr(). This pairs with the full barrier
+			 * between the rq->curr update and
+			 * resctrl_arch_sched_in() during context switch.
+			 */
+			smp_mb();
+
+			/*
+			 * If the task is on a CPU, set the CPU in the mask.
+			 * The detection is inaccurate as tasks might move or
+			 * schedule before the smp function call takes place.
+			 * In such a case the function call is pointless, but
+			 * there is no other side effect.
+			 */
+			if (IS_ENABLED(CONFIG_SMP) && mask && task_curr(t))
+				cpumask_set_cpu(task_cpu(t), mask);
+		}
+	}
+	read_unlock(&tasklist_lock);
+}
+
+static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
+{
+	struct rdtgroup *sentry, *stmp;
+	struct list_head *head;
+
+	head = &rdtgrp->mon.crdtgrp_list;
+	list_for_each_entry_safe(sentry, stmp, head, mon.crdtgrp_list) {
+		rdtgroup_unassign_cntrs(sentry);
+		free_rmid(sentry->closid, sentry->mon.rmid);
+		list_del(&sentry->mon.crdtgrp_list);
+
+		if (atomic_read(&sentry->waitcount) != 0)
+			sentry->flags = RDT_DELETED;
+		else
+			rdtgroup_remove(sentry);
+	}
+}
+
+/*
+ * Forcibly remove all of subdirectories under root.
+ */
+static void rmdir_all_sub(void)
+{
+	struct rdtgroup *rdtgrp, *tmp;
+
+	/* Move all tasks to the default resource group */
+	rdt_move_group_tasks(NULL, &rdtgroup_default, NULL);
+
+	list_for_each_entry_safe(rdtgrp, tmp, &rdt_all_groups, rdtgroup_list) {
+		/* Free any child rmids */
+		free_all_child_rdtgrp(rdtgrp);
+
+		/* Remove each rdtgroup other than root */
+		if (rdtgrp == &rdtgroup_default)
+			continue;
+
+		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
+		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
+			rdtgroup_pseudo_lock_remove(rdtgrp);
+
+		/*
+		 * Give any CPUs back to the default group. We cannot copy
+		 * cpu_online_mask because a CPU might have executed the
+		 * offline callback already, but is still marked online.
+		 */
+		cpumask_or(&rdtgroup_default.cpu_mask,
+			   &rdtgroup_default.cpu_mask, &rdtgrp->cpu_mask);
+
+		rdtgroup_unassign_cntrs(rdtgrp);
+
+		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
+
+		kernfs_remove(rdtgrp->kn);
+		list_del(&rdtgrp->rdtgroup_list);
+
+		if (atomic_read(&rdtgrp->waitcount) != 0)
+			rdtgrp->flags = RDT_DELETED;
+		else
+			rdtgroup_remove(rdtgrp);
+	}
+	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
+	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
+
+	kernfs_remove(kn_info);
+	kernfs_remove(kn_mongrp);
+	kernfs_remove(kn_mondata);
+}
+
+/**
+ * mon_get_kn_priv() - Get the mon_data priv data for this event.
+ *
+ * The same values are used across the mon_data directories of all control and
+ * monitor groups for the same event in the same domain. Keep a list of
+ * allocated structures and re-use an existing one with the same values for
+ * @rid, @domid, etc.
+ *
+ * @rid:    The resource id for the event file being created.
+ * @domid:  The domain id for the event file being created.
+ * @mevt:   The type of event file being created.
+ * @do_sum: Whether SNC summing monitors are being created. Only set
+ *	    when @rid == RDT_RESOURCE_L3.
+ *
+ * Return: Pointer to mon_data private data of the event, NULL on failure.
+ */
+static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
+					struct mon_evt *mevt,
+					bool do_sum)
+{
+	struct mon_data *priv;
+
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
+		if (priv->rid == rid && priv->domid == domid &&
+		    priv->sum == do_sum && priv->evt == mevt)
+			return priv;
+	}
+
+	priv = kzalloc_obj(*priv);
+	if (!priv)
+		return NULL;
+
+	priv->rid = rid;
+	priv->domid = domid;
+	priv->sum = do_sum;
+	priv->evt = mevt;
+	list_add_tail(&priv->list, &mon_data_kn_priv_list);
+
+	return priv;
+}
+
+/**
+ * mon_put_kn_priv() - Free all allocated mon_data structures.
+ *
+ * Called when resctrl file system is unmounted.
+ */
+static void mon_put_kn_priv(void)
+{
+	struct mon_data *priv, *tmp;
+
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	list_for_each_entry_safe(priv, tmp, &mon_data_kn_priv_list, list) {
+		list_del(&priv->list);
+		kfree(priv);
+	}
+}
+
+static void resctrl_fs_teardown(void)
+{
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	/* Cleared by rdtgroup_destroy_root() */
+	if (!rdtgroup_default.kn)
+		return;
+
+	rmdir_all_sub();
+	rdtgroup_unassign_cntrs(&rdtgroup_default);
+	mon_put_kn_priv();
+	rdt_pseudo_lock_release();
+	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
+	closid_exit();
+	schemata_list_destroy();
+	rdtgroup_destroy_root();
+}
+
 static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
@@ -2981,194 +3169,6 @@ static int rdt_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
-/*
- * Move tasks from one to the other group. If @from is NULL, then all tasks
- * in the systems are moved unconditionally (used for teardown).
- *
- * If @mask is not NULL the cpus on which moved tasks are running are set
- * in that mask so the update smp function call is restricted to affected
- * cpus.
- */
-static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
-				 struct cpumask *mask)
-{
-	struct task_struct *p, *t;
-
-	read_lock(&tasklist_lock);
-	for_each_process_thread(p, t) {
-		if (!from || is_closid_match(t, from) ||
-		    is_rmid_match(t, from)) {
-			resctrl_arch_set_closid_rmid(t, to->closid,
-						     to->mon.rmid);
-
-			/*
-			 * Order the closid/rmid stores above before the loads
-			 * in task_curr(). This pairs with the full barrier
-			 * between the rq->curr update and
-			 * resctrl_arch_sched_in() during context switch.
-			 */
-			smp_mb();
-
-			/*
-			 * If the task is on a CPU, set the CPU in the mask.
-			 * The detection is inaccurate as tasks might move or
-			 * schedule before the smp function call takes place.
-			 * In such a case the function call is pointless, but
-			 * there is no other side effect.
-			 */
-			if (IS_ENABLED(CONFIG_SMP) && mask && task_curr(t))
-				cpumask_set_cpu(task_cpu(t), mask);
-		}
-	}
-	read_unlock(&tasklist_lock);
-}
-
-static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
-{
-	struct rdtgroup *sentry, *stmp;
-	struct list_head *head;
-
-	head = &rdtgrp->mon.crdtgrp_list;
-	list_for_each_entry_safe(sentry, stmp, head, mon.crdtgrp_list) {
-		rdtgroup_unassign_cntrs(sentry);
-		free_rmid(sentry->closid, sentry->mon.rmid);
-		list_del(&sentry->mon.crdtgrp_list);
-
-		if (atomic_read(&sentry->waitcount) != 0)
-			sentry->flags = RDT_DELETED;
-		else
-			rdtgroup_remove(sentry);
-	}
-}
-
-/*
- * Forcibly remove all of subdirectories under root.
- */
-static void rmdir_all_sub(void)
-{
-	struct rdtgroup *rdtgrp, *tmp;
-
-	/* Move all tasks to the default resource group */
-	rdt_move_group_tasks(NULL, &rdtgroup_default, NULL);
-
-	list_for_each_entry_safe(rdtgrp, tmp, &rdt_all_groups, rdtgroup_list) {
-		/* Free any child rmids */
-		free_all_child_rdtgrp(rdtgrp);
-
-		/* Remove each rdtgroup other than root */
-		if (rdtgrp == &rdtgroup_default)
-			continue;
-
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			rdtgroup_pseudo_lock_remove(rdtgrp);
-
-		/*
-		 * Give any CPUs back to the default group. We cannot copy
-		 * cpu_online_mask because a CPU might have executed the
-		 * offline callback already, but is still marked online.
-		 */
-		cpumask_or(&rdtgroup_default.cpu_mask,
-			   &rdtgroup_default.cpu_mask, &rdtgrp->cpu_mask);
-
-		rdtgroup_unassign_cntrs(rdtgrp);
-
-		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
-
-		kernfs_remove(rdtgrp->kn);
-		list_del(&rdtgrp->rdtgroup_list);
-
-		if (atomic_read(&rdtgrp->waitcount) != 0)
-			rdtgrp->flags = RDT_DELETED;
-		else
-			rdtgroup_remove(rdtgrp);
-	}
-	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
-	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
-
-	kernfs_remove(kn_info);
-	kernfs_remove(kn_mongrp);
-	kernfs_remove(kn_mondata);
-}
-
-/**
- * mon_get_kn_priv() - Get the mon_data priv data for this event.
- *
- * The same values are used across the mon_data directories of all control and
- * monitor groups for the same event in the same domain. Keep a list of
- * allocated structures and re-use an existing one with the same values for
- * @rid, @domid, etc.
- *
- * @rid:    The resource id for the event file being created.
- * @domid:  The domain id for the event file being created.
- * @mevt:   The type of event file being created.
- * @do_sum: Whether SNC summing monitors are being created. Only set
- *	    when @rid == RDT_RESOURCE_L3.
- *
- * Return: Pointer to mon_data private data of the event, NULL on failure.
- */
-static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
-					struct mon_evt *mevt,
-					bool do_sum)
-{
-	struct mon_data *priv;
-
-	lockdep_assert_held(&rdtgroup_mutex);
-
-	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
-		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evt == mevt)
-			return priv;
-	}
-
-	priv = kzalloc_obj(*priv);
-	if (!priv)
-		return NULL;
-
-	priv->rid = rid;
-	priv->domid = domid;
-	priv->sum = do_sum;
-	priv->evt = mevt;
-	list_add_tail(&priv->list, &mon_data_kn_priv_list);
-
-	return priv;
-}
-
-/**
- * mon_put_kn_priv() - Free all allocated mon_data structures.
- *
- * Called when resctrl file system is unmounted.
- */
-static void mon_put_kn_priv(void)
-{
-	struct mon_data *priv, *tmp;
-
-	lockdep_assert_held(&rdtgroup_mutex);
-
-	list_for_each_entry_safe(priv, tmp, &mon_data_kn_priv_list, list) {
-		list_del(&priv->list);
-		kfree(priv);
-	}
-}
-
-static void resctrl_fs_teardown(void)
-{
-	lockdep_assert_held(&rdtgroup_mutex);
-
-	/* Cleared by rdtgroup_destroy_root() */
-	if (!rdtgroup_default.kn)
-		return;
-
-	rmdir_all_sub();
-	rdtgroup_unassign_cntrs(&rdtgroup_default);
-	mon_put_kn_priv();
-	rdt_pseudo_lock_release();
-	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
-	closid_exit();
-	schemata_list_destroy();
-	rdtgroup_destroy_root();
-}
-
 static void rdt_kill_sb(struct super_block *sb)
 {
 	struct rdt_resource *r;
-- 
2.54.0

