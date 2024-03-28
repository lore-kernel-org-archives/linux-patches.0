Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6B759B4E
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643323; cv=none; b=Oo1kiUzCQ4RtngGeCFvFvYWxOKwjzt+f1Q+tOIrOJjovEp6Mo1QQnbkW1nmKsOUAr4NGdPsKT1oTkTf555U4sZzc0ezTThe28uMf5fiHavwbSwLeqXJjgGrc4oJATLbzSvxxKBYddJUhsgy/0aI0MP0o6xkt7YDsOv3VdfWbLWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643323; c=relaxed/simple;
	bh=fR0Wo9JmCK1kuYf5aubmxSE+3t0SSjK8Tl/bVGDHMv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuIeEQ6EYQEFM9oo5KWELd+PmlEzNOieJI3KbwFhaNZuug8+u03HvzAgbxDCRbatm5dHz5TWY6a2iTYsqchsUnYuS15Qom89wOS1lQWV8AlTkDiq+0R49CwvZxbToLEj3mP3QGwX5BVWODoqHitqEJWEpEXzum7DdioKLtX8SVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kXAnvMh7; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kXAnvMh7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643320; x=1743179320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fR0Wo9JmCK1kuYf5aubmxSE+3t0SSjK8Tl/bVGDHMv8=;
  b=kXAnvMh7kxNAoM5LeKxNhClEOBvYKojiaPpBAH/cUqUBZl4SY7+t7FfC
   3Iyjp/xaHDnVH4d3kLWZIe6kgAOE97n7f93JMQjPYmSQrxTqMxkhm0Wme
   s3808pwPdbmcaa+sI4BcQL09xy4z1NSwOdjKrRUxGUpLOB9SsCLt9t9/K
   umcjI3/PLy+Nlf6rYKlaXRCrB9tp/1Ga9Zm9Dc2+Tt2e8WpaPPeJvaanE
   Y+mNqkPFn3/58O2YR9d8Xn3kT/S8tuD5geEyUs1DE7IiTXyO0l2yzdDAW
   qpGIPY957UDU38kGkv9JXx4B2uG3g4NL26xmStlSLGAOo3M4w9X2lqa2u
   w==;
X-CSE-ConnectionGUID: dAU9tszhSfeQxv7sioefQQ==
X-CSE-MsgGUID: OSUX1apATtuKRsORdUV4DQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294806"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294806"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726190"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 71/74] x86/cpu/vfm: Update tools/power/x86/turbostat/turbostat.c
Date: Thu, 28 Mar 2024 09:28:05 -0700
Message-ID: <20240328162820.242778-71-tony.luck@intel.com>
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
 tools/power/x86/turbostat/turbostat.c | 161 +++++++++++++++-----------
 1 file changed, 93 insertions(+), 68 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 7a334377f92b..7194c2da5617 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -9,6 +9,30 @@
 
 #define _GNU_SOURCE
 #include MSRHEADER
+
+// copied from arch/x86/include/asm/cpu_device_id.h
+#define VFM_VENDOR_BIT  0
+#define VFM_FAMILY_BIT  8
+#define VFM_MODEL_BIT   16
+#define VFM_RSVD_BIT    24
+
+#define VFM_VENDOR_MASK GENMASK(VFM_FAMILY_BIT - 1, VFM_VENDOR_BIT)
+#define VFM_FAMILY_MASK GENMASK(VFM_MODEL_BIT - 1, VFM_FAMILY_BIT)
+#define VFM_MODEL_MASK  GENMASK(VFM_RSVD_BIT - 1, VFM_MODEL_BIT)
+
+#define VFM_VENDOR(vfm) (((vfm) & VFM_VENDOR_MASK) >> VFM_VENDOR_BIT)
+#define VFM_FAMILY(vfm) (((vfm) & VFM_FAMILY_MASK) >> VFM_FAMILY_BIT)
+#define VFM_MODEL(vfm)  (((vfm) & VFM_MODEL_MASK) >> VFM_MODEL_BIT)
+
+#define VFM_MAKE(_vendor, _family, _model) (	\
+	((_vendor) << VFM_VENDOR_BIT) |		\
+	((_family) << VFM_FAMILY_BIT) |		\
+	((_model) << VFM_MODEL_BIT)		\
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

