Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D762E610B
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936273; cv=none; b=YBzWOmYXuIo6up5adNyj9MvA1b1AHdb0WK5YCdt0xcnBoafiMDxv9Oy4FT/KBM01/A6cjAaHOgfZWaIMVePnVsZu7Xh9/IWJbinTkTYl1Q4wb6xqoZFtyXb4/EOtP7vp2wrw1odvkSYoK8LvcC/mgZdDnseKpEbR0NdjpGRl5uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936273; c=relaxed/simple;
	bh=sgId1FpAHkWwdJsgc/05Ii+a6vl/BCuVqfaaJBncn0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euVe+OrvEMPVEroO/huB4NGC8GIs1JVFH0do8p6fE7+/XlESFX8EQe2QV+ZDABt2Naa11tDXYptGap4vyhgyPHEsBso2+BrgQ4t0lFwr0F1sVrZYGeIa1vwsNY5BNXog0imDUcAbiohb0iQv+Djs1pUA+0N5s2kzJxuXWfFfJG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GuKj+HxQ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GuKj+HxQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936272; x=1786472272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sgId1FpAHkWwdJsgc/05Ii+a6vl/BCuVqfaaJBncn0M=;
  b=GuKj+HxQovI1EFUjb8grThzPVs8/3iIufexFhUm4g/+9Fr35R5O/31ZI
   fti/NcPutyO5HDextRSye++eWUFgs8qm3tX19dcbf9e4PaQ6UfdxziX8Q
   W0ciYzDPMRPP2vFMeCQPtzg2JE1r2FQy6BNQZYpnt5cdYFSaRgccTy+AY
   n7a9A4/oD+TNn4ffErp3bYn4qVDnsUCQTtQmAzraebAHH5LEm50tU4CYV
   NKX57pixOK1QLsdIjmhCyAWxNsIHvEdISENM29gxFNWXPcweiCcqorOki
   8SFgq6envZ+CIYkOMzSh2/E61eqiLiqjd4xiVg0w/OkJUKR+xF8N6sQMS
   A==;
X-CSE-ConnectionGUID: SOOB1ufLS3OPNoicII5xTA==
X-CSE-MsgGUID: AM9c4ok8Q5Os8Q8hifIeaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277555"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277555"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: 6BUEeamvQ42pTXGhWEsb6g==
X-CSE-MsgGUID: QphSABpkSg2MdlbDwJY3kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825711"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
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
Subject: [PATCH v8 29/32] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Mon, 11 Aug 2025 11:17:03 -0700
Message-ID: <20250811181709.6241-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
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

Set the global rdt_mon_capable (to cover the case when none of the L3
monitor events are enabled).

Mark the resource as mon_capable and call domain_add_cpu_mon() for
each online CPU to build the domain lists in the first call to the
resctrl_arch_pre_mount() hook.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c      | 17 ++++++++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  4 ++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 0284da075ea6..d1e2c5e2501f 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -750,14 +750,29 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
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
index 96c454748320..4afc99e74cef 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -258,6 +258,10 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 	else
 		r->num_rmid = e->num_rmids;
 
+	pr_info("%s %s monitoring detected\n", r->name, e->name);
+	r->mon_capable = true;
+	rdt_mon_capable = true;
+
 	return 0;
 }
 
-- 
2.50.1

