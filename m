Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284359;
	b=skWBwoiqHQCzu8xL91t73XZWe9xDOIMselbjz0yZ9bkEiGGoiBjJbDpuZuvkkcwLzV3/
	 pFaBuq9QN/Ceh60fs41c7yW143yOXOvFrryrqjsUTRVeEyIXFLOoToZydAfAg9OYqQanA
	 NaJkFT8MGdxbz0+P9uk3914SeypgotiRlPC8ET/I62oW57Kjvtff4G4lN8vvmqTWjfZsA
	 WsSezNehjzodu2frKekpNXZYpqm1ZM/wxDCdq4hJxmwCYSmgk7L3Mmplf3a3ASCR4LNBN
	 BK+ThWmN6l7ek4H+QXKsaBmTf0ln8mQbAwASSm0Hm9QsOBGkg9PK1CjNQLM80JwWCCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284359;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9UdVGg/h64QrJFmMdvc8IRX8SR/hJQXPD1E3diwN+do=;
	b=HTUPrvXCPdYErJ2OqeyXKvwRSXnx3ONkrJwfhKMKOsnswSrcZLDoFFRJ07RApli8zsfH
	 rtSZxibumM3uDuUWIhb8SH5vdswCMZfU5Q5osgrkPRPDHypkp2JbnCaoGkeaRcU/3CZzz
	 q3bvFqFcaZEJWPy4PloOhk6NKcWhE38upymY4KQzxhb2wz8tkAsTe8c8TPEd2tFrqJCcR
	 pvpj9pT+mVwsea8KMhlRNWhrDEMSuPzcIclaEAMSfqyd5oIcPEY4wGzunBSnjHBC56du/
	 NfOxN5w2/WxYblDJrGamrIPObN/XjPaT2LpIMBLLBXxiTKB+UlLQILisUrqfDsVMBRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kjRI09v+;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8156160A2606
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8156160A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kjRI09v+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284356; x=1825820356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8dfFjAyH1NZ5O/UsFja1Hvgmiui6X/KQMbG0P2/bo+I=;
  b=kjRI09v+5MtAwkG+6h5qCj6XGZrrhcEHQg7LjrljFDn4klPP2IkaJZ0R
   2RKuOXg3vWlRBnBcfvGlK6NuEHyZDJARWNRkiTobN3w5wBryKwJ0E7w0j
   gicvnmUQklAX0e+IwRXUa0fs1TkLcVkWnbRtQofVq5euo2XtRmll/nSaA
   69yNbRiByIgiML3KrsUlzGOnzonmO8+4mTtb5bNfnNE5U87LPLBdAvNIv
   WvND/4W91mINDXBIP7R8BmUNC1YFHvEPnHtXKKf81Wf7FwJE/6NXz1ypq
   cZyL0YLThzYNzDkNIJXQoiGAR5TfqwWbDwkFWmF62mEY6jrJfQ3cXFaQ/
   A==;
X-CSE-ConnectionGUID: 4s+EUHyhQFOmAB3kzfP+wA==
X-CSE-MsgGUID: y3vv48m1RpKN+ZmsctLSfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901293"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901293"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:14 -0800
X-CSE-ConnectionGUID: V2ig3Z3cTsuv9u0S8wjhJw==
X-CSE-MsgGUID: skpaQYrwT4aODqJeOZQhDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856908"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com,
	ruanjinjie@huawei.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	tan.shaopeng@fujitsu.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 1/8] arm_mpam: resctrl: Add a helper to find the component counting an event
Date: Mon,  9 Nov 2026 20:19:01 -0800
Message-ID: <8635f50f938afbe3f58dcd69966c2dd45e2394cd.1794283825.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794283825.git.reinette.chatre@intel.com>
References: <cover.1794283825.git.reinette.chatre@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl_arch_cntr_read() and resctrl_arch_reset_cntr() both drive the
monitors MPAM pre-allocated for bandwidth counting. Each starts with the
same sequence: check that MPAM is enabled, reject cache occupancy and
events without a class, then take the component counting the event from
the monitoring domain.

The duplicated sequence has to be kept in sync by hand. Only the failure
handling differs: one reports the failure to its caller while the other
has no way to do so.

Add find_mbwu_mon_comp() to locate the component, returning an error
pointer on the failures both callers test for. Ignore that error in
resctrl_arch_reset_cntr(), which cannot report it.

No functional change intended.

Suggested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC v2:
- New patch.
---
 drivers/resctrl/mpam_resctrl.c | 62 ++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 5468367776e2..1b1e724ae040 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -7,6 +7,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/limits.h>
 #include <linux/list.h>
@@ -541,26 +542,51 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 				 closid, rmid, val);
 }
 
-/* MBWU counters when in ABMC mode */
-int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
-			   u32 closid, u32 rmid, int mon_idx,
-			   enum resctrl_event_id eventid, u64 *val)
+/*
+ * find_mbwu_mon_comp() - Find the component counting @eventid in a domain
+ * @d:		The monitoring domain to search.
+ * @eventid:	The event to find the counting component for.
+ *
+ * The counters reached through this component are the monitors MPAM
+ * pre-allocated for bandwidth counting. Cache occupancy is not counted by
+ * those monitors, it is read on demand via resctrl_arch_rmid_read().
+ *
+ * Return: the component counting @eventid in @d, or an error pointer when
+ * MPAM is disabled, when @eventid is cache occupancy, or when no class was
+ * picked to count @eventid.
+ */
+static struct mpam_component *find_mbwu_mon_comp(struct rdt_l3_mon_domain *d,
+						 enum resctrl_event_id eventid)
 {
-	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
 	struct mpam_resctrl_dom *l3_dom;
-	struct mpam_component *mon_comp;
+	struct mpam_resctrl_mon *mon;
 
 	if (!mpam_is_enabled())
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
+	mon = &mpam_resctrl_counters[eventid];
 	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
-	mon_comp = l3_dom->mon_comp[eventid];
 
-	return read_mon_cdp_safe(mon, mon_comp, mpam_feat_msmon_mbwu,
-				 USE_PRE_ALLOCATED, closid, rmid, val);
+	return l3_dom->mon_comp[eventid];
+}
+
+/* MBWU counters when in ABMC mode */
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
+			   u32 closid, u32 rmid, int mon_idx,
+			   enum resctrl_event_id eventid, u64 *val)
+{
+	struct mpam_component *mon_comp;
+
+	mon_comp = find_mbwu_mon_comp(d, eventid);
+	if (IS_ERR(mon_comp))
+		return PTR_ERR(mon_comp);
+
+	return read_mon_cdp_safe(&mpam_resctrl_counters[eventid], mon_comp,
+				 mpam_feat_msmon_mbwu, USE_PRE_ALLOCATED,
+				 closid, rmid, val);
 }
 
 static void __reset_mon(struct mpam_resctrl_mon *mon, struct mpam_component *mon_comp,
@@ -603,20 +629,14 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d
 			     u32 closid, u32 rmid, int cntr_id,
 			     enum resctrl_event_id eventid)
 {
-	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
-	struct mpam_resctrl_dom *l3_dom;
 	struct mpam_component *mon_comp;
 
-	if (!mpam_is_enabled())
+	mon_comp = find_mbwu_mon_comp(d, eventid);
+	if (IS_ERR(mon_comp))
 		return;
 
-	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
-		return;
-
-	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
-	mon_comp = l3_dom->mon_comp[eventid];
-
-	reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmid);
+	reset_mon_cdp_safe(&mpam_resctrl_counters[eventid], mon_comp,
+			   USE_PRE_ALLOCATED, closid, rmid);
 }
 
 /*
-- 
2.56.0

