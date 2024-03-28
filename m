Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53EF13175E
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643318; cv=none; b=gOO0NdwKnjRI3jPVaeN4JZYqXCLdp/RMDmYNbD8KiDi6HGTs7aE9Z7DZfleUt9FKDHm0wB0DKlU+Y1nU2YNy8chRxLUxKfHez5OLFG1c7QllCXEBdTOU2jPQiItV18z4R8Zo7GgGys1wyHMvgDffdzn2XPpcADdAkf3PH79O0dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643318; c=relaxed/simple;
	bh=8BfI2hjYKf/TtKpPZBR8m4bVwal0XuuMnwSbzdK8eQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlGDxRrGtnb+PJeObxZbQ4Bfshi2NypWH3QiToC//35ReMCqb5P++jhMATOFnS02cp35myOWgc3l5rtrRtkW+lBIvw0LIt6pj5syyrKxXuUd2mbmCblfrOq/1+MMl3UFlIuvfYZXkg1sCKA9FisR7n6zuIU3c7/+iJQaozZIoyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l90uN3PE; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l90uN3PE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643315; x=1743179315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8BfI2hjYKf/TtKpPZBR8m4bVwal0XuuMnwSbzdK8eQk=;
  b=l90uN3PE7j/yCX4y/Z5nfIp4AsDbqbBWXQqEIuHsYRYZNosQZlHGRflI
   86cd4V46m/e+I7uiHIEyvJQSxIgdFW+4Om09Z+StFbQTSkPCy50wgc216
   FUI8ge6GCCH5Azsg/385gdR2cKq0U70Fe0xHL/+V45kNvFfFdWs/mVc2g
   fDubzwCXP2RqIKlei1cgMGqqOwZKSSVXcOFIV4RFvBKC4mrUP+9vU909C
   GIE/tBCCic09rls47DjDLOWBmWmhqbMAFs2M49fR8IUAOdwQRFTZJyj5R
   LOJ9NOJaxXrxQzkzh21tDB7qX+BkUCZB/PC/kUE6N7eqUCqU1ffYFPiTM
   w==;
X-CSE-ConnectionGUID: hYVIv569QUiop/QOYUCh/A==
X-CSE-MsgGUID: awhA/c4BSJaXzIFDuxpuhQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294782"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294782"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726119"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 52/74] x86/cpu/vfm: Update drivers/platform/x86/intel/pmc/pltdrv.c
Date: Thu, 28 Mar 2024 09:27:46 -0700
Message-ID: <20240328162820.242778-52-tony.luck@intel.com>
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
 drivers/platform/x86/intel/pmc/pltdrv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

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
2.44.0

