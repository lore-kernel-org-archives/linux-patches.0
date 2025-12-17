Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3E634CFDE
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992160; cv=none; b=c9xwGk72TUDp1bfcNwaaF0TvL2fFvfkPf29xS4OEbu/hqhbzGTumr5BkFx/0LewRfSgkCWnYMx1ADtSigrFvR7iizdFG5vBEVdivOE06GHBdYZzfeOEvcgWYKy+CDg5b8FligHMZjnPVXTm7vmTo2sRZX8dbVE3usTkR1ZpJ8B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992160; c=relaxed/simple;
	bh=/R2DK4fMzY4wGavtaDh/rSLGaG0BpBIxmJhhkYMafx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaIsuVGPUN30uJI+MM+wA6P/v1h8dXFhS8TXPpLPUnfEoMCNzj/7MDERQG+dcfo7Fo/Ri0XmOvyAX6C9pIhH2FY99G5RGdV3K0xkubEl+y0mlyXHdbq8U+ZUKtUCKqZxSnpmXgf60M0J5xpl5G+LCrOkq52JrJN2sdtEWiPFvtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=REE3wYrV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="REE3wYrV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992149; x=1797528149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/R2DK4fMzY4wGavtaDh/rSLGaG0BpBIxmJhhkYMafx8=;
  b=REE3wYrVAA/5ulfvDS1l7PmkpbvOT2djTcJCYB22WL7qropYn7ogLtmZ
   WVRfJ/LeakM20V1uPW7uotT0LrSfAVl/VgRJ3cCUyTV96zgq7QQVy3tpq
   ZvmTwHYmQU1ZCTyYKRJ4vcvlvxLcONHzU8wQhVNaZefcPjQL50/XFiQeJ
   eVSNRRaQ70j3uHpPyFJnEprWzU3h5pQkOumvy5An7MoY01eQ5YWa1EIqA
   JOSUBtYj6mTWQT7hhbxA3PNHIe79DOIjEKGZ4xs2DAW/D0W7PReNtclCH
   8zmZBUDDHPK5KZQl5LmHU2+xObfi5g2O3WQ5dq6PJ0nXHFkx6qfcO0q5r
   w==;
X-CSE-ConnectionGUID: qtBCN4BwReqqzvEHUG/buw==
X-CSE-MsgGUID: hWBJ7UA+TpilMwecpVPM2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594838"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594838"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:38 -0800
X-CSE-ConnectionGUID: NWoLSrEwRmC1j8O7hC9ZvQ==
X-CSE-MsgGUID: 3R8lPylZR86JTgz39U62Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748264"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:36 -0800
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
Subject: [PATCH v17 27/32] x86,fs/resctrl: Compute number of RMIDs as minimum across resources
Date: Wed, 17 Dec 2025 09:21:14 -0800
Message-ID: <20251217172121.12030-28-tony.luck@intel.com>
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
2.52.0

