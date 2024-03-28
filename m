Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FBB130AD4
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643319; cv=none; b=uNVFYrxwJJW5DPSHI38o67I+NHQZQKzsOaS0/S4+7HJb7G1rhZq1QIkAnWDBSV3x/1HsOWjzSYDh/WGg8AUsbbHZ2FY7XkWxT7NzFijzhqavwTnSAAS8bdvhcOvygSck+H7Kaj6VP/UQAScpqm57WZgUoB3Gbe16+avlbRMT+4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643319; c=relaxed/simple;
	bh=lMiePj5BLeBwTfmhtOWVl7Nr+Y6PBZ2sXOR4c241KGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMIBIzVcrO5eSOiTICPpKtqlXh/BtKAwuTuLqwD73A92iJIHwujNt25N2c2Wz2sJDim5P5iw6rwYDs4W9cX3mSE48jG9RMYJL6T2s1e9xFBugr9Q2K5nKCU1AAaeluv6GYkpD//vgNXCsKfvK/CrS1vD4MXtMjJLaKV51lCewkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lx93aC6H; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lx93aC6H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643315; x=1743179315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lMiePj5BLeBwTfmhtOWVl7Nr+Y6PBZ2sXOR4c241KGg=;
  b=Lx93aC6HrNac3r+73lfIlERxDvjStCKhtrXlEG44FVYCqQ2125YGGCY5
   zZqjXkqMaO+Rb6I5nld46w5fYhODUTlMJm0f1FxdpaKx/IEZCBMIj85vO
   9XeyPIYps9CfdwRUQPbB3NYDgwu9L61SfmXLZ2ZdI3zQ67vDnE7iCrDEs
   8iwRXMcITOxbEBhZohUlkcYDFb5Jh41kOawCdc32HJnJ67+PrvW4zj2lx
   S8e/sMj2cCyWCNPwcFmHv6QnHrFCiIxdLidFDOQ3tbgesIX7BYe7GOTUv
   susxasm3FQ/X4Ma+AjNX4ifPV4ngEsQS5Y+4znxuj8Zw/FMMyMachDcSS
   w==;
X-CSE-ConnectionGUID: MCWgInfhSn2kWuZMYb1HlQ==
X-CSE-MsgGUID: Ah0bUT4BRwiWWYNIyA28WQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294781"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294781"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726116"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 51/74] x86/cpu/vfm: Update drivers/platform/x86/intel/pmc/core.c
Date: Thu, 28 Mar 2024 09:27:45 -0700
Message-ID: <20240328162820.242778-51-tony.luck@intel.com>
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
 drivers/platform/x86/intel/pmc/core.c | 46 +++++++++++++--------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index 10c96c1a850a..054a56532e23 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1255,29 +1255,29 @@ static void pmc_core_dbgfs_register(struct pmc_dev *pmcdev)
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
 
-- 
2.44.0

