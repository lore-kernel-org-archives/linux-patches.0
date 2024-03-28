Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B1A131183
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643322; cv=none; b=eTkO6HXXDSuYrjLumie0sRYevbuOPyMkJKjZWdOzhP03wDV87Cjh+3bKyZZEx+enqfMw3uhmlPSGVDp3nOCGH79zk+KHGgK5QDD3cJ0nIBM3WJw+NhIAiwkQZ9L/J+hJC+raJARZO7Djvnlf989zryJliM/ZIQFHsATbAUzO6+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643322; c=relaxed/simple;
	bh=TEzhvkvCuOTK927VLY77j87rDedjjUqKcpM9RnTh430=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaaT2O5wyx/4SUEkk30XW+o/8ZNJpQJmr1QkZPEJRje6hdwFLNtOSpGF6HmLXrQtQzzIieJHVIMPQrtSCSIcDZWRkFY8JhUZSv6/aCnQ4l0F+KyETdc46z9+2w+uHzHWpBP8yb01MtI9sFPfD+/Q9124n+rNyY3owyADhy5X5qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B/uv1Ox9; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B/uv1Ox9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643317; x=1743179317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TEzhvkvCuOTK927VLY77j87rDedjjUqKcpM9RnTh430=;
  b=B/uv1Ox91mBrVCl5qu56InUxg4Id3Yx99ghDn0MwtVYFErNgbmziPHgW
   ZeRhg657qUCoBec4FrM11jvu2m/eZxoXIwgTzVdW4EtpoDkS+iH15HtWO
   +og3W/T7kirlR9BC2nIGTmLuhccJekHJm4YGwpxVEe0dvrQpkfOioD1iF
   YrbNYGv+Gy5h+O2HHcG/f2BJEU5G+pE48Slsv8bnsrwQrsGVF3FEXw4gG
   6crDQ86sGPv2q7ZkHqvdD1tpGOr0C2tUEdyoUwSBob11JyH7XAIchHDwB
   l2p96q9Ztvk+h6Pt0YN1vkSgVyTZf396TI0/QWkmTqOUX8uZ4lTO6pLhm
   Q==;
X-CSE-ConnectionGUID: QKgIspDrRMCcWiSpl2FqMw==
X-CSE-MsgGUID: E5+jCF4ARXuizr6DrofqAw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294792"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294792"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726151"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 61/74] x86/cpu/vfm: Update drivers/powercap/intel_rapl_common.c
Date: Thu, 28 Mar 2024 09:27:55 -0700
Message-ID: <20240328162820.242778-61-tony.luck@intel.com>
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
 drivers/powercap/intel_rapl_common.c | 118 +++++++++++++--------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index a28d54fd5222..59c36ea55712 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1220,65 +1220,65 @@ static const struct rapl_defaults rapl_defaults_amd = {
 };
 
 static const struct x86_cpu_id rapl_ids[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE_X,	&rapl_defaults_core),
-
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X,		&rapl_defaults_core),
-
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_L,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_G,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X,		&rapl_defaults_hsw_server),
-
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_G,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,		&rapl_defaults_hsw_server),
-
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,		&rapl_defaults_hsw_server),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(CANNONLAKE_L,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_NNPI,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&rapl_defaults_hsw_server),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&rapl_defaults_hsw_server),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ROCKETLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,        &rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&rapl_defaults_spr_server),
-	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&rapl_defaults_spr_server),
-	X86_MATCH_INTEL_FAM6_MODEL(LUNARLAKE_M,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ARROWLAKE,		&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(LAKEFIELD,		&rapl_defaults_core),
-
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	&rapl_defaults_byt),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&rapl_defaults_cht),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID,	&rapl_defaults_tng),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT_MID,	&rapl_defaults_ann),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_D,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_D,	&rapl_defaults_core),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_L,	&rapl_defaults_core),
-
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,	&rapl_defaults_hsw_server),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,	&rapl_defaults_hsw_server),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE_X,	&rapl_defaults_core),
+
+	X86_MATCH_VFM(INTEL_IVYBRIDGE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE_X,	&rapl_defaults_core),
+
+	X86_MATCH_VFM(INTEL_HASWELL,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_HASWELL_L,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_HASWELL_G,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_HASWELL_X,		&rapl_defaults_hsw_server),
+
+	X86_MATCH_VFM(INTEL_BROADWELL,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_BROADWELL_G,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	&rapl_defaults_hsw_server),
+
+	X86_MATCH_VFM(INTEL_SKYLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,		&rapl_defaults_hsw_server),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_CANNONLAKE_L,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ICELAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ICELAKE_NNPI,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,		&rapl_defaults_hsw_server),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,		&rapl_defaults_hsw_server),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_COMETLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_TIGERLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ROCKETLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ALDERLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,        &rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_METEORLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	&rapl_defaults_spr_server),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	&rapl_defaults_spr_server),
+	X86_MATCH_VFM(INTEL_LUNARLAKE_M,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ARROWLAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_LAKEFIELD,		&rapl_defaults_core),
+
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	&rapl_defaults_byt),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	&rapl_defaults_cht),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, &rapl_defaults_tng),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_MID,	&rapl_defaults_ann),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT_D,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT_L,	&rapl_defaults_core),
+
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&rapl_defaults_hsw_server),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&rapl_defaults_hsw_server),
 
 	X86_MATCH_VENDOR_FAM(AMD, 0x17, &rapl_defaults_amd),
 	X86_MATCH_VENDOR_FAM(AMD, 0x19, &rapl_defaults_amd),
-- 
2.44.0

