Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7991181D1E
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495899; cv=none; b=CkBujT7NMj9o5ZODjnbtSX5oc4kBN3z99UaR534hgzzu8CzmA1FbtKfMThgVSe+H12wzDjVNb7A9i9bqPo8kFza2gtc/twjjDvsMT4OkU/NeU7SnpxXdY87517KnoA2uCy4ZWtoMxFpgBWTFlkCRhxKsrot4eS/nSqjmotqoTKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495899; c=relaxed/simple;
	bh=DsTxdChN/mYCzh9I4OyIgdX+q2TnrHqwbKbjQIoRaMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRVFxIcatYFSMxep9GFXemjiBCFm4bt2KExAtEufipWiG6PGP32eik3FfZfbqlk2RcKPYedLvTItLWrznoTX9SPW3x36Rm5TKxY/xW24Mjxvxbvkpv9PXNC90hKusU0ErUJYlUtMXpawi5bLDrAVC6WdaCZj2JBc0aGB8GG2nmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hr4rHy0X; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hr4rHy0X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495898; x=1746031898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DsTxdChN/mYCzh9I4OyIgdX+q2TnrHqwbKbjQIoRaMw=;
  b=Hr4rHy0XXcm2z9c7oMSTWk5SDrxDte68EqKVlNL2QCaIRzVWc4tCBVWy
   7tJJNWYBakoUuCdxgIao6Q/IQi0OfE6woAd70Yxbb8rzpbYpQzRsDv6cB
   mYTKHde50dtS8NmpVRFwWq22zyvpY9rA2qOztzjo8yrD7KrxNkY+65S8b
   kPX+O2djXmvFnY2Y/bSU54cP+Od3gG5fX6VskH4Uz5/YTKSM5pId+ln7X
   OVcO7cC1pFn2tOKywVS1FpaXu4DybxA4WvsSGhMb6YCrzX0NdEGoBzh3E
   fpetAN/EqvBOZu5Q1w+vxalh6gflORA2xAu+V3cnGrL1vinBV58lhr/cD
   A==;
X-CSE-ConnectionGUID: mMxfjNboRDyYzBIJYT35AA==
X-CSE-MsgGUID: 6Vp3W0CKT364N8c/ccORSw==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075664"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075664"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: zIfRzOLYQUebOPWcl77RSg==
X-CSE-MsgGUID: oSD0ksI7S2S8/uEMliVl+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515446"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:13 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v5 17/47] platform/x86: intel_ips: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:30 -0700
Message-ID: <20240430165100.73491-17-tony.luck@intel.com>
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
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel_ips.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index ba38649cc142..d95f686e0515 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -62,6 +62,7 @@
 #include <drm/i915_drm.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
+#include <asm/cpu_device_id.h>
 #include "intel_ips.h"
 
 #include <linux/io-64-nonatomic-lo-hi.h>
@@ -1284,7 +1285,7 @@ static struct ips_mcp_limits *ips_detect_cpu(struct ips_driver *ips)
 	struct ips_mcp_limits *limits = NULL;
 	u16 tdp;
 
-	if (!(boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 37)) {
+	if (!(boot_cpu_data.x86_vfm == INTEL_WESTMERE)) {
 		dev_info(ips->dev, "Non-IPS CPU detected.\n");
 		return NULL;
 	}
-- 
2.44.0

