Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF70B1C0DD1
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495911; cv=none; b=Z5OjgJ7oQ8NrlejM4WZOw6//raQeGIwYw6W0jx1yNvNOjNBYKKyqnnafoe6G/wAMBXRQ0FRJK4L6kqnw1ciXAjzaD+F0zrL8sk91XiaJzzOpadSHtGTPT4ni1n7fCZCsp4PXQyuT73DiPyHByewEPlGXvJS5nQSh451fhSIxy0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495911; c=relaxed/simple;
	bh=UCKckKaf+DcEOivednlx2AHS0yzAWKTc2jZ4Dmi/hSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYEDLuZmDQgOQV60wFlvFWtBLOGuw6ZlSWW8K6pttnEfUJ6CP+2QvGxS4buWlWv30FsZ9UdrL67eLMeKSzctKuTIoP7NCcWCKX+3stsGyQR2ELDb1iaWDyqV1S5lVt6j1VraZvh/u1Hh616NkPCaVHI+X9BeOr4ewvovhSb1AHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UB28rapN; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UB28rapN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495909; x=1746031909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UCKckKaf+DcEOivednlx2AHS0yzAWKTc2jZ4Dmi/hSY=;
  b=UB28rapNHRtZmRmkc6eG1siU6FnUKWBh8UJ5XoezZbh5YEwlV9JLyVdV
   oVK2dBQFwyoxnPDVdLm4SYK73BdsSbl1o1s2x2G4+zrU0vMzC9go83whT
   P1LtrsLUGEyGJm02R8w2stNfhafdTZfD9oiprU5Sg19zctFXelFEJvXmC
   18LJsIAPHwPEHQuUZe8LjyogAl0AdTsW5EjcmfqCZWx8pQetQCkngJpUX
   C8h6i2xZNYQJqJFEEwPQakZb3YkAdhTFHQPb15CYhoTDtS88310XBnHZU
   9HYKpQhNSrqvY2en9qyi2wTk4G1IuKxAwfrKv4rjRWTKkaNWAMyATSP7v
   A==;
X-CSE-ConnectionGUID: hPDTYhPnShe+H4TztiHykQ==
X-CSE-MsgGUID: OIWdgd3ySouFzBu7dmUHzQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075742"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075742"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: OQ41DDF5QEOY8syVOzhN1w==
X-CSE-MsgGUID: Zrnc/pNZSKqqGlIFzE3Mew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515493"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 29/47] perf/x86/intel: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:42 -0700
Message-ID: <20240430165100.73491-29-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/events/intel/core.c | 148 +++++++++++++++++------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 768d1414897f..94206f8cd371 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4698,8 +4698,8 @@ static void intel_pmu_check_extra_regs(struct extra_reg *extra_regs);
 static inline bool intel_pmu_broken_perf_cap(void)
 {
 	/* The Perf Metric (Bit 15) is always cleared */
-	if ((boot_cpu_data.x86_model == INTEL_FAM6_METEORLAKE) ||
-	    (boot_cpu_data.x86_model == INTEL_FAM6_METEORLAKE_L))
+	if (boot_cpu_data.x86_vfm == INTEL_METEORLAKE ||
+	    boot_cpu_data.x86_vfm == INTEL_METEORLAKE_L)
 		return true;
 
 	return false;
@@ -6245,19 +6245,19 @@ __init int intel_pmu_init(void)
 	/*
 	 * Install the hw-cache-events table:
 	 */
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_CORE_YONAH:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_CORE_YONAH:
 		pr_cont("Core events, ");
 		name = "core";
 		break;
 
-	case INTEL_FAM6_CORE2_MEROM:
+	case INTEL_CORE2_MEROM:
 		x86_add_quirk(intel_clovertown_quirk);
 		fallthrough;
 
-	case INTEL_FAM6_CORE2_MEROM_L:
-	case INTEL_FAM6_CORE2_PENRYN:
-	case INTEL_FAM6_CORE2_DUNNINGTON:
+	case INTEL_CORE2_MEROM_L:
+	case INTEL_CORE2_PENRYN:
+	case INTEL_CORE2_DUNNINGTON:
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -6269,9 +6269,9 @@ __init int intel_pmu_init(void)
 		name = "core2";
 		break;
 
-	case INTEL_FAM6_NEHALEM:
-	case INTEL_FAM6_NEHALEM_EP:
-	case INTEL_FAM6_NEHALEM_EX:
+	case INTEL_NEHALEM:
+	case INTEL_NEHALEM_EP:
+	case INTEL_NEHALEM_EX:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
@@ -6303,11 +6303,11 @@ __init int intel_pmu_init(void)
 		name = "nehalem";
 		break;
 
-	case INTEL_FAM6_ATOM_BONNELL:
-	case INTEL_FAM6_ATOM_BONNELL_MID:
-	case INTEL_FAM6_ATOM_SALTWELL:
-	case INTEL_FAM6_ATOM_SALTWELL_MID:
-	case INTEL_FAM6_ATOM_SALTWELL_TABLET:
+	case INTEL_ATOM_BONNELL:
+	case INTEL_ATOM_BONNELL_MID:
+	case INTEL_ATOM_SALTWELL:
+	case INTEL_ATOM_SALTWELL_MID:
+	case INTEL_ATOM_SALTWELL_TABLET:
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -6320,11 +6320,11 @@ __init int intel_pmu_init(void)
 		name = "bonnell";
 		break;
 
-	case INTEL_FAM6_ATOM_SILVERMONT:
-	case INTEL_FAM6_ATOM_SILVERMONT_D:
-	case INTEL_FAM6_ATOM_SILVERMONT_MID:
-	case INTEL_FAM6_ATOM_AIRMONT:
-	case INTEL_FAM6_ATOM_AIRMONT_MID:
+	case INTEL_ATOM_SILVERMONT:
+	case INTEL_ATOM_SILVERMONT_D:
+	case INTEL_ATOM_SILVERMONT_MID:
+	case INTEL_ATOM_AIRMONT:
+	case INTEL_ATOM_AIRMONT_MID:
 		memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
 			sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, slm_hw_cache_extra_regs,
@@ -6342,8 +6342,8 @@ __init int intel_pmu_init(void)
 		name = "silvermont";
 		break;
 
-	case INTEL_FAM6_ATOM_GOLDMONT:
-	case INTEL_FAM6_ATOM_GOLDMONT_D:
+	case INTEL_ATOM_GOLDMONT:
+	case INTEL_ATOM_GOLDMONT_D:
 		memcpy(hw_cache_event_ids, glm_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, glm_hw_cache_extra_regs,
@@ -6369,7 +6369,7 @@ __init int intel_pmu_init(void)
 		name = "goldmont";
 		break;
 
-	case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
+	case INTEL_ATOM_GOLDMONT_PLUS:
 		memcpy(hw_cache_event_ids, glp_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, glp_hw_cache_extra_regs,
@@ -6398,9 +6398,9 @@ __init int intel_pmu_init(void)
 		name = "goldmont_plus";
 		break;
 
-	case INTEL_FAM6_ATOM_TREMONT_D:
-	case INTEL_FAM6_ATOM_TREMONT:
-	case INTEL_FAM6_ATOM_TREMONT_L:
+	case INTEL_ATOM_TREMONT_D:
+	case INTEL_ATOM_TREMONT:
+	case INTEL_ATOM_TREMONT_L:
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, glp_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
@@ -6427,7 +6427,7 @@ __init int intel_pmu_init(void)
 		name = "Tremont";
 		break;
 
-	case INTEL_FAM6_ATOM_GRACEMONT:
+	case INTEL_ATOM_GRACEMONT:
 		intel_pmu_init_grt(NULL);
 		intel_pmu_pebs_data_source_grt();
 		x86_pmu.pebs_latency_data = adl_latency_data_small;
@@ -6439,8 +6439,8 @@ __init int intel_pmu_init(void)
 		name = "gracemont";
 		break;
 
-	case INTEL_FAM6_ATOM_CRESTMONT:
-	case INTEL_FAM6_ATOM_CRESTMONT_X:
+	case INTEL_ATOM_CRESTMONT:
+	case INTEL_ATOM_CRESTMONT_X:
 		intel_pmu_init_grt(NULL);
 		x86_pmu.extra_regs = intel_cmt_extra_regs;
 		intel_pmu_pebs_data_source_cmt();
@@ -6453,9 +6453,9 @@ __init int intel_pmu_init(void)
 		name = "crestmont";
 		break;
 
-	case INTEL_FAM6_WESTMERE:
-	case INTEL_FAM6_WESTMERE_EP:
-	case INTEL_FAM6_WESTMERE_EX:
+	case INTEL_WESTMERE:
+	case INTEL_WESTMERE_EP:
+	case INTEL_WESTMERE_EX:
 		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
@@ -6484,8 +6484,8 @@ __init int intel_pmu_init(void)
 		name = "westmere";
 		break;
 
-	case INTEL_FAM6_SANDYBRIDGE:
-	case INTEL_FAM6_SANDYBRIDGE_X:
+	case INTEL_SANDYBRIDGE:
+	case INTEL_SANDYBRIDGE_X:
 		x86_add_quirk(intel_sandybridge_quirk);
 		x86_add_quirk(intel_ht_bug);
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
@@ -6498,7 +6498,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		if (boot_cpu_data.x86_model == INTEL_FAM6_SANDYBRIDGE_X)
+		if (boot_cpu_data.x86_vfm == INTEL_SANDYBRIDGE_X)
 			x86_pmu.extra_regs = intel_snbep_extra_regs;
 		else
 			x86_pmu.extra_regs = intel_snb_extra_regs;
@@ -6524,8 +6524,8 @@ __init int intel_pmu_init(void)
 		name = "sandybridge";
 		break;
 
-	case INTEL_FAM6_IVYBRIDGE:
-	case INTEL_FAM6_IVYBRIDGE_X:
+	case INTEL_IVYBRIDGE:
+	case INTEL_IVYBRIDGE_X:
 		x86_add_quirk(intel_ht_bug);
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
@@ -6541,7 +6541,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_ivb;
 		x86_pmu.pebs_prec_dist = true;
-		if (boot_cpu_data.x86_model == INTEL_FAM6_IVYBRIDGE_X)
+		if (boot_cpu_data.x86_vfm == INTEL_IVYBRIDGE_X)
 			x86_pmu.extra_regs = intel_snbep_extra_regs;
 		else
 			x86_pmu.extra_regs = intel_snb_extra_regs;
@@ -6563,10 +6563,10 @@ __init int intel_pmu_init(void)
 		break;
 
 
-	case INTEL_FAM6_HASWELL:
-	case INTEL_FAM6_HASWELL_X:
-	case INTEL_FAM6_HASWELL_L:
-	case INTEL_FAM6_HASWELL_G:
+	case INTEL_HASWELL:
+	case INTEL_HASWELL_X:
+	case INTEL_HASWELL_L:
+	case INTEL_HASWELL_G:
 		x86_add_quirk(intel_ht_bug);
 		x86_add_quirk(intel_pebs_isolation_quirk);
 		x86_pmu.late_ack = true;
@@ -6596,10 +6596,10 @@ __init int intel_pmu_init(void)
 		name = "haswell";
 		break;
 
-	case INTEL_FAM6_BROADWELL:
-	case INTEL_FAM6_BROADWELL_D:
-	case INTEL_FAM6_BROADWELL_G:
-	case INTEL_FAM6_BROADWELL_X:
+	case INTEL_BROADWELL:
+	case INTEL_BROADWELL_D:
+	case INTEL_BROADWELL_G:
+	case INTEL_BROADWELL_X:
 		x86_add_quirk(intel_pebs_isolation_quirk);
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, hsw_hw_cache_event_ids, sizeof(hw_cache_event_ids));
@@ -6638,8 +6638,8 @@ __init int intel_pmu_init(void)
 		name = "broadwell";
 		break;
 
-	case INTEL_FAM6_XEON_PHI_KNL:
-	case INTEL_FAM6_XEON_PHI_KNM:
+	case INTEL_XEON_PHI_KNL:
+	case INTEL_XEON_PHI_KNM:
 		memcpy(hw_cache_event_ids,
 		       slm_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs,
@@ -6658,15 +6658,15 @@ __init int intel_pmu_init(void)
 		name = "knights-landing";
 		break;
 
-	case INTEL_FAM6_SKYLAKE_X:
+	case INTEL_SKYLAKE_X:
 		pmem = true;
 		fallthrough;
-	case INTEL_FAM6_SKYLAKE_L:
-	case INTEL_FAM6_SKYLAKE:
-	case INTEL_FAM6_KABYLAKE_L:
-	case INTEL_FAM6_KABYLAKE:
-	case INTEL_FAM6_COMETLAKE_L:
-	case INTEL_FAM6_COMETLAKE:
+	case INTEL_SKYLAKE_L:
+	case INTEL_SKYLAKE:
+	case INTEL_KABYLAKE_L:
+	case INTEL_KABYLAKE:
+	case INTEL_COMETLAKE_L:
+	case INTEL_COMETLAKE:
 		x86_add_quirk(intel_pebs_isolation_quirk);
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, skl_hw_cache_event_ids, sizeof(hw_cache_event_ids));
@@ -6715,16 +6715,16 @@ __init int intel_pmu_init(void)
 		name = "skylake";
 		break;
 
-	case INTEL_FAM6_ICELAKE_X:
-	case INTEL_FAM6_ICELAKE_D:
+	case INTEL_ICELAKE_X:
+	case INTEL_ICELAKE_D:
 		x86_pmu.pebs_ept = 1;
 		pmem = true;
 		fallthrough;
-	case INTEL_FAM6_ICELAKE_L:
-	case INTEL_FAM6_ICELAKE:
-	case INTEL_FAM6_TIGERLAKE_L:
-	case INTEL_FAM6_TIGERLAKE:
-	case INTEL_FAM6_ROCKETLAKE:
+	case INTEL_ICELAKE_L:
+	case INTEL_ICELAKE:
+	case INTEL_TIGERLAKE_L:
+	case INTEL_TIGERLAKE:
+	case INTEL_ROCKETLAKE:
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, skl_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, skl_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
@@ -6759,13 +6759,13 @@ __init int intel_pmu_init(void)
 		name = "icelake";
 		break;
 
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:
-	case INTEL_FAM6_EMERALDRAPIDS_X:
+	case INTEL_SAPPHIRERAPIDS_X:
+	case INTEL_EMERALDRAPIDS_X:
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 		x86_pmu.extra_regs = intel_glc_extra_regs;
 		fallthrough;
-	case INTEL_FAM6_GRANITERAPIDS_X:
-	case INTEL_FAM6_GRANITERAPIDS_D:
+	case INTEL_GRANITERAPIDS_X:
+	case INTEL_GRANITERAPIDS_D:
 		intel_pmu_init_glc(NULL);
 		if (!x86_pmu.extra_regs)
 			x86_pmu.extra_regs = intel_rwc_extra_regs;
@@ -6783,11 +6783,11 @@ __init int intel_pmu_init(void)
 		name = "sapphire_rapids";
 		break;
 
-	case INTEL_FAM6_ALDERLAKE:
-	case INTEL_FAM6_ALDERLAKE_L:
-	case INTEL_FAM6_RAPTORLAKE:
-	case INTEL_FAM6_RAPTORLAKE_P:
-	case INTEL_FAM6_RAPTORLAKE_S:
+	case INTEL_ALDERLAKE:
+	case INTEL_ALDERLAKE_L:
+	case INTEL_RAPTORLAKE:
+	case INTEL_RAPTORLAKE_P:
+	case INTEL_RAPTORLAKE_S:
 		/*
 		 * Alder Lake has 2 types of CPU, core and atom.
 		 *
@@ -6845,8 +6845,8 @@ __init int intel_pmu_init(void)
 		name = "alderlake_hybrid";
 		break;
 
-	case INTEL_FAM6_METEORLAKE:
-	case INTEL_FAM6_METEORLAKE_L:
+	case INTEL_METEORLAKE:
+	case INTEL_METEORLAKE_L:
 		intel_pmu_init_hybrid(hybrid_big_small);
 
 		x86_pmu.pebs_latency_data = mtl_latency_data_small;
-- 
2.44.0

