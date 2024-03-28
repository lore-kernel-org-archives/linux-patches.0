Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92910130AC8
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643311; cv=none; b=NedLWGLsfqLj4B7bgPL6mtLAbULFkwvd+z7TbSCPW7PH16gsa2TydIAWhWKCWVFEI/7Apww22/sCkD1j6wo+sRxHfyOLlLvZU1CHrR2Vgxm2nCa94LopwFd8epP3pyxcwXLXfxEhWtJBQkyV6iv3MxvO+rW+QKX+33rvdCGxVrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643311; c=relaxed/simple;
	bh=GP8K12tmMTVew3rcfbK9H8cbywaw2ViV8X1yf50M3z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqXQWbvWE1Agqav5VsgM2miFCivxjd54wV3a5PN5qYhnN2DjWvSbWGhN6kIduVnhkg8PlQJPloyGiTXplddDYz++Q7effQrGSCBEPL1xWseUesfe+73Sxa6UMM6q+obeOyjgh+XkckBnMJdxxiuCV46a5P/3J409KUSFTKlcVQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cYPKucO3; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cYPKucO3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643308; x=1743179308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GP8K12tmMTVew3rcfbK9H8cbywaw2ViV8X1yf50M3z8=;
  b=cYPKucO39KDjWQN6DV4b6g2NOh8WyUeyoBoTUPQZyVhHBmaxUymoyyDV
   oYJM0oAKpPYPbM8k9M54fgHvLgDF29unD7tMdduzXTyHD4AnPuKhLdWpv
   7LcKxp4Ms/KNfD8+Jc1TMu7ilmpfGal2eVvV2jMjV+mMMg32G2icg4qBE
   HG9hKloQNGp/hXwSdmuVGCb8vQAHlOrV0XIWANuk3cGe5Fef7AGX70u6B
   7rauLmpm0XchTqxEtbur4ownE0Cpv5n4owGQfYlWnwTyHBdyJ1AbEW27Z
   9unGhc/jiDZDvsUWDobuwtjQDuH7Zg/aHYaiueLl/bGZM9EC5FIdGw1bV
   A==;
X-CSE-ConnectionGUID: 01FtVDM6T36pkOhiZtRryw==
X-CSE-MsgGUID: bxV9fb+ORUSQQ67sFUY/4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294743"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294743"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726015"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 21/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/mce/core.c
Date: Thu, 28 Mar 2024 09:27:15 -0700
Message-ID: <20240328162820.242778-21-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/mce/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index b5cc557cfc37..fc3104e7ea5d 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -47,6 +47,7 @@
 #include <linux/kexec.h>
 
 #include <asm/fred.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/traps.h>
@@ -1930,14 +1931,14 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		if (c->x86 == 6 && c->x86_model <= 13 && cfg->bootlog < 0)
 			cfg->bootlog = 0;
 
-		if (c->x86 == 6 && c->x86_model == 45)
+		if (c->x86_vfm == INTEL_SANDYBRIDGE_X)
 			mce_flags.snb_ifu_quirk = 1;
 
 		/*
 		 * Skylake, Cascacde Lake and Cooper Lake require a quirk on
 		 * rep movs.
 		 */
-		if (c->x86 == 6 && c->x86_model == INTEL_FAM6_SKYLAKE_X)
+		if (c->x86_vfm == INTEL_SKYLAKE_X)
 			mce_flags.skx_repmov_quirk = 1;
 	}
 
-- 
2.44.0

