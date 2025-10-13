Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E94E30E0F5
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394860; cv=none; b=NFVHVVgLDwRJHpumEbhDTyH5fbpvRXCi7QeOrAzka5fUr4o5xiYnSSPfJrcGdpmrT5gN/8vuBB+sA9ZydYr8grr9ruQ/gldNvJy5pPo37GAJ5AM9P3J4qDBTeantf6WSJndQtztnncPnCOOZ6q6HzK2YM5yBkySFY2Po8ZIAUq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394860; c=relaxed/simple;
	bh=cuRhoizmfwXcJSSVDXuZyJahB4wrm/4dq13lhFeHdfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAV17ccL54qnskZmPjly9/qMXVF4c6UT8IrRF6jAIAGwYHvlew1iOamrY+Qflspb2fg0Nl2ioCcjbfDxo3/DSJ2Y66Ii9CDKQuFUVA+uv3w//0+4JR/7oHVhdRiHPpqMmhEYq5jkxEScmyzg2rZd7xLDX1pBmeyMj8j9ThHdboc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ipr3ZMB/; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ipr3ZMB/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394859; x=1791930859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cuRhoizmfwXcJSSVDXuZyJahB4wrm/4dq13lhFeHdfc=;
  b=ipr3ZMB/s9W4SN9SL1bGX2Jgux7GUHZAjY3YI2JUG1Jy+N1bFQgmn78G
   PlHaPXfQ3HRBV+26QypdrfDbXMlAZRMnc0pcFcl70vIKfFHK3NCUueMgp
   itqW9ioP3g4wb54e6yg4SPBuXehSD9ioxfN0mq7ERylcjAPpfQYCjbwcW
   hqJetLrfj8BGasnj81I5nOqk1qcez0RbH8xkK4Yyr8cfw9Nwk9eZQBDNQ
   hVrUGKT0U+WLpo1+UUeyDhBWZrGhwtXCXO17jvO2W1sQ1ooEoV2KF87m8
   5FtS7mp7Pl36gXnAGxwMad5urEFCOb6IQwp5L0Fs3IBmOpGJ7htW4A4xI
   Q==;
X-CSE-ConnectionGUID: TwI7qlduT/efLdfqvdEjYw==
X-CSE-MsgGUID: OOF4xLnHSICtzyMxCfbC3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168954"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168954"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:04 -0700
X-CSE-ConnectionGUID: NNpPc321R8SXQs/hq1wpoA==
X-CSE-MsgGUID: Erua9l8eSdiXfVY6jr4xhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145339"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:03 -0700
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
Subject: [PATCH v12 28/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Mon, 13 Oct 2025 15:33:42 -0700
Message-ID: <20251013223348.103390-29-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
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

Mark the RDT_RESOURCE_PERF_PKG as "monitoring capable" upon successful telemetry event
enumeration to ensure future CPU hotplug events include this resource and initialize its
domain list for CPUs that are already online.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c      | 16 +++++++++++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 955a1904ba2a..2d8c20819ec3 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -761,14 +761,28 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
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
index 03d159afcfe1..bc0a4d84a4e0 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -225,6 +225,8 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 		resctrl_enable_mon_event(e->evts[j].id, true,
 					 e->evts[j].bin_bits, &e->evts[j]);
 
+	pr_info("%s %s monitoring detected\n", r->name, e->name);
+
 	return true;
 }
 
-- 
2.51.0

