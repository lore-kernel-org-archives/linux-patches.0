Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F9130E5D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643306; cv=none; b=G5uWAe3TMdl4pDZgzGY/cyJbu1w3S98SAIHsZ8t5WwCR0x8wna8I0AtSeqqaifly/fw5lu+kujQwvqw6PJFhsp0Xpfq0rw2JlhpaPA5QZWYKwPNVIZknEsNrbQ+kLdFDT2rknUtXL74jB9/ZaNCfI1sB/CtZHkMiw7UDkjApT9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643306; c=relaxed/simple;
	bh=t7s0Jb1VMCyYA/ZHcEyg4TQxW5ylNCaGqSLvy2930us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkKak4CRgaLrcKC+lfLupe4oJ83+IWT1Vo/UySPrt4bqBcHyRA2Miko5koBit2ctcRAA4gJy8wCjxozgF8m97304PSz9b5iCCjsdjAXtaalzSefl0M4IR/rY1sVTbnH13Qkc6ZsOZOBXe+gYY04/jFtDXdCE/PaJGxNoo0dbpcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IJuZYdrN; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IJuZYdrN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643303; x=1743179303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t7s0Jb1VMCyYA/ZHcEyg4TQxW5ylNCaGqSLvy2930us=;
  b=IJuZYdrNl33kTKk0EhSJTqSmN57+3DDn4Yq2DpByoYzSQBceZ6pghzEY
   sxipLMnSVRXmwVf/YTxTWYwdSSIRdMMc4zGbYvNXEPKUIc/pXe//R2Frc
   wNv6mmxdcIddZMNrp+N6cYBrhRkUl3h/EnfSMy/BW0Po7FKmTem+OfTQ4
   +Z9RqJcbT1CGeD1Ztk4RRZoFETDclTYUqjxN4pIPb853LWr4YIXTpr1Q+
   Rk9RtaIE3bVKICw9aWFSy3Snbr1C5CjAGpiQRo2v23s7rSH+So4C6VcSy
   iYCrz1lYANR13O9IauAQmyHLMPuQF5ruKNWE4P2qLYfh8g1mur6Tc4vvP
   g==;
X-CSE-ConnectionGUID: a7LqgvfAQTaJ7UvVNbTh2A==
X-CSE-MsgGUID: /sRCSkWkQlmPdbmBFDAMyw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294724"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294724"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725960"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 06/74] x86/cpu/vfm: Update arch/x86/events/intel/cstate.c
Date: Thu, 28 Mar 2024 09:27:00 -0700
Message-ID: <20240328162820.242778-6-tony.luck@intel.com>
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
 arch/x86/events/intel/cstate.c | 144 ++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 72 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index 326c8cd5aa2d..54eb142810fb 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -696,78 +696,78 @@ static const struct cstate_model srf_cstates __initconst = {
 
 
 static const struct x86_cpu_id intel_cstates_match[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM,		&nhm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EP,		&nhm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EX,		&nhm_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE,		&nhm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE_EP,		&nhm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(WESTMERE_EX,		&nhm_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE_X,	&snb_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X,		&snb_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_G,		&snb_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_L,		&hswult_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	&slm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_D,	&slm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&slm_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_G,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,		&snb_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		&snb_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,		&snb_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		&hswult_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		&hswult_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&hswult_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&hswult_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(CANNONLAKE_L,	&cnl_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,	&knl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,	&knl_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&glm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_D,	&glm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&glm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_D,	&glm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT,	&glm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_L,	&glm_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT,	&adl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	&srf_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT,	&grr_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,		&icl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE,		&icl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&icx_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&icx_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&icx_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&icx_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	&icx_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_D,	&icx_cstates),
-
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&icl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&icl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ROCKETLAKE,		&icl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&adl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&adl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&adl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&adl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,		&adl_cstates),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&adl_cstates),
+	X86_MATCH_VFM(INTEL_NEHALEM,		&nhm_cstates),
+	X86_MATCH_VFM(INTEL_NEHALEM_EP,		&nhm_cstates),
+	X86_MATCH_VFM(INTEL_NEHALEM_EX,		&nhm_cstates),
+
+	X86_MATCH_VFM(INTEL_WESTMERE,		&nhm_cstates),
+	X86_MATCH_VFM(INTEL_WESTMERE_EP,	&nhm_cstates),
+	X86_MATCH_VFM(INTEL_WESTMERE_EX,	&nhm_cstates),
+
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE,	&snb_cstates),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE_X,	&snb_cstates),
+
+	X86_MATCH_VFM(INTEL_IVYBRIDGE,		&snb_cstates),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE_X,	&snb_cstates),
+
+	X86_MATCH_VFM(INTEL_HASWELL,		&snb_cstates),
+	X86_MATCH_VFM(INTEL_HASWELL_X,		&snb_cstates),
+	X86_MATCH_VFM(INTEL_HASWELL_G,		&snb_cstates),
+
+	X86_MATCH_VFM(INTEL_HASWELL_L,		&hswult_cstates),
+
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	&slm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_D,	&slm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	&slm_cstates),
+
+	X86_MATCH_VFM(INTEL_BROADWELL,		&snb_cstates),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	&snb_cstates),
+	X86_MATCH_VFM(INTEL_BROADWELL_G,	&snb_cstates),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	&snb_cstates),
+
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		&snb_cstates),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		&snb_cstates),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,		&snb_cstates),
+
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		&hswult_cstates),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		&hswult_cstates),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L,	&hswult_cstates),
+	X86_MATCH_VFM(INTEL_COMETLAKE,		&hswult_cstates),
+
+	X86_MATCH_VFM(INTEL_CANNONLAKE_L,	&cnl_cstates),
+
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&knl_cstates),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&knl_cstates),
+
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&glm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&glm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&glm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT_D,	&glm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT,	&glm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT_L,	&glm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	&adl_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	&srf_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	&grr_cstates),
+
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		&icl_cstates),
+	X86_MATCH_VFM(INTEL_ICELAKE,		&icl_cstates),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,		&icx_cstates),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,		&icx_cstates),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	&icx_cstates),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	&icx_cstates),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	&icx_cstates),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_D,	&icx_cstates),
+
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	&icl_cstates),
+	X86_MATCH_VFM(INTEL_TIGERLAKE,		&icl_cstates),
+	X86_MATCH_VFM(INTEL_ROCKETLAKE,		&icl_cstates),
+	X86_MATCH_VFM(INTEL_ALDERLAKE,		&adl_cstates),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	&adl_cstates),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE,		&adl_cstates),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,	&adl_cstates),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,	&adl_cstates),
+	X86_MATCH_VFM(INTEL_METEORLAKE,		&adl_cstates),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&adl_cstates),
 	{ },
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_cstates_match);
-- 
2.44.0

