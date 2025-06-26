Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246362EF9C9
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956606; cv=none; b=FsXrVdAgZcD+uSsM7pY0x0kTxowr+ueGsbVftITC8/41PJGTW6PXIzP7vKnWigfq6a/QFzCWeGTU8mbmAoohi43ay9wqcQv3JuzEnk8TycWBnnhQrJ8BPDmpbu0mdFMhBMvDgbyoE79CaI8gxgc8BMgkzr+rb1jGcfFMERs6Nm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956606; c=relaxed/simple;
	bh=/dVildZ2z+SGctJJUuboEilq0TwsoT2gkP4IyXcUnjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pI/AMaInWqVIZNppXunEdd91B0xspbRd8Vaa37zKNQ4NPsZw6MEQe29M0Th4wnSTR1FVVXg+8aNJ/CUS1oskKtUyK0mi+c8OHv8tancwPoA4HkeRJufg8Z4jvrpW3iHIrCgLNILCBSiRpCWIeSA3C0IoOI/EOuHz9ydiwCAkn5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XVDL/Wv4; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XVDL/Wv4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956605; x=1782492605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/dVildZ2z+SGctJJUuboEilq0TwsoT2gkP4IyXcUnjg=;
  b=XVDL/Wv4hn9MX92WnVeHnnqnQ56A8mFfcFBF9rvFusqHE/WMdU9sd3Pn
   wQBdXMm/C0rlxW4pgHungKsn0X7dHfTxWekdLHF1iffTyGltb+whE0o4T
   A5trt5N5Z0tRLRf3gwmc1mIIvnTJnT2S5KbGml5JXpR1qjkd95FurYPfQ
   ZwHmO/iMB7cJAsCSd+xsdfbVlWnvH+YiSBj0DOb6g946SQR0Xs9s2GPKw
   gL8IzWfNwhzBmDYy3qkXN/A+eT8CkCAhmeMWKvTYpav5zdF6LbIPF0WaO
   L3ogyH3bt7cKKYzQcKmFuNujMayI36CySyJYkHhPuitRbS+thO5t424mj
   w==;
X-CSE-ConnectionGUID: yfU/TqnnRxe0IzjIPBapCg==
X-CSE-MsgGUID: GV8lZDUtTYu1p60LmD+0aQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136462"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136462"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:59 -0700
X-CSE-ConnectionGUID: 1zdv6IPmRQmEqCKZMysuqg==
X-CSE-MsgGUID: 7SUT49TNR4+fP5T0smFqVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069258"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:58 -0700
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
Subject: [PATCH v6 18/30] x86/resctrl: Count valid telemetry aggregators per package
Date: Thu, 26 Jun 2025 09:49:27 -0700
Message-ID: <20250626164941.106341-19-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 55 ++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index b09044b093dd..8d67ed709a74 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/intel_vsec.h>
 #include <linux/resctrl.h>
+#include <linux/slab.h>
 
 #include "internal.h"
 
@@ -24,6 +25,7 @@
  *			within the OOBMSM driver that contains data for all
  *			telemetry regions.
  * @guid:		Unique number per XML description file.
+ * @mmio_size:		Number of bytes of MMIO registers for this group.
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
@@ -31,14 +33,19 @@ struct event_group {
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	size_t				mmio_size;
 };
 
+#define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status)	\
+	(((num_rmids) * (num_events) + (num_extra_status)) * sizeof(u64))
+
 /*
  * Link: https://github.com/intel/Intel-PMT
  * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
  */
 static struct event_group energy_0x26696143 = {
 	.guid		= 0x26696143,
+	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 };
 
 /*
@@ -47,6 +54,7 @@ static struct event_group energy_0x26696143 = {
  */
 static struct event_group perf_0x26557651 = {
 	.guid		= 0x26557651,
+	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 };
 
 static struct event_group *known_event_groups[] = {
@@ -56,10 +64,53 @@ static struct event_group *known_event_groups[] = {
 
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
+		pr_warn_once("MMIO space %zu too small for guid 0x%x\n", tr->size, e->guid);
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
-	return -EINVAL;
+	int *pkgcounts __free(kfree) = NULL;
+	struct telemetry_region *tr;
+	int num_pkgs;
+
+	num_pkgs = topology_max_packages();
+
+	/* Get per-package counts of telemetry_regions for this event group */
+	for (int i = 0; i < p->count; i++) {
+		tr = &p->regions[i];
+		if (skip_this_region(tr, e))
+			continue;
+		if (!pkgcounts) {
+			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
+			if (!pkgcounts)
+				return -ENOMEM;
+		}
+		pkgcounts[tr->plat_info.package_id]++;
+	}
+
+	if (!pkgcounts)
+		return -ENODEV;
+
+	return 0;
 }
 
 DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
-- 
2.49.0

