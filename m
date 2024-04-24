Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8651A17F39A
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982519; cv=none; b=Yt35n6Bz4jk02yAIs9uX+DpTUxQbgEvJuTrH0YBImXefEKIVLW5d67zvrdRuUpZAQ11Cz8tVG8hztsia3jPqDGoYYL1Vmy0aRZIFT6oNBFPIYz8hKGWRNfCOTITdndjv2Iedtyp9Ufr8BFmuH0sNF/R8U5QXNdm/fUxX/rTc2YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982519; c=relaxed/simple;
	bh=MQ97iLFFbgxQYCiSBsEDrW3R5WSpsqJ/JU/KTZPQ0ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lh9aPFZluNv+dPamBNzD5G5dAVGa4pYxserUGg4mlyf7oc2nDCISs14dE5CkDgM1oBkm9ByoyJY4Ql6r0/VnmI4MHqpym6fWqvLSCdWXzRG9XzNmQdGwvrY2U1DiqJ/nH8pvU9uGmVr2KUMzroYWcu0PKlBUCqypXsQsCrE8wvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SRpFXisU; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SRpFXisU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982517; x=1745518517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MQ97iLFFbgxQYCiSBsEDrW3R5WSpsqJ/JU/KTZPQ0ow=;
  b=SRpFXisUExcoEVnMpDDGla3seTIZ4eMnxhTLa7ma1YswDfJuAa007kDD
   Uq3NjvXeVXXbQC9n/jDokItXup1woq5gQqokhTB0GGXABM+8TJLToEtiR
   jwaaObWkhYJx6HNIMg74IgDc7iVCfGT0ZQdQrMJJt62OUyWcCR+S4y6U+
   WNfmDgZ1sZdRsUJ5dYXX5o7EBVMHQF0vZ3/WT45vzJN+iWBZmj+ubU3tf
   FiXj/dvG86NQIHnoSdrfFgwvxqu2dMrIaxHDaO0nxiiDKqqZ4DN2s38pb
   cLGa599FLglvq764DHgrtapMFglNkweQDmVzPJupt1NS6vGc6x1lnpwcK
   w==;
X-CSE-ConnectionGUID: pldYl2BGQlCTadoOfqbg9g==
X-CSE-MsgGUID: j6BHwCuSSA6GmNuek4CVfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481951"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481951"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:06 -0700
X-CSE-ConnectionGUID: NQGb3yeuSbW5JeWJ/NDD0A==
X-CSE-MsgGUID: SMvjHHtTQJySvBszTAF66A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262700"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:07 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 27/71] x86/bugs: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:06 -0700
Message-ID: <20240424181506.41673-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/bugs.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ca295b0c1eee..32d86dd976c0 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -26,7 +26,7 @@
 #include <asm/msr.h>
 #include <asm/vmx.h>
 #include <asm/paravirt.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/e820/api.h>
 #include <asm/hypervisor.h>
 #include <asm/tlbflush.h>
@@ -2390,20 +2390,20 @@ static void override_cache_bits(struct cpuinfo_x86 *c)
 	if (c->x86 != 6)
 		return;
 
-	switch (c->x86_model) {
-	case INTEL_FAM6_NEHALEM:
-	case INTEL_FAM6_WESTMERE:
-	case INTEL_FAM6_SANDYBRIDGE:
-	case INTEL_FAM6_IVYBRIDGE:
-	case INTEL_FAM6_HASWELL:
-	case INTEL_FAM6_HASWELL_L:
-	case INTEL_FAM6_HASWELL_G:
-	case INTEL_FAM6_BROADWELL:
-	case INTEL_FAM6_BROADWELL_G:
-	case INTEL_FAM6_SKYLAKE_L:
-	case INTEL_FAM6_SKYLAKE:
-	case INTEL_FAM6_KABYLAKE_L:
-	case INTEL_FAM6_KABYLAKE:
+	switch (c->x86_vfm) {
+	case INTEL_NEHALEM:
+	case INTEL_WESTMERE:
+	case INTEL_SANDYBRIDGE:
+	case INTEL_IVYBRIDGE:
+	case INTEL_HASWELL:
+	case INTEL_HASWELL_L:
+	case INTEL_HASWELL_G:
+	case INTEL_BROADWELL:
+	case INTEL_BROADWELL_G:
+	case INTEL_SKYLAKE_L:
+	case INTEL_SKYLAKE:
+	case INTEL_KABYLAKE_L:
+	case INTEL_KABYLAKE:
 		if (c->x86_cache_bits < 44)
 			c->x86_cache_bits = 44;
 		break;
-- 
2.44.0

