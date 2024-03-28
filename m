Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA29130E5D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643317; cv=none; b=a3bpk8ZqnZObEjdzi3hZZ6578Vuv+sbRaheOhmD3EW8fRstkSkufLza8csVnZs3s7r1Y7YoLAWboxv5yzULyJDm56UaLFob1VRK71T76LqsYWIqHD2U2aAhmsg/YGmya9T3wSoEcuNUBbzO+dEZ/m2MIHHHZjIPh9TAGHKUhiXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643317; c=relaxed/simple;
	bh=CceJ/j8xrbqthafygXXbUhNMAfGcBw2sSvWtcFeTgUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kae+mrL/vlEMfmd7liEqKAflKp1bqZ/DA0Ii4pSRMyTTY52bEkdOxKHjqN500bjN8GqJ0Rs/fHmx1zozn5RETTT9YVaNiHHfmi9cjEPDUoHkP9sQN+V4CmoZT+4Otn/UJkw5ZaIq9FlTDO34+jxNCQwTYYb/JDzwewye3EuQLhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GmjnLI84; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GmjnLI84"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643313; x=1743179313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CceJ/j8xrbqthafygXXbUhNMAfGcBw2sSvWtcFeTgUs=;
  b=GmjnLI84kW032QIzXgqeFDFnFL92OwN+Exs6DuG6LQcUtrPjLJgEfCb/
   mgJYJqkBQzlLZO2L/eNuf7LhZZVIEs+TEXfzkChY14GuD10ele+JR4Ma6
   Bdvd+VlgvWmNkffOmNR2YJgp2p9XkytIKbHKGyies/7gpbwnsWEVs+z8M
   CLKazOaJ9mrYZRr/YaTlCRjAMsCNpXmFe43xJHLzHBvuOPT0FS4JwO1yB
   uKgdx6Y2xGJw/uRYhyOBvo9PxeB/Hc6tQbRMsAgyABFxRkhauXlIiTkgC
   sqPIVIkCZ2e0Q7o2DMkk0gx1Fwx7Ul9Nu6LBNAfH/0eUT0C0fCrqFvPk1
   w==;
X-CSE-ConnectionGUID: C5Ci3ZgdSCmDM6R8Pm4PeA==
X-CSE-MsgGUID: XLLBORepTCSESwueCTCZHw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294774"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294774"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726100"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 46/74] x86/cpu/vfm: Update drivers/idle/intel_idle.c
Date: Thu, 28 Mar 2024 09:27:40 -0700
Message-ID: <20240328162820.242778-46-tony.luck@intel.com>
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
 drivers/idle/intel_idle.c | 116 +++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index e486027f8b07..9aab7abc2ae9 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1494,53 +1494,53 @@ static const struct idle_cpu idle_cpu_srf __initconst = {
 };
 
 static const struct x86_cpu_id intel_idle_ids[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EP,		&idle_cpu_nhx),
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM,		&idle_cpu_nehalem),
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_G,		&idle_cpu_nehalem),
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE,		&idle_cpu_nehalem),
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE_EP,		&idle_cpu_nhx),
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EX,		&idle_cpu_nhx),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_BONNELL,	&idle_cpu_atom),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_BONNELL_MID,	&idle_cpu_lincroft),
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE_EX,		&idle_cpu_nhx),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE,		&idle_cpu_snb),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE_X,	&idle_cpu_snx),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SALTWELL,	&idle_cpu_atom),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	&idle_cpu_byt),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID,	&idle_cpu_tangier),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&idle_cpu_cht),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE,		&idle_cpu_ivb),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X,		&idle_cpu_ivt),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL,		&idle_cpu_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X,		&idle_cpu_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_L,		&idle_cpu_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_G,		&idle_cpu_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_D,	&idle_cpu_avn),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL,		&idle_cpu_bdw),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_G,		&idle_cpu_bdw),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,		&idle_cpu_bdx),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,		&idle_cpu_bdx),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		&idle_cpu_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		&idle_cpu_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		&idle_cpu_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		&idle_cpu_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,		&idle_cpu_skx),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&idle_cpu_icx),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&idle_cpu_icx),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&idle_cpu_adl),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&idle_cpu_adl_l),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&idle_cpu_mtl_l),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT,	&idle_cpu_gmt),
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&idle_cpu_spr),
-	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&idle_cpu_spr),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,	&idle_cpu_knl),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,	&idle_cpu_knl),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&idle_cpu_bxt),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&idle_cpu_bxt),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_D,	&idle_cpu_dnv),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_D,	&idle_cpu_snr),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT,	&idle_cpu_grr),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	&idle_cpu_srf),
+	X86_MATCH_VFM(INTEL_NEHALEM_EP,		&idle_cpu_nhx),
+	X86_MATCH_VFM(INTEL_NEHALEM,		&idle_cpu_nehalem),
+	X86_MATCH_VFM(INTEL_NEHALEM_G,		&idle_cpu_nehalem),
+	X86_MATCH_VFM(INTEL_WESTMERE,		&idle_cpu_nehalem),
+	X86_MATCH_VFM(INTEL_WESTMERE_EP,	&idle_cpu_nhx),
+	X86_MATCH_VFM(INTEL_NEHALEM_EX,		&idle_cpu_nhx),
+	X86_MATCH_VFM(INTEL_ATOM_BONNELL,	&idle_cpu_atom),
+	X86_MATCH_VFM(INTEL_ATOM_BONNELL_MID,	&idle_cpu_lincroft),
+	X86_MATCH_VFM(INTEL_WESTMERE_EX,	&idle_cpu_nhx),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE,	&idle_cpu_snb),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE_X,	&idle_cpu_snx),
+	X86_MATCH_VFM(INTEL_ATOM_SALTWELL,	&idle_cpu_atom),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	&idle_cpu_byt),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, &idle_cpu_tangier),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	&idle_cpu_cht),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE,		&idle_cpu_ivb),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE_X,	&idle_cpu_ivt),
+	X86_MATCH_VFM(INTEL_HASWELL,		&idle_cpu_hsw),
+	X86_MATCH_VFM(INTEL_HASWELL_X,		&idle_cpu_hsx),
+	X86_MATCH_VFM(INTEL_HASWELL_L,		&idle_cpu_hsw),
+	X86_MATCH_VFM(INTEL_HASWELL_G,		&idle_cpu_hsw),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_D,	&idle_cpu_avn),
+	X86_MATCH_VFM(INTEL_BROADWELL,		&idle_cpu_bdw),
+	X86_MATCH_VFM(INTEL_BROADWELL_G,	&idle_cpu_bdw),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	&idle_cpu_bdx),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	&idle_cpu_bdx),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		&idle_cpu_skl),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		&idle_cpu_skl),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		&idle_cpu_skl),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		&idle_cpu_skl),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,		&idle_cpu_skx),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,		&idle_cpu_icx),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,		&idle_cpu_icx),
+	X86_MATCH_VFM(INTEL_ALDERLAKE,		&idle_cpu_adl),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	&idle_cpu_adl_l),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&idle_cpu_mtl_l),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	&idle_cpu_gmt),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	&idle_cpu_spr),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	&idle_cpu_spr),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&idle_cpu_knl),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&idle_cpu_knl),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&idle_cpu_bxt),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&idle_cpu_bxt),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&idle_cpu_dnv),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT_D,	&idle_cpu_snr),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	&idle_cpu_grr),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	&idle_cpu_srf),
 	{}
 };
 
@@ -1990,27 +1990,27 @@ static void __init intel_idle_init_cstates_icpu(struct cpuidle_driver *drv)
 {
 	int cstate;
 
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_IVYBRIDGE_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_IVYBRIDGE_X:
 		ivt_idle_state_table_update();
 		break;
-	case INTEL_FAM6_ATOM_GOLDMONT:
-	case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
+	case INTEL_ATOM_GOLDMONT:
+	case INTEL_ATOM_GOLDMONT_PLUS:
 		bxt_idle_state_table_update();
 		break;
-	case INTEL_FAM6_SKYLAKE:
+	case INTEL_SKYLAKE:
 		sklh_idle_state_table_update();
 		break;
-	case INTEL_FAM6_SKYLAKE_X:
+	case INTEL_SKYLAKE_X:
 		skx_idle_state_table_update();
 		break;
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:
-	case INTEL_FAM6_EMERALDRAPIDS_X:
+	case INTEL_SAPPHIRERAPIDS_X:
+	case INTEL_EMERALDRAPIDS_X:
 		spr_idle_state_table_update();
 		break;
-	case INTEL_FAM6_ALDERLAKE:
-	case INTEL_FAM6_ALDERLAKE_L:
-	case INTEL_FAM6_ATOM_GRACEMONT:
+	case INTEL_ALDERLAKE:
+	case INTEL_ALDERLAKE_L:
+	case INTEL_ATOM_GRACEMONT:
 		adl_idle_state_table_update();
 		break;
 	}
-- 
2.44.0

