Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC78D31355C
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547909; cv=none; b=hJKLlANrq0zC5+mrZK5vRJo47Hhn6AyI9PJ0nPOi1+1wbMby9dNOLEnqf5OE0mf7yfvoiatbHjTto/SxtCw1z6BpW8XA86qWMVqZQ9SZfkiUZUXREovNN2xj+1SCq801UvZBEViDPhO0sis3x7UTClarSSPyy7x0EBInX0oXqOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547909; c=relaxed/simple;
	bh=O5uisUIU0S7xYoADy958jPSZY+kSfiqxIs0NzJ2DqfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOWE8PmeMQcsGakkRfMoEpQM+nsDOYvqBa+AD7oxJR9XtuMuD3fpJv3eZx7o53gAQU/cjPo0q9L/6Xy10KWbpfmmFz4JXoFVOnqCjv35qO5eXfCWAqvKL+4+9swlSfUpyezEu+w3tVXOnM31/x4HVBUjnDCKumC8YsF7IXk9GZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SdcpAksX; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SdcpAksX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547907; x=1813083907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O5uisUIU0S7xYoADy958jPSZY+kSfiqxIs0NzJ2DqfM=;
  b=SdcpAksXNsL+QXT2iMXh4oDQyw/yg6kY7D/XS56WVe0avdZKzAF8WRdO
   JyTw5D1X4l+sXgbQ9kaGc2bk7MwlPZ6Zhy/zvqjzZqvCMRO6Hot86xlAK
   qHjmzWzl6bJGN6ylSZq+ZUejICZOtrjPQu1Rby/qebYpVsNvgus5bxE5K
   4blXPnLrKaVDO8ZoeN0AUG0hXLiI23L34poOjLWnDQmUceqTJ0g5uGS8h
   10+djf87+5laD0GqgviY86BEToLKjbmoyu/iIEzoAa13fNIinOHaGBe5S
   yS8PNidNG4WP6jXN/OwYX51exlS8RNKJmZ1Tu9QG+2KejSEbkdHAdMUj2
   g==;
X-CSE-ConnectionGUID: UY1M7rEbS1WVTgZewp/chA==
X-CSE-MsgGUID: HXgYGobLTOq/bEQ8oPEMwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789919"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789919"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:06 -0700
X-CSE-ConnectionGUID: 9LIU0lkNRhGvg/3aKuAT6Q==
X-CSE-MsgGUID: eBAGd1vORO2KX5rWjyEFww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620581"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:05 -0700
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
Subject: [PATCH v8 01/16] fs/resctrl: Move functions to avoid forward references in subsequent fixes
Date: Mon, 15 Jun 2026 11:24:42 -0700
Message-ID: <20260615182457.14725-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
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

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
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

