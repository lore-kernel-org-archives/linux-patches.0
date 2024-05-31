Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF21B17D889
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187834; cv=none; b=SvANyPmGB90s2obIB3GJhgj7gPFeGWIFIumxTb4SmWq05uJE0kEr3x0bFBta2XnmP9VKslZjBHb410jl79jRY3PvQBMYADlNyqVyaVlRkHBS/n8xdMmiIuH7FYGBQcDWQqRzFg9ST8IKFuSDCxkWl8jhlPGAl7k2K4FOUqvdLBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187834; c=relaxed/simple;
	bh=FfeANi/aX8lTWIYdqfaGTSFqvYCgBVvixGLxtNlg0Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhCUBgD4ZvkkH0Xytf09K4C8gqDl/4obasRa09FsiGfVmiOuLOMztc3OrDbVjsmywws8gWAkEz9SU+QRRYDQWpxv6BTrwTpYzhF6vsqzfoDzkWx9COOfd3/g5XpODq3+KYEJoLeRFVzDQ93k6ejhtIAbxHWs+q/fZ9Ih/P2cybU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mtx5/NUa; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mtx5/NUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187833; x=1748723833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FfeANi/aX8lTWIYdqfaGTSFqvYCgBVvixGLxtNlg0Pg=;
  b=mtx5/NUanbrWHJccrEEqYVYqSwOYW2sx40jwa5kmVIKzbNQ1FP/PzL78
   rE212Fgm9IECmTdfL5595qHvGfi9i1AcIyTXU6MJaqtPGVHyp0CzMwNiO
   aQxhN2I/GPw3Xj8KsrLEVXbu63SMJ2iWLh8AVXsaAdCe1qLBcePRtNnHo
   tOH+hq1XB+56lTn2n+1M4rNJUWSEJwgmurtZ9qDot2rhYCLCm7VC1tdFY
   zjIM3o0PMSjiUPKnV+ALkUSBhudfL08c9iHgT8SJQJTVIMcO5PN1ESBF3
   rlqtwjeYqMFlYCmi89TA779QCeptoFPfMKRKw+O71tMGpFEmfWsj8sPBf
   w==;
X-CSE-ConnectionGUID: N4z1MhYoTdiCI5yiR+Uy+A==
X-CSE-MsgGUID: /9OfOUhQSuav8ftJfuwsGA==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871824"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871824"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:11 -0700
X-CSE-ConnectionGUID: +HrKgBRjRQuinUm4p0vBFg==
X-CSE-MsgGUID: RhSU8KmFSQeJNSoZzZXIsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355364"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 01/11] platform/x86/intel/pmc: Switch to new Intel CPU model defines
Date: Fri, 31 May 2024 13:36:57 -0700
Message-ID: <20240531203706.233365-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240531203706.233365-1-tony.luck@intel.com>
References: <20240531203706.233365-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/pmc/core.c   | 46 ++++++++++++-------------
 drivers/platform/x86/intel/pmc/pltdrv.c | 16 ++++-----
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index 2ad2f8753e5d..65eb09c7af6a 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1293,29 +1293,29 @@ static void pmc_core_dbgfs_register(struct pmc_dev *pmcdev)
 }
 
 static const struct x86_cpu_id intel_pmc_core_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		spt_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		spt_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		spt_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		spt_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(CANNONLAKE_L,	cnp_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,		icl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_NNPI,	icl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		cnp_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		cnp_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		tgl_l_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		tgl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT,	tgl_l_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_L,	icl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ROCKETLAKE,		tgl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		tgl_l_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT,	tgl_l_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		adl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,        tgl_l_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		adl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	adl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	mtl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(ARROWLAKE,		arl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(LUNARLAKE_M,         lnl_core_init),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		spt_core_init),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		spt_core_init),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		spt_core_init),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		spt_core_init),
+	X86_MATCH_VFM(INTEL_CANNONLAKE_L,	cnp_core_init),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		icl_core_init),
+	X86_MATCH_VFM(INTEL_ICELAKE_NNPI,	icl_core_init),
+	X86_MATCH_VFM(INTEL_COMETLAKE,		cnp_core_init),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L,	cnp_core_init),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	tgl_l_core_init),
+	X86_MATCH_VFM(INTEL_TIGERLAKE,		tgl_core_init),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT,	tgl_l_core_init),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT_L,	icl_core_init),
+	X86_MATCH_VFM(INTEL_ROCKETLAKE,		tgl_core_init),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	tgl_l_core_init),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	tgl_l_core_init),
+	X86_MATCH_VFM(INTEL_ALDERLAKE,		adl_core_init),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,	tgl_l_core_init),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE,		adl_core_init),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,	adl_core_init),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L,	mtl_core_init),
+	X86_MATCH_VFM(INTEL_ARROWLAKE,		arl_core_init),
+	X86_MATCH_VFM(INTEL_LUNARLAKE_M,	lnl_core_init),
 	{}
 };
 
diff --git a/drivers/platform/x86/intel/pmc/pltdrv.c b/drivers/platform/x86/intel/pmc/pltdrv.c
index ddfba38c2104..22cfcd431987 100644
--- a/drivers/platform/x86/intel/pmc/pltdrv.c
+++ b/drivers/platform/x86/intel/pmc/pltdrv.c
@@ -35,14 +35,14 @@ static struct platform_device *pmc_core_device;
  * other list may grow, but this list should not.
  */
 static const struct x86_cpu_id intel_pmc_core_platform_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(CANNONLAKE_L,	&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_CANNONLAKE_L,	&pmc_core_device),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_COMETLAKE,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L,	&pmc_core_device),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pmc_core_platform_ids);
-- 
2.45.0

