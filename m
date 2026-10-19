Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443058;
	b=Cb5yrnVnChJ4hoBk/2FHILerkDn33FiBiisa51L0AUFLHHxJUIkRNSR+fuzC3XlxnDdj
	 MnSGWajpbhsBCKZHUCHT/KvkNdOex3teRyhn3Ge/8X9kLu4U3+4fE6v+lXLGDtPpQ3L3R
	 nhi2BIX5qrjsAjGNe54Kp5gcZFHQ5A00VoXkWVH7xAEM0UxHq8lkaVoeHMXB7Q7HmVdd5
	 oDsYHUGHj4j4JnGiUES3Zl63/833LAUE0WbWIeDRHCBld8VhWfDBLRUliWBQULhVal/uD
	 whzQIHz1F/c//mUv78QT8ej6sOj/vN+4dfoljeJ7qBL0V58PRaoozHe5LawVpIyHXBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443058;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=q2EMgSjpPBPO62ZV1j2Wk1ycPQMdhNoW/sg/0kL7Xf4=;
	b=TngHR9IhhnlRpo5BAM6iIASdf/EZWCmgZO+A8KO6EFBy8djCt1SD2RXp4/LR+unullbW
	 3gvBATgpZauWl9ZbUaM/pwCXZsIFOGVveylMS2G/QRSoCJ4ATzC1LIBuSAJN/yjL1Na/q
	 DqRL8f2baxwPKarBEuNxECK4agIVXzlpOUzW2zhJX0+sxsXPLIs6MZ7/CoJab2le3Wvh3
	 HhoqPHY77J9umkymy27tySWBVTWe0PZ+JvAuWXdWJ/+s6xQ9hnbqYtdONpc6dOD2LDAH5
	 7G3ZWRBKdh+CjcRW30VFHWpaIBg3Q1DBwOc/Do2pKGQOfGjGcsZS2tRHWsmOgdMGH8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=azAn4nE4;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA9560A2607
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADA9560A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=azAn4nE4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443058; x=1823979058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pUOIp7znB1XND2Y7RoTTlqpgm8CZT1KyJ4ww0J3mmq8=;
  b=azAn4nE4wHc/g35grxPRneQrDfkaagL0RztrofFlpMTLdqs3BvG/s18/
   mB63HyAKA3wwLu2uBlFcycuMq5WEOFWjV90yU5BSgQXKb4r8aXrJ7a9Vj
   lp/RFIK+Wkqd/Qvup7vpiZHdwgjEx7NjcCESWihdtxMuo8Y4lND/ghg0p
   j2NEiXHF5YnuGvRXIGmmOlUGwUcr3u2Mt9zWrR87Op3KggISACTO1iBo1
   kOEvmPoCZTQqDw22ht52eP5z3IQZSiujA1y0sQnc6W3EFztpkBk/8D81T
   nPSAF2prbp5juXoNBmt2GavQBBlO9T3WqN9qEB64r2QFYqOWJZMT0i5Mu
   A==;
X-CSE-ConnectionGUID: 3aIVbSKVReaq0y8MEumkOg==
X-CSE-MsgGUID: ukmUlylDTAm4KPSOea4fqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131208"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131208"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:50 -0700
X-CSE-ConnectionGUID: uS0+jwY2R1qDkRp27kWx7g==
X-CSE-MsgGUID: lxsbvjIWTy+EDkY3XW67Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008657"
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
Subject: [PATCH v14 12/24] arm,x86,fs/resctrl: Allocate maximum needed rmid_ptrs[]
Date: Mon, 19 Oct 2026 13:50:19 -0700
Message-ID: <20261019205031.16977-13-tony.luck@intel.com>
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

resctrl keeps per-RMID state in rmid_ptrs[]. It is allocated on first
mount, sized for the number of RMIDs available at that time, and reused by
every subsequent mount. The number of RMIDs available is the smallest
number supported across all monitoring resources.

Application Energy Telemetry (AET) requires the pmt_telemetry driver
to be built in. Allowing it to be a module means AET may contribute to
that smallest number on one mount and not on the next, so a later mount
may need more entries than the first mount allocated. Reallocating per
mount is not possible because the limbo handler continues to access
rmid_ptrs[] after resctrl is unmounted.

Size rmid_ptrs[] for the maximum number of RMIDs the system can ever need,
as reported by a new architecture hook. On x86 this is the number of RMIDs
supported by L3 monitoring if present, since that bounds the number
available on every mount, and otherwise the number of RMIDs that
MSR_IA32_PQR_ASSOC.RMID can hold.

Rebuild the free list on every mount from the RMIDs available for that
mount. Leave out RMIDs still dirty from an earlier mount, because the
limbo handler returns them to the free list once they are clean.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	New commit message.
---
 include/linux/resctrl.h            |  1 +
 arch/x86/kernel/cpu/resctrl/core.c | 27 +++++++++++++
 drivers/resctrl/mpam_resctrl.c     |  9 +++++
 fs/resctrl/monitor.c               | 64 ++++++++++++++++++++----------
 4 files changed, 79 insertions(+), 22 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 764c45be2d59..7afeb3bd55d9 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -447,6 +447,7 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
 /* The number of closid supported by this resource regardless of CDP */
 u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
+u32 resctrl_arch_system_max_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2e3b9c16cbda..8702a6da2374 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -45,6 +45,9 @@ static DEFINE_MUTEX(domain_list_lock);
  */
 DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
+/* Number of unique RMID values that can be written to MSR_IA32_PQR_ASSOC.RMID */
+static u32 pqr_assoc_num_rmid;
+
 static void mba_wrmsr_intel(struct msr_param *m);
 static void cat_wrmsr(struct msr_param *m);
 static void mba_wrmsr_amd(struct msr_param *m);
@@ -124,6 +127,28 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
+/**
+ * resctrl_arch_system_max_rmid_idx - Largest possible RMID index
+ *
+ * Return: Largest possible RMID index used for boot time allocations.
+ */
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	u32 num_rmid = pqr_assoc_num_rmid;
+
+	/*
+	 * If the system is capable of L3 monitoring the maximum RMID value may
+	 * be lower than the system maximum. Either because the L3 monitoring
+	 * feature supports fewer RMIDs, or because SNC (Sub-NUMA Cluster)
+	 * is enabled and divides RMIDs per cluster.
+	 */
+	if (r->mon_capable)
+		num_rmid = r->mon.num_rmid;
+
+	return num_rmid;
+}
+
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 {
 	if (l >= RDT_NUM_RESOURCES)
@@ -967,6 +992,8 @@ static __init bool get_rdt_mon_resources(void)
 	if (!cpu_feature_enabled(X86_FEATURE_CQM))
 		return false;
 
+	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
+
 	/* Any of the L3 monitoring features? */
 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
 		return false;
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 7ddee8f5162f..52726f7fd03f 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -257,6 +257,15 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
 }
 
+/*
+ * File system calls this for one-time allocation of structures.
+ * Return the largest possible value.
+ */
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	return resctrl_arch_system_num_rmid_idx();
+}
+
 u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
 {
 	return closid * (mpam_pmg_max + 1) + rmid;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index fbbb31e9618b..647dad02fffd 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -75,6 +75,11 @@ static unsigned int rmid_limbo_count;
  */
 static struct rmid_entry	*rmid_ptrs;
 
+/*
+ * @num_rmid_ptrs - The number of elements in rmid_ptrs[].
+ */
+static u32 num_rmid_ptrs;
+
 /*
  * This is the threshold cache occupancy in bytes at which we will consider an
  * RMID available for re-allocation.
@@ -961,45 +966,60 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 
 int setup_rmid_lru_list(void)
 {
-	struct rmid_entry *entry = NULL;
-	u32 idx_limit;
-	u32 idx;
+	struct rmid_entry *entry;
+	u32 cur_idx_limit;
+	u32 rsvd_idx;
 	int i;
 
 	if (!resctrl_mon_capable())
 		return 0;
 
 	/*
-	 * Called on every mount, but the number of RMIDs cannot change
-	 * after the first mount, so keep using the same set of rmid_ptrs[]
-	 * until resctrl_exit(). Note that the limbo handler continues to
-	 * access rmid_ptrs[] after resctrl is unmounted.
+	 * Allocate the largest number of RMIDs that this system will ever
+	 * need. These cannot be freed until resctrl_exit() because the limbo
+	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
 	 */
-	if (rmid_ptrs)
-		return 0;
+	if (!rmid_ptrs) {
+		num_rmid_ptrs = resctrl_arch_system_max_rmid_idx();
+		rmid_ptrs = kzalloc_objs(struct rmid_entry, num_rmid_ptrs);
+		if (!rmid_ptrs) {
+			num_rmid_ptrs = 0;
+			return -ENOMEM;
+		}
 
-	idx_limit = resctrl_arch_system_num_rmid_idx();
-	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
-	if (!rmid_ptrs)
-		return -ENOMEM;
+		for (i = 0; i < num_rmid_ptrs; i++) {
+			entry = &rmid_ptrs[i];
+			INIT_LIST_HEAD(&entry->list);
 
-	for (i = 0; i < idx_limit; i++) {
-		entry = &rmid_ptrs[i];
-		INIT_LIST_HEAD(&entry->list);
+			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
+		}
+	}
 
-		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
-		list_add_tail(&entry->list, &rmid_free_lru);
+	/* Find how many RMIDs are available for this mount */
+	cur_idx_limit = resctrl_arch_system_num_rmid_idx();
+	if (cur_idx_limit > num_rmid_ptrs) {
+		pr_warn_once("RMID count %u exceeds allocation. Limit to %u\n",
+			     cur_idx_limit, num_rmid_ptrs);
+		cur_idx_limit = num_rmid_ptrs;
 	}
 
+	INIT_LIST_HEAD(&rmid_free_lru);
+
 	/*
 	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
 	 * are always allocated. These are used for the rdtgroup_default
 	 * control group, which was setup earlier in rdtgroup_setup_default().
 	 */
-	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
-					   RESCTRL_RESERVED_RMID);
-	entry = __rmid_entry(idx);
-	list_del(&entry->list);
+	rsvd_idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
+						RESCTRL_RESERVED_RMID);
+
+	for (i = 0; i < cur_idx_limit; i++) {
+		entry = &rmid_ptrs[i];
+		/* Don't add reserved or busy entries to free list */
+		if (i == rsvd_idx || entry->busy)
+			continue;
+		list_add_tail(&entry->list, &rmid_free_lru);
+	}
 
 	return 0;
 }
-- 
2.56.0

