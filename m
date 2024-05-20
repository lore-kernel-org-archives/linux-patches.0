Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822C613AA5E
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245206; cv=none; b=GeAjQ5ZQYlM7aT5cWoFZj9FpC3kYS4T63tTz98ixShmyGiS+ZrQcpfPRD21HTce+0Hz5PiAWmVFu2d74h4WiDqiaI/C3RENV9Ly7Xv1IC45OT9Kmk4j9xXQXAB+GgSeIdif+ikFqMyYX7DhLZIo/j30Kbm2PByUjR8B9HtyY7dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245206; c=relaxed/simple;
	bh=32OovBnI96Pt8u6y2/ExOjFMxT/hkeFmHDurbkDaicI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDPUEu89LT3eL+eegMBruAt2xp0U05sso252ndOxHxEWHYvooDdblru3FRGIP+Xtb9sBeqqLdqMCtt978EI0fzbCDpBtX+O9DZsFFIK+62cE5bfdVz3J3r5L96MOgYAo5LpLcGs3Shi1oQCW6Jr4EB6LTOg6EcqzN1Z5g8GIxM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UWCJ+Pbe; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UWCJ+Pbe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245205; x=1747781205;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=32OovBnI96Pt8u6y2/ExOjFMxT/hkeFmHDurbkDaicI=;
  b=UWCJ+Pbe2ygY9bC4X5/HUjISHedDXrSjFX0lirLQSWBKj6n+b5PoJx1u
   JVOLQyKSPTgn47RPFAF0ZMmbsw0fxgcHddxh3tgYiTZ5z9HE+5LqMO1t7
   lmxSrcyFQJnoLogsLht+mhN8dFDf/0Jca1OKsz0QaY/wS+qT15fOwUD+i
   3V5bDprb9e9FLqmUKFol5IyYPZ4hHZ5+p+8/1BOfeTwCfgj0LnFPe8uuf
   J1rvbmROUv3xPVzssokvqFbErFDlToGr1u9Dc2IxpKEYvpxomZ/kKXJgR
   SwuoMNmt2+jRxaoDdZVVzbf4CX/vY/S9e5f91nT6PSfEWh+ypI8uzPwdF
   Q==;
X-CSE-ConnectionGUID: /OaAjWBTQSGgFc/MuhjJcw==
X-CSE-MsgGUID: 5w92R/n6SN+8laoHNAmSYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199714"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199714"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:37 -0700
X-CSE-ConnectionGUID: /gZXDJriTOiKIdQcRhTJyw==
X-CSE-MsgGUID: 9XGSISLaS2Ku671oT+x9SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593439"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:37 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 19/49] platform/x86: intel_ips: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:50 -0700
Message-ID: <20240520224620.9480-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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
2.45.0

