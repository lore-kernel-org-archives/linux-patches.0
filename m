Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC3D40DFB0
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652562; cv=none; b=IIm2weGWFD343NteBXvGauysY5zGJcXGqw5Ps5GdVwtwX8+E4aflKbLFb95XtdbOPZbjX4scRkvp2dm7MECtE0A+BvkMcHqf+tmkJ+b2valJLIdPoallhlD+fZqVvmm10GWzoXUxpCYJH5TyRXf3ivqaTbkT4A7PtNPIO9Trn4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652562; c=relaxed/simple;
	bh=sCP5yTMAKUxJUogvJ6h/yYpc8TdhsObTGUqn2bTxugE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj5EVZGHGtJ1HcEtjlnvCt/W3FiubGuRK7CDpvopLT8RPN9U8ECnvYkKEp9RZKpYhE/MlVzRn88vZ4tpIVR754IGhYvWHUqqmM8gvBHzErI33HpWtmOEkMDZPfKwJFIh8HR7KA+KLeYUYr5YL5RX+PkanJomLAvIlG96dOOGmhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QVGC906V; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QVGC906V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774652561; x=1806188561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sCP5yTMAKUxJUogvJ6h/yYpc8TdhsObTGUqn2bTxugE=;
  b=QVGC906VW02SA5J+dNjAW4GtXZ3UA2kMUoUl08IuxZD07YhSDUBUNhNm
   btTz8XRxt1BmZfcY7qQ9yjA/kn82l4RiUNNVfa2O9+aOvIAxCokTlvtE7
   hRSIMxTnoVsUiX5eJK+x8ixHh0Ml2mLurgXQas3ZJPncZtN4lOVZxuHWK
   RSEYRFvwTZHfunWr2qJu1VpxFZf849NPzPET6dZJr7sfMBC123gEIx37E
   cyF/y+0ZVdSlezSbezabiO9yUSSRzR8IMsJj0EJX6Bub29dDaTkwqZFP9
   B3Qnu3ntL0rO2CTb2wcHt16IM3xEvo5XIafMdUo4pnh4VzgVC3HxHrodH
   Q==;
X-CSE-ConnectionGUID: NsFxaY04QxOX/7qF+SnVTQ==
X-CSE-MsgGUID: GiwC8uUMSdu+uKU5fv1Jvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75613269"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75613269"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:39 -0700
X-CSE-ConnectionGUID: csQUBVHNRHKBBRKY56RSXQ==
X-CSE-MsgGUID: RtT59Z7WS7m3AG9n+aMdPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218816028"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.83])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:15 -0700
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
Subject: [PATCH v3 3/7] fs,x86/resctrl: Add architecture hooks for every mount/unmount
Date: Fri, 27 Mar 2026 16:02:04 -0700
Message-ID: <20260327230208.18094-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327230208.18094-1-tony.luck@intel.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
 <20260327230208.18094-1-tony.luck@intel.com>
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
 include/linux/resctrl.h                 | 11 +++++++++--
 arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++++++--
 arch/x86/kernel/cpu/resctrl/core.c      | 14 +++++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 13 +++++++++++++
 fs/resctrl/rdtgroup.c                   | 20 ++++++++++++++++----
 5 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index b312aaf76974..fd16256d01a7 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -518,11 +518,18 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
- * No locks are held.
+ * Architecture hooks for resctrl mount/unmount. No locks are held.
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
index 5da305bd36c9..edcee79de424 100644
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
@@ -2788,8 +2787,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
-
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
@@ -2900,6 +2897,19 @@ static int rdt_get_tree(struct fs_context *fc)
 	return ret;
 }
 
+static int rdt_get_tree_wrapper(struct fs_context *fc)
+{
+	int ret;
+
+	resctrl_arch_pre_mount();
+
+	ret = rdt_get_tree(fc);
+
+	resctrl_arch_mount_result(ret);
+
+	return ret;
+}
+
 enum rdt_param {
 	Opt_cdp,
 	Opt_cdpl2,
@@ -2959,7 +2969,7 @@ static void rdt_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations rdt_fs_context_ops = {
 	.free		= rdt_fs_context_free,
 	.parse_param	= rdt_parse_param,
-	.get_tree	= rdt_get_tree,
+	.get_tree	= rdt_get_tree_wrapper,
 };
 
 static int rdt_init_fs_context(struct fs_context *fc)
@@ -3187,6 +3197,8 @@ static void rdt_kill_sb(struct super_block *sb)
 	kernfs_kill_sb(sb);
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	resctrl_arch_unmount();
 }
 
 static struct file_system_type rdt_fs_type = {
-- 
2.53.0

