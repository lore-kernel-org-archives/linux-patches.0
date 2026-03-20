Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBD2381AE7
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044245; cv=none; b=b3bPg3ww6l/Ox11D4jZj6wdB60aExq0y9EVw8hCb0DznXDG/lBChFwMXoYXz9sqdlfP4g9IkWLoZ8DNxv5g7b8MgfiUw+4/NosPG77U5L7UAb+pNgtHiQxdPWADoKksb+uGCbC8pmpVFl6Gpzpw7fDFENGtu/HblGvigSy2oQvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044245; c=relaxed/simple;
	bh=nFf5lyjZOmv1Kwhc8O1v5V+0vN0yj3DlyLSNBpRiX4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYHi4YlxmI/PWHoUK6g0Z8EeyonK1Irzc9RSc5xCMBASqMHPCWwbOuw92oj1czjPs21BF4DxAn+Sh4gIBTdkukqd9YPhqNfKIwI2jSxjY4uhq7Z4DCWcOU936PuJVHFL9shW+wOhJuyVHDvPiTP4oNCznvy+uiVUFPtlGRU6GA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TxI00kJU; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TxI00kJU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044243; x=1805580243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nFf5lyjZOmv1Kwhc8O1v5V+0vN0yj3DlyLSNBpRiX4o=;
  b=TxI00kJUOQwzeXN3VfbT/vwbKc5HbDBNrlyl+SLXFUW/mfVW3RyAJSze
   cPmSHYFyUeoVaUa48/S3cnqNqTqNYIIk5vSw5fwgvEUF6GDvXmjgEYCp1
   g+ILL0DnjdZg6fcHx8dRErONNxzd2KppyoPvdWwTmgp6vZXBZgXCxGTqk
   Q2GXqbjvXzf66NJnEUsz3rQrvBNoBkCUMUf7m9wbwKhEx7KjLS/j6XBS3
   l1j4Xb6xwueoIdeGwPSrQ+1HOVbqye3AZLmbOjWqeCSoiUEUM6b9k1wFe
   Kl2je/45ui9wufOYDOyWUeaebB/RZKg0NHEpMr5j13d+cKSvaGBc4Lxh5
   Q==;
X-CSE-ConnectionGUID: 5AcZ1OHwRoCKCHzWR3dp0w==
X-CSE-MsgGUID: P4lqXbpmTJ6kx91cCnEhMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758459"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758459"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:57 -0700
X-CSE-ConnectionGUID: tPfDtAp0Qm6bYGPu1sBI/w==
X-CSE-MsgGUID: Pz2u+9iYSduaYSRWlV1y0w==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:57 -0700
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
Subject: [PATCH v2 13/14] fs/resctrl: Communicate resource group deleted error via last_cmd_status
Date: Fri, 20 Mar 2026 15:03:23 -0700
Message-ID: <1c78707dd99102518b3205d03f0bfce611d96e6d.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
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
index 5100a8bb16f3..0f753a820702 100644
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
@@ -2639,10 +2633,20 @@ struct rdtgroup *rdtgroup_kn_lock_live(struct kernfs_node *kn)
 
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
@@ -3765,8 +3769,6 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
-
 	/*
 	 * Check that the parent directory for a monitor group is a "mon_groups"
 	 * directory.
-- 
2.50.1

