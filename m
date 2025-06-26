Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337A92F271A
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956613; cv=none; b=s0IMlJQ3xTXaRDEaWowFUr4kfPf0pzHC83OXkX5G7juCeruFHQOiNEScToiKVeLJXa4AYyTcNRbhNOOrolrhJJgTqrKgZmTr3YvKmm8J3KvB7b39WGnV/C/rTLg3+Y9Q088FNNGkuq31aV6otJzclTuPJzUuvPwxTK5tBKthXzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956613; c=relaxed/simple;
	bh=rZd2hRli8Da++8V5MNk0EyR/ru9cppsEeSazevG9HTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScES8FVk2Tg0uLR0mYxUCmkJrBEfYA44HK0xjg0yv5xBSIXKz8pSB09Zapgmr5iV8FFg6zxzviMzDbmwJfs9GWPxZmcT50Pyew/aUZOZZLURwG14AlKihAGxY/aTkSPubAbULsPXbpRESydgFZ7TQrqwgySwJIlX3KsqOXnHaOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J8BYjmLH; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J8BYjmLH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956612; x=1782492612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rZd2hRli8Da++8V5MNk0EyR/ru9cppsEeSazevG9HTg=;
  b=J8BYjmLHGKiuReJ9n8BCu0YjRDjSvvkotOucX+1EstFtA7f2IMs0xFGm
   Bm27m3RS/G1Soy3aqc9wwnUxyjA3+DbPzufBXDrZIiIzed74VN14FjeQC
   lkTPaD7ReXYB2ZgeDMAPB6RDmQV4rw+Cw/PoV4+guR4+OG5UpmbwtzQGI
   uGvcdn4vz0sb32LiG5S2Q/0hH+XNwjEeG7J8Gsb4VP0CG4BCN5Rx8iW+J
   w7TX2krD9/CyZ81YSnENv6x0NBlhnQi60sHxfQO83GwcUvus7zGmKiZrl
   iNN5romvk0HXnFX2uZq/wmKPk74EJL0acR8N5Ov4X6R/D1pwTiJkcRlUB
   A==;
X-CSE-ConnectionGUID: fl3Q9tz4R2aW+wxK5ISiwg==
X-CSE-MsgGUID: znfSVnsAT3uJYWbBUD/KQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136536"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136536"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:04 -0700
X-CSE-ConnectionGUID: zIBLx4f6Q5i+hAKCI5WIIA==
X-CSE-MsgGUID: ZCB32HVDTjCtAT2e5v2v/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069344"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:03 -0700
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
Subject: [PATCH v6 27/30] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Thu, 26 Jun 2025 09:49:36 -0700
Message-ID: <20250626164941.106341-28-tony.luck@intel.com>
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

The RDT_RESOURCE_PERF_PKG resource is not marked as "mon_capable" during
early resctrl initialization. This means that the domain lists for the
resource are not built when the CPU hot plug notifiers are registered.

Mark the resource as mon_capable and call domain_add_cpu_mon() for
each online CPU to build the domain lists in the first call to the
resctrl_arch_pre_mount() hook.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c      | 14 +++++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 50de0c29704f..3ec8fbd2f778 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -774,14 +774,26 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
 void resctrl_arch_pre_mount(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	static atomic_t only_once = ATOMIC_INIT(0);
-	int old = 0;
+	int cpu, old = 0;
 
 	if (!atomic_try_cmpxchg(&only_once, &old, 1))
 		return;
 
 	if (!intel_aet_get_events())
 		return;
+
+	/*
+	 * Late discovery of telemetry events means the domains for the
+	 * resource were not built. Do that now.
+	 */
+	cpus_read_lock();
+	mutex_lock(&domain_list_lock);
+	for_each_online_cpu(cpu)
+		domain_add_cpu_mon(cpu, r);
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 1d9edd409883..090e7b35c3e2 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -295,6 +295,9 @@ bool intel_aet_get_events(void)
 			r->num_rmid = min(r->num_rmid, (*eg)->num_rmids);
 		else
 			r->num_rmid = (*eg)->num_rmids;
+		pr_info("%s %s monitoring detected\n", r->name, (*eg)->name);
+
+		r->mon_capable = true;
 	}
 
 	return ret1 || ret2;
-- 
2.49.0

