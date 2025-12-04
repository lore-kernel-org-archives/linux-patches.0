Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB53B32ABC3
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881685; cv=none; b=QSkBlIz8jlmE/sbDiJFy/kBxHIYbaFyEQS4XOrGo2VSMDW6R+c/mjYbWn073G1ayDUGo/vMKH3u0c7CDd62zC4jRw9Ys2E3Evz+ju7VTPUYmiKuPuaoKJUneYhU2rjcp7sez1ayv1xFimbmnBeXl/71r/1haaDnEBuxKqGhwzsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881685; c=relaxed/simple;
	bh=XAfywqzIO9v8aMzwLwSad0Acq7REiDb7hYT15DhaUu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBn7dm1701EgjAZmGsytuG0NU7N1M5eG8909K9nbX13AMQPDVj/2k5OdvE6+zcIngrQrqNJ5xF1BuzAliHlT2tH6YIf7Q5lxFZkMwrm0z7fo9lQd3/6gPdeFTV6Yb8gfHMkw0cHipyuFIbMmB8lSHua9JO0lp2Rq72Ti5KKntVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kMOvQ+JW; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kMOvQ+JW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881683; x=1796417683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XAfywqzIO9v8aMzwLwSad0Acq7REiDb7hYT15DhaUu8=;
  b=kMOvQ+JWXjBkbQiOi1S3JP0w0inFFB+DAFsuvHVb3AUGCcCSV59KUm0N
   lobZ0FUHvrUq9So4yfxkN4CJF3W+keEk8M3Bqt+BWgZ82fqKvGJsc/EhO
   b+ef0B6C90F90/HKhgKGhobMI77O3xPsgtrEm2co5D/hjUjesu9P94yfl
   aqZ0YhCmmubiuWtBsqly4p8PLqCcI6nFtASJCbD5LogxjHY5NucR5jKcK
   bjfo0nMJmzmN8vS/K0pi4tN53o4Y5xr3a72aBVywp+dYpDJlewMYzudUk
   lGvNUQZTcKCBgtFf84k8Ped4xU/6M1wXz8uHZnTftux8MA/N5ZylkMtt/
   Q==;
X-CSE-ConnectionGUID: 3r3VRDRiRD+KM2tD1wb4Vw==
X-CSE-MsgGUID: oit9nl6wQiKEfmKE6Wqexg==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69511093"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69511093"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:33 -0800
X-CSE-ConnectionGUID: Zu5muyNKTGSqRaEuIQgNfQ==
X-CSE-MsgGUID: Y6DQMQDqRxi798tr1/QYLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752886"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:32 -0800
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
Subject: [PATCH v15 29/32] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Thu,  4 Dec 2025 12:53:59 -0800
Message-ID: <20251204205404.12763-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
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
index 38fcddc72ed8..2e68c6baf9b2 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -273,6 +273,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
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

