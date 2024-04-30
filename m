Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BCB1C688C
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495912; cv=none; b=LBNSK4awMR8SXI4aRqkL3F4n3ghJ/zYZiDCtUvwIuUfaF5TpdcNcYNmXaar55Mjj7EOQltjYDsnUZUwPRlXt79w6zFzIrXdEGNTy5hBWuTfajb8FqgQB24E61mrmxoMQf28BbWHY+suCPlVPqDv1tSZmBhenTo5vwK/id2hk9SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495912; c=relaxed/simple;
	bh=K0SMUkbNdaQTs8egvbi/pMmubWEho1P85u2CzO6rIlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJOf5cq8BFtMHF8xrA2KuACj3og0j3AZu4CFS030n+avRLZnszZ5FxHz0OrF+cultbY9Pc1KmSiHOxkVVzEjta3/afTAw56Q/11xkVgh1tu0jX0v0LeBglqpGaALkizpzeV5GARjYrMZeFL5vWPXtbQdM7LNim4p3yzc00cfMcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=as+xknr3; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="as+xknr3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495911; x=1746031911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K0SMUkbNdaQTs8egvbi/pMmubWEho1P85u2CzO6rIlk=;
  b=as+xknr3NcteoxHYhIovcuCiGrgmZ1Qo27iv3iQeHRvQtAbeMfZnP+7c
   DgJqx+1QK8d5H78GEeIaJlBDyyh9hYTF8czfCB0LHQUZGvsK4J2onXDY6
   OqwNl0wf30mmQ0TnG7wGka7nnbBHs25s/J6hMUFX4QC2ToNLiKyT7gKXb
   hiwYY636cPqfTjDQnrqcQykMv91LvF2kbKJlK7c9mHDdJ876gTOIGx2Mz
   ziOI8nKAjUKoWslslD6zacwbk5xLnWe+ISvaL41ZuxvkWIAkSGp/2sE7g
   hpSqmZlW4MODVBqqsLTvxo9MhCg3bHBEj54A5PS8KaPHFlJQ9PG/kKjdD
   Q==;
X-CSE-ConnectionGUID: ZtWMWBnXQB2PBXSt3gUsiQ==
X-CSE-MsgGUID: 2vyB8YjRTMqiv0O+MMkvSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075768"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075768"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: cRsaezwwQC2j9D/c2EVBow==
X-CSE-MsgGUID: 5GKCtyyNQjaaCHTMHrH64g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515505"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 35/47] EDAC/sb_edac: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:48 -0700
Message-ID: <20240430165100.73491-35-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
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
 drivers/edac/sb_edac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 26cca5a9322d..cbc92d3683e6 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -3546,13 +3546,13 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev, enum type type)
 }
 
 static const struct x86_cpu_id sbridge_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE_X, &pci_dev_descr_sbridge_table),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X,	  &pci_dev_descr_ibridge_table),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X,	  &pci_dev_descr_haswell_table),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,	  &pci_dev_descr_broadwell_table),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,	  &pci_dev_descr_broadwell_table),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,  &pci_dev_descr_knl_table),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,  &pci_dev_descr_knl_table),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE_X,	&pci_dev_descr_sbridge_table),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE_X,	&pci_dev_descr_ibridge_table),
+	X86_MATCH_VFM(INTEL_HASWELL_X,		&pci_dev_descr_haswell_table),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	&pci_dev_descr_broadwell_table),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	&pci_dev_descr_broadwell_table),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&pci_dev_descr_knl_table),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&pci_dev_descr_knl_table),
 	{ }
 };
 MODULE_DEVICE_TABLE(x86cpu, sbridge_cpuids);
-- 
2.44.0

