Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E97C34B43F
	for <patches@lists.linux.dev>; Mon, 13 Jul 2026 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783964431; cv=none; b=pHznSbO8LJAD+C0L285jY49mqdNcbIMcg7bmCEFTKgfp9oemC6MpBNwLIA8JBG/jTgxwtYNB2Iod6ciPj6lNoyUBCBvyD4B1SmyawLgRtaXKti3LVqJdsZmZU24gk5yEOSXrWBboqdsC+MMPG4xoOmls2oGiFeNUdN4BTDKPRw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783964431; c=relaxed/simple;
	bh=c6w5CK9GPmNnmpO5DfslC4xWiuP2PXx6PbTov7+zUIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUNW2l79sjF+2bCH7PHQ+HqhUBDkT5EIjdO83ylJjkbP4hq3BwJ5+K7X7X1VWYoMyoHLuvjjKJXVn4DdKk8boC7xPm0Dq1bRrUZOflKycrXBF1dNU07KRwuEcKkfMbigjarkCZrjhqHNmx2S81n36WKZ38p9F1Hsb52Bsp6KKNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MmGyo94O; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MmGyo94O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783964429; x=1815500429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c6w5CK9GPmNnmpO5DfslC4xWiuP2PXx6PbTov7+zUIU=;
  b=MmGyo94O4nIXSCHJvpyf3wuO8hJvjNWKOAjSlsTnQ7fzmTEtaqb+avr4
   FUzsaC6IuvaXj+k3fddxsoh5mi6JhUe4zgku2RlKTj0aVBIa9HKmVatIl
   /aRzgCVcfPWQS/Q6cphI4CTfILMWa9sDTCLfnqhIoWtqcVXC4N2KcfCq5
   rpIrPWVvQ15S3cCXPWbq63Xs6niHMu6wM+ZIFcXgc4OrX6+rfzO6BBDph
   w3JSwilgVZu3OHhKwQMluokBetUAjimN5ye8Wgpc66LXDZuDRslivFHn/
   Wx7VcJ20alVN5fPjy59fUqjP9qX5+4aAIQVXxR7HJ3XXfgRZ0D/wqA+mD
   A==;
X-CSE-ConnectionGUID: t+7FGo3tR6iiXvjsNWKVFA==
X-CSE-MsgGUID: s6a4rbuERfG+5u6APpYjBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="107375528"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="107375528"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:26 -0700
X-CSE-ConnectionGUID: QeQu0764RVqRlTajDf9GnA==
X-CSE-MsgGUID: PjkarBhdTniscS1R6H6VCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254483884"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:25 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v7 2/7] fs/resctrl: Move functions to avoid forward references in subsequent fixes
Date: Mon, 13 Jul 2026 10:39:38 -0700
Message-ID: <af10101be95679e1d69ce4efc3edf980a6cc37cc.1783963505.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783963505.git.reinette.chatre@intel.com>
References: <cover.1783963505.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tony Luck <tony.luck@intel.com>

rdt_get_tree() manages resctrl fs mount and rdt_kill_sb() manages resctrl
fs unmount.

There is significant overlap between error cleanup during resctrl mount
failure and cleanup on resctrl unmount yet the cleanup is not done
consistently in these two flows.

Pull some cleanup functions before rdt_get_tree() in preparation for
a new helper that can be shared between mount and unmount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since V2:
- Rewrite changelog.

Changes since V3:
- Add Ben's Reviewed-by tag.

Changes since V5:
- Remove mon_put_kn_priv() forward declaration added in v6 to support
  backporting of portion of series.
---
 fs/resctrl/rdtgroup.c | 384 +++++++++++++++++++++---------------------
 1 file changed, 191 insertions(+), 193 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5a0d69636d87..9804e40ad36d 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -74,8 +74,6 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx);
 
 static void rdtgroup_destroy_root(void);
 
-static void mon_put_kn_priv(void);
-
 struct dentry *debugfs_resctrl;
 
 /*
@@ -2800,6 +2798,197 @@ static void schemata_list_destroy(void)
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
+		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
+		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
+			rdtgroup_pseudo_lock_remove(rdtgrp);
+		} else {
+			/* Pseudo-locked group's RMID is freed during setup. */
+			free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
+		}
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
+	rdtgroup_default.flags = RDT_DELETED;
+	closid_exit();
+	schemata_list_destroy();
+	rdtgroup_destroy_root();
+}
+
 static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
@@ -3006,197 +3195,6 @@ static int rdt_init_fs_context(struct fs_context *fc)
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
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
-			rdtgroup_pseudo_lock_remove(rdtgrp);
-		} else {
-			/* Pseudo-locked group's RMID is freed during setup. */
-			free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
-		}
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
-	rdtgroup_default.flags = RDT_DELETED;
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

