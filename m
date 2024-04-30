Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B351C2300
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495911; cv=none; b=NOiTMQi5/rdaKlayYPK7qHeYI1NoVxcowUZ67VK5dvCEzsi1qxE6PM9/7qd6OV9UpmU0rOtkFJdymLvNxWmZXqEeuE/9ugg5D34eNGhKsvs4Acs7ovsb2s11X7XHoZfOqDaHVYV4WxNJHGh2b5BLD40APk1cBuLDxVfkLPO1zjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495911; c=relaxed/simple;
	bh=X1kVlmKoykgrGIOBnOPbHS/gm0hWrSVAGeWzcm3MPZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ46ViXWPUQPapIkU3FMDcqtw+6+OQbgWO0pTKOlVBcZz1O6IlQbfWsb6+R31etc6Z1CUHcpLHWsZnszjnlWMIh5GBhMsIXRGRrBgUrgdeI5mCio4Bd6Xkc8dqO0WQNbx2c5hUvVNoTbmptJrv99B0Karu+iTpEiKUEXb+uq41U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CRLk7+sw; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CRLk7+sw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495909; x=1746031909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X1kVlmKoykgrGIOBnOPbHS/gm0hWrSVAGeWzcm3MPZU=;
  b=CRLk7+swCVA0b6fVqlcw6qqm3DcnjAinqmGTtE8wKARDy7j/PmOHKw7F
   OXrpCK3XjzEFoAQ7NSi2NHUL3QDAT/8IA8tQHKoLvr1+cnXe7dG+YNEsd
   /Vki1B4oWYkE60qiNuib8AZf10x0/q6zfQdYqZtN5JxlVWOYXjjwn5JyH
   XyME1gWA73QchjwfvVR3WHNHYP4xPPs4d1Or5BXiRxwHjD8PZUq0se+5k
   mVRHTy0JC9RTouyBMASFU5Jr6Q2c2onL+IpEQPYnsGGGgbsp0FpH1Su51
   4uG21AhWc2SP0X8u9JMn7+huEKpDkEVbD9tddl4b5iA/yNRzAY8eZpj01
   w==;
X-CSE-ConnectionGUID: uVFNHPKySZ6HhXE67hltpg==
X-CSE-MsgGUID: dbyCUEkkSXWCRHbglIvFpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075752"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075752"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: +0DddIMwSmigdoDZrLTMzg==
X-CSE-MsgGUID: GzwnytXpSraOZfLqnYCZfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515514"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v5 39/47] cpufreq: intel_pstate: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:52 -0700
Message-ID: <20240430165100.73491-39-tony.luck@intel.com>
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
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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

