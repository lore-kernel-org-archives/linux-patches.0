Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645093CF691
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577783; cv=none; b=VFIoiXMhWHh/i2pfhmRx7sUpVo4CJxlTAq3eb4xXGm7TCCcCPUFLWun+tWU5ckEYO7d4ALy5UPTFdFK1GcjOjfpUQjBQ8AYj/bj2yW9eqtrHPKArOBLdyTYTgezt6KF7JfPmM1InUX1AQjhd44JetOIwq02LeMLkriVyRtWGfKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577783; c=relaxed/simple;
	bh=ClrkB0PcIBu61gvXQBQnJibsI5pxz5caod8xkzFYwTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utrKgl+AxRgoemEbpRmHJRAal5duW3LMGgJX7kDjPv792YQpX5cPKchnK4KWemLpa+haWOYgVcdujmziIXCZUWsc57eoK8VPdCSzsDqKnK3HwG0rAp57mzJyBAV4vvq5gTz2Fm6oegPjPi9Sb7fi9f0QUluSchkocJuay0wq+CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KQP7T0ua; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KQP7T0ua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577773; x=1807113773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ClrkB0PcIBu61gvXQBQnJibsI5pxz5caod8xkzFYwTI=;
  b=KQP7T0uaPrW7Ev2Iurgs3aOlVgZmzpKq0cShmgIzBtABEV7CE46pluVV
   9ybs0nrKIZ4qBAmohcDDuVYMVk0JJB38tF73weF4Qg4fgKqm94+3a2Z9Q
   UxbPWZFaMHIBXeQ3XJW81hdoR9uxMU4b3pAjcnuibgKTx89SHs1fM1qNg
   R3TXtaACQLA6NnIAoCa9y7M+fe9IDaG8rFfQtnpOXfNaT1TT2C7g1MlTl
   INLxybmWPI26xfNVbhLcSuRmnqt03hl+DhCpaNvC9lX9XNYD0xvCFgebX
   FuLFfH1ZtMAPq44Ndd7+EDw5lOeSQaMcpI7QDvdaSfUiwey2h1Ywy+8WQ
   g==;
X-CSE-ConnectionGUID: WV2QOyUqTt6ypZACdtTPFw==
X-CSE-MsgGUID: 2jbnOUbTQDOAAOtEyDrCCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432751"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432751"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:19 -0700
X-CSE-ConnectionGUID: zBhJoni8TZGqbA/0WJ6/dg==
X-CSE-MsgGUID: biHFblZpTS21NMk+P00vBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119062"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 11/13] fs/resctrl: Change last_cmd_status custom during input parsing
Date: Tue,  7 Apr 2026 09:02:08 -0700
Message-ID: <3ac4f26326d704f5a31922b036e07e1b07b81763.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A pattern of usage of last_cmd_status was introduced during its enabling in
commit

c377dcfbee80 ("x86/intel_rdt: Add diagnostics when writing the schemata file")

and since copied throughout resctrl to result in the following custom:

	..._write()
	{
		/* Early parsing of input, exit on failure. */

		/* Obtain rdtgroup_mutex */
		rdt_last_cmd_clear(); /* Clear last_cmd_status buffer */

		/*
		 * Act on user command, failures result in detail
		 * error message in last_cmd_status buffer via
		 * rdt_last_cmd_puts()/rdt_last_cmd_printf().
		 */

		/* Release rdtgroup_mutex */
	}

If resctrl exits with failure during early parsing of input there are two
possible scenarios:
 - The last_cmd_status buffer is empty and a user's read of
   info/last_cmd_status returns "ok".
 - The last_cmd_status buffer contains details from an earlier ...write()
   failure and a user's read of info/last_cmd_status returns this outdated
   error description.

Writing to a resctrl file is considered a "resctrl command" and the
resctrl documentation states the following about the last_cmd_status file:
   "If the command failed, it will provide more information that can be
    conveyed in the error returns from file operations."
Neither of the current scenarios is correct behavior.

Move early input parsing to be done with rdtgroup_mutex held after the
last_cmd_status buffer is cleared. Let info/last_cmd_status be accurate
when an error is encountered during parsing of user command.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v1:
- Add Ben's RB tag.
---
 fs/resctrl/ctrlmondata.c | 54 ++++++++++++++++----------
 fs/resctrl/monitor.c     | 60 +++++++++++++++++------------
 fs/resctrl/rdtgroup.c    | 82 +++++++++++++++++++++++-----------------
 3 files changed, 117 insertions(+), 79 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 8a43efe67a95..5d5e844429df 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -312,11 +312,6 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	char *tok, *resname;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-	buf[nbytes - 1] = '\0';
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		rdtgroup_kn_unlock(of->kn);
@@ -324,6 +319,15 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	}
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	/*
 	 * No changes to pseudo-locked region allowed. It has to be removed
 	 * and re-created instead.
@@ -466,11 +470,6 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	struct rdtgroup *rdtgrp;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-	buf[nbytes - 1] = '\0';
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		rdtgroup_kn_unlock(of->kn);
@@ -478,6 +477,15 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	}
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	if (!strcmp(buf, "mbm_local_bytes")) {
 		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
 			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
@@ -495,6 +503,7 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	if (ret)
 		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
 
+out_unlock:
 	rdtgroup_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
@@ -854,15 +863,17 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 	bool enable;
 	int ret;
 
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
-
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
 	rdt_last_cmd_clear();
 
+	ret = kstrtobool(buf, &enable);
+	if (ret) {
+		rdt_last_cmd_puts("Invalid input\n");
+		goto out_unlock;
+	}
+
 	if (!r->cache.io_alloc_capable) {
 		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
 		ret = -ENODEV;
@@ -1018,16 +1029,19 @@ ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
 	u32 io_alloc_closid;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
-	buf[nbytes - 1] = '\0';
-
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	if (!r->cache.io_alloc_capable) {
 		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
 		ret = -ENODEV;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 101b2911d582..1a38f3b6a1f1 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1112,13 +1112,15 @@ ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf
 	bool value;
 	int ret;
 
-	ret = kstrtobool(buf, &value);
-	if (ret)
-		return ret;
-
 	mutex_lock(&rdtgroup_mutex);
 	rdt_last_cmd_clear();
 
+	ret = kstrtobool(buf, &value);
+	if (ret) {
+		rdt_last_cmd_puts("Invalid input\n");
+		goto out_unlock;
+	}
+
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
 		ret = -EINVAL;
@@ -1409,17 +1411,20 @@ ssize_t event_filter_write(struct kernfs_open_file *of, char *buf, size_t nbytes
 	u32 evt_cfg = 0;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
-	buf[nbytes - 1] = '\0';
-
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	r = resctrl_arch_get_resource(mevt->rid);
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
@@ -1478,17 +1483,20 @@ ssize_t resctrl_mbm_assign_mode_write(struct kernfs_open_file *of, char *buf,
 	int ret = 0;
 	bool enable;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
-	buf[nbytes - 1] = '\0';
-
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	if (!strcmp(buf, "default")) {
 		enable = 0;
 	} else if (!strcmp(buf, "mbm_event")) {
@@ -1759,12 +1767,6 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 	char *token, *event;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
-	buf[nbytes - 1] = '\0';
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		rdtgroup_kn_unlock(of->kn);
@@ -1772,10 +1774,19 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 	}
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rdt_last_cmd_puts("mbm_event mode is not enabled\n");
-		rdtgroup_kn_unlock(of->kn);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
 	while ((token = strsep(&buf, "\n")) != NULL) {
@@ -1791,6 +1802,7 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 			break;
 	}
 
+out_unlock:
 	rdtgroup_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5e3ea92cc243..755a46ef5bdb 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -512,38 +512,38 @@ static int cpus_ctrl_write(struct rdtgroup *rdtgrp, cpumask_var_t newmask,
 static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 				   char *buf, size_t nbytes, loff_t off)
 {
-	cpumask_var_t tmpmask, newmask, tmpmask1;
+	cpumask_var_t tmpmask = CPUMASK_VAR_NULL, newmask = CPUMASK_VAR_NULL;
+	cpumask_var_t tmpmask1 = CPUMASK_VAR_NULL;
 	struct rdtgroup *rdtgrp;
 	int ret;
 
-	if (!buf)
-		return -EINVAL;
-
-	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
-		return -ENOMEM;
-	if (!zalloc_cpumask_var(&newmask, GFP_KERNEL)) {
-		free_cpumask_var(tmpmask);
-		return -ENOMEM;
-	}
-	if (!zalloc_cpumask_var(&tmpmask1, GFP_KERNEL)) {
-		free_cpumask_var(tmpmask);
-		free_cpumask_var(newmask);
-		return -ENOMEM;
-	}
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		ret = -ENOENT;
-		goto unlock;
+		goto out_unlock;
 	}
 
 	rdt_last_cmd_clear();
 
+	if (!buf) {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL) ||
+	    !zalloc_cpumask_var(&newmask, GFP_KERNEL) ||
+	    !zalloc_cpumask_var(&tmpmask1, GFP_KERNEL)) {
+		rdt_last_cmd_puts("Kernel allocation failure\n");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED ||
 	    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
 		ret = -EINVAL;
 		rdt_last_cmd_puts("Pseudo-locking in progress\n");
-		goto unlock;
+		goto out_free;
 	}
 
 	if (is_cpu_list(of))
@@ -553,7 +553,7 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 
 	if (ret) {
 		rdt_last_cmd_puts("Bad CPU list/mask\n");
-		goto unlock;
+		goto out_free;
 	}
 
 	/* check that user didn't specify any offline cpus */
@@ -561,7 +561,7 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	if (!cpumask_empty(tmpmask)) {
 		ret = -EINVAL;
 		rdt_last_cmd_puts("Can only assign online CPUs\n");
-		goto unlock;
+		goto out_free;
 	}
 
 	if (rdtgrp->type == RDTCTRL_GROUP)
@@ -571,11 +571,12 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	else
 		ret = -EINVAL;
 
-unlock:
-	rdtgroup_kn_unlock(of->kn);
+out_free:
 	free_cpumask_var(tmpmask);
 	free_cpumask_var(newmask);
 	free_cpumask_var(tmpmask1);
+out_unlock:
+	rdtgroup_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
@@ -1452,11 +1453,6 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 	enum rdtgrp_mode mode;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-	buf[nbytes - 1] = '\0';
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		rdtgroup_kn_unlock(of->kn);
@@ -1464,6 +1460,14 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 	}
 
 	rdt_last_cmd_clear();
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	buf[nbytes - 1] = '\0';
 
 	mode = rdtgrp->mode;
 
@@ -1789,19 +1793,23 @@ static ssize_t mbm_total_bytes_config_write(struct kernfs_open_file *of,
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 	int ret;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	buf[nbytes - 1] = '\0';
 
 	ret = mon_config_write(r, buf, QOS_L3_MBM_TOTAL_EVENT_ID);
 
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 
@@ -1815,19 +1823,23 @@ static ssize_t mbm_local_bytes_config_write(struct kernfs_open_file *of,
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 	int ret;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	buf[nbytes - 1] = '\0';
 
 	ret = mon_config_write(r, buf, QOS_L3_MBM_LOCAL_EVENT_ID);
 
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 
-- 
2.50.1

