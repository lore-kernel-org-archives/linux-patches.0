Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81591176FA7
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982512; cv=none; b=aAROfivbjlOhzKcreTyuFFlcJEdE5ITAvgXIrDulShhPBWxLJBGiREuYi1b+dEfrFgVAY6Wzp5I1Mvmn6UxUNpvhLVfE0o1phvJ7KlqgQilbw78LHzDx0NjJSFAaPyllFzP60e7xrQkRka83Zn4aVyXAWvEcNR87k2dh90tdADU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982512; c=relaxed/simple;
	bh=J3/S5BDaJa8W6a3KT1KDi2bLZ8czh8Tc2c5pQvZ+hqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2FdoiIHTeEl1k8rSOqiTgeYj68aP1IqUkIm1Rxm50hJKm2F6b1JGMCOjvEKQx3O3zI8pCuDlHu6xWlVZ/iKUrQIgPZ6jhy8U8COUH1zEIZ++rdvYZJDx9EUuBUS58Q8d6wtTkZ8ASiBDAEetcwteUGIe8wMWe7GX6PscgaRQxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BNDIqVTM; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BNDIqVTM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982510; x=1745518510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J3/S5BDaJa8W6a3KT1KDi2bLZ8czh8Tc2c5pQvZ+hqQ=;
  b=BNDIqVTMzwD9X2rCh5L85ScV8YWvZiUb8Nqmaog3vNPPQuGW3PPrlexZ
   Z8sG+yADwc7j3VM+SwN+AznkR5agELXI9HWU9nsmMEOdfLDKNXA+SWLRH
   gjqSlffPKw57cgoiJ50l+K/ew1HJqk+klQzNIC4Hg+mqIMfy0CPyzOX1W
   YDNOxzgR2Bah3nEWjF5fS5KToCt88/FnANxTbZ2gzU2XVwN+A88193Vxs
   xTGNNF9CVHalOSgfQn3JXyjzGqGW7h/0wdypgQv02gk5tNvhIJ6tbQDnU
   2MGz5HrGfKQky4zDJdBbHfzwvYZvW9mwQdiACPEwBLorZi9K5o6Q39YK7
   g==;
X-CSE-ConnectionGUID: /T0AgKoqR1q6uuWh9QI7BA==
X-CSE-MsgGUID: +g/IKFwRQ0KtcvFM6PpGOA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481832"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481832"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:58 -0700
X-CSE-ConnectionGUID: d+wTH2E0R+KvUsjkrxPzkQ==
X-CSE-MsgGUID: 6r5h0f+ET6+PHYO0YHMU4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262622"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:58 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 16/71] crypto: x86/poly1305 - Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:14:58 -0700
Message-ID: <20240424181458.41462-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
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
 arch/x86/crypto/poly1305_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 1dfb8af48a3c..08ff4b489f7e 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -12,7 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
 asmlinkage void poly1305_init_x86_64(void *ctx,
@@ -269,7 +269,7 @@ static int __init poly1305_simd_mod_init(void)
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

