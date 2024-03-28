Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6002D792
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643307; cv=none; b=a+kazDyIHBx1cDMYhNzdQZPZ+pHY5Kx39dfaGcow2XYiwL4C6LYokYmpB5ljx7HsyBwOfoOCkZsTquPCx7ntJ3mtTCUs2ExaY171ZqRwvb07pA/kng8DngvSmEmnDDyUFeWwT2mB5qzdYms1i+VcCDc76BMpXCjR9K7W/298Qm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643307; c=relaxed/simple;
	bh=Zrqcnxorevl79WD5a/tmkln4E0tHA8stgjX1kIXjdB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etWybsbgDQ2UyRAPl8pwDx62yXWmZ+fjvx1tYMbwOWRR7zIQTSmN++pcTfSerAd04XeQ4VLZQAg1ZqKaWkojCMk5Xf25R0AbQ+nyw+gxRPzryK9sjmjl0tXZQwyxfbM2gBugaGieOzoAy52woa8f+NwKW77Ni8dYhRMGUnVH0e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=agvOLJCN; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="agvOLJCN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643304; x=1743179304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zrqcnxorevl79WD5a/tmkln4E0tHA8stgjX1kIXjdB8=;
  b=agvOLJCNU6CDoS0pIvIjxP/XFI2qQkk52KDn4SErd8+4RmdQqg9bASvo
   S/3XpIzEKvFnsUjwDhCJkYKI3dTOiH3UOSIHQ2lm9VwMUPk+lvuDMQ4sG
   6fZGXg+P25wMS99D4u92+8N3I7IEagwes3DJxAVfw2m0J+qH+2DRaYeRM
   MMZ/Jkmw/D8+FKA8DfFFVlqkdyb+3+kdNCqaTdLFDw3Y+gveKCdps7VGB
   tCXqA+jffRai+RwhGipxdUutL0V4g6rOf/5GmduU5437WJOXq7YK+lCfx
   UX8L7HMaXfk19FOGjE4brHaz1lcFfvUAdWyfU0mF2qGm/8Fy/PADIJ7HH
   w==;
X-CSE-ConnectionGUID: siN7+CC6Q1KLGXD68kw8eA==
X-CSE-MsgGUID: Xk25yeCKSx2PrbtvU6iBgw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294730"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294730"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725972"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 09/74] x86/cpu/vfm: Update arch/x86/events/intel/uncore.c
Date: Thu, 28 Mar 2024 09:27:03 -0700
Message-ID: <20240328162820.242778-9-tony.luck@intel.com>
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
 arch/x86/events/intel/uncore.c | 100 ++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 258e2cdf28fa..419c517b8594 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1829,56 +1829,56 @@ static const struct intel_uncore_init_fun generic_uncore_init __initconst = {
 };
 
 static const struct x86_cpu_id intel_uncore_match[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EP,		&nhm_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM,		&nhm_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE,		&nhm_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE_EP,		&nhm_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE,		&snb_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE,		&ivb_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL,		&hsw_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_L,		&hsw_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_G,		&hsw_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL,		&bdw_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_G,		&bdw_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE_X,	&snbep_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EX,		&nhmex_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE_EX,		&nhmex_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X,		&ivbep_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X,		&hswep_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,		&bdx_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,		&bdx_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,	&knl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,	&knl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		&skl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		&skl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,		&skx_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		&skl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		&skl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&skl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&skl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,		&icl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_NNPI,	&icl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE,		&icl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&icx_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&icx_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&tgl_l_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&tgl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ROCKETLAKE,		&rkl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&adl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&adl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&adl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&adl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,		&mtl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&mtl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&spr_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&spr_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	&gnr_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_D,	&gnr_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_D,	&snr_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT,	&adl_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	&gnr_uncore_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT,	&gnr_uncore_init),
+	X86_MATCH_VFM(INTEL_NEHALEM_EP,		&nhm_uncore_init),
+	X86_MATCH_VFM(INTEL_NEHALEM,		&nhm_uncore_init),
+	X86_MATCH_VFM(INTEL_WESTMERE,		&nhm_uncore_init),
+	X86_MATCH_VFM(INTEL_WESTMERE_EP,	&nhm_uncore_init),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE,	&snb_uncore_init),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE,		&ivb_uncore_init),
+	X86_MATCH_VFM(INTEL_HASWELL,		&hsw_uncore_init),
+	X86_MATCH_VFM(INTEL_HASWELL_L,		&hsw_uncore_init),
+	X86_MATCH_VFM(INTEL_HASWELL_G,		&hsw_uncore_init),
+	X86_MATCH_VFM(INTEL_BROADWELL,		&bdw_uncore_init),
+	X86_MATCH_VFM(INTEL_BROADWELL_G,	&bdw_uncore_init),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE_X,	&snbep_uncore_init),
+	X86_MATCH_VFM(INTEL_NEHALEM_EX,		&nhmex_uncore_init),
+	X86_MATCH_VFM(INTEL_WESTMERE_EX,	&nhmex_uncore_init),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE_X,	&ivbep_uncore_init),
+	X86_MATCH_VFM(INTEL_HASWELL_X,		&hswep_uncore_init),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	&bdx_uncore_init),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	&bdx_uncore_init),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&knl_uncore_init),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&knl_uncore_init),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		&skl_uncore_init),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		&skl_uncore_init),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,		&skx_uncore_init),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		&skl_uncore_init),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		&skl_uncore_init),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L,	&skl_uncore_init),
+	X86_MATCH_VFM(INTEL_COMETLAKE,		&skl_uncore_init),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		&icl_uncore_init),
+	X86_MATCH_VFM(INTEL_ICELAKE_NNPI,	&icl_uncore_init),
+	X86_MATCH_VFM(INTEL_ICELAKE,		&icl_uncore_init),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,		&icx_uncore_init),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,		&icx_uncore_init),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	&tgl_l_uncore_init),
+	X86_MATCH_VFM(INTEL_TIGERLAKE,		&tgl_uncore_init),
+	X86_MATCH_VFM(INTEL_ROCKETLAKE,		&rkl_uncore_init),
+	X86_MATCH_VFM(INTEL_ALDERLAKE,		&adl_uncore_init),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	&adl_uncore_init),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE,		&adl_uncore_init),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,	&adl_uncore_init),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,	&adl_uncore_init),
+	X86_MATCH_VFM(INTEL_METEORLAKE,		&mtl_uncore_init),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&mtl_uncore_init),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	&spr_uncore_init),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	&spr_uncore_init),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	&gnr_uncore_init),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_D,	&gnr_uncore_init),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT_D,	&snr_uncore_init),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	&adl_uncore_init),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	&gnr_uncore_init),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	&gnr_uncore_init),
 	{},
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_uncore_match);
-- 
2.44.0

