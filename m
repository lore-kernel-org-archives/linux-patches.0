Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA6E8626D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643308; cv=none; b=Df/drR/H1Ea+gg4wEjscQubGAgb5M+yRrUZB6i0IsRnDaXnN8vGStYxQwemewCgP6f9AseRR9XdP5LqDjWTnmoCrKQjsY9f7aL8PpI3+S3cApSXQHeQBiMYBj/yskXha40Gdd+g7Su8PcUkeU/UyfaLQSXETKwdYbTm3M94m2aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643308; c=relaxed/simple;
	bh=D6uulQ3cLZc5mQiJu7bFxubPtVC+PN35kkiJSAvGK6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWzyLAwJ79F6hNlC8LI68rZVxaHZCULb0eUTbENZHWnhmna5XuySJIlyVEUhHgWtY27HvGU/o8oqfeJ906/IHQ8ZZ7nnFnWVx2NBHY/sHscT/8CzenQCJrUg4o+2+mXkunjoJbRLdYRlIS+xpgN9n5WG8rACZ4JELu7Bq2H6jUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XRCbTzn+; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XRCbTzn+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643305; x=1743179305;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D6uulQ3cLZc5mQiJu7bFxubPtVC+PN35kkiJSAvGK6A=;
  b=XRCbTzn+ClB4BmcBLyE2XfVH6nmMaIOdX6twSpDhhdee4TUCMemhAUn7
   IecbddjQHESRGJ7VhJTXa00JrpXnSgnwyylrKZXWxX7XoCNeUuXOywxW3
   Z5VdtimZcqoYF1yDkFuBB6+Q/Kk7HUmJ3wyD8y4xznjI2JYBy8DuoTRKV
   yMAZQtmP4nI5NHhpDdmSoK6DqygjBGxWvmg7iISoS/EMcqzI9e6ji+8Pl
   sC0Yeo2pESWlBXbVYsuo30vXJ3I4Ec1ETP9gyKFp7UA4CPzwPvOsIG0hv
   HFp4HzZjSn/HMUdZyntZTR/gyHsFtl0TnCnxLZ5QxBaYQDD/R8TxrK27e
   A==;
X-CSE-ConnectionGUID: QhlcVmcrR8yfY1W0pKz1fw==
X-CSE-MsgGUID: swQ0lQ/dTq+A15Uox98IPQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294734"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294734"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725983"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 12/74] x86/cpu/vfm: Update arch/x86/events/msr.c
Date: Thu, 28 Mar 2024 09:27:06 -0700
Message-ID: <20240328162820.242778-12-tony.luck@intel.com>
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
 arch/x86/events/msr.c | 131 +++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 65 deletions(-)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 9e237b30f017..19de4cd26de2 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -2,6 +2,7 @@
 #include <linux/perf_event.h>
 #include <linux/sysfs.h>
 #include <linux/nospec.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include "probe.h"
 
@@ -43,75 +44,75 @@ static bool test_intel(int idx, void *data)
 	    boot_cpu_data.x86 != 6)
 		return false;
 
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_NEHALEM:
-	case INTEL_FAM6_NEHALEM_G:
-	case INTEL_FAM6_NEHALEM_EP:
-	case INTEL_FAM6_NEHALEM_EX:
-
-	case INTEL_FAM6_WESTMERE:
-	case INTEL_FAM6_WESTMERE_EP:
-	case INTEL_FAM6_WESTMERE_EX:
-
-	case INTEL_FAM6_SANDYBRIDGE:
-	case INTEL_FAM6_SANDYBRIDGE_X:
-
-	case INTEL_FAM6_IVYBRIDGE:
-	case INTEL_FAM6_IVYBRIDGE_X:
-
-	case INTEL_FAM6_HASWELL:
-	case INTEL_FAM6_HASWELL_X:
-	case INTEL_FAM6_HASWELL_L:
-	case INTEL_FAM6_HASWELL_G:
-
-	case INTEL_FAM6_BROADWELL:
-	case INTEL_FAM6_BROADWELL_D:
-	case INTEL_FAM6_BROADWELL_G:
-	case INTEL_FAM6_BROADWELL_X:
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:
-	case INTEL_FAM6_EMERALDRAPIDS_X:
-	case INTEL_FAM6_GRANITERAPIDS_X:
-	case INTEL_FAM6_GRANITERAPIDS_D:
-
-	case INTEL_FAM6_ATOM_SILVERMONT:
-	case INTEL_FAM6_ATOM_SILVERMONT_D:
-	case INTEL_FAM6_ATOM_AIRMONT:
-
-	case INTEL_FAM6_ATOM_GOLDMONT:
-	case INTEL_FAM6_ATOM_GOLDMONT_D:
-	case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
-	case INTEL_FAM6_ATOM_TREMONT_D:
-	case INTEL_FAM6_ATOM_TREMONT:
-	case INTEL_FAM6_ATOM_TREMONT_L:
-
-	case INTEL_FAM6_XEON_PHI_KNL:
-	case INTEL_FAM6_XEON_PHI_KNM:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_NEHALEM:
+	case INTEL_NEHALEM_G:
+	case INTEL_NEHALEM_EP:
+	case INTEL_NEHALEM_EX:
+
+	case INTEL_WESTMERE:
+	case INTEL_WESTMERE_EP:
+	case INTEL_WESTMERE_EX:
+
+	case INTEL_SANDYBRIDGE:
+	case INTEL_SANDYBRIDGE_X:
+
+	case INTEL_IVYBRIDGE:
+	case INTEL_IVYBRIDGE_X:
+
+	case INTEL_HASWELL:
+	case INTEL_HASWELL_X:
+	case INTEL_HASWELL_L:
+	case INTEL_HASWELL_G:
+
+	case INTEL_BROADWELL:
+	case INTEL_BROADWELL_D:
+	case INTEL_BROADWELL_G:
+	case INTEL_BROADWELL_X:
+	case INTEL_SAPPHIRERAPIDS_X:
+	case INTEL_EMERALDRAPIDS_X:
+	case INTEL_GRANITERAPIDS_X:
+	case INTEL_GRANITERAPIDS_D:
+
+	case INTEL_ATOM_SILVERMONT:
+	case INTEL_ATOM_SILVERMONT_D:
+	case INTEL_ATOM_AIRMONT:
+
+	case INTEL_ATOM_GOLDMONT:
+	case INTEL_ATOM_GOLDMONT_D:
+	case INTEL_ATOM_GOLDMONT_PLUS:
+	case INTEL_ATOM_TREMONT_D:
+	case INTEL_ATOM_TREMONT:
+	case INTEL_ATOM_TREMONT_L:
+
+	case INTEL_XEON_PHI_KNL:
+	case INTEL_XEON_PHI_KNM:
 		if (idx == PERF_MSR_SMI)
 			return true;
 		break;
 
-	case INTEL_FAM6_SKYLAKE_L:
-	case INTEL_FAM6_SKYLAKE:
-	case INTEL_FAM6_SKYLAKE_X:
-	case INTEL_FAM6_KABYLAKE_L:
-	case INTEL_FAM6_KABYLAKE:
-	case INTEL_FAM6_COMETLAKE_L:
-	case INTEL_FAM6_COMETLAKE:
-	case INTEL_FAM6_ICELAKE_L:
-	case INTEL_FAM6_ICELAKE:
-	case INTEL_FAM6_ICELAKE_X:
-	case INTEL_FAM6_ICELAKE_D:
-	case INTEL_FAM6_TIGERLAKE_L:
-	case INTEL_FAM6_TIGERLAKE:
-	case INTEL_FAM6_ROCKETLAKE:
-	case INTEL_FAM6_ALDERLAKE:
-	case INTEL_FAM6_ALDERLAKE_L:
-	case INTEL_FAM6_ATOM_GRACEMONT:
-	case INTEL_FAM6_RAPTORLAKE:
-	case INTEL_FAM6_RAPTORLAKE_P:
-	case INTEL_FAM6_RAPTORLAKE_S:
-	case INTEL_FAM6_METEORLAKE:
-	case INTEL_FAM6_METEORLAKE_L:
+	case INTEL_SKYLAKE_L:
+	case INTEL_SKYLAKE:
+	case INTEL_SKYLAKE_X:
+	case INTEL_KABYLAKE_L:
+	case INTEL_KABYLAKE:
+	case INTEL_COMETLAKE_L:
+	case INTEL_COMETLAKE:
+	case INTEL_ICELAKE_L:
+	case INTEL_ICELAKE:
+	case INTEL_ICELAKE_X:
+	case INTEL_ICELAKE_D:
+	case INTEL_TIGERLAKE_L:
+	case INTEL_TIGERLAKE:
+	case INTEL_ROCKETLAKE:
+	case INTEL_ALDERLAKE:
+	case INTEL_ALDERLAKE_L:
+	case INTEL_ATOM_GRACEMONT:
+	case INTEL_RAPTORLAKE:
+	case INTEL_RAPTORLAKE_P:
+	case INTEL_RAPTORLAKE_S:
+	case INTEL_METEORLAKE:
+	case INTEL_METEORLAKE_L:
 		if (idx == PERF_MSR_SMI || idx == PERF_MSR_PPERF)
 			return true;
 		break;
-- 
2.44.0

