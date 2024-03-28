Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9181127B67
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643308; cv=none; b=LuSc5ZACtcpJ6v9yiTy6LQzQiqoZzvGmRuoFdVTTyo1rDwgqdaBGF80L6eu32gVCciP380DXMOZEoivKI+ojwLJ7P3VH0t0eD0ik0X22gH1K35rmuI81lY3SJZPxrJLbHJ0ZWsxyR0NT1tXiUuBr6UaXvKGHRYf55HgehBe8aFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643308; c=relaxed/simple;
	bh=dOmQ7jUeo78k2rwa4FbxrxxtpSbAveIjEYydSHsCBrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7dQ9KLpV3yadquI3sWNiHwhn2p9wyCMp+DjNgnZCRNb0OnZAMrT/XlfCj0HfZxkPKTIgqFX8/KOQCMgsbUuOtszUcpQBAh05S77daiZY9ptVEWRhRjukbalPmY74i8zWbLPdkl8wTKMHTzuzEx44Q9yfV/S/MoxLM6HOkKuzAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MMwe/GpH; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MMwe/GpH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643304; x=1743179304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dOmQ7jUeo78k2rwa4FbxrxxtpSbAveIjEYydSHsCBrw=;
  b=MMwe/GpH/dGhEwPCKLIjBasRHHcSMbcM5AI3YjaGTdOAPRt9PubpmJfZ
   zPiWfGrGNhhKPcJMXh8w+tejOvOSF5TM0ALXpFW1ZJQwXaw4FPzStNyAy
   wJvfQnWAuFp8SRSr49tRlowLF7NgwjzA9wZDBoj/MQvH2z2VH7vR+mJAV
   zMvwyp2yxXr8TaF2OhvAW/0nk4ckzWXyu/+PkcroNG/tH0sQr1/y2dCU8
   Uw83L7pgufGgP0nM3ORVP+bGgXVeulfu9fu7z69rKUpAhKr549HPOfK1x
   s7XVrjzgf8Banwviypy9U9o2/DBvetZV7MkgYoS0aHGP1QjcJjMlCNDyE
   A==;
X-CSE-ConnectionGUID: b8u6rkuTSW2gRQAMFmHAJQ==
X-CSE-MsgGUID: k9MohsNuQoGRVgAPTJammg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294727"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294727"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725969"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 08/74] x86/cpu/vfm: Update arch/x86/events/intel/pt.c
Date: Thu, 28 Mar 2024 09:27:02 -0700
Message-ID: <20240328162820.242778-8-tony.luck@intel.com>
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
 arch/x86/events/intel/pt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 8e2a12235e62..e3320c2ee7c6 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -22,6 +22,7 @@
 #include <asm/insn.h>
 #include <asm/io.h>
 #include <asm/intel_pt.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 
 #include "../perf_event.h"
@@ -211,11 +212,11 @@ static int __init pt_pmu_hw_init(void)
 	}
 
 	/* model-specific quirks */
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_BROADWELL:
-	case INTEL_FAM6_BROADWELL_D:
-	case INTEL_FAM6_BROADWELL_G:
-	case INTEL_FAM6_BROADWELL_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_BROADWELL:
+	case INTEL_BROADWELL_D:
+	case INTEL_BROADWELL_G:
+	case INTEL_BROADWELL_X:
 		/* not setting BRANCH_EN will #GP, erratum BDM106 */
 		pt_pmu.branch_en_always_on = true;
 		break;
-- 
2.44.0

