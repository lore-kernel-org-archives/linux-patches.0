Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32094DA9C7
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600433; cv=none; b=SQd60D6UeSRZHVl2GmQoJ3wjoWEsVh8ahoGrTAHDNegWtYHfMx/SdkctLuy1nCXt16FRQCP0OJcYt8YeJ8xwz33itCA3/364wsHZU75x3tBOK/UdqJm/pyMRPravUvk+yfP//djS+pFkVLS47kEqUN7TbIu0Ni1T0ry0bMjcuKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600433; c=relaxed/simple;
	bh=8+L2gR2Ss+gNnCnweaBzwESt6GJNv29K9n1V0EfSMa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgCEN0ZURQWhW93O4e91QWHBGEktoD2DKd/MEYSo+v6N2AqMFixq926JKRViWoh+nS9PwjAACdDseJR+watmitw2rbJF+WLcqIzt/+JTkz8vMCauGqZ3Vm3mEapTJ9C1t4iQw6esUrUhnlTN8/Epxn0OTsJfdJLKIYu4yfKkJvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BRK1UuGP; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BRK1UuGP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600431; x=1821136431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8+L2gR2Ss+gNnCnweaBzwESt6GJNv29K9n1V0EfSMa4=;
  b=BRK1UuGPfkziuU7a+rngsTQ2vgMNFRKJkyY+Oyd0qw/sq8AcRvLBUGcg
   zZHfL0ITL5QBxM9PvQkm77xuAKnflKSLz17MyEyA7Kjd53ZZDhdHJLFm+
   ViSD/Az/D1t+fnkaLjdqQZ9s5j6KvzMtccHNyIY7TGxV5JQ7JBOFk3zrb
   bGqjWzey8ZRhrnz0OiUiIgjiaVYPbpnvLkJoTd/O2YT85yqC7E6NU21fh
   u7kudOLczvPiSqJxO52I9itC/Bk8WcKzmmJipw8uz83S2Lh2uTKyhrrI8
   IGBX49l7T2V+lz45cB8Vlm7j4Ut7ZC8kdtKbwq16y3acGQCiaqK6nylf8
   w==;
X-CSE-ConnectionGUID: zPwFt9NnTiunQypsjV8kig==
X-CSE-MsgGUID: YLr8Lm7FTqebqHV/HNPjEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861489"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861489"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:39 -0700
X-CSE-ConnectionGUID: hVkVTmCsSy+s+luHCKEWoQ==
X-CSE-MsgGUID: uqIdBX5pRpevzIXFaim2jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231489"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:39 -0700
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
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v12 19/25] arm,x86,fs/resctrl: Enumerate AET on every resctrl mount
Date: Wed, 16 Sep 2026 16:13:14 -0700
Message-ID: <20260916231320.14502-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call resctrl_arch_pre_mount() for every mount protected by
resctrl_mount_lock. Add matching resctrl_arch_unmount() path for
architecture code to clean up on mount failure or unmount.

Remove intel_aet_exit() after moving all the cleanup code into
intel_aet_unmount().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Rest of old patch 17 merged into patch 18 so the umount
	code path is complete.
	Fix rdt_get_tree() return value when kernfs_get_tree() fails.
	Move resctrl_arch_unmount() after cpus_read_unlock() in out: error path
	Update resctrl_arch_pre_mount() header comment to say it is now
	called for each mount, not just the first.
	Update comment for resctrl_mounted to say that both resctrl_mount_lock
	and rdtgroup_mutex must be help to change state.
---
 include/linux/resctrl.h                 | 10 ++++++--
 arch/x86/kernel/cpu/resctrl/internal.h  |  4 ++--
 arch/x86/kernel/cpu/resctrl/core.c      | 21 +++++++++++++++--
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++----
 drivers/resctrl/mpam_resctrl.c          |  4 ++++
 fs/resctrl/rdtgroup.c                   | 31 ++++++++++++++++++++-----
 6 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 604ab7af7c2b..5a975856f670 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -590,11 +590,17 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
- * No locks are held.
+ * Architecture hook called at beginning of each file system mount attempt.
+ * Called while holding resctrl_mount_lock.
  */
 void resctrl_arch_pre_mount(void);
 
+/*
+ * Architecture hook called when mount fails, or on unmount.
+ * Called while holding resctrl_mount_lock.
+ */
+void resctrl_arch_unmount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index fc60b0af250d..5e71dd758624 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-void __exit intel_aet_exit(void);
 bool intel_aet_pre_mount(void);
+void intel_aet_unmount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline void __exit intel_aet_exit(void) { }
 static inline bool intel_aet_pre_mount(void) { return false; }
+static inline void intel_aet_unmount(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2fa4ebf7159a..3bf4d1a07593 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -811,6 +811,25 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_unlock();
 }
 
+void resctrl_arch_unmount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int cpu;
+
+	if (!r->mon_capable)
+		return;
+
+	intel_aet_unmount();
+
+	cpus_read_lock();
+	mutex_lock(&domain_list_lock);
+	for_each_online_cpu(cpu)
+		domain_remove_cpu_mon(cpu, r);
+	r->mon_capable = false;
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
@@ -1159,8 +1178,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 32f3f30894a4..8aa2e18a6bbb 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -298,7 +298,7 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 /*
  * Protects pmt_module, get_feature, put_feature against races between module
  * load/unload of the pmt_telemetry module and mount/unmount of the resctrl
- * file system.
+ * file system. Also protects pmt_in_use.
  */
 static DEFINE_MUTEX(aet_register_lock);
 
@@ -306,6 +306,11 @@ static struct module *pmt_module;
 static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
 static void (*put_feature)(struct pmt_feature_group *p);
 
+/*
+ * Track whether pmt_telemetry enumeration succeeded during mount for use during unmount.
+ */
+static bool pmt_in_use;
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -375,19 +380,33 @@ bool intel_aet_pre_mount(void)
 		return false;
 	}
 
+	pmt_in_use = true;
+
 	return true;
 }
 
-void __exit intel_aet_exit(void)
+void intel_aet_unmount(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	struct event_group **peg;
 
+	guard(mutex)(&aet_register_lock);
+	if (!pmt_in_use)
+		return;
+
 	for_each_event_group(peg) {
-		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
-			(*peg)->pfg = NULL;
+		struct event_group *e = *peg;
+
+		if (e->pfg) {
+			for (int i = 0; i < e->num_events; i++)
+				resctrl_disable_mon_event(e->evts[i].id);
+			put_feature(e->pfg);
+			e->pfg = NULL;
 		}
 	}
+	module_put(pmt_module);
+	pmt_in_use = false;
+	r->mon.num_rmid = 0;
 }
 
 #define DATA_VALID	BIT_ULL(63)
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 69c9e02d2f40..f42f98f89c38 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -121,6 +121,10 @@ void resctrl_arch_pre_mount(void)
 {
 }
 
+void resctrl_arch_unmount(void)
+{
+}
+
 bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
 {
 	return mpam_resctrl_controls[rid].cdp_enabled;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 2e9f71901f68..07fefa3c434e 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -30,6 +30,9 @@
 
 #include "internal.h"
 
+/* Mutex protecting resctrl_mounted and mount/unmount operations */
+static DEFINE_MUTEX(resctrl_mount_lock);
+
 /* Mutex to protect rdtgroup access. */
 DEFINE_MUTEX(rdtgroup_mutex);
 
@@ -48,7 +51,10 @@ LIST_HEAD(resctrl_schema_all);
  */
 static LIST_HEAD(mon_data_kn_priv_list);
 
-/* The filesystem can only be mounted once. */
+/*
+ * The filesystem can only be mounted once. Can only be updated
+ * while holding both resctrl_mount_lock and rdtgroup_mutex.
+ */
 bool resctrl_mounted;
 
 /* Kernel fs node for "info" directory under root */
@@ -3149,6 +3155,7 @@ static void resctrl_unmount(void)
 {
 	struct rdt_resource *r;
 
+	mutex_lock(&resctrl_mount_lock);
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
@@ -3166,6 +3173,8 @@ static void resctrl_unmount(void)
 	resctrl_mounted = false;
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+	resctrl_arch_unmount();
+	mutex_unlock(&resctrl_mount_lock);
 }
 
 static int rdt_get_tree(struct fs_context *fc)
@@ -3177,24 +3186,27 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+	mutex_lock(&resctrl_mount_lock);
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
 	/*
 	 * resctrl file system can only be mounted once.
 	 */
 	if (resctrl_mounted) {
 		ret = -EBUSY;
-		goto out;
+		goto out_mount_unlock;
 	}
 
 	/* Avoid races from pending operations from a previous mount */
 	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
 		ret = -EBUSY;
-		goto out;
+		goto out_mount_unlock;
 	}
 
+	resctrl_arch_pre_mount();
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
 	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
 		ret = invalfc(fc, "No allocation or monitoring features are available or enabled");
 		goto out;
@@ -3289,6 +3301,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 
+	mutex_unlock(&resctrl_mount_lock);
+
 	ret = kernfs_get_tree(fc);
 	/*
 	 * resctrl can only be mounted once, new superblock only expected
@@ -3297,6 +3311,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (!ctx->kfc.new_sb_created)
 		resctrl_unmount();
 	kernfs_put(rdt_root_kn);
+
 	return ret;
 
 out_mondata:
@@ -3320,6 +3335,10 @@ static int rdt_get_tree(struct fs_context *fc)
 out:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+	resctrl_arch_unmount();
+out_mount_unlock:
+	mutex_unlock(&resctrl_mount_lock);
+
 	return ret;
 }
 
-- 
2.55.0

