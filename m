Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443059;
	b=4KHrTX1H7NfPm6cI8zvZBwWfKtCVJdbW6xf+u/SZMz2JpmbO6Joqm+s9pLWmx4yg1AT7
	 xX7BDQXJs0ogzNorn1Wxa9TbbRufKqf/aSsTosZBryOlTkSMGt+ZYecRevBz/3ibotvdx
	 ZPBIkBD9qvdhM8WzyB63QdzJWBcZajjvLtNCWBvk6wwCkpsU/adBFTfGZSrmU/icWMUIa
	 +2+0NSLeylOgk1hqcbh8kP0IpObqzMvMNwI+F4KBCjowjxi81ig+EP7O8D+32GwKaA0Sq
	 qJ60dh0yoP7a42/5isJm3r5r23pY6APtoJeVwH99Uk9VG+6GgQo20Q5vR3kPh/4NLhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443059;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EWCAukJpfypXkJ1AUHDx2SYvDPMDe89HV7B/yJCZQoA=;
	b=kJHoVIj+FlnUjw29mDCqBV+UWYE0guIpejHSbunbCiAGtmlJVP0oXMYNNyP60IFg7obX
	 D3PAoTkrixUpZPFi5m4Ab3HLsRruyRS5JsQKAJtA0gQ/6cElTcChujBJbz0czTXKyjRCb
	 oMjBZz5iWgeRPPjrtIUMPFrp8lKuQZuy5ljimeDbOf97HCoKD4Ir+hYNWcB7Rjuqzkr9M
	 d5OXs0W+iO2FLtY4pUBPWFmKc+UwhPniB8UnbQGLF8ooL6YrrEpRpr/AEAKL08MFzKXUE
	 xXgFzxL2hNQh+E6k4uVLOEasr9LdBHCooc2ZDD7Vxf5UuYOMyCi0paMcwccu8FeW6Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="VohbPUF/";
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1741560A2610
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1741560A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VohbPUF/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443058; x=1823979058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HIJZHhW18EuAZhzseoz+2uCOpZJSfJvc5qIXkMj4+VY=;
  b=VohbPUF/enGpDuJV4v5fezKcnc7EdJHJKdXjI2Lm9+Oemi4GB+yT6a6d
   weGF4bxLIKMM+aCpnmZjku4oQgfARqx8y0ugSyFsn7Bzp2UJ8WROw4Az7
   m5hRSo3cNVy518HiPRe3cMbPLGo0wHMK7UWoR24fxihgbhophLi1eDTW6
   7g5mUeZp+flH5C1u58VTxdtxiT/YCU6jG2eByVMPiJqnuBM70RXAIkAUn
   LHI+EPYPsStmPmBsdmzTVNnoMKxMRB22UQa07ZemY3DfT7mhLK6A+NxF2
   6p9uU3ToNucfnJIDl5LFHNIF3I/zvebREI0gc/PSn1nBwjo83EuT5JH2I
   w==;
X-CSE-ConnectionGUID: VKhCPN1gQ9KQriyYRHV1Xw==
X-CSE-MsgGUID: VZrBrZa0TdqqffIx/CZ34Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131215"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131215"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:50 -0700
X-CSE-ConnectionGUID: khEYXUwAQtuz0yTxrvSzuQ==
X-CSE-MsgGUID: 4YZziXq0SgWx73OAUUz7/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008660"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:50 -0700
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
Subject: [PATCH v14 13/24] arm,x86,fs/resctrl: Use right size for L3 monitor data structures
Date: Mon, 19 Oct 2026 13:50:20 -0700
Message-ID: <20261019205031.16977-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On x86 the number of RMIDs available for use is the smallest number of RMIDs
supported by any resource that supports monitoring.

Each L3 monitoring domain has structures with one entry per RMID index,
allocated when the domain comes online and kept across mounts of the resctrl
file system:

* the bitmap of RMIDs in limbo with L3 occupancy above the threshold,
* the per-event state used by the "mba_MBps" software controller to compute
bandwidth,
* on x86, the per-event state that accumulates MBM counts across hardware
counter overflow.

The resctrl file system sizes and walks the first two using the number of
RMIDs available for use. x86 already sizes the third by the number of RMIDs
supported by L3 monitoring.

The number of RMIDs available for use does not currently change between
mounts because Application Energy Telemetry (AET) is enumerated only once. In
preparation for building the pmt_telemetry driver as a module, AET will be
enumerated on every mount, and its events will be available only when the
driver is loaded at that time. The number of RMIDs available for use can
then change between mounts while the L3 domain structures stay allocated. A
domain that comes online while the number is small would be too small for a
later mount. RMIDs that are still in limbo at unmount may also be beyond the
number of RMIDs available for the next mount.

Add resctrl_arch_get_num_rmid_idx() for the architecture to report the
number of RMID indexes a resource supports, which does not change between
mounts. On x86 this is the number of RMIDs supported by L3 monitoring. MPAM
keeps reporting the system-wide number. Use it to size and walk the L3
domain structures.

Keep checking every RMID supported by L3 for limbo. Do not return an RMID
to the free list when it is beyond the number of RMIDs available for the
current mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	New commit message.
---
 include/linux/resctrl.h            |  7 +++++--
 arch/x86/kernel/cpu/resctrl/core.c |  5 +++++
 drivers/resctrl/mpam_resctrl.c     |  5 +++++
 fs/resctrl/monitor.c               | 22 ++++++++++++++++++----
 fs/resctrl/rdtgroup.c              |  2 +-
 5 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 7afeb3bd55d9..c77e24c0d8b6 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -183,10 +183,12 @@ struct mbm_cntr_cfg {
  * struct rdt_l3_mon_domain - group of CPUs sharing RDT_RESOURCE_L3 monitoring
  * @hdr:		common header for different domain types
  * @ci_id:		cache info id for this domain
- * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
+ * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold. Sized for
+ *			maximum supported RMIDs in L3 resource.
  * @mbm_states:		Per-event pointer to the MBM event's saved state.
  *			An MBM event's state is an array of struct mbm_state
  *			indexed by RMID on x86 or combined CLOSID, RMID on Arm.
+ *			Sized same as @rmid_busy_llc.
  * @mbm_over:		worker to periodically read MBM h/w counters
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
@@ -444,8 +446,9 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
 	return WARN_ON_ONCE(1);
 }
 
-/* The number of closid supported by this resource regardless of CDP */
+/* The number of closid/rmid supported by this resource regardless of CDP */
 u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
+u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 u32 resctrl_arch_system_max_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8702a6da2374..b32fa143283e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -380,6 +380,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r)
 	return resctrl_to_arch_res(r)->num_closid;
 }
 
+u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r)
+{
+	return r->mon.num_rmid;
+}
+
 void rdt_ctrl_update(void *arg)
 {
 	struct rdt_hw_resource *hw_res;
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 52726f7fd03f..360a50eb0cd3 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -252,6 +252,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
 	return mpam_partid_max + 1;
 }
 
+u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *ignored)
+{
+	return resctrl_arch_system_num_rmid_idx();
+}
+
 u32 resctrl_arch_system_num_rmid_idx(void)
 {
 	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 647dad02fffd..4c7308c84657 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -120,10 +120,18 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 
 static void limbo_release_entry(struct rmid_entry *entry)
 {
+	u32 cur_idx_limit = resctrl_arch_system_num_rmid_idx();
+
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	rmid_limbo_count--;
-	list_add_tail(&entry->list, &rmid_free_lru);
+
+	/*
+	 * Limbo may be freeing an RMID from a previous mount where there
+	 * were more RMIDs available.
+	 */
+	if (resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid) < cur_idx_limit)
+		list_add_tail(&entry->list, &rmid_free_lru);
 
 	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID))
 		closid_num_dirty_rmid[entry->closid]--;
@@ -138,7 +146,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
 void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	struct rmid_entry *entry;
 	bool rmid_dirty = true;
 	u32 idx, cur_idx = 1;
@@ -159,6 +167,11 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	 * are marked as busy for occupancy < threshold. If the occupancy
 	 * is less than the threshold decrement the busy counter of the
 	 * RMID and move it to the free list when the counter reaches 0.
+	 *
+	 * RMIDs will keep counts of allocated LLC entries after the resctrl
+	 * file system is unmounted. So check all possible RMIDs since a
+	 * previous mount cycle may have used more than are available in
+	 * this mount cycle.
 	 */
 	for (;;) {
 		idx = find_next_bit(d->rmid_busy_llc, idx_limit, cur_idx);
@@ -202,7 +215,8 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 bool has_busy_rmid(struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+	u32 idx_limit = resctrl_arch_get_num_rmid_idx(r);
 
 	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
 }
@@ -1240,7 +1254,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
  */
 static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	enum resctrl_event_id evt;
 	int idx;
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 7cf809380c53..79d4ddc3d64d 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4619,7 +4619,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	u32 idx_limit = resctrl_arch_get_num_rmid_idx(r);
 	size_t tsize = sizeof(*d->mbm_states[0]);
 	enum resctrl_event_id eventid;
 	int idx;
-- 
2.56.0

