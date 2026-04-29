Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B668537AA8E
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475216; cv=none; b=Md05oDCFNZP5TC522K5NLT4ONqD9p0ogQKGiz3kX9AEeDx5TXHLNEBGpxaGbHwTa5w+VXbtEsclR3pr2d0eZ00ycyJXVZtmui+IiIxL1w92kNH/mnxdxdZOMkGQn3DSYd2xGK6r6nk/6ktDhuS33+rGX4gTlDU9yUh7LqneKuhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475216; c=relaxed/simple;
	bh=3Adg0a/ffzd9vkO8eZLWDW54/0mR9Ia0jl60u5Zyr/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5k2vuEFkt+1sZxgGWFjRNifqX5Wek1dGOGSrR5ha9yq9nk3+fwPG2oxv9GzN9faMWKuiFN2HUcpcxWr0PLjJ+3nC4lEANb9NM0WeOsvk1dK+TAW7h+xPIy93o3VyRqxQ38pZpSQ7kb4lsXoZYcse3CFeWay4rHmaF2nz8UBocM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ebRBAyHr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ebRBAyHr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475214; x=1809011214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3Adg0a/ffzd9vkO8eZLWDW54/0mR9Ia0jl60u5Zyr/s=;
  b=ebRBAyHrQ7esYl0V79oEPO/fEHOozR0GMyKnUIThpQa/6ZQ0lzhXSjW7
   yTI4fbkLfUzzppHNVFhezlyjzbPZdwwLcEw6gw7MVBbb5MklJL1Bqowq7
   MM1ZdoPb2po+n/56XjmI4kVasa6T+YLTPlAD9ZkVI3srlyG3ctPejEckP
   3/YYIfpjClMRSlLudBrQoyM+m9ji8P58Mk7tQTDdAKOydcw1tKdhP6CC4
   VMtogvMDwf8Wxxc+o1EXrlCDaZlT2TZ1i+NPdnetny6hruxTSu9G2Kb3X
   Ibf5YeXqJ9hezqxFnr4KL78OM1CDwLWsFcSzVv5WRp4mAIjBOOUDWjwCV
   A==;
X-CSE-ConnectionGUID: QuRSr077QLee6jgRqKcJAQ==
X-CSE-MsgGUID: nBfcoIxwRE6vONK57jywUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424408"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424408"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: yfKmjQ7USK22n0i0MiQYMg==
X-CSE-MsgGUID: RvC6EU9sT6KfEWZVFoK3dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445025"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
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
Subject: [PATCH v4 09/10] fs/resctrl: Communicate resource group deleted error via last_cmd_status
Date: Wed, 29 Apr 2026 08:06:39 -0700
Message-ID: <9b55e2f83f4f779f02ae991da0859ae4b2b8df5d.1777419024.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1777419024.git.reinette.chatre@intel.com>
References: <cover.1777419024.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User space expects last_cmd_status to contain additional information if
any resctrl command fails.

A resctrl command may be blocked waiting on the rdtgroup_mutex waiting for
another command to finish and find that once the mutex is available that
the resource group has since been deleted. In this scenario the command
will fail while last_cmd_status contains either "ok" if the last_cmd_status
buffer is empty or an outdated error from a previous command failure if
last_cmd_status buffer has content.

Include clearing of last_cmd_status buffer as part of
rdtgroup_kn_lock_live() that is used to obtain access and needed locking
to a resource group before attempting a command on the group. With the
last_cmd_status buffer ready, provide an appropriate message to user space
if the resource group has been deleted.

No last_cmd_status treatment is needed for the remaining failure of
rdtgroup_kn_lock_live() encountering a non-existent resource group since
that could only occur during an attempt to obtain a resource group lock
on a file in info/ which is an invalid usage.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v1:
- Add snippet about why it is safe to dereference the kn to get
  to resource group name when resource group is deleted.
---
 fs/resctrl/ctrlmondata.c |  3 ---
 fs/resctrl/monitor.c     |  2 --
 fs/resctrl/rdtgroup.c    | 20 +++++++++++---------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 5d5e844429df..26bbf4ecdbca 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -317,7 +317,6 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
@@ -434,7 +433,6 @@ int rdtgroup_schemata_show(struct kernfs_open_file *of,
 			}
 		} else if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 			if (!rdtgrp->plr->d) {
-				rdt_last_cmd_clear();
 				rdt_last_cmd_puts("Cache domain offline\n");
 				ret = -ENODEV;
 			} else {
@@ -475,7 +473,6 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 1a38f3b6a1f1..88f1fa0b9d8d 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1632,7 +1632,6 @@ int mbm_L3_assignments_show(struct kernfs_open_file *of, struct seq_file *s, voi
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
 		ret = -EINVAL;
@@ -1772,7 +1771,6 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 755a46ef5bdb..0677e6e4102e 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -360,7 +360,6 @@ static int rdtgroup_cpus_show(struct kernfs_open_file *of,
 	if (rdtgrp) {
 		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 			if (!rdtgrp->plr->d) {
-				rdt_last_cmd_clear();
 				rdt_last_cmd_puts("Cache domain offline\n");
 				ret = -ENODEV;
 			} else {
@@ -523,8 +522,6 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
-
 	if (!buf) {
 		rdt_last_cmd_puts("Invalid input\n");
 		ret = -EINVAL;
@@ -781,7 +778,6 @@ static ssize_t rdtgroup_tasks_write(struct kernfs_open_file *of,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED ||
 	    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
@@ -1459,7 +1455,6 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 		return -ENOENT;
 	}
 
-	rdt_last_cmd_clear();
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
 		rdt_last_cmd_puts("Invalid input\n");
@@ -1596,7 +1591,6 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 		if (!rdtgrp->plr->d) {
-			rdt_last_cmd_clear();
 			rdt_last_cmd_puts("Cache domain offline\n");
 			ret = -ENODEV;
 		} else {
@@ -2634,10 +2628,20 @@ struct rdtgroup *rdtgroup_kn_lock_live(struct kernfs_node *kn)
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
 
 	/* Was this group deleted while we waited? */
-	if (rdtgrp->flags & RDT_DELETED)
+	if (rdtgrp->flags & RDT_DELETED) {
+		/*
+		 * It is safe to dereference kn to obtain the resource group's
+		 * name because one extra reference to kn is obtained
+		 * during resource group creation that will be released by
+		 * rdtgroup_remove() called by rdtgroup_kn_put().
+		 */
+		rdt_last_cmd_printf("Resource group %s deleted. No commands possible.\n",
+				    rdt_kn_name(rdtgrp->kn));
 		return NULL;
+	}
 
 	return rdtgrp;
 }
@@ -3760,8 +3764,6 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
-
 	/*
 	 * Check that the parent directory for a monitor group is a "mon_groups"
 	 * directory.
-- 
2.50.1

