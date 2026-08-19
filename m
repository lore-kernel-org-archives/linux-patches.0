Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB756488D92
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787156020; cv=none; b=Ql03QDRpDJlYFr00xTCSOd0KkVvTNX91Z61+vUT+9G7gkFOEp9Oza9hNm6fK63rJcOLXGX3ZbEwPXFqYEks06+YjnZNIV+R9Jx5GLhI2/nv54nBUR+rD3UOdAtrtYNKknmNtoLU+tWtb+BMdsCVx4jdzWaBDR86YuiZ8bvMvgRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787156020; c=relaxed/simple;
	bh=jIEscGel+bFptW/MzzQctO/3HTgWIzQRSvRdBQsABbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRQSxHONKcwEfsY1UK0ikSTsGlHmG6HK79YDD32vgazsOq9gAzOlMQQsHeTpAMtdFQykfbHzhnOMMhDHTi5ilPfJjCv6lc3mumts0LcmU3VTll4lJMnxu5MdRWZ/A/YDfEJtBDGfs6krYxku5qUsKdqPPuXvAP0FEXf1hYa5Qpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f4WfWjTe; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f4WfWjTe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787156017; x=1818692017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jIEscGel+bFptW/MzzQctO/3HTgWIzQRSvRdBQsABbQ=;
  b=f4WfWjTeFLQq7xuyIyhR/kqJmtIZPJ5Prkx6I5neccxoikRC//KUQvnC
   W6sNWXbdtFdqP5Jsf2zwIqQkXV6tBWuoMrPtN/2jMM0i0NxP+2FLRtJJZ
   Cnjuh1O7syW+GDbV6stL2UnDJZ32MpZysP0rCnBjjiMgct4uWgdzB9q+5
   fi2qHRa6/ea1vx7fqo+Nr2RsVnk1vws/ff6UVprg9YqUjR71KyyLebWJC
   zAHcN/EvbTmYtqHlTqcFa1EPVktSV/73VbAdr/fuGVEkNp6Yn9mkXoNOB
   heBDuAOu58ATK64QLqaXaEWfhhJ1EyRdtKhEVU6JNdDKO4zkGsxdc9LS0
   g==;
X-CSE-ConnectionGUID: Rskul4NnTRaaj0pkZq0ReA==
X-CSE-MsgGUID: aGCOD5b8RKeY48tSaIvu5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="87598068"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="87598068"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
X-CSE-ConnectionGUID: sZDbsV55QJ6/9y2B4C47+g==
X-CSE-MsgGUID: Y61bPEmASp6JVu72sFVHnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="290391852"
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
Subject: [RFC PATCH 4/4] x86/resctrl: Delete resctrl_cpu_detect()
Date: Wed, 19 Aug 2026 09:13:22 -0700
Message-ID: <20260819161323.11587-5-tony.luck@intel.com>
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

cpuinfo_x86::x86_cache_{max_rmid,occ_scale,mbm_width_offset} are no
longer used.

Delete resctrl_cpu_detect() and the fields from struct cpuinfo_x86.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/processor.h   |  4 ---
 arch/x86/include/asm/resctrl.h     |  3 ---
 arch/x86/kernel/cpu/amd.c          |  3 ---
 arch/x86/kernel/cpu/hygon.c        |  3 ---
 arch/x86/kernel/cpu/intel.c        |  7 -----
 arch/x86/kernel/cpu/resctrl/core.c | 42 ------------------------------
 6 files changed, 62 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ec9db0dfa0df..4deb88c61c94 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -185,10 +185,6 @@ struct cpuinfo_x86 {
 	/* in KB - valid for CPUS which support this call: */
 	unsigned int		x86_cache_size;
 	int			x86_cache_alignment;	/* In bytes */
-	/* Cache QoS architectural values, valid only on the BSP: */
-	int			x86_cache_max_rmid;	/* max index */
-	int			x86_cache_occ_scale;	/* scale to bytes */
-	int			x86_cache_mbm_width_offset;
 	int			x86_power;
 	unsigned long		loops_per_jiffy;
 	/* protected processor identification number */
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 9bfa9b14002b..ab7f6ccd149e 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -193,12 +193,9 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
 					     enum resctrl_event_id evtid,
 					     void *ctx) { }
 
-void resctrl_cpu_detect(struct cpuinfo_x86 *c);
-
 #else
 
 static inline void resctrl_arch_sched_in(struct task_struct *tsk) {}
-static inline void resctrl_cpu_detect(struct cpuinfo_x86 *c) {}
 
 #endif /* CONFIG_X86_CPU_RESCTRL */
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 54e14ed276b5..dd82a11084f4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -23,7 +23,6 @@
 #include <asm/pci-direct.h>
 #include <asm/delay.h>
 #include <asm/debugreg.h>
-#include <asm/resctrl.h>
 #include <asm/msr.h>
 #include <asm/sev.h>
 
@@ -475,8 +474,6 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
-	resctrl_cpu_detect(c);
-
 	/* Figure out Zen generations: */
 	switch (c->x86) {
 	case 0x17:
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index ec51c2b9a257..0f226335dd9a 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -17,7 +17,6 @@
 #include <asm/spec-ctrl.h>
 #include <asm/delay.h>
 #include <asm/msr.h>
-#include <asm/resctrl.h>
 
 #include "cpu.h"
 
@@ -119,8 +118,6 @@ static void bsp_init_hygon(struct cpuinfo_x86 *c)
 			x86_amd_ls_cfg_ssbd_mask = 1ULL << 10;
 		}
 	}
-
-	resctrl_cpu_detect(c);
 }
 
 static void early_init_hygon(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 4297ceb2cb24..2f09710e863c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -22,7 +22,6 @@
 #include <asm/microcode.h>
 #include <asm/msr.h>
 #include <asm/numa.h>
-#include <asm/resctrl.h>
 #include <asm/thermal.h>
 #include <asm/uaccess.h>
 
@@ -371,11 +370,6 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 		detect_tme_early(c);
 }
 
-static void bsp_init_intel(struct cpuinfo_x86 *c)
-{
-	resctrl_cpu_detect(c);
-}
-
 #ifdef CONFIG_X86_32
 /*
  *	Early probe support logic for ppro memory erratum #50
@@ -804,7 +798,6 @@ static const struct cpu_dev intel_cpu_dev = {
 #endif
 	.c_detect_tlb	= intel_detect_tlb,
 	.c_early_init   = early_init_intel,
-	.c_bsp_init	= bsp_init_intel,
 	.c_init		= init_intel,
 	.c_x86_vendor	= X86_VENDOR_INTEL,
 };
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index da94a12f9256..1e36630c5da7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1078,48 +1078,6 @@ static __init void rdt_init_res_defs(void)
 
 static enum cpuhp_state rdt_online;
 
-/* Runs once on the BSP during boot. */
-void resctrl_cpu_detect(struct cpuinfo_x86 *c)
-{
-	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
-		c->x86_cache_max_rmid  = -1;
-		c->x86_cache_occ_scale = -1;
-		c->x86_cache_mbm_width_offset = -1;
-		return;
-	}
-
-	/* will be overridden if occupancy monitoring exists */
-	c->x86_cache_max_rmid = cpuid_ebx(0xf);
-
-	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
-	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
-	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL) ||
-	    cpu_has(c, X86_FEATURE_ABMC)) {
-		u32 eax, ebx, ecx, edx;
-
-		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
-		cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
-
-		c->x86_cache_max_rmid  = ecx;
-		c->x86_cache_occ_scale = ebx;
-		c->x86_cache_mbm_width_offset = eax & 0xff;
-
-		if (!c->x86_cache_mbm_width_offset) {
-			switch (c->x86_vendor) {
-			case X86_VENDOR_AMD:
-				c->x86_cache_mbm_width_offset = MBM_CNTR_WIDTH_OFFSET_AMD;
-				break;
-			case X86_VENDOR_HYGON:
-				c->x86_cache_mbm_width_offset = MBM_CNTR_WIDTH_OFFSET_HYGON;
-				break;
-			default:
-				/* Leave c->x86_cache_mbm_width_offset as 0 */
-				break;
-			}
-		}
-	}
-}
-
 static int __init resctrl_arch_late_init(void)
 {
 	struct rdt_resource *r;
-- 
2.55.0

