Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3491B253F34
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069270; cv=none; b=WRU2tsllnf8OM1EpBC8pP+CQgJHOiPc8KUd+QNpvErOpEEMF/mHH+EcIBtSzUFGNQX8ARz2VdnUFztGzi1WekMh1ZViienx42KHuRPCjuD+q4SFJm51fhs5KDAGI8WHHIkk/sLCGN8AAbld4qvbQq3fU0DTWMZXQhSkMmGZqs4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069270; c=relaxed/simple;
	bh=0vh9HuxcyMxqpMiFdEcg2+0e4DmDqzuVo7gAd3iUy4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVtYNgiQlu6lK2/29gBxHZ9gTQ1IjRSiKCzgJ+KMnBZGJbG7L7ECXvquB/8Fpd08HzhnFsRd6/2xbyYBj0FccXqZIClbjaJx0rtGD9hy8uHJ7K6Kp3vKYOZSwNZ8b5Zd9su9XpxG/kJjfpio6p5bNXa4jkegaON7I71JKef/vvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M0jejNVq; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M0jejNVq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069268; x=1775605268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0vh9HuxcyMxqpMiFdEcg2+0e4DmDqzuVo7gAd3iUy4g=;
  b=M0jejNVqD6t1A2VZ/nNQ80H4/UkANsLGxOIRYhcLu/meEm9wKxSWCup2
   31lyF3wfE16mUnSO63Vl5cdNUPTPSIPNPaVf88ReKQLraS+fNHP/xZh+h
   30YDwepvafYal4LPU//CLxkfXe5KvMu11Q26B/IYuGmaMzU5dXy0pKmwK
   xQdUsaIDuruzX13ImxftnNj8LLSRdHGgPA1HXF/hX2AfGbPk/qIM0g0dv
   RLX8sRKb3PvJ3XvtQZValcXRmjxxd6GELmd/rgq0zUlAKAoPOAL9jXRq2
   iaq1D4AcJSavgXxkuIo/bpl2CtwUxdBrmHwsV/OpeEYI5OI+XB0T0J7DC
   w==;
X-CSE-ConnectionGUID: XfaQjj9STrWPq7gQ7dz98A==
X-CSE-MsgGUID: uTv7lFg5T/K2C9XswpuNbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193299"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193299"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:58 -0700
X-CSE-ConnectionGUID: iih2M1wyTkGHvcCDv8Uc3w==
X-CSE-MsgGUID: PIWC+5UDRSWEI0fW8Se0eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315532"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:57 -0700
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
Subject: [PATCH v3 25/26] fs-x86/resctrl: Add detailed descriptions for Clearwater Forest events
Date: Mon,  7 Apr 2025 16:40:27 -0700
Message-ID: <20250407234032.241215-26-tony.luck@intel.com>
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

There are two event groups one for energy reporting and another
for "perf" events.

See the XML description files in https://github.com/intel/Intel-PMT
in the xml/CWF/OOBMSM/{RMID-ENERGY,RMID-PERF}/ for the detailed
descriptions that were used to derive these descriptions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 57 +++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 529f6d49e3a3..e1097767009e 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -42,6 +42,8 @@ struct pmt_event {
 	enum resctrl_event_type	type;
 };
 
+#define EVT(id, offset, _type) { .evtid = id, .evt_offset = offset, .type = _type }
+
 /**
  * struct telem_entry - Summarized form from XML telemetry description
  * @name:			Name for this group of events
@@ -82,8 +84,63 @@ static struct evtinfo {
 
 #define EVT_OFFSET(evtid)	(evtinfo[evtid].pmt_event->evt_offset)
 
+/*
+ * https://github.com/intel/Intel-PMT
+ * xml/CWF/OOBMSM/RMID-ENERGY *.xml
+ */
+#define NUM_RMIDS_0x26696143	576
+#define GUID_0x26696143		0x26696143
+#define NUM_EVENTS_0x26696143	2
+#define EVT_BYTES_0x26696143	(NUM_RMIDS_0x26696143 * NUM_EVENTS_0x26696143 * sizeof(u64))
+
+static struct telem_entry energy_0x26696143 = {
+	.name				= "energy",
+	.guid				= GUID_0x26696143,
+	.size				= EVT_BYTES_0x26696143 + sizeof(u64) * 3,
+	.num_rmids			= NUM_RMIDS_0x26696143,
+	.overflow_counter_off		= EVT_BYTES_0x26696143 + sizeof(u64) * 0,
+	.last_overflow_tstamp_off	= EVT_BYTES_0x26696143 + sizeof(u64) * 1,
+	.last_update_tstamp_off		= EVT_BYTES_0x26696143 + sizeof(u64) * 2,
+	.num_events			= NUM_EVENTS_0x26696143,
+	.evts				= {
+		EVT(PMT_EVENT_ENERGY, 0x0, EVT_TYPE_U46_18),
+		EVT(PMT_EVENT_ACTIVITY, 0x8, EVT_TYPE_U46_18),
+	}
+};
+
+/*
+ * https://github.com/intel/Intel-PMT
+ * xml/CWF/OOBMSM/RMID-PERF *.xml
+ */
+#define NUM_RMIDS_0x26557651	576
+#define GUID_0x26557651		0x26557651
+#define NUM_EVENTS_0x26557651	7
+#define EVT_BYTES_0x26557651	(NUM_RMIDS_0x26557651 * NUM_EVENTS_0x26557651 * sizeof(u64))
+
+static struct telem_entry perf_0x26557651 = {
+	.name				= "perf",
+	.guid				= GUID_0x26557651,
+	.size				= EVT_BYTES_0x26557651 + sizeof(u64) * 3,
+	.num_rmids			= NUM_RMIDS_0x26557651,
+	.overflow_counter_off		= EVT_BYTES_0x26557651 + sizeof(u64) * 0,
+	.last_overflow_tstamp_off	= EVT_BYTES_0x26557651 + sizeof(u64) * 1,
+	.last_update_tstamp_off		= EVT_BYTES_0x26557651 + sizeof(u64) * 2,
+	.num_events			= NUM_EVENTS_0x26557651,
+	.evts				= {
+		EVT(PMT_EVENT_STALLS_LLC_HIT, 0x0, EVT_TYPE_U64),
+		EVT(PMT_EVENT_C1_RES, 0x8, EVT_TYPE_U64),
+		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, 0x10, EVT_TYPE_U64),
+		EVT(PMT_EVENT_STALLS_LLC_MISS, 0x18, EVT_TYPE_U64),
+		EVT(PMT_EVENT_AUTO_C6_RES, 0x20, EVT_TYPE_U64),
+		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, 0x28, EVT_TYPE_U64),
+		EVT(PMT_EVENT_UOPS_RETIRED, 0x30, EVT_TYPE_U64),
+	}
+};
+
 /* All known telemetry event groups */
 static struct telem_entry *telem_entry[] = {
+	&energy_0x26696143,
+	&perf_0x26557651,
 	NULL
 };
 
-- 
2.48.1

