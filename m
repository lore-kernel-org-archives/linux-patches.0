Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DD61C0DF0
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495907; cv=none; b=CnbvAnmOGn06sf42QHH4PdDSh/w+up7GkRvnG0HwkvT2EobLAowE+bb61YbnLxL2sfrn37KwhelUoNNg0uM1/oz/8Vvz/cI55uslJJ1qAC/Mbit3AZ0V4N2zYY7W/B/bSbkhDxDSfR5FmzeDS8PvlNcqWDdSeEjIJA+J2/z2VHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495907; c=relaxed/simple;
	bh=J3/S5BDaJa8W6a3KT1KDi2bLZ8czh8Tc2c5pQvZ+hqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR0loBltYRPB+H8LyUfGUq61oz45kkPT3q9EuDkXh+a9Gjo565C6nvOdHsTWo+0s+8v6VcCDjlPwsq4APBYlZ7Vft5C0hKSOZ5yRwVWmx//eOMgrLmYeG2g7pT40sTB13ORF4eQNCY8EwH+cN0qBk2572os9LObGKpihLdvOH+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cBGneDjN; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cBGneDjN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495905; x=1746031905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J3/S5BDaJa8W6a3KT1KDi2bLZ8czh8Tc2c5pQvZ+hqQ=;
  b=cBGneDjN+JIrRucMqctstMiJAwgp7hnTmwPsdtA/1UK894CwVrt6eul7
   BPUq01Ic8dJx6WLhR2QMp5F2nk5Pi1sQ/S8RRIvBHjCWpc0SVlbIjL64S
   K8foRbd4lNBY5LiYoGCkA9lxurFxRORCXamxVcxsBZ6NarvAk0hfyKqzE
   UMJXWj/+xCw3eEPg5a8PIQ30hycvvEOf5tZoKrzFcmhyJkZ9SwnXGibW8
   FCSYM97BAQuRqOGh++T8uixPC9WeXTIOLgP0HFpxg0VxtNqqNd6k45Vxl
   EjXi9ZLsWWB/xQqUgJD8Pohxi/KlUevViTsQ3d187hNAu1nkHS221YKrB
   w==;
X-CSE-ConnectionGUID: /PU8AlsrR3uVPy4zM39rsw==
X-CSE-MsgGUID: O7C/cccpTUirQtFvNbiniQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075722"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075722"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:22 -0700
X-CSE-ConnectionGUID: 14aDnfPrS9WcC5YxWZUgnA==
X-CSE-MsgGUID: gyj4EATrS0OufzG26f4VAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515480"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 24/47] crypto: x86/poly1305 - Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:37 -0700
Message-ID: <20240430165100.73491-24-tony.luck@intel.com>
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

