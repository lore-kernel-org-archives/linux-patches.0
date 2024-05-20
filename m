Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6037713D262
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245220; cv=none; b=GBMKc93OLMA+3+1srjhUl7UZgk60/HQqx+bUeB/eK3SM+n6fjsAfP8hdLmwPxL35UfevRn8maWDu7kD2Kxvy4aQnKwgwnPAWjEHqwyRts8UYlOZhj/y5Okd5qDDT3/DxoYUWTkTw6Md7aE2qEb596a/AspGRTbq9xm+qejwstVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245220; c=relaxed/simple;
	bh=A/kp9Rdskk/VY+HmbT1Gfw4afwzWaErQECfGecHn7vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNcP2IMEAq7FNxH8LVfdZQ1Rb7Q7I61uRHO3EPFtlIdD0huS3V8JQjxJadHB3s6r9gHX0NT+fbsP/JKYiWetMH5rzKIaH5D7QmwbFHAvsja/c8lFEKA9L8MNYUZL9+hPr6lyuKFc+fMl9qdHrWnD6n0yh4Gdl/W7JhZLU3Uk2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hb+sHUlf; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hb+sHUlf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245216; x=1747781216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/kp9Rdskk/VY+HmbT1Gfw4afwzWaErQECfGecHn7vw=;
  b=Hb+sHUlfafj/8o0/uPOIG82KXKzoUuNQ3f6jUIwbkjqALjBzeA5nt+2+
   Nuhc4/2tBWEvUYVXIgJTY6TbvDe6tdAOStwqDH8ab2cjbrT4wy2VYubwC
   onFvAO0uThnjrBIMmy+XrwhbKANg51jGpA7tpMFr657XgzSnbuh/DkEiH
   oCE1KqpbZTUIvDk3Ccr2BXo+cXr27Af2OcmwE54MHayyD9c6l70TxY52j
   apvSPgvngrNlig7/DmGyEU1khA/ojPzu0XoMj+TAaZFoFreftVuji00zf
   Uzmghncl/y7MILpUYh9xX68NgP/M/afKSGZPcWPWSIR/n6VvVZZY++Lnq
   Q==;
X-CSE-ConnectionGUID: aPhTHdKLQcmKKkyXFaGOgA==
X-CSE-MsgGUID: 6NuraXrgRYmj3ySelgTVAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12200014"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12200014"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
X-CSE-ConnectionGUID: /X0EMqcrQMKHwdvSe7S2Ag==
X-CSE-MsgGUID: jblmajauQ925b227asUMIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593525"
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
Subject: [PATCH v6 46/49] tools/power/turbostat: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:17 -0700
Message-ID: <20240520224620.9480-47-tony.luck@intel.com>
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

N.B. Copied VFM_*() defines here from <asm/cpu_device_id.h> to avoid
an application picking a second internal kernel header file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 165 +++++++++++++++-----------
 1 file changed, 95 insertions(+), 70 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 8cdf41906e98..2df6c118b6c0 100644
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
@@ -367,7 +391,7 @@ struct platform_features {
 };
 
 struct platform_data {
-	unsigned int model;
+	unsigned int vfm;
 	const struct platform_features *features;
 };
 
@@ -910,75 +934,75 @@ static const struct platform_features amd_features_with_rapl = {
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
-	{ INTEL_FAM6_ARROWLAKE_H, &arl_features },
-	{ INTEL_FAM6_ARROWLAKE_U, &arl_features },
-	{ INTEL_FAM6_ARROWLAKE, &arl_features },
-	{ INTEL_FAM6_LUNARLAKE_M, &arl_features },
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
+	{ INTEL_ARROWLAKE_H, &arl_features },
+	{ INTEL_ARROWLAKE_U, &arl_features },
+	{ INTEL_ARROWLAKE, &arl_features },
+	{ INTEL_LUNARLAKE_M, &arl_features },
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
@@ -1003,11 +1027,12 @@ void probe_platform_features(unsigned int family, unsigned int model)
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
2.45.0

