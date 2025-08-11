Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DC22E54D5
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936271; cv=none; b=KLCOCHaILJAr7T/cRL5zdsqhOf0e/CuUF7ImNwJ9VgQBAcRw5lTy7jWIEMJVUEQ2GsE/HDe+KWKbqOGE97m4HMJbpcpcptq5cD8kUKhAUj2maYqso9c/JLWbCSAyJDN+8fdmCh4O/xjofTGj/FKvioAibKf6aYmm4eMiKnkZOV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936271; c=relaxed/simple;
	bh=sw+euk2AZUSojRcvrV7jLAishCzKBceO1HRJvLkyXvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3ETa4z+3I3X9nvHdrG6eVsoVOq1p09NF1iVGgjnWhck8W0FNU5p7gTDSd0zrs956HHT1O65dhp9/EHm27NztqhPVj6DK3isVOdrECFANqMQEyCci0IydAGHIoKineU1j0D6RKlyo+DbnPtcl92cY1i2TxVw857oIfxUin3Sgig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IrMezgAT; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IrMezgAT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936270; x=1786472270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sw+euk2AZUSojRcvrV7jLAishCzKBceO1HRJvLkyXvw=;
  b=IrMezgATYBkmuzWlkpBgCn4kQsupq2/bcq+xlCcuH9UNMujGm1+T9iSV
   hIlVwAB3nfZ8FQwaqiLRHsZ3gSYgTek7teNApDK2kZ8l5Aq7XMeidv1DE
   Ly844e3ln7a2p1AaCAid/Vnrp+Paxk9LTkMJQPViaeoNrPvSbxCcdp3+E
   piu1jpFsAf77LxqCTfSLMEw9azcIj3cxUAGnGUq7WxTZ9FcQt7ngjlv2d
   j09Q4Op/WIQZohX0rmaNxvCBDFagjGXmUXBm/zUP7ALmaD0To7PH4kpca
   d2u2WB9hS57SZRkaazuQ+eyqYupLzq+i1OpXMtO0qTYWMUvmkhaIYVKqa
   w==;
X-CSE-ConnectionGUID: DjpOrXO0TXWSMrxiG9uk6g==
X-CSE-MsgGUID: iZOaWP9CStK2RoXX6CjVmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277524"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277524"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: u+tWpg20QKCVbNa/HSGLXw==
X-CSE-MsgGUID: nEo+oUipT6ieuRz44QGeQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825705"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
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
Subject: [PATCH v8 27/32] fs,x86/resctrl: Compute number of RMIDs as minimum across resources
Date: Mon, 11 Aug 2025 11:17:01 -0700
Message-ID: <20250811181709.6241-28-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that only the L3 resource supports monitor events, so
it simply takes the rdt_resource::num_rmid from RDT_RESOURCE_L3 as
the number of RMIDs.

The addition of telemetry events in a different resource breaks that
assumption.

Compute the number of available RMIDs as the minimum value across
all mon capable resources (analogous to how the number of CLOSIDs
is computed across alloc capable resources).

Note that mount time enumeration of the telemetry resource means that
this number can be reduced. If this happens, then some memory will
be wasted as the allocations for rdt_l3_mon_domain::states[] will be
larger than needed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 15 +++++++++++++--
 fs/resctrl/rdtgroup.c              |  5 +++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2b011f9efc73..0284da075ea6 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -110,12 +110,23 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 	},
 };
 
+/**
+ * resctrl_arch_system_num_rmid_idx - Compute number of supported RMIDs
+ *				      (minimum across all mon capable resource)
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
+		num_rmids = min(num_rmids, r->num_rmid);
 
 	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
-	return r->num_rmid;
+	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 55ad99bd77d2..5352480eb55c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4116,6 +4116,11 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  * During boot this may be called before global allocations have been made by
  * resctrl_mon_l3_resource_init().
  *
+ * This routine is called at resctrl init time. The number of supported RMIDs
+ * may be reduced if additional mon capable resources are enumerated at mount
+ * time. This means the rdt_l3_mon_domain::states[] allocations may be larger
+ * than needed.
+ *
  * Returns 0 for success, or -ENOMEM.
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
-- 
2.50.1

