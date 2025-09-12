Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1291E362080
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715084; cv=none; b=lbjfE80p0L4qnOpysUKDcxt3+XRRpArm004NllZpxwWorN4uUFMj/dFfBv5hIPdYscZ3WI/SiNsLvOJ/BMXqpac2mc5PX1x51Caay5snXsfTp1khbItyIWXyw9wqHL+N6Dgn7KBx/9QRtggHupsQ9IvTVOwXb3lp97/9VXgh6Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715084; c=relaxed/simple;
	bh=yAfrsktJ80wasAMBxI0Dda4ScPgAJlD4RRy9FtTfa6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ez+mZtU+zXzKl2mPj08e6sId3lghnaMEL3SiRbZQKmaOCbWmeUL70/W1B+CEtr0i9zchvAvaAniizH1TKTz/FOPGSiqO/GE2P302aJkBs+5azxmrNlJuuiPgaJinXAL/WylazcohubURQ4wDmgzg5eChy6Mt+fDlBUpsUMzY7b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V/sdM5QJ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/sdM5QJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715082; x=1789251082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yAfrsktJ80wasAMBxI0Dda4ScPgAJlD4RRy9FtTfa6E=;
  b=V/sdM5QJbueCjWK9Kb6lCktBQF8Fkii+F29VeNMA93wuVUrXOafWlyIU
   Cro0IQX1O985wiggvd7738MXI24KzivCeRpzJHJVd84w0C0PrL6k2Mw3I
   zMfngDiW2NeIENfG4vVvrfW7CNpL95CArE67yEK+qXGrZ0LAo0XCiy4YN
   67t7cwM8begEvLOuDcW6jQ7mWuK3Shx8MfAjYnWGZcLdVJm2MJL1EE2g1
   XCRN9v4ZRFGpQ++9++vQszN4QY1T5mAsZmDvwqdV5ZK+lM8NNoXx/9V8k
   Yhf9JDoiK9HWlt9ib73qGS/rUtlEmE7g3qLhsvdysMVkFqQ+wnZrg6P9F
   g==;
X-CSE-ConnectionGUID: L6xunPhwQGuR5E8Om5Bqgw==
X-CSE-MsgGUID: L4hT9e4XRFCplugZKceA7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002841"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002841"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:13 -0700
X-CSE-ConnectionGUID: bjt+DnhWT/qtLhIYGZDH+g==
X-CSE-MsgGUID: iOamUvFwQg6yFaSBX2wnNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265230"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:13 -0700
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
Subject: [PATCH v10 25/28] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Fri, 12 Sep 2025 15:10:46 -0700
Message-ID: <20250912221053.11349-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Full support for RDT_RESOURCE_PERF_PKG resource is present but
it is not enabled.

Mark the resource as mon_capable and set the global rdt_mon_capable
flag.

Call domain_add_cpu_mon() for each online CPU to allocate all domains
for the RDT_RESOURCE_PERF_PKG since they were not created during resctrl
initialization because of the enumeration delay until first mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c      | 17 ++++++++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  5 +++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 876258545b0e..10ce0edfd702 100644
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

