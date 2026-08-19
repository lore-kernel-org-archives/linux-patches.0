Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FA8488D86
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787156019; cv=none; b=RyJH44MYD4ZjCCxHaoXDOm2ge0uMX3KhSQbvt9rS5JGnqrkvUa+xB74z6EbTg4hmDVKIDQKQEVIprsq1+YZkksBszO/9AAlpIuyI0mGa/ag9pRnES7bXsab3gJ5b3hevjowjljxAs5LPo6XaBquYCPZpTXHlCxF1FA+Wn/v7AQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787156019; c=relaxed/simple;
	bh=bpDrxydPeJMWiQw6rPyKf5fH9m3VQzJgQysqTivh0QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laSJ0E8boIKt3W1RsSZAz8saFh0j4+rHxKFa6eEHQAF+Wub+spklVIuRpgFa7YKyJENMHP/RPQ9n2WI0sGWQ4waZ9frSl53FM9MQLgQbW8dnK6hT6EljZaWosAPoy9TKb99H+Rsp4U7Bi2w74dKS4l8h93gCEtbPjH3u0tC6yaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OsKXyFMa; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OsKXyFMa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787156017; x=1818692017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bpDrxydPeJMWiQw6rPyKf5fH9m3VQzJgQysqTivh0QM=;
  b=OsKXyFMaH9t+o9ZRXhp9H3GxmnPtDnI9QFWb8KLvXlUr2ukI/JAtT2Ma
   FrW3ikJbBOMmOAh1WHzLnlA81LmzkbXLXS4yZFh06LyTTV7FKdbXsZoEW
   1BIy59hRfZIbMNwDGNb0BYTO1KU/QlGPSfT130I6p8RSjLNCyoPRVU0Sq
   j1GsWpYmW+i9mZBfv/M6+5cmfwEGk/56vURIFLvjNHgJ5RyTUPA7lIz07
   84nmxP4HHdmP6GeaWIeKU1zw4mnFjUeTkUyMg7PN9QXkGDyOXzNUx/INc
   MPYY2HQ/CPWaWyD3RiT/Z00qSsz3Td5RxQl4idL21/khvpzonu0H6UZv/
   w==;
X-CSE-ConnectionGUID: IQ96t2pwTjmfUMdiY0eXeg==
X-CSE-MsgGUID: 08ZLmcEmQVOXeIiBBqxIoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="87598063"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="87598063"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
X-CSE-ConnectionGUID: LD0TjyS9T2+/efPb9VPizw==
X-CSE-MsgGUID: K5KIg28ySWmP0dvX3Haa6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="290391848"
Received: from rodrigoa-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
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
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 3/4] x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
Date: Wed, 19 Aug 2026 09:13:21 -0700
Message-ID: <20260819161323.11587-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819161323.11587-1-tony.luck@intel.com>
References: <20260819161323.11587-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Intel quirk to adjust Memory Bandwidth Monitoring (MBM) values on
certain CPUs is applied early, before discovering if MBM is supported.

Move the call to rdt_get_l3_mon_config(), but keep the decision on
whether it is needed in __check_quirks_intel() with all the other
model specific tests.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h |  4 +--
 arch/x86/kernel/cpu/resctrl/core.c     |  2 +-
 arch/x86/kernel/cpu/resctrl/monitor.c  | 35 +++++++++++++++-----------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92..e46eb9a4c725 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -151,6 +151,8 @@ static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r
 
 extern struct rdt_hw_resource rdt_resources_all[];
 
+extern bool __initdata intel_rdt_mbm_need_quirk;
+
 void arch_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
@@ -228,8 +230,6 @@ int rdt_get_l3_mon_config(struct rdt_resource *r);
 
 bool rdt_cpu_has(int flag);
 
-void __init intel_rdt_mbm_apply_quirk(void);
-
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2677b8a6c15b..da94a12f9256 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1006,7 +1006,7 @@ static __init void __check_quirks_intel(void)
 			set_rdt_options("!l3cat");
 		fallthrough;
 	case INTEL_BROADWELL_X:
-		intel_rdt_mbm_apply_quirk();
+		intel_rdt_mbm_need_quirk = true;
 		break;
 	}
 }
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 0c2aa20148a1..0bce199a5f7b 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -37,6 +37,8 @@ bool rdt_mon_capable;
  */
 unsigned int __ro_after_init rdt_l3_mon_scale;
 
+bool __initdata intel_rdt_mbm_need_quirk;
+
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
 static int snc_nodes_per_l3_cache = 1;
@@ -51,7 +53,7 @@ static int snc_nodes_per_l3_cache = 1;
  * 1. The threshold 0 is changed to rmid count - 1 so don't do correction
  *    for the case.
  * 2. MBM total and local correction table indexed by core counter which is
- *    equal to (x86_cache_max_rmid + 1) / 8 - 1 and is from 0 up to 27.
+ *    equal to r->mon.num_rmid / 8 - 1 and is from 0 up to 27.
  * 3. The correction factor is normalized to 2^20 (1048576) so it's faster
  *    to calculate corrected value by shifting:
  *    corrected_value = (original_value * correction_factor) >> 20
@@ -421,6 +423,20 @@ static __init int snc_get_config(void)
 	return ret;
 }
 
+static void __init intel_rdt_mbm_apply_quirk(u32 num_rmid)
+{
+	int cf_index;
+
+	cf_index = num_rmid / 8 - 1;
+	if (cf_index >= ARRAY_SIZE(mbm_cf_table)) {
+		pr_info("No MBM correction factor available\n");
+		return;
+	}
+
+	mbm_cf_rmidthreshold = mbm_cf_table[cf_index].rmidthreshold;
+	mbm_cf = mbm_cf_table[cf_index].cf;
+}
+
 int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
@@ -500,25 +516,14 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 		hw_res->mbm_cntr_assign_enabled = true;
 	}
 
+	if (intel_rdt_mbm_need_quirk)
+		intel_rdt_mbm_apply_quirk(r->mon.num_rmid);
+
 	r->mon_capable = true;
 
 	return 0;
 }
 
-void __init intel_rdt_mbm_apply_quirk(void)
-{
-	int cf_index;
-
-	cf_index = (boot_cpu_data.x86_cache_max_rmid + 1) / 8 - 1;
-	if (cf_index >= ARRAY_SIZE(mbm_cf_table)) {
-		pr_info("No MBM correction factor available\n");
-		return;
-	}
-
-	mbm_cf_rmidthreshold = mbm_cf_table[cf_index].rmidthreshold;
-	mbm_cf = mbm_cf_table[cf_index].cf;
-}
-
 static void resctrl_abmc_set_one_amd(void *arg)
 {
 	bool *enable = arg;
-- 
2.55.0

