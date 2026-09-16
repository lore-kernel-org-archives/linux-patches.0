Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294DC4E06FF
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600415; cv=none; b=H3TExgwPBOZO08a44C4Re3W2dFwGlVVL8mvzMHnLe6Y91pOPKzroiwYWHYIiOdQYiDlp4UYCsTTTImUoIZXPh5RQcRwrU6r4HMJkERl7oHFVNTqpd93xBbALmE9TrARZw7Ei+SefShGsH29BEab/5Al60HCkUKQpXeH/frC4QTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600415; c=relaxed/simple;
	bh=b78w4Q5/oAk8AxLWTFSPezUXUZOigprtMDZLpaZuLKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piO2ZQxXvRfphdpoIbjOJQpmW5RX7KnzNvltfq6pK9VWJwOFvOfxdNkWy2ZiWs5BSEt3jTOvyXK7/4hPkaBnUk4yA2jd8REzn+CLHwE01RMurM9i2T78thbXRp3fTmTuTIDQ1QOeGiESCxLEZv2mCLTFbUf/+5geMqzt0ZG7DK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PgLxNs/T; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PgLxNs/T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600413; x=1821136413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b78w4Q5/oAk8AxLWTFSPezUXUZOigprtMDZLpaZuLKo=;
  b=PgLxNs/Tw+7Bw2LrSg/KfwTHa+RFLNW/fPQzwUG35aJeB50QKS8Zgeb8
   wXkJOyFej4XD3rVDG93DRqB4V8gjGqVVVVQWaHJ1Bn5UUguN6vNH3kUQJ
   hXizTJPn5QoFJ8OLXEEItnzs30QbxxkvGHLQdUPgTYE7tf2qkk3vYUhBd
   e2k2l4vaSGINPGf8Hem3CX2xqXgLjI2YNLdT7dhuWLKc7+QENUG3lFCW9
   xlTIgcj3Vh/ajvkaV4i/+O0o5PqgUwd2gNOyLAlSh0d3fNLpvjrE5FjDK
   cD7gF8dUNciGfMB8zv6wZbsGxEha6s9JTlqxDYwVIRNKZNyL1UPL6HzWj
   g==;
X-CSE-ConnectionGUID: 2UTIgV3VRcyDydOqDZbjNQ==
X-CSE-MsgGUID: 94EfjrqzQmy+WVOsdus0xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861345"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861345"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:32 -0700
X-CSE-ConnectionGUID: ouEkTmpaRaWMS2x+lbtJag==
X-CSE-MsgGUID: Y43W89fRTeeC8jFitK4zyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231433"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:32 -0700
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
Subject: [PATCH v12 04/25] x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
Date: Wed, 16 Sep 2026 16:12:59 -0700
Message-ID: <20260916231320.14502-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Intel quirk to adjust Memory Bandwidth Monitoring (MBM) values on
certain CPUs is applied early, before discovering if MBM is supported.

Move the call into rdt_get_l3_mon_config(), but keep the decision on
whether it is needed in __check_quirks_intel() with all the other
model specific tests.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Change type of cf_index to unsigned in intel_rdt_mbm_apply_quirk()
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
index 34ca3c7cc046..82b27a0157ae 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1011,7 +1011,7 @@ static __init void __check_quirks_intel(void)
 			set_rdt_options("!l3cat");
 		fallthrough;
 	case INTEL_BROADWELL_X:
-		intel_rdt_mbm_apply_quirk();
+		intel_rdt_mbm_need_quirk = true;
 		break;
 	}
 }
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 89b83cc7e800..ab9cb34145c5 100644
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
+	unsigned int cf_index;
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

