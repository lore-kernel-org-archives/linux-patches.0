Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EC6320CA0
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010495; cv=none; b=Rr/GMk7iaWAFwwEM3AfTuOTPaplXmbtnl5+ByqVzGCTz/KqFbuBNJIBTAupY7NRHUURmHOlStSt4Fyh8Z+1NmWy27NGdzfj9PxMgpeu6X6ZGvrf4+gBfvWA7IJoE5mQfYmK0ElGjlk3TC55MIikQnohCc6Pki/rV5liFWTGBT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010495; c=relaxed/simple;
	bh=BHW2P22nkzgIe9yBxx11bv1THtGmQBmLC7K8mfk28uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnuCfCB5tdGgUTt3FLoZAuhEHyuGZMw0DP/h83r6lBMC9k8FJMzQyLNHsWiSeqUCfxmmZqWxZis7FabS4+sdFDSyLMHxkHhNke1G1GUoVk0KYZcYmI8M97RgTvVqmJT0Kip6U1qvrnqx5bGNo6WM/wm2aOliRZgMd78C2fe71Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lgL0cLk0; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lgL0cLk0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010494; x=1795546494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BHW2P22nkzgIe9yBxx11bv1THtGmQBmLC7K8mfk28uY=;
  b=lgL0cLk0oyRCDNzdvhHU3L2YFck4h/zEcaf+gtPEnitZC43sr1hkmkcD
   tn5bXTTH96jjrkabPICMJBrsP1Uh4mkLW2uKk6uLV76Y6mO8C2mYlBPlM
   UXORYC0OLvl/gJoOy2Omay+9wFMrnoeyaJRou18/GhOKdWbbXDAoFeMMr
   1zZZ6GXjUZfhgKWVJuEpTYJx3Qu8YgSwSo6nlXeFwIYwUojrttBJNBqaX
   aKlTj2nGXoCsUy3H9xuYTb2LZwFI43rbklxh962TKGlf438o9Gi+6qMnP
   aj3yyARnGrHwSu6ZGTUUWucRLCdu/iMhimnA9whEFLShPhdVHSnWbvVKc
   g==;
X-CSE-ConnectionGUID: xaTjWULmTbO42xYlCT9T4Q==
X-CSE-MsgGUID: NT0YHHqVTWmIwEaDauWlzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636616"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636616"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:25 -0800
X-CSE-ConnectionGUID: 5BXxuvzrQTaWTk8qgnmpbg==
X-CSE-MsgGUID: /MmFPJjITlecRwTcJQEe/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224979"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:25 -0800
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
Subject: [PATCH v14 12/32] x86,fs/resctrl: Support binary fixed point event counters
Date: Mon, 24 Nov 2025 10:53:49 -0800
Message-ID: <20251124185412.24155-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that all monitor events can be displayed as unsigned decimal
integers.

Hardware architecture counters may provide some telemetry events with greater
precision where the event is not a simple count, but is a measurement of
some sort (e.g. Joules for energy consumed).

Add a new argument to resctrl_enable_mon_event() for architecture code
to inform the file system that the value for a counter is a fixed-point
value with a specific number of binary places.

Display fixed point values with values rounded to ceil(binary_bits * log10(2))
decimal places. Special case for zero binary bits to print "{value}.0".

Only allow architecture to use floating point format on events that the file
system has marked with mon_evt::is_floating_point.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            |  3 +-
 fs/resctrl/internal.h              |  8 ++++
 arch/x86/kernel/cpu/resctrl/core.c |  6 +--
 fs/resctrl/ctrlmondata.c           | 74 ++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c               | 10 +++-
 5 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 22c5d07fe9ff..c43526cdf304 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -412,7 +412,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+			      unsigned int binary_bits);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index fb0b6e40d022..14e5a9ed1fbd 100644
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
index bd4a98106153..9222eee7ce07 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -902,15 +902,15 @@ static __init bool get_rdt_mon_resources(void)
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
index 2c69fcd70eeb..f319fd1a6de3 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -17,6 +17,7 @@
 
 #include <linux/cpu.h>
 #include <linux/kernfs.h>
+#include <linux/math.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/tick.h>
@@ -601,6 +602,77 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
+/*
+ * Decimal place precision to use for each number of fixed-point
+ * binary bits computed from ceil(binary_bits * log10(2)) except
+ * binary_bits == 0 which will print "value.0"
+ */
+static const unsigned int decplaces[MAX_BINARY_BITS + 1] = {
+	[0]  =  1,
+	[1]  =  1,
+	[2]  =  1,
+	[3]  =  1,
+	[4]  =  2,
+	[5]  =  2,
+	[6]  =  2,
+	[7]  =  3,
+	[8]  =  3,
+	[9]  =  3,
+	[10] =  4,
+	[11] =  4,
+	[12] =  4,
+	[13] =  4,
+	[14] =  5,
+	[15] =  5,
+	[16] =  5,
+	[17] =  6,
+	[18] =  6,
+	[19] =  6,
+	[20] =  7,
+	[21] =  7,
+	[22] =  7,
+	[23] =  7,
+	[24] =  8,
+	[25] =  8,
+	[26] =  8,
+	[27] =  9
+};
+
+static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
+{
+	unsigned long long frac = 0;
+
+	if (binary_bits) {
+		/* Mask off the integer part of the fixed-point value. */
+		frac = val & GENMASK_ULL(binary_bits - 1, 0);
+
+		/*
+		 * Multiply by 10^{desired decimal places}. The integer part of
+		 * the fixed point value is now almost what is needed.
+		 */
+		frac *= int_pow(10ull, decplaces[binary_bits]);
+
+		/*
+		 * Round to nearest by adding a value that would be a "1" in the
+		 * binary_bits + 1 place.  Integer part of fixed point value is
+		 * now the needed value.
+		 */
+		frac += 1ull << (binary_bits - 1);
+
+		/*
+		 * Extract the integer part of the value. This is the decimal
+		 * representation of the original fixed-point fractional value.
+		 */
+		frac >>= binary_bits;
+	}
+
+	/*
+	 * "frac" is now in the range [0 .. 10^decplaces).  I.e. string
+	 * representation will fit into chosen number of decimal places.
+	 */
+	seq_printf(m, "%llu.%0*llu\n", val >> binary_bits, decplaces[binary_bits], frac);
+}
+
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
@@ -678,6 +750,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		seq_puts(m, "Unavailable\n");
 	else if (rr.err == -ENOENT)
 		seq_puts(m, "Unassigned\n");
+	else if (evt->is_floating_point)
+		print_event_value(m, evt->binary_bits, rr.val);
 	else
 		seq_printf(m, "%llu\n", rr.val);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index a503ddd159fd..9c316b714968 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -981,16 +981,22 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
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
 
-- 
2.51.1

