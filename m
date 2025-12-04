Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A667329E5A
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881684; cv=none; b=DOhZjujSRJlvrcHV3rkUcvboYGPf10IEaAbyEIhR6Gk5WX4n3rWl/9cJYXRDOUtkJyLlnNsR9n4qVJwzqsz26RICCdYPhB8ruB5qvyP0PcPuHWNXI+f+iYcElBmtEoyKQBcxqN6T592f72hw8WxFrnig8feqtSj9JuabYeP1ulk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881684; c=relaxed/simple;
	bh=6P6/qdwIinWh3GhPxgZSngc0CYjUPfiSTLftQro4OAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOMwJOiYA85KX8HblmwkFadQ3tLlW6muko2UBinRRAumeAUkYRJAlrjDDxlFHidxGd5DwXgXTdRjqNTq/6qLZQxOoJzNuMIb3EjBy70mQZc9DQevVg4mZmqjPZRZIPJ//FcneE3fngoCqJAenhYyYuNFMwEf9lVitpx3dXrT0bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gvDTkO5i; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gvDTkO5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881680; x=1796417680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6P6/qdwIinWh3GhPxgZSngc0CYjUPfiSTLftQro4OAU=;
  b=gvDTkO5i9gZk9aHhXMdblHLzIRpvZ1sR4gpxg7IPG92CGZ5GcVJOqDYN
   o0F826wuNgAkocjCmE6zR5W52K/aYXomGh5lwaFXEr4XU3pcRQvLw5tn8
   pCXgqNuRtP6+HiT5VDUe0Bm5/riufA1d+yi05QnPHwKadCkr/2rMJu2KR
   jOttE9TX2OANc2FrvUDarplwiiG8u0ZUW4iNNt5B9yrB9iE81sF4dNJPZ
   Ah27iHLyh5GMR21brJEUgmjGJ3kuPRLtd9t8dgD0bLxDsZ/MK2YpifXpT
   L/F1q2MxkDxtpEqp9XvAOhOzzciz7AKxCBvdKeQD+0DK/PD7/zi7aKu8Y
   A==;
X-CSE-ConnectionGUID: aW5DWQYdSYGFTw6VF/4YXg==
X-CSE-MsgGUID: Qs3mF0kDSaG1gwR/oS9txA==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69511077"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69511077"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:31 -0800
X-CSE-ConnectionGUID: GQ1uEawjRES/qp8Qiju/qA==
X-CSE-MsgGUID: GaErUmvAT5CEg7lurl7z5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752868"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:30 -0800
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
Subject: [PATCH v15 27/32] x86,fs/resctrl: Compute number of RMIDs as minimum across resources
Date: Thu,  4 Dec 2025 12:53:57 -0800
Message-ID: <20251204205404.12763-28-tony.luck@intel.com>
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

resctrl assumes that only the L3 resource supports monitor events, so it
simply takes the rdt_resource::num_rmid from RDT_RESOURCE_L3 as the system's
number of RMIDs.

The addition of telemetry events in a different resource breaks that
assumption.

Compute the number of available RMIDs as the minimum value across all
mon_capable resources (analogous to how the number of CLOSIDs is computed
across alloc_capable resources).

Note that mount time enumeration of the telemetry resource means that
this number can be reduced. If this happens, then some memory will
be wasted as the allocations for rdt_l3_mon_domain::mbm_states[] and
rdt_l3_mon_domain::rmid_busy_llc created during resctrl initialization will
be larger than needed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 15 +++++++++++++--
 fs/resctrl/rdtgroup.c              |  6 ++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 960974ffa866..bca65851d592 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -110,12 +110,23 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 	},
 };
 
+/**
+ * resctrl_arch_system_num_rmid_idx - Compute number of supported RMIDs
+ *				      (minimum across all mon_capable resource)
+ *
+ * Return: Number of supported RMIDs at time of call. Note that mount time
+ * enumeration of resources may reduce the number.
+ */
 u32 resctrl_arch_system_num_rmid_idx(void)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	u32 num_rmids = U32_MAX;
+	struct rdt_resource *r;
+
+	for_each_mon_capable_rdt_resource(r)
+		num_rmids = min(num_rmids, r->mon.num_rmid);
 
 	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
-	return r->mon.num_rmid;
+	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 60ce2390723e..e95d3d0dc515 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4352,6 +4352,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  * During boot this may be called before global allocations have been made by
  * resctrl_l3_mon_resource_init().
  *
+ * Called during CPU online that may run as soon as CPU online callbacks
+ * are set up during resctrl initialization. The number of supported RMIDs
+ * may be reduced if additional mon_capable resources are enumerated
+ * at mount time. This means the rdt_l3_mon_domain::mbm_states[] and
+ * rdt_l3_mon_domain::rmid_busy_llc allocations may be larger than needed.
+ *
  * Return: 0 for success, or -ENOMEM.
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
-- 
2.51.1

