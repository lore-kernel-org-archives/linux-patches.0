Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CCF23FC54
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044897; cv=none; b=u23/NorAAdtMC1KmaufalUP49O96NaWNSxEIwITjZTKJIW1j43xoTIL4O3pRpfphex/C077DP6lx6smUumysmw2B/cDmCUqFLEPNwNr7b0qxzNu/iuxXc6OBOk3nx8GcwE7miJmCu1dOIkc2FeDLYLRCygV/AeEPa642SFkRDxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044897; c=relaxed/simple;
	bh=4MoQg5m1EvWqC4eUPuuvU9SN1nimbFf5mvHqPzoqqSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j85w2wHOJuTNS/ub4Zk1umVwdBy+RLRoJ+fwmbgX96meGag8q16UbWVHaHZh4KMF9U3A3aRQ9zd3Nx3IEVpZfwIZZNpNYuD8tJZzHa6BpMfCDvDkzazWJWwDBtM/YVWsakUpt0HLwB78vr35eXTpIN6ZaI/N+YvyKRCXuata7bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i3JwKWBD; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i3JwKWBD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044896; x=1772580896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4MoQg5m1EvWqC4eUPuuvU9SN1nimbFf5mvHqPzoqqSs=;
  b=i3JwKWBDuVJujkXcWDQpEBcj0i9x1A1l7xQ4iBup2EdseOCl84v3CNjj
   XwEftK1MH2B8iKhRvGO/obd5vFnK0eDHn9bZWv/eB9MEBRByBURt17Tdc
   g6Lt/EAq9OJR3EO+K9f3O2rsAOuKjEhqf02Vtsg9dXO2LgjKv1P8itDlq
   Ld1rbL4rWVlAL0A7PHUAF5aFJ1YUSL2QIXHSkkGM7rndJQuvksjNRjEKD
   FIv8eqt69ZHvIfp3rdJGUo6TGfuJNPdhSSlBGuo9XeAam1JPLI+4qqRxG
   03YBLaC+G/ssKOQTUQC2nCkWi+bJpLTZlY6rxpExq/oVyHeZsppTy+3Mv
   g==;
X-CSE-ConnectionGUID: Q6qWBuZLQISkVvz2GHRBaw==
X-CSE-MsgGUID: oxo8VU+9QNyHDmq8WUYGGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835974"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835974"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:47 -0800
X-CSE-ConnectionGUID: QNCp+lAXSwKixeh97KdsSw==
X-CSE-MsgGUID: I+AbBn3jRhKXI4y+W11s4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982302"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:53 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 12/17] x86/resctrl: Add list of known events to RDT_RESOURCE_INTEL_PMT
Date: Mon,  3 Mar 2025 15:33:32 -0800
Message-ID: <20250303233340.333743-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Core code uses this list to populate "mon_data" directories.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_pmt.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_pmt.c b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
index 754748d858c6..05640e85d303 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_pmt.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
@@ -13,6 +13,7 @@
 
 #include <linux/cpu.h>
 #include <linux/cleanup.h>
+#include <linux/minmax.h>
 #include <linux/slab.h>
 #include "fake_intel_pmt_features.h"
 #include <linux/intel_vsec.h>
@@ -254,14 +255,35 @@ void rdt_get_intel_pmt_mount(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_PMT].r_resctrl;
 	struct rdt_core_mon_domain *d, *tmp;
+	struct telem_entry **tentry;
 	static int do_one_time;
+	struct mon_evt *evt;
+	bool ret = false;
 
 	if (do_one_time)
 		return;
 
 	do_one_time = 1;
 
-	if (!get_events()) {
+	if (!get_events())
+		goto done;
+
+	for (tentry = telem_entry; *tentry; tentry++) {
+		if (!(*tentry)->active)
+			continue;
+		for (int i = 0; (*tentry)->evts[i].evt.name; i++) {
+			evt = &(*tentry)->evts[i].evt;
+			list_add_tail(&evt->list, &r->evt_list);
+			ret = true;
+		}
+		if (!r->num_rmid)
+			r->num_rmid = (*tentry)->num_rmids;
+		else
+			r->num_rmid = min(r->num_rmid, (*tentry)->num_rmids);
+	}
+done:
+	if (!ret) {
+		r->mon_capable = false;
 		list_for_each_entry_safe(d, tmp, &r->mon_domains, hdr.list)
 			kfree(d);
 		r->mon_capable = false;
-- 
2.48.1

