Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA37512DD92
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643317; cv=none; b=b5os30DLNWCuGK+1KQAhmY4pi99gHCgWlSzFKVqWLL6r5ZFfFo+fVxvCe1KZuRO25ls3svU/lC7B0gz/00jvwTewIG4BodFaMp2AkpUX1enVmnXOwpi1dShbOhRY2k8YzE6ZQiWmcgQpH9h/Pq+dfaEvG1rGayqsu8PjRenmIDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643317; c=relaxed/simple;
	bh=2gPGaDcRT5gcL/MB7CRiRDvqupdeUr0UkHk3k5ZMu6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXWSqnpOiwLGbKecGCGEZQ0I9WKkSnTu5DB4dRZmhQtg5hQFsIvQqhUyhkSAjs5WXOJ2LyD+2ohIkAzAqs5PfVQnzT+Gr/OxCCN2poBTWWLgOQdea5DpAFy/qEPvKT1Wdsa6VaHqsF+Ey3OCjlE/FzHnp2wgmH0Wp8VfNVh4lr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kaXob34v; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kaXob34v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643314; x=1743179314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2gPGaDcRT5gcL/MB7CRiRDvqupdeUr0UkHk3k5ZMu6g=;
  b=kaXob34vS9Vyhu3MDEYJzWWRRk59Rd9a7Lm0P7AvM2DjemNXEXyAWQIV
   eRte243JY5tEb2k5TeJ7VF3Hw7+J7s5hzAlh16wNkRSzp0PKpzoUx1ZKi
   9v5rYch79x1sdUWMn0QqhH7i+WeGK7Y4NNvK26eIj5F89bIMQX9A87IrJ
   cUgWujGzd4w6ihJhf+WMqPfHBECL7iUi5Dvjn7kWlgZtDNpVVszZvOchl
   w19sAj7mz2WaDRtjK+y/yK8cSEAMwthdv0kQosEVRBDIiwfj7Nk53RvqO
   w8KkVaM6qlOU9hU4JxjXrgfkzgoAFoGTN1EixzkMAMBTZ1MlzTLkJoVCZ
   Q==;
X-CSE-ConnectionGUID: i/9hhvH4RYilayb29YHknw==
X-CSE-MsgGUID: CNWnA0RcSz6NkcZ2ISVdNg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294777"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294777"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726106"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 48/74] x86/cpu/vfm: Update drivers/peci/cpu.c
Date: Thu, 28 Mar 2024 09:27:42 -0700
Message-ID: <20240328162820.242778-48-tony.luck@intel.com>
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
 include/linux/peci-cpu.h |  1 +
 drivers/peci/cpu.c       | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/peci-cpu.h b/include/linux/peci-cpu.h
index ff8ae9c26c80..2c972b728524 100644
--- a/include/linux/peci-cpu.h
+++ b/include/linux/peci-cpu.h
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 
+#include "../../arch/x86/include/asm/cpu_device_id.h"
 #include "../../arch/x86/include/asm/intel-family.h"
 
 #define PECI_PCS_PKG_ID			0  /* Package Identifier Read */
diff --git a/drivers/peci/cpu.c b/drivers/peci/cpu.c
index bd990acd92b8..8e8292c05551 100644
--- a/drivers/peci/cpu.c
+++ b/drivers/peci/cpu.c
@@ -294,38 +294,38 @@ peci_cpu_probe(struct peci_device *device, const struct peci_device_id *id)
 
 static const struct peci_device_id peci_cpu_device_ids[] = {
 	{ /* Haswell Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_HASWELL_X,
+		.family	= VFM_FAMILY(INTEL_HASWELL_X),
+		.model	= VFM_MODEL(INTEL_HASWELL_X),
 		.data	= "hsx",
 	},
 	{ /* Broadwell Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_BROADWELL_X,
+		.family	= VFM_FAMILY(INTEL_BROADWELL_X),
+		.model	= VFM_MODEL(INTEL_BROADWELL_X),
 		.data	= "bdx",
 	},
 	{ /* Broadwell Xeon D */
-		.family	= 6,
-		.model	= INTEL_FAM6_BROADWELL_D,
+		.family	= VFM_FAMILY(INTEL_BROADWELL_D),
+		.model	= VFM_MODEL(INTEL_BROADWELL_D),
 		.data	= "bdxd",
 	},
 	{ /* Skylake Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_SKYLAKE_X,
+		.family	= VFM_FAMILY(INTEL_SKYLAKE_X),
+		.model	= VFM_MODEL(INTEL_SKYLAKE_X),
 		.data	= "skx",
 	},
 	{ /* Icelake Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_ICELAKE_X,
+		.family	= VFM_FAMILY(INTEL_ICELAKE_X),
+		.model	= VFM_MODEL(INTEL_ICELAKE_X),
 		.data	= "icx",
 	},
 	{ /* Icelake Xeon D */
-		.family	= 6,
-		.model	= INTEL_FAM6_ICELAKE_D,
+		.family	= VFM_FAMILY(INTEL_ICELAKE_D),
+		.model	= VFM_MODEL(INTEL_ICELAKE_D),
 		.data	= "icxd",
 	},
 	{ /* Sapphire Rapids Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_SAPPHIRERAPIDS_X,
+		.family	= VFM_FAMILY(INTEL_SAPPHIRERAPIDS_X),
+		.model	= VFM_MODEL(INTEL_SAPPHIRERAPIDS_X),
 		.data	= "spr",
 	},
 	{ }
-- 
2.44.0

