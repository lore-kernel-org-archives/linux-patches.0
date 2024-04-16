Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44958152DE4
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302544; cv=none; b=LNGBt83UkGnaA5plRUL12a7yD2YcPZbpEZewv5LuK9h7gJbYK246bMD6JOrJtZxsbRM1TdSuRNNdEjXT5B9ksdapAUfc9vgeSVwaxJjMK5ZHsjZaW3UcO5nVP8MajjCWgJmYxnIMFg7aCHysj+8T7ACtGKwu7trY71QqRJXLriM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302544; c=relaxed/simple;
	bh=2gPGaDcRT5gcL/MB7CRiRDvqupdeUr0UkHk3k5ZMu6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuO4PDJIIOoDCy3amV6RE36/gd8ZZ0EoMy4oI7xQOh8fh2PckrbhGOGuMDTyEZjO8jZkY+Lft565FQtYNJhZwwf/uX1HzQJ2R4Sce8Lo/u2Rte5+qX/FL+Gyg/D+T26TGwviD1q6IV1lVizWtb4aKIh1RGN5LvvmrSg4cs5FxAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZXMwFoTG; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZXMwFoTG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302544; x=1744838544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2gPGaDcRT5gcL/MB7CRiRDvqupdeUr0UkHk3k5ZMu6g=;
  b=ZXMwFoTG4jw5Aw9XKXiovyAGrw/lt5eocwvmEt3fb1CtWKC+x6FCahEJ
   S4b2toU5M+Ci4ebloJaGtKa18DXyee84aaHyuJSpPlAemTaY6oUBEQbXt
   Ojoer9Ps174uiZzKYSJ9RYBYd137Pim7ldLTNdbmpief6VjIoQApxRaLy
   JfHUswhJbqDyQ3+1ixl/ckh8CG5tuTzMr3OVOdwTg2kZGJWY61Q47uxiW
   l0XRpoYqR90Ty11rUrR1GsR056Od6eSGYkL8O3SMOtw93hiFtPbolrske
   chdHbogGxKH/90yclngfS4CLOMMMqgih7i+pEuOlH4URXeAIIijxwL61v
   A==;
X-CSE-ConnectionGUID: lmET2YuWTta5vwKBxOT+pA==
X-CSE-MsgGUID: bcRjRRkESHmd5RnCqzy/rw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="26234925"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="26234925"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:23 -0700
X-CSE-ConnectionGUID: Pi2uSVG5SZCFXfiEfYLbUQ==
X-CSE-MsgGUID: HaRXpSXaQd+o5xzaVUPZtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22267095"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Iwona Winiarska <iwona.winiarska@intel.com>,
	openbmc@lists.ozlabs.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 53/74] x86/cpu/vfm: Update drivers/peci/cpu.c
Date: Tue, 16 Apr 2024 14:22:21 -0700
Message-ID: <20240416212221.9662-1-tony.luck@intel.com>
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

