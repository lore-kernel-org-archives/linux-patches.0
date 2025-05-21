Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4CE23A58E
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867861; cv=none; b=O/uO/gubbBZmXJSTL5ykcUN2yPjdLApJyaeVe3B5kDjOekdxp7bTDh4w3/eK8Fxfwv+YdAMyidfyBLlF5RKBT8hkRe91OP/tbKfXLy8rv77bgvqjRqLmIR54fX5D9bEMbau7G7L58VC+EuF9qM4IhjBB4nXuri0ha9C5SQPgYIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867861; c=relaxed/simple;
	bh=IVy4LhDAZM5Nxy/pPdww1lQYsqOkYwzTZTnTQf1NwTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcRuwl03HVqZb7jgSwbZHS0WUpuHvx3vS4KjzUdivGvqcxN1OJjl7417LKxA6UPFKTeFhGmncN4BDY4KwLmB3KQufAyoGbqcO31AtAcjorfLaqMNcPTOY9snxzCd62EZjFPjlC1HdpHU4sMQC3JYXcA7nWBdyv2P5vf5d8X0y54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fUJRoo6v; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fUJRoo6v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867860; x=1779403860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IVy4LhDAZM5Nxy/pPdww1lQYsqOkYwzTZTnTQf1NwTM=;
  b=fUJRoo6vP1rQ/4dRLJjykOP+g1UMh7FU+xgMF5kzkfsXYzJL/5tMEt8k
   bzavfEBST71JXaRJgJahmp+UXzZqaCO6jmltrNCACsqpvaTwElzFhSipO
   2BvjbPAPLc26KQDkKtHPf73IPUiMYUixDX7COV2k60s5Yw/Z/ZUc36svy
   6R0IQdHGTR5N4GraBe9QUnWgXiu/MqmYmRfhiEFmc3SphGneM7jx1Ii3q
   szfE8em0H91P8Zn25nWXnr2hvwztfCA+NVtY8AEdai2ucD6OBfeS/17GN
   E77eJdu8cUfevzzMszDSagKA0gD9GHZB2xsYGRTnz7jlzv17txfc7/S3k
   w==;
X-CSE-ConnectionGUID: uAekruuDQjW7zzH6ImV0BQ==
X-CSE-MsgGUID: gZTN9yjGSl++jFRFjuKyBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677634"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677634"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:57 -0700
X-CSE-ConnectionGUID: Iw9HxtXpReKbTAMpGKTWqw==
X-CSE-MsgGUID: 3AcI84ZHSZy3N/Ce6wn3vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352129"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:56 -0700
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
Subject: [PATCH v5 03/29] x86/resctrl: Remove 'rdt_mon_features' global variable
Date: Wed, 21 May 2025 15:50:21 -0700
Message-ID: <20250521225049.132551-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This variable was used as a bitmask of enabled monitor events. But
that function is now provided by the filesystem mon_event_all[] array.

Remove the remaining uses of this variable.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/resctrl.h        | 1 -
 arch/x86/kernel/cpu/resctrl/core.c    | 9 +++++----
 arch/x86/kernel/cpu/resctrl/monitor.c | 5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 9c889f51b7f1..089742970cc1 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -42,7 +42,6 @@ DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
 extern bool rdt_mon_capable;
-extern unsigned int rdt_mon_features;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f4f4c1d42710..819bc7a09327 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -860,21 +860,22 @@ static __init bool get_rdt_alloc_resources(void)
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
index a1296ee7d508..fda579251dba 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -30,11 +30,6 @@
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

