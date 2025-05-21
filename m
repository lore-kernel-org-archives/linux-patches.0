Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781F623D2B6
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867867; cv=none; b=NnCWRPr9E/Tlihw+wiMmijHQNSQGNKoRV/EvJYGJGlshheSiZt3xL08xqRWaZT4ZFlWXL0nX11QrqU01yfgm72INyhcjF5ilILvyro8PvJubFWFIHG8o9tty8jwm2MGCxs57eQoKBjsALoGFhBCL2jIyLBOlNql5BrGF5u/ycx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867867; c=relaxed/simple;
	bh=5gTvtBqwCiz3yA1qAMmHe8YRGbU+roL/wG25p3KREaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVzFlwAJb0IVppR6F+Omsuqdh8/3+mJR5XjQgcpniiANmFdfFBSGG5PeC7Zl+UbqVt6VXYDbkjbKCnATw4OqLjRRuWJcbTEBdhpXDq5aObDPWfnIbnKAuQ2ztqsecMHBJbkK+feCDvCv05ZyLiKS+3sJchgwMgVSlXRR0k6aiyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FeDVR34S; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FeDVR34S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867865; x=1779403865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5gTvtBqwCiz3yA1qAMmHe8YRGbU+roL/wG25p3KREaY=;
  b=FeDVR34Swpb9XAO1CQ/T2euaS08B4ZUtxQuBgQW20/FuI7hrQ6AcyTEL
   V2zihmAn6HlPr0XcMVUkyII2p+fNQBuLlSFbBtrjdU/Yt62bI7g7iCheO
   PYpbJy2lY6OVo6KAeVAuzAYkmRHAUCK3VJLyd7IarEMra6QCGa2Czok7l
   4MEufdnXscGljXD3Kz/BmPoJA8XyIeNnnf3Mbea7le0vs2UnNyxmwfT+E
   QFLk7ePvNBKamZcUdDKGPrdnScjeOhe3CQF3VN+wV8/cibMdR4RHGUWej
   Jv1hiZioosHyZOeYs4Uj58dz1nSM+6c58GEP/0Pb5UJ1fTcnTDgFGQULE
   g==;
X-CSE-ConnectionGUID: s0aoNxbXRqeRJ62s91Py2Q==
X-CSE-MsgGUID: 3Y3RTXApQQya+FsdmMy4jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677717"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677717"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
X-CSE-ConnectionGUID: VNWoHoMIQA+WSFuxGpzYVg==
X-CSE-MsgGUID: wUTivwGkTjOI0RJAbTWDQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352163"
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
Subject: [PATCH v5 14/29] x86,fs/resctrl: Support binary fixed point event counters
Date: Wed, 21 May 2025 15:50:32 -0700
Message-ID: <20250521225049.132551-15-tony.luck@intel.com>
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

Resctrl was written with the assumption that all monitor events
can be displayed as unsigned decimal integers.

Hardware architecture counters may provide some telemetry events with
greater precision where the event is not a simple count, but is a
measurement of some sort (e.g. Joules for energy consumed).

Add a new argument to resctrl_enable_mon_event() for architecture
code to inform the file system that the value for a counter is
a fixed-point value with a specific number of binary places.

Fixed point values are displayed with values rounded to an
appropriate number of decimal places.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  4 +-
 fs/resctrl/internal.h              |  2 +
 arch/x86/kernel/cpu/resctrl/core.c |  6 +--
 fs/resctrl/ctrlmondata.c           | 75 +++++++++++++++++++++++++++++-
 fs/resctrl/monitor.c               |  5 +-
 5 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 9aab3d78005a..46ba62ee94a1 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -377,7 +377,9 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu);
+#define MAX_BINARY_BITS	27
+
+void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu, u32 binary_bits);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index eb6e92d1ab15..d5045491790e 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -58,6 +58,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @name:		name of the event
  * @configurable:	true if the event is configurable
  * @any_cpu:		true if the event can be read from any CPU
+ * @binary_bits:	number of fixed-point binary bits from architecture
  * @enabled:		true if the event is enabled
  */
 struct mon_evt {
@@ -66,6 +67,7 @@ struct mon_evt {
 	char			*name;
 	bool			configurable;
 	bool			any_cpu;
+	int			binary_bits;
 	bool			enabled;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 5d9a024ce4b0..306afb50fd37 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -880,15 +880,15 @@ static __init bool get_rdt_mon_resources(void)
 	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
-		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
+		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
+		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
+		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
 		ret = true;
 	}
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 1337716f59c8..07bf44834a46 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -590,6 +590,77 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
+/**
+ * struct fixed_params - parameters to decode a binary fixed point value
+ * @mask:	Mask for fractional part of value.
+ * @lshift:	Shift to round-up binary places.
+ * @pow10:	Multiplier (10 ^ decimal places).
+ * @round:	Add to round up to nearest decimal representation.
+ * @rshift:	Shift back for final answer.
+ * @decplaces:	Number of decimal places for this number of binary places.
+ */
+struct fixed_params {
+	u64	mask;
+	int	lshift;
+	int	pow10;
+	u64	round;
+	int	rshift;
+	int	decplaces;
+};
+
+static struct fixed_params fixed_params[MAX_BINARY_BITS + 1] = {
+	[1]  = { GENMASK_ULL(1, 0),  0,         10, 0x00000000,  1,  1 },
+	[2]  = { GENMASK_ULL(2, 0),  0,        100, 0x00000000,  2,  2 },
+	[3]  = { GENMASK_ULL(3, 0),  0,       1000, 0x00000000,  3,  3 },
+	[4]  = { GENMASK_ULL(4, 0),  2,       1000, 0x00000020,  6,  3 },
+	[5]  = { GENMASK_ULL(5, 0),  1,       1000, 0x00000020,  6,  3 },
+	[6]  = { GENMASK_ULL(6, 0),  0,       1000, 0x00000020,  6,  3 },
+	[7]  = { GENMASK_ULL(7, 0),  2,       1000, 0x00000100,  9,  3 },
+	[8]  = { GENMASK_ULL(8, 0),  1,       1000, 0x00000100,  9,  3 },
+	[9]  = { GENMASK_ULL(9, 0),  0,       1000, 0x00000100,  9,  3 },
+	[10] = { GENMASK_ULL(10, 0), 2,      10000, 0x00000800, 12,  4 },
+	[11] = { GENMASK_ULL(11, 0), 1,      10000, 0x00000800, 12,  4 },
+	[12] = { GENMASK_ULL(12, 0), 0,      10000, 0x00000800, 12,  4 },
+	[13] = { GENMASK_ULL(13, 0), 2,     100000, 0x00004000, 15,  5 },
+	[14] = { GENMASK_ULL(14, 0), 1,     100000, 0x00004000, 15,  5 },
+	[15] = { GENMASK_ULL(15, 0), 0,     100000, 0x00004000, 15,  5 },
+	[16] = { GENMASK_ULL(16, 0), 2,    1000000, 0x00020000, 18,  6 },
+	[17] = { GENMASK_ULL(17, 0), 1,    1000000, 0x00020000, 18,  6 },
+	[18] = { GENMASK_ULL(18, 0), 0,    1000000, 0x00020000, 18,  6 },
+	[19] = { GENMASK_ULL(19, 0), 2,   10000000, 0x00100000, 21,  7 },
+	[20] = { GENMASK_ULL(20, 0), 1,   10000000, 0x00100000, 21,  7 },
+	[21] = { GENMASK_ULL(21, 0), 0,   10000000, 0x00100000, 21,  7 },
+	[22] = { GENMASK_ULL(22, 0), 2,  100000000, 0x00800000, 24,  8 },
+	[23] = { GENMASK_ULL(23, 0), 1,  100000000, 0x00800000, 24,  8 },
+	[24] = { GENMASK_ULL(24, 0), 0,  100000000, 0x00800000, 24,  8 },
+	[25] = { GENMASK_ULL(25, 0), 2, 1000000000, 0x04000000, 27,  9 },
+	[26] = { GENMASK_ULL(26, 0), 1, 1000000000, 0x04000000, 27,  9 },
+	[27] = { GENMASK_ULL(27, 0), 0, 1000000000, 0x04000000, 27,  9 }
+};
+
+static void print_event_value(struct seq_file *m, int binary_bits, u64 val)
+{
+	struct fixed_params *fp = &fixed_params[binary_bits];
+	unsigned long long frac;
+	char buf[10];
+
+	frac = val & fp->mask;
+	frac <<= fp->lshift;
+	frac *= fp->pow10;
+	frac += fp->round;
+	frac >>= fp->rshift;
+
+	sprintf(buf, "%0*llu", fp->decplaces, frac);
+
+	/* Trim trailing zeroes */
+	for (int i = fp->decplaces - 1; i > 0; i--) {
+		if (buf[i] != '0')
+			break;
+		buf[i] = '\0';
+	}
+	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
+}
+
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
@@ -657,8 +728,10 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		seq_puts(m, "Error\n");
 	else if (rr.err == -EINVAL)
 		seq_puts(m, "Unavailable\n");
-	else
+	else if (evt->binary_bits == 0)
 		seq_printf(m, "%llu\n", rr.val);
+	else
+		print_event_value(m, evt->binary_bits, rr.val);
 
 out:
 	rdtgroup_kn_unlock(of->kn);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index e6e3be990638..f554d7933739 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -878,9 +878,9 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu)
+void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu, u32 binary_bits)
 {
-	if (WARN_ON_ONCE(evtid >= QOS_NUM_EVENTS))
+	if (WARN_ON_ONCE(evtid >= QOS_NUM_EVENTS) || binary_bits > MAX_BINARY_BITS)
 		return;
 	if (mon_event_all[evtid].enabled) {
 		pr_warn("Duplicate enable for event %d\n", evtid);
@@ -888,6 +888,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu)
 	}
 
 	mon_event_all[evtid].any_cpu = any_cpu;
+	mon_event_all[evtid].binary_bits = binary_bits;
 	mon_event_all[evtid].enabled = true;
 }
 
-- 
2.49.0

