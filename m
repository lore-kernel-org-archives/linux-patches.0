Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F276CDC4
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302404; cv=none; b=pNcXxxtWQQ3ska1j8TbFFyg/NzOLVp6m3fIPrGGFSpmh2aOLA9ZH1Lv4efwcVK4lT5alUt1lsucERfbQgScP7W2X/V51WTgR475mo8UISB8QpCFdoOkC3U+FKag4e6osyM8gPg+8Bo9kce7rVJsXS0D5TlQAXoCAJBUW/7WB+LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302404; c=relaxed/simple;
	bh=Zrqcnxorevl79WD5a/tmkln4E0tHA8stgjX1kIXjdB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mC8zowQdAJ5o2BZ0Dx7jOKfzcSvMG851QpRyLVKu5buAeCpq0k/BiGJAMPMaVAk2GUUExcq5mnXTyeoPW/RN3yzxG+j0JIJDjnMh13aMeUmc8ZlE3qgaw6Fa7ig6Do1tNIKA++0TCXTXthf+P7CYcqxqWBNLQpmz+IG9vlFUdu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzVVb2U3; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzVVb2U3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302402; x=1744838402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zrqcnxorevl79WD5a/tmkln4E0tHA8stgjX1kIXjdB8=;
  b=bzVVb2U3h390RcW298tinpQO7IF8SBK4GX5p97lwTZMHgtpF7xkkceNb
   vbeDmjPCSz4oPTY/yS7td/yZ/5lpPKK1opuRelWUHQrCkweabKATGIXvv
   9lZQoSni4FXUPojBJtdvGRlh0w5ENr24IjF7bE44nIJmoI7q5kQmkfBnR
   5rV87mdqStwWarz1dg5ZUdhmMl5P42O0Fo+S+0FEaeqQGaa8kzaCVMx+U
   vg+g27Q5Yf5ks7N+Bul47O1Y55iO4PDWXIjaTidz71ROPrC4QysjZ0Joz
   /VnFs+6sizWleR2lcVczd8IRkRlMjsW/jc2LD+psvX6/to9qV2uFoG4Fd
   Q==;
X-CSE-ConnectionGUID: oi5DpYfhQ+OC1vnSo6lDPA==
X-CSE-MsgGUID: RGReQhHeRhyJNuF7PevSZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914707"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914707"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:58 -0700
X-CSE-ConnectionGUID: 7tcl3dorRkG1Gg7XGMzdGw==
X-CSE-MsgGUID: GzJMb5BlSE+AOxTT7HmR8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871900"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 09/74] x86/cpu/vfm: Update arch/x86/events/intel/uncore.c
Date: Tue, 16 Apr 2024 14:19:11 -0700
Message-ID: <20240416211941.9369-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416211941.9369-1-tony.luck@intel.com>
References: <20240416211941.9369-1-tony.luck@intel.com>
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

