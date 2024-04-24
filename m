Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B201B181334
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982524; cv=none; b=jOsyFTOGpOOp/SU3z9SCepN2qe/Q2LwKufFwg1qB0MoBOv/fiKQrz6B/WDQyZi54wJ5kUseJcgpUhLAQruE8LwkFoOm7Jn7f0riJ/Soi6NN3hSwiOE5l5vU91u9mAqku97+Wl9RR9+DTUK7rQrkjQPIJ/sFEI5bD3kzUmEYU5yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982524; c=relaxed/simple;
	bh=RNT+k0vH5nyuxqu3Y+Ud1FK95n7UPRfWtbXzxwVqrV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNxMSq/ZD1qiEjkmOYHrU6FLObCHbJgmwHyklS83NF2a/CldRH0L+5lhIfunXEaeDTHEFkI7peSRNYEYVInBxlCaE9MfQL/YYjbap/5AAUwJUYiP/3YOJR1YDXSXhVTOMsVqHeOxSmnaQD9vJiBFBnVzzBjPH3Q8WJTIsFTwzJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E+hMi3eJ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E+hMi3eJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982521; x=1745518521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RNT+k0vH5nyuxqu3Y+Ud1FK95n7UPRfWtbXzxwVqrV4=;
  b=E+hMi3eJOK/VRXAieoys4SCnf+c2IBs2Wc1fKTfBMYbhdozqBx7T1/v+
   SEGgZahYnpvp7SmclmrvZTVVGE+fDt8FtY8RcnykTjBEmePzMb3u3Xbw2
   w0L7svXwiEVduD04Mj85h2AyrpKeQaMRDY60NAl3uQ3RIf5F9YgqMTHHb
   JqdQ2Y3fFjaHsFZ6DTN5UebtOG8IDOKI+Eq15SeiFoB8+kvua20VXIMFI
   C5cmpLMxTp+9s7bYF/XdPi54fGeoUNZp/VcdyGe31xDDhZoQ8LTtfAzOV
   XCo/Tn3J4g7OfQoMTVj1jkVYTEAOk6tzofUkP4K9lz+qrhuo6lbE946hx
   g==;
X-CSE-ConnectionGUID: /UBVp7HwRKaMZGZ3XxetJQ==
X-CSE-MsgGUID: 1CUtWmL1T06XRIBwsxmpvA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9482005"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9482005"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:12 -0700
X-CSE-ConnectionGUID: 3N7OQ/o8SAO9NhA7ZCmJIw==
X-CSE-MsgGUID: bDu9a9cXQw6s048MOIf4tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262748"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 33/71] x86/mce: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:12 -0700
Message-ID: <20240424181512.41791-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/mce/intel.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 399b62e223d2..f6103e6bf69a 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -13,7 +13,7 @@
 #include <linux/cpumask.h>
 #include <asm/apic.h>
 #include <asm/cpufeature.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
@@ -455,10 +455,10 @@ static void intel_imc_init(struct cpuinfo_x86 *c)
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
@@ -484,12 +484,11 @@ bool intel_filter_mce(struct mce *m)
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

