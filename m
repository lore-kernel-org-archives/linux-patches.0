Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62D93277A4
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830667; cv=none; b=BCsZbO/SfVTPD3PQIKByl/gY81Bh0D3tq51lUgYOb1TsHoIt2jmxt3gaFYdn+A0m3/Jt+aWH13mWfTKdppuRhmCLOrIXoaTPg/8TiUFho5KbeNExj4lCx9KMBEbykB3LoVl8vqtu0ZfL5UX1N8sMZaSxhzW46miHkCkeK5rXZ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830667; c=relaxed/simple;
	bh=1MMY4PAZRGnOiPMB9iT/8hUSyj60OcM6gcQ/DakGfmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GayaAz1qUO/YQj25qt34w28/BB23JEcwqQosYGUtW5DuT0KjQWdod+2uZHP/tIQAV8k4+O8i04Jz3JmniO7aEwfStaKy8d3MvxuqWctB2TMQSfYGtqyMKE3E2fspmJbnJPQej4Vb3EL7TfQ1c2iPhcy6rVMmycPogiwUHxp2UxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jOHZJdh+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jOHZJdh+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830665; x=1790366665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1MMY4PAZRGnOiPMB9iT/8hUSyj60OcM6gcQ/DakGfmk=;
  b=jOHZJdh+osgj5GaLpCR+CuR8b4QKAtes6oe8/CeysYf5A5QfUqkJVnxU
   htj1+Cp53OoQBJaEke/1yL92hBLGcot9IlBz0OVXT5IH3dYRJVF78uLVX
   hgFd1UQCR7EJJZ69HqkJCFkualX/xfh6UwKvqPW+1TzMAX5dMb38pqSgA
   7Tvi3Lk5VUd8SWu5GgAJ8VxvG682AP16RZabFUNaEZRICFGHFdMPC7k3V
   8e/4z/NoTRuqekgJrrsWUX4kuV7qsrBTizhsasq4hBieyQA5m54Km1zhI
   rWL8UvDR6szF5SVAxBP5LGNsAbXMfzbOHa7FNzAPxdUt1AklBC3w/jb6c
   w==;
X-CSE-ConnectionGUID: eNP8pZNOSpq/wcKPwyIhpQ==
X-CSE-MsgGUID: NvZ+QRSLTH63SfkB5FidNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074363"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074363"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:14 -0700
X-CSE-ConnectionGUID: YTcZVJ6DQK6PeKTPIWBDKQ==
X-CSE-MsgGUID: AeA3gc9XTAuyWwPHbEOefg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003694"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:14 -0700
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
Subject: [PATCH v11 26/31] fs/resctrl: Move RMID initialization to first mount
Date: Thu, 25 Sep 2025 13:03:20 -0700
Message-ID: <20250925200328.64155-27-tony.luck@intel.com>
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

L3 monitor features are enumerated during resctrl initialization
and rmid_ptrs[] that tracks all RMIDs and depends on the
number of supported RMIDs is allocated during this time.

Telemetry monitor features are enumerated during first resctrl mount and
may support a different number of RMIDs compared to L3 monitor features.

Delay allocation and initialization of rmid_ptrs[] until first mount.
Since the number of RMIDs cannot change on later mounts, keep the same
set of rmid_ptrs[] until resctrl_exit(). This is required because the
limbo handler keeps running after resctrl is unmounted and may likely
need to access rmid_ptrs[] as it keeps tracking busy RMIDs after unmount.

Rename routines to match what they now do:
dom_data_init() -> setup_rmid_lru_list()
dom_data_exit() -> free_rmid_lru_list()

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h |  4 ++++
 fs/resctrl/monitor.c  | 50 +++++++++++++++++++------------------------
 fs/resctrl/rdtgroup.c |  5 +++++
 3 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index aee6c4684f81..223a6cc6a64a 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -369,6 +369,10 @@ int closids_supported(void);
 
 void closid_free(int closid);
 
+int setup_rmid_lru_list(void);
+
+void free_rmid_lru_list(void);
+
 int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 5960a0afd0ca..c0e1b672afce 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -880,20 +880,27 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
 }
 
-static int dom_data_init(struct rdt_resource *r)
+int setup_rmid_lru_list(void)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	struct rmid_entry *entry = NULL;
-	int err = 0, i;
 	u32 idx;
+	int i;
 
-	mutex_lock(&rdtgroup_mutex);
+	if (!resctrl_arch_mon_capable())
+		return 0;
+
+	/*
+	 * Called on every mount, but the number of RMIDs cannot change
+	 * after the first mount, so keep using the same set of rmid_ptrs[]
+	 * until resctrl_exit().
+	 */
+	if (rmid_ptrs)
+		return 0;
 
 	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
-	if (!rmid_ptrs) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
+	if (!rmid_ptrs)
+		return -ENOMEM;
 
 	for (i = 0; i < idx_limit; i++) {
 		entry = &rmid_ptrs[i];
@@ -906,30 +913,24 @@ static int dom_data_init(struct rdt_resource *r)
 	/*
 	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
 	 * are always allocated. These are used for the rdtgroup_default
-	 * control group, which will be setup later in resctrl_init().
+	 * control group, which was setup earlier in rdtgroup_setup_default().
 	 */
 	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
 					   RESCTRL_RESERVED_RMID);
 	entry = __rmid_entry(idx);
 	list_del(&entry->list);
 
-out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-
-	return err;
+	return 0;
 }
 
-static void dom_data_exit(struct rdt_resource *r)
+void free_rmid_lru_list(void)
 {
-	mutex_lock(&rdtgroup_mutex);
-
-	if (!r->mon_capable)
-		goto out_unlock;
+	if (!resctrl_arch_mon_capable())
+		return;
 
+	mutex_lock(&rdtgroup_mutex);
 	kfree(rmid_ptrs);
 	rmid_ptrs = NULL;
-
-out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
@@ -1803,7 +1804,8 @@ static void closid_num_dirty_rmid_free(void)
  * resctrl_l3_mon_resource_init() - Initialise global monitoring structures.
  *
  * Allocate and initialise global monitor resources that do not belong to a
- * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
+ * specific domain. i.e. the closid_num_dirty_rmid[] used to find the CLOSID
+ * with the cleanest set of RMIDs.
  * Called once during boot after the struct rdt_resource's have been configured
  * but before the filesystem is mounted.
  * Resctrl's cpuhp callbacks may be called before this point to bring a domain
@@ -1823,12 +1825,6 @@ int resctrl_l3_mon_resource_init(void)
 	if (ret)
 		return ret;
 
-	ret = dom_data_init(r);
-	if (ret) {
-		closid_num_dirty_rmid_free();
-		return ret;
-	}
-
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
@@ -1877,6 +1873,4 @@ void resctrl_l3_mon_resource_exit(void)
 		return;
 
 	closid_num_dirty_rmid_free();
-
-	dom_data_exit(r);
 }
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5e3ee4b8f70b..f82bdb8f6f1d 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2734,6 +2734,10 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	ret = setup_rmid_lru_list();
+	if (ret)
+		goto out;
+
 	ret = rdtgroup_setup_root(ctx);
 	if (ret)
 		goto out;
@@ -4568,4 +4572,5 @@ void resctrl_exit(void)
 	 */
 
 	resctrl_l3_mon_resource_exit();
+	free_rmid_lru_list();
 }
-- 
2.51.0

