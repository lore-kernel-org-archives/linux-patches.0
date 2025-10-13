Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F8D30ACEF
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394848; cv=none; b=Nb++1AcA9XO//2uQdtGLoyYWFCaFrZpZrlrsVWJ3+TD1IxT3o3NkXJHZwpgboLCG/8Ca2Ec/k5GMy+iG1pcxBgkcpynz9Hl7ZBZJqq/siPUq9VJj3cS4HuQRzioCMRa6nP3jc5foXeaKfDIyFJh1cr4iBr5Qoyac6COpbtpZ9fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394848; c=relaxed/simple;
	bh=PnpCoCwosL6AC8m5twyBSqBERlVtFW7+/LF6zUbWMUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l01j3MyHLaCFFk4bFnI6GIiHkD6wF63waGLieGlCjJGL3HjDOU7hnjEBWpj+NmSZjgzO5/CkvQWu8LnG+0FaANpBIeUA+HO5au12sOUNQKO5Lgk7nfRtXX4wqAh0hltDwAFcl1mKKxQQs2TzXALsYnQ3SVb5ad9Z3/5vivlzrz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=goaVoBOi; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="goaVoBOi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394846; x=1791930846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PnpCoCwosL6AC8m5twyBSqBERlVtFW7+/LF6zUbWMUk=;
  b=goaVoBOihE9GKO/fcj0mAIeN+jVfgwohijhvatGCH3dTBfDOp3reHy8b
   H0I2IAWpJ5rA2ncct87AjbcaR2VvybRCq6oQ9I24b0H8rmYgD0sbY67wp
   9Lzw3ntEpHAKFb2ODMTbZm+WMwAqlW5lk0xjZwFBF1wG5AOEzvKy54/Ia
   1nw9WaMvZvrFtzJX/5HR1ySMnrZ6BpsS58cQ5ddRN55tNazlvehSIRV1c
   sn8UcSj6rnafLylV/RQrdwH53ietHnZnNxfNT6Ya3cgA5xj6J9f9m0xCk
   KOkRen5HvGTuMjufszA9vp8vdSiaqwE72PvK7qCI/MptC4CayEagtjSSn
   A==;
X-CSE-ConnectionGUID: dGLeAIswQjetZJtvRGdErw==
X-CSE-MsgGUID: 5Jhc4begRyS362xXYZ1WpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168807"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168807"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:01 -0700
X-CSE-ConnectionGUID: tFnxEzqpToKYo8GdqtyRlA==
X-CSE-MsgGUID: RsAiqiJZTIu8H66Mgqj4/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145266"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:00 -0700
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
Subject: [PATCH v12 08/31] x86,fs/resctrl: Rename some L3 specific functions
Date: Mon, 13 Oct 2025 15:33:22 -0700
Message-ID: <20251013223348.103390-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
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

Fixed kerneldoc "Return:" for l3_mon_domain_mbm_alloc(),
resctrl_l3_mon_resource_init(), and domain_setup_l3_mon_state().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
 fs/resctrl/internal.h                  |  6 +++---
 arch/x86/kernel/cpu/resctrl/core.c     | 20 +++++++++++---------
 arch/x86/kernel/cpu/resctrl/monitor.c  |  2 +-
 fs/resctrl/monitor.c                   |  8 ++++----
 fs/resctrl/rdtgroup.c                  | 24 ++++++++++++------------
 6 files changed, 32 insertions(+), 30 deletions(-)

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
index 8137c1442139..a9fa506f09fa 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -363,7 +363,7 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 	kfree(hw_dom);
 }
 
-static void mon_domain_free(struct rdt_hw_l3_mon_domain *hw_dom)
+static void l3_mon_domain_free(struct rdt_hw_l3_mon_domain *hw_dom)
 {
 	int idx;
 
@@ -396,11 +396,13 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
 }
 
 /**
- * arch_domain_mbm_alloc() - Allocate arch private storage for the MBM counters
+ * l3_mon_domain_mbm_alloc() - Allocate arch private storage for the MBM counters
  * @num_rmid:	The size of the MBM counter array
  * @hw_dom:	The domain that owns the allocated arrays
+ *
+ * Return:	%0 for success; Error code otherwise.
  */
-static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
+static int l3_mon_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
 {
 	size_t tsize = sizeof(*hw_dom->arch_mbm_states[0]);
 	enum resctrl_event_id eventid;
@@ -514,7 +516,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 		return;
 	}
 	d->ci_id = ci->id;
@@ -522,8 +524,8 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 
 	arch_mon_domain_online(r, d);
 
-	if (arch_domain_mbm_alloc(r->mon.num_rmid, hw_dom)) {
-		mon_domain_free(hw_dom);
+	if (l3_mon_domain_mbm_alloc(r->mon.num_rmid, hw_dom)) {
+		l3_mon_domain_free(hw_dom);
 		return;
 	}
 
@@ -533,7 +535,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 	}
 }
 
@@ -659,7 +661,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
 		synchronize_rcu();
-		mon_domain_free(hw_dom);
+		l3_mon_domain_free(hw_dom);
 		break;
 	}
 	default:
@@ -908,7 +910,7 @@ static __init bool get_rdt_mon_resources(void)
 	if (!ret)
 		return false;
 
-	return !rdt_get_mon_l3_config(r);
+	return !rdt_get_l3_mon_config(r);
 }
 
 static __init void __check_quirks_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 3980c59cf5dc..8f9a2ec3bd04 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -429,7 +429,7 @@ static __init int snc_get_config(void)
 	return ret;
 }
 
-int __init rdt_get_mon_l3_config(struct rdt_resource *r)
+int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
 	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 69b6aa31b986..26e2ecbddb5c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1754,7 +1754,7 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 }
 
 /**
- * resctrl_mon_resource_init() - Initialise global monitoring structures.
+ * resctrl_l3_mon_resource_init() - Initialise global monitoring structures.
  *
  * Allocate and initialise global monitor resources that do not belong to a
  * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
@@ -1763,9 +1763,9 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
  * Resctrl's cpuhp callbacks may be called before this point to bring a domain
  * online.
  *
- * Returns 0 for success, or -ENOMEM.
+ * Return: %0 for success; -ENOMEM otherwise.
  */
-int resctrl_mon_resource_init(void)
+int resctrl_l3_mon_resource_init(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	int ret;
@@ -1817,7 +1817,7 @@ int resctrl_mon_resource_init(void)
 	return 0;
 }
 
-void resctrl_mon_resource_exit(void)
+void resctrl_l3_mon_resource_exit(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index f9d35eb86dcc..3845ed277355 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4180,7 +4180,7 @@ static void rdtgroup_setup_default(void)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-static void domain_destroy_mon_state(struct rdt_l3_mon_domain *d)
+static void domain_destroy_l3_mon_state(struct rdt_l3_mon_domain *d)
 {
 	int idx;
 
@@ -4235,13 +4235,13 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
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
@@ -4249,11 +4249,11 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  * Called when the first CPU of a domain comes online, regardless of whether
  * the filesystem is mounted.
  * During boot this may be called before global allocations have been made by
- * resctrl_mon_resource_init().
+ * resctrl_l3_mon_resource_init().
  *
- * Returns 0 for success, or -ENOMEM.
+ * Return: %0 for success; -ENOMEM otherwise.
  */
-static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
+static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize = sizeof(*d->mbm_states[0]);
@@ -4320,7 +4320,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	err = domain_setup_mon_state(r, d);
+	err = domain_setup_l3_mon_state(r, d);
 	if (err)
 		goto out_unlock;
 
@@ -4435,13 +4435,13 @@ int resctrl_init(void)
 
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
 
@@ -4476,7 +4476,7 @@ int resctrl_init(void)
 
 cleanup_mountpoint:
 	sysfs_remove_mount_point(fs_kobj, "resctrl");
-	resctrl_mon_resource_exit();
+	resctrl_l3_mon_resource_exit();
 
 	return ret;
 }
@@ -4512,7 +4512,7 @@ static bool resctrl_online_domains_exist(void)
  * When called by the architecture code, all CPUs and resctrl domains must be
  * offline. This ensures the limbo and overflow handlers are not scheduled to
  * run, meaning the data structures they access can be freed by
- * resctrl_mon_resource_exit().
+ * resctrl_l3_mon_resource_exit().
  *
  * After resctrl_exit() returns, the architecture code should return an
  * error from all resctrl_arch_ functions that can do this.
@@ -4539,5 +4539,5 @@ void resctrl_exit(void)
 	 * it can be used to umount resctrl.
 	 */
 
-	resctrl_mon_resource_exit();
+	resctrl_l3_mon_resource_exit();
 }
-- 
2.51.0

