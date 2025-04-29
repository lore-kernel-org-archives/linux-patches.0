Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B601D215777
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886871; cv=none; b=DuxFZmm9For0Hm9lFU4vE29QT0B8RpgKKcd2TGfP6nWEiKyMngImFPSdi0d91jGyoNTkDCBbyO9qqqgzOjGNgR55VsWv5fwqPJDRZJ6seWoOcEsD3zlTXeyKg82Wk7cuYeFkeesRwWZlE28nw/8EquShVSleqCUSOYtnbqPVKuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886871; c=relaxed/simple;
	bh=ndLXdrx5e+eeWbCrX0njshMSXqZWltIeXhsH3kzx+dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsX+f7idPf3H+6/CPC2Da+qnCDtJQ6GMqfdLMIBc/TO+k+KzP5tNVbHhBIXfCe6sQjcG76u+DQ8XQqG4m6U5zuRvawcnG1WkLeRSqHNhcu7h9ozUo4CXRosfVL7Cp9tWhSKb0R7OIdt5HJs7DJSLkBFTqwg5kY4xgzIlHx/Lzq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UcRINqsS; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UcRINqsS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886869; x=1777422869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ndLXdrx5e+eeWbCrX0njshMSXqZWltIeXhsH3kzx+dw=;
  b=UcRINqsSLkN4AqAu5bc4KdoiPp4QHupJ8236+EA1fjU036sC+ft5pgU+
   9J4W7CAVInBHO6BoPhVXay1qEhj4CsrIq32yv6JsDWoAaS+pfjYym5Pka
   HXUlllIvx0MCaLtvvmhVlx0l+5FKS+mkcXvBaiJxUnMxMPHwuKSp3oghU
   t1dZCwvzfEDLuh8fd+avKPnomP+OFOmaa3hh9T6DbF7X+zWOmRCDMUuI+
   N+vqz4PlVfLOMm9c7kVCW/mpCCOAUUjbKnQJ/vz47AskBOWL1ZDm6gcPQ
   QqMW0wyn097pYQNxETfosjTOR3xWQGVF2WaPHd6iTwCTRuc5EdJIeloAn
   w==;
X-CSE-ConnectionGUID: FVSF1MhYQhu2P/EwFBLboA==
X-CSE-MsgGUID: nh3xtLbSSHmvS/PJxiMLDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148280"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148280"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:22 -0700
X-CSE-ConnectionGUID: EU03d3FhR12wZw305kOzpg==
X-CSE-MsgGUID: 5sYYQ2ImR0yjxmZHHbf7mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394067"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:21 -0700
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
Subject: [PATCH v4 25/31] x86/resctrl: Final steps to enable RDT_RESOURCE_PERF_PKG
Date: Mon, 28 Apr 2025 17:33:51 -0700
Message-ID: <20250429003359.375508-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/core.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 97fb2001c8d8..9fa4cc66faf4 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -761,13 +761,27 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
 void resctrl_arch_pre_mount(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	static atomic_t only_once;
+	int cpu;
 
 	if (atomic_cmpxchg(&only_once, 0, 1))
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
+	for_each_online_cpu(cpu)
+		domain_add_cpu_mon(cpu, r);
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
 }
 
 enum {
-- 
2.48.1

