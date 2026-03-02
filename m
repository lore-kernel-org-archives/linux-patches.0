Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65052383C6D
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477197; cv=none; b=d/YkoFjK/m1D/gHsDVjcbrbEWz7MafCHm8kBoJz1MihRA8QUYFNMrRMqjOpfV/t70zTnIR8iIk1FMHnajSiP8+n6GUohkgifW5vlKnNmfiXJuTWZ497V3WgSzR7XCz7/13JKMORtB0EHr73IHgNArXaNU3GQiGwSb+xLUZclMGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477197; c=relaxed/simple;
	bh=/jyQh8Q6R02r9eO1ihb6qt+lfOWNdbA214wN+6np2WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVVhWb7pwMnGC/B0XsenIIJHgPxv582eVQi+amughqZyIMfyWAjKvDTAVJOL+FRhEB5I9Z4ZMMTYYkJG9HO5UQNGGMB1biouCPmA6/VGYw12t2vuvJui68JDCTHMoFjTXwVbLS71lHGXgVKWlAGBKynspgfTQrb9gW69g+wyyKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PoOiRm06; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PoOiRm06"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477195; x=1804013195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/jyQh8Q6R02r9eO1ihb6qt+lfOWNdbA214wN+6np2WQ=;
  b=PoOiRm06qRXWhUnmIyXboSD12glGAMQncYlzaTrVCf0COJeYblP73iSW
   e2ymDkVldkrTilqHw8Uq3YEMxncV1Ux1hlDvOD2gkyl9pYmq2KHCh9zqi
   4RR/L0GkFRAhmURg5v+n0KnGNY4p9RA5Rj8bxm8oqEXHxgpi4/nJCpfgN
   9q+fsbSFHbIihLGk100Jj2akG1rRrnWQ9fviTu6wnDqXsAn2Sjb4ppYUn
   XAleSt5vvkhLo/8FRP4BN+56zVlf/zD6y4N6ClNtyNHYH+Qn5rHIdin+h
   1zi+qpU9kBsfAx4ka7qkEeyPIE6CK6/sDWRimFCReo+XDfzz5NEpOy387
   Q==;
X-CSE-ConnectionGUID: 9+oVGqSNSGevA760iZKRdA==
X-CSE-MsgGUID: mm+wM8FzSryIsqWhz5f8CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135518"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135518"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:27 -0800
X-CSE-ConnectionGUID: vDWIpBknS/CUe0nF8kYEbQ==
X-CSE-MsgGUID: sU+P8ZM3QV+OhxmiNSRsHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604104"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
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
Subject: [PATCH 10/11] fs/resctrl: Change last_cmd_status custom during input parsing
Date: Mon,  2 Mar 2026 10:46:16 -0800
Message-ID: <021f736612186e9fd653d107b0642e8c1cf110d2.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
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
---
 fs/resctrl/ctrlmondata.c | 54 ++++++++++++++++----------
 fs/resctrl/monitor.c     | 60 ++++++++++++++++------------
 fs/resctrl/rdtgroup.c    | 84 +++++++++++++++++++++++-----------------
 3 files changed, 118 insertions(+), 80 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index a8e7cdcfec6e..7b90c36ff0a6 100644
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
@@ -1004,16 +1015,19 @@ ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
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
index f1a08fdbdd61..6c499a0bd435 100644
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
index f33a50c545bc..3b3acc748d03 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -511,38 +511,38 @@ static int cpus_ctrl_write(struct rdtgroup *rdtgrp, cpumask_var_t newmask,
 static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 				   char *buf, size_t nbytes, loff_t off)
 {
-	cpumask_var_t tmpmask, newmask, tmpmask1;
+	cpumask_var_t tmpmask = CPUMASK_VAR_NULL, newmask = CPUMASK_VAR_NULL;
+	cpumask_var_t tmpmask1 = CPUMASK_VAR_NULL;
 	struct rdtgroup *rdtgrp;
 	int ret;
 
-	if (!buf || nbytes == 0)
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
 
+	if (!buf || nbytes == 0) {
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
@@ -552,18 +552,18 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 
 	if (ret) {
 		rdt_last_cmd_puts("Bad CPU list/mask\n");
-		goto unlock;
+		goto out_free;
 	}
 
 	if (cpumask_empty(newmask))
-		goto unlock;
+		goto out_free;
 
 	/* check that user didn't specify any offline cpus */
 	cpumask_andnot(tmpmask, newmask, cpu_online_mask);
 	if (!cpumask_empty(tmpmask)) {
 		ret = -EINVAL;
 		rdt_last_cmd_puts("Can only assign online CPUs\n");
-		goto unlock;
+		goto out_free;
 	}
 
 	if (rdtgrp->type == RDTCTRL_GROUP)
@@ -573,11 +573,12 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
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
@@ -1457,11 +1458,6 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
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
@@ -1469,6 +1465,14 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
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
 
@@ -1794,19 +1798,23 @@ static ssize_t mbm_total_bytes_config_write(struct kernfs_open_file *of,
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
 
@@ -1820,19 +1828,23 @@ static ssize_t mbm_local_bytes_config_write(struct kernfs_open_file *of,
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

