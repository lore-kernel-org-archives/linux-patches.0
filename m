Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE689242D9D
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278052; cv=none; b=FB74GInwEeIC66/MYZtHJMvNg5kZcFmv4fSRc/pPjuKDIBVCbndyQALwFnPWOyMpu7SAWvIY+/UH0zEUh2dWGtiegcSrlTlMsMjcXDeXF1bdNcxJG+49y7ZrccDMZtiq5Q9jYR9kUGZp15lg8Y80aMF+eMagJ+PRFLESQ347PdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278052; c=relaxed/simple;
	bh=U1ifVbvO+qNS8csk9YqAqbdJ9si8vGjr9Ymt+ieUuVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnhX7Zfndp8kSsbISKkoIDJDQDBqt4Z5kMphQlAEKEnL7D7RXPD6kP0tWiUgXw2BKRaFKzUCu17IOlqkzsWuhy/6Mm5yb5Akvj2I/BzhbvnAGhvNpZ62CCA0u6p/5IeRqJTe2zxHdNktPXPjftcSbzj6vv2sJ2qNmXaxuLmfdII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hItRnwDq; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hItRnwDq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278050; x=1783814050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U1ifVbvO+qNS8csk9YqAqbdJ9si8vGjr9Ymt+ieUuVw=;
  b=hItRnwDqGYN3DqvnvOKc1t656PPclFB9Qxw7oRUz+QcJEQDoeoKNtPp0
   /D1O2FUEBCbGMJCotAFkabVbGxacJUgBmbr1hG4TJ7cZFWwG/lLpC6Vl6
   v/SqaOBfbc8qpvmyCFZ28YjFZ5XjdWYnlWczcFwJo5NqgVWl9raQTHi/P
   cPDpzaHNNnHynfnqgi4Xp6P/wUYNOHWH4paQvOc0ibDcnWt3XBJ6jNr71
   NVLu7VZLyxOVffAq5N41k3sn0BoTz1tPTaLpFCKHxTIvX9FnlmwIHFlXX
   pebPOAfZNpXFx3cIguqjjLcMyERU/TF5nfNofoBgO2ifsgWP1CuuN7hZX
   Q==;
X-CSE-ConnectionGUID: fNqfYFr/SYqCI7DrwWx46A==
X-CSE-MsgGUID: UZw/B7w6QgqkhkHCaRtJxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292795"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292795"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:06 -0700
X-CSE-ConnectionGUID: sFKna1jxQ9Wna7KwhDh46g==
X-CSE-MsgGUID: HAXMTZZDQ9iJl5bK3S2UNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902169"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:07 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 27/31] x86,fs/resctrl: Move RMID initialization to first mount
Date: Fri, 11 Jul 2025 16:53:34 -0700
Message-ID: <20250711235341.113933-28-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl file system code assumed that the only monitor events were
tied to the RDT_RESOURCE_L3 resource. Also that the number of supported
RMIDs was enumerated during early initialization.

RDT_RESOURCE_PERF_PKG breaks both of those assumptions.

Delay the final enumeration of the number of RMIDs and subsequent
allocation of structures until first mount of the resctrl file system
so that the number of usable RMIDs can be computed as the minimum
value from all enabled monitor resources.

Since the dom_data* functions now only allocate/free structures
used for RMIDs, rename: dom_data_init() -> rmid_init(),
dom_data_exit() -> rmid_exit().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c |  8 ++++++--
 fs/resctrl/monitor.c               | 26 +++++++++-----------------
 fs/resctrl/rdtgroup.c              |  6 ++++++
 4 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 28d505efdb7c..7fca1849742f 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -358,6 +358,8 @@ int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
 
+int rmid_init(void);
+
 int resctrl_mon_l3_resource_init(void);
 
 void resctrl_mon_l3_resource_exit(void);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 31fb598482bf..1a6635cc5b37 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -112,10 +112,14 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 
 u32 resctrl_arch_system_num_rmid_idx(void)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	u32 num_rmids = U32_MAX;
+	struct rdt_resource *r;
+
+	for_each_mon_capable_rdt_resource(r)
+		num_rmids = min(num_rmids, r->num_rmid);
 
 	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
-	return r->num_rmid;
+	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index e3eceba70713..3fe81c43e5e8 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -833,20 +833,19 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
 }
 
-static int dom_data_init(struct rdt_resource *r)
+int rmid_init(void)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	struct rmid_entry *entry = NULL;
-	int err = 0, i;
 	u32 idx;
+	int i;
 
-	mutex_lock(&rdtgroup_mutex);
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
@@ -866,13 +865,10 @@ static int dom_data_init(struct rdt_resource *r)
 	entry = __rmid_entry(idx);
 	list_del(&entry->list);
 
-out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-
-	return err;
+	return 0;
 }
 
-static void dom_data_exit(struct rdt_resource *r)
+static void rmid_exit(struct rdt_resource *r)
 {
 	mutex_lock(&rdtgroup_mutex);
 
@@ -965,10 +961,6 @@ int resctrl_mon_l3_resource_init(void)
 	if (ret)
 		return ret;
 
-	ret = dom_data_init(r);
-	if (ret)
-		return ret;
-
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
@@ -993,5 +985,5 @@ void resctrl_mon_l3_resource_exit(void)
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
 	closid_num_dirty_rmid_exit();
-	dom_data_exit(r);
+	rmid_exit(r);
 }
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index b45f3d63c629..9e667d3a93ae 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2599,6 +2599,12 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	if (resctrl_arch_mon_capable()) {
+		ret = rmid_init();
+		if (ret)
+			goto out;
+	}
+
 	ret = rdtgroup_setup_root(ctx);
 	if (ret)
 		goto out;
-- 
2.50.0

