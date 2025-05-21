Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9532459C4
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867873; cv=none; b=sljiZnWdyTTKcA4kr3wOrjxUQGlI2Xw5OftmGKwpoqKW5XBCplXvDA0wT3mvR9/w1Flf9yOoDT+JDHbqkPinIwMmHp8e89Bw4ttBS3EwSmnUSQF9txjqvyR6cauNvYTZE1kSA7iyui50tpz++p3Lhz+LDfut3kD5gACQxk65dto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867873; c=relaxed/simple;
	bh=Vuq2Y1X1WqGtNgyMA65DiHUQ7pD0Ew/rt+rgo5WAH70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1R3qZHmWBBVt9kJEZUq8k4TvcGXsDtbbEKEAe+dOZouBi3ZD8sdZcXJsKmA9TUN+bTrP2fvgEbNa1lXmbF8uaxmim13XTGBuOncOUGRsxllF+yNb+/5qicdNfnMRE0Xjg1BPPMJcti1DlnDv3oa8UTt/pdRnkd1IalfFOMQPfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHcCnfFR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHcCnfFR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867871; x=1779403871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vuq2Y1X1WqGtNgyMA65DiHUQ7pD0Ew/rt+rgo5WAH70=;
  b=FHcCnfFRcMYLmsFU6gDSTLxWwKG0gOJd7cGA+vzi2fmxvHtRh7BDrFWl
   C+KgYl1J88GhYV1qwij7Kbf7byYYqPUZHFf0zihtnZivhrE3BHBXTAevh
   saPOJIjEqWNckF1WAx5lxW1IK+MAT+ULTAqO/uW3NkZ+veQ4AVvQRax5O
   s60tjTqON15z+1mcKCZINmXTgqe71ZwRWksY/xbb2yy9U7kvmt2YBiHXg
   HrSHmVHIxp3G6Y5vzZ8Hnz6x0fr0aUrifwnGBq8s9Y+gzlKrw9LeLs/WF
   4BxaBPEALkXvUVFqjDxb44vQUjU8FqLVelHcqmicDc83C9Hm1WiXqm1xK
   w==;
X-CSE-ConnectionGUID: Z7TDTPGKQzeX2du8u4gXng==
X-CSE-MsgGUID: bqZRn7VmQpuCp4F8vqgbxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677776"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677776"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
X-CSE-ConnectionGUID: pC9+aHUnSQ6Kze+YGjV2dA==
X-CSE-MsgGUID: 3cV8fQp7TGaBMx0MQwIr6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352193"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
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
Subject: [PATCH v5 23/29] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Date: Wed, 21 May 2025 15:50:41 -0700
Message-ID: <20250521225049.132551-24-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 18d84c497ee4..f07f5b58639a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -763,14 +763,27 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
 void resctrl_arch_pre_mount(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	static atomic_t only_once;
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
+	for_each_online_cpu(cpu)
+		domain_add_cpu_mon(cpu, r);
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
 }
 
 enum {
-- 
2.49.0

