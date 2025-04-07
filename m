Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE239253331
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069268; cv=none; b=G5k7SGYQeJUvomeBusBX4GDB2q22DD4hFKvHm8/oPXnzxPs8OiY7oDsElh+Yz8spsIDUoCCWoEzh9+Y2zAD5sLutrNgAjTHEdxxhNBQ+cMDRDsEmwFvz//HXYDtv2Kd/UlbjvBnsfP3icVi8UFgZza2JSf2zmHgOfChaFhKZLCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069268; c=relaxed/simple;
	bh=1i/8JSi+8RpbrWAm8clCMAtNcpyDmlI9pQJUCQrwPiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFHl77i+ZEFn/tK/Fo+GuHRx9miicQc8tKmOr3ESTuj8rtLXMpOcav420b0hmnVlMENQVnPt8H/COE/tY/ZC1tQ2kt2k/x2AcKs51QJZtk7xX5Wb83afGsyTGXTxH1gOuaM3ut1HIHM9FDEbijzNQ7HAf4aJExOSKwdH6NjIdQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QBICZ25Q; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QBICZ25Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069267; x=1775605267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1i/8JSi+8RpbrWAm8clCMAtNcpyDmlI9pQJUCQrwPiQ=;
  b=QBICZ25QviS6ODcSMv7Xf4x2XnswYyiydBge+EyhnBTvnjC+6DIVB3IW
   EuGZXgcu2jDhrIU3ymbUqZ18IS8cmAhkTTrdDy5Mkd/hqtZqLcfr4hP56
   lImQsfthnGq8KYcUMCp4q5zNF4z+bEw15+jwhBjvOsi5qo4n4Olaiex/g
   Kbfr/TGyVYvgDFEqKUBh7h2ysQq3D0eVfs4UvA+WwvchzZj3Xd/TAlWvw
   1xNZhQowhVSWG0ejGsZOw9JiE6e45OrAVWa3Tbij+6STL6Z4l+5C8A1R3
   rAy6dndhShR4dBaQKSkylf8YYBzlERWm9CH8O/FMkGskJesq6Ut1zanwX
   w==;
X-CSE-ConnectionGUID: l9gOpM0uRwaOyVO+SU5Jgw==
X-CSE-MsgGUID: ky+mV+KITjuUwLRqQzTwSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193285"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193285"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:57 -0700
X-CSE-ConnectionGUID: HyM8rUmgQLi9YMMOGa9xnw==
X-CSE-MsgGUID: rhkLX5R7RYK4cG/S/wSo5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315523"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:56 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 23/26] fs/resctrl: Add new telemetry event id and structures
Date: Mon,  7 Apr 2025 16:40:25 -0700
Message-ID: <20250407234032.241215-24-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Nine new events for energy and perf monitoring per-RMID.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl_types.h | 19 ++++++++++++---
 fs/resctrl/monitor.c          | 45 +++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index 3354f21e82ad..2c959e7233dd 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -46,16 +46,29 @@ enum resctrl_res_level {
 };
 
 /*
- * Event IDs, the values match those used to program IA32_QM_EVTSEL before
- * reading IA32_QM_CTR on RDT systems.
+ * Event IDs
  */
 enum resctrl_event_id {
+	/* Legacy events. Values must match X86 IA32_QM_EVTSEL usage */
 	QOS_L3_OCCUP_EVENT_ID		= 0x01,
 	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
 	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
+
+	/* Intel Telemetry Events */
+	PMT_EVENT_ENERGY,
+	PMT_EVENT_ACTIVITY,
+	PMT_EVENT_STALLS_LLC_HIT,
+	PMT_EVENT_C1_RES,
+	PMT_EVENT_UNHALTED_CORE_CYCLES,
+	PMT_EVENT_STALLS_LLC_MISS,
+	PMT_EVENT_AUTO_C6_RES,
+	PMT_EVENT_UNHALTED_REF_CYCLES,
+	PMT_EVENT_UOPS_RETIRED,
+
+	/* Must be the last */
+	QOS_NUM_EVENTS
 };
 
-#define QOS_NUM_EVENTS		(QOS_L3_MBM_LOCAL_EVENT_ID + 1)
 #define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
 #define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 5846a13c631a..0207c9ed2d47 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -861,6 +861,51 @@ static struct mon_evt all_events[QOS_NUM_EVENTS] = {
 		.rid	= RDT_RESOURCE_L3,
 		.type	= EVT_TYPE_U64,
 	},
+	[PMT_EVENT_ENERGY] = {
+		.name	= "core_energy",
+		.evtid	= PMT_EVENT_ENERGY,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_ACTIVITY] = {
+		.name	= "activity",
+		.evtid	= PMT_EVENT_ACTIVITY,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_STALLS_LLC_HIT] = {
+		.name	= "stalls_llc_hit",
+		.evtid	= PMT_EVENT_STALLS_LLC_HIT,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_C1_RES] = {
+		.name	= "c1_res",
+		.evtid	= PMT_EVENT_C1_RES,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_UNHALTED_CORE_CYCLES] = {
+		.name	= "unhalted_core_cycles",
+		.evtid	= PMT_EVENT_UNHALTED_CORE_CYCLES,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_STALLS_LLC_MISS] = {
+		.name	= "stalls_llc_miss",
+		.evtid	= PMT_EVENT_STALLS_LLC_MISS,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_AUTO_C6_RES] = {
+		.name	= "c6_res",
+		.evtid	= PMT_EVENT_AUTO_C6_RES,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_UNHALTED_REF_CYCLES] = {
+		.name	= "unhalted_ref_cycles",
+		.evtid	= PMT_EVENT_UNHALTED_REF_CYCLES,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
+	[PMT_EVENT_UOPS_RETIRED] = {
+		.name	= "uops_retired",
+		.evtid	= PMT_EVENT_UOPS_RETIRED,
+		.rid	= RDT_RESOURCE_PERF_PKG,
+	},
 };
 
 int resctrl_set_event_attributes(enum resctrl_event_id evt,
-- 
2.48.1

