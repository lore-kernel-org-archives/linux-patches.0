Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C0723B612
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278046; cv=none; b=O6B3uq4pMUOs6pl72o2m60ApohLV8vDrrsfeTRrLL28nrFL3GBE2Y8QBWVtpZvdrhPBzQgMlhEvCwviGhgzKb0Z6vVIZcXrRRh2ePjH/G/fxNZ6cz/rFuySJlq/x+bsFGz/g7eXX3qqwCTv5oqJmFKLuh6mq3ezSBHLLh0ECAZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278046; c=relaxed/simple;
	bh=B9FzWCnUMi6sCioj5Y3JUa3XFXN1JE1kcPFtCEpal3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE1wOTwVVU+/2hWgtaovzvjFN2lo7w2IOWs8Pl1/p8wnzILCkneRvJKHcyljrB+kGdHDjNuO8AkpRpIxp5Yi7j6lehCX2VnYeu67TOGvjgIPfU1Dch3RqpWIFOyazRoP6uVPu3hpo1jlTNLGayzEk/hoWHkzJ1QJNCRbxoS/PXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WB6dnv9o; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WB6dnv9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278044; x=1783814044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B9FzWCnUMi6sCioj5Y3JUa3XFXN1JE1kcPFtCEpal3o=;
  b=WB6dnv9oTn6D2Hns+BKeQQRzF/b7HSkjZYrIeEn2CfoAtJ0FfJMwAmqq
   Z8GERHWvWnwfraOLm89pV8fvEyTwEbtEdR52Gfy8O/7jDCI6yXZODRDXJ
   iH6sVRkfdB3HTNwtq1odf0yXWWkVx5ThatilRvpLnJTtuWOIY27ibJ66Z
   jnCro1nQgHMjYAOd6pxAP3TpVWsCMavjZy25ViMyvcKgjutljLo8PRMjW
   2cp7QZCLTZ95llrAl8rtFDtW3IEVBuFzth/2e6EjA5jRn2q4HdRQFdZLd
   FbQ/wTBwV9rA85mi8gLCtQfrviD7DELxTxihdtcXBbOyK21ZV/QlXPUxi
   g==;
X-CSE-ConnectionGUID: ua/aRC6iQbqYLms7kVELnA==
X-CSE-MsgGUID: /ETSyt7aSDiQP4KZ0b9OEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292725"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292725"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:01 -0700
X-CSE-ConnectionGUID: xb1oA26EQxqVzOYrhJV/7g==
X-CSE-MsgGUID: p422mw7tSsiG9qGFJRiSKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902143"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:02 -0700
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
Subject: [PATCH v7 19/31] x86/resctrl: Complete telemetry event enumeration
Date: Fri, 11 Jul 2025 16:53:26 -0700
Message-ID: <20250711235341.113933-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
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

There may be multiple aggregators per package. Scan all the
telemetry_region structures again and save the number of regions together
with a flex array of the MMIO addresses for each aggregator indexed by
package id.

Completed structure for each event group looks like this:

             +---------------------+---------------------+
pkginfo** -->|pkginfo[package ID 0]|pkginfo[package ID 1]|
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
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 64 ++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 7cd6c06f9205..3f383f0a9d08 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -19,12 +19,26 @@
 
 #include "internal.h"
 
+/**
+ * struct pkg_mmio_info - MMIO address information for one event group of a package.
+ * @num_regions:	Number of telemetry regions on this package.
+ * @addrs:		Array of MMIO addresses, one per telemetry region on this package.
+ *
+ * Provides convenient access to all MMIO addresses of one event group
+ * for one package. Used when reading event data on a package.
+ */
+struct pkg_mmio_info {
+	unsigned int	num_regions;
+	void __iomem	*addrs[] __counted_by(num_regions);
+};
+
 /**
  * struct event_group - All information about a group of telemetry events.
  * @pfg:		Points to the aggregated telemetry space information
  *			within the OOBMSM driver that contains data for all
  *			telemetry regions.
  * @list:		List of active event groups.
+ * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
  * @guid:		Unique number per XML description file.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  */
@@ -32,6 +46,7 @@ struct event_group {
 	/* Data fields for additional structures to manage this group. */
 	struct pmt_feature_group	*pfg;
 	struct list_head		list;
+	struct pkg_mmio_info		**pkginfo;
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
@@ -90,15 +105,32 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
 	return false;
 }
 
+static void free_pkg_mmio_info(struct pkg_mmio_info **mmi)
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
+DEFINE_FREE(pkg_mmio_info, struct pkg_mmio_info **, free_pkg_mmio_info(_T))
+
 /*
  * Discover events from one pmt_feature_group.
  * 1) Count how many usable telemetry regions per package.
- * 2...) To be continued.
+ * 2) Allocate per-package structures and populate with MMIO
+ *    addresses of the telemetry regions used by each aggregator.
  */
 static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 {
+	struct pkg_mmio_info **pkginfo __free(pkg_mmio_info) = NULL;
 	int *pkgcounts __free(kfree) = NULL;
 	struct telemetry_region *tr;
+	struct pkg_mmio_info *mmi;
 	int num_pkgs;
 
 	num_pkgs = topology_max_packages();
@@ -108,6 +140,7 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 		tr = &p->regions[i];
 		if (skip_this_region(tr, e))
 			continue;
+
 		if (!pkgcounts) {
 			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
 			if (!pkgcounts)
@@ -119,6 +152,32 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 	if (!pkgcounts)
 		return -ENODEV;
 
+	/* Allocate array for per-package struct pkg_mmio_info data */
+	pkginfo = kcalloc(num_pkgs, sizeof(*pkginfo), GFP_KERNEL);
+	if (!pkginfo)
+		return -ENOMEM;
+
+	/*
+	 * Allocate per-package pkg_mmio_info structures and initialize
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
 
@@ -151,6 +210,7 @@ static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **ev
 			(*peg)->pfg = no_free_ptr(p);
 			return true;
 		}
+		free_pkg_mmio_info((*peg)->pkginfo);
 	}
 
 	return false;
@@ -179,6 +239,8 @@ void __exit intel_aet_exit(void)
 	list_for_each_entry_safe(evg, tmp, &active_event_groups, list) {
 		intel_pmt_put_feature_group(evg->pfg);
 		evg->pfg = NULL;
+		free_pkg_mmio_info(evg->pkginfo);
+		evg->pkginfo = NULL;
 		list_del(&evg->list);
 	}
 }
-- 
2.50.0

