Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B5B13C9AF
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245217; cv=none; b=ge+rth6P7n7lpLK6cxk5YumeIknbz+ZxrEbPniICI6N5neUW1l6h9edKwmzpA78ajXRyYnTMsdSYIpQvGjZw02i/5uod92YA1TOfng1TcMr05m9jOlIP8UZYRJom6BdwCbAghS/0Wor6A+auFgKSLjA0XRVuoTkjXsBp+JX8Q0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245217; c=relaxed/simple;
	bh=6a3GkybpndO6V8BBiLVHi4y7WhZypoRGyiKKTkvOGRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czcdBnqZUbITiHvmp88tq7N44xzd+rn/SvYmkvSk5NjOWFFOxadhU+rxbCXrXtMDYbHZ8tDfgSM76bEW0U8LFBq2Ypijcxpc4SCdyXIILvovuFyu6Rq7i89cTMhbTimHqs20hSMtkvg6niAwGfgFd7rh/nLeBLxKHexZFj6Hios=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GPah9F8V; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GPah9F8V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245213; x=1747781213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6a3GkybpndO6V8BBiLVHi4y7WhZypoRGyiKKTkvOGRo=;
  b=GPah9F8VnrSbGg+y87NYkM2Jw5ngEqPLh3MC2Ab6cHszxxZkPxwGPG2k
   2UbNoK4pNoWlo/gluPRtkD4z3craTFHpRDkcYSoWbpFN9Vcx9mFpuAEAE
   sXfIGW2lIYZzrghIpuDE2lJWMaox5v5JxTfh5eBcQIUClHI0dr94/CEr7
   YCMWAss4ZCUGJdqHJQz3zp4SimD9uv/8g5Pl7vWeH/3IPj8bI56EEqzdD
   BUPJDNi1dv4lvwM4pQm870oRaaGEg6NqA6oWpXy5QZdUVOPUeZfNWVhb6
   Lgere/u3R6BtCdhA4p7PPciA5Nb2+uZrjAufTIe1J3lO2MHjKXCwY1W8G
   w==;
X-CSE-ConnectionGUID: PCoK1mQITPSoVCLjhXF0sw==
X-CSE-MsgGUID: y+SEDjtFSdiBUGyN/wCotw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199967"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199967"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
X-CSE-ConnectionGUID: kuR694ncSg+jAMCLnwR/Eg==
X-CSE-MsgGUID: QG2j3FUCQaGHzzUx49fZbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593512"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v6 42/49] cpufreq: intel_pstate: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:13 -0700
Message-ID: <20240520224620.9480-43-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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
index 4b986c044741..69d85b5bf366 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2362,54 +2362,53 @@ static const struct pstate_funcs knl_funcs = {
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
 
 #ifdef CONFIG_ACPI
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
 #endif
 
 static const struct x86_cpu_id intel_pstate_cpu_ee_disable_ids[] = {
-	X86_MATCH(KABYLAKE,		core_funcs),
+	X86_MATCH(INTEL_KABYLAKE,		core_funcs),
 	{}
 };
 
@@ -3345,14 +3344,13 @@ static inline void intel_pstate_request_control_from_smm(void) {}
 
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
 
@@ -3385,15 +3383,15 @@ static const struct x86_cpu_id intel_epp_default[] = {
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
2.45.0

