Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31D7233733
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598987; cv=none; b=TTvaauAm1BJQo41AptkligKPB0LMOvy8RnLmLj8FVIaHBoLzGQ/qgAWiVwkO1N+OGrCSXGOq2y/jNU6vFfwEKGXTeduH91rynn/y9FiKdftCW+RrGN8tjGH441d7L5LAtt1rKs6Qmok7bSNzURaLJn0NUzgeuoSTe4aPWr2wPgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598987; c=relaxed/simple;
	bh=EelZRvoSNl3GeFDTwR9XrsX4puLt4kUGCZtESpc/1Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtHUK50Xgv2dCa3UI/dze3ybFUqLe/HN85VQtoXV2aaybe/2qNyyGUAnWixzfOwFD+js+45RWDl3dzaYQD4XZRcXsGx0QJI/4VtERulC/LgZIJNGZ9eDsLEjTd2G/xvi1GqK5Q1btrdkob3Z3Z/vheNhFlStbLLpXcn5OVfj9DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZWbG3OCa; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZWbG3OCa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598986; x=1774134986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EelZRvoSNl3GeFDTwR9XrsX4puLt4kUGCZtESpc/1Zw=;
  b=ZWbG3OCaX6WBTohLP6wJ7IKKPDC9MmnRuBlWfn+iiCAxi8dD5/fu7Zth
   5d09Vn48+u7SmexzBynrsX8XlhV3R1ztA11bDmrV7rb5agOGuobWt70MD
   Z9gKeRnwHAG7NG00iH+xtVV0B6Tp4KaVti3yHHKirGTvqCDH4iWzU1Xr7
   mhmsB8OIjTiH43o/almxx2O9fRCjG0T0B4i/gReXWF1buI8A4SEx8FZVP
   8LyQyNLEX2LtwPO45C52HmTEpJ0feadXKSYZd+yHwWwGGZHW+9TEY6Xvx
   Z6Rjnfdd3qul07H/K0kfz0Z7pDaNYippPLZu9+mZ041ENDQ70ExnB8XdF
   Q==;
X-CSE-ConnectionGUID: rTBsKie8Sk6gURPYJhkM0Q==
X-CSE-MsgGUID: nu/9d3zQSxClWvLJZn1ZCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604604"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604604"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:22 -0700
X-CSE-ConnectionGUID: VNVNbhtLTh6z9ePbxiQRzg==
X-CSE-MsgGUID: fQOcj1/pSvaITgqDnDlzXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354315"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 09/16] x86/resctrl: Add detailed descriptions for Clearwater Forest events
Date: Fri, 21 Mar 2025 16:15:59 -0700
Message-ID: <20250321231609.57418-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two event groups one for energy reporting and another
for "perf" events.

See the XML description files in https://github.com/intel/Intel-PMT
in the xml/CWF/OOBMSM/{RMID-ENERGY,RMID-PERF}/ for the detailed
descriptions that were used to derive these descriptions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 54 +++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 9a8ccb62b4ab..67862e81b9e0 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -94,8 +94,62 @@ struct telem_entry {
 	struct pmt_event evts[];
 };
 
+/*
+ * Known events from Intel Clearwater Forest CPU.
+ */
+#define CWF_NUM_RMIDS	576
+#define CWF_ENERGY_GUID	0x26696143
+#define CWF_PERF_GUID	0x26557651
+#define	CWF_ENERGY_STRIDE	0x10
+#define CWF_PERF_STRIDE	0x38
+
+/*
+ * https://github.com/intel/Intel-PMT
+ * xml/CWF/OOBMSM/RMID-ENERGY *.xml
+ */
+static struct telem_entry cwf_energy = {
+	.name				= "energy",
+	.guid				= CWF_ENERGY_GUID,
+	.num_rmids			= CWF_NUM_RMIDS,
+	.stride				= CWF_ENERGY_STRIDE,
+	.overflow_counter_off		= CWF_NUM_RMIDS * CWF_ENERGY_STRIDE,
+	.last_overflow_tstamp_off	= CWF_NUM_RMIDS * CWF_ENERGY_STRIDE + 8,
+	.last_update_tstamp_off		= CWF_NUM_RMIDS * CWF_ENERGY_STRIDE + 16,
+	.evts				= {
+		EVT(PMT_EVENT_ENERGY, "core_energy", 0x0, EVT_U46_18),
+		EVT(PMT_EVENT_ACTIVITY, "activity", 0x8, EVT_U46_18),
+		{ }
+	}
+};
+
+/*
+ * https://github.com/intel/Intel-PMT
+ * xml/CWF/OOBMSM/RMID-PERF *.xml
+ */
+static struct telem_entry cwf_perf = {
+	.name				= "perf",
+	.guid				= CWF_PERF_GUID,
+	.num_rmids			= CWF_NUM_RMIDS,
+	.stride				= CWF_PERF_STRIDE,
+	.overflow_counter_off		= CWF_NUM_RMIDS * CWF_PERF_STRIDE,
+	.last_overflow_tstamp_off	= CWF_NUM_RMIDS * CWF_PERF_STRIDE + 8,
+	.last_update_tstamp_off		= CWF_NUM_RMIDS * CWF_PERF_STRIDE + 16,
+	.evts				= {
+		EVT(PMT_EVENT_STALLS_LLC_HIT, "stalls_llc_hit", 0x0, EVT_U64),
+		EVT(PMT_EVENT_C1_RES, "c1_res", 0x8, EVT_U64),
+		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, "unhalted_core_cycles", 0x10, EVT_U64),
+		EVT(PMT_EVENT_STALLS_LLC_MISS, "stalls_llc_miss", 0x18, EVT_U64),
+		EVT(PMT_EVENT_AUTO_C6_RES, "c6_res", 0x20, EVT_U64),
+		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, "unhalted_ref_cycles", 0x28, EVT_U64),
+		EVT(PMT_EVENT_UOPS_RETIRED, "uops_retired", 0x30, EVT_U64),
+		{ }
+	}
+};
+
 /* All known telemetry event groups */
 static struct telem_entry *telem_entry[] = {
+	&cwf_energy,
+	&cwf_perf,
 	NULL
 };
 
-- 
2.48.1

