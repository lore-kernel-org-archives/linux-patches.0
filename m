Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BA0370AF6
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346089; cv=none; b=F8+4qH8VEhiV8vj59gNcGC7HsJxkFTijXOHG0DOhIkj6ETqQGHsFjMA10k+gGT+yDuTp2Tday4lX4qdqKC2HnASAj6b8flHhXZ+B/NqPjmHpG3sRJh33oHxElPzbQ+9K/XXLdJvvxhYcC/gjHaOo9riF66ku8cJVR/st1sUuWGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346089; c=relaxed/simple;
	bh=JtkuDuA5PL3WZsgVJF6HeGhrQv/7SWiFDCnfop8/yv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+DxGT+36/5VwyGyJnq0WIJ5pFkbxCXvUduPu6bhBD2Jk9h2XZWnPSM3d3V0g8X9QP6FTI95thdR2TSNQwX5M/zpuX5FseVJs2UcidBksjy9x3KzczqORzVCPS3QzBsWnuVIVNN114PD7ejS4DTNe7yPm7yHJxiAxFccYkTeesQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XzBsiqMh; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XzBsiqMh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346088; x=1816882088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JtkuDuA5PL3WZsgVJF6HeGhrQv/7SWiFDCnfop8/yv4=;
  b=XzBsiqMhNB7LK8UvYTXwtnUdK++L5VgLxN1nEXyTXajc/cy1y2mCUx/q
   ujlFgfiKQ+MOJWm8TCT7X05xR0Yi270ddLUsuZG3gVznyVp9YRXzpY55V
   jEKX+3VV9/DcwXTIQzTjIVQI+AuRCDUKw3x2HGnlxwywsZQF8Lh7fERdE
   6UgIjyRetow6gOoOKC+/zRskX5EkDz/qeFRTTlYJfg1Q9bE5AwTGkGqXp
   yDiVYgRBG0a6+Q6fKsuHEmZzweJVjHtr3085nhgtft6MnyVTGXurEyVfP
   DN3yhTBZM/AmD8H1oq4RegOIn4s6TNvlUvGgs//CvY+REJjdl9RTklVFv
   g==;
X-CSE-ConnectionGUID: U25NMrniTTulOB3c7oEDGA==
X-CSE-MsgGUID: +bRNAw7dQl240U2C4APzoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473619"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473619"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:01 -0700
X-CSE-ConnectionGUID: nR9C9dZASlC2VVZpGB7X6g==
X-CSE-MsgGUID: vM8StwSERZ6mTccpx7PbSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024582"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:01 -0700
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
Subject: [PATCH v10 08/17] x86/resctrl: Enforce system RMID limit on AET event groups
Date: Wed, 29 Jul 2026 10:27:43 -0700
Message-ID: <20260729172752.11561-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AET (Application Energy Telemetry) event groups each support a specific
number of RMIDs. But that number may be lower than the number supported
by the system. Especially true on systems with SNC (Sub-NUMA Cluster)
enabled as that reduces the number of supported RMIDs.

Fix get_rdt_mon_resources() to return true when any monitor resource is
possibly enabled. Call intel_aet_init() to adjust the event_group::num_rmid
values to not exceed the system supported maximum.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	New patch

 arch/x86/kernel/cpu/resctrl/internal.h  |  4 +++-
 arch/x86/kernel/cpu/resctrl/core.c      |  8 +++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 17 +++++++++++++----
 arch/x86/kernel/cpu/resctrl/monitor.c   |  4 +---
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92..8e4f0bb91785 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -224,7 +224,7 @@ union l3_qos_abmc_cfg {
 
 void rdt_ctrl_update(void *arg);
 
-int rdt_get_l3_mon_config(struct rdt_resource *r);
+void rdt_get_l3_mon_config(struct rdt_resource *r);
 
 bool rdt_cpu_has(int flag);
 
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
index 092764cf693f..2c938b97b147 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1019,10 +1019,10 @@ static __init bool get_rdt_mon_resources(void)
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
 		ret = true;
 
-	if (!ret)
-		return false;
+	if (ret)
+		rdt_get_l3_mon_config(r);
 
-	return !rdt_get_l3_mon_config(r);
+	return boot_cpu_data.x86_cache_max_rmid > 0;
 }
 
 static __init void __check_quirks_intel(void)
@@ -1169,6 +1169,8 @@ static int __init resctrl_arch_late_init(void)
 	if (!get_rdt_resources())
 		return -ENODEV;
 
+	intel_aet_init();
+
 	state = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
 				  "x86/resctrl/cat:online:",
 				  resctrl_arch_online_cpu,
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 4ad6ad78e93e..e6cc57206381 100644
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
@@ -325,6 +325,15 @@ bool intel_aet_get_events(void)
 	return ret;
 }
 
+void __init intel_aet_init(void)
+{
+	u32 max_rmid = resctrl_arch_system_max_rmid_idx();
+	struct event_group **peg;
+
+	for_each_event_group(peg)
+		(*peg)->num_rmid = min(max_rmid, (*peg)->num_rmid);
+}
+
 void __exit intel_aet_exit(void)
 {
 	struct event_group **peg;
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 1fea893f2cc1..f40f5dd1440c 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -407,7 +407,7 @@ static __init int snc_get_config(void)
 	return ret;
 }
 
-int __init rdt_get_l3_mon_config(struct rdt_resource *r)
+void __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
 	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
@@ -466,8 +466,6 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 	}
 
 	r->mon_capable = true;
-
-	return 0;
 }
 
 void __init intel_rdt_mbm_apply_quirk(void)
-- 
2.55.0

