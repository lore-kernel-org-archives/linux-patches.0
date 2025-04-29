Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D6138F80
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886862; cv=none; b=n3CSMKv3kiWXJNV2tGGPGHmOJ/8cctVFJsFw2iAkSBm4VGzpRGyFk39HF2vXC5f2zx7b9Wo9D2wzBosPednpNIWbrd4wwBT3QX1SBTqN0sQgxF1083WIsZVN1zMwJHSIzp5aIe2HV4HcvtKtI1hnAiiW6DoZWQYf1hcqALxdpjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886862; c=relaxed/simple;
	bh=z0L0z/agPWaN8QNGwNrQmf+C5bmutBlZQlBrNgZsyjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkGssM4/UiP37G9tp527SYcn4Rx++MjVhFcCyJ7XFABI8iz1PYTOFfYOF29Ni/Ixy5lYCL50Hg7wpvT+Yf57ntbjoYij3X3Ot1Om19VL88dODIVXvTO7955/Ts4GQSioyzIs5tAsrWTFbYmEUl2BMBXfTsZVEoB6tmJbN9dskXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fxoZB9JL; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fxoZB9JL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886860; x=1777422860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z0L0z/agPWaN8QNGwNrQmf+C5bmutBlZQlBrNgZsyjo=;
  b=fxoZB9JLtqitAh+t+MWdEh/8mYOzTAwc3s64Cx5G+Brb5STKsSfW66p+
   FPwipgk6sZCCsXlC263f95Rxardyz7QpRbFwJDdCTN9rr6xj4IlEEmr94
   lQNiEWICkIaxM6/VM5cP4oHH9uSX4ldl4GaaOifrtf7Ay9HtApdosJu/0
   xHQMboYu4IRr5Mj0hbwQCG4mthoOLre7voOwLahe8KglCyVQRN4HMfpct
   sVSy4FNnKFKlga+9dfLq5anfC2e7N0rHivfRR5laaYe+BzlJ0Suf3ENtp
   s/XxgMrB+duPgAaf0ZMqWDbdFsMlOUm1uoXQ4Q4Sogk1m3Gxu6PqA4L1k
   Q==;
X-CSE-ConnectionGUID: mO2DFrp2Ty+PUQi//TSGog==
X-CSE-MsgGUID: jzTNKR0xQzCgD7iQP5rokA==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148159"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148159"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:15 -0700
X-CSE-ConnectionGUID: mOGWEq6iRI6gE/GzO7OrZw==
X-CSE-MsgGUID: FPflHQezSCCYPULzPlcdSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394007"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:14 -0700
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
Subject: [PATCH v4 13/31] fs/resctrl: Add support for additional monitor event display formats
Date: Mon, 28 Apr 2025 17:33:39 -0700
Message-ID: <20250429003359.375508-14-tony.luck@intel.com>
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

Resctrl was written with the assumption that all monitor events
can be displayed as unsigned decimal integers.

Some telemetry events provide greater precision where architecture code
uses a fixed point format with 18 binary places.

Add a "display_format" field to struct mon_evt which can specify
that the value for the event be displayed as an integer for legacy
events, or as a floating point value with six decimal places converted
from the fixed point format received from architecture code.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl_types.h |  5 +++++
 fs/resctrl/internal.h         |  2 ++
 fs/resctrl/ctrlmondata.c      | 24 +++++++++++++++++++++++-
 fs/resctrl/monitor.c          | 21 ++++++++++++---------
 4 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index 5ef14a24008c..6245034f6c76 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -50,4 +50,9 @@ enum resctrl_event_id {
 #define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
 #define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
 
+/* Event value display formats */
+enum resctrl_event_fmt {
+	EVT_FORMAT_U64,
+	EVT_FORMAT_U46_18,
+};
 #endif /* __LINUX_RESCTRL_TYPES_H */
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index d8aa69b42c74..aaa74a17257d 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -73,6 +73,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @configurable:	true if the event is configurable
  * @enabled:		true if the event is enabled
  * @any_cpu:		true if the event can be read from any CPU
+ * @display_format:	format to display value to users
  * @list:		entry in &rdt_resource->evt_list
  */
 struct mon_evt {
@@ -82,6 +83,7 @@ struct mon_evt {
 	bool			configurable;
 	bool			enabled;
 	bool			any_cpu;
+	enum resctrl_event_fmt	display_format;
 	struct list_head	list;
 };
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 7a2957b9c13e..1544c103446b 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -569,6 +569,28 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
+#define NUM_FRAC_BITS	18
+#define FRAC_MASK	GENMASK(NUM_FRAC_BITS - 1, 0)
+
+static void print_event_value(struct seq_file *m, enum resctrl_event_fmt type, u64 val)
+{
+	u64 frac;
+
+	switch (type) {
+	case EVT_FORMAT_U64:
+		seq_printf(m, "%llu\n", val);
+		break;
+	case EVT_FORMAT_U46_18:
+		frac = val & FRAC_MASK;
+		frac = frac * 1000000;
+		/* round values up to nearest decimal representation */
+		frac += 1ul << (NUM_FRAC_BITS - 1);
+		frac >>= NUM_FRAC_BITS;
+		seq_printf(m, "%llu.%06llu\n", val >> NUM_FRAC_BITS, frac);
+		break;
+	}
+}
+
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
@@ -637,7 +659,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	else if (rr.err == -EINVAL)
 		seq_puts(m, "Unavailable\n");
 	else
-		seq_printf(m, "%llu\n", rr.val);
+		print_event_value(m, evt->display_format, rr.val);
 
 out:
 	rdtgroup_kn_unlock(of->kn);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index e903d3c076ee..be78488a15e5 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -844,19 +844,22 @@ static void dom_data_exit(struct rdt_resource *r)
 
 struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	[QOS_L3_OCCUP_EVENT_ID] = {
-		.name	= "llc_occupancy",
-		.evtid	= QOS_L3_OCCUP_EVENT_ID,
-		.rid	= RDT_RESOURCE_L3,
+		.name		= "llc_occupancy",
+		.evtid		= QOS_L3_OCCUP_EVENT_ID,
+		.rid		= RDT_RESOURCE_L3,
+		.display_format	= EVT_FORMAT_U64,
 	},
 	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
-		.name	= "mbm_total_bytes",
-		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
-		.rid	= RDT_RESOURCE_L3,
+		.name		= "mbm_total_bytes",
+		.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
+		.rid		= RDT_RESOURCE_L3,
+		.display_format	= EVT_FORMAT_U64,
 	},
 	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
-		.name	= "mbm_local_bytes",
-		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
-		.rid	= RDT_RESOURCE_L3,
+		.name		= "mbm_local_bytes",
+		.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
+		.rid		= RDT_RESOURCE_L3,
+		.display_format	= EVT_FORMAT_U64,
 	},
 };
 
-- 
2.48.1

