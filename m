Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63093451DA
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496056; cv=none; b=CvDiPOEUGYJzAfroOiNsT2Xz6RWMuM3QLtJl/azH9zbADhxpV/Yjt/Iw1dief1V0z112dS2xpil1DJLu52VvwIC2t4klObNomAdwuOWd5Epmj9EOsQVkx32qQGeloUTumgCKu9QguQTg/HTS/guLbOq34uEJ8/ZX9dqyVsyXzGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496056; c=relaxed/simple;
	bh=0ynTJMOhGoVYEoi5fmUyznzEidV8835va+yFyk/z4kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8vo8YS9mFZ2+2fKO6Y0WIOuWRMJrxSScB94uBkSUNdcb4OmvNAR/HDMIyICIxOkBppNPu5LYq+aKy7gnXZZNVt5uSXhdqhLKyge5K+01vgiwxd5pm1a9erO0HkPr7sJCrBrZZaAf6/iEXwQ+OzpboEGbt20qkssknOUGY0qTIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PBhg+epN; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PBhg+epN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496052; x=1788032052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0ynTJMOhGoVYEoi5fmUyznzEidV8835va+yFyk/z4kM=;
  b=PBhg+epNO3Oc2Akr99TCndvOrG/ZscSrHXR63pV9skJU+fKfwT3MUuu0
   kT6xXHiIyAkZYIIT/D/QMMbD7YMMBIdhF1zwCNXUY4+cn/1PHU7cyHo9d
   jD+J9yl2YPgwv28ZFbfDSelxhzadwwYd8SuO1D0A42Db6bL18/LdAUNTT
   WAK9D6Lc4m/i0ZfPybXUmIjwJpzSWf6si/4lQf6Eq2+tX/SyGNn17rKjQ
   2Jq1+OZeoE+8F3IwmL6dMrJ8SKQM2AC6/6qaLWz7amK83cdg2qjgrykcV
   H7YePDfOAQ7EeZU/ySwAYZLxQ01PTMF/9twWiwHaWHatXXeX32Ow33Qw9
   A==;
X-CSE-ConnectionGUID: G191OyiHSHmdoJNTd7HcpQ==
X-CSE-MsgGUID: Uz+wWuruSaijC1eT6uVoQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625384"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625384"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:57 -0700
X-CSE-ConnectionGUID: PHBjiY6hSx22o7Fm2X/ngQ==
X-CSE-MsgGUID: 7VDUSvYYRnufphE8Qk0zZw==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:57 -0700
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
Subject: [PATCH v9 28/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Fri, 29 Aug 2025 12:33:40 -0700
Message-ID: <20250829193346.31565-29-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  5 +++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8aa7d9105971..c221c68507da 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -753,14 +753,29 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
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
index f06f71c06029..35670ef07478 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -182,6 +182,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	if (!usable_events)
 		return false;
 
+	r->mon_capable = true;
+	rdt_mon_capable = true;
+
 	if (r->num_rmid)
 		r->num_rmid = min(r->num_rmid, e->num_rmids);
 	else
@@ -191,6 +194,8 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 		resctrl_enable_mon_event(e->evts[j].id, true,
 					 e->evts[j].bin_bits, &e->evts[j]);
 
+	pr_info("%s %s monitoring detected\n", r->name, e->name);
+
 	return true;
 }
 
-- 
2.50.1

