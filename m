Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7D81CB53D
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 23:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732319922; cv=none; b=Kp3+z5IA0QXKNwbQ8vpzy6hKhwzjEG3HS+sA2cMlzB/bVJjKsP/b5L77Y8fDt/4GJlTbwz9yKLJR+uGcgc7UcJm1gsrJTpbGlxoBM+ZN+KavSpDnoQFMC4OahY9N/Ym3anoswpawoB0EnLb+pTG6yEH1LCc03b1qWXDpxosHTM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732319922; c=relaxed/simple;
	bh=Syhd0kuw6fN7AJ+GTquPajZxSLFc2Qlh/gYSKbznIJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baHx9emKK5SGW2SvI4iQ1T3j8mlw2LeZh+C5ayyAx3/mZcd80+xp6gffQXK1D1VdhwDkCM25EomOyvkSDbBck/eMzBk8cIiMkQYXiivrQijvw3DBRT1HbKmFr7OMx98halVB+Y9T27c2FX2na/GLYxRewFjZGemlQL5/iQxWjbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XJgM4I95; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XJgM4I95"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732319921; x=1763855921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Syhd0kuw6fN7AJ+GTquPajZxSLFc2Qlh/gYSKbznIJw=;
  b=XJgM4I95tnEpdHSgqV1ERu140bKmBDIC8yY2VXaG6JN9iTeVlscTw4Qf
   b/0iWlp49Uh90K38nFGIyr+0mHgqlmvrfrn9/4iQ66q8KqRbeZhOWMK73
   NgRvNBLNJ2yFghRlNtUnDzYPzPrHLOH5W6Gv3OdsJ8WgHgwbCbCLK9/24
   Cc97rmBSoSZ/ByUYKynlBU9g9RIStT3qpfGGaRZarwpVbDBQsfLzC5F2m
   8nRb0J/ny/PB6ypMf2+BWB4j0bqPHydMoZRdcTGnVLNXmDyyA0aNC0Dme
   0hHgFu6mOsr8VZ9lDaHp9kSyrHiq/ugjKxb+hX27HU+GIAOSc1eGHFdIo
   Q==;
X-CSE-ConnectionGUID: GbccpyR3TgCl+RjG0HhI8Q==
X-CSE-MsgGUID: e4SrlNSaRJuHY/EQyu14kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32642714"
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="32642714"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:39 -0800
X-CSE-ConnectionGUID: 3sWU245SQn23T3YiF4rzcw==
X-CSE-MsgGUID: O4q4Mf85SIKarPVZYNQ+ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="90850899"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:38 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 3/8] x86/resctrl: Modify update_mba_bw() to use per CTRL_MON group event
Date: Fri, 22 Nov 2024 15:58:27 -0800
Message-ID: <20241122235832.27498-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241122235832.27498-1-tony.luck@intel.com>
References: <20241122235832.27498-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update_mba_bw() hard codes use of the memory bandwidth local event which
prevents more flexible options from being deployed.

Change this function to use the event specified in the rdtgroup that is
being processed.

Mount time checks for the "mba_MBps" option ensure that local memory
bandwidth is enabled. So drop the redundant is_mbm_local_enabled() check.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 7ef1a293cc13..6fe2e6ab8dd4 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -752,20 +752,20 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	u32 closid, rmid, cur_msr_val, new_msr_val;
 	struct mbm_state *pmbm_data, *cmbm_data;
 	struct rdt_ctrl_domain *dom_mba;
+	enum resctrl_event_id evt_id;
 	struct rdt_resource *r_mba;
-	u32 cur_bw, user_bw, idx;
 	struct list_head *head;
 	struct rdtgroup *entry;
-
-	if (!is_mbm_local_enabled())
-		return;
+	u32 cur_bw, user_bw;
 
 	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
+	evt_id = rgrp->mba_mbps_event;
 
 	closid = rgrp->closid;
 	rmid = rgrp->mon.rmid;
-	idx = resctrl_arch_rmid_idx_encode(closid, rmid);
-	pmbm_data = &dom_mbm->mbm_local[idx];
+	pmbm_data = get_mbm_state(dom_mbm, closid, rmid, evt_id);
+	if (WARN_ON_ONCE(!pmbm_data))
+		return;
 
 	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
 	if (!dom_mba) {
@@ -784,7 +784,9 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	 */
 	head = &rgrp->mon.crdtgrp_list;
 	list_for_each_entry(entry, head, mon.crdtgrp_list) {
-		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
+		cmbm_data = get_mbm_state(dom_mbm, entry->closid, entry->mon.rmid, evt_id);
+		if (WARN_ON_ONCE(!cmbm_data))
+			return;
 		cur_bw += cmbm_data->prev_bw;
 	}
 
-- 
2.47.0

