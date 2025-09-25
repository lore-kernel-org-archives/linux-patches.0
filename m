Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390C43203AB
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830652; cv=none; b=mL7+gMvAHOq6C+4OtyFqlPcCH/MqgRyV1HyX0VeCK1hwcb+x5wqVFfxAI4IsKHKicjfIpf0cHYUWu5MEc/3DgtvnGMDPPVycgXo49OpphfbGaMlCWpEfUidAT5EFzVpFJJPnebsTzHqP1f1UrNCxTCgrRICHsaIuLybH+tPG7yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830652; c=relaxed/simple;
	bh=gyXvtfuM2DO2MmMztQrjC+UHtGEtL4e/uxyFFach+uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kH9vHO4/Vv7pggaMspSOBQfWGqAI/5cHHn3Wc2FyJR22FrnXGE2p12DBbMDBoE2XhxqjcaadKzAqKVYHL5yMBaCE/3lZ7KV0RoJV4FCQPUf5fFPjruj7oPNRuFeiGTogyi194GdyxQTwzOdrRGWGebGxpafUcJKbbKo19t4XJmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jq1auwiL; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jq1auwiL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830651; x=1790366651;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gyXvtfuM2DO2MmMztQrjC+UHtGEtL4e/uxyFFach+uA=;
  b=jq1auwiLA0CCo8Fz5khYDMqE85IAOU591CEPseZcjlfa4qU6f7sjQSrv
   1Gyb+783Dda6LkPPhyn0iJxfndFSOykLSDi1WI1P/KzedvewFaeV31+U0
   SyFS4X9FluNPKa2qaSmxO4NWkh2X1TVqE+8cIXOZC0xoUQoEqz9FRm0dR
   V4abmGXHBKf9AUJQfXfbClhYCe+aBZzBSJeRXVM5qVoVJJ3iDC+oCSeot
   4YwzswwzvMCxR/7Omn+0cooPJjTUmFuq805IyH+KM54/iKN7G5Isdf/fx
   OvFnCLuvlDdVA1BBGE2WdHts8crQ18B4RLnXyZ49dyilFqZ+3MEb/LUKQ
   Q==;
X-CSE-ConnectionGUID: tcz6Kx8JSK2PifA1QM0aoA==
X-CSE-MsgGUID: yxhW6/SDQaWLGORomLzp4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074194"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074194"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:07 -0700
X-CSE-ConnectionGUID: 86dO9KSRRKKiXXMHPcoM4w==
X-CSE-MsgGUID: ZYBy7Py6SHCZjsE2fI71Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003623"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:07 -0700
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
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 08/31] x86,fs/resctrl: Rename some L3 specific functions
Date: Thu, 25 Sep 2025 13:03:02 -0700
Message-ID: <20250925200328.64155-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the arrival of monitor events tied to new domains associated with
a different resource it would be clearer if the L3 resource specific
functions are more accurately named.

Rename three groups of functions:

Functions that allocate/free architecture per-RMID MBM state information:
arch_domain_mbm_alloc()		-> l3_mon_domain_mbm_alloc()
mon_domain_free()		-> l3_mon_domain_free()

Functions that allocate/free filesystem per-RMID MBM state information:
domain_setup_mon_state()	-> domain_setup_l3_mon_state()
domain_destroy_mon_state()	-> domain_destroy_l3_mon_state()

Initialization/exit:
rdt_get_mon_l3_config()		-> rdt_get_l3_mon_config()
resctrl_mon_resource_init()	-> resctrl_l3_mon_resource_init()
resctrl_mon_resource_exit()	-> resctrl_l3_mon_resource_exit()

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
 fs/resctrl/internal.h                  |  6 +++---
 arch/x86/kernel/cpu/resctrl/core.c     | 18 +++++++++---------
 arch/x86/kernel/cpu/resctrl/monitor.c  |  2 +-
 fs/resctrl/monitor.c                   |  6 +++---
 fs/resctrl/rdtgroup.c                  | 22 +++++++++++-----------
 6 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 6eca3d522fcc..14fadcff0d2b 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -208,7 +208,7 @@ union l3_qos_abmc_cfg {
 
 void rdt_ctrl_update(void *arg);
 
-int rdt_get_mon_l3_config(struct rdt_resource *r);
+int rdt_get_l3_mon_config(struct rdt_resource *r);
 
 bool rdt_cpu_has(int flag);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index d9e291d94926..88b4489b68e1 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -357,7 +357,9 @@ int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
 
-void resctrl_mon_resource_exit(void);
+int resctrl_l3_mon_resource_init(void);
+
+void resctrl_l3_mon_resource_exit(void);
 
 void mon_event_count(void *info);
 
@@ -367,8 +369,6 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first);
 
-int resctrl_mon_resource_init(void);
-
 void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
 				int exclude_cpu);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 42f4f702eeec..4762790c6e62 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -363,7 +363,7 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 	kfree(hw_dom);
 }
 
-static void mon_domain_free(struct rdt_hw_l3_mon_domain *hw_dom)
+static void l3_mon_domain_free(struct rdt_hw_l3_mon_domain *hw_dom)
 {
 	int idx;
 
@@ -396,11 +396,11 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
 }
 
 /**
- * arch_domain_mbm_alloc() - Allocate arch private storage for the MBM counters
+ * l3_mon_domain_mbm_alloc() - Allocate arch private storage for the MBM counters
  * @num_rmid:	The size of the MBM counter array
  * @hw_dom:	The domain that owns the allocated arrays
  */
-static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
+static int l3_mon_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
 {
 	size_t tsize = sizeof(*hw_dom->arch_mbm_states[0]);
 	enum resctrl_event_id eventid;
@@ -514,7 +514,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 		return;
 	}
 	d->ci_id = ci->id;
@@ -522,8 +522,8 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 
 	arch_mon_domain_online(r, d);
 
-	if (arch_domain_mbm_alloc(r->mon.num_rmid, hw_dom)) {
-		mon_domain_free(hw_dom);
+	if (l3_mon_domain_mbm_alloc(r->mon.num_rmid, hw_dom)) {
+		l3_mon_domain_free(hw_dom);
 		return;
 	}
 
@@ -533,7 +533,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 	}
 }
 
@@ -658,7 +658,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
 		synchronize_rcu();
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 		break;
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
@@ -906,7 +906,7 @@ static __init bool get_rdt_mon_resources(void)
 	if (!ret)
 		return false;
 
-	return !rdt_get_mon_l3_config(r);
+	return !rdt_get_l3_mon_config(r);
 }
 
 static __init void __check_quirks_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index b448e6816fe7..ea81305fbc5d 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -422,7 +422,7 @@ static __init int snc_get_config(void)
 	return ret;
 }
 
-int __init rdt_get_mon_l3_config(struct rdt_resource *r)
+int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
 	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 88b990e939ea..54ae3494adfe 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1750,7 +1750,7 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 }
 
 /**
- * resctrl_mon_resource_init() - Initialise global monitoring structures.
+ * resctrl_l3_mon_resource_init() - Initialise global monitoring structures.
  *
  * Allocate and initialise global monitor resources that do not belong to a
  * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
@@ -1761,7 +1761,7 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
  *
  * Returns 0 for success, or -ENOMEM.
  */
-int resctrl_mon_resource_init(void)
+int resctrl_l3_mon_resource_init(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	int ret;
@@ -1813,7 +1813,7 @@ int resctrl_mon_resource_init(void)
 	return 0;
 }
 
-void resctrl_mon_resource_exit(void)
+void resctrl_l3_mon_resource_exit(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 1b4f4bd63143..88b80944cf85 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4174,7 +4174,7 @@ static void rdtgroup_setup_default(void)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-static void domain_destroy_mon_state(struct rdt_l3_mon_domain *d)
+static void domain_destroy_l3_mon_state(struct rdt_l3_mon_domain *d)
 {
 	int idx;
 
@@ -4228,13 +4228,13 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		cancel_delayed_work(&d->cqm_limbo);
 	}
 
-	domain_destroy_mon_state(d);
+	domain_destroy_l3_mon_state(d);
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
 /**
- * domain_setup_mon_state() -  Initialise domain monitoring structures.
+ * domain_setup_l3_mon_state() -  Initialise domain monitoring structures.
  * @r:	The resource for the newly online domain.
  * @d:	The newly online domain.
  *
@@ -4242,11 +4242,11 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  * Called when the first CPU of a domain comes online, regardless of whether
  * the filesystem is mounted.
  * During boot this may be called before global allocations have been made by
- * resctrl_mon_resource_init().
+ * resctrl_l3_mon_resource_init().
  *
  * Returns 0 for success, or -ENOMEM.
  */
-static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
+static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize = sizeof(*d->mbm_states[0]);
@@ -4313,7 +4313,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	err = domain_setup_mon_state(r, d);
+	err = domain_setup_l3_mon_state(r, d);
 	if (err)
 		goto out_unlock;
 
@@ -4429,13 +4429,13 @@ int resctrl_init(void)
 
 	thread_throttle_mode_init();
 
-	ret = resctrl_mon_resource_init();
+	ret = resctrl_l3_mon_resource_init();
 	if (ret)
 		return ret;
 
 	ret = sysfs_create_mount_point(fs_kobj, "resctrl");
 	if (ret) {
-		resctrl_mon_resource_exit();
+		resctrl_l3_mon_resource_exit();
 		return ret;
 	}
 
@@ -4470,7 +4470,7 @@ int resctrl_init(void)
 
 cleanup_mountpoint:
 	sysfs_remove_mount_point(fs_kobj, "resctrl");
-	resctrl_mon_resource_exit();
+	resctrl_l3_mon_resource_exit();
 
 	return ret;
 }
@@ -4506,7 +4506,7 @@ static bool resctrl_online_domains_exist(void)
  * When called by the architecture code, all CPUs and resctrl domains must be
  * offline. This ensures the limbo and overflow handlers are not scheduled to
  * run, meaning the data structures they access can be freed by
- * resctrl_mon_resource_exit().
+ * resctrl_l3_mon_resource_exit().
  *
  * After resctrl_exit() returns, the architecture code should return an
  * error from all resctrl_arch_ functions that can do this.
@@ -4533,5 +4533,5 @@ void resctrl_exit(void)
 	 * it can be used to umount resctrl.
 	 */
 
-	resctrl_mon_resource_exit();
+	resctrl_l3_mon_resource_exit();
 }
-- 
2.51.0

