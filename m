Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EE9131E2C
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643316; cv=none; b=pvWhJLX5T9a4mRxViTt+fsCefoWg88ytE4x2LEC9lJBiP2lFrDU5NyVGHgJgRVqThQGeQXSy2befJQlNOPb0CcUIC3Z5xZeDDjyJ38OGEL51tuE16pa8Cq4xGP+yIY8ZNRzivHh46dAop29qGnscIK8V6YLfcU6zeLwFeWQwBEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643316; c=relaxed/simple;
	bh=TH6/8w9pkWktCUcxRMlnQFc4unYcczUDErtWtr3bsHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyhFvkXRkw1LKHkxUwGgZdV+vH7l7orFqWJgRp0y2NLi0nw8kvUdt/UtVsqFTB6rkvXmmdMYurPs8Laa5yE+RftblMKGpZbZl4PEXbIDLFAbqvTNN/LvDEnAobbvXfzcCNkJ5yOIBxxTb2vFDpmyO5jPDQDpIz63TVgFKGxan00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KYt6d/Ke; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KYt6d/Ke"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643313; x=1743179313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TH6/8w9pkWktCUcxRMlnQFc4unYcczUDErtWtr3bsHw=;
  b=KYt6d/Keogcd4LHI98HhJcAb63W8lpk2uW9dq5lFUGCeqTTRLWK6TxoK
   J+lDfB68e+Lb01kn1Yc9NvGC+FYQHxht8sf9gh6SVR3QScCR2Ze09bdsF
   wzJhYxpy2/T7bcZc3WkAYHourFfd24hx4W5qt2xiNXHTgqdCgLGhIgwCx
   MdQB5X/SCj7dyIq7Sk/yk43kpiuzpkXkiAsxia2XQItag/yL1rQ1VH7/t
   W75VRg1J+yvdxIgRBuH45DF1RbOLcqCBZ0W+/SpCJtAbK2SfcTFIWINkf
   tXyDy9f9jfQtDex9gxGBaQbe2gsB3JBaSo6e+e6xZYPgpDMKJoOBOPQFk
   A==;
X-CSE-ConnectionGUID: OVoZYOSNSGyQcfjXYEOF7Q==
X-CSE-MsgGUID: 1h7BJt5NQeee/gprzEUZeA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294773"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294773"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726096"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 45/74] x86/cpu/vfm: Update drivers/hwmon/peci/cputemp.c
Date: Thu, 28 Mar 2024 09:27:39 -0700
Message-ID: <20240328162820.242778-45-tony.luck@intel.com>
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
 drivers/hwmon/peci/cputemp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/peci/cputemp.c b/drivers/hwmon/peci/cputemp.c
index a812c15948d9..28cec5c318d4 100644
--- a/drivers/hwmon/peci/cputemp.c
+++ b/drivers/hwmon/peci/cputemp.c
@@ -11,6 +11,7 @@
 #include <linux/peci-cpu.h>
 #include <linux/units.h>
 
+#include <asm/cpu_device_id.h>
 #include "common.h"
 
 #define CORE_NUMS_MAX		64
@@ -361,9 +362,9 @@ static int init_core_mask(struct peci_cputemp *priv)
 
 	/* Get the RESOLVED_CORES register value */
 	switch (peci_dev->info.model) {
-	case INTEL_FAM6_ICELAKE_X:
-	case INTEL_FAM6_ICELAKE_D:
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case VFM_MODEL(INTEL_ICELAKE_X):
+	case VFM_MODEL(INTEL_ICELAKE_D):
+	case VFM_MODEL(INTEL_SAPPHIRERAPIDS_X):
 		ret = peci_ep_pci_local_read(peci_dev, 0, reg->bus, reg->dev,
 					     reg->func, reg->offset + 4, &data);
 		if (ret)
-- 
2.44.0

