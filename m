Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECD047D930
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198284; cv=none; b=lr9x+lgWtc61ldXRagjvdpQ0CKdyqmekspKX3DU7GpvoCAhvJ5Sj0oxdURx+z1qdxfWo6u/by6KZVzSz5GB+nHdkCzXPeZghjiM5g6Sz3JG7VsJ/371WGTdMdj+w4wlpDSW/pWBe5iCLYtOUnxuKryc1ykKtHy+rvlQpf6P24zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198284; c=relaxed/simple;
	bh=xBMNQdFLWOol3ORAaGkugwtnykTZuR9r21XAYlCUVtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpRyjb4cOvBFVqRMfCxgYQ5+Do74vg7MCey5pqKTLltU1+3Rlsx+HwnetqYv1oe3QJ8uf7g21kYUUAHewytGqiBUz9MasdgEMws6w5unW3V07mejjGQ3PhKSsa9aCozda87XHZHhgg/fx+6Omgx/en+9rXaPWVgwPvyA+TNIgyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YKoqoGiI; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YKoqoGiI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198283; x=1819734283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBMNQdFLWOol3ORAaGkugwtnykTZuR9r21XAYlCUVtM=;
  b=YKoqoGiIm79G13KHRNHpY69qh6K34LubA2fVMSyfyxwz7akv2jC25oZW
   jbyKnbLSrArH/2GGqP/XtCkQ3vLnRqNqxte4x2iSMjSH6eo4+QNFsuttU
   m/BWe61fONyvDCfhoOymx7xfj8GELNmdxUfBloAFtE9AgZtTLxoECkZV7
   cfRL2CFiz7lsCsRkEjQa4SQAwAxa6d0BLlx61sorS8ACDV3zk6s0gqqjZ
   eHwuHA4g4boRCUkogczcsZSQMoA97AX2JeOEUoARl7ngZ6OTzVltove00
   fFCeB+ghvvr1geA4ldVxL4VFqTI4F3sR3RfEOO5+Ekid7itpSWoCe74vE
   g==;
X-CSE-ConnectionGUID: Pp9u77GgQ4Gem3AYMC+RjA==
X-CSE-MsgGUID: XAicCsvjRnq0wp4lMxNiYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480036"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480036"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:38 -0700
X-CSE-ConnectionGUID: TpDsyezhTxyxFrBLdMbY1Q==
X-CSE-MsgGUID: gJkWsJYwTn+xWqOyUWQSlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906995"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:37 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 13/23] x86/resctrl: Handle systems when AET is the only resource
Date: Mon, 31 Aug 2026 10:44:11 -0700
Message-ID: <20260831174421.13921-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a system with no L3 monitor resources it should still be possible to
run with just AET.

Update get_rdt_mon_resources() to return true based on whether the
system supports monitoring rather than on the presence of any of the
L3 monitor features.

Make rdt_get_tree() handle the case where AET is the only feature, but
is not enabled for a specific mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	Split the AET RMID cap change into separate commit.
	s/Fix get_rdt_mon_resources/Update get_rdt_mon_resources/
	New subject for this patch

 arch/x86/kernel/cpu/resctrl/internal.h | 2 +-
 arch/x86/kernel/cpu/resctrl/core.c     | 7 ++++---
 arch/x86/kernel/cpu/resctrl/monitor.c  | 4 +---
 fs/resctrl/rdtgroup.c                  | 8 ++++++--
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e46eb9a4c725..d70c8cb1cb81 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -226,7 +226,7 @@ union l3_qos_abmc_cfg {
 
 void rdt_ctrl_update(void *arg);
 
-int rdt_get_l3_mon_config(struct rdt_resource *r);
+void rdt_get_l3_mon_config(struct rdt_resource *r);
 
 bool rdt_cpu_has(int flag);
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index ef37fbb586d3..0ddec2b67e3d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1016,10 +1016,11 @@ static __init bool get_rdt_mon_resources(void)
 			ret = true;
 	}
 
-	if (!ret)
-		return false;
+	if (ret)
+		rdt_get_l3_mon_config(r);
 
-	return !rdt_get_l3_mon_config(r);
+	/* Even if there are no L3 monitor events, AET might be supported */
+	return resctrl_arch_system_max_rmid_idx() > 0;
 }
 
 static __init void __check_quirks_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index bc2df287ccfa..e3485dc55923 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -431,7 +431,7 @@ static void __init intel_rdt_mbm_apply_quirk(u32 num_rmid)
 	mbm_cf = mbm_cf_table[cf_index].cf;
 }
 
-int __init rdt_get_l3_mon_config(struct rdt_resource *r)
+void __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	unsigned int mbm_offset;
@@ -514,8 +514,6 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 		intel_rdt_mbm_apply_quirk(r->mon.num_rmid);
 
 	r->mon_capable = true;
-
-	return 0;
 }
 
 static void resctrl_abmc_set_one_amd(void *arg)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index de07ccdffdb2..3ac518ed2368 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3195,6 +3195,11 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = setup_rmid_lru_list();
 	if (ret)
 		goto out;
@@ -3253,8 +3258,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (resctrl_mon_capable())
 		resctrl_arch_enable_mon();
 
-	if (resctrl_alloc_capable() || resctrl_mon_capable())
-		resctrl_mounted = true;
+	resctrl_mounted = true;
 
 	if (resctrl_is_mbm_enabled()) {
 		r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-- 
2.55.0

