Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEDA51812B
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788006; cv=none; b=R95AYd84KSh39hDpD5g0QAd03azrrPaFuBUYPuhcNex+rLCNoRCuz7MZgAJl92IVRBBHJxpZpkOtw2oDqpIK9ZYO0WORijwx5s0yU4K9sR+qvPits1ZQ3y550u0Iuzo7BCcN2P7KZNUGRHhOkeDtTkF9P/qHTjfMH0GJ8tnfjv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788006; c=relaxed/simple;
	bh=bzzLqRQcL4j4/jI3tSMnmdNfOyLhafsT7mEkAT529mE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LQY2U9ELA3Oezoo8APWTnD8jR0wlsDUekTUWjyvHcAqRhZQzMfu82AtP9V+ygTVMm/S0KtrqLVJRYyIwMEDKYFuoA8xX16VsofAohaYyP/kbV6aHyqzkjzuZShIJt99LFGhtq77ZK9dDz0y2wamQfgNnf8Z11KFrQOpmMiSJUv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mvAq3BLn; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mvAq3BLn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790788005; x=1822324005;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bzzLqRQcL4j4/jI3tSMnmdNfOyLhafsT7mEkAT529mE=;
  b=mvAq3BLnGb/fKd/ATSXX4gOU1i7DwhBJOPiq8SsF+bKzcbNTzU8fyfw+
   uVdiuvb97qxeyvenuMLZbkRcpmthSrU2hzPJAlzs2zQjdWYsGDejvtEVP
   Z0ISVRSY+tnSeS1lwQGjmssOpwzHthzP85hH8iKETbgQU/Tn3tiq9KR/J
   QkhgebCLSOjuTj2FMKbccNB9t/0TVgnlpigPVIvrHerJniAflG9IwBRBd
   4wz39S0kiYgvhnfnH6KHVf4LMTTNdl8axWrLdt04dy++k/J90b1G2PoJ7
   YzHBag5hXPJlURa9SCxGLrVuYCwg+SOn/GjfN0S6eiQlvOZvBaNuZgpSQ
   A==;
X-CSE-ConnectionGUID: lNPODOZZSHiBohuJu6/lXA==
X-CSE-MsgGUID: fVVLQe+HTj6/IHvE4o8jgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="90299474"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90299474"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 10:06:44 -0700
X-CSE-ConnectionGUID: 9cwheulbS56BJXe4zmjZmQ==
X-CSE-MsgGUID: 50l3AmTIQzCBk8FPSqoLNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275292858"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.50])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 10:05:30 -0700
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
Subject: [PATCH v3] x86,fs/resctrl: Add event group descriptions for Intel Diamond Rapids
Date: Wed, 30 Sep 2026 10:05:22 -0700
Message-ID: <20260930170522.12522-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel Diamond Rapids exposes Application Energy Telemetry through two
new PMT aggregator GUIDs: one covering the "energy" feature, and one
covering the "perf" feature, both documented in the Intel-PMT XML
repository [1].

The "perf" aggregator references two events not previously enumerated
by resctrl: retired instructions (INST_RETIRED), and a count of
unhalted core clock cycles perceived by hardware as contributing to
instruction execution (PCNT).

Add definitions for both aggregators, and add the two new events to
the resctrl filesystem so they can be exposed to user space.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://github.com/intel/Intel-PMT # [1]
---
v3:
	Use lower case for GUIDs containing hex
	Add Reinette RB tag
---
 include/linux/resctrl_types.h           |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
 fs/resctrl/monitor.c                    |  2 ++
 3 files changed, 38 insertions(+)

diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index a5f56faa18d2..e2e2cf3d9ff6 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -60,6 +60,8 @@ enum resctrl_event_id {
 	PMT_EVENT_AUTO_C6_RES,
 	PMT_EVENT_UNHALTED_REF_CYCLES,
 	PMT_EVENT_UOPS_RETIRED,
+	PMT_EVENT_INST_RETIRED,
+	PMT_EVENT_PCNT,
 
 	/* Must be the last */
 	QOS_NUM_EVENTS,
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index c22c3cf5167d..79876443a622 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -125,9 +125,43 @@ static struct event_group perf_0x26557651 = {
 	}
 };
 
+/*
+ * Link: https://github.com/intel/Intel-PMT/blob/main/xml/DMR/OOBMSM/RMID-ENERGY/dmr_aggregator.xml
+ */
+static struct event_group energy_0x47903099 = {
+	.pfname		= "energy",
+	.guid		= 0x47903099,
+	.num_rmid	= 256,
+	.mmio_size	= XML_MMIO_SIZE(256, 2, 3),
+	.num_events	= 2,
+	.evts		= {
+		EVT(PMT_EVENT_ENERGY, 0, 18),
+		EVT(PMT_EVENT_ACTIVITY, 1, 18),
+	}
+};
+
+/*
+ * Link: https://github.com/intel/Intel-PMT/blob/main/xml/DMR/OOBMSM/RMID-PERF/dmr_aggregator.xml
+ */
+static struct event_group perf_0x1415910a = {
+	.pfname		= "perf",
+	.guid		= 0x1415910a,
+	.num_rmid	= 256,
+	.mmio_size	= XML_MMIO_SIZE(256, 4, 3),
+	.num_events	= 4,
+	.evts		= {
+		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, 0, 0),
+		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, 1, 0),
+		EVT(PMT_EVENT_INST_RETIRED, 2, 0),
+		EVT(PMT_EVENT_PCNT, 3, 0),
+	}
+};
+
 static struct event_group *known_event_groups[] = {
 	&energy_0x26696143,
+	&energy_0x47903099,
 	&perf_0x26557651,
+	&perf_0x1415910A,
 };
 
 #define for_each_event_group(_peg)						\
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 73413cb128ea..04e4ea612b7c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1041,6 +1041,8 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	MON_EVENT(PMT_EVENT_AUTO_C6_RES,		"c6_res",		RDT_RESOURCE_PERF_PKG,	false),
 	MON_EVENT(PMT_EVENT_UNHALTED_REF_CYCLES,	"unhalted_ref_cycles",	RDT_RESOURCE_PERF_PKG,	false),
 	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
+	MON_EVENT(PMT_EVENT_INST_RETIRED,		"inst_retired",		RDT_RESOURCE_PERF_PKG,	false),
+	MON_EVENT(PMT_EVENT_PCNT,			"pcnt",			RDT_RESOURCE_PERF_PKG,	false),
 };
 
 bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
-- 
2.55.0

