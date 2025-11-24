Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048EA32572E
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010507; cv=none; b=KpIFA5MlQTzYmkQLG/ESKAtHxI1k7fXF0ItdeMFZ6qhp0WFZBfISWIWA5TnAmfemuQl30EdBszNeSKYGYOh5blPRqvSimJWKRULy2TCV+cZzacr6Ft2yP29HapiPo7qZU5q3AgkBwTkNNP6a2O4lnoi4qE8uRb0NBYVSQVblnqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010507; c=relaxed/simple;
	bh=4XoXTDSAzjR+FuLDzRLi0xcTlYd7JBY+p4ofE6ckqr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EI8V0bsBBCeHEjmzDUaZQXTYfEdI0tg49oWzW8tnOR+BRTnZ+UOj/Woo+1qfEpnEmuK5v18jiUnNJQI40rb2Hy+IX3QHDJK2RRplybM8Zg/pNIkrphdgUB8ntMeFIhpvs8f725snkL54rH1s9wlBC2W9itEUzzdKBaS/puLPEv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T0V1lbDj; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T0V1lbDj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010506; x=1795546506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4XoXTDSAzjR+FuLDzRLi0xcTlYd7JBY+p4ofE6ckqr8=;
  b=T0V1lbDj1QfpHRcs1LEzWQakoDlfuBBq8DWdJiACyaxPLl3u+L/eFRRP
   E+IwkgOo22/A1V7fdYveANlswY0jNR4aWehM9IbZ1oIyf4NrbUX+RApyB
   qKSF1gJkUJSoHaYzUGpZI3zxRhfbcD1+91CU+zEkMcsjzK7pkbIMTmYN+
   JqaJNPL4s9Mxa39CWgr8JROYeeCzk+dudk6O/NSAWr6gUit1xYK80z4WC
   PGzBpz+FqbBgNpP80Md9l31Pb+3p+FZlo7UHr5Eue8cBwLxpxt6gZcteE
   kJLZCPe6Ev5aQqUDV48kfWNRUX1Xy1QHKWlUfWfBibwQE5qs4u395FIT7
   A==;
X-CSE-ConnectionGUID: E2lzjI/oTSSe5LxvUqtuUg==
X-CSE-MsgGUID: mb4rMK6pQUi4XSc4jPIhQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636837"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636837"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:30 -0800
X-CSE-ConnectionGUID: SUkCbQriQZefb+gEdDRrhg==
X-CSE-MsgGUID: 5Hew9XgFRt6Lpo4dcuDIJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192225024"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:30 -0800
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
Subject: [PATCH v14 24/32] x86/resctrl: Add energy/perf choices to rdt boot option
Date: Mon, 24 Nov 2025 10:54:01 -0800
Message-ID: <20251124185412.24155-25-tony.luck@intel.com>
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

Legacy resctrl features are enumerated by X86_FEATURE_* flags. These may be
overridden by quirks to disable features in the case of errata.  Users can
use kernel command line options to either disable a feature, or to force
enable a feature that was disabled by a quirk.

Provide similar functionality for hardware features that do not have an
X86_FEATURE_* flag.  Unlike other features that are tied to X86_FEATURE_*
flags, these are defined by the feature name.

Users may force a feature to be disabled. E.g. "rdt=!perf" will ensure that
none of the perf telemetry events are enabled.

Resctrl architecture code may disable a feature that does not provide full
functionality. Users may override that decision.  E.g. "rdt=energy" will
enable any available energy telemetry events even if they do not provide
full functionality.

An optional guid can be included for more granular control of features sharing
a name. E.g. rdt=energy:0x12345 will only override disabling of the energy
feature with guid = 0x12345.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 ++-
 arch/x86/kernel/cpu/resctrl/internal.h        |  2 +
 arch/x86/kernel/cpu/resctrl/core.c            |  2 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 37 +++++++++++++++++++
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8c5636a120ee..e47def4a3dd8 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6207,9 +6207,13 @@
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, smba, bmec, abmc, sdciae.
+			mba, smba, bmec, abmc, sdciae, energy[:guid],
+			perf[:guid].
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
+			To turn off all energy features and ensure that
+			the 0x12345 perf feature is enabled use:
+				rdt=!energy,perf:0x12345
 
 	reboot=		[KNL]
 			Format (x86 or x86_64):
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 0b7f8317be14..304e6e341905 100644
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
index 46c64419ec10..50c8b4c50790 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -57,12 +57,16 @@ struct pmt_event {
  * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
  * @feature:		Type of events, for example FEATURE_PER_RMID_PERF_TELEM or
  *			FEATURE_PER_RMID_ENERGY_TELEM, in this group.
+ * @name:		Name for this group (used by boot rdt= option)
  * @pfg:		Points to the aggregated telemetry space information
  *			returned by the intel_pmt_get_regions_by_feature()
  *			call to the INTEL_PMT_TELEMETRY driver that contains
  *			data for all telemetry regions type @feature.
  *			Valid if the system supports the event group.
  *			NULL otherwise.
+ * @force_off:		True when "rdt" command line disables this @guid.
+ * @force_on:		True when "rdt" command line overrides disable of
+ *			this @guid due to insufficient @num_rmid.
  * @guid:		Unique number per XML description file.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
@@ -71,7 +75,9 @@ struct pmt_event {
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
 	enum pmt_feature_id		feature;
+	char				*name;
 	struct pmt_feature_group	*pfg;
+	bool				force_off, force_on;
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
@@ -89,6 +95,7 @@ struct event_group {
  */
 static struct event_group energy_0x26696143 = {
 	.feature	= FEATURE_PER_RMID_ENERGY_TELEM,
+	.name		= "energy",
 	.guid		= 0x26696143,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
@@ -104,6 +111,7 @@ static struct event_group energy_0x26696143 = {
  */
 static struct event_group perf_0x26557651 = {
 	.feature	= FEATURE_PER_RMID_PERF_TELEM,
+	.name		= "perf",
 	.guid		= 0x26557651,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
@@ -128,6 +136,32 @@ static struct event_group *known_event_groups[] = {
 	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
 	     _peg++)
 
+bool intel_aet_option(bool force_off, char *tok)
+{
+	struct event_group **peg;
+	bool ret = false;
+	u32 guid = 0;
+	char *name;
+
+	name = strsep(&tok, ":");
+	if (tok && kstrtou32(tok, 16, &guid))
+		return false;
+
+	for_each_event_group(peg) {
+		if (strcmp(name, (*peg)->name))
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
@@ -178,6 +212,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 {
 	int skipped_events = 0;
 
+	if (e->force_off)
+		return false;
+
 	if (!group_has_usable_regions(e, p))
 		return false;
 
-- 
2.51.1

