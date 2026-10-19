Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443058;
	b=vs4nYoZ75nTYIOACq2YUlwPHsuluHp08Bv0Hyx2B2VBVNK6u8Iid21kmB/T0QkRf0udB
	 vBd4y7rNYosCiDD0qWdGXtBb4ezRCKm8g8TkCAe0JHcLDitjKcG/Q4agBN1LBCyxLkdc1
	 ZWpyHT3j1rQTmuZxNIDzjgdNTiiKG/b8bjXqPUSblMJvy7gEBF1fEDWR9FJs2YU0bDaBO
	 UkrKYl+y2WNNV5/tFRoN6E6IoMQ9kzJPQfgp3Txs0GmVwWS3YoDkR6cDqph1gDEbZsbnn
	 JFWJPv4MJszE4ZiXNceuMPBX4GV3tv1q6twFnAwbBlYM4jxMPgXFPhBGi/g7bRdroFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443058;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hxdTMbA8LElIuPJVsQvOST89gibjO3Mqlv7/+bxExC4=;
	b=bX+K5lbsPofbs6KratzfZp7+h2aKOJYz02DHjJZNjZ3Rq76WWzCdywqv1oGbVKMABUF0
	 fjbQKIKV68TRdrTTcy+eSwghlCJVpn/j5xhrVmBRr2w5koxjUC4N6wwQpqZOwqJZiVhJq
	 Im6Jn2aME4Ddm6lf/NQHBqqT+fEsD04GgUrVDXxgjmrrG+rLCdXhvFcP4D9DDIyDTN6mZ
	 RBmRuBfjQtpdR7l/q9tmly6X3WvVDayBqzn/b5ZZ9701eTfpm/nONSLG73uzwsSt7X5VS
	 O7x89kbNE3JzP2Km4krdhK3beFm4+GsS6VOxrsf0CjU9BVRMfNR45ZP/FPzvH2B1G9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cbubWggy;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD22606A326
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FD22606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cbubWggy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443052; x=1823979052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CG7Lll4s+ThtivUH6SVnYWTUIN/0rn8cWo9ieKUsPK4=;
  b=cbubWggyJoXccd8cj8ee9e5jgdNj2jrrmpdKjlz4wKcS2u+lzHVKVaD5
   QMUeJ06owGVPNIppB7b7IkeIWgbQNxTlmWMhPzca2gjDQjgPNLBM11mpx
   hNGNuICN2ndJOmtkEhp/IipvxoRtkeld2SP37/EQO5Ko04w5NIvVXIx5a
   M3HkBF2QEhNcgwAJ1A5G8iMxZCwFwkEE3i4DEUllXFFmOpq6HZVOLMxLz
   T1t9Pq53o1dvFz/glXfKs9HP8XiEGu7a0DtCVIb3EOwnEiahJS1zGJB+Z
   VtTJ7IYxghUJgzAi/lu5ZcFTCmca4GdsKGO7wotlteffnKrqkm5XLsGOd
   w==;
X-CSE-ConnectionGUID: rSsfyL2vT+653DaYVdfW8Q==
X-CSE-MsgGUID: aBKGyDNnQ5uwzZSaGAHY7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131127"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131127"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:48 -0700
X-CSE-ConnectionGUID: 2MsWXzZ1RtG/QDjxgdfpFQ==
X-CSE-MsgGUID: nw1Lt+vyT/SssC6+yl2TZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008624"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:49 -0700
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
Subject: [PATCH v14 03/24] x86/resctrl: Centralize monitoring feature enumeration
Date: Mon, 19 Oct 2026 13:50:10 -0700
Message-ID: <20261019205031.16977-4-tony.luck@intel.com>
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

The original "perf" implementation of Intel Cache QoS Monitoring (CQM)
put parameters from CPUID into fields of the cpuinfo_x86 structure. The
perf implementation was reverted and replaced by resctrl. The enumerated
parameters remained in the boot_cpu_data structure.

resctrl is the only consumer of these values, yet it depends on generic
x86 CPU setup to enumerate them.

Centralize all L3 monitoring enumeration within resctrl in preparation for
removal of resctrl fields from struct cpuinfo_x86. The Intel MBM correction
factor quirk remains the only reader of the cached values.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	Structure commit in context, problem, solution.
	Add note that there is still one user of boot_cpu_data.
---
 arch/x86/include/asm/resctrl.h        |  9 ++++----
 arch/x86/kernel/cpu/resctrl/monitor.c | 32 ++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 8f6edcdcfd87..c9f9db96f792 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -44,6 +44,7 @@ DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
 extern bool rdt_mon_capable;
+extern unsigned int rdt_l3_mon_scale;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
@@ -132,11 +133,9 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
 
 static inline unsigned int resctrl_arch_round_mon_val(unsigned int val)
 {
-	unsigned int scale = boot_cpu_data.x86_cache_occ_scale;
-
-	/* h/w works in units of "boot_cpu_data.x86_cache_occ_scale" */
-	val /= scale;
-	return val * scale;
+	/* Round down to nearest h/w monitoring unit */
+	val /= rdt_l3_mon_scale;
+	return val * rdt_l3_mon_scale;
 }
 
 static inline void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid,
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 3838e0a13d36..89b83cc7e800 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -32,6 +32,11 @@
  */
 bool rdt_mon_capable;
 
+/*
+ * Scale factor to convert L3 monitor events to bytes.
+ */
+unsigned int __ro_after_init rdt_l3_mon_scale;
+
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
 static int snc_nodes_per_l3_cache = 1;
@@ -418,16 +423,37 @@ static __init int snc_get_config(void)
 
 int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
-	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
+	unsigned int mbm_offset;
 	unsigned int threshold;
 	u32 eax, ebx, ecx, edx;
+	u32 num_rmid;
+
+	/* Resource monitoring leaf is 0xf. L3 monitoring details in subleaf 1 */
+	cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
+	mbm_offset = eax & GENMASK(7, 0);
+	rdt_l3_mon_scale = ebx;
+	num_rmid = ecx + 1;
+
+	if (!mbm_offset) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_AMD:
+			mbm_offset = MBM_CNTR_WIDTH_OFFSET_AMD;
+			break;
+		case X86_VENDOR_HYGON:
+			mbm_offset = MBM_CNTR_WIDTH_OFFSET_HYGON;
+			break;
+		default:
+			/* Leave mbm_offset as 0 */
+			break;
+		}
+	}
 
 	snc_nodes_per_l3_cache = snc_get_config();
 
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
-	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
-	r->mon.num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
+	hw_res->mon_scale = rdt_l3_mon_scale / snc_nodes_per_l3_cache;
+	r->mon.num_rmid = num_rmid / snc_nodes_per_l3_cache;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
-- 
2.56.0

