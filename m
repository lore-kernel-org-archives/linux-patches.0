Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8221813CABC
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245216; cv=none; b=Ix7t4CoaF5KNiEbuqeHuAA2Vg25YlSx7dDUCefq1JwnoGvaxqssFpsb63S2RfRfTIu6RjkfIJhYRGOOaF4o3Sa0Qk4aLOCGEgyguXZe4Z8RjFcTLo0GsiEp9mKV8yyy+vevk4FPAMQG4frSeJD8uqsZWtCcgDG3aYPbvIIu3hDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245216; c=relaxed/simple;
	bh=u+wLTku9+HuuC8Qmf1gTNgKbRO640SfS5D9xhRd1fEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa18kX9uLPLol/vXRtwA3X2Swo1pTewo79a1Zf2aGxSHoljhAoENKRwGQznR//mv+hRQ3oo0bfgDsB8xCVWzHrW1JGPSo/NtEls8Ap+BkVkdLsGy7nmNlpyUmd6xbGv90UHoEJYUa9baCBdIbYoYpSNg53qXcFvhDt3xisoq/gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=clPgfZHK; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="clPgfZHK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245215; x=1747781215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u+wLTku9+HuuC8Qmf1gTNgKbRO640SfS5D9xhRd1fEU=;
  b=clPgfZHKMjNLNp0zsIHcKR2LVohESBEC6enbSwyG6d9JdQsL0y3kmeWt
   6hpPpafmpXxLGDSyWKPeVMRmy0mEjLmAJ2a+EbwWJrGyf7qmdg6DwH6Mv
   3wthI0nkhOXRou6LJP04KwLfbFvt3DTCRYv8zyk0F7DvPRbNLeRHb7FTO
   sUUkK3VbA50hPql6jktWRJlsREva0pfyjkeK7F5AGjKSd1qginnn98c3q
   L5pDUdn+epW667uMYXLBfrojo9ccNZ6liJM6CjxuH01c/XzdnhZKQxbmv
   EAvUvXc0cA6BwEpWEqiC/1l+UC3tN2icDvPI1kmqfA97cOLfVxxxhvVaW
   w==;
X-CSE-ConnectionGUID: cHANGZmgS/alE8jVkzLYoA==
X-CSE-MsgGUID: KsyzLKDMT8+eU6tF9VsrgA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199981"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199981"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
X-CSE-ConnectionGUID: FEg2DnAGT/C5dx5m1Lgj0g==
X-CSE-MsgGUID: U1sw2U2DSTalky/lOkcuVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593515"
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
	patches@lists.linux.dev
Subject: [PATCH v6 43/49] perf/x86/rapl: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:14 -0700
Message-ID: <20240520224620.9480-44-tony.luck@intel.com>
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
---
 arch/x86/events/rapl.c | 90 +++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 46e673585560..edab61e3b053 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -764,51 +764,51 @@ static struct rapl_model model_amd_hygon = {
 };
 
 static const struct x86_cpu_id rapl_model_match[] __initconst = {
-	X86_MATCH_FEATURE(X86_FEATURE_RAPL,		&model_amd_hygon),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE,		&model_snb),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE_X,	&model_snbep),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE,		&model_snb),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X,		&model_snbep),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_L,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_G,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_G,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,	&model_knl),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,	&model_knl),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(CANNONLAKE_L,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_D,	&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&model_spr),
-	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&model_spr),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ARROWLAKE_H,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ARROWLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(LUNARLAKE_M,		&model_skl),
+	X86_MATCH_FEATURE(X86_FEATURE_RAPL,	&model_amd_hygon),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE,	&model_snb),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE_X,	&model_snbep),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE,		&model_snb),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE_X,	&model_snbep),
+	X86_MATCH_VFM(INTEL_HASWELL,		&model_hsw),
+	X86_MATCH_VFM(INTEL_HASWELL_X,		&model_hsx),
+	X86_MATCH_VFM(INTEL_HASWELL_L,		&model_hsw),
+	X86_MATCH_VFM(INTEL_HASWELL_G,		&model_hsw),
+	X86_MATCH_VFM(INTEL_BROADWELL,		&model_hsw),
+	X86_MATCH_VFM(INTEL_BROADWELL_G,	&model_hsw),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	&model_hsx),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	&model_hsx),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&model_knl),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&model_knl),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		&model_skl),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,		&model_hsx),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		&model_skl),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_CANNONLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&model_hsw),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&model_hsw),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&model_hsw),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		&model_skl),
+	X86_MATCH_VFM(INTEL_ICELAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,		&model_hsx),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,		&model_hsx),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_COMETLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_TIGERLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_ALDERLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	&model_skl),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	&model_spr),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	&model_spr),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,	&model_skl),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,	&model_skl),
+	X86_MATCH_VFM(INTEL_METEORLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_ARROWLAKE_H,	&model_skl),
+	X86_MATCH_VFM(INTEL_ARROWLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_LUNARLAKE_M,	&model_skl),
 	{},
 };
 MODULE_DEVICE_TABLE(x86cpu, rapl_model_match);
-- 
2.45.0

