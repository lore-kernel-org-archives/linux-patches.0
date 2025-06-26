Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831FC2EE61D
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956602; cv=none; b=dTN8ietRZ3K7JYYf3KWznTE9MAC/kedzQB9jAMJrXn3YjXnH4AricQWwFe0oWFdr4lM+nVs3PyXr6HrY0WtuJ0RJUTn6VZZ+lytK0DhjYUDcV2VvOaq/nz8UxmqJN3lbJN64YsMyyK2XtzY/FvjrLFsf7QjOe0tO2a6mCOoimhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956602; c=relaxed/simple;
	bh=cEygOBG7Tos0l17pLw8UJvXD04xloPv44Ad+viQBia4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3zlr4lR3DxghtQ+aeZGJ79RwlO1S+318hAMRyfS0nxrKcLbFDSKef16sDjaEfqPii9QNnMcL5lWUgruDw5cinSawOJDx8I0aXIi0Q5hka9O1KaQpf8qpe7DUN8+tHloFfqT5EA4kGNS+y9ibI7WoYiqy1zXSgH9RS9I5KGZaZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MA6w8cU6; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MA6w8cU6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956601; x=1782492601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cEygOBG7Tos0l17pLw8UJvXD04xloPv44Ad+viQBia4=;
  b=MA6w8cU6iu0zexeubiYBH293NFTorQUEs2Ze/pVnW3rZiGOP4hKmShjP
   8YYf4Vton+EElMl2do1Gql+nJA9U+IvfJkBLAyvtcX0fcuoYPuGUm3pKj
   IhqJ5T8WhVpbs9plDhB048RcWunLpvW8uP2YLnHbxR1wu0HjlBsFW32NC
   6m+g5cbfKjSIeaAT5mYB6jYxFg5GKIpXq+OLCcjHt3eerGROt8oWjFKgp
   S3iSEN/X+wI+N6T7GOSsxY3Vj7DX0oihijC3nkQtyiDbum9zAiHtwpGrc
   t5N/kNIcGFruabyLjZnhC7mJmlZeD+o0pesTj6DaP3kJ3WqGZjmpqIYF0
   g==;
X-CSE-ConnectionGUID: HK+OPLYAQuWnecee7fZauw==
X-CSE-MsgGUID: wOf2MLw5SQKuTiXxl4D0KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136430"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136430"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:57 -0700
X-CSE-ConnectionGUID: +8YQ4GblRFSgjmDWUJEv4A==
X-CSE-MsgGUID: h2vsmCuATBOP7ho0nj7dow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069236"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:56 -0700
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
Subject: [PATCH v6 14/30] x86,fs/resctrl: Support binary fixed point event counters
Date: Thu, 26 Jun 2025 09:49:23 -0700
Message-ID: <20250626164941.106341-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resctrl was written with the assumption that all monitor events can be
displayed as unsigned decimal integers.

Hardware architecture counters may provide some telemetry events with
greater precision where the event is not a simple count, but is a
measurement of some sort (e.g. Joules for energy consumed).

Add a new argument to resctrl_enable_mon_event() for architecture code
to inform the file system that the value for a counter is a fixed-point
value with a specific number of binary places.  The file system will
only allow architecture to use floating point format on events that it
marked with mon_evt::is_floating_point.

Fixed point values are displayed with values rounded to an appropriate
number of decimal places for the precision of the number of binary places
provided. In general one extra decimal place is added for every three
additional binary places. There are some exceptions for low precision
binary values where exact representation is possible:

  1 binary place is 0.0 or 0.5.			=> 1 decimal place
  2 binary places is 0.0. 0.25, 0.5, 0.75	=> 2 decimal places
  3 binary places is 0.0, 0.125, etc.		=> 3 decimal places

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  4 +-
 fs/resctrl/internal.h              |  4 ++
 arch/x86/kernel/cpu/resctrl/core.c |  6 +-
 fs/resctrl/ctrlmondata.c           | 91 +++++++++++++++++++++++++++++-
 fs/resctrl/monitor.c               | 10 +++-
 5 files changed, 108 insertions(+), 7 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index e05a1abb25d4..1060a54cc9fa 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -379,7 +379,9 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
+#define MAX_BINARY_BITS	27
+
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index f51d10d6a510..4dc678af005c 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -58,6 +58,8 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @name:		name of the event
  * @configurable:	true if the event is configurable
  * @any_cpu:		true if the event can be read from any CPU
+ * @is_floating_point:	event values may be displayed in floating point format
+ * @binary_bits:	number of fixed-point binary bits from architecture
  * @enabled:		true if the event is enabled
  */
 struct mon_evt {
@@ -66,6 +68,8 @@ struct mon_evt {
 	char			*name;
 	bool			configurable;
 	bool			any_cpu;
+	bool			is_floating_point;
+	int			binary_bits;
 	bool			enabled;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b83861ab504f..2b6c6b61707d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -887,15 +887,15 @@ static __init bool get_rdt_mon_resources(void)
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
index 2e65fddc3408..29de0e380ccc 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -590,6 +590,93 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
+/**
+ * struct fixed_params - parameters to decode a binary fixed point value
+ * @decplaces:	Number of decimal places for this number of binary places.
+ * @pow10:	Multiplier (10 ^ decimal places).
+ */
+struct fixed_params {
+	int	decplaces;
+	int	pow10;
+};
+
+static struct fixed_params fixed_params[MAX_BINARY_BITS + 1] = {
+	[1]  = { .decplaces = 1, .pow10 = 10 },
+	[2]  = { .decplaces = 2, .pow10 = 100 },
+	[3]  = { .decplaces = 3, .pow10 = 1000 },
+	[4]  = { .decplaces = 3, .pow10 = 1000 },
+	[5]  = { .decplaces = 3, .pow10 = 1000 },
+	[6]  = { .decplaces = 3, .pow10 = 1000 },
+	[7]  = { .decplaces = 3, .pow10 = 1000 },
+	[8]  = { .decplaces = 3, .pow10 = 1000 },
+	[9]  = { .decplaces = 3, .pow10 = 1000 },
+	[10] = { .decplaces = 4, .pow10 = 10000 },
+	[11] = { .decplaces = 4, .pow10 = 10000 },
+	[12] = { .decplaces = 4, .pow10 = 10000 },
+	[13] = { .decplaces = 5, .pow10 = 100000 },
+	[14] = { .decplaces = 5, .pow10 = 100000 },
+	[15] = { .decplaces = 5, .pow10 = 100000 },
+	[16] = { .decplaces = 6, .pow10 = 1000000 },
+	[17] = { .decplaces = 6, .pow10 = 1000000 },
+	[18] = { .decplaces = 6, .pow10 = 1000000 },
+	[19] = { .decplaces = 7, .pow10 = 10000000 },
+	[20] = { .decplaces = 7, .pow10 = 10000000 },
+	[21] = { .decplaces = 7, .pow10 = 10000000 },
+	[22] = { .decplaces = 8, .pow10 = 100000000 },
+	[23] = { .decplaces = 8, .pow10 = 100000000 },
+	[24] = { .decplaces = 8, .pow10 = 100000000 },
+	[25] = { .decplaces = 9, .pow10 = 1000000000 },
+	[26] = { .decplaces = 9, .pow10 = 1000000000 },
+	[27] = { .decplaces = 9, .pow10 = 1000000000 }
+};
+
+static void print_event_value(struct seq_file *m, int binary_bits, u64 val)
+{
+	struct fixed_params *fp = &fixed_params[binary_bits];
+	unsigned long long frac;
+	char buf[10];
+
+	/* Mask off the integer part of the fixed-point value. */
+	frac = val & GENMASK_ULL(binary_bits, 0);
+
+	/*
+	 * Multiply by 10^{desired decimal places}. The
+	 * integer part of the fixed point value is now
+	 * almost what is needed.
+	 */
+	frac *= fp->pow10;
+
+	/*
+	 * Round to nearest by adding a value that
+	 * would be a "1" in the binary_bit + 1 place.
+	 * Integer part of fixed point value is now
+	 * the needed value.
+	 */
+	frac += 1 << (binary_bits - 1);
+
+	/*
+	 * Extract the integer part of the value. This
+	 * is the decimal representation of the original
+	 * fixed-point fractional value.
+	 */
+	frac >>= binary_bits;
+
+	/*
+	 * "frac" is now in the range [0 .. fp->pow10).
+	 * I.e. string representation will fit into
+	 * fp->decplaces.
+	 */
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
@@ -666,8 +753,10 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
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
index aec26457d82c..076c0cc6e53a 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -897,16 +897,22 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits)
 {
-	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
+	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS) ||
+			 binary_bits > MAX_BINARY_BITS)
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
2.49.0

