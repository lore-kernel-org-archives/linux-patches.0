Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E5B24467A
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278053; cv=none; b=bR60hltBx4v2riqwha4lOEO8BZWZNLji85C6dxtfl6HU6hctfnC0yxc/cnL5uNZeHqbJVTMKfw85r7V+I7vc8vTEGN0CFNhAG/a2cs92SMMO1uDX/4ZrJZ/cGsd4cfZrLtxNhH7Cnz/Yn5DYYzCyB5M2hGL2AYg/v3WabCMYDkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278053; c=relaxed/simple;
	bh=Gymz2sVtbmI3bTn+wpzreJLeOERzpKrsMsPiBbWpuhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kp6tzrtOudcik7OoqjVtNQcv64WF3MpJ/Zfol+tdmYmQHSHZgVKvZ+eK6XIHcRZagM0SYF5QLqhyjTa+2VoZL3vpVAkRXLrDY2YaLenLI1Q4zVMhNFFDXzZct6xZorinf3HuLsXY5xTBS1bJ/vtoB2c3W7HS7lYBA8WB20oPyDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQ32mY5a; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQ32mY5a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278051; x=1783814051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gymz2sVtbmI3bTn+wpzreJLeOERzpKrsMsPiBbWpuhQ=;
  b=hQ32mY5a6agT77PwKklTLEDsUGXNgBSHmnnB+6eoCJOjVWowFSkdyE0G
   IjaM/MLtfqPW0mmv2N5Aq7Mo7MIq2sQ/BVtJCcQ19azsvAbyasl62H7oz
   BPX7aC0Bmn4cvhJ2Kyj9QGmEdkL3ukv4PrQKq2i5IqrsI8/88f/IMtCMx
   amze5gY0HAVvXm7+MZYft+db6Cu6zji9bh9tOJr/rDh2ubANUHPrOhW5C
   6/loQTyuYEu7Ame55wc0YYT3TqKfWYh5r/ognNx6DU9sUl3riro6DuMLK
   Vu7IuSwihCV6UvjB/SxQn0bLpqnkREvBXQvxV84Th6b19PwMNBD3LR15E
   Q==;
X-CSE-ConnectionGUID: QLsdyM50TnOIMehVAGEYrg==
X-CSE-MsgGUID: KM5DsPpwRy+xvEfhmYtm7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292803"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292803"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:07 -0700
X-CSE-ConnectionGUID: NBIjVLHgQrezcek/LS7vJg==
X-CSE-MsgGUID: Mjs6NbiiTpCCBAZ9eP18bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902172"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:07 -0700
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
Subject: [PATCH v7 28/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Fri, 11 Jul 2025 16:53:35 -0700
Message-ID: <20250711235341.113933-29-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
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
index 1a6635cc5b37..1d07c38ed528 100644
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
index 6958efbf7e81..ea7a782c1661 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -264,6 +264,9 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 	else
 		r->num_rmid = e->num_rmids;
 
+	pr_info("%s %s monitoring detected\n", r->name, e->name);
+	r->mon_capable = true;
+
 	return 0;
 }
 
-- 
2.50.0

