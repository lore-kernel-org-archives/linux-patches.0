Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31584314B6D
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547912; cv=none; b=BOvMI61gBuwCIiqc+hLNbbZJDff1V9MC3Lbl3JWIyOD/luxP57QCsaZ8BglbuJEKoD0iCqpKUvGjkG7D3yz8eSPFu/RAjPZbsReFrDAubsTTGfmzcIEQ8UN3a8w80yNLU1hmDAKl/xBATRkwW09/lgoWcdvmUZP9PCyXGkiS4U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547912; c=relaxed/simple;
	bh=KxLowYXEe81y+BszRgYh51N7JWArxU6FgCVNOrdu17w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8pWW8EyB51DKSYShfdEfTIeoWNuM0cYEbULujkezlpduXpQxZWJoIaOt9gJLljHLgrgX6x0jSL90uPy88MFuI0sepRk/F+4R5abVhKBEP4rxxiclDP2dbkBU9qtngXgekIG9LTWpbTSiNpW6GZ8Cl4b//Rv52iQxigL3waMuTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pah+t+ty; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pah+t+ty"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547910; x=1813083910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KxLowYXEe81y+BszRgYh51N7JWArxU6FgCVNOrdu17w=;
  b=Pah+t+tyYdiZ4sBRSZpjw6DVmbpiuaArF9myCL303p+vwaGU9LMULv60
   +oD2LKsLc5q4IyUwvY0vGNFW6N0v4sDzES2LSBoLl/Ow9l6R2+9J3Tcmu
   y8aP9HojWLfWAcC7gr8HV29n1Cmg8e5KZmTR/F6xVBytCOclVBmfFpVnq
   1SaKHN5KVRtV8L6h0p98860tr1AuVA0eGgKBQzw5193g9+B8r1WbIE9Wk
   5caznoJFO5FvLjRHZQVI4zzm+1S7ZaqZwBMIGCNerVgLcLQdIkzHJqZt7
   YGzEPSCE2s9g+8BUzr8VPvK75wlpHkAvoE451OdCrAjePyfWZ/LaHKs3W
   A==;
X-CSE-ConnectionGUID: PM5rRSwOQFmS7Ngqj23dLA==
X-CSE-MsgGUID: N5NbHwivSLyj1lccf2/N7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789948"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789948"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:08 -0700
X-CSE-ConnectionGUID: 5NdOs2nxQ62DH8dFdu7H+w==
X-CSE-MsgGUID: G3zOsiMeR06CY0ZflQnqOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620613"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:07 -0700
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
	Sashiko <sashiko-bot@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v8 04/16] fs/resctrl: Fix deadlock on errors during mount
Date: Mon, 15 Jun 2026 11:24:45 -0700
Message-ID: <20260615182457.14725-5-tony.luck@intel.com>
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

From: Reinette Chatre <reinette.chatre@intel.com>

rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
superblock setup fails inside kernfs_get_tree(), the VFS calls .kill_sb()
(rdt_kill_sb()) on the same thread before kernfs_get_tree() returns.
rdt_kill_sb() unconditionally attempts to acquire rdtgroup_mutex and
deadlock occurs.

Since mount failure resulting from kernfs_get_tree() already calls the
resctrl fs unmount handler (rdt_kill_sb()) let both call the same helper
to make it clear both paths perform the same cleanup.

Call kernfs_get_tree() outside of locks. If kernfs_get_tree() fails and
ctx->kfc.new_sb_created is set, then rdt_kill_sb() has already been called
and no further cleanup is needed.

kernfs_get_tree() may set ctx->kfc.new_sb_created and then fail to obtain
an inode for the new kn, causing the rdt_kill_sb() path to run with one fewer
reference than required for the root to remain accessible in kernfs_kill_sb().
Add an extra hold on rdtgroup_default.kn to defend against this scenario
and ensure the root can be dereferenced safely from kernfs_kill_sb().

Dropping locks before kernfs_get_tree() creates a window where CPU hotplug
callbacks can race with the mount operation. Specifically, an online event
observing resctrl_mounted == true could concurrently append directories to
the unactivated kernfs tree, allocate mon_data structures, and arm background
workers.

This concurrency is safe because the mount has not yet returned to the VFS,
meaning userspace cannot interact with these transient files. If
kernfs_get_tree() subsequently fails, the standard resctrl_unmount() teardown
safely manages the concurrent modifications: any dynamically generated kernfs
nodes are removed, and the associated memory is freed. Any background
workers spawned by the hotplug event will naturally exit without re-arming
when they acquire rdtgroup_mutex and observe resctrl_mounted == false.

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
---
 fs/resctrl/rdtgroup.c | 83 +++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 27 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ac3285ba8775..a8f84b653607 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2977,10 +2977,34 @@ static void resctrl_fs_teardown(void)
 	rdtgroup_destroy_root();
 }
 
+static void resctrl_unmount(void)
+{
+	struct rdt_resource *r;
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	rdt_disable_ctx();
+
+	/* Put everything back to default values. */
+	for_each_alloc_capable_rdt_resource(r)
+		resctrl_arch_reset_all_ctrls(r);
+
+	resctrl_fs_teardown();
+	if (resctrl_arch_alloc_capable())
+		resctrl_arch_disable_alloc();
+	if (resctrl_arch_mon_capable())
+		resctrl_arch_disable_mon();
+	resctrl_mounted = false;
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+}
+
 static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 	unsigned long flags = RFTYPE_CTRL_BASE;
+	struct kernfs_node *rdt_root_kn;
 	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
 	int ret;
@@ -3056,10 +3080,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	ret = kernfs_get_tree(fc);
-	if (ret < 0)
-		goto out_psl;
-
 	if (resctrl_arch_alloc_capable())
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
@@ -3075,10 +3095,38 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
-	goto out;
+	/*
+	 * Ensure root remains accessible after mutex is unlocked so that
+	 * kernfs_kill_sb() can run safely if called by kernfs_get_tree()'s
+	 * failure path after creating a superblock but before taking reference
+	 * on root kn (for example, if unable to get inode for root kn).
+	 */
+	kernfs_get(rdtgroup_default.kn);
+
+	/*
+	 * Make backup of the current root kn being created to be used in
+	 * kernfs_put(). The additional reference taken above will prevent the
+	 * kn from being freed before kernfs_kill_sb() can run but
+	 * rdtgroup_default.kn may be set to NULL via rdtgroup_destroy_root()
+	 * and its backing root (rdt_root) could be overwritten before
+	 * kernfs_put() can run.
+	 */
+	rdt_root_kn = rdtgroup_default.kn;
+
+	rdt_last_cmd_clear();
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+
+	ret = kernfs_get_tree(fc);
+	/*
+	 * resctrl can only be mounted once, new superblock only expected
+	 * to be created once.
+	 */
+	if (!ctx->kfc.new_sb_created)
+		resctrl_unmount();
+	kernfs_put(rdt_root_kn);
+	return ret;
 
-out_psl:
-	rdt_pseudo_lock_release();
 out_mondata:
 	if (resctrl_arch_mon_capable())
 		kernfs_remove(kn_mondata);
@@ -3098,7 +3146,6 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
-	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 	return ret;
@@ -3185,26 +3232,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
 
 static void rdt_kill_sb(struct super_block *sb)
 {
-	struct rdt_resource *r;
-
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
-
-	rdt_disable_ctx();
-
-	/* Put everything back to default values. */
-	for_each_alloc_capable_rdt_resource(r)
-		resctrl_arch_reset_all_ctrls(r);
-
-	resctrl_fs_teardown();
-	if (resctrl_arch_alloc_capable())
-		resctrl_arch_disable_alloc();
-	if (resctrl_arch_mon_capable())
-		resctrl_arch_disable_mon();
-	resctrl_mounted = false;
+	resctrl_unmount();
 	kernfs_kill_sb(sb);
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 }
 
 static struct file_system_type rdt_fs_type = {
-- 
2.54.0

