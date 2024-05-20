Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22C613B7A6
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245209; cv=none; b=OLDD4LzA+NfcyntoNW2JZBAXrKUKRgeCrK7drSfpd1+0vQIhU2hvnCz74sEdJMA3FkMUCjwl/hZG1IclyrE3Ill+EfIhA86Qs5S0YJhijBI2T3gFTcVf60FBww4Ie99kw0baCD32zeZsVi+BbXr22OclYIbZOqyDsAriEmYtbBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245209; c=relaxed/simple;
	bh=3xWAckKLedIRwhhdnl1v4yxZLvPVQHJ+27f28hvh3oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n38hP8L2GYVpQROa5Ji+gPSfpURMZ3EUp/0ip5lR7tkBcQ+oAnYqOXB/476Swf/ST6CJXBR9H91Wx0DUxbcXSRkjJyXE9Ul061arzwUcVvi+TkNiVVdYC0dVVqrXNvmRsr+xSQPTSuSMG+F26DAuQB2AuTEQgurCvN3QQXFISN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d1MrpPnZ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d1MrpPnZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245208; x=1747781208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3xWAckKLedIRwhhdnl1v4yxZLvPVQHJ+27f28hvh3oU=;
  b=d1MrpPnZZPHC9nklGcLiQX4Ymh/nh34nJsyomrja9ujutDc4Y0ka2N29
   hpEJucBnjLIwDERrWR6q1AOjZ5cpSexZl47Rhp9zG8+qd36ugvIGSVxMY
   7Cd8F5XbtPazs+eUl0MADpoQA0MOfFUeQ5nyD7aciW2ZKmj7rc8fdDxPy
   28FyWL8QysicHoTk+Wehkc7BkAYGeiNocYArQycndw8LCVUZKDrFWm7IV
   U3JtrDAmBKfG9lzdGUvwcTw9fF+YFreIzCvs/0g3KGIq3ZdRBFOp1KfKv
   eI5LksH5n0UGWh+c1wte0Sg0OV4pLojgpQrYs6AuH22yns2jFZlyANwRJ
   w==;
X-CSE-ConnectionGUID: 0VGW2AqeQgGPnEEHkhwcbw==
X-CSE-MsgGUID: hnqaszJsQ46tdMgSyaqBqg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199797"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199797"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
X-CSE-ConnectionGUID: E2xYQU4GSbqWd4uI7Ldm0w==
X-CSE-MsgGUID: CP8JBdBpRDyt4+UbVW5oMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593460"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 26/49] crypto: x86/poly1305 - Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:57 -0700
Message-ID: <20240520224620.9480-27-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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
2.45.0

