Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DF2502D45
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633729; cv=none; b=Z7Iq7OXndHP2o4iiGNHT4wKkGUQEK0U0oSf8pl7sAI+CNXJ4OBBKV4W/dgkL+JFGz1mv3ogAYiKu63SvjONAKgbZ8PhrsgUDaRjwOnDjqXg7QyvtggeEasOXmPeg4VqDJg655xdJ6NkH8/UmYoR+zxdq+Mf/eyr2isOKN+zb2pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633729; c=relaxed/simple;
	bh=nhwEC2QH7/NHB66wQKhVR0mTkp6KvQcYd8p/53bETLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=re24uW7gYr864LdZx0ZVx0xBtlKbt1QktHzKmnUvZIRYkTSOMsP6J/R7+BZgwSwePGifX0U6EHxaCAyWFdPb4EF/OM9NAhRtxMsVjM/fN7YrUHm85IZ7J4AyfrOM31n8N1ZB05zFAA0wTSkOv7kJqpMOsVp8vqRDgbI6risjvLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n45QUnA0; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n45QUnA0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633723; x=1822169723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nhwEC2QH7/NHB66wQKhVR0mTkp6KvQcYd8p/53bETLs=;
  b=n45QUnA0daTh8JUEJB9W/9OOv7yUiDrGisi6X6lvfUDRVfcOsVHtFsy5
   EsYpTUCG3DFQqO9uqJ7Skoy6GbdonP3p3fOGf+dtiPNhZOqX0B0Gd9lsp
   jKTlBjIJzAgCwzPrOpx9N30nE73oVDK/pkSh6AIZM7nTC0yazn33EljqG
   yTsn1KpMpGmWsx2IkEsjack/jxUHqRVvzYGW5ajmDLG+e9HysOiwHdsQr
   ewglQoC0ddWOfjAfB+xwBald7AJ+K00ufMR/NZgg9pN5ZnZEDClSyH4mb
   3xIpW25qogIodIv7JWYiIo9pf8eskNt1udZqWOlCjneQ3HoStrjz4jQo3
   Q==;
X-CSE-ConnectionGUID: me/pcN7pSL2bwea6r9H0sQ==
X-CSE-MsgGUID: Yaso6ZnpSyaD+u7NAo+waw==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387181"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387181"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:18 -0700
X-CSE-ConnectionGUID: 027vTMxBRLql91KH7Q9Oog==
X-CSE-MsgGUID: yJfIPWnSQC6p4IclwG0sag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685472"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:17 -0700
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
Subject: [PATCH v13 04/25] x86/resctrl: Centralize monitoring feature enumeration
Date: Mon, 28 Sep 2026 15:14:48 -0700
Message-ID: <20260928221509.68002-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The original implementation of Intel Cache QoS Monitoring (CQM) planned
to integrate with the "perf" and "cgroup" subsystems. With that plan it
made sense for parameters from CPUID to be stored in fields of the
cpuinfo_x86 structure. But that plan was abandoned and the resctrl file
system user interface replaced it.

Centralize all L3 monitoring enumeration within resctrl in preparation for
removal of resctrl fields from struct cpuinfo_x86.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Update commit subject and comment as suggested.
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
2.55.0

