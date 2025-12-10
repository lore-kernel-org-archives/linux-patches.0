Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B8E2D8DA3
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408504; cv=none; b=KDQpnNKwUsKtpOLlGF82bWvCDAoIK17AshuYh6TtrPYgp+QDvvAWD/nd0aNRijsZzWIeDIJ7vC1T1TnAhQb+w7sX09A5FfAXg0XdOcsMNhZ7QP0S8tdDTH8pR9XvnnekhgzaQ2l3z2WE4kTAJtejX0RlPPRfGCWNLW541vUnqWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408504; c=relaxed/simple;
	bh=9KtQhAEuNacTIhDtiaux0qfjZKcSMZhDOZ14EYOTjwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnLaoGnb+un+6vzObGFFzHEBdp/5eA0NlRbeUGSuxamFkjWPEhvj7nGgBkDg/MrGQtSVwqBGaMUJr9Id/Vgo+oDdU5Em5u7Dp+2NZx0pvpvoIsfnc+Sda68p0XNuIEoM4H7LConY5DLBLfkF2hNfFsnXGw88jx9y4rKPKvv+QXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kg2CZPOC; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kg2CZPOC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408495; x=1796944495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9KtQhAEuNacTIhDtiaux0qfjZKcSMZhDOZ14EYOTjwQ=;
  b=kg2CZPOCEgCFEWhukLqujZRApZcqos52detQpRwFGJyRJrRdIE5dyTVB
   zTEg9Eind1J5lB2eLLFvCSCH92o3A93mPL3dCGL/BkR3iBjCwOL9OkPFT
   nfUVj5W1p2/Y/PB671OUjWXfHM/RBUHrN36NT50Mu0hMQxzzPjWnv4gS6
   /q5BuEvU3RViiV7hccFDQhhndFML6MTIRA3Q6lWzmWrePSsOU4ugsaiLS
   OI5R+ppvPbDuxRde+OCnfe80uwL8pVGsAMcb/P75vTGrjkLrt5GiVBbHq
   WsEoW5NyKVH6z6TrYAw1zTVPtltj2eEPWtaSDJGxXmhfbCWmaW2VbFDVr
   A==;
X-CSE-ConnectionGUID: uMVH/IUwSHi0A58H0Ay2tg==
X-CSE-MsgGUID: OS149YNyQoq8OLd54Qn7zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973598"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973598"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:34 -0800
X-CSE-ConnectionGUID: 9H1zVkj4TtargcZiv9i/8A==
X-CSE-MsgGUID: aIiSpyglT0WkhdBellUIFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297083"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:33 -0800
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
Subject: [PATCH v16 15/32] fs/resctrl: Emphasize that L3 monitoring resource is required for summing domains
Date: Wed, 10 Dec 2025 15:13:54 -0800
Message-ID: <20251210231413.59102-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The feature to sum event data across multiple domains supports systems with
Sub-NUMA Cluster (SNC) mode enabled. The top-level monitoring files in each
"mon_L3_XX" directory provide the sum of data across all SNC nodes sharing
an L3 cache instance while the "mon_sub_L3_YY" sub-directories provide the
event data of the individual nodes.

SNC is only associated with the L3 resource and domains and as a result the
flow handling the sum of event data implicitly assumes it is working with
the L3 resource and domains.

Reading of telemetry events do not require to sum event data so this feature
can remain dedicated to SNC and keep the implicit assumption of working with
the L3 resource and domains.

Add a WARN to where the implicit assumption of working with the L3 resource
is made and add comments on how the structure controlling the event sum
feature is used.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/internal.h    | 4 ++--
 fs/resctrl/ctrlmondata.c | 8 +++++++-
 fs/resctrl/rdtgroup.c    | 3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 0110d1175398..50d88e91e0da 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -92,8 +92,8 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
  * @evt:             Event structure associated with the event file.
- * @sum:             Set when event must be summed across multiple
- *                   domains.
+ * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
+ *                   across multiple domains.
  * @domid:           When @sum is zero this is the domain to which
  *                   the event file belongs. When @sum is one this
  *                   is the id of the L3 cache that all domains to be
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index f319fd1a6de3..cc4237c57cbe 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -677,7 +677,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
 	enum resctrl_res_level resid;
-	struct rdt_l3_mon_domain *d;
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
 	struct rdtgroup *rdtgrp;
@@ -705,6 +704,13 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
+		struct rdt_l3_mon_domain *d;
+
+		if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		/*
 		 * This file requires summing across all domains that share
 		 * the L3 cache id that was provided in the "domid" field of the
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 4952ba6b8609..dce1f0a6d40b 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3095,7 +3095,8 @@ static void rmdir_all_sub(void)
  * @rid:    The resource id for the event file being created.
  * @domid:  The domain id for the event file being created.
  * @mevt:   The type of event file being created.
- * @do_sum: Whether SNC summing monitors are being created.
+ * @do_sum: Whether SNC summing monitors are being created. Only set
+ *	    when @rid == RDT_RESOURCE_L3.
  */
 static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 					struct mon_evt *mevt,
-- 
2.51.1

