Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897D23803DE
	for <patches@lists.linux.dev>; Fri, 15 May 2026 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778873996; cv=none; b=O//BZWywN/1k3THLhadZP52vEw7gJlsFuPeji8bB2GZqv9Bu/w3TaBoH6bmCqh/pQAs5cstkr+DNeAMgqQLPSdJMSmT1rS363+uLnmPeqgf19+sPn2iHaVg0S4AB0jkQ43sSe6uPfv2XGXGCIeyvGrC3twuJbj+2h490D1rMi8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778873996; c=relaxed/simple;
	bh=3F4Z+vJGQ8MGpdrCQTPEDhUTS1uQ8W3/UXG5mV11VAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efFV3l3TY4hYkTDRmG2sAbJmLqgqA9IJraQG/a357p7kZxOY1/vWXthSkSU1q52i+unArL8jj4zKhtu2QhgjLbdSbjM5aKNxLKHYDUltvTKEZF9J1cqvvylK2lB6ew12g+ZefA1Ber0blh+NQdPuDQzr0OC1kajq8bH/0FmmtT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RtMk1uHj; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RtMk1uHj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778873994; x=1810409994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3F4Z+vJGQ8MGpdrCQTPEDhUTS1uQ8W3/UXG5mV11VAw=;
  b=RtMk1uHjrA5v8Q/zX0bJVUdMXe4CwlGdeaARwq4INUK7wIZd2lxDWJXB
   wNWHil6tvfyvJrVu8H2ZIB3orMEqihNk8+GeAl5O8vfOoh80ZxAIv1EDR
   G9cQ3Bvix7MC9xeXRD/3TJ1Kz4jghPGsibIw68JUnsv8iUwZUIZ9dCJTC
   EkztbuFqH7XR4zXW9vKwOgiloxlvxiR4gw2iZ4iUHk85KHxz7F1RUFbXQ
   XjuoMLi4mGWrW3lFY+6W/gy6joHmLKWNNXxJbllQx3SMUUCLD600dR2pm
   PVEXTTJ4sZzmywYulvXmTatEZ5OcZcI0fHq0LG4Rslkib8EhQ67w63hr+
   Q==;
X-CSE-ConnectionGUID: PA45dt7qQciiTdcdbVrS+w==
X-CSE-MsgGUID: R7y9676kRuyKb9mXznnbGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11787"; a="78972244"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="78972244"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:52 -0700
X-CSE-ConnectionGUID: Fj3/9FGjTDajzlGFXKEGAw==
X-CSE-MsgGUID: AeB5t0WZTHWJglJ/8MfVRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="237916574"
Received: from hanvin-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:51 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 4/5] fs/resctrl: Fix deadlock for errors during mount
Date: Fri, 15 May 2026 12:39:43 -0700
Message-ID: <20260515193944.15114-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515193944.15114-1-tony.luck@intel.com>
References: <20260515193944.15114-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Reinette Chatre <reinette.chatre@intel.com>

Sashiko noticed[1] a deadlock in the resctrl mount code.

rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
the same thread before the call returns.  rdt_kill_sb() unconditionally
attempts to acquire rdtgroup_mutex and deadlock occurs.

Move the call to kernfs_get_tree() outside of locks.

Add resctrl_unmount() helper to keep code consistent between the
rdt_get_tree() failure path and a normal unmount.

If kernfs_get_tree() fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb()
has already been called and no further cleanup is needed.

Add an extra hold in this error path on rdtgroup_default.kn to defend against
other races destroying the root which is then dereferenced in kernfs_kill_sb()

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
---
 fs/resctrl/rdtgroup.c | 82 +++++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 27 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 97d1a3648b9e..282a0acedea8 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2978,10 +2978,34 @@ static void resctrl_fs_teardown(void)
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
@@ -3057,10 +3081,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	ret = kernfs_get_tree(fc);
-	if (ret < 0)
-		goto out_psl;
-
 	if (resctrl_arch_alloc_capable())
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
@@ -3076,10 +3096,37 @@ static int rdt_get_tree(struct fs_context *fc)
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
@@ -3099,7 +3146,6 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
-	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 	return ret;
@@ -3186,26 +3232,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
 
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

