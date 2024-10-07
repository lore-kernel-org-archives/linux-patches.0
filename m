Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E9D1DC1B3
	for <patches@lists.linux.dev>; Mon,  7 Oct 2024 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728320229; cv=none; b=hy9lI0aqcFE0cHN6etVeFLvPdB1qeWgbOXYr4l50Hgb/zZXrrK5FYPlqSgHIAmTGzkV/k/jW6rLAnS65ucfuJNIbXSCjdTnIDPGw90vs/nzGSZVdz39xpHRtgev7hH/x4kBWU8we9olD34Yen8ofmIMeUyrl0Ix3iADHUIy336k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728320229; c=relaxed/simple;
	bh=lyzSMcWFnmspFtIMnp4dk0axPSL7aDSUZtWn+g8V1ls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZJUU8a8PVaYpha5At3k+EmGdUhnfTvK4EoU6nxyG+L233tzGiA34ULkQxpU1v2t1lM0bDARoZSErBOGLEv9UDHeAjb/6MNnkZu0bDVIikr0tmZEUG5YSBJZt1Ryre/Jdi/eWg4PFJFDIho/69qPR0xPY/axc9Nky5YnK686dYiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JmlRPiRT; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JmlRPiRT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728320228; x=1759856228;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lyzSMcWFnmspFtIMnp4dk0axPSL7aDSUZtWn+g8V1ls=;
  b=JmlRPiRT5QkY+g9rXcvwIdW5feTjWws1JZKyhn6Xr+h6fQ/MNZUA6aX4
   HQP1AVrk7Wykov18fhHB7U+nARIlojC2/UgmQFX+lYwtmwskAWiD3Ql4H
   2rjpAYqGDBXy7q8IMnDTT7mJ35i/EcdaG4krxP/BtkeuX5mxQWWw3fcne
   uSl6Wneb9hJuhszxsaGCv0LGP6MX15HFEaz/YYv1YewxqLTxcTLhNGIO5
   R8v9GvSg7bFGEVXaBKeOJlkXOMvqE2GNHYY1ZLDFQXflOyeZIUHsguvb1
   8vmBbiOIRJamB6MNjckWbdKtLi1gWqiB79lZefa8Xb+nnNcZBjR3qbNJV
   Q==;
X-CSE-ConnectionGUID: sMoLllROTEm3Csjy24XRww==
X-CSE-MsgGUID: gk7JIcxERYGlz5JroXEwug==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="27613391"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="27613391"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 09:57:08 -0700
X-CSE-ConnectionGUID: bl1VizmAQha2wrmxsA7g9g==
X-CSE-MsgGUID: mC2By01zSIa6ZeshtbMeiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="75790394"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 09:57:07 -0700
From: Tony Luck <tony.luck@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Christian Ludloff <ludloff@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	andrew.cooper3@citrix.com,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Fix #define name for Intel CPU model 0x5A
Date: Mon,  7 Oct 2024 09:57:01 -0700
Message-ID: <20241007165701.19693-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This CPU was mistakenly given the name INTEL_ATOM_AIRMONT_MID. But it
uses a Silvermont core, not Airmont.

Change #define name to INTEL_ATOM_SILVERMONT_MID2

Reported-by: Christian Ludloff <ludloff@gmail.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
I'm open to other suggestions for the new #define name.

 .../staging/media/atomisp/include/linux/atomisp_platform.h    | 4 ++--
 arch/x86/include/asm/intel-family.h                           | 2 +-
 arch/x86/events/intel/core.c                                  | 2 +-
 arch/x86/kernel/cpu/common.c                                  | 2 +-
 arch/x86/kernel/tsc_msr.c                                     | 2 +-
 drivers/powercap/intel_rapl_common.c                          | 2 +-
 drivers/thermal/intel/intel_tcc.c                             | 2 +-
 tools/power/x86/turbostat/turbostat.c                         | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index 064449fd51af..fe69c7a44cc0 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -183,10 +183,10 @@ void atomisp_unregister_subdev(struct v4l2_subdev *subdev);
 #define IS_BYT	__IS_SOC(INTEL_ATOM_SILVERMONT)
 #define IS_CHT	__IS_SOC(INTEL_ATOM_AIRMONT)
 #define IS_MRFD	__IS_SOC(INTEL_ATOM_SILVERMONT_MID)
-#define IS_MOFD	__IS_SOC(INTEL_ATOM_AIRMONT_MID)
+#define IS_MOFD	__IS_SOC(INTEL_ATOM_SILVERMONT_MID2)
 
 /* Both CHT and MOFD come with ISP2401 */
 #define IS_ISP2401 __IS_SOCS(INTEL_ATOM_AIRMONT, \
-			     INTEL_ATOM_AIRMONT_MID)
+			     INTEL_ATOM_SILVERMONT_MID2)
 
 #endif /* ATOMISP_PLATFORM_H_ */
diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 1a42f829667a..b9f4b87a55d2 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -149,9 +149,9 @@
 #define INTEL_ATOM_SILVERMONT		IFM(6, 0x37) /* Bay Trail, Valleyview */
 #define INTEL_ATOM_SILVERMONT_D		IFM(6, 0x4D) /* Avaton, Rangely */
 #define INTEL_ATOM_SILVERMONT_MID	IFM(6, 0x4A) /* Merriefield */
+#define INTEL_ATOM_SILVERMONT_MID2	IFM(6, 0x5A) /* Anniedale */
 
 #define INTEL_ATOM_AIRMONT		IFM(6, 0x4C) /* Cherry Trail, Braswell */
-#define INTEL_ATOM_AIRMONT_MID		IFM(6, 0x5A) /* Moorefield */
 #define INTEL_ATOM_AIRMONT_NP		IFM(6, 0x75) /* Lightning Mountain */
 
 #define INTEL_ATOM_GOLDMONT		IFM(6, 0x5C) /* Apollo Lake */
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index d879478db3f5..3e4ee59f20a1 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6526,7 +6526,7 @@ __init int intel_pmu_init(void)
 	case INTEL_ATOM_SILVERMONT_D:
 	case INTEL_ATOM_SILVERMONT_MID:
 	case INTEL_ATOM_AIRMONT:
-	case INTEL_ATOM_AIRMONT_MID:
+	case INTEL_ATOM_SILVERMONT_MID2:
 		memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
 			sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, slm_hw_cache_extra_regs,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 07a34d723505..63168b89b9c4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1165,7 +1165,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(INTEL_CORE_YONAH,		NO_SSB),
 
-	VULNWL_INTEL(INTEL_ATOM_AIRMONT_MID,	NO_SSB | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | MSBDS_ONLY),
+	VULNWL_INTEL(INTEL_ATOM_SILVERMONT_MID2,NO_SSB | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | MSBDS_ONLY),
 	VULNWL_INTEL(INTEL_ATOM_AIRMONT_NP,	NO_SSB | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
 	VULNWL_INTEL(INTEL_ATOM_GOLDMONT,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index deeb02825670..48e6cc1cb017 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -152,7 +152,7 @@ static const struct x86_cpu_id tsc_msr_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	&freq_desc_byt),
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID,	&freq_desc_tng),
 	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	&freq_desc_cht),
-	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_MID,	&freq_desc_ann),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID2,	&freq_desc_ann),
 	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_NP,	&freq_desc_lgm),
 	{}
 };
diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 5e793b80fd6b..61934c70e30d 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1273,7 +1273,7 @@ static const struct x86_cpu_id rapl_ids[] __initconst = {
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	&rapl_defaults_byt),
 	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	&rapl_defaults_cht),
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, &rapl_defaults_tng),
-	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_MID,	&rapl_defaults_ann),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID2,&rapl_defaults_ann),
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&rapl_defaults_core),
diff --git a/drivers/thermal/intel/intel_tcc.c b/drivers/thermal/intel/intel_tcc.c
index c86654f28aa5..0329bc0bba55 100644
--- a/drivers/thermal/intel/intel_tcc.c
+++ b/drivers/thermal/intel/intel_tcc.c
@@ -106,7 +106,7 @@ static const struct x86_cpu_id intel_tcc_cpu_ids[] __initconst = {
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_D,		&temp_broadwell),
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID,	&temp_broadwell),
 	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,		&temp_broadwell),
-	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_MID,		&temp_broadwell),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID2,	&temp_broadwell),
 	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_NP,		&temp_broadwell),
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,		&temp_goldmont),
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,		&temp_goldmont),
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 089220aaa5c9..eea7dbd2802a 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1027,7 +1027,7 @@ static const struct platform_data turbostat_pdata[] = {
 	 * Missing support for
 	 * INTEL_ICELAKE
 	 * INTEL_ATOM_SILVERMONT_MID
-	 * INTEL_ATOM_AIRMONT_MID
+	 * INTEL_ATOM_SILVERMONT_MID2
 	 * INTEL_ATOM_AIRMONT_NP
 	 */
 	{ 0, NULL },
-- 
2.46.2

