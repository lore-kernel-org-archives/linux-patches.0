Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870314E3762
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600419; cv=none; b=DbsBBiDW1xOK98oKNRyXM8Jc9gBzBJDQK2BHWz4XtMUrJs/QvPOpTj89a+7wFpe4SXE+MEhirW5I8Vqh22z5Zgo3xM46HebjxE5InIm7kbw9J8VngcM0qMCs6EYx/m5QiISl7BO4SGUmBa3J8MQ3oaITJScHVoepQFxSVitKrrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600419; c=relaxed/simple;
	bh=4B8Mhqv72RZOMhlRglNO3ieNTu5l4iDurKmAOs7y3bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7mG3NPiqFUkhkHn8B7Ntrb0HddiCRskplKJz3yIRTw3PqiobrOrgu0t2sepS67ehzjNHryrlNevNXOHaYBBtf72SKKvgZvd/g7yRY7s2k3GSA3ks4PxMiND/2R5eoGzgdpSumbwWwcHpg5HZp3+9ZMSAwYyVzYJID7UKVRh0zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DPoLW5dc; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DPoLW5dc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600415; x=1821136415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4B8Mhqv72RZOMhlRglNO3ieNTu5l4iDurKmAOs7y3bY=;
  b=DPoLW5dcop6XZApYMbzYoIOiqyi6UI3lOv2VsNpQxuGdwMm/YUzJpNZq
   ZX9vR6LUnOl7SC+iZCxPII3HjdOO7ix2nDDF6jldohFt78tJ1b2mgCBZq
   gpkvYiAzI9Y3ChpWVZaOouAceH8kcy9QLJX9id+HdrsQIYN0FMa6sMgHa
   WeQ8N8L8xQXnUuByLj7HRtdXGqrn21uGjDoc67MLkpVFgKSi+ZHMpj8Vj
   kRLogEkwuLibP1E3bTDYItqYg1rzDIU2igTd6OukbWY7cb148Fz1Na9W6
   A7TCr/uRzX5FbVZjZVpobG82U0Z9Y85NNpA1Ro/OWeJAcrHJ/KbV6J7c7
   Q==;
X-CSE-ConnectionGUID: WHsGevYpQ3KCwuLOxy9gag==
X-CSE-MsgGUID: JcDbya1RRWadUMLGSc7c8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861354"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861354"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:32 -0700
X-CSE-ConnectionGUID: CexuQpH5QwG+Cxsxmtjewg==
X-CSE-MsgGUID: 5DCXY7VPQOy2hryg1id0vA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231440"
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
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH v12 05/25] x86/resctrl: Delete resctrl_cpu_detect()
Date: Wed, 16 Sep 2026 16:13:00 -0700
Message-ID: <20260916231320.14502-6-tony.luck@intel.com>
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

cpuinfo_x86::x86_cache_{max_rmid,occ_scale,mbm_width_offset} are no
longer used.

Delete resctrl_cpu_detect() and the fields from struct cpuinfo_x86.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
---
v12:
	No change
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
index 82b27a0157ae..f0cfb37482d3 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1083,48 +1083,6 @@ static __init void rdt_init_res_defs(void)
 
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

