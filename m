Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685B2130A4F
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643306; cv=none; b=M+emD6bY6DgQSEWv5FhneDz5FyvVDxi8YPSdZQ3HfAHJn5hInhXc3cEnodJjXOfzMDqbkj4rt8JX7tHHfKCXN7Ie4phw1fwQxQ+ne8a0mYTG+09KYcdYCI/FeRtZbpdJCySaLgqCJleUk5RszPJ16L3x95ij4NK+vRIo9owKBE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643306; c=relaxed/simple;
	bh=AAxq3Dn0QuXe2vl7CnrIifkDHLAbXL8hnyPhGpmPU4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsdIqL/KI0gSsz6qU/7kk+QDbtobpaxVPUjvHH+6KVHcpXRzvWlHucjM86EDguGXbAh/+J9vx4DT4L/GMF8F8kTb3iON0U+LhkyKSgToihx8kuJAptA+7gsj+WJurL6/k1KOOcxPyeFHtLemsL0nET5ODMV3sb+jWaoZMPWUDPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ckgVQl23; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ckgVQl23"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643303; x=1743179303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AAxq3Dn0QuXe2vl7CnrIifkDHLAbXL8hnyPhGpmPU4g=;
  b=ckgVQl23DvCRLPsGG1cikojiKI5UvhmS316qMpdwyTy2iXFf59fsvCWE
   X4Cq59e8hQAZJnXFxuPSE9ff1aiS9f2+aRxwRRbXZmB2W9eHpiLXZt0Tr
   T+bKzy/+M7oqzjwNVnuJtV28V6CwgSTTW/PJ2VlVTdyGa7Sb/ovGwEWSe
   GVAQfwR853kLpzHPp5iyhWukqk74bnhQ0bjWqO0RJA9KseDZoVq51Fv8y
   mrAU3tuwsSDEpTY2gZlxNN0JoOGl4oIvWcssXx1uR/4EIDcKfFhhxHqxn
   /JC8o8dkEO5gDCspPjkXE+q3qB6nMxqK/PdjYu5rTv8N6pDTWU6dvg2By
   g==;
X-CSE-ConnectionGUID: SCYRPpEnRA2NxS/A5GGrNA==
X-CSE-MsgGUID: YzW2qY1CRuWc16eIr59pGg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294721"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294721"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725954"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 04/74] x86/cpu/vfm: Update arch/x86/crypto/poly1305_glue.c
Date: Thu, 28 Mar 2024 09:26:58 -0700
Message-ID: <20240328162820.242778-4-tony.luck@intel.com>
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
 arch/x86/crypto/poly1305_glue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 1dfb8af48a3c..9738995080bc 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/simd.h>
 
@@ -269,7 +270,7 @@ static int __init poly1305_simd_mod_init(void)
 	    boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX512F) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512, NULL) &&
 	    /* Skylake downclocks unacceptably much when using zmm, but later generations are fast. */
-	    boot_cpu_data.x86_model != INTEL_FAM6_SKYLAKE_X)
+	    boot_cpu_data.x86_vfm != INTEL_SKYLAKE_X)
 		static_branch_enable(&poly1305_use_avx512);
 	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ? crypto_register_shash(&alg) : 0;
 }
-- 
2.44.0

