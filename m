Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B6D30BB89
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394854; cv=none; b=prUOR8bwuGBNgfmOtri9WTYL9vuwin7YmmIfN3lK6u4llC+r4mgP60xXbn6Qp0YO5EUIsBt0N9uTX99e5m1D60T0SlP6AYs8KRgrOQJRDD3bWxSf+UROFOhtLjSvnDVzMtn/MEvpYzjEgU8HbnCkyw0YhPhJUBx9LZlV5K2e/4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394854; c=relaxed/simple;
	bh=KlJaHRdRtq0V96pXGnhylW65awcxhx2/sA0W1/f5y2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjDvKs++ypTe1Di9AegbAOg9FmOXSJjf9rsozJzqGf4c83z8HDa5p9VmTHnBPH1IwtKb3czPwdcRY7N19aJOWlNyffOU8b3ldY8hZcxUmMEhJYLLFGA+Hq3xDbvyIOHzrOP91NwiheuibEwxbiOUtJxAe+It1wmkgwJgHDMzmAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACCUYSAf; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACCUYSAf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394852; x=1791930852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KlJaHRdRtq0V96pXGnhylW65awcxhx2/sA0W1/f5y2w=;
  b=ACCUYSAf55JmpmqtLhVVI4AyilmV9FGaQy5W4eLIW80JEbnM31eCQV4/
   PbUFw5/uWZP9qwuHyxdXr6mtGfINtMt0aWlYiRyyBqVXACN8Rl2fUU9B/
   xQ6LYpcQTMQ2Y3g21knh2/mYte4OkOPUvZof6PFKix39i0VeSdh9ONzhW
   JBEjmzxR3Mw62XQ9qAChRbcfOZrXiCs0aL66+JqMEWgvdytsuY0gBRe/S
   smisktEImjTjpKuyhvFzwMX5WlgiipmcbG0s6FwmljufUYWe/8NX9sQbT
   4rtiBlcM2uLUE6FTuDzmI9Ew1u2SIdxBA+EQ33rDZ3R+M6/tV5qcJ6q4T
   g==;
X-CSE-ConnectionGUID: PMLgxNr9R1OJeqMIy2ix9g==
X-CSE-MsgGUID: LsVj3FKdSaqZu0yTWaNwRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168900"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168900"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:03 -0700
X-CSE-ConnectionGUID: BTfaIpQuRCaEvP+98pJ1SA==
X-CSE-MsgGUID: OF4tgUQiQsy6ld38F8ulfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145316"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:02 -0700
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
Subject: [PATCH v12 21/31] fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp()
Date: Mon, 13 Oct 2025 15:33:35 -0700
Message-ID: <20251013223348.103390-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rmdir_mondata_subdir_allrdtgrp() is complicated because of the support for
Sub-NUMA Cluster (SNC) mode.

Refactor into a helper function for the SNC case to make it easier to add support
for a new telemetry resource.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/rdtgroup.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index b7eaa4388768..837279d97db4 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3162,6 +3162,29 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
 		kernfs_remove_by_name(kn, subname);
 }
 
+static void rmdir_mondata_subdir_allrdtgrp_snc(struct rdt_resource *r,
+					       struct rdt_domain_hdr *hdr)
+{
+	struct rdtgroup *prgrp, *crgrp;
+	struct rdt_l3_mon_domain *d;
+	char subname[32];
+	char name[32];
+
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return;
+
+	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
+	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
+	sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
+
+	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
+		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
+
+		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
+			mon_rmdir_one_subdir(crgrp->mon.mon_data_kn, name, subname);
+	}
+}
+
 /*
  * Remove all subdirectories of mon_data of ctrl_mon groups
  * and monitor groups for the given domain.
@@ -3172,25 +3195,19 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 					   struct rdt_domain_hdr *hdr)
 {
 	struct rdtgroup *prgrp, *crgrp;
-	struct rdt_l3_mon_domain *d;
-	char subname[32];
-	bool snc_mode;
 	char name[32];
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+	if (r->mon_scope == RESCTRL_L3_NODE) {
+		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
 		return;
+	}
 
-	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
-	if (snc_mode)
-		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
-
+	sprintf(name, "mon_%s_%02d", r->name, hdr->id);
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
-		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
+		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
 
 		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
-			mon_rmdir_one_subdir(crgrp->mon.mon_data_kn, name, subname);
+			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
 	}
 }
 
-- 
2.51.0

