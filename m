Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8040A131195
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643307; cv=none; b=ZbwoEkr5o3DRfgZEW9L2RTttersyWQO4JFJlkPJaVv4GXmVO+H6v0bG0064pHb0yjspFpVs9awavrfFCHyEV1Gcff13ApXdUddSINIIUR3eMk+rNUUgbqYYRZoVlVBhluluajUntGpGkaYhq/7g3SXe3gbIE6GDt/Nzl5Fx7mvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643307; c=relaxed/simple;
	bh=XAPDGw5vqm4R68C0iiGxVia58si6InFh20Tr6Ma0z9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swF7YadiDJmVMazQSsi0Emdig4kP85uYeOo96DAA2GPByDswJQh0SyslGddpg6P1Qil9RQv6KverS31wLf/Pd+w/bsgV0XbDE5FZBrdy0MtMjmtw4xb5ZXqupPstgmp785UzDCIvy1ISzqqBX1hCU3jeAm8rY0azMF0hPAJyqBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dboYOX8h; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dboYOX8h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643304; x=1743179304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XAPDGw5vqm4R68C0iiGxVia58si6InFh20Tr6Ma0z9k=;
  b=dboYOX8hHthvpeqneJqV07YxG4AkgddLGTj2+dmgIEgWIo/IqjffS1aN
   15YSf+hodbpEZ9GczVPBh/r24IzMvDh4ToeC+Tdrp7atS2YcC34uzM8tj
   qBMfnsCaQ1aziVRABOHQYVP2bhHb0LVzP4PsdEq3yMxdQ476nbSiz8/yM
   joS7B1RVAqAVVeeyQ6xLegXKuLk2vgn8+Bo454k7IWO7JQWCWAUasyiRo
   eN170hq8xjozG6rGMpQBCv3FVamAtD/rhSgeRSTHre7ngL1mWq1dqVr+p
   eyRDiMrmC45u0iz+DncinCpl3iXf+nujpICJfCp5mB2Kph1Y6Bgpk9C4R
   g==;
X-CSE-ConnectionGUID: Oon4mBXkTWi4d38z12uqpw==
X-CSE-MsgGUID: lkAH6IW2QvOgpMaiVQbqlQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294726"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294726"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725963"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 07/74] x86/cpu/vfm: Update arch/x86/events/intel/lbr.c
Date: Thu, 28 Mar 2024 09:27:01 -0700
Message-ID: <20240328162820.242778-7-tony.luck@intel.com>
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
 arch/x86/events/intel/lbr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 78cd5084104e..86277196ffad 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -2,6 +2,7 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
+#include <asm/cpu_device_id.h>
 #include <asm/perf_event.h>
 #include <asm/msr.h>
 
@@ -1457,7 +1458,7 @@ void __init intel_pmu_lbr_init_atom(void)
 	 * to have an operational LBR which can freeze
 	 * on PMU interrupt
 	 */
-	if (boot_cpu_data.x86_model == 28
+	if (boot_cpu_data.x86_vfm == INTEL_ATOM_BONNELL
 	    && boot_cpu_data.x86_stepping < 10) {
 		pr_cont("LBR disabled due to erratum");
 		return;
-- 
2.44.0

