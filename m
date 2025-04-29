Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4ED2036E2
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886866; cv=none; b=mTY23jfStEjfeyHB0YtfZIolvOS+dig2kjqYNammc9dQCEGqNaxdKurYi3GBtybU1gtD0YvgcCDu33ubnry0rO9KX6OUNvMmU8O+9Ntd8hX+L7nxvCCg2+bewbpXOS/KVDaMCgjhWsLfaLIkMq6LXlnfNixK4A1QjaqZTZAfBUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886866; c=relaxed/simple;
	bh=WpX4W9eMoqX5jiHgxecwgFYS8iw5BYHo22VOGiJt1VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFgIRDRKqVYPu+uQPZNJqu84e5einJpQ3U0PpVd/qnVyuppQhVrrqsHB11ySI4eob7IAPynkWHW98s3Y03Iqr7e2T9x+Qrm9Y3b/FMzBmG0C8iHHXoZqt7uUJJPbwePeJ91pCbZdEbC/SkcfKKc/LI2bDaUmBKNT6BawPM7Cqoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QquwfViF; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QquwfViF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886864; x=1777422864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WpX4W9eMoqX5jiHgxecwgFYS8iw5BYHo22VOGiJt1VU=;
  b=QquwfViF4yJEO/PJLc+IC/UN+KbRi8HSsgOuRGSCp0TlDzrRBwoDzqON
   8Hj2Fldd1ETSQmJ5Gj6lwMZO6bSIde77jkC4S3C00cszdu2yIe3gqybUk
   b8J1QZVQe7x9u6cojAdf+oJrRH9Fnv9n1EhgrfZGXwp9eJxvkoj2gr9Jc
   +AedaECusitGGNRV74q6umoggkX4PKCWEkBdbsD4x8ompN1O8dmXf52Sd
   TuqjkFCcfed0Uph29CnU2WZpdCHFmpYcX1wnkvv4FK5kXZ0UV94IGBelJ
   +ieCiYCAr1LZEf1HVMTjgboY6LrKKWvXNn4K08wPqmINNotU1oKPRLmam
   Q==;
X-CSE-ConnectionGUID: z5Li7okRQ/mgv0G1GkpzmQ==
X-CSE-MsgGUID: rA9cLjxpQGiud1PR7tQbNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148206"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148206"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:18 -0700
X-CSE-ConnectionGUID: f1QFlmulS8+qVrKJD0j0rw==
X-CSE-MsgGUID: Ai97tRPhRiGRxQwb+H52sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394027"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:17 -0700
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
Subject: [PATCH v4 18/31] x86/resctrl: Add third part of telemetry event enumeration
Date: Mon, 28 Apr 2025 17:33:44 -0700
Message-ID: <20250429003359.375508-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Counters for telemetry events are in MMIO space. Each telemetry_region
structure returned in the pmt_feature_group returned from OOBMSM
contains the base MMIO address for the counters.

Scan all the telemetry_region structures again and gather these
addresses into a more convenient structure with addresses for
each aggregator indexed by package id. Note that there may be
multiple aggregators per package.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 55 +++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index a0365c3ce982..03839d5c369b 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -20,6 +20,16 @@
 
 #include "internal.h"
 
+/**
+ * struct mmio_info - Array of MMIO addresses for a package
+ * @count:		Number of addresses on this package
+ * @addrs:		The MMIO addresses
+ */
+struct mmio_info {
+	int		count;
+	void __iomem	*addrs[] __counted_by(count);
+};
+
 /**
  * struct event_group - All information about a group of telemetry events.
  *                      Some fields initialized with MMIO layout information
@@ -27,10 +37,12 @@
  *                      retrieved from intel_pmt_get_regions_by_feature().
  * @pfg:		The pmt_feature_group for this event group
  * @guid:		Unique number per XML description file
+ * @pkginfo:		Per-package MMIO addresses
  */
 struct event_group {
 	struct pmt_feature_group	*pfg;
 	int				guid;
+	struct mmio_info		**pkginfo;
 };
 
 /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-ENERGY *.xml */
@@ -50,12 +62,33 @@ static struct event_group *known_event_groups[] = {
 
 #define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
 
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
 static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
 {
+	struct mmio_info __free(mmio_info) **pkginfo = NULL;
 	int *pkgcounts __free(kfree) = NULL;
 	struct telemetry_region *tr;
+	struct mmio_info *mmi;
 	int num_pkgs;
 
+	if (e->pkginfo) {
+		pr_warn("Duplicate telemetry information for guid 0x%x\n", e->guid);
+		return false;
+	}
+
 	num_pkgs = topology_max_packages();
 	pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
 	if (!pkgcounts)
@@ -73,6 +106,27 @@ static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
 		pkgcounts[tr->plat_info.package_id]++;
 	}
 
+	/* Allocate per-package arrays and save MMIO addresses */
+	pkginfo = kcalloc(num_pkgs, sizeof(*pkginfo), GFP_KERNEL);
+	if (!pkginfo)
+		return false;
+	for (int i = 0; i < num_pkgs; i++) {
+		pkginfo[i] = kmalloc(struct_size(pkginfo[i], addrs, pkgcounts[i]), GFP_KERNEL);
+		if (!pkginfo[i])
+			return false;
+		pkginfo[i]->count = pkgcounts[i];
+	}
+
+	/* Save MMIO address(es) for each aggregator in per-package structures */
+	for (int i = 0; i < p->count; i++) {
+		tr = &p->regions[i];
+		if (tr->guid != e->guid || tr->plat_info.package_id >= num_pkgs)
+			continue;
+		mmi = pkginfo[tr->plat_info.package_id];
+		mmi->addrs[--pkgcounts[tr->plat_info.package_id]] = tr->addr;
+	}
+	e->pkginfo = no_free_ptr(pkginfo);
+
 	return false;
 }
 
@@ -130,5 +184,6 @@ void __exit intel_aet_exit(void)
 			intel_pmt_put_feature_group((*peg)->pfg);
 			(*peg)->pfg = NULL;
 		}
+		free_mmio_info((*peg)->pkginfo);
 	}
 }
-- 
2.48.1

