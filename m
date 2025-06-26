Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA6828C039
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956594; cv=none; b=nt4/vXATDtD0YG6UGSw7Z/+8Dbxeh5fExA8TGLz0hEGZgvilhaOetHlHp22duKi19COObasej6jco5n4heM5Wnakjvf7XyjM/932MbT+wG6f/pCAKVX72obGY3pTtysmlrQ/YCvXeybMpVQvlIZFYD6dAM0odWKBJNyMLh6M00o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956594; c=relaxed/simple;
	bh=ohU9oFXgklw2CWCxEtCjAVewl1W1kGyl4PI2z+dhjBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1Y4aq0bpSoNpvU2Be9S6LSdsGYX+4JQidRnuPWw+aS25Uvbo2vsKG/Bh9nqVKwpbl/UWWsWw9Ro4bGFAd94eTCz+O0eJgAA5PcP/qdY84+GPVQj4TowJsXWk6u4bKRNAZvgqg74uhhu9OLo5QjkY9yqdMNmZBza6PyWN7WcuqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NK5+jewY; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NK5+jewY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956594; x=1782492594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ohU9oFXgklw2CWCxEtCjAVewl1W1kGyl4PI2z+dhjBI=;
  b=NK5+jewYKm4baJcJKAFJ99iiWE1AzQvGN/LBNIA/pH6hRS7JoPAhYhQv
   ZvJg8BMulpw3XzeAyJfDIINS84N0Q+k7XtPlOo67b/SlRWlvlg7Di1pTs
   rm1IoU/fI7qlku1kbc7ZDoJbzeJq9RipbsaA56SpsTewr7dnUd/pes7ro
   ZdTIqAk2uratQ5ONMG9+GGzImZ7UHwfUGXSTC+MjfMPGwVOkVYsNb5Y47
   qFxvopNhzyWQ5Z/JCVR4fTs1wSRMrZUOmRClayXozZOGwL2njLzYMoluk
   Z/6EiCBY09GKN6raNIM9UznPOEA3FsYK5/jgqZtdGqr2k8SpYu8waAM/y
   w==;
X-CSE-ConnectionGUID: 3UhKT/VjTmiAI9B6719luw==
X-CSE-MsgGUID: EYw57XLjQiuwHVq6x2Hqbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136331"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136331"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:52 -0700
X-CSE-ConnectionGUID: 8qfW+FaCS8mfBeQtkRkbbQ==
X-CSE-MsgGUID: cI71nm9ORAO3SuPSntI/Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069153"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:51 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v6 03/30] x86/resctrl: Remove 'rdt_mon_features' global variable
Date: Thu, 26 Jun 2025 09:49:12 -0700
Message-ID: <20250626164941.106341-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rdt_mon_features is used as a bitmask of enabled monitor events. A monitor
event's status is now maintained in mon_evt::enabled with all monitor
events' mon_evt structures found in the filesystem's mon_event_all[] array.

Remove the remaining uses of rdt_mon_features.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/resctrl.h        | 1 -
 arch/x86/kernel/cpu/resctrl/core.c    | 9 +++++----
 arch/x86/kernel/cpu/resctrl/monitor.c | 5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index b1dd5d6b87db..575f8408a9e7 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -44,7 +44,6 @@ DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
 extern bool rdt_mon_capable;
-extern unsigned int rdt_mon_features;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 1a319ce9328c..5d14f9a14eda 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -863,21 +863,22 @@ static __init bool get_rdt_alloc_resources(void)
 static __init bool get_rdt_mon_resources(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
 		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
-		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
+		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
-		rdt_mon_features |= (1 << QOS_L3_MBM_TOTAL_EVENT_ID);
+		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
-		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
+		ret = true;
 	}
 
-	if (!rdt_mon_features)
+	if (!ret)
 		return false;
 
 	return !rdt_get_mon_l3_config(r);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 61d38517e2bf..07f8ab097cbe 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -31,11 +31,6 @@
  */
 bool rdt_mon_capable;
 
-/*
- * Global to indicate which monitoring events are enabled.
- */
-unsigned int rdt_mon_features;
-
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
 static int snc_nodes_per_l3_cache = 1;
-- 
2.49.0

