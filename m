Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B997551FCCC
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600429; cv=none; b=hl0f8l+WFS9WoKMqDveDnyJWwiA2WVZ1bN2IxLO0rTBjVIuX8WUu1IEWs1Qq+ci9+TAsNPtmkCmu3ZPXQnb+KtjtuAsnO89DIho46B1hyIlfnJXrfYus6ACGP7b9UMH7g6+YsZavQTRnakD1Vvsxax+4A6o9kyTnuXV6bR/lORU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600429; c=relaxed/simple;
	bh=rDLLR0LDnRx/9atFQ+G3cGMZ7kZWOpg49SUEMq2vW0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX3IadwQp4AMWVLFLk/XYCN84EMIOs2CIskR5beRXZjIQllqS27qvL/CG71pthWPsMHRzscrx1rmxBouBZ96VR7CD1jy21KN85sTkx1OFNzTiv9rAokJdGvTbqeGBti2Zhxnz9HX71Hsgb48f0ZCKBivz9uWD4GPZj72uq/KQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=byIUXC90; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="byIUXC90"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600427; x=1821136427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rDLLR0LDnRx/9atFQ+G3cGMZ7kZWOpg49SUEMq2vW0I=;
  b=byIUXC907lvpl0RrpuD/wsh61bXQ2o9JgREiYEnxKgGe78ABUCrwZcyq
   kP+yAwihat+rNVGATIbGClszU1Ojp8wUzJ/6TcKYT311alRpreEzC6u5w
   UTPSNbZKbHVU5WBF5iTwPDAkwLbeKlFHD6WaW4wG+u5uER1+oAno00V17
   s+lfNSp9PEz5hPWGDw9WcurCCddHU2e9yQa3+6KnsXwfJfZBrt9AblUdo
   Y8gjBABwkKKQVbJttxk7vDD6vS887hl9ty8LAiWTiAcPv9g40+rmTuDYp
   PpmTzLgq5NC0q8i0WaJnsWAbm3SnE2E9qSTIEwKeWsbSJG3tcfEmV6mQx
   w==;
X-CSE-ConnectionGUID: vipE5QrIQl6ZggV6kfZbdw==
X-CSE-MsgGUID: ns2mdnTSSNaKnfCEpA/bIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861453"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861453"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:37 -0700
X-CSE-ConnectionGUID: ilIvPQJaS5mmoc0aIfMOmA==
X-CSE-MsgGUID: 1WnhJTtjTpCBX2LF8q692Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231476"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:37 -0700
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
Subject: [PATCH v12 15/25] x86,fs/resctrl: Handle systems where AET is the only resource
Date: Wed, 16 Sep 2026 16:13:10 -0700
Message-ID: <20260916231320.14502-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
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

Refuse to mount the resctrl file system if there are no monitoring or
control features.  Add invalfc() to rdt_get_tree() so the console log will
let the user know why the mount failed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Cleanups in get_rdt_mon_resources()
	Add invalfc() to rdt_get_tree()
	Change commit message with updated changes
---
 arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c     | 20 +++++++++++---------
 arch/x86/kernel/cpu/resctrl/monitor.c  |  4 +---
 fs/resctrl/rdtgroup.c                  |  8 ++++++--
 4 files changed, 19 insertions(+), 15 deletions(-)

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
index e633da548959..addcb2a19c98 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -991,7 +991,7 @@ static __init bool get_rdt_alloc_resources(void)
 static __init bool get_rdt_mon_resources(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
-	bool ret = false;
+	bool l3_mon_found = false;
 
 	/* Any monitoring at all? */
 	if (!cpu_feature_enabled(X86_FEATURE_CQM))
@@ -1001,27 +1001,29 @@ static __init bool get_rdt_mon_resources(void)
 
 	/* Any of the L3 monitoring features? */
 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
-		return false;
+		goto skip_l3_feature_checks;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
 		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
-		ret = true;
+		l3_mon_found = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
-		ret = true;
+		l3_mon_found = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
-		ret = true;
+		l3_mon_found = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
-		ret = true;
+		l3_mon_found = true;
 
-	if (!ret)
-		return false;
+	if (l3_mon_found)
+		rdt_get_l3_mon_config(r);
 
-	return !rdt_get_l3_mon_config(r);
+skip_l3_feature_checks:
+	/* Even if there are no L3 monitor events, AET might be supported */
+	return true;
 }
 
 static __init void __check_quirks_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 2f3e5b89a7fc..e684353631de 100644
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
index 0c9c29037667..2e9f71901f68 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3195,6 +3195,11 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
+		ret = invalfc(fc, "No allocation or monitoring features are available or enabled");
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

