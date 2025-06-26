Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52402EFD91
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956607; cv=none; b=gFIoatEOnMN8J2NJHYoYjdq/1CAOW+VzJVxUgI1QeZ5r6qA3hjlX+3IW9/31ll5WH+5y2KgShzNusf3HTkKBIsi7fXIhBz9F3E4VncBo2SpBdhBn/+eaB4WXmboabn3hwSqK3twX54fqJZEihVCszlIWOxNXcr6nVC63kZb5pYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956607; c=relaxed/simple;
	bh=kRgybYBII5wk9YaXFdZ5FQXPkRnG9bRWdzp1mhTykh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZrFsDBJ+z8Z+zTFWRD3CgqqKzxpKT8cDAH2lFyk6G6bdCvwWA9RlCI8KwJ6+jaIHfl4v82cWdAyuI+TbK71vr81t1cgEQSJfP47WsM/mAPP7+FFtYbHVDhuGSIPeUq2gU72ppgli/H90iRP48aJxwDhjiRhFJRlSZkUk95cVRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b+OknKwH; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b+OknKwH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956606; x=1782492606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kRgybYBII5wk9YaXFdZ5FQXPkRnG9bRWdzp1mhTykh4=;
  b=b+OknKwHSJSB/MrMYwegxSgIzzwF3ZYxv9V1JzEQqRTmI7S82BdGkFbr
   CPV8/LQYxISyumgz9PHFYnGXw7gB6p6RKj3r1S90QS+JRJdygptA/Uif2
   qSsnm3RjbX8IOxWINmJn+FHcCmi81fR5fUuBY91/P7DM/rM2sqoFMqWzT
   FapcwXkxN/92OlYLJylNQQJWyjMnCRy/ei+iexvWrOrI8t1l4LaXPTIJ3
   KHV2kaCOx0vu1rpmapInFSsxiuvdwh3zuwapeDJ6q5VSrY7nNoVaEUaIQ
   pCLN8qZ9vGdoBUmtZc3ByIWxjMt1nbRQcVI1Pt/ae5/hik5no4CelWUTz
   w==;
X-CSE-ConnectionGUID: a6xtpxdNTLyKGsDJgnr+jw==
X-CSE-MsgGUID: UE4TRd2pSz+HPOjNo1fAqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136470"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136470"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:00 -0700
X-CSE-ConnectionGUID: aCcpHcseTPKhaRirHQNcyg==
X-CSE-MsgGUID: W8vRzrBjRgOpytOTRtFULg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069261"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:59 -0700
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
Subject: [PATCH v6 19/30] x86/resctrl: Complete telemetry event enumeration
Date: Thu, 26 Jun 2025 09:49:28 -0700
Message-ID: <20250626164941.106341-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Counters for telemetry events are in MMIO space. Each telemetry_region
structure returned in the pmt_feature_group returned from OOBMSM contains
the base MMIO address for the counters.

Scan all the telemetry_region structures again and save the number
of regions together with a flex array of the mmio addresses for each
aggregator indexed by package id. Note that there may be multiple
aggregators per package.

Completed structure for each event group looks like this:

             +---------------------+---------------------+
pkginfo** -->|   pkginfo[0]         |    pkginfo[1]      |
             +---------------------+---------------------+
                        |                     |
                        v                     v
                +----------------+    +----------------+
                |struct mmio_info|    |struct mmio_info|
                +----------------+    +----------------+
                |num_regions = N |    |num_regions = N |
                |  addrs[0]      |    |  addrs[0]      |
                |  addrs[1]      |    |  addrs[1]      |
                |    ...         |    |    ...         |
                |  addrs[N-1]    |    |  addrs[N-1]    |
                +----------------+    +----------------+

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 64 +++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 8d67ed709a74..c770039b2525 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -19,17 +19,32 @@
 
 #include "internal.h"
 
+/**
+ * struct mmio_info - MMIO address information for one event group of a package.
+ * @num_regions:	Number of telemetry regions on this package.
+ * @addrs:		Array of MMIO addresses, one per telemetry region on this package.
+ *
+ * Provides convenient access to all MMIO addresses of one event group
+ * for one package. Used when reading event data on a package.
+ */
+struct mmio_info {
+	int		num_regions;
+	void __iomem	*addrs[] __counted_by(num_regions);
+};
+
 /**
  * struct event_group - All information about a group of telemetry events.
  * @pfg:		Points to the aggregated telemetry space information
  *			within the OOBMSM driver that contains data for all
  *			telemetry regions.
+ * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
  * @guid:		Unique number per XML description file.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
 	struct pmt_feature_group	*pfg;
+	struct mmio_info		**pkginfo;
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
@@ -81,6 +96,20 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
 	return false;
 }
 
+static void free_mmio_info(struct mmio_info **mmi)
+{
+	int num_pkgs = topology_max_packages();
+
+	if (!mmi)
+		return;
+
+	for (int i = 0; i < num_pkgs; i++)
+		kfree(mmi[i]);
+	kfree(mmi);
+}
+
+DEFINE_FREE(mmio_info, struct mmio_info **, free_mmio_info(_T))
+
 /*
  * Configure events from one pmt_feature_group.
  * 1) Count how many per package.
@@ -88,8 +117,10 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
  */
 static int configure_events(struct event_group *e, struct pmt_feature_group *p)
 {
+	struct mmio_info **pkginfo __free(mmio_info) = NULL;
 	int *pkgcounts __free(kfree) = NULL;
 	struct telemetry_region *tr;
+	struct mmio_info *mmi;
 	int num_pkgs;
 
 	num_pkgs = topology_max_packages();
@@ -99,6 +130,12 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
 		tr = &p->regions[i];
 		if (skip_this_region(tr, e))
 			continue;
+
+		if (e->pkginfo) {
+			pr_warn_once("Duplicate telemetry information for guid 0x%x\n", e->guid);
+			return -EINVAL;
+		}
+
 		if (!pkgcounts) {
 			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
 			if (!pkgcounts)
@@ -110,6 +147,32 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
 	if (!pkgcounts)
 		return -ENODEV;
 
+	/* Allocate array for per-package struct mmio_info data */
+	pkginfo = kcalloc(num_pkgs, sizeof(*pkginfo), GFP_KERNEL);
+	if (!pkginfo)
+		return -ENOMEM;
+
+	/*
+	 * Allocate per-package mmio_info structures and initialize
+	 * count of telemetry_regions in each one.
+	 */
+	for (int i = 0; i < num_pkgs; i++) {
+		pkginfo[i] = kzalloc(struct_size(pkginfo[i], addrs, pkgcounts[i]), GFP_KERNEL);
+		if (!pkginfo[i])
+			return -ENOMEM;
+		pkginfo[i]->num_regions = pkgcounts[i];
+	}
+
+	/* Save MMIO address(es) for each telemetry region in per-package structures */
+	for (int i = 0; i < p->count; i++) {
+		tr = &p->regions[i];
+		if (skip_this_region(tr, e))
+			continue;
+		mmi = pkginfo[tr->plat_info.package_id];
+		mmi->addrs[--pkgcounts[tr->plat_info.package_id]] = tr->addr;
+	}
+	e->pkginfo = no_free_ptr(pkginfo);
+
 	return 0;
 }
 
@@ -169,5 +232,6 @@ void __exit intel_aet_exit(void)
 			intel_pmt_put_feature_group((*peg)->pfg);
 			(*peg)->pfg = NULL;
 		}
+		free_mmio_info((*peg)->pkginfo);
 	}
 }
-- 
2.49.0

