Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0013074B1
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408537; cv=none; b=aGLgIyQ+ITw/HKLfrHwwxMWdCzi3it1xp5WQJTyRNd9tbGt4b3vhCQX5ocBYVDt+zGEOYAb9GlmLRfWw/+vII8xXmvO4Oe9zG9WSHMNvs0jMFHeHr8gBs8wRCTj2MELaC9ivpvxETPeReRgIE835qVTyNYqjy9/aY99d02C+FnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408537; c=relaxed/simple;
	bh=mdPSsXNAF+ChB2cevDfLFY2DwPCA14rHNG70ozRiqTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeryDqf6IFnnNmTMjrERpgrCzUQkPCFEBTElcUC2uExFWydIKai+QuRDM6kQ+5zkjO5EBZJUtOvzjZVSa7VYFoHYwl9yu6QMPFRdzg0SFSuLuY7fY3rBepH1cOrQ5i4sVsv4ccrRGjE50LgC10TSg0x/JYfpdGE020DtS4Ar7WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cDWqu2b1; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cDWqu2b1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408530; x=1796944530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mdPSsXNAF+ChB2cevDfLFY2DwPCA14rHNG70ozRiqTE=;
  b=cDWqu2b1YeYcJKDAkzFQZo9U2B6E9WFj2xzhriwUzebeUVvIXe6Iw6t6
   aNb35b3Jf+zvms4oxxEk/4qYizU9eEvpArNTQECTTEBZS7QEUd0TEwYUi
   SoXaJcAx/mdhCRhx/wYsXo+0M0fowqGpaoUjM8XARHQgTI0SLNVYtwEFn
   VTj6stTvUkiDAlYQR7jBrq4HqK+PK+jU7jpQMzPQbw8QRMzUbUGxq8eSB
   TndvstyUOAZHDDZ8lOKyGyOTnSQp04hsC7inSFh2qcBVeBizqwr2hUbnI
   583aPUGJ8ObBVFmAYir03Pt0D4LIGzU2cWY6HW5dFkvJ9BTWKIH/gwl4y
   w==;
X-CSE-ConnectionGUID: 75qlNCrpTfWg3/z682bIVA==
X-CSE-MsgGUID: M3yt+/1tQZWcZMRP//gQoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973718"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973718"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:44 -0800
X-CSE-ConnectionGUID: ALEXaJlrRmWip92vLRTi0w==
X-CSE-MsgGUID: ba8T8sJ0ReSl4y0KBqrqwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297161"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:43 -0800
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
Subject: [PATCH v16 29/32] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Wed, 10 Dec 2025 15:14:08 -0800
Message-ID: <20251210231413.59102-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since telemetry events are enumerated on resctrl mount the RDT_RESOURCE_PERF_PKG
resource is not considered "monitoring capable" during early resctrl initialization.
This means that the domain list for RDT_RESOURCE_PERF_PKG is not built when the CPU
hot plug notifiers are registered and run for the first time right after resctrl
initialization.

Mark the RDT_RESOURCE_PERF_PKG as "monitoring capable" upon successful telemetry
event enumeration to ensure future CPU hotplug events include this resource and
initialize its domain list for CPUs that are already online.

Print to console log announcing the name of the telemetry feature detected.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c      | 16 +++++++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  6 ++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index bca65851d592..829633bc54e5 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -766,14 +766,28 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
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
+	r->mon_capable = true;
+	rdt_mon_capable = true;
+	for_each_online_cpu(cpu)
+		domain_add_cpu_mon(cpu, r);
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 34f882df1243..ea613e49d213 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -275,6 +275,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	else
 		r->mon.num_rmid = e->num_rmid;
 
+	if (skipped_events)
+		pr_info("%s %s:0x%x monitoring detected (skipped %d events)\n", r->name,
+			e->pfname, e->guid, skipped_events);
+	else
+		pr_info("%s %s:0x%x monitoring detected\n", r->name, e->pfname, e->guid);
+
 	return true;
 }
 
-- 
2.51.1

