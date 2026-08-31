Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C7247D948
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198285; cv=none; b=nKuHkVo1QGDrjbG0M/PQSHRR4icmlXLSTKxwgtblRI+TTEWAdGPFWnvaElp5FK5Tdq53vm16wW58pckA41VPtPViVgYID2QZs/TygeX4D3hVK6ectFv7wFDwJBnuDorz8qlbRTaNiaByRfLlPIszsy4ILRjZMZDPh1tKgSjCDXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198285; c=relaxed/simple;
	bh=JqOGJ/moTFxUxenAXiaBr8MZLPkGD5oiOTlJiRlC1do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KejY3Vzl12f1PYZ3WD8eWRQ/UhtyOK+W3serX506CRfKXptASh7xvsobhqevGpMqx2xxe+eur/ldXhj4oFqVaL8cPBL2bEF+5zdBpG/TPomz+x+ksZi078SCTaOGNWPHsZ79iXy+mmcSRHFDlC3U+e+kinJnBULCdwB9+Dvep4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MsAk5Uq9; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MsAk5Uq9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198283; x=1819734283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JqOGJ/moTFxUxenAXiaBr8MZLPkGD5oiOTlJiRlC1do=;
  b=MsAk5Uq9VhNsmaFCJ43/LUkHSEf+fj1mn2y9jCbxjR+uyH2N5TVJGhWi
   8HqREByqWdC/QjOeEyHY1gSjJzw4Z9m1YhVQjYENsCw1Az7OGGnyLxoxA
   CRG6cwcm3BTrn09aLrq4lCQzIC9wgfbqLXvfRPUW7H8Loib3hZoIBbK+0
   TXQKl8NjErRO5Yr9LjlNv4ItIoRGyWCbM2oFTAZhdwtQ2q3nogGpmtztm
   i7JWRC/oSuEYVXJ2/tVr2KJ0OY51SIqBgwHiNFGiKojppr5bgiC9vgexs
   cFOwoF6p2LC1WiKpLcWkhzR/6RPBlF1hqzZODmy/fjxF4IlpuTrKtnTTd
   Q==;
X-CSE-ConnectionGUID: ewZcWJmrSVO2+N2+oZu9dw==
X-CSE-MsgGUID: TIYPzWlMTSeO/nurndQ+Og==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480045"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480045"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:39 -0700
X-CSE-ConnectionGUID: kTvsJEiARou2xC/4AXxAqA==
X-CSE-MsgGUID: 9LJ/jRnLTlenmifEHJy6kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906998"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:38 -0700
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
Subject: [PATCH v11 14/23] x86/resctrl: Enforce system RMID limit on AET event groups
Date: Mon, 31 Aug 2026 10:44:12 -0700
Message-ID: <20260831174421.13921-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AET (Application Energy Telemetry) event groups each support a specific
number of RMIDs. But that number may be lower than the number supported
by the system. This is especially true on systems with SNC (Sub-NUMA Cluster)
enabled as that reduces the number of supported RMIDs.

Reduce all event_group::num_rmid to system maximum.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	Split out as separate patch

 arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c      |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 19 +++++++++++++++----
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index d70c8cb1cb81..27dc27480f6e 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -235,6 +235,7 @@ void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
+void __init intel_aet_init(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
@@ -242,6 +243,7 @@ void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
+static inline void intel_aet_init(void) { }
 static inline void __exit intel_aet_exit(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 0ddec2b67e3d..8b763cf638ef 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1131,6 +1131,8 @@ static int __init resctrl_arch_late_init(void)
 	if (!get_rdt_resources())
 		return -ENODEV;
 
+	intel_aet_init();
+
 	state = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
 				  "x86/resctrl/cat:online:",
 				  resctrl_arch_online_cpu,
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 4ad6ad78e93e..fef1081f926d 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -65,10 +65,10 @@ struct pmt_event {
  * @force_on:		True when "rdt" command line overrides disable of this
  *			event group.
  * @guid:		Unique number per XML description file.
- * @num_rmid:		Number of RMIDs supported by this group. May be
- *			adjusted downwards if enumeration from
- *			intel_pmt_get_regions_by_feature() indicates fewer
- *			RMIDs can be tracked simultaneously.
+ * @num_rmid:		Number of RMIDs supported by this group. May be adjusted
+ *			downwards if the system supports fewer RMIDs or
+ *			enumeration from intel_pmt_get_regions_by_feature()
+ *			indicates fewer RMIDs can be tracked simultaneously.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
  * @evts:		Array of event descriptors.
@@ -325,6 +325,17 @@ bool intel_aet_get_events(void)
 	return ret;
 }
 
+void __init intel_aet_init(void)
+{
+	u32 max_rmid = resctrl_arch_system_max_rmid_idx();
+	struct event_group **peg, *e;
+
+	for_each_event_group(peg) {
+		e = *peg;
+		e->num_rmid = min(max_rmid, e->num_rmid);
+	}
+}
+
 void __exit intel_aet_exit(void)
 {
 	struct event_group **peg;
-- 
2.55.0

