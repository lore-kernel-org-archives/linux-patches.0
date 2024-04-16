Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B235513C3FA
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302411; cv=none; b=DZOUy4rf1kIk+0utlRBB6hiIU0oQdEiNcnaZGKiWTrf6Nsv/Os/86iQo486iE+wDb6uu+NzoMce30raizs+TIppewEr9DfNsDFkhmHwpD6k+6CbkeE9tcpmWEJni4XiKg3pdTIdkjyRCnPsBrN3S9DGRTHzMvJ74UvKbbNa0qWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302411; c=relaxed/simple;
	bh=4Evugcn3kVWKJZ07W69Ngsq6GMblRUkSDp2ZEKxPWWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grEtmIGIg/6u876dLeMHaZdRYiXKYuVHNogvXjhLOz/GMxe2NBwdrm8GFwagtaEi8La/am3KSMX/R1UGTQSpVoTa3Tb81R4ZTxGurR4fbJU4eX+joPyLfOICrlo8Y9gbemoQxA218WWDDZ0CEua+U4JRG0o5BmhDuoaDcLHQSHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L33c4zNN; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L33c4zNN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302409; x=1744838409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Evugcn3kVWKJZ07W69Ngsq6GMblRUkSDp2ZEKxPWWk=;
  b=L33c4zNNMXWXS/J5z3pa6k9jmPZy2dUb0xvyHLpJUVBquEFSGx6lVuvW
   fOboVoJ3PZ6aukx093NUvn2r9AqGJE3/mSagY+tykFmDEcGzYsPs2qTse
   M0gSfxKhoZPCmp5uQK8EYReisZvpwSFi/zyM/vJtyywWevqzhC0IgOqIz
   iSumbjKehPp1zOIvXJem/B7Y6o+sGvwF0c3eWETopDm5e6wSIvsHMpWDi
   PEY+WrQ6mGtXVHjf8wuabb6iHtOP5DFI1qpEy2XYbjdhJCcrgodXXB52K
   8W1ZUTobveOt//mb5OpapnbsKQv2YmIcrbAwUWGv7mOp3PHO5uHLEb8cB
   A==;
X-CSE-ConnectionGUID: VuccHL9/RTOcq6sF4CukTg==
X-CSE-MsgGUID: +eLn2MtqSJifbrOTB+ULaA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914773"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914773"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
X-CSE-ConnectionGUID: v+A65RU3R7WsNRQDnSC92g==
X-CSE-MsgGUID: DhkLpcDwSx6Kj7vTJYtDMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871952"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 22/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/mce/intel.c
Date: Tue, 16 Apr 2024 14:19:24 -0700
Message-ID: <20240416211941.9369-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416211941.9369-1-tony.luck@intel.com>
References: <20240416211941.9369-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/mce/intel.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 399b62e223d2..a73e3ff847aa 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -13,6 +13,7 @@
 #include <linux/cpumask.h>
 #include <asm/apic.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -455,10 +456,10 @@ static void intel_imc_init(struct cpuinfo_x86 *c)
 {
 	u64 error_control;
 
-	switch (c->x86_model) {
-	case INTEL_FAM6_SANDYBRIDGE_X:
-	case INTEL_FAM6_IVYBRIDGE_X:
-	case INTEL_FAM6_HASWELL_X:
+	switch (c->x86_vfm) {
+	case INTEL_SANDYBRIDGE_X:
+	case INTEL_IVYBRIDGE_X:
+	case INTEL_HASWELL_X:
 		if (rdmsrl_safe(MSR_ERROR_CONTROL, &error_control))
 			return;
 		error_control |= 2;
@@ -484,12 +485,11 @@ bool intel_filter_mce(struct mce *m)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
 	/* MCE errata HSD131, HSM142, HSW131, BDM48, HSM142 and SKX37 */
-	if ((c->x86 == 6) &&
-	    ((c->x86_model == INTEL_FAM6_HASWELL) ||
-	     (c->x86_model == INTEL_FAM6_HASWELL_L) ||
-	     (c->x86_model == INTEL_FAM6_BROADWELL) ||
-	     (c->x86_model == INTEL_FAM6_HASWELL_G) ||
-	     (c->x86_model == INTEL_FAM6_SKYLAKE_X)) &&
+	if ((c->x86_vfm == INTEL_HASWELL ||
+	     c->x86_vfm == INTEL_HASWELL_L ||
+	     c->x86_vfm == INTEL_BROADWELL ||
+	     c->x86_vfm == INTEL_HASWELL_G ||
+	     c->x86_vfm == INTEL_SKYLAKE_X) &&
 	    (m->bank == 0) &&
 	    ((m->status & 0xa0000000ffffffff) == 0x80000000000f0005))
 		return true;
-- 
2.44.0

