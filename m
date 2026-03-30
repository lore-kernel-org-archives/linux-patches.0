Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC2C374E7F
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907016; cv=none; b=lhf0Xb1rZFPbw88QoJ58kBv8E8bACPztdn6p7Je7mPo1OKDqubowF26VCfKvw6HuBMd+JKM5d8Phz5xyeKYvifeW+dCTXUJxltvQMtkTJHPQK8J1Ta5Zyv3chZTDlkBD9ighFjS/PGv3CaTolmw/usEdMkxidVJCoLJKf+RD+kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907016; c=relaxed/simple;
	bh=ZmrW/lnrmraTGrG222FCq68z97lMPh4tb6hecweEEP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGrcr6X39te1RDb1hN/ZreWkzicg8aomlUztzBEd7/1+MnMteztCIbgT7LEWjILXKit+qRVHL5ekOtHaBkXwOrXACajPptwNv64lDNUzHmEf43TO8+yn8KVkTpVkHZ7MWI1SyHPpv9/rXt8rWbEhOE9Ou+ALE0m20AOZfkh7ctk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iKj71Ina; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iKj71Ina"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774907014; x=1806443014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZmrW/lnrmraTGrG222FCq68z97lMPh4tb6hecweEEP4=;
  b=iKj71InaqbFdEomivbFQZ7mFKzYVoGg2BVgQuPKsfWg4qITBEfQLCrG0
   EaDHobrsszxXKii7oRZWgeEO3lPSII37Lo0oeue0SQmxEJVHhhkF9YEYb
   Wy/zr0HHXuIzSQcD5mG0McgPBrXnegYrV43qXqts3QLLuAQN98lKcS+uf
   x1wbQv8y4HZ5o1KBikanP3Yg8b6m5+1SagsOSiix9m9qtEG7VocopkIc2
   9X++R0IpJNphWhyjSMb+wQCKwwub9dI6MdZeSMvTC/BjAv/8Vde6WXmmG
   CIVE+2aft9L60p8E4V0FE1LKD9zyu0ojm2iidnTmBnuqat2OEM909cde6
   Q==;
X-CSE-ConnectionGUID: kj7k3G2YTGiVERUhMJZtmw==
X-CSE-MsgGUID: 83W5S1IhQ0CtvEEKtmue7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79772153"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79772153"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:33 -0700
X-CSE-ConnectionGUID: GWFOHd8UQT2V+mDjRssSYw==
X-CSE-MsgGUID: PaSeuy4iRaKBwwCGYBT+Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225185945"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:33 -0700
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
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every mount/unmount
Date: Mon, 30 Mar 2026 14:43:19 -0700
Message-ID: <20260330214322.96686-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330214322.96686-1-tony.luck@intel.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add hooks for every mount/unmount of the resctrl file system so that
architecture code can allocate on mount and free on unmount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Note this patch disables enumeration of AET monitor events because the
new mount/unmount hooks do not call intel_aet_get_events() (which is
not ready for the change from "just on first mount" to "called on
every mount"). That is resolved in the next patch.

 include/linux/resctrl.h                 | 12 +++++--
 arch/x86/kernel/cpu/resctrl/internal.h  |  8 +++--
 arch/x86/kernel/cpu/resctrl/core.c      | 14 +++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 13 ++++++++
 fs/resctrl/rdtgroup.c                   | 43 ++++++++++++++++++-------
 5 files changed, 74 insertions(+), 16 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index b312aaf76974..489c7d4ae3e9 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -518,11 +518,19 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
- * No locks are held.
+ * Architecture hooks for resctrl mount/unmount.
+ * Each is called with resctrl_mount_lock held.
  */
+
+/* Called at beginning of each file system mount attempt. */
 void resctrl_arch_pre_mount(void);
 
+/* Called to report success/failure of mount. */
+void resctrl_arch_mount_result(int ret);
+
+/* Called to report unmount. */
+void resctrl_arch_unmount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92..6f322818a9e6 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,14 +234,18 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-bool intel_aet_get_events(void);
+bool intel_aet_pre_mount(void);
+void intel_aet_mount_result(int ret);
+void intel_aet_unmount(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline bool intel_aet_get_events(void) { return false; }
+static inline bool intel_aet_pre_mount(void) { return false; }
+static inline void intel_aet_mount_result(int ret) { }
+static inline void intel_aet_unmount(void) { }
 static inline void __exit intel_aet_exit(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..162eca2cfcdb 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -769,8 +769,10 @@ void resctrl_arch_pre_mount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	if (!intel_aet_pre_mount()) {
+		r->mon_capable = false;
 		return;
+	}
 
 	/*
 	 * Late discovery of telemetry events means the domains for the
@@ -786,6 +788,16 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_unlock();
 }
 
+void resctrl_arch_mount_result(int ret)
+{
+	intel_aet_mount_result(ret);
+}
+
+void resctrl_arch_unmount(void)
+{
+	intel_aet_unmount();
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 015627401ed2..743a1894fe9a 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -335,6 +335,19 @@ void __exit intel_aet_exit(void)
 	}
 }
 
+bool intel_aet_pre_mount(void)
+{
+	return false; // Temporary stub
+}
+
+void intel_aet_mount_result(int ret)
+{
+}
+
+void intel_aet_unmount(void)
+{
+}
+
 #define DATA_VALID	BIT_ULL(63)
 #define DATA_BITS	GENMASK_ULL(62, 0)
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5da305bd36c9..2ce11ae2d2cd 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -18,7 +18,6 @@
 #include <linux/fs_parser.h>
 #include <linux/sysfs.h>
 #include <linux/kernfs.h>
-#include <linux/once.h>
 #include <linux/resctrl.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
@@ -30,6 +29,9 @@
 
 #include "internal.h"
 
+/* Mutex protecting mount/unmount operations */
+static DEFINE_MUTEX(resctrl_mount_lock);
+
 /* Mutex to protect rdtgroup access. */
 DEFINE_MUTEX(rdtgroup_mutex);
 
@@ -2788,17 +2790,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
-
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
-	/*
-	 * resctrl file system can only be mounted once.
-	 */
-	if (resctrl_mounted) {
-		ret = -EBUSY;
-		goto out;
-	}
 
 	ret = setup_rmid_lru_list();
 	if (ret)
@@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
 	return ret;
 }
 
+static int rdt_get_tree_wrapper(struct fs_context *fc)
+{
+	int ret;
+
+	mutex_lock(&resctrl_mount_lock);
+
+	/*
+	 * resctrl file system can only be mounted once.
+	 */
+	if (resctrl_mounted) {
+		mutex_unlock(&resctrl_mount_lock);
+		return -EBUSY;
+	}
+
+	resctrl_arch_pre_mount();
+
+	ret = rdt_get_tree(fc);
+
+	resctrl_arch_mount_result(ret);
+	mutex_unlock(&resctrl_mount_lock);
+
+	return ret;
+}
+
 enum rdt_param {
 	Opt_cdp,
 	Opt_cdpl2,
@@ -2959,7 +2976,7 @@ static void rdt_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations rdt_fs_context_ops = {
 	.free		= rdt_fs_context_free,
 	.parse_param	= rdt_parse_param,
-	.get_tree	= rdt_get_tree,
+	.get_tree	= rdt_get_tree_wrapper,
 };
 
 static int rdt_init_fs_context(struct fs_context *fc)
@@ -3169,6 +3186,7 @@ static void rdt_kill_sb(struct super_block *sb)
 {
 	struct rdt_resource *r;
 
+	mutex_lock(&resctrl_mount_lock);
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
@@ -3187,6 +3205,9 @@ static void rdt_kill_sb(struct super_block *sb)
 	kernfs_kill_sb(sb);
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	resctrl_arch_unmount();
+	mutex_unlock(&resctrl_mount_lock);
 }
 
 static struct file_system_type rdt_fs_type = {
-- 
2.53.0

