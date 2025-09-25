Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9729532128C
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830654; cv=none; b=bOVI7qNMcYhWq/8x1T0dqVQSjf+XbofNwr+hpvTHqTqRW8p2CeFBukkdUBSytAinyGueBBDAIrsMLtxNNQyaRLGhhVUsQ59WVYwGDiq9yPye9FPL/LxN5+5A+UDxlB0cY7dyUQPK4YxGJL3Tpz/fgHtjSymibJwpJFYUY6sDhoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830654; c=relaxed/simple;
	bh=2f6/Swl91POazZDU/TNZoGBxShRWy4x/LTMyWVuZPCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwO7IsdvVwaQj2Ymbjz6xxKzWWEM7u9Duv8z41m1YMxofjNNobhIh2ByJ+1WYRcLIPUZvJg4ij1oV/iFZDg8ZNNmgta1EEa3TfgrrOJt3/0fipGkBUHa7swRVU2gtFXrCcpRdxPD5Wy6+m7FbZk1iSJqq9ZqlDSfro7usR/iSWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ecHc3PRi; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ecHc3PRi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830653; x=1790366653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2f6/Swl91POazZDU/TNZoGBxShRWy4x/LTMyWVuZPCg=;
  b=ecHc3PRiHfkVzD3QJ6CW3eK/XWvf/MkZJXkS2BqVrhXpqlf8Fi0cNu1L
   iYU+buGkO77LAPtvaw+h8NR4s1aVUXRhlC52poS4NW5xqopp7wHZhb3K2
   ftttKZ3mZ6rryu+0ikI0E7JMhe1oBqa508VWHboJFzD6QK7GoBEP+Guji
   A6HWwaj2MCWTKziorLJj3+WOkgNsm8BmtKUWcOjAk5ipYcXsdj2Zw+clj
   e2m6HsKBoIcJSXEEHh04vWnQacrtXjwXTf4n+wqixL9+8nn3MrrVw0afu
   VRVGlkNYx3LpDaTJrJ4X5OHODWMQxnFDgSckrb5OPNc73ILJ/gd5XRV1m
   A==;
X-CSE-ConnectionGUID: Jm7FAOLDSAmXCuxkJNKEEA==
X-CSE-MsgGUID: 3v/aaNAWQeCwVncY4BlFLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074220"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074220"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:08 -0700
X-CSE-ConnectionGUID: iXyfSXsjS4WkKTGeyIkIew==
X-CSE-MsgGUID: wjD8r8GARwSaVAIPVL/j3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003634"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:08 -0700
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
Subject: [PATCH v11 11/31] x86,fs/resctrl: Support binary fixed point event counters
Date: Thu, 25 Sep 2025 13:03:05 -0700
Message-ID: <20250925200328.64155-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that all monitor events can be displayed as unsigned
decimal integers.

Hardware architecture counters may provide some telemetry events with
greater precision where the event is not a simple count, but is a
measurement of some sort (e.g. Joules for energy consumed).

Add a new argument to resctrl_enable_mon_event() for architecture code
to inform the file system that the value for a counter is a fixed-point
value with a specific number of binary places.
Only allow architecture to use floating point format on events that the
file system has marked with mon_evt::is_floating_point.

Display fixed point values with values rounded to an appropriate number
of decimal places for the precision of the number of binary places
provided. Add one extra decimal place for every three additional binary
places, except for low precision binary values where exact representation
is possible:

  1 binary place is 0.0 or 0.5			=> 1 decimal place
  2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
  3 binary places is 0.0, 0.125, etc.		=> 3 decimal places

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            |  3 +-
 fs/resctrl/internal.h              |  8 +++
 arch/x86/kernel/cpu/resctrl/core.c |  6 +--
 fs/resctrl/ctrlmondata.c           | 84 ++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c               | 14 +++--
 5 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 22edd8d131d8..de66928e9430 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -409,7 +409,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+			      unsigned int binary_bits);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 40b76eaa33d0..f5189b6771a0 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -62,6 +62,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  *			Only valid if @evtid is an MBM event.
  * @configurable:	true if the event is configurable
  * @any_cpu:		true if the event can be read from any CPU
+ * @is_floating_point:	event values are displayed in floating point format
+ * @binary_bits:	number of fixed-point binary bits from architecture,
+ *			only valid if @is_floating_point is true
  * @enabled:		true if the event is enabled
  */
 struct mon_evt {
@@ -71,6 +74,8 @@ struct mon_evt {
 	u32			evt_cfg;
 	bool			configurable;
 	bool			any_cpu;
+	bool			is_floating_point;
+	unsigned int		binary_bits;
 	bool			enabled;
 };
 
@@ -79,6 +84,9 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
 #define for_each_mon_event(mevt) for (mevt = &mon_event_all[QOS_FIRST_EVENT];	\
 				      mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++)
 
+/* Limit for mon_evt::binary_bits */
+#define MAX_BINARY_BITS	27
+
 /**
  * struct mon_data - Monitoring details for each event file.
  * @list:            Member of the global @mon_data_kn_priv_list list.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8db941fef7a0..ccba27df3ea6 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -889,15 +889,15 @@ static __init bool get_rdt_mon_resources(void)
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
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index fbf55e61445c..ae43e09fa5e5 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -17,6 +17,7 @@
 
 #include <linux/cpu.h>
 #include <linux/kernfs.h>
+#include <linux/math.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/tick.h>
@@ -597,6 +598,87 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
+/*
+ * Decimal place precision to use for each number of fixed-point
+ * binary bits.
+ */
+static unsigned int decplaces[MAX_BINARY_BITS + 1] = {
+	[1]  =  1,
+	[2]  =  2,
+	[3]  =  3,
+	[4]  =  3,
+	[5]  =  3,
+	[6]  =  3,
+	[7]  =  3,
+	[8]  =  3,
+	[9]  =  3,
+	[10] =  4,
+	[11] =  4,
+	[12] =  4,
+	[13] =  5,
+	[14] =  5,
+	[15] =  5,
+	[16] =  6,
+	[17] =  6,
+	[18] =  6,
+	[19] =  7,
+	[20] =  7,
+	[21] =  7,
+	[22] =  8,
+	[23] =  8,
+	[24] =  8,
+	[25] =  9,
+	[26] =  9,
+	[27] =  9
+};
+
+static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
+{
+	unsigned long long frac;
+	char buf[10];
+
+	if (!binary_bits) {
+		seq_printf(m, "%llu.0\n", val);
+		return;
+	}
+
+	/* Mask off the integer part of the fixed-point value. */
+	frac = val & GENMASK_ULL(binary_bits, 0);
+
+	/*
+	 * Multiply by 10^{desired decimal places}. The integer part of
+	 * the fixed point value is now almost what is needed.
+	 */
+	frac *= int_pow(10ull, decplaces[binary_bits]);
+
+	/*
+	 * Round to nearest by adding a value that would be a "1" in the
+	 * binary_bits + 1 place.  Integer part of fixed point value is
+	 * now the needed value.
+	 */
+	frac += 1ull << (binary_bits - 1);
+
+	/*
+	 * Extract the integer part of the value. This is the decimal
+	 * representation of the original fixed-point fractional value.
+	 */
+	frac >>= binary_bits;
+
+	/*
+	 * "frac" is now in the range [0 .. 10^decplaces).  I.e. string
+	 * representation will fit into chosen number of decimal places.
+	 */
+	snprintf(buf, sizeof(buf), "%0*llu", decplaces[binary_bits], frac);
+
+	/* Trim trailing zeroes */
+	for (int i = decplaces[binary_bits] - 1; i > 0; i--) {
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
@@ -675,6 +757,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		seq_puts(m, "Unavailable\n");
 	else if (rr.err == -ENOENT)
 		seq_puts(m, "Unassigned\n");
+	else if (evt->is_floating_point)
+		print_event_value(m, evt->binary_bits, rr.val);
 	else
 		seq_printf(m, "%llu\n", rr.val);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 6f8a9b5a2f6b..e354f01df615 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -977,16 +977,22 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits)
 {
-	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
+	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS ||
+			 binary_bits > MAX_BINARY_BITS))
 		return;
 	if (mon_event_all[eventid].enabled) {
 		pr_warn("Duplicate enable for event %d\n", eventid);
 		return;
 	}
+	if (binary_bits && !mon_event_all[eventid].is_floating_point) {
+		pr_warn("Event %d may not be floating point\n", eventid);
+		return;
+	}
 
 	mon_event_all[eventid].any_cpu = any_cpu;
+	mon_event_all[eventid].binary_bits = binary_bits;
 	mon_event_all[eventid].enabled = true;
 }
 
@@ -1812,9 +1818,9 @@ int resctrl_l3_mon_resource_init(void)
 
 	if (r->mon.mbm_cntr_assignable) {
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
+			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
+			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
 		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
 								   (READS_TO_LOCAL_MEM |
-- 
2.51.0

