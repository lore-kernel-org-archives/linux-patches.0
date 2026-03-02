Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB23387574
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477197; cv=none; b=n1tWMxp9j8ejIrGwE05y3tpUo/6QcVMAlnWLzfdnvS/qCO/bA4DSm4FmBMLWJ1zxhUtX88d8tZVNHZikjsWpMGiD/KCvjmYH0EKQhuHiIIv6xV6BskrY61/KHeZjLCCNmfN1N6kFHoKIX9WiRPX2gH0SpKnRQJnbNu5ijUjyowA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477197; c=relaxed/simple;
	bh=z+I4Oh28rTlzW4CAMClsLNIZcZbgb28hRpbqm0vRka4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+pyd049X6Y7P1nL0d+nBw2oJd4qrQo40qXsk/UFXUcP3iG3xwdDJ/mvRNlwStqMzY/rH6s7DKnOgMG1EDGqUrv2x3IlS2iS7935Xj9o3JaSnupWpUnzcQEX+xWI4MuNuqIcvmgOnUqe2bnwLTbqt2tuPQUX7ezH2oV7h4lT/14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S4kbU/lb; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S4kbU/lb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477195; x=1804013195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z+I4Oh28rTlzW4CAMClsLNIZcZbgb28hRpbqm0vRka4=;
  b=S4kbU/lb803+Q475Mu/kA2FvDsZyghCJoderwHuqWUmTFMiX3w8Rz5BB
   0K/c2DVvdJqMoujqF69d1E92ajtvhKIIR8mauscT84wh2jxYIeGrnVxmf
   cYd2cW6z4VFnu9sjE69FPN4b2ZnsmRHfNbpXXNl7cGsJxRpF7kvzVQvQl
   mlP7Fl+SHA/7ZulIO2K1D7T5DEC8igZKxkvQ1Je36ZcbxIeNErl3B/qBc
   rzfPZVMBpWF8sUN/SSgTCStqhDG+b2tRdbcFyewBH+oKzrsXUxccpdxV9
   Fit4eVIk42LIBxiRe3l1nVj2DX9edAPdQikndxV1H7xQZRrdXUCrmp2An
   w==;
X-CSE-ConnectionGUID: 4Oeh5T8nQKiO6/bkgmPYEQ==
X-CSE-MsgGUID: LNqN2aF/S/GAPDECW6KpKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135530"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135530"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:27 -0800
X-CSE-ConnectionGUID: uGAxpUKASqiLqiHIjSHJtA==
X-CSE-MsgGUID: PIXfq16aSIuuUlWyNKAmcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604107"
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
Subject: [PATCH 11/11] fs/resctrl: Communicate resource group deleted error via last_cmd_status
Date: Mon,  2 Mar 2026 10:46:17 -0800
Message-ID: <f5d06640a0c0a43601abb3be3593a20dcef56ea6.1772476561.git.reinette.chatre@intel.com>
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
 fs/resctrl/ctrlmondata.c |  3 ---
 fs/resctrl/monitor.c     |  2 --
 fs/resctrl/rdtgroup.c    | 14 +++++---------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 7b90c36ff0a6..9915f714e26a 100644
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
index 6c499a0bd435..73893a7e14e0 100644
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
index 3b3acc748d03..09d688bee0a3 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -359,7 +359,6 @@ static int rdtgroup_cpus_show(struct kernfs_open_file *of,
 	if (rdtgrp) {
 		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 			if (!rdtgrp->plr->d) {
-				rdt_last_cmd_clear();
 				rdt_last_cmd_puts("Cache domain offline\n");
 				ret = -ENODEV;
 			} else {
@@ -522,8 +521,6 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
-
 	if (!buf || nbytes == 0) {
 		rdt_last_cmd_puts("Invalid input\n");
 		ret = -EINVAL;
@@ -783,7 +780,6 @@ static ssize_t rdtgroup_tasks_write(struct kernfs_open_file *of,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED ||
 	    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
@@ -1464,7 +1460,6 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 		return -ENOENT;
 	}
 
-	rdt_last_cmd_clear();
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
 		rdt_last_cmd_puts("Invalid input\n");
@@ -1601,7 +1596,6 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 		if (!rdtgrp->plr->d) {
-			rdt_last_cmd_clear();
 			rdt_last_cmd_puts("Cache domain offline\n");
 			ret = -ENODEV;
 		} else {
@@ -2639,10 +2633,14 @@ struct rdtgroup *rdtgroup_kn_lock_live(struct kernfs_node *kn)
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
 
 	/* Was this group deleted while we waited? */
-	if (rdtgrp->flags & RDT_DELETED)
+	if (rdtgrp->flags & RDT_DELETED) {
+		rdt_last_cmd_printf("Resource group %s deleted. No commands possible.\n",
+				    rdt_kn_name(rdtgrp->kn));
 		return NULL;
+	}
 
 	return rdtgrp;
 }
@@ -3765,8 +3763,6 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
-
 	/*
 	 * Check that the parent directory for a monitor group is a "mon_groups"
 	 * directory.
-- 
2.50.1

