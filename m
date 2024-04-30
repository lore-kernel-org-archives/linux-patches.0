Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A7217BB11
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495907; cv=none; b=X46hM/E0P/iB3n/dTPfEvJlPt8Y9wIsTfptmHay3YFvwHMCelIWCyd1TTwrfIov0v6U6Rdn+t8S6jqThM6Z856Mr5k0bmY6a1IAUbWXe9nndRMhd/HrISSFnN/OFLj6m2FcVc4qnrgirnGeD9pn51KaCv8Cc/BYD+/RbL3sbndE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495907; c=relaxed/simple;
	bh=zpJumNq7u5KsT133nYF8l88fxW5RaBTIKz2lN9diWJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orG/msvVjpoiFrUN9WKblsUGFxHVKfGJ5V1OZ1Of8t10oDmO47s/LObPgQjOLFmNpb20DP6kbjGf8b8loID1uu0VrwyiVAdQ/5lxJj5D3X22MBJYt/Xc+wmJamNSI6NcLTrQ+GJz3293EexBKQXviGRH5lDV8F6wDAQUoo7FPiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzFPP4xz; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzFPP4xz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495906; x=1746031906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zpJumNq7u5KsT133nYF8l88fxW5RaBTIKz2lN9diWJs=;
  b=bzFPP4xzyNG2EcU8OgXnKoEqIVWoZ5/xi7OaK3FY3nTMuKASaD3GFnL7
   Wrv4l5YmTPXWbwPWB3VYzFoYd1VgAV0a+4B4DDUFGU8xDMEn5f6+f3aDI
   HG975f1Qmj6GQf40hphwb9MHkZdb54a3ynBNSThUwbi0l4BTbiiEo/K8m
   eP7ax2Q1eSBahylZ8JjygVOUR60Nk9Xio+Ri4+nVhKUyVx+yCERQRB0GC
   z0tz0LClLVGp0Ga1dXWbZZ2Va5ydLKaE1WSoCF2tQlfFU0Jux/p+XhbPX
   Ab9RZVMKk6ToF34FTWg0fxUU6ahZB0M6zUxz9a+UXq4n/At38OspNXA5J
   g==;
X-CSE-ConnectionGUID: WiTtd1J5Tpye5qse9YVMlg==
X-CSE-MsgGUID: 2adpfpY9QEuSjq2ZV0AzaA==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075730"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075730"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:22 -0700
X-CSE-ConnectionGUID: kHKJNDQVT56RmmYTZONdHg==
X-CSE-MsgGUID: 0GWIDDisQhOierrHHt5dwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515492"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 28/47] x86/virt/tdx: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:41 -0700
Message-ID: <20240430165100.73491-28-tony.luck@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4d6826a76f78..ee9a9273b75a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -34,7 +34,7 @@
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
 #include <asm/tdx.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
 #include "tdx.h"
@@ -1427,9 +1427,9 @@ static void __init check_tdx_erratum(void)
 	 * private memory poisons that memory, and a subsequent read of
 	 * that memory triggers #MC.
 	 */
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:
-	case INTEL_FAM6_EMERALDRAPIDS_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_SAPPHIRERAPIDS_X:
+	case INTEL_EMERALDRAPIDS_X:
 		setup_force_cpu_bug(X86_BUG_TDX_PW_MCE);
 	}
 }
-- 
2.44.0

