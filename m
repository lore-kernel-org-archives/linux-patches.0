Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA21D1C6610
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495912; cv=none; b=nqEhIC/2pC3oM820nLGWveSdrE8lRzlAc3TsoGXtTo1kycpchstH17bB8S4VpiiSK8JfBOfu1aG6fb600xb67B+FfIe50zRaEI09rx6UCZhAkvl5RFo5MuPd9S/yojEcQDcOzM5Ucv8zOOtrRPp7d8/5X8bGgaUc6cvPav95XQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495912; c=relaxed/simple;
	bh=Qr1oSpxWZ27YJOVnrdQbeSgDcIB9qPw15rIzdzPv2WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/NFWrmIEmTkpuDfa78PceQPa3x8nM+X31XUw7zZId85mSp4Ilkfj2sy07pIE2dubDO/WHCp5vUiqzQKpz2jp1msqLD8ANBdiTUePIRg0e6XbRJ37JVbIyOO6DUkMPwk0zA/3ht++is2tPqqnHhTGVi0ldFzGZrVvhexIcyrqPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bzoh/nq+; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bzoh/nq+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495910; x=1746031910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qr1oSpxWZ27YJOVnrdQbeSgDcIB9qPw15rIzdzPv2WU=;
  b=Bzoh/nq+uTENJgzE8qlnYIElLsxW43f5rCf/z/KbMXdbfrf+ReHN0S7x
   FCUFZtxZjOVqQB2x14lP7YefGS9BWFjFnDPPkloeHFmuHaKZMN4j4R/sg
   4IaFvV152VqTjVwSKsjYMuP3hLCu/c3gKrpx3h2cZYh6/aVnqGM/LtQgU
   ewgUKfZMHsxpH0E064BcOJSVSPE7WcBlWwuRpDHs+TA7aGm3eUQX7v/7W
   Suk6cSUWCh6oWGhm86yX+LqfVOnqpvNKhBaTXKqoW5nmLUIMnPWFg5b92
   rC9nVIG/r+040OiLtiFpuAKo/4wWGSevNt8+gfgk/uXXAfzT29Fbj3KKV
   w==;
X-CSE-ConnectionGUID: Q+5QtWz3RzGa2fFIrlGOhg==
X-CSE-MsgGUID: UcnYWFtjTruaSuqLc/f1zg==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075763"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075763"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: zn93bogfSbKYYdjXR2y1bw==
X-CSE-MsgGUID: CP+pflCGQ0aBKb1iC35fvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515520"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v5 41/47] tools/power/turbostat: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:54 -0700
Message-ID: <20240430165100.73491-41-tony.luck@intel.com>
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

N.B. Copied VFM_*() defines here from <asm/cpu_device_id.h> to avoid
an application picking a second internal kernel header file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 161 +++++++++++++++-----------
 1 file changed, 93 insertions(+), 68 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 7a334377f92b..68c660c58a13 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -9,6 +9,30 @@
 
 #define _GNU_SOURCE
 #include MSRHEADER
+
+// copied from arch/x86/include/asm/cpu_device_id.h
+#define VFM_MODEL_BIT	0
+#define VFM_FAMILY_BIT	8
+#define VFM_VENDOR_BIT	16
+#define VFM_RSVD_BIT	24
+
+#define	VFM_MODEL_MASK	GENMASK(VFM_FAMILY_BIT - 1, VFM_MODEL_BIT)
+#define	VFM_FAMILY_MASK	GENMASK(VFM_VENDOR_BIT - 1, VFM_FAMILY_BIT)
+#define	VFM_VENDOR_MASK	GENMASK(VFM_RSVD_BIT - 1, VFM_VENDOR_BIT)
+
+#define VFM_MODEL(vfm)	(((vfm) & VFM_MODEL_MASK) >> VFM_MODEL_BIT)
+#define VFM_FAMILY(vfm)	(((vfm) & VFM_FAMILY_MASK) >> VFM_FAMILY_BIT)
+#define VFM_VENDOR(vfm)	(((vfm) & VFM_VENDOR_MASK) >> VFM_VENDOR_BIT)
+
+#define	VFM_MAKE(_vendor, _family, _model) (	\
+	((_model) << VFM_MODEL_BIT) |		\
+	((_family) << VFM_FAMILY_BIT) |		\
+	((_vendor) << VFM_VENDOR_BIT)		\
+)
+// end copied section
+
+#define X86_VENDOR_INTEL	0
+
 #include INTEL_FAMILY_HEADER
 #include <stdarg.h>
 #include <stdio.h>
@@ -300,7 +324,7 @@ struct platform_features {
 };
 
 struct platform_data {
-	unsigned int model;
+	unsigned int vfm;
 	const struct platform_features *features;
 };
 
@@ -825,73 +849,73 @@ static const struct platform_features amd_features_with_rapl = {
 };
 
 static const struct platform_data turbostat_pdata[] = {
-	{ INTEL_FAM6_NEHALEM, &nhm_features },
-	{ INTEL_FAM6_NEHALEM_G, &nhm_features },
-	{ INTEL_FAM6_NEHALEM_EP, &nhm_features },
-	{ INTEL_FAM6_NEHALEM_EX, &nhx_features },
-	{ INTEL_FAM6_WESTMERE, &nhm_features },
-	{ INTEL_FAM6_WESTMERE_EP, &nhm_features },
-	{ INTEL_FAM6_WESTMERE_EX, &nhx_features },
-	{ INTEL_FAM6_SANDYBRIDGE, &snb_features },
-	{ INTEL_FAM6_SANDYBRIDGE_X, &snx_features },
-	{ INTEL_FAM6_IVYBRIDGE, &ivb_features },
-	{ INTEL_FAM6_IVYBRIDGE_X, &ivx_features },
-	{ INTEL_FAM6_HASWELL, &hsw_features },
-	{ INTEL_FAM6_HASWELL_X, &hsx_features },
-	{ INTEL_FAM6_HASWELL_L, &hswl_features },
-	{ INTEL_FAM6_HASWELL_G, &hswg_features },
-	{ INTEL_FAM6_BROADWELL, &bdw_features },
-	{ INTEL_FAM6_BROADWELL_G, &bdwg_features },
-	{ INTEL_FAM6_BROADWELL_X, &bdx_features },
-	{ INTEL_FAM6_BROADWELL_D, &bdx_features },
-	{ INTEL_FAM6_SKYLAKE_L, &skl_features },
-	{ INTEL_FAM6_SKYLAKE, &skl_features },
-	{ INTEL_FAM6_SKYLAKE_X, &skx_features },
-	{ INTEL_FAM6_KABYLAKE_L, &skl_features },
-	{ INTEL_FAM6_KABYLAKE, &skl_features },
-	{ INTEL_FAM6_COMETLAKE, &skl_features },
-	{ INTEL_FAM6_COMETLAKE_L, &skl_features },
-	{ INTEL_FAM6_CANNONLAKE_L, &cnl_features },
-	{ INTEL_FAM6_ICELAKE_X, &icx_features },
-	{ INTEL_FAM6_ICELAKE_D, &icx_features },
-	{ INTEL_FAM6_ICELAKE_L, &cnl_features },
-	{ INTEL_FAM6_ICELAKE_NNPI, &cnl_features },
-	{ INTEL_FAM6_ROCKETLAKE, &cnl_features },
-	{ INTEL_FAM6_TIGERLAKE_L, &cnl_features },
-	{ INTEL_FAM6_TIGERLAKE, &cnl_features },
-	{ INTEL_FAM6_SAPPHIRERAPIDS_X, &spr_features },
-	{ INTEL_FAM6_EMERALDRAPIDS_X, &spr_features },
-	{ INTEL_FAM6_GRANITERAPIDS_X, &spr_features },
-	{ INTEL_FAM6_LAKEFIELD, &cnl_features },
-	{ INTEL_FAM6_ALDERLAKE, &adl_features },
-	{ INTEL_FAM6_ALDERLAKE_L, &adl_features },
-	{ INTEL_FAM6_RAPTORLAKE, &adl_features },
-	{ INTEL_FAM6_RAPTORLAKE_P, &adl_features },
-	{ INTEL_FAM6_RAPTORLAKE_S, &adl_features },
-	{ INTEL_FAM6_METEORLAKE, &cnl_features },
-	{ INTEL_FAM6_METEORLAKE_L, &cnl_features },
-	{ INTEL_FAM6_ARROWLAKE, &cnl_features },
-	{ INTEL_FAM6_LUNARLAKE_M, &cnl_features },
-	{ INTEL_FAM6_ATOM_SILVERMONT, &slv_features },
-	{ INTEL_FAM6_ATOM_SILVERMONT_D, &slvd_features },
-	{ INTEL_FAM6_ATOM_AIRMONT, &amt_features },
-	{ INTEL_FAM6_ATOM_GOLDMONT, &gmt_features },
-	{ INTEL_FAM6_ATOM_GOLDMONT_D, &gmtd_features },
-	{ INTEL_FAM6_ATOM_GOLDMONT_PLUS, &gmtp_features },
-	{ INTEL_FAM6_ATOM_TREMONT_D, &tmtd_features },
-	{ INTEL_FAM6_ATOM_TREMONT, &tmt_features },
-	{ INTEL_FAM6_ATOM_TREMONT_L, &tmt_features },
-	{ INTEL_FAM6_ATOM_GRACEMONT, &adl_features },
-	{ INTEL_FAM6_ATOM_CRESTMONT_X, &srf_features },
-	{ INTEL_FAM6_ATOM_CRESTMONT, &grr_features },
-	{ INTEL_FAM6_XEON_PHI_KNL, &knl_features },
-	{ INTEL_FAM6_XEON_PHI_KNM, &knl_features },
+	{ INTEL_NEHALEM, &nhm_features },
+	{ INTEL_NEHALEM_G, &nhm_features },
+	{ INTEL_NEHALEM_EP, &nhm_features },
+	{ INTEL_NEHALEM_EX, &nhx_features },
+	{ INTEL_WESTMERE, &nhm_features },
+	{ INTEL_WESTMERE_EP, &nhm_features },
+	{ INTEL_WESTMERE_EX, &nhx_features },
+	{ INTEL_SANDYBRIDGE, &snb_features },
+	{ INTEL_SANDYBRIDGE_X, &snx_features },
+	{ INTEL_IVYBRIDGE, &ivb_features },
+	{ INTEL_IVYBRIDGE_X, &ivx_features },
+	{ INTEL_HASWELL, &hsw_features },
+	{ INTEL_HASWELL_X, &hsx_features },
+	{ INTEL_HASWELL_L, &hswl_features },
+	{ INTEL_HASWELL_G, &hswg_features },
+	{ INTEL_BROADWELL, &bdw_features },
+	{ INTEL_BROADWELL_G, &bdwg_features },
+	{ INTEL_BROADWELL_X, &bdx_features },
+	{ INTEL_BROADWELL_D, &bdx_features },
+	{ INTEL_SKYLAKE_L, &skl_features },
+	{ INTEL_SKYLAKE, &skl_features },
+	{ INTEL_SKYLAKE_X, &skx_features },
+	{ INTEL_KABYLAKE_L, &skl_features },
+	{ INTEL_KABYLAKE, &skl_features },
+	{ INTEL_COMETLAKE, &skl_features },
+	{ INTEL_COMETLAKE_L, &skl_features },
+	{ INTEL_CANNONLAKE_L, &cnl_features },
+	{ INTEL_ICELAKE_X, &icx_features },
+	{ INTEL_ICELAKE_D, &icx_features },
+	{ INTEL_ICELAKE_L, &cnl_features },
+	{ INTEL_ICELAKE_NNPI, &cnl_features },
+	{ INTEL_ROCKETLAKE, &cnl_features },
+	{ INTEL_TIGERLAKE_L, &cnl_features },
+	{ INTEL_TIGERLAKE, &cnl_features },
+	{ INTEL_SAPPHIRERAPIDS_X, &spr_features },
+	{ INTEL_EMERALDRAPIDS_X, &spr_features },
+	{ INTEL_GRANITERAPIDS_X, &spr_features },
+	{ INTEL_LAKEFIELD, &cnl_features },
+	{ INTEL_ALDERLAKE, &adl_features },
+	{ INTEL_ALDERLAKE_L, &adl_features },
+	{ INTEL_RAPTORLAKE, &adl_features },
+	{ INTEL_RAPTORLAKE_P, &adl_features },
+	{ INTEL_RAPTORLAKE_S, &adl_features },
+	{ INTEL_METEORLAKE, &cnl_features },
+	{ INTEL_METEORLAKE_L, &cnl_features },
+	{ INTEL_ARROWLAKE, &cnl_features },
+	{ INTEL_LUNARLAKE_M, &cnl_features },
+	{ INTEL_ATOM_SILVERMONT, &slv_features },
+	{ INTEL_ATOM_SILVERMONT_D, &slvd_features },
+	{ INTEL_ATOM_AIRMONT, &amt_features },
+	{ INTEL_ATOM_GOLDMONT, &gmt_features },
+	{ INTEL_ATOM_GOLDMONT_D, &gmtd_features },
+	{ INTEL_ATOM_GOLDMONT_PLUS, &gmtp_features },
+	{ INTEL_ATOM_TREMONT_D, &tmtd_features },
+	{ INTEL_ATOM_TREMONT, &tmt_features },
+	{ INTEL_ATOM_TREMONT_L, &tmt_features },
+	{ INTEL_ATOM_GRACEMONT, &adl_features },
+	{ INTEL_ATOM_CRESTMONT_X, &srf_features },
+	{ INTEL_ATOM_CRESTMONT, &grr_features },
+	{ INTEL_XEON_PHI_KNL, &knl_features },
+	{ INTEL_XEON_PHI_KNM, &knl_features },
 	/*
 	 * Missing support for
-	 * INTEL_FAM6_ICELAKE
-	 * INTEL_FAM6_ATOM_SILVERMONT_MID
-	 * INTEL_FAM6_ATOM_AIRMONT_MID
-	 * INTEL_FAM6_ATOM_AIRMONT_NP
+	 * INTEL_ICELAKE
+	 * INTEL_ATOM_SILVERMONT_MID
+	 * INTEL_ATOM_AIRMONT_MID
+	 * INTEL_ATOM_AIRMONT_NP
 	 */
 	{ 0, NULL },
 };
@@ -916,11 +940,12 @@ void probe_platform_features(unsigned int family, unsigned int model)
 		return;
 	}
 
-	if (!genuine_intel || family != 6)
+	if (!genuine_intel)
 		return;
 
 	for (i = 0; turbostat_pdata[i].features; i++) {
-		if (turbostat_pdata[i].model == model) {
+		if (VFM_FAMILY(turbostat_pdata[i].vfm) == family &&
+		    VFM_MODEL(turbostat_pdata[i].vfm) == model) {
 			platform = turbostat_pdata[i].features;
 			return;
 		}
-- 
2.44.0

