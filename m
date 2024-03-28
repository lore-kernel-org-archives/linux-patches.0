Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB52131195
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643318; cv=none; b=HeFjl2cyy1ZoJ5cChZlo6lF2rOhsU+9dWs5IiBR1VD/dzT63+moo3Fmq3pyiZvHH9dEFUvrpAh7A5EQje0gk2ciyA/xHz1ZJRpAP+GAjwP9DmCOsoOqoX+3InDdfe3cLrCV3I6rIisbbv0WgsRarE8smyCv/9kcJP/5qfI7npTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643318; c=relaxed/simple;
	bh=26W7AK4Uyulx7e8OguFS/2MgsGW9fO1MZTL4z9xDJQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSXyUjF2yCqk7zV8BHe6L+DCm6GW20p9odSc3uCbuOK3C3MDVW7WakB3PcJd3AxlwKty506QdiR0caNDS1j4agxwoP/AwGUpH8VNz+SG06S/ooKBv5yuWwEl6gtgWOHrXzU4oxFYvKgQn3c4R8h+avrB9LO1Pw286Y4NQGEiVB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=COhpon8h; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="COhpon8h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643315; x=1743179315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=26W7AK4Uyulx7e8OguFS/2MgsGW9fO1MZTL4z9xDJQs=;
  b=COhpon8hAuySZiLEwKErbWP2LPQM3/cUpK6+KcjE3r6614DdgVp+MJ0x
   XZtzWXP8WQ0Zx1Xn58LEXGMmHqGoa6RFm0mNYTl94fBI6NtloDaIKUCmt
   ymHr7mh1yJ/LP0xH8oCKNCJgHjcveB4y0QYuqIbCygWjqinzvxwJSGRCN
   3pyz/yF1Taid5Qrxd5BsX76X+C+1iCFesBMNiq1pcD1JxVjSO6ICBp+31
   Bs4yHXHQiQTkSHPSCmCe1ZI5pDp3HM8ybDtyTB/rZ3y51S4oxnII89l5a
   zRH34d6AMdz1YtxsVg4aAXJ6ElKYlPKZK1zoy4CJvTbc4e0FS3b2XCDHk
   g==;
X-CSE-ConnectionGUID: xAsGWmGAQtC5Ip/xeBa/2Q==
X-CSE-MsgGUID: 4u2QjMnTRA2ClV0cZMRC1w==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294780"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294780"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726113"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 50/74] x86/cpu/vfm: Update drivers/platform/x86/intel_ips.c
Date: Thu, 28 Mar 2024 09:27:44 -0700
Message-ID: <20240328162820.242778-50-tony.luck@intel.com>
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

