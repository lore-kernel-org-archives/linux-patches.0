Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1414618E35F
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 17:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725384900; cv=none; b=bJd0CwuKQ/xksS48l1rtFGsiFfAPKBzLJaFECELfdr9YZTz02PtvVOx1pflJ5Dl6k1+BKl2uUmHY4NYbZIEDu2TucXGzXIBQAIxMecZUWRX2YrjKfxOdjtCVQ+xBuUEJA18eaqxH2F7HGLYhBn8oyykU7RJIcEm44qqWyzCaFY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725384900; c=relaxed/simple;
	bh=OppoUoa9VLSDb0gOUl1fd135LjvE4DmUbJuGCJnSfE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK2NEfy1EbrTDT5kMKqmXegWUcKKzz4KRCHL4TpKxJp5P0QJ7cXfkSLPyTbEcPu6gBCFEf2dIhMFmynrdaepUlMDoMEXzlBcMdermQdTG9DClXSCyCjsWY00WIJJPWOu5AjN3uDoQV+4eHddWkBO4UTIpb7S4esKiA+pZUIVfCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HYXAP7Wu; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HYXAP7Wu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725384900; x=1756920900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OppoUoa9VLSDb0gOUl1fd135LjvE4DmUbJuGCJnSfE4=;
  b=HYXAP7Wu5zHpc3QYp/z+iCcRy48eTUDpgHDZu+PQYvXLETZaIN4BsBm5
   RjekgIh+eYl4kWnEDbzdnCOTckcgcdJhntbItHHtYQPhAYHElcmgiQ0B9
   7qkkIbnLmSYMTTCodpxaipNXcD85NS+FcEXGknpdUSbzzMYwhZvQU6zZa
   Z4uV/NeZvcYhBCC458KMnXRWYGMpqvFHvkjouXLnR22J5w4YKIh6vqd5X
   SVJTnxq8pNh0qMYIiC9FoQf7YcBelWou0nv1dEoIwFXwc0/uAo+1FF2kT
   UFZ+z7Vb3Q/wZ4OLx9SFadcvK1WGb7i/4L5zPKU7vCfmD+ePNL5GCWb9v
   w==;
X-CSE-ConnectionGUID: i2b+Gnc8TeeleeGIJSnnow==
X-CSE-MsgGUID: +7ZEUkIdRWGpL9L69A7E4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="46528550"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="46528550"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 10:34:56 -0700
X-CSE-ConnectionGUID: lShKJROJRmeSMaGSnCn35g==
X-CSE-MsgGUID: 4TjnwwVxRA6YhnZLKm2vOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="65715880"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 10:34:55 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 3/3] x86/cpu/vfm: Delete all the *_FAM6_ CPU #defines
Date: Tue,  3 Sep 2024 10:34:43 -0700
Message-ID: <20240903173443.7962-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240903173443.7962-1-tony.luck@intel.com>
References: <20240903173443.7962-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All code has been converted to use the vendor/family/model versions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 85 +----------------------------
 1 file changed, 2 insertions(+), 83 deletions(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 27bdf3b55c6f..44949f972826 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -10,7 +10,7 @@
  * that group keep the CPUID for the variants sorted by model number.
  *
  * The defined symbol names have the following form:
- *	INTEL_FAM6{OPTFAMILY}_{MICROARCH}{OPTDIFF}
+ *	INTEL_{OPTFAMILY}_{MICROARCH}{OPTDIFF}
  * where:
  * OPTFAMILY	Describes the family of CPUs that this belongs to. Default
  *		is assumed to be "_CORE" (and should be omitted). Other values
@@ -42,217 +42,136 @@
 
 #define IFM(_fam, _model)	VFM_MAKE(X86_VENDOR_INTEL, _fam, _model)
 
-/* Wildcard match for FAM6 so X86_MATCH_INTEL_FAM6_MODEL(ANY) works */
-#define INTEL_FAM6_ANY			X86_MODEL_ANY
-/* Wildcard match for FAM6 so X86_MATCH_VFM(ANY) works */
+/* Wildcard match so X86_MATCH_VFM(ANY) works */
 #define INTEL_ANY			IFM(X86_FAMILY_ANY, X86_MODEL_ANY)
 
 #define INTEL_PENTIUM_PRO		IFM(6, 0x01)
 
-#define INTEL_FAM6_CORE_YONAH		0x0E
 #define INTEL_CORE_YONAH		IFM(6, 0x0E)
 
-#define INTEL_FAM6_CORE2_MEROM		0x0F
 #define INTEL_CORE2_MEROM		IFM(6, 0x0F)
-#define INTEL_FAM6_CORE2_MEROM_L	0x16
 #define INTEL_CORE2_MEROM_L		IFM(6, 0x16)
-#define INTEL_FAM6_CORE2_PENRYN		0x17
 #define INTEL_CORE2_PENRYN		IFM(6, 0x17)
-#define INTEL_FAM6_CORE2_DUNNINGTON	0x1D
 #define INTEL_CORE2_DUNNINGTON		IFM(6, 0x1D)
 
-#define INTEL_FAM6_NEHALEM		0x1E
 #define INTEL_NEHALEM			IFM(6, 0x1E)
-#define INTEL_FAM6_NEHALEM_G		0x1F /* Auburndale / Havendale */
 #define INTEL_NEHALEM_G			IFM(6, 0x1F) /* Auburndale / Havendale */
-#define INTEL_FAM6_NEHALEM_EP		0x1A
 #define INTEL_NEHALEM_EP		IFM(6, 0x1A)
-#define INTEL_FAM6_NEHALEM_EX		0x2E
 #define INTEL_NEHALEM_EX		IFM(6, 0x2E)
 
-#define INTEL_FAM6_WESTMERE		0x25
 #define INTEL_WESTMERE			IFM(6, 0x25)
-#define INTEL_FAM6_WESTMERE_EP		0x2C
 #define INTEL_WESTMERE_EP		IFM(6, 0x2C)
-#define INTEL_FAM6_WESTMERE_EX		0x2F
 #define INTEL_WESTMERE_EX		IFM(6, 0x2F)
 
-#define INTEL_FAM6_SANDYBRIDGE		0x2A
 #define INTEL_SANDYBRIDGE		IFM(6, 0x2A)
-#define INTEL_FAM6_SANDYBRIDGE_X	0x2D
 #define INTEL_SANDYBRIDGE_X		IFM(6, 0x2D)
-#define INTEL_FAM6_IVYBRIDGE		0x3A
 #define INTEL_IVYBRIDGE			IFM(6, 0x3A)
-#define INTEL_FAM6_IVYBRIDGE_X		0x3E
 #define INTEL_IVYBRIDGE_X		IFM(6, 0x3E)
 
-#define INTEL_FAM6_HASWELL		0x3C
 #define INTEL_HASWELL			IFM(6, 0x3C)
-#define INTEL_FAM6_HASWELL_X		0x3F
 #define INTEL_HASWELL_X			IFM(6, 0x3F)
-#define INTEL_FAM6_HASWELL_L		0x45
 #define INTEL_HASWELL_L			IFM(6, 0x45)
-#define INTEL_FAM6_HASWELL_G		0x46
 #define INTEL_HASWELL_G			IFM(6, 0x46)
 
-#define INTEL_FAM6_BROADWELL		0x3D
 #define INTEL_BROADWELL			IFM(6, 0x3D)
-#define INTEL_FAM6_BROADWELL_G		0x47
 #define INTEL_BROADWELL_G		IFM(6, 0x47)
-#define INTEL_FAM6_BROADWELL_X		0x4F
 #define INTEL_BROADWELL_X		IFM(6, 0x4F)
-#define INTEL_FAM6_BROADWELL_D		0x56
 #define INTEL_BROADWELL_D		IFM(6, 0x56)
 
-#define INTEL_FAM6_SKYLAKE_L		0x4E	/* Sky Lake             */
 #define INTEL_SKYLAKE_L			IFM(6, 0x4E) /* Sky Lake */
-#define INTEL_FAM6_SKYLAKE		0x5E	/* Sky Lake             */
 #define INTEL_SKYLAKE			IFM(6, 0x5E) /* Sky Lake */
-#define INTEL_FAM6_SKYLAKE_X		0x55	/* Sky Lake             */
 #define INTEL_SKYLAKE_X			IFM(6, 0x55) /* Sky Lake */
 /*                 CASCADELAKE_X	0x55	   Sky Lake -- s: 7     */
 /*                 COOPERLAKE_X		0x55	   Sky Lake -- s: 11    */
 
-#define INTEL_FAM6_KABYLAKE_L		0x8E	/* Sky Lake             */
 #define INTEL_KABYLAKE_L		IFM(6, 0x8E) /* Sky Lake */
 /*                 AMBERLAKE_L		0x8E	   Sky Lake -- s: 9     */
 /*                 COFFEELAKE_L		0x8E	   Sky Lake -- s: 10    */
 /*                 WHISKEYLAKE_L	0x8E       Sky Lake -- s: 11,12 */
 
-#define INTEL_FAM6_KABYLAKE		0x9E	/* Sky Lake             */
 #define INTEL_KABYLAKE			IFM(6, 0x9E) /* Sky Lake */
 /*                 COFFEELAKE		0x9E	   Sky Lake -- s: 10-13 */
 
-#define INTEL_FAM6_COMETLAKE		0xA5	/* Sky Lake             */
 #define INTEL_COMETLAKE			IFM(6, 0xA5) /* Sky Lake */
-#define INTEL_FAM6_COMETLAKE_L		0xA6	/* Sky Lake             */
 #define INTEL_COMETLAKE_L		IFM(6, 0xA6) /* Sky Lake */
 
-#define INTEL_FAM6_CANNONLAKE_L		0x66	/* Palm Cove */
 #define INTEL_CANNONLAKE_L		IFM(6, 0x66) /* Palm Cove */
 
-#define INTEL_FAM6_ICELAKE_X		0x6A	/* Sunny Cove */
 #define INTEL_ICELAKE_X			IFM(6, 0x6A) /* Sunny Cove */
-#define INTEL_FAM6_ICELAKE_D		0x6C	/* Sunny Cove */
 #define INTEL_ICELAKE_D			IFM(6, 0x6C) /* Sunny Cove */
-#define INTEL_FAM6_ICELAKE		0x7D	/* Sunny Cove */
 #define INTEL_ICELAKE			IFM(6, 0x7D) /* Sunny Cove */
-#define INTEL_FAM6_ICELAKE_L		0x7E	/* Sunny Cove */
 #define INTEL_ICELAKE_L			IFM(6, 0x7E) /* Sunny Cove */
-#define INTEL_FAM6_ICELAKE_NNPI		0x9D	/* Sunny Cove */
 #define INTEL_ICELAKE_NNPI		IFM(6, 0x9D) /* Sunny Cove */
 
-#define INTEL_FAM6_ROCKETLAKE		0xA7	/* Cypress Cove */
 #define INTEL_ROCKETLAKE		IFM(6, 0xA7) /* Cypress Cove */
 
-#define INTEL_FAM6_TIGERLAKE_L		0x8C	/* Willow Cove */
 #define INTEL_TIGERLAKE_L		IFM(6, 0x8C) /* Willow Cove */
-#define INTEL_FAM6_TIGERLAKE		0x8D	/* Willow Cove */
 #define INTEL_TIGERLAKE			IFM(6, 0x8D) /* Willow Cove */
 
-#define INTEL_FAM6_SAPPHIRERAPIDS_X	0x8F	/* Golden Cove */
 #define INTEL_SAPPHIRERAPIDS_X		IFM(6, 0x8F) /* Golden Cove */
 
-#define INTEL_FAM6_EMERALDRAPIDS_X	0xCF
 #define INTEL_EMERALDRAPIDS_X		IFM(6, 0xCF)
 
-#define INTEL_FAM6_GRANITERAPIDS_X	0xAD
 #define INTEL_GRANITERAPIDS_X		IFM(6, 0xAD)
-#define INTEL_FAM6_GRANITERAPIDS_D	0xAE
 #define INTEL_GRANITERAPIDS_D		IFM(6, 0xAE)
 
 /* "Hybrid" Processors (P-Core/E-Core) */
 
-#define INTEL_FAM6_LAKEFIELD		0x8A	/* Sunny Cove / Tremont */
 #define INTEL_LAKEFIELD			IFM(6, 0x8A) /* Sunny Cove / Tremont */
 
-#define INTEL_FAM6_ALDERLAKE		0x97	/* Golden Cove / Gracemont */
 #define INTEL_ALDERLAKE			IFM(6, 0x97) /* Golden Cove / Gracemont */
-#define INTEL_FAM6_ALDERLAKE_L		0x9A	/* Golden Cove / Gracemont */
 #define INTEL_ALDERLAKE_L		IFM(6, 0x9A) /* Golden Cove / Gracemont */
 
-#define INTEL_FAM6_RAPTORLAKE		0xB7	/* Raptor Cove / Enhanced Gracemont */
 #define INTEL_RAPTORLAKE		IFM(6, 0xB7) /* Raptor Cove / Enhanced Gracemont */
-#define INTEL_FAM6_RAPTORLAKE_P		0xBA
 #define INTEL_RAPTORLAKE_P		IFM(6, 0xBA)
-#define INTEL_FAM6_RAPTORLAKE_S		0xBF
 #define INTEL_RAPTORLAKE_S		IFM(6, 0xBF)
 
-#define INTEL_FAM6_METEORLAKE		0xAC
 #define INTEL_METEORLAKE		IFM(6, 0xAC)
-#define INTEL_FAM6_METEORLAKE_L		0xAA
 #define INTEL_METEORLAKE_L		IFM(6, 0xAA)
 
-#define INTEL_FAM6_ARROWLAKE_H		0xC5
 #define INTEL_ARROWLAKE_H		IFM(6, 0xC5)
-#define INTEL_FAM6_ARROWLAKE		0xC6
 #define INTEL_ARROWLAKE			IFM(6, 0xC6)
-#define INTEL_FAM6_ARROWLAKE_U		0xB5
 #define INTEL_ARROWLAKE_U		IFM(6, 0xB5)
 
-#define INTEL_FAM6_LUNARLAKE_M		0xBD
 #define INTEL_LUNARLAKE_M		IFM(6, 0xBD)
 
 /* "Small Core" Processors (Atom/E-Core) */
 
-#define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
 #define INTEL_ATOM_BONNELL		IFM(6, 0x1C) /* Diamondville, Pineview */
-#define INTEL_FAM6_ATOM_BONNELL_MID	0x26 /* Silverthorne, Lincroft */
 #define INTEL_ATOM_BONNELL_MID		IFM(6, 0x26) /* Silverthorne, Lincroft */
 
-#define INTEL_FAM6_ATOM_SALTWELL	0x36 /* Cedarview */
 #define INTEL_ATOM_SALTWELL		IFM(6, 0x36) /* Cedarview */
-#define INTEL_FAM6_ATOM_SALTWELL_MID	0x27 /* Penwell */
 #define INTEL_ATOM_SALTWELL_MID		IFM(6, 0x27) /* Penwell */
-#define INTEL_FAM6_ATOM_SALTWELL_TABLET	0x35 /* Cloverview */
 #define INTEL_ATOM_SALTWELL_TABLET	IFM(6, 0x35) /* Cloverview */
 
-#define INTEL_FAM6_ATOM_SILVERMONT	0x37 /* Bay Trail, Valleyview */
 #define INTEL_ATOM_SILVERMONT		IFM(6, 0x37) /* Bay Trail, Valleyview */
-#define INTEL_FAM6_ATOM_SILVERMONT_D	0x4D /* Avaton, Rangely */
 #define INTEL_ATOM_SILVERMONT_D		IFM(6, 0x4D) /* Avaton, Rangely */
-#define INTEL_FAM6_ATOM_SILVERMONT_MID	0x4A /* Merriefield */
 #define INTEL_ATOM_SILVERMONT_MID	IFM(6, 0x4A) /* Merriefield */
 
-#define INTEL_FAM6_ATOM_AIRMONT		0x4C /* Cherry Trail, Braswell */
 #define INTEL_ATOM_AIRMONT		IFM(6, 0x4C) /* Cherry Trail, Braswell */
-#define INTEL_FAM6_ATOM_AIRMONT_MID	0x5A /* Moorefield */
 #define INTEL_ATOM_AIRMONT_MID		IFM(6, 0x5A) /* Moorefield */
-#define INTEL_FAM6_ATOM_AIRMONT_NP	0x75 /* Lightning Mountain */
 #define INTEL_ATOM_AIRMONT_NP		IFM(6, 0x75) /* Lightning Mountain */
 
-#define INTEL_FAM6_ATOM_GOLDMONT	0x5C /* Apollo Lake */
 #define INTEL_ATOM_GOLDMONT		IFM(6, 0x5C) /* Apollo Lake */
-#define INTEL_FAM6_ATOM_GOLDMONT_D	0x5F /* Denverton */
 #define INTEL_ATOM_GOLDMONT_D		IFM(6, 0x5F) /* Denverton */
 
 /* Note: the micro-architecture is "Goldmont Plus" */
-#define INTEL_FAM6_ATOM_GOLDMONT_PLUS	0x7A /* Gemini Lake */
 #define INTEL_ATOM_GOLDMONT_PLUS	IFM(6, 0x7A) /* Gemini Lake */
 
-#define INTEL_FAM6_ATOM_TREMONT_D	0x86 /* Jacobsville */
 #define INTEL_ATOM_TREMONT_D		IFM(6, 0x86) /* Jacobsville */
-#define INTEL_FAM6_ATOM_TREMONT		0x96 /* Elkhart Lake */
 #define INTEL_ATOM_TREMONT		IFM(6, 0x96) /* Elkhart Lake */
-#define INTEL_FAM6_ATOM_TREMONT_L	0x9C /* Jasper Lake */
 #define INTEL_ATOM_TREMONT_L		IFM(6, 0x9C) /* Jasper Lake */
 
-#define INTEL_FAM6_ATOM_GRACEMONT	0xBE /* Alderlake N */
 #define INTEL_ATOM_GRACEMONT		IFM(6, 0xBE) /* Alderlake N */
 
-#define INTEL_FAM6_ATOM_CRESTMONT_X	0xAF /* Sierra Forest */
 #define INTEL_ATOM_CRESTMONT_X		IFM(6, 0xAF) /* Sierra Forest */
-#define INTEL_FAM6_ATOM_CRESTMONT	0xB6 /* Grand Ridge */
 #define INTEL_ATOM_CRESTMONT		IFM(6, 0xB6) /* Grand Ridge */
 
-#define INTEL_FAM6_ATOM_DARKMONT_X	0xDD /* Clearwater Forest */
 #define INTEL_ATOM_DARKMONT_X		IFM(6, 0xDD) /* Clearwater Forest */
 
 /* Xeon Phi */
 
-#define INTEL_FAM6_XEON_PHI_KNL		0x57 /* Knights Landing */
 #define INTEL_XEON_PHI_KNL		IFM(6, 0x57) /* Knights Landing */
-#define INTEL_FAM6_XEON_PHI_KNM		0x85 /* Knights Mill */
 #define INTEL_XEON_PHI_KNM		IFM(6, 0x85) /* Knights Mill */
 
 /* Family 5 */
-- 
2.46.0

