Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3F72F90C4
	for <patches@lists.linux.dev>; Thu,  8 Jan 2026 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894183; cv=none; b=QxYRQmJGoFSPqPcLNdqxSKGYPraO4/A42gaBafK38kCkC9QGSpaInV7YNMDhObh3Dt+alztIQFsgFFRU3ZpGvXD7Cz6gmeXPwKfcNiurdHH/t0FG0NqUbDwelJ7i7cbtuG5aEFoRVOSMA7X9MFl5vGMdnXuvzj+Zj4codozZ+LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894183; c=relaxed/simple;
	bh=GZGtdDd4N6jOmjtSGH1ydviDCZdSAoZ4xutDEN7L7W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csi5JPU9LoSwsVYgQ69BrWdnVek761jmNI6XVgQNBvehMzSmKqH37qnvW4BBM6ETBeXhS63J7UAV7lRXOxrQ4f713VZ/+/Tn/ZwrxC9AAkA8QOvyxBnbnAKMN/Vn2MoVscW5uCMrW5lM1D1TpwRIy5DDvvZ50+5wfMWwiuUfMsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XgQ8CZHX; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XgQ8CZHX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767894178; x=1799430178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GZGtdDd4N6jOmjtSGH1ydviDCZdSAoZ4xutDEN7L7W4=;
  b=XgQ8CZHXNSV4S2jY0UgDWjzH3IBXA9rRd6s2rnzQ1744z+pXFlkFomE9
   T+BArnSHvwJF8Qf/60nFm5YisDB2wfTGSZWxdnMnszaJYUtYGnhSqRgz6
   iM+inijj3vGYjmxvgDdBK2rNkZ3Scvp7RkR2M4ws9W86g5sgsNksGfofa
   bQeI1C3OSriCfgg35mxXKrmFG3YNyFV4GZSmXGA6Is3FPjcpVZFwazKdt
   uW+RwLTKXmZ9AW6xiE3e/Lbmrk61gZD8sWL56BJYbBtyuJ8WsDS9eRkGt
   HckUmkywqxQOXoMCMs7tOcrFaxBIwiYdWNh7hysJFUOhXkgnI61kacIMX
   g==;
X-CSE-ConnectionGUID: y9xnvEeOSJq/Mi5JGvrNXA==
X-CSE-MsgGUID: fMv3YZTiSD6Ub0Ei9WzHxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="79999017"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="79999017"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:42:48 -0800
X-CSE-ConnectionGUID: S6+ZBNpGQ6iJSzWhHc1PkQ==
X-CSE-MsgGUID: 8HrSvVqIQeCkq1hWM6ft3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="240751118"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.16])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:42:48 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 29/32] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Thu,  8 Jan 2026 09:42:27 -0800
Message-ID: <20260108174227.11307-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108174227.11307-1-tony.luck@intel.com>
References: <20260108174227.11307-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/core.c      | 16 ++++++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  6 ++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index a3c65f46e8b4..5500c4f03100 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -766,8 +766,24 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
 void resctrl_arch_pre_mount(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int cpu;
+
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

