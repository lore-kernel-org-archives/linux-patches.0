Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F4930C618
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408523; cv=none; b=KipaAA8ryuLkCNijVA9WuuwfIMIcw8I4I8OYrmwC8GDOvbcFoxFXXftd3/pcIdP6OeBlJnxy4Ouziekl+uKdeYuZFkQ2QZbeOE34m4fwiU052xH2dPgkRpSzoPIj2XERWhINBgDOVhSf1ueLsGB1dP/WtKngC7s9wYkwEnuSAT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408523; c=relaxed/simple;
	bh=Iq+khrH84RR1qQPndfNyfQcjfBndGjwEGwQ1TgErAtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3qGZAIYs570mFTpiLNwhWLy6q+4k3EkT5reOisqljbMXTLhSG1rhHk4xNn7kkO1ugLO15ijS2irHAHOM5v2f8dzh6VsVE1QWJUJfCb9OR9JENzr8IvcG54xZup1JPhMCj+Sxs9MWLUckuFgEA10SlHMUXK08rPyM0HGJmJOC7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EXl3b1Av; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EXl3b1Av"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408516; x=1796944516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iq+khrH84RR1qQPndfNyfQcjfBndGjwEGwQ1TgErAtw=;
  b=EXl3b1AvLpGJ6Ut5q6nZQbVhfadQfTc+195s5ZeL0xfcGBz8sLo4dba5
   WXHjN48d46k2ARPD1T8a63AQ/h0Vl9sckAZ030cNVgCfhN2IE/K6M75Qs
   0cfR2ayQCymzVRZSTM6tkubd1lmuL4hZDQDgWvIqJkupjBvwpDOwGg9Dw
   8v+AAc2q2B0IAonnMYDy2TxwoKfsoHZ/d+cjAFWTHuyVL4R+bKxzs0QjW
   p7sbBI6wGjmb8fPN42zubBqb00Juko8k9aeoy8fBUD9e+fJexpZ3AUdl7
   0cby/iWsjQAKTv5J/lueB3lrVW/nBTcWyep8LwHVP3T0KGoYrHdHOTr61
   Q==;
X-CSE-ConnectionGUID: ZIixHdEcSduBJs90jaS3Tw==
X-CSE-MsgGUID: QdPfwvcgTFCCW4FLSZM18w==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973673"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973673"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:40 -0800
X-CSE-ConnectionGUID: HRopHPBUQvGgeYu2WlqiEQ==
X-CSE-MsgGUID: MDRVIbjSTzmgvOzmytzNEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297131"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:40 -0800
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
Subject: [PATCH v16 24/32] x86/resctrl: Add energy/perf choices to rdt boot option
Date: Wed, 10 Dec 2025 15:14:03 -0800
Message-ID: <20251210231413.59102-25-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy resctrl features are enumerated by X86_FEATURE_* flags. These may be
overridden by quirks to disable features in the case of errata.  Users can
use kernel command line options to either disable a feature, or to force
enable a feature that was disabled by a quirk.

A different approach is needed for hardware features that do not have an
X86_FEATURE_* flag.

Update parsing of the "rdt=" boot parameter to call the telemetry driver
directly to handle new "perf" and "energy" options that controls activation
of telemetry monitoring of the named type. By itself a "perf" or "energy" option
controls the forced enabling or disabling (with ! prefix) of all event groups of
the named type. A ":guid" suffix allows for fine grain control per event group.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++-
 arch/x86/kernel/cpu/resctrl/internal.h        |  2 +
 arch/x86/kernel/cpu/resctrl/core.c            |  2 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 38 +++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2b465eab41a1..cc9d2800abeb 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6217,9 +6217,14 @@
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, smba, bmec, abmc, sdciae.
+			mba, smba, bmec, abmc, sdciae, energy[:guid],
+			perf[:guid].
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
+			To turn off all energy telemetry monitoring and ensure that
+			perf telemetry monitoring associated with guid 0x12345
+			is enabled use:
+				rdt=!energy,perf:0x12345
 
 	reboot=		[KNL]
 			Format (x86 or x86_64):
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 3b228b241fb2..df09091f7c6c 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -236,6 +236,7 @@ void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
+bool intel_aet_option(bool force_off, char *tok);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
@@ -246,6 +247,7 @@ static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64
 
 static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 					      struct list_head *add_pos) { }
+static inline bool intel_aet_option(bool force_off, char *tok) { return false; }
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 283d653002a2..960974ffa866 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -820,6 +820,8 @@ static int __init set_rdt_options(char *str)
 		force_off = *tok == '!';
 		if (force_off)
 			tok++;
+		if (intel_aet_option(force_off, tok))
+			continue;
 		for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
 			if (strcmp(tok, o->name) == 0) {
 				if (force_off)
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 35761d6cd55b..df91e1ea4a7b 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -52,12 +52,17 @@ struct pmt_event {
 /**
  * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
  * @pfname:		PMT feature name ("energy" or "perf") of this event group.
+ *			Used by boot rdt= option.
  * @pfg:		Points to the aggregated telemetry space information
  *			returned by the intel_pmt_get_regions_by_feature()
  *			call to the INTEL_PMT_TELEMETRY driver that contains
  *			data for all telemetry regions of type @pfname.
  *			Valid if the system supports the event group,
  *			NULL otherwise.
+ * @force_off:		True when "rdt" command line or architecture code disables
+ *			this event group.
+ * @force_on:		True when "rdt" command line overrides disable of this
+ *			event group.
  * @guid:		Unique number per XML description file.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
@@ -67,6 +72,7 @@ struct event_group {
 	/* Data fields for additional structures to manage this group. */
 	const char			*pfname;
 	struct pmt_feature_group	*pfg;
+	bool				force_off, force_on;
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
@@ -121,6 +127,35 @@ static struct event_group *known_event_groups[] = {
 	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
 	     _peg++)
 
+bool intel_aet_option(bool force_off, char *tok)
+{
+	struct event_group **peg;
+	bool ret = false;
+	u32 guid = 0;
+	char *name;
+
+	if (!tok)
+		return false;
+
+	name = strsep(&tok, ":");
+	if (tok && kstrtou32(tok, 16, &guid))
+		return false;
+
+	for_each_event_group(peg) {
+		if (strcmp(name, (*peg)->pfname))
+			continue;
+		if (guid && (*peg)->guid != guid)
+			continue;
+		if (force_off)
+			(*peg)->force_off = true;
+		else
+			(*peg)->force_on = true;
+		ret = true;
+	}
+
+	return ret;
+}
+
 /*
  * Clear the address field of regions that did not pass the checks in
  * skip_telem_region() so they will not be used by intel_aet_read_event().
@@ -172,6 +207,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int skipped_events = 0;
 
+	if (e->force_off)
+		return false;
+
 	if (!group_has_usable_regions(e, p))
 		return false;
 
-- 
2.51.1

