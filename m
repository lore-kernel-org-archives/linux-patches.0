Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75B47CA6D
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198280; cv=none; b=tfBTJrsORtfar4We7flluJdQgqnhW1sd68Ec5EK4hOsv/uju+z7L9s3Nz6Lde6Obv/uXo0aBXyNzJF8HqpYp2kjPOG9rJcly3UsWCgcG3b7wrNW8MLq36X2lLSX0x85/BCbNK6WiW2rt4GNM1gtuEd0NSQvkF/D+RY9rfrrvpLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198280; c=relaxed/simple;
	bh=loyzFr+JpL4qX/bD5i+tb6CktIi0lN31Z3JzQIP9+ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cV27RaBvSYhwZ+ezWeyNvEhuNxWxXgPs6jiVc7woL3JtVYthVTJ5sDWBmPD8BB6Dq+jpf+ccRc6ZewIRLbVLZ0b4c/nb3qHcqEzcTKCDOoPXC/RxykwpGzoRJ/XaGn+pUOp+5dHwDpwhB9Jh05LttvJlznCzsAFAUGGJVtinOew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZDp2vKl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZDp2vKl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198279; x=1819734279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=loyzFr+JpL4qX/bD5i+tb6CktIi0lN31Z3JzQIP9+ME=;
  b=NZDp2vKlVuysqDD0vaV8iax+BcRpMcwQwYVly8YXVN108iYRcG7/WqYu
   FRMlfo3ZVcBI5mWKmxM7cIsCyit0e9LaJ+hrtwaFEjp8Igf8sBbsFeKS4
   fpUEzIwgr53UreKMu5MZWgGopiy3mEl4aG1fW7ITJkV251aKGAgyoC+u6
   3N5f6pE1oFim6qgIVesbx5G7rZkXCS8762UKgdem4U9alj7s9kpbjCq5c
   bzt1Bb1lU2kRSiMR0C4SSAov/byUC8QibtttjhRV+HFxzuHoj0rQmV2Lt
   GpEIF8seTFHJJ1CW9fkNpZ/HFdWgB6JMdMdqIyK0Ktd9ujfbGO57ntXnD
   w==;
X-CSE-ConnectionGUID: T7EZWGcwQbOqBKPfiAhsAQ==
X-CSE-MsgGUID: GCATbjbaTYiYVRaI0l6z4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92479978"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92479978"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:35 -0700
X-CSE-ConnectionGUID: ug2pxWH8SGqH8xHhqFr0sw==
X-CSE-MsgGUID: dSOXmEC9TgObpAK2DfUHCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906969"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:34 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 08/23] x86/resctrl: Delete rdt_alloc_capable and rdt_mon_capable
Date: Mon, 31 Aug 2026 10:44:06 -0700
Message-ID: <20260831174421.13921-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These globals are no longer needed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
v11:
	New patch
---
 arch/x86/include/asm/resctrl.h        |  2 --
 arch/x86/kernel/cpu/resctrl/core.c    | 15 +++++----------
 arch/x86/kernel/cpu/resctrl/monitor.c |  6 ------
 3 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index fb6cfff82e2f..49b5357e2e5c 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -42,8 +42,6 @@ struct resctrl_pqr_state {
 
 DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
-extern bool rdt_alloc_capable;
-extern bool rdt_mon_capable;
 extern unsigned int __ro_after_init rdt_l3_mon_scale;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 62b97e357ce5..e851da431dd9 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -45,12 +45,6 @@ static DEFINE_MUTEX(domain_list_lock);
  */
 DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
-/*
- * Global boolean for rdt_alloc which is true if any
- * resource allocation is enabled.
- */
-bool rdt_alloc_capable;
-
 static void mba_wrmsr_intel(struct msr_param *m);
 static void cat_wrmsr(struct msr_param *m);
 static void mba_wrmsr_amd(struct msr_param *m);
@@ -786,7 +780,6 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_lock();
 	mutex_lock(&domain_list_lock);
 	r->mon_capable = true;
-	rdt_mon_capable = true;
 	for_each_online_cpu(cpu)
 		domain_add_cpu_mon(cpu, r);
 	mutex_unlock(&domain_list_lock);
@@ -1026,10 +1019,12 @@ static __init void check_quirks(void)
 
 static __init bool get_rdt_resources(void)
 {
-	rdt_alloc_capable = get_rdt_alloc_resources();
-	rdt_mon_capable = get_rdt_mon_resources();
+	bool alloc_capable, mon_capable;
+
+	alloc_capable = get_rdt_alloc_resources();
+	mon_capable = get_rdt_mon_resources();
 
-	return (rdt_mon_capable || rdt_alloc_capable);
+	return (mon_capable || alloc_capable);
 }
 
 static __init void rdt_init_res_defs_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 0bce199a5f7b..bc2df287ccfa 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -26,12 +26,6 @@
 
 #include "internal.h"
 
-/*
- * Global boolean for rdt_monitor which is true if any
- * resource monitoring is enabled.
- */
-bool rdt_mon_capable;
-
 /*
  * Scale factor to convert L3 monitor events to bytes.
  */
-- 
2.55.0

