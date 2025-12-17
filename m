Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F7034C141
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992164; cv=none; b=R7AUgj26wLk0PhtxRWBsleUVc0+OrYr3Ml49tOrJvUYS6JwPlL0q91DjPsEQAw+4fDCvjgWcn3KSI7XfOL9DEOzY6CJ+zrjzdRdlHzEOQW/eM3c0bpS+s7Hx2Be6zQ1++0M2rPL/OUnarXrnuYqNMGuk2zv6g0iEmnYy6BoKceE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992164; c=relaxed/simple;
	bh=zY4ixyPA16TWiCZD68LwvScC7FiX9KzB26LzSNsOUjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEQn39qD43wBKkrrARO+kWeOeT8+huyPdKPidTDy/hNKHQcL0MzxQ69GhivI3K35SDxTu8xHrx6u9yGAQKtUD8UpqvcQiNgLUNHtxN5+ziDfFun2D/NKiUIuT7pywg6eKRJvV7uv6Ms4O+UmSaJTKLlQljECBJa72+g0H7A0pjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P2/G7jW+; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P2/G7jW+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992159; x=1797528159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zY4ixyPA16TWiCZD68LwvScC7FiX9KzB26LzSNsOUjU=;
  b=P2/G7jW+9kPyeo47/MpA9/Sud4WZLh90jhKXD1Kp2uCJe2V8+TBu0xIi
   BtFqihB3q1J9ELtboQErWdgoL/gOkzqGEOHPEyc6psddpepUM/zgSq6n6
   6QfYtDAsUy444lfBiYQNgts23eEpvr6mpNRyUzZKajGk4GtnniWN3l+sk
   7/a+A7fazAFnTFieVpG3Fg613aRyYWSiufW+5fX7rWbqmvA+k7i0v6x7/
   +f4UeMbSKRf4gPsqJFR4nmMNk0ypBbLZncnflLe7K5qXnSbmDsW0hX6/s
   vRupHdpfbWsqWv+0G9FJInb+2jc2SNiQTSdxSwZruXF3i0vWGgqUgf7z9
   g==;
X-CSE-ConnectionGUID: /o3/fPnaRHu2Rmtpz/nBMw==
X-CSE-MsgGUID: /uPmkiHXQCqYrgJ6LRgykQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594851"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594851"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:38 -0800
X-CSE-ConnectionGUID: gFA6Qi6JTUW5sDm0F4ScIw==
X-CSE-MsgGUID: GHXXFbRWQEW5wByPgMPWZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748274"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:37 -0800
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
Subject: [PATCH v17 29/32] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Wed, 17 Dec 2025 09:21:16 -0800
Message-ID: <20251217172121.12030-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
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
index e50c04afc8eb..3ee51b05a297 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -274,6 +274,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
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
2.52.0

