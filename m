Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9986C13C804
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302411; cv=none; b=Y4k7q2fzi+0OmGEt2595o8Km1Zz8p2n49M08TmILmmIJZD4K8mt97Qfn7OZ4d12VZwk6nlBzDnqV7SCwh+reHiNO1LQPyZhu3rcuw1wfP4F2Pftkzupe/0ScYU1flwiq91GO0oKDUFPxzn6mxibBMxmJI9az1qt9uqi649QU8fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302411; c=relaxed/simple;
	bh=+muWR4/mEwwLXtJHfxut/jEkspNEEcrpR5BzFhJ1KYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpZHhiMta6EBI05UCxoz9HtGlLUHF2TPCrr/vYwCAGqDDdW+E1TzcT66CBixpFm4Fh6mkVr/G+lNG5p6DMXREzU0XHXcefxAm2sqPz7pnXiBO6lX/MwIfL0HgvhXki1EQHhXQH2i0pnYAtEwYhEQtTY+Tw9W2rAuHsZHQu5wzn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2uYuaFE; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2uYuaFE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302410; x=1744838410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+muWR4/mEwwLXtJHfxut/jEkspNEEcrpR5BzFhJ1KYM=;
  b=E2uYuaFEmQMktC9ZyPHeoI56zuvXKqkLKooN1CCpoG/EaSE4MiCKYg7Z
   +vgFIiooIa+gmf2EVnQ8W5rB2wWu8vxMqUjLQpDLSt3QmxO5bZHKTl4b0
   EXObMJGOx7/aCTo1nZNb9GkUHDGDpaysgIxfSdWilPEJeqiGU2loLhpOL
   aQrK0PmT+ySwq9TdyA63B8R7v6PgHJJqtJ4VhTqLITmXnOy7y8X8cHNJw
   ZCDMKR+YyuPkdNQ9S+5WGtbTWEfQH9cF1xt+Mwe0TBSdSFQvNXh/iXFmj
   dPhnzXhLyMu5EYemozQ0P6ALRuGkHCTY2N3b4s/wPmx3nH2WriQbKjMlm
   A==;
X-CSE-ConnectionGUID: Ft0P1e0xSLeBHz/hK/gRdQ==
X-CSE-MsgGUID: ZkJRDEToS+awp+roncMsWA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914788"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914788"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
X-CSE-ConnectionGUID: O1nCF40FT2CrdwbD3nwUgA==
X-CSE-MsgGUID: jHZWh8ZKQGmx/oHrXFnxaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871967"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 25/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/resctrl/core.c
Date: Tue, 16 Apr 2024 14:19:27 -0700
Message-ID: <20240416211941.9369-26-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 83e40341583e..863fef5e55a4 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -22,6 +22,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/cpuhotplug.h>
 
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/resctrl.h>
 #include "internal.h"
@@ -821,18 +822,18 @@ static __init bool get_rdt_mon_resources(void)
 
 static __init void __check_quirks_intel(void)
 {
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_HASWELL_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_HASWELL_X:
 		if (!rdt_options[RDT_FLAG_L3_CAT].force_off)
 			cache_alloc_hsw_probe();
 		break;
-	case INTEL_FAM6_SKYLAKE_X:
+	case INTEL_SKYLAKE_X:
 		if (boot_cpu_data.x86_stepping <= 4)
 			set_rdt_options("!cmt,!mbmtotal,!mbmlocal,!l3cat");
 		else
 			set_rdt_options("!l3cat");
 		fallthrough;
-	case INTEL_FAM6_BROADWELL_X:
+	case INTEL_BROADWELL_X:
 		intel_rdt_mbm_apply_quirk();
 		break;
 	}
-- 
2.44.0

