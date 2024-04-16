Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004DC13FD66
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302415; cv=none; b=aNWhN4/F1VdNiXiS0pewleTundZ0VNOypAnOyyKjHRPi5uYwIz5znAKd4KFzFgoRYrpUywcoArpUNbyqtzxzhJrwYZZtoqpSga1l2vKgCSo1XW4+WJWOzPcmv/BfCJ5GkhrNXsbJvPduShSJpj1zxx2kzD9HlD0bKY5yJ+ZDz+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302415; c=relaxed/simple;
	bh=7admVmhZ4o2F2ASVUVilv4irbHkYcisALjnpaLiV9rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deg8Cc9nwS3JOIB4Yw7aknJSYu7ACS8vZfq70OlgnNf1PsTaiTzTnEaIXV5JAEdeIww02QNn1t1teF5g0AE//iCziRrGuI3gsKuu7ot6Z9vNlWDRjRq1XiJaokWVJYL1NwJegX+mspK9SO2Q7MyRaA7Dp7926z7EcxFZF8YDv8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LnqBpfKU; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LnqBpfKU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302414; x=1744838414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7admVmhZ4o2F2ASVUVilv4irbHkYcisALjnpaLiV9rc=;
  b=LnqBpfKUh+YTUDYp7z4bNVSU0+hkciVdvzj3aQojuIb7dDr5zG454Q66
   UVlX45ZbawgUNMQPIfUo3HMKrxrxsfXW7S1Y/U1Cti1xeImvL2tpLDvyS
   DAcFks4RvlmEVyRl+NlPn9P6/0ln4lLDR/q01sZORBlE5ftwLalgLjbgu
   1D4WM+BCTV9oPmNKUiPNzybnC45GJyZcxPjZby59s/mT7j6n699azkqol
   gau8i7U7LB3Hy//fP0HfqgHWQ6wGR/VBjiiYjhNm4BgQ0OgeQBbMiz2us
   yVHjJjpnP8WIsrOeyBNMrcBdvKhFQJY1SBwCl/vtrZrAGNZBONcXwFhWr
   g==;
X-CSE-ConnectionGUID: NbBsjFHJQTWEU/VaGgn3Vg==
X-CSE-MsgGUID: Ij1df4fxT6CyOx9tBU7eCQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914833"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914833"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:02 -0700
X-CSE-ConnectionGUID: ExIjNerlR+WsiyfRutxmZA==
X-CSE-MsgGUID: gN5YpAZITBeT08TkUuVuzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22872036"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:02 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 34/74] x86/cpu/vfm: Update arch/x86/virt/vmx/tdx/tdx.c
Date: Tue, 16 Apr 2024 14:19:36 -0700
Message-ID: <20240416211941.9369-35-tony.luck@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 49a1c6890b55..3d22566c9b55 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -33,6 +33,7 @@
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
 #include <asm/tdx.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
@@ -1426,9 +1427,9 @@ static void __init check_tdx_erratum(void)
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

