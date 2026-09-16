Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096254E66CE
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600422; cv=none; b=cpFBs1635QE5EHpDh6uhl0noPbvrnA+gZk9tQA7uzq0bENBanv3Tj3Y2oGQhhDY1IWqgz7DT0dObYRmJWmLk4Y0EorxhbjW8pvlghBel7w4jAu8nSFTmHn+39jE4IybepH7bqJGxJFgmNkHSxOUKWggV66n9Zed2JrxadBHMUA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600422; c=relaxed/simple;
	bh=LkEGaL6edY32DUDcv/ylXMeVcz/O/JZteQw/+LK2t+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtDYR8TtK9qccb+1aC9rS8putTgpDZsUtKWvXZ+GHi7WTOwUB8h4cALCSn8CL0RW5sGWJChlf7V9moCaJZ9IP3PkJMOqbWpnPFbRqJLZII2p+u57xCpAq4QE3LtHcBhAXW/Kjy8WOsK6o57ADr8GylI3EEKHjLalkGctQxzy4EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GszOyhcz; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GszOyhcz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600418; x=1821136418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LkEGaL6edY32DUDcv/ylXMeVcz/O/JZteQw/+LK2t+w=;
  b=GszOyhczvNlmDy8brzDW5+fNo6WOvdfYcaP8jGj6tBe8eYHq0l2e8vVj
   jqrtsBi3445uy3gaK0+abSBtEVCjEUgeelwnVB0JQyBXnPafHxWiBPZU4
   vVRBaM2aNePZh5fZ+2HXMcYe0tfYDwip6HVODhIBNo4pncuGDdGwpvo2K
   KocgLk3VFBKQJx1l9ovA2CAXHmXujw2+5fT07p4zq24EgKHtv98BagUUZ
   LL/tuKU9o4ioikvrnuivQ85Kp6TIx76KFsz5u5WrapmcxC2zRBCmTYP8T
   hEvyJiqzq0fiJsHpPsfUnVN1+STCHEpg49YYGVQdlW9moPk38PfJ8MpCg
   A==;
X-CSE-ConnectionGUID: 5727hOIVTeuP16Zhy+ming==
X-CSE-MsgGUID: 3thhNz3FSTaBEehxYBDpvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861382"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861382"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:34 -0700
X-CSE-ConnectionGUID: w0y+UQK2T72Q+QD7KcCXCA==
X-CSE-MsgGUID: Y8IF91JQQd2ymtNCSw7RLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231451"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:33 -0700
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
Subject: [PATCH v12 08/25] x86/resctrl: Delete rdt_alloc_capable and rdt_mon_capable
Date: Wed, 16 Sep 2026 16:13:03 -0700
Message-ID: <20260916231320.14502-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These globals are no longer needed, delete them.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Changed names of local variables in get_rdt_resources()
---
 arch/x86/include/asm/resctrl.h        |  2 --
 arch/x86/kernel/cpu/resctrl/core.c    | 13 +++----------
 arch/x86/kernel/cpu/resctrl/monitor.c |  6 ------
 3 files changed, 3 insertions(+), 18 deletions(-)

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
index f2bf160d01c1..2e3b9c16cbda 100644
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
@@ -781,7 +775,6 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_lock();
 	mutex_lock(&domain_list_lock);
 	r->mon_capable = true;
-	rdt_mon_capable = true;
 	for_each_online_cpu(cpu)
 		domain_add_cpu_mon(cpu, r);
 	mutex_unlock(&domain_list_lock);
@@ -1026,10 +1019,10 @@ static __init void check_quirks(void)
 
 static __init bool get_rdt_resources(void)
 {
-	rdt_alloc_capable = get_rdt_alloc_resources();
-	rdt_mon_capable = get_rdt_mon_resources();
+	bool alloc = get_rdt_alloc_resources();
+	bool mon = get_rdt_mon_resources();
 
-	return (rdt_mon_capable || rdt_alloc_capable);
+	return alloc || mon;
 }
 
 static __init void rdt_init_res_defs_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index ab9cb34145c5..2f3e5b89a7fc 100644
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

