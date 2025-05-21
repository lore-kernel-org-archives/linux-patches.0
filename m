Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69E523FC6B
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867870; cv=none; b=BTbI1sXx9G/714RHXqtIddko7WLZDi5fAFa9VZG28+Va/6E4l5R/aqMXx5w+XGZv5O2tvATxCozysp17T9UriasKvdLA2piSFtDxVuQJj3wsLmSReaS3khE8AB+C1kPIsIT69nfV8mXY3D7ZHHgF6pp6fDD/8V1buBzMe7W1PDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867870; c=relaxed/simple;
	bh=jZvJTkcSVjRmkGLeOmMgrgMCrGaQmQ2myZ1ADMCEudg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uL5FR6GfqEkX7bXBMn3h31sJqoZhkI0l+oqFwaOIMu/aehNSlTkd14NEXY9IGkl65bvtfKqh2Aoz77Ue/eeF8W2gaaq7+b9gZnNw3RGau49iwjGVL7JbRj5b3RIYSNR2x8VFBuKp7xhiyhknWCapRm7vgUXE1LKMPTrWCue+xWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJ3xuNB0; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJ3xuNB0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867868; x=1779403868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jZvJTkcSVjRmkGLeOmMgrgMCrGaQmQ2myZ1ADMCEudg=;
  b=gJ3xuNB0e4QLNi1UzpRpCRriTF9hOPdxMx7BXNX8wYY170DiBXr+wW5l
   HEqZAoD75b5Maefxh9dSVGaclo4xV2weeMKu9T4NZ7xqySZb+xgpQO8e4
   1H6n9YAX8c2Un/V3Wl7alug2aUJnw7jcp8tj/2yU4gkP3Lo1AuHD+5aok
   V5XaaB9CLko/yaSXwQ14gSEyfzJxWEb6+WfVdGiDCJYzOIuc9eHYkcSnt
   qHv2RMJqPVICAHoWjBFthMmsdh155cDJNm89C9ap5o6bY9l1BnFQzWgv0
   fwLqaFweb6W9dCYmxy1V6qxhFt0YQKc7TyWTWkSyc5F0/myP6xRtknFoS
   g==;
X-CSE-ConnectionGUID: MnXSAjQlSriL5aDkX8r1WQ==
X-CSE-MsgGUID: rATbPG53Rwm6Y/MJ/LXJUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677739"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677739"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
X-CSE-ConnectionGUID: kYvU0AH5TgaIJ3vMsEriSA==
X-CSE-MsgGUID: pjtoTgD/Sz2zCUini76Tfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352176"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
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
Subject: [PATCH v5 18/29] x86/resctrl: Count valid telemetry aggregators per package
Date: Wed, 21 May 2025 15:50:36 -0700
Message-ID: <20250521225049.132551-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There may be multiple telemetry aggregators per package, each enumerated
by a telemetry region structure in the feature group.

Scan the array of telemetry region structures and count how many are
in each package in preparation to allocate structures to save the MMIO
addresses for each in a convenient format for use when reading event
counters.

Sanity check that the telemetry region structures have a valid
package_id and that the size they report for the MMIO space is as
large as expected from the XML description of the registers in
the region.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 45 ++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index df73b9476c4d..ffcb54be54ea 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -14,6 +14,7 @@
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/resctrl.h>
+#include <linux/slab.h>
 
 /* Temporary - delete from final version */
 #include "fake_intel_aet_features.h"
@@ -26,6 +27,7 @@
  *			within the OOBMSM driver that contains data for all
  *			telemetry regions.
  * @guid:		Unique number per XML description file.
+ * @mmio_size:		Number of bytes of MMIO registers for this group.
  */
 struct event_group {
 	/* Data fields used by this code. */
@@ -33,6 +35,7 @@ struct event_group {
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	size_t				mmio_size;
 };
 
 /*
@@ -41,6 +44,7 @@ struct event_group {
  */
 static struct event_group energy_0x26696143 = {
 	.guid		= 0x26696143,
+	.mmio_size	= (576 * 2 + 3) * 8,
 };
 
 /*
@@ -49,6 +53,7 @@ static struct event_group energy_0x26696143 = {
  */
 static struct event_group perf_0x26557651 = {
 	.guid		= 0x26557651,
+	.mmio_size	= (576 * 7 + 3) * 8,
 };
 
 static struct event_group *known_event_groups[] = {
@@ -58,9 +63,47 @@ static struct event_group *known_event_groups[] = {
 
 #define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
 
-/* Stub for now */
+static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
+{
+	if (tr->guid != e->guid)
+		return true;
+	if (tr->plat_info.package_id >= topology_max_packages()) {
+		pr_warn_once("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,
+			     tr->guid);
+		return true;
+	}
+	if (tr->size < e->mmio_size) {
+		pr_warn_once("MMIO space too small for guid 0x%x\n", e->guid);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Configure events from one pmt_feature_group.
+ * 1) Count how many per package.
+ * 2...) To be continued.
+ */
 static int configure_events(struct event_group *e, struct pmt_feature_group *p)
 {
+	int *pkgcounts __free(kfree) = NULL;
+	struct telemetry_region *tr;
+	int num_pkgs;
+
+	num_pkgs = topology_max_packages();
+	pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
+	if (!pkgcounts)
+		return -ENOMEM;
+
+	/* Get per-package counts of telemetry_regions for this event group */
+	for (int i = 0; i < p->count; i++) {
+		tr = &p->regions[i];
+		if (skip_this_region(tr, e))
+			continue;
+		pkgcounts[tr->plat_info.package_id]++;
+	}
+
 	return -EINVAL;
 }
 
-- 
2.49.0

