Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CB13570D5
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754911; cv=none; b=eGyF6i4zISk8RHDwvkZJduyzH5Dp5nzu28icLG4binwHwTr8pJDBv44Km2hxnpcRVUFiH8LlnbbszZiEL/e9NTyzXTnrpPrbCPdSUhVQOhUsEMqBX2T3leEaUuaIzIF5m3JioeVWoxPm1ewsv/CHeM2whIEhKGNsR7YdzM0zmX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754911; c=relaxed/simple;
	bh=Zb98oa5Tsu6FZrHnx3+dZazYWKu06/vufasATYdm/DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7FLPixJyOtYbMwMCmstDc2wOlLoA/ExnFHP4WWjc3meU7BOyDMsVmE2tnWiTXTpgLt4C/jce+8ejBxijmwdBGD9QaPzCcBtttLqHxmLKs7mJzfp0JbnTnTRQ9/1O175PK5oW4xfDqi1ZTKps8nGLOeBBGPkBOIdVw0t4ARYRh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m85MVGKL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m85MVGKL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754909; x=1793290909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zb98oa5Tsu6FZrHnx3+dZazYWKu06/vufasATYdm/DA=;
  b=m85MVGKLaZrmDPx40BlAksZ6ys0OmyIgqUrdrq98ap5R7kmIlTJxFAC8
   U6Ff/mXXz8mtB1Hf64qVTahnHyylLYvQ1Qy29SJLkmCVkmnYKnA+SYCii
   rqkLHmWEj0+r8nEGpK1I5Y7PZdTcv6l7OIjmH4gnsTYFAsnR8DBs+nVIw
   RpO+TpCek8Hm3P9fyNvnAsIxCOoUg9hM2NbmyDsC/TIo203Uof0If9V/B
   +z1AC2++3iMHHFtrWV6IVgU1DyQvDTYhRpvxBZel1Ys6X6cjubOn8POVo
   IgIU7aH38aUxutLRFYKIgPu9wlKfbSkhNmJZsggEEYKxgSLfL/on8Dm2J
   g==;
X-CSE-ConnectionGUID: oRU1aBSRRN2ymHyfQ+8dTw==
X-CSE-MsgGUID: COQ3M697RFezWQBZtLG31g==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481346"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481346"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:35 -0700
X-CSE-ConnectionGUID: IknzJvYIQUqtfIC8WtyrUQ==
X-CSE-MsgGUID: CnwwZxWUQ6OeNYsow0KIlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901404"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:35 -0700
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
Subject: [PATCH v13 27/32] x86,fs/resctrl: Compute number of RMIDs as minimum across resources
Date: Wed, 29 Oct 2025 09:21:10 -0700
Message-ID: <20251029162118.40604-28-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 15 +++++++++++++--
 fs/resctrl/rdtgroup.c              |  6 ++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index a8eb197e27db..9eb1bca9436b 100644
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
index b67faf6a5012..15b2765898d6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4286,6 +4286,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
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
2.51.0

