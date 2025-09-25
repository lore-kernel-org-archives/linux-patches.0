Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10307322A19
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830667; cv=none; b=ozczvdI5q8qguvk98cE8EUibN7WS2jN/O0ItGl9c/Grcs+YisIqSRx140V+gW60ZBo5/ArcnGZBJ40Bp8adI4GTCJzCiCwviZiZ5uxSvEFl2kqJlEFeXjBRP9W2ks4Nx/K6hUetCev48oBwwyDPWLVWEyVdvYoCH+MTN1gGsYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830667; c=relaxed/simple;
	bh=F/bYMDpwsvBJEBQwRTIY2pjvEIXc8qpGNlaU4LojosM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAiUUfY1oCVmUWN9zamJd8uiWC+g9h9gsrcwioLmsiCfSVPIpLyQsaaLHfnEu6dWLYiA6HJvWUTD3w0GLQzmzNu98DbAGbxKadevaxbFZjrLJeC83q8IePrWVnZn6JFuOZyWOtlY4ZrEKRcd8WMPvROndyoGjp98O7nWZcuM++g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GzOnxzIf; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GzOnxzIf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830665; x=1790366665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F/bYMDpwsvBJEBQwRTIY2pjvEIXc8qpGNlaU4LojosM=;
  b=GzOnxzIfbgac4uqpeyyTWKL/1+GyeOy1SgD5So4vqIsQNRUNrwFlEpWO
   So01cLl69zwKjDlLOLR9lN59A4IuqTw/ADBzXHaZNdU+9uB2bDRcEEq6i
   Adofkg4h7mWu3Qj255YZ1YQnuM143Hfs+o7EieydshziZAdjH+g/R4gVg
   Ap+zlmKtgvkOG7TaLj0A6OSaAiA131EgQtkrm3+yL2OdmVLCKDubrfobx
   TzI4aOWF5Hj/+Ua4R+KR6HGC3qzNHC9bLRZQSfi4KOh6mH4PCowU1x/ne
   ON6D6USZ0YYeLIucZgNDWuwIm1VkvlmTfq+UINR27nSLwVAVlhXAB8w7C
   A==;
X-CSE-ConnectionGUID: lFLsdvI4R6Gn0v54auTsUQ==
X-CSE-MsgGUID: bIA4rbFtQeiwb7N9j6wKJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074372"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074372"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:15 -0700
X-CSE-ConnectionGUID: CtTXJXAWQpyeXnkbOLvT5Q==
X-CSE-MsgGUID: HziKMY2BQrSNaNMrKi6+qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003699"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:14 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 27/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Thu, 25 Sep 2025 13:03:21 -0700
Message-ID: <20250925200328.64155-28-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mark the RDT_RESOURCE_PERF_PKG resource as mon_capable and set the global
rdt_mon_capable flag.

Call domain_add_cpu_mon() for each online CPU to allocate all domains
for the RDT_RESOURCE_PERF_PKG since they were not created during resctrl
initialization because of the enumeration delay until first mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c      | 17 ++++++++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  5 +++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 1d43087c5975..48ed6242d136 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -755,14 +755,29 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
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
+	if (!r->mon_capable)
+		return;
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
index 039e63d8c2e7..f6afe862b9de 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -214,6 +214,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	if (!usable_events)
 		return false;
 
+	r->mon_capable = true;
+	rdt_mon_capable = true;
+
 	if (r->mon.num_rmid)
 		r->mon.num_rmid = min(r->mon.num_rmid, e->num_rmids);
 	else
@@ -223,6 +226,8 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 		resctrl_enable_mon_event(e->evts[j].id, true,
 					 e->evts[j].bin_bits, &e->evts[j]);
 
+	pr_info("%s %s monitoring detected\n", r->name, e->name);
+
 	return true;
 }
 
-- 
2.51.0

