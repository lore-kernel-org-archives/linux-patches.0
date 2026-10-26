Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051852;
	b=g83KdYVJm1fC4tREJds95KbNp+mrRSmuSkADxuQ0957DpkPMApdNS32+cDJz1Ybfep4V
	 eS8zjrEGH/TE9WGHNdSiJLUG3+QB2XmVryjyI3S7ZTrIfEy0gnvuL+H7wqWZgB62vYok8
	 sfsXCJIB+wcLsIeqLT4hVdd0Pm22tAczw2e1Ixz1t8VtGq5fYAaOd3y7kJ8vPLigUKjNv
	 Xuz4VmAsx9Am2KyXwHwyalAunrb7yO7GNSw0V2fjmy/s4sRc/TsCN54DeQ3EGKNcJ68JZ
	 ycE72MCDq6IxsbEuX1BHXyLarthzBUWSJ+ICef6c1ke3W16qyFdc2CSd8wR2bYdAgBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051852;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nLbiu4vpexc8Wx0YWylLG3s0v3cIUHKHYDMXRcAL94g=;
	b=oTUc6HOLH+nGeu4HXved5GdHAU2IP88D3HZdprGHXBWxqNsk+rQcBJXzhggyQQvkOETU
	 MfEurx83khiVUidYt2RipAmeciV2n4zKHzMTX1alanIzqgnhaihG183lpRanQGt8EfARq
	 gkyqCPH1vfMJdJ8CGpOauIBg7PzWayzRS2v815sN8TqA4ZolDvu9V4vaRSRgXxtwkPFwV
	 rR4BfQskPswwFkRti9JvZR4rGwtan1D83fQBz/odMnC5Gh+jrbbZjIYXuygnCnlrU+EeN
	 c+TN0q6jw3iS/yjWNwkhgriuu20h5Yi8ii/FCqIX1KbW4w9C0cDJAm9O8xC9yr/7URw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bltFPkO5;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1728606A322
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 21:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1728606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bltFPkO5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793051850; x=1824587850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bzhv7s/5nJvPxQ44OMZU6Iz/kte/89+Yw2a+vbOExNA=;
  b=bltFPkO5fl9nJFTb/FSE2I+Nd5T5KG/5XNcUpqVdyQf/GJRKxaBhDOND
   LhWh92l3EPD6CE2gCqfZtzg7PD/bb26jXcOHo98uWzEGuTK7aju0eD5TN
   orf4Q8VBA1UA0Jzx4oqJz1ktc6YfAP4Db6vVG2PMTsjBTZKy7BQIcVMEL
   vUXXYiOEtCog8PJ5a3F37VLnKcfe0TEkZOoi4SBE1CZtsNKVa/9qSoj00
   HdUD2vRnrjKxzWK0iZ7sIc47KviMH+4IH8LloNVpgfqg8MHTPARkg3kr6
   jLQixDTHHGlSaIcBWjqdXKLXY857Sv5ZT7Ib6x+I9Qf/pA8JxPW3kCXPm
   Q==;
X-CSE-ConnectionGUID: Ano2bZ8tQEWdMUj0I3mZjQ==
X-CSE-MsgGUID: hWKapQmYR/C4F9wiQCYvRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1766391"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1766391"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:28 -0700
X-CSE-ConnectionGUID: +J61q/xmSxyTQOJgpbAT1w==
X-CSE-MsgGUID: SB2LEAl0R6eXBdw3Kjwutw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4240264"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.204])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:27 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 3/8] x86/cpuid: Add and use defines for Intel RDT enumeration leaves
Date: Mon, 26 Oct 2026 14:57:13 -0700
Message-ID: <20261026215718.16810-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026215718.16810-1-tony.luck@intel.com>
References: <20261026215718.16810-1-tony.luck@intel.com>
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

Intel Resource Director Technology (RDT) parameters are enumerated
in four leaves for (monitoring, allocation) * (symmetric, asymmetric).

Add defines for all four leaves.

Update code that hard-codes numerical values for the symmetric leaves.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/cpuid/types.h | 4 ++++
 arch/x86/kernel/cpu/resctrl/core.c | 8 ++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpuid/types.h b/arch/x86/include/asm/cpuid/types.h
index 3d0e611c97ba..9594965a54e7 100644
--- a/arch/x86/include/asm/cpuid/types.h
+++ b/arch/x86/include/asm/cpuid/types.h
@@ -28,9 +28,13 @@ enum cpuid_regs_idx {
 #define CPUID_LEAF_MWAIT	0x05
 #define CPUID_LEAF_DCA		0x09
 #define CPUID_LEAF_XSTATE	0x0d
+#define CPUID_LEAF_RDT_M	0x0f
+#define CPUID_LEAF_RDT_A	0x10
 #define CPUID_LEAF_TSC		0x15
 #define CPUID_LEAF_FREQ		0x16
 #define CPUID_LEAF_TILE		0x1d
+#define CPUID_LEAF_RDT_M_ASYM	0x27
+#define CPUID_LEAF_RDT_A_ASYM	0x28
 
 #define CPUID_RANGE(idx)	((idx) & 0xffff0000)
 #define CPUID_RANGE_MAX(idx)	(CPUID_RANGE(idx) + 0xffff)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 709075ffc706..c66ff4cdd84b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -235,7 +235,7 @@ static __init bool __get_mem_config_intel(struct rdt_resource *r)
 	union cpuid_0x10_x_edx edx;
 	u32 ebx, ecx, max_delay;
 
-	cpuid_count(0x00000010, 3, &eax.full, &ebx, &ecx, &edx.full);
+	cpuid_count(CPUID_LEAF_RDT_A, 3, &eax.full, &ebx, &ecx, &edx.full);
 	hw_res->num_closid = edx.split.cos_max + 1;
 	max_delay = eax.split.max_delay + 1;
 
@@ -357,7 +357,7 @@ static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
 	union cpuid_0x10_x_edx edx;
 	u32 ebx, default_ctrl;
 
-	cpuid_count(0x00000010, idx, &eax.full, &ebx, &ecx.full, &edx.full);
+	cpuid_count(CPUID_LEAF_RDT_A, idx, &eax.full, &ebx, &ecx.full, &edx.full);
 	hw_res->num_closid = edx.split.cos_max + 1;
 	hw_ctrl = kzalloc_obj(*hw_ctrl);
 	if (!hw_ctrl)
@@ -1196,7 +1196,7 @@ void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 	}
 
 	/* will be overridden if occupancy monitoring exists */
-	c->x86_cache_max_rmid = cpuid_ebx(0xf);
+	c->x86_cache_max_rmid = cpuid_ebx(CPUID_LEAF_RDT_M);
 
 	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
 	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
@@ -1205,7 +1205,7 @@ void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 		u32 eax, ebx, ecx, edx;
 
 		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
-		cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
+		cpuid_count(CPUID_LEAF_RDT_M, 1, &eax, &ebx, &ecx, &edx);
 
 		c->x86_cache_max_rmid  = ecx;
 		c->x86_cache_occ_scale = ebx;
-- 
2.56.0

