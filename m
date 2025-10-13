Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACE530C34D
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394853; cv=none; b=bq7nay0zOlMRgWGMVcuYpblqPYDEB5flCLAV9L2nE2kXFp91/s6qwaXhh+dZTM2+xqfe7fMsAB3VT5wr+yhNMF2p2EvMreO44irsu4cIuKPLCinft0Iiv1IzTZNYZxoWXjCGpuykkez4MUJqDySj1ODeqJJD7u2vPEHC2YBBkg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394853; c=relaxed/simple;
	bh=sxUh6M7tJ8CznuLQWRkaK96SERLOcZ1j/6iCSCkBhqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqLhH5YDXBSbGQ3DtrfWn+bd+np8WKHIECIUNwDh88KiytUAmbxRW6j8WhWgD/5gHr2tlo9z3b293ic7WcMFoaPsv2jgj1rkzT7wCAkXjk+Iuy4W8QdBPv0Jglbp3F0BieMZyvfSiLzVbhB1LPU4YV48WZeXasthPLq+IahhkBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UkXW9Hfu; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UkXW9Hfu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394851; x=1791930851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sxUh6M7tJ8CznuLQWRkaK96SERLOcZ1j/6iCSCkBhqg=;
  b=UkXW9Hfuo5OEYf5E2YdrQh9Ln+JhxKVrC5j5zow+zngfglV2qu9gf9/C
   cZjSgMtEBhyIrTststgexHpHmEqmIIa6IfLNdZeciJuYPR/mlHXR24FCY
   fSR2L0XPpH3ZhxPHaUmakVi7pcI4P//z9gdYwLQ+VU9Xqc1VijLtke1Fk
   k6K+HMBgmIxNcu4gtbqefs7P9x4Bf+Y4WKpHHH63yUcQRtx2bD6belyDX
   Watui/3iWxrwiI7T3Pr2Xl0Ct1tIXRhnJ3sI8jmfBm8OmazfwIoBRg7BE
   niTV62DQ76hnYeP5amHwbkhW6ej1ZbPYJo8Sh095o39bqkUpcvmmwynqX
   w==;
X-CSE-ConnectionGUID: AnhCxe3nReKkzHxwwUDXZw==
X-CSE-MsgGUID: NczlvearS/euS389GBNUtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168866"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168866"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:02 -0700
X-CSE-ConnectionGUID: PWNYpwcUSzaHP4xWSXjXsg==
X-CSE-MsgGUID: dqbsL7mVRbad+it1PbIC+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145304"
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
Subject: [PATCH v12 17/31] x86/resctrl: Find and enable usable telemetry events
Date: Mon, 13 Oct 2025 15:33:31 -0700
Message-ID: <20251013223348.103390-18-tony.luck@intel.com>
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

The INTEL_PMT_TELEMETRY driver provides telemetry region structures of the
types requested by resctrl.

Scan these structures to discover which pass sanity checks to derive
a list of valid regions:

1) They have guid known to resctrl.
2) They have a valid package ID.
3) The enumerated size of the MMIO region matches the expected
   value from the XML description file.

Mark regions that fail any of these checks as unusable.

Enable events that usable telemetry regions are responsible for.

Note that it is architecturally possible that some telemetry events
are only supported by a subset of the packages in the system. It
is not expected that systems will ever do this. If they do the user
will see event files in resctrl that always return "Unavailable".

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 ++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 036086404e28..a500b5d384fb 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -20,9 +20,11 @@
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/overflow.h>
+#include <linux/printk.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
 #include <linux/stddef.h>
+#include <linux/topology.h>
 #include <linux/types.h>
 
 #include "internal.h"
@@ -114,12 +116,59 @@ static struct event_group *known_perf_event_groups[] = {
 	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
 		if ((*_peg)->pfg)
 
-/* Stub for now */
-static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+/*
+ * Clear the address field of regions that did not pass the checks in
+ * skip_telem_region() so they will not be used by intel_aet_read_event().
+ * This is safe to do because intel_pmt_get_regions_by_feature() allocates
+ * a new pmt_feature_group structure to return to each caller and only makes
+ * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
+ * returns the structure.
+ */
+static void mark_telem_region_unusable(struct telemetry_region *tr)
+{
+	tr->addr = NULL;
+}
+
+static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
 {
+	if (tr->guid != e->guid)
+		return true;
+	if (tr->plat_info.package_id >= topology_max_packages()) {
+		pr_warn("Bad package %u in guid 0x%x\n", tr->plat_info.package_id,
+			tr->guid);
+		return true;
+	}
+	if (tr->size != e->mmio_size) {
+		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
+			tr->size, e->guid, e->mmio_size);
+		return true;
+	}
+
 	return false;
 }
 
+static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	bool usable_events = false;
+
+	for (int i = 0; i < p->count; i++) {
+		if (skip_telem_region(&p->regions[i], e)) {
+			mark_telem_region_unusable(&p->regions[i]);
+			continue;
+		}
+		usable_events = true;
+	}
+
+	if (!usable_events)
+		return false;
+
+	for (int j = 0; j < e->num_events; j++)
+		resctrl_enable_mon_event(e->evts[j].id, true,
+					 e->evts[j].bin_bits, &e->evts[j]);
+
+	return true;
+}
+
 /*
  * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
  * pmt_feature_group for a specific feature. If there is one, the returned
-- 
2.51.0

