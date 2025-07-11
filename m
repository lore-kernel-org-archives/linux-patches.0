Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBEA236454
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278042; cv=none; b=o6CWK4x0BTWn6oQhDMgoetuvQ78ImmVCvzBF9TCBo4yirZjbStdEYklwQAlpPFueAcrHv//R+kChZGJcIosmPr2NmQ+0BYtGn4fDpBi3bw6vQoMX+jqJVtB2WKXehurU0u4MLkoHrqp3paZuFkE+V201tka2/JXzDHbqeTEySdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278042; c=relaxed/simple;
	bh=6Q5rZXghnZwk2QwpbWjKTeiYxAt4yvXYvzuKJ69jjrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOjerhTUj3x6pKFzXXLJpmriN0YnxJpgdHjVbq5FKbtLJtx4SvKa0FSiNM4xm9nD7S3SspLSpkVMMq+v3vEnk+lhPc6sEodi1WIADZybSoEV2yg3wkAedIGNRUfUfCKl0Y0E1nK8r9cwAWKQ3ztZUzOUZy/vRGBgP1med/cnLCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mataqxmV; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mataqxmV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278040; x=1783814040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Q5rZXghnZwk2QwpbWjKTeiYxAt4yvXYvzuKJ69jjrs=;
  b=mataqxmVasY0kVA1R/Z/9TRV9AzG7UuxdKu90MBw0e7DO6V+/l7stZSU
   jN4umvAPDfQL/0ml8FQemLrzA6AdFk/toPpl+/WyWHpkYdWi7cQ4Z76bL
   XK0g+OMQkKHUr2OZdLF7BN8ZCMyUBWEWCJPonC4lldpxCgkxbjcSUgH3Z
   LF+fSNsJKEOyulYZv50TEtS5KgTF+wrqWpcb60q36OrTipXUp2BrcWHif
   1LqCJHkQxZSEIN6wJdMlbZwU68v/nZDAcewnS0HkCg+Kt5e3IzpMuoX9I
   AO1hBWE0uN3+iSFiaoi6cnqNX2nnsDwV9MP6MRqVe56FWLpzRu3jywYMq
   g==;
X-CSE-ConnectionGUID: OSOCByyTSWCdEuNpSFnF4g==
X-CSE-MsgGUID: 0W55KDsgR5exmEs0hL2pew==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292684"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292684"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:58 -0700
X-CSE-ConnectionGUID: aTK8eSSkTcu4zX5+fmQlMA==
X-CSE-MsgGUID: 2L4scH14QeqTr74PzYEgPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902128"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:59 -0700
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
Subject: [PATCH v7 14/31] x86,fs/resctrl: Support binary fixed point event counters
Date: Fri, 11 Jul 2025 16:53:21 -0700
Message-ID: <20250711235341.113933-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
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
  2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
  3 binary places is 0.0, 0.125, etc.		=> 3 decimal places

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  4 +-
 fs/resctrl/internal.h              |  5 ++
 arch/x86/kernel/cpu/resctrl/core.c |  6 +-
 fs/resctrl/ctrlmondata.c           | 88 ++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c               | 10 +++-
 5 files changed, 107 insertions(+), 6 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 17a21f193a3d..e9a1cabfc724 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -379,7 +379,9 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
+#define MAX_BINARY_BITS	27
+
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 23dd0b39a117..263a34f06a5b 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -58,6 +58,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @name:		name of the event
  * @configurable:	true if the event is configurable
  * @any_cpu:		true if the event can be read from any CPU
+ * @is_floating_point:	event values are displayed in floating point format
+ * @binary_bits:	number of fixed-point binary bits from architecture,
+ *			only valid if @is_floating_point is true
  * @enabled:		true if the event is enabled
  */
 struct mon_evt {
@@ -66,6 +69,8 @@ struct mon_evt {
 	char			*name;
 	bool			configurable;
 	bool			any_cpu;
+	bool			is_floating_point;
+	unsigned int		binary_bits;
 	bool			enabled;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 0a564285d829..0286d3cf6754 100644
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
index 2e65fddc3408..71d61c96c2b8 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -17,6 +17,7 @@
 
 #include <linux/cpu.h>
 #include <linux/kernfs.h>
+#include <linux/math.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/tick.h>
@@ -590,6 +591,91 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
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
+	 * Multiply by 10^{desired decimal places}. The
+	 * integer part of the fixed point value is now
+	 * almost what is needed.
+	 */
+	frac *= int_pow(10ull, decplaces[binary_bits]);
+
+	/*
+	 * Round to nearest by adding a value that
+	 * would be a "1" in the binary_bit + 1 place.
+	 * Integer part of fixed point value is now
+	 * the needed value.
+	 */
+	frac += 1ull << (binary_bits - 1);
+
+	/*
+	 * Extract the integer part of the value. This
+	 * is the decimal representation of the original
+	 * fixed-point fractional value.
+	 */
+	frac >>= binary_bits;
+
+	/*
+	 * "frac" is now in the range [0 .. 10^decplaces).
+	 * I.e. string representation will fit into
+	 * chosemn number of decimal places.
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
@@ -666,6 +752,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		seq_puts(m, "Error\n");
 	else if (rr.err == -EINVAL)
 		seq_puts(m, "Unavailable\n");
+	else if (evt->is_floating_point)
+		print_event_value(m, evt->binary_bits, rr.val);
 	else
 		seq_printf(m, "%llu\n", rr.val);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index a6d11011cb8e..adb14a9be3d2 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -901,16 +901,22 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
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
2.50.0

