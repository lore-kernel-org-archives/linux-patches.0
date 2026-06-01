Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6AD37FF5E
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343804; cv=none; b=CuLrBxDfeL2Gw2Us/IXIdt9g6T0mvlvfLDkfT/q3iLoTX6kF7Hvn9zxfEqMhIHZU9fRLCmvakcp/TyfzAKVRFEzvRTSwhaAo3ylE3wzuk1yw5MoWktjo7g5ul8G1SMfVGqhJ55CUhG8+4afxGz9qBnU/jjWQp+HdFN0wDEb4Xio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343804; c=relaxed/simple;
	bh=mwI/yhmgeN5/52KEyoVb6JwFkIjGCcVHBKa4n3GiI4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lypPFfLFRVNnnnEj2mF2VBzEu7nUlHNSjUkKahMxJjuQnsDIcr3STzHdM23A2o4DDnMHhcMHANnLCW9BUS84WWpAamh/VRL86rcb+8sY79mEiqfEkZ8kUkNLmeIryI9dp/s/hipNTQjnbrboF4LQqNkK8UTxQxcLjqq0Qb/gfHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gr5WipBH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gr5WipBH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343803; x=1811879803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mwI/yhmgeN5/52KEyoVb6JwFkIjGCcVHBKa4n3GiI4Y=;
  b=Gr5WipBHaiTDy6d9tZoLC7IMUTp/hcQam9dui3hE0M6Gu+bXkF2g7ATD
   HWZJs0T6gKkBR2GeyC6jBbVJlIgFnfSLteYjAN9xbSK/NptDxXizt+3oH
   kGI+scGSwd+3GEQ/4hfDbEZhwqleXIQ2/rhkqQpmbNQcMe+ELGjVsWogL
   lZl0acSPliNAPUKAB1LKOAH+/3BYLM005cpSnkOXjMRSRizDoHquQpwRl
   BSAeH7EaVaYz5KgiG/nbRrHmPwOav8ms4cUuxf7YR9wHKgkOtUXbP6WsK
   IKmSyb4hLOdEv9N9E9J12QMG5/gX8IO+pqWPNrOzZW3E8gz3CNaExp40B
   A==;
X-CSE-ConnectionGUID: iK6gNeTeSeG5h5Jd1wKTsA==
X-CSE-MsgGUID: jX8UGK8+QxyFo5C76PoZMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011587"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011587"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:41 -0700
X-CSE-ConnectionGUID: q0n2xr5jSnGO8/6ZNb5cQw==
X-CSE-MsgGUID: a13zFb1PT/O1PAvg970IIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946499"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:40 -0700
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
Subject: [PATCH v7 04/14] fs/resctrl: Fix deadlock for errors during mount
Date: Mon,  1 Jun 2026 12:56:22 -0700
Message-ID: <20260601195632.15876-5-tony.luck@intel.com>
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

From: Reinette Chatre <reinette.chatre@intel.com>

rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
the same thread before the call returns.  rdt_kill_sb() unconditionally
attempts to acquire rdtgroup_mutex and deadlock occurs.

Move the call to kernfs_get_tree() outside of locks. If kernfs_get_tree()
fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb() has already
been called and no further cleanup is needed.

Add an extra hold in this error path on rdtgroup_default.kn to defend against
other races destroying the root which is then dereferenced in kernfs_kill_sb()

Add resctrl_unmount() helper to keep code consistent between the
rdt_get_tree() failure path and a normal unmount.

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
 fs/resctrl/rdtgroup.c | 82 +++++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 27 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ac3285ba8775..d2a1f88d8782 100644
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
@@ -3075,10 +3095,37 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
-	goto out;
+	/*
+	 * Ensure root kn remains accessible after mutex is unlocked so that
+	 * kernfs_kill_sb() can run safely if called by kernfs_get_tree()'s
+	 * failure path after creating a superblock but before taking reference
+	 * on root kn.
+	 */
+	kernfs_get(rdtgroup_default.kn);
+
+	/*
+	 * Make backup of the current root kn being created to be used in kernfs_put().
+	 * The additional reference taken above will prevent the kn from being freed
+	 * before kernfs_kill_sb() can run but rdtgroup_default.kn may be set to NULL
+	 * via rdtgroup_destroy_root() and its backing root (rdt_root) could be overwritten
+	 * before kernfs_put() can run.
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
@@ -3098,7 +3145,6 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
-	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 	return ret;
@@ -3185,26 +3231,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
 
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

