Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04EB3ACEF4
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343815; cv=none; b=r5E59hjsMJtq7VG+UIpvkDkfAWlpR6DzW+SpcJe6MYyYBkXwSN82SDgchPY8UaIhZE6svr3efneoC74W153MVoOoFi4lbEqNUqI9sdp9Oj4w7yhNdcOWVICVIaY6w7InuVlQkDYQG5J7WestP9G2ZMEi1mSj6gf5tNGxC5rAno4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343815; c=relaxed/simple;
	bh=nCYc6fH1RLD1MGo78gaYDpKcyUShs28yNo/4DjBwTPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnCEbTytG5pwOvroGk5dcjFQKjz2hgvLCpp+VMSTlhYWGPEk9xxy/XIuTX24emTXvTFPLGfZ4S4758D2ea133VN90UhAJqmXk2080miLQuH5DRTTRbaqZ551W9zPMprY1migiW9UxzB0E/Ba6VLWEguuhFn/mcImzyC1cf53aPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=evXrOfQa; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="evXrOfQa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343807; x=1811879807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nCYc6fH1RLD1MGo78gaYDpKcyUShs28yNo/4DjBwTPs=;
  b=evXrOfQaxP4TR6jD8iwEdcKY1zrCGlQiALcqVcEyl3Q8VtGtFhCE61/E
   ZVsjDHWsIl4lbwGz8p8bCYXyu/U+PM/41EFJb6fWw49cjWBn1bhJ0xIVk
   nsJyBdqgNctB8zdXos4MxYE/OxyRaaDPOK5nnpdkDL9OP7wf+2z8xQQ5l
   xPmgf/tBmpR16+ANLvdPOERZde92N6hzfhFzOnPo0hTzVwL+R6uu1cjzI
   Sx5BtL0kNhUEOt1U/5Y1KQHn90r/dmAPJoZLSuyUrz+HWqrPmTAOF9YJs
   8C3GtN1JEpiCn09t/riwVikwSvW2N+/fPd24g/cxWAJi1aDWqAavJt85Z
   w==;
X-CSE-ConnectionGUID: 54LhSbCyQ6W/mN617P9K+A==
X-CSE-MsgGUID: XJQQwXgyT9WvdzbaDpfYXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011625"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011625"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:43 -0700
X-CSE-ConnectionGUID: cl39qHC2S9CqYDKdcDZGZQ==
X-CSE-MsgGUID: d9CStnUQTSqPgGjzZQVPpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946516"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:42 -0700
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
Subject: [PATCH v7 08/14] fs,x86,mpam/resctrl: Handle change in number of RMIDs on each mount
Date: Mon,  1 Jun 2026 12:56:26 -0700
Message-ID: <20260601195632.15876-9-tony.luck@intel.com>
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

Application Energy Telemetry (AET) event enumeration takes place
asynchronously. Linux builds the pmt_telemetry module into the kernel to
kick of enumeration early enough that it completes before first mount of
the resctrl file system.

Allowing pmt_telemetry to be a loadable module means that it is possible
for different numbers of RMIDs to be supported on each mount, depending
on whether pmt_telemetry module is loaded.

Add resctrl_arch_system_max_rmid_idx() interface to provide the maximum
supported number of RMIDs on a system. For x86 this is RDT_RESOURCE_L3
rdt_resource::mon.num_rmid (if L3 monitoring is enabled).

Allocate the rmid_ptrs, rdt_l3_mon_domain::rmid_busy_llc, and
rdt_l3_mon_domain::mbm_states based on the maximum possible.

Initialize rmid_free_lru based on the number of RMIDs available for
this mount.

Note that some RMIDs may still be marked busy from a previous mount.
Don't add these to the free list. Check current RMID limit in
limbo_release_entry() and do not add out of range RMIDs to the
free list.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  1 +
 arch/x86/kernel/cpu/resctrl/core.c | 12 ++++++++
 drivers/resctrl/mpam_resctrl.c     |  5 ++++
 fs/resctrl/monitor.c               | 47 ++++++++++++++++++++----------
 fs/resctrl/rdtgroup.c              |  2 +-
 5 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index a8338656f836..3705f0214fa6 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -412,6 +412,7 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
 /* The number of closid supported by this resource regardless of CDP */
 u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
+u32 resctrl_arch_system_max_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 1af8f965fdd0..934492c7e643 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -129,6 +129,18 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
+/**
+ * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
+ *
+ * Return: If L3 monitoring is supported, largest possible comes from L3.
+ */
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+
+	return r->mon_capable ? r->mon.num_rmid : resctrl_arch_system_num_rmid_idx();
+}
+
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 {
 	if (l >= RDT_NUM_RESOURCES)
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 226ff6f532fa..7079870ca894 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -272,6 +272,11 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
 }
 
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	return resctrl_arch_system_num_rmid_idx();
+}
+
 u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
 {
 	return closid * (mpam_pmg_max + 1) + rmid;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 327e7a863614..b374e2f84a75 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -115,10 +115,17 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 
 static void limbo_release_entry(struct rmid_entry *entry)
 {
+	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	rmid_limbo_count--;
-	list_add_tail(&entry->list, &rmid_free_lru);
+
+	/*
+	 * Limbo may be freeing an RMID from a previous mount where there
+	 * were more RMIDs available.
+	 */
+	if (resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid) < idx_limit)
+		list_add_tail(&entry->list, &rmid_free_lru);
 
 	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID))
 		closid_num_dirty_rmid[entry->closid]--;
@@ -133,7 +140,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
 void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
 	struct rmid_entry *entry;
 	u32 idx, cur_idx = 1;
 	void *arch_mon_ctx;
@@ -192,7 +199,7 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 bool has_busy_rmid(struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
 
 	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
 }
@@ -916,24 +923,32 @@ int setup_rmid_lru_list(void)
 		return 0;
 
 	/*
-	 * Called on every mount, but the number of RMIDs cannot change
-	 * after the first mount, so keep using the same set of rmid_ptrs[]
-	 * until resctrl_exit(). Note that the limbo handler continues to
-	 * access rmid_ptrs[] after resctrl is unmounted.
+	 * Allocate the largest number of RMIDs that this system will ever
+	 * need. These cannot be freed until resctrl_exit() because the limbo
+	 * handler  continues to access rmid_ptrs[] after resctrl is unmounted.
 	 */
-	if (rmid_ptrs)
-		return 0;
+	if (!rmid_ptrs) {
+		idx_limit = resctrl_arch_system_max_rmid_idx();
+		rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
+		if (!rmid_ptrs)
+			return -ENOMEM;
+
+		for (i = 0; i < idx_limit; i++) {
+			entry = &rmid_ptrs[i];
+			INIT_LIST_HEAD(&entry->list);
+
+			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
+		}
+	}
 
+	/* Find how many RMIDs are needed for this mount */
 	idx_limit = resctrl_arch_system_num_rmid_idx();
-	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
-	if (!rmid_ptrs)
-		return -ENOMEM;
 
+	INIT_LIST_HEAD(&rmid_free_lru);
 	for (i = 0; i < idx_limit; i++) {
 		entry = &rmid_ptrs[i];
-		INIT_LIST_HEAD(&entry->list);
-
-		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
+		if (i && entry->busy)
+			continue;
 		list_add_tail(&entry->list, &rmid_free_lru);
 	}
 
@@ -1156,7 +1171,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
  */
 static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
 	enum resctrl_event_id evt;
 	int idx;
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index d2a1f88d8782..6d647b71c5db 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4416,7 +4416,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
 	size_t tsize = sizeof(*d->mbm_states[0]);
 	enum resctrl_event_id eventid;
 	int idx;
-- 
2.54.0

