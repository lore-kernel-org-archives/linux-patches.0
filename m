Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156A8130E5D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643314; cv=none; b=ICkH7/vaqByzcUd4zyQ4U+nTvHkTosbpNPGK+N2+x37FYsas07TBYk+72wph3w2W6EB5iRzj56a/8MkfiSdg1FXINvvDRFEkGEB/64UJu2km9qoBMWLDzMW2E9a4/8DE/0HxCspz0jZ1cEcJwLE34guseGJKTwLL5UHffy/7RQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643314; c=relaxed/simple;
	bh=A8rPja5SM3e/A73Nv/9L+KQ5Wu8KFRJ03CdluyjQGDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibLqN95a+T3PaCfkaWopnbY3jlELIjbS12NhvTn2+8vMIg8LRAwqbpTKWCaElr23lOJkRmWfHjy6t7gLr6vNTNz2X8WQJlF8BXqDmYo/gGhjJK4sVfHEjHNTXGnR7REEWP7XZkh7pYpjRXM+6SzdpPZJlZbhiApLx9Jx2GicUrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BORDVyWi; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BORDVyWi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643311; x=1743179311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A8rPja5SM3e/A73Nv/9L+KQ5Wu8KFRJ03CdluyjQGDk=;
  b=BORDVyWiV4Mwa3l2KRLKNqlzDZzFF0WYXFrtWjMGSmAIlutS0+lDZcB2
   ARa311u8/EM9hj1zLLVBop12mseTsB5+uFqAyOP56W5e7DN1Os8VRZKeb
   e8jZV8/4vfcdvTTT460c2gg1BbJnrEVP1/AEHSPYi3ECxEk4JkFXSRzHY
   11/+xbczYeymz2lXCAomn76Uk2U8PdEE6LPHCgMJ0J0PQaMUCo3PXw+xO
   ELkZO6DypDZ9YyuvviiUji8l/GQu6ocTgxLLLkuNBLzRnfuFfmQkjl6WR
   wswCy00cGsDPbf8h19vGOnnnLif5hAE/EgOvU5JCwR32gUpVZbimz96D3
   w==;
X-CSE-ConnectionGUID: LQWcoHGGRxCSy1AlMB0o+A==
X-CSE-MsgGUID: Qszrpxo3Q8aIdNnlUOvKsw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294764"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294764"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726073"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 38/74] x86/cpu/vfm: Update drivers/cpufreq/intel_pstate.c
Date: Thu, 28 Mar 2024 09:27:32 -0700
Message-ID: <20240328162820.242778-38-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
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
 drivers/cpufreq/intel_pstate.c | 90 +++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index dbbf299f4219..685ec80e0af5 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2402,52 +2402,51 @@ static const struct pstate_funcs knl_funcs = {
 	.get_val = core_get_val,
 };
 
-#define X86_MATCH(model, policy)					 \
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6, INTEL_FAM6_##model, \
-					   X86_FEATURE_APERFMPERF, &policy)
+#define X86_MATCH(vfm, policy)					 \
+	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_APERFMPERF, &policy)
 
 static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
-	X86_MATCH(SANDYBRIDGE,		core_funcs),
-	X86_MATCH(SANDYBRIDGE_X,	core_funcs),
-	X86_MATCH(ATOM_SILVERMONT,	silvermont_funcs),
-	X86_MATCH(IVYBRIDGE,		core_funcs),
-	X86_MATCH(HASWELL,		core_funcs),
-	X86_MATCH(BROADWELL,		core_funcs),
-	X86_MATCH(IVYBRIDGE_X,		core_funcs),
-	X86_MATCH(HASWELL_X,		core_funcs),
-	X86_MATCH(HASWELL_L,		core_funcs),
-	X86_MATCH(HASWELL_G,		core_funcs),
-	X86_MATCH(BROADWELL_G,		core_funcs),
-	X86_MATCH(ATOM_AIRMONT,		airmont_funcs),
-	X86_MATCH(SKYLAKE_L,		core_funcs),
-	X86_MATCH(BROADWELL_X,		core_funcs),
-	X86_MATCH(SKYLAKE,		core_funcs),
-	X86_MATCH(BROADWELL_D,		core_funcs),
-	X86_MATCH(XEON_PHI_KNL,		knl_funcs),
-	X86_MATCH(XEON_PHI_KNM,		knl_funcs),
-	X86_MATCH(ATOM_GOLDMONT,	core_funcs),
-	X86_MATCH(ATOM_GOLDMONT_PLUS,	core_funcs),
-	X86_MATCH(SKYLAKE_X,		core_funcs),
-	X86_MATCH(COMETLAKE,		core_funcs),
-	X86_MATCH(ICELAKE_X,		core_funcs),
-	X86_MATCH(TIGERLAKE,		core_funcs),
-	X86_MATCH(SAPPHIRERAPIDS_X,	core_funcs),
-	X86_MATCH(EMERALDRAPIDS_X,      core_funcs),
+	X86_MATCH(INTEL_SANDYBRIDGE,		core_funcs),
+	X86_MATCH(INTEL_SANDYBRIDGE_X,		core_funcs),
+	X86_MATCH(INTEL_ATOM_SILVERMONT,	silvermont_funcs),
+	X86_MATCH(INTEL_IVYBRIDGE,		core_funcs),
+	X86_MATCH(INTEL_HASWELL,		core_funcs),
+	X86_MATCH(INTEL_BROADWELL,		core_funcs),
+	X86_MATCH(INTEL_IVYBRIDGE_X,		core_funcs),
+	X86_MATCH(INTEL_HASWELL_X,		core_funcs),
+	X86_MATCH(INTEL_HASWELL_L,		core_funcs),
+	X86_MATCH(INTEL_HASWELL_G,		core_funcs),
+	X86_MATCH(INTEL_BROADWELL_G,		core_funcs),
+	X86_MATCH(INTEL_ATOM_AIRMONT,		airmont_funcs),
+	X86_MATCH(INTEL_SKYLAKE_L,		core_funcs),
+	X86_MATCH(INTEL_BROADWELL_X,		core_funcs),
+	X86_MATCH(INTEL_SKYLAKE,		core_funcs),
+	X86_MATCH(INTEL_BROADWELL_D,		core_funcs),
+	X86_MATCH(INTEL_XEON_PHI_KNL,		knl_funcs),
+	X86_MATCH(INTEL_XEON_PHI_KNM,		knl_funcs),
+	X86_MATCH(INTEL_ATOM_GOLDMONT,		core_funcs),
+	X86_MATCH(INTEL_ATOM_GOLDMONT_PLUS,	core_funcs),
+	X86_MATCH(INTEL_SKYLAKE_X,		core_funcs),
+	X86_MATCH(INTEL_COMETLAKE,		core_funcs),
+	X86_MATCH(INTEL_ICELAKE_X,		core_funcs),
+	X86_MATCH(INTEL_TIGERLAKE,		core_funcs),
+	X86_MATCH(INTEL_SAPPHIRERAPIDS_X,	core_funcs),
+	X86_MATCH(INTEL_EMERALDRAPIDS_X,	core_funcs),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
 
 static const struct x86_cpu_id intel_pstate_cpu_oob_ids[] __initconst = {
-	X86_MATCH(BROADWELL_D,		core_funcs),
-	X86_MATCH(BROADWELL_X,		core_funcs),
-	X86_MATCH(SKYLAKE_X,		core_funcs),
-	X86_MATCH(ICELAKE_X,		core_funcs),
-	X86_MATCH(SAPPHIRERAPIDS_X,	core_funcs),
+	X86_MATCH(INTEL_BROADWELL_D,		core_funcs),
+	X86_MATCH(INTEL_BROADWELL_X,		core_funcs),
+	X86_MATCH(INTEL_SKYLAKE_X,		core_funcs),
+	X86_MATCH(INTEL_ICELAKE_X,		core_funcs),
+	X86_MATCH(INTEL_SAPPHIRERAPIDS_X,	core_funcs),
 	{}
 };
 
 static const struct x86_cpu_id intel_pstate_cpu_ee_disable_ids[] = {
-	X86_MATCH(KABYLAKE,		core_funcs),
+	X86_MATCH(INTEL_KABYLAKE,		core_funcs),
 	{}
 };
 
@@ -3386,14 +3385,13 @@ static inline void intel_pstate_request_control_from_smm(void) {}
 
 #define INTEL_PSTATE_HWP_BROADWELL	0x01
 
-#define X86_MATCH_HWP(model, hwp_mode)					\
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6, INTEL_FAM6_##model, \
-					   X86_FEATURE_HWP, hwp_mode)
+#define X86_MATCH_HWP(vfm, hwp_mode)				\
+	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_HWP, hwp_mode)
 
 static const struct x86_cpu_id hwp_support_ids[] __initconst = {
-	X86_MATCH_HWP(BROADWELL_X,	INTEL_PSTATE_HWP_BROADWELL),
-	X86_MATCH_HWP(BROADWELL_D,	INTEL_PSTATE_HWP_BROADWELL),
-	X86_MATCH_HWP(ANY,		0),
+	X86_MATCH_HWP(INTEL_BROADWELL_X,	INTEL_PSTATE_HWP_BROADWELL),
+	X86_MATCH_HWP(INTEL_BROADWELL_D,	INTEL_PSTATE_HWP_BROADWELL),
+	X86_MATCH_HWP(INTEL_ANY,		0),
 	{}
 };
 
@@ -3426,15 +3424,15 @@ static const struct x86_cpu_id intel_epp_default[] = {
 	 * which can result in one core turbo frequency for
 	 * AlderLake Mobile CPUs.
 	 */
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, HWP_SET_DEF_BALANCE_PERF_EPP(102)),
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, HWP_SET_DEF_BALANCE_PERF_EPP(32)),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L, HWP_SET_EPP_VALUES(HWP_EPP_POWERSAVE,
-							HWP_EPP_BALANCE_POWERSAVE, 115, 16)),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L, HWP_SET_DEF_BALANCE_PERF_EPP(102)),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, HWP_SET_DEF_BALANCE_PERF_EPP(32)),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L, HWP_SET_EPP_VALUES(HWP_EPP_POWERSAVE,
+		      HWP_EPP_BALANCE_POWERSAVE, 115, 16)),
 	{}
 };
 
 static const struct x86_cpu_id intel_hybrid_scaling_factor[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L, HYBRID_SCALING_FACTOR_MTL),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L, HYBRID_SCALING_FACTOR_MTL),
 	{}
 };
 
-- 
2.44.0

