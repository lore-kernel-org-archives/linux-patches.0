Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2559517F4E5
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187837; cv=none; b=M+L+mvyDiHJo7ilo3cps/4glqWe2HKklbRifS/EmNGnnya0XPBlgUHIUllCFPquBopFNirhzO14q0yQNE+PsEFram8Yo+36R+kJryieaPdQHo/j2yadEIuuOh4Odk5taJO34Cvog1ZNkaQJemxnYi7tAG54Vne5idDUlKnpUFZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187837; c=relaxed/simple;
	bh=Q4TosjeGaAlesFOvhOKuWq462U/pe+hYmovI9Y0U2Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRhPtghSS9RdZtBuGeeHzS26duxO/ptn168BaaIceuIkkhuatCOwE4xJrEn9en6w50aBMxntk78GWUzyisUJ7SL5oAa3MnI9wgq9UqEZR3KX/tob6E/Zap7SaxnzzXZ3anhnWKRNzEr4JpybLra+1ZAQnaS8theEEwrQ6lF8eGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GoZzffMv; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GoZzffMv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187836; x=1748723836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q4TosjeGaAlesFOvhOKuWq462U/pe+hYmovI9Y0U2Eg=;
  b=GoZzffMvppiBbiRLPjn5ZYlnjTjqV36/bbDx/WhX7PwJM+17Fp2oS+7D
   y+Uo4fbTSA0XKDO8oSELo1fVs2sGqudyIkqiB84Da11eazXp+r0m2rz52
   UKICMG9fBh1hFeJP1j/6mcrby17ixIrbP5w+DWHqcLBtvYDsS/jkRJSYU
   3sPbAiTdYsjhAi3F2Nozf1+/qETm3z0eryxRkJkDyt8IE+N4fkdqi8kxl
   v33nGRH04pl+bvWqd3a2MsKLrB5SlBeqiFTRWRKF+QRwoBN1FnezV8OCD
   gy0reRFrdtQ7tSE26Q3FAnW2qSZnJcxKU9YuhEKceZTAA9ERMkOlrbVJh
   Q==;
X-CSE-ConnectionGUID: wcb0Hj7AQYmg6uYZ70djdA==
X-CSE-MsgGUID: IqQXdFgARsWjkJgOKAesjg==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871844"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871844"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
X-CSE-ConnectionGUID: QgW8GW6hTKCI0O6rhvGZ5g==
X-CSE-MsgGUID: vt3AL+dHTxut838gqmSVoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355387"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 06/11] platform/x86: intel_ips: Switch to new Intel CPU model defines
Date: Fri, 31 May 2024 13:37:02 -0700
Message-ID: <20240531203706.233365-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240531203706.233365-1-tony.luck@intel.com>
References: <20240531203706.233365-1-tony.luck@intel.com>
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
index 73ec4460a151..c62c3c4ec20a 100644
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
2.45.0

