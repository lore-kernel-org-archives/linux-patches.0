Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D159346761
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992128; cv=none; b=DDsMyac1s373ffKfHcFuQkXpQfVdD8ASb7g3Vc5FFze31C+kymntWvbNCpMwNwrq2gPyorAZswh3uO+l3C0tggmnORvjFTO8wBpF7XjgLbPtuDFg/0KoS8fGNw8dK48tmQV3b8+fccPoJJY6W8LplUozr+I1r3HeOyLeQL+FQV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992128; c=relaxed/simple;
	bh=3ZyHJ27pCOGlhcVQLg5dYL1pUnUiyGgQGFEaEN5p68k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvNxFjBDfoWKTWzD5Cbs/3jKkfWH7VfcPO0avfloH+IgBtcW0W/JPnO2z2LK+5ZLm3oKJseexhWyLZiej7QQBI0waQhOSkxIo354sPQGBJE7beBJLwwBlvOfvgTVW0iN7jV+3opz4ksMSO7qeI7TH/rqTgxPp8c9p0eTs9OH3dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TW+3klvX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TW+3klvX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992123; x=1797528123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ZyHJ27pCOGlhcVQLg5dYL1pUnUiyGgQGFEaEN5p68k=;
  b=TW+3klvXV14NEcD/edL9d9PGzhdyFaQ56BoJOCo7BZP8NtVUvPzgFp13
   8chqfjiTjR8uBJTnYSeAZ04IcK03PnTuMNjOdU/1444q43YJJPQ37Bg3s
   MaXJUnEPABbV1LrRQCiTiR37fHX/2aNLXQYDddF3v99xu9hQ61jkGaK4o
   thrY/FV4IdZ5L/WYw/L3IzZYSoipTcJ7g5S8i66135ywwvVsdOWu/w1Si
   S08Pvvt4DMW7ROVV8XXqO48uBz/VMI0qZzYitxriyWij+bAxDvSbHlQW6
   HqA4EJsoFtAAKb/3ZIS1vqlf6JJRmW+KPKIev8MOWLlwmP9b8mXz7L/cG
   w==;
X-CSE-ConnectionGUID: P6PJuM8+TEyL1Reaih6gww==
X-CSE-MsgGUID: KnrpyW+XRuCh/hykXKmxoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594742"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594742"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:35 -0800
X-CSE-ConnectionGUID: vYypdBnDQ5mGoTgMKdpQeA==
X-CSE-MsgGUID: 4QtwwgjcQZ+/te7aAbDhwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748214"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:34 -0800
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
Subject: [PATCH v17 15/32] fs/resctrl: Emphasize that L3 monitoring resource is required for summing domains
Date: Wed, 17 Dec 2025 09:21:02 -0800
Message-ID: <20251217172121.12030-16-tony.luck@intel.com>
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
2.52.0

