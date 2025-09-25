Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCC8324B38
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830665; cv=none; b=Co3Lo0HicUvHXxfpEOhLKIPB0gVtt0UFmH2rBVHxV7pGknJfgZ1Q6o1JJMYpXF/gveJjmgtwL8DZ8d5v/WM1u3ePT7tsRbzNRITD+3o1uhHaycC6B5I/KD5atwlVtzQKENYo0hNGhXKbWbqBAPWzuahNvHL6BfRCHncDa75EHf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830665; c=relaxed/simple;
	bh=A/s/Fc4eulOfSdUOZRNHjPNqYxrapq1zmZT32Ja/r34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKXKrS1cKIuS/ehkLymZM2uZzJc18L+OPyDCYNx7W9ZEeG8yGK/ZOE7b4BZ9+a6Z+UZ7wo1LWlDCSd8Mv1FjvProHObtfVJeZ4k2KiSLuqHkACQNsgLn1wJI5tyXwkdNCRhfmJis8cc/zG3P9Hl0vo5Ojr/RI6opP9WBy1lkr0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N9u8bH7Y; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N9u8bH7Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830664; x=1790366664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/s/Fc4eulOfSdUOZRNHjPNqYxrapq1zmZT32Ja/r34=;
  b=N9u8bH7YVpV9LlKmzCS2P/DKKN/LTk+ELWKKNcxkeJ15ho6cRhFU0Dd3
   jr0LLRdAEdlbjB7YZt9LrmqcZW5ud70zGB3HPCDCUz8Cvc/bFs0AyJ9iL
   dTQQyBgIP9s3jzui1WLRJFwhYBz/MoA8J1oz8z+DA3IIz1jMgnjSxidLR
   G60H14f/KnfHPFWAiKmtU45Jrz1B5HfKegepw3ImMheEVXtTvwdFRkAPk
   EazA64B6wGlAG/SHQzYmqMkibOZAbHcMKxGMw1IWT4O+dJ/g1KOITVxr1
   yf6drLH3CxqT/3u7u8A0ON0ocJb8p08jwuS/p32xhGvjrRfVqTpm4XDQR
   g==;
X-CSE-ConnectionGUID: qMjlt7yHRVCI9mdMbuP0JQ==
X-CSE-MsgGUID: ZRYeM1IRR2S4zFXcpLtvpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074354"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074354"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:14 -0700
X-CSE-ConnectionGUID: hSsBN8VEQVK4z0Lm0vX3Ew==
X-CSE-MsgGUID: eV6PWUQ6QySosY+aCkOqVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003691"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:14 -0700
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
Subject: [PATCH v11 25/31] fs,x86/resctrl: Compute number of RMIDs as minimum across resources
Date: Thu, 25 Sep 2025 13:03:19 -0700
Message-ID: <20250925200328.64155-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that only the L3 resource supports monitor events, so
it simply takes the rdt_resource::num_rmid from RDT_RESOURCE_L3 as
the system's number of RMIDs.

The addition of telemetry events in a different resource breaks that
assumption.

Compute the number of available RMIDs as the minimum value across
all mon_capable resources (analogous to how the number of CLOSIDs
is computed across alloc_capable resources).

Note that mount time enumeration of the telemetry resource means that
this number can be reduced. If this happens, then some memory will
be wasted as the allocations for rdt_l3_mon_domain::mbm_states[] and
rdt_l3_mon_domain::rmid_busy_llc created during resctrl initialization
will be larger than needed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 15 +++++++++++++--
 fs/resctrl/rdtgroup.c              |  6 ++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 5b7f9a44d562..1d43087c5975 100644
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
index 19efb345c4a6..5e3ee4b8f70b 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4268,6 +4268,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  * During boot this may be called before global allocations have been made by
  * resctrl_l3_mon_resource_init().
  *
+ * Called during CPU online that may run as soon as CPU online callbacks
+ * are set up during resctrl initialization. The number of supported RMIDs
+ * may be reduced if additional mon_capable resources are enumerated
+ * at mount time. This means the rdt_l3_mon_domain::mbm_states[] and
+ * rdt_l3_mon_domain::rmid_busy_llc allocations may be larger than needed.
+ *
  * Returns 0 for success, or -ENOMEM.
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
-- 
2.51.0

