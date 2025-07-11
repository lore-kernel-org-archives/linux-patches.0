Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6144B241661
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278050; cv=none; b=M9CJOz5dnacsh6Fg2D06oSTRN3pcWAydZmIzhUacSAyz+OkTF5oiqHjxT6HOQlYrv7eVchXaMqPGaBJlBrRPKWMGHdqvB6RIUku+SSlzF/j4rpqohVlvVRtZrgR4hZ7guifY74b+7XRkCuODk0/fc2/pHFzDQt6cS6C5ecIAFG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278050; c=relaxed/simple;
	bh=d84VgkCXBtXfc0HuHPVmzCr0+JqKDJaMuirqvTzotDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQtnIm3ZrsCd4aHf7ju/HWlA+YX3/U3bdQqGpuOqtNbOKuZhonSo/oJMj05ZSraTxrHs6KShtkXEcVFTp/L+HowQn2tvutiTYCCsCRrJ+rGizNGQ4042pNlaTcK+MtPo+EecwmDEyTdAFWp+TC3ItEDJEPGzJ4txmfu/pGis9QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WQS4Bcf+; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WQS4Bcf+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278048; x=1783814048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d84VgkCXBtXfc0HuHPVmzCr0+JqKDJaMuirqvTzotDY=;
  b=WQS4Bcf+GIKF8rcw48NZHgCEFIOWILWFZSIzL4WaW1ubxAPPRkyr4X6N
   8aq20rAayH/qmQuHW6s12jdNqZK0N+tF3wRuCeoddpyAFL+16AQmQqXE/
   H5ydyiO2vcF6nRDp0THTBg0hiyskzDpkhC6FOvdvF1br1pE/3Dau+L4I9
   lXdajGvHi71RAcvdnBDHphDDD7SWT1LEP17MtI+EIYMLJ1277Udhh+Bia
   1hQQAwXMXciXF+60fVpS6k1L3xFIDewnyyjYsw56Q6tbwNCuDHlcJSVR9
   EjjMUtj5UrNNL+g+rrBL/sDgfhplzRJ3q8hatfK+Xf4eq7oPJ0XZTxjcM
   g==;
X-CSE-ConnectionGUID: Z252Y3YARjKFDyFQcQxYaA==
X-CSE-MsgGUID: 5v7p156eSG+VlaP2jAURvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292768"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292768"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:04 -0700
X-CSE-ConnectionGUID: yee5ZQWqR1KU9SG5UNQ94Q==
X-CSE-MsgGUID: t8triOZAQ/GV3aOgb/43iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902160"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:05 -0700
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
Subject: [PATCH v7 24/31] x86/resctrl: Add energy/perf choices to rdt boot option
Date: Fri, 11 Jul 2025 16:53:31 -0700
Message-ID: <20250711235341.113933-25-tony.luck@intel.com>
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

Legacy resctrl features are enumerated by X86_FEATURE_* flags. These
may be overridden by quirks to disable features in the case of errata.

Users can use kernel command line options to either disable a feature,
or to force enable a feature that was disabled by a quirk.

Provide similar functionality for hardware features that do not have an
X86_FEATURE_* flag.

Unlike other options that are tied to X86_FEATURE_* flags, these must be
queried by name. Add rdt_is_feature_enabled() to check whether quirks
or kernel command line have disabled a feature. Just like the legacy
feature options the command line enable overrides quirk disable.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 arch/x86/kernel/cpu/resctrl/internal.h        |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c            | 30 +++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c       |  7 +++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f1f2c0874da9..4c12159f3ea0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6066,7 +6066,7 @@
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, smba, bmec.
+			mba, smba, bmec, energy, perf.
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
 
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 0081fb5a4420..83166dd0b9c8 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -169,6 +169,8 @@ void __init intel_rdt_mbm_apply_quirk(void);
 
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
+bool rdt_is_feature_enabled(char *option);
+
 #ifdef CONFIG_X86_RESCTRL_CPU_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c954171073c7..83e046313600 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -791,6 +791,8 @@ enum {
 	RDT_FLAG_MBA,
 	RDT_FLAG_SMBA,
 	RDT_FLAG_BMEC,
+	RDT_FLAG_ENERGY,
+	RDT_FLAG_PERF,
 };
 
 #define RDT_OPT(idx, n, f)	\
@@ -816,6 +818,8 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
 	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
 	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
 	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
+	RDT_OPT(RDT_FLAG_ENERGY,    "energy",	0),
+	RDT_OPT(RDT_FLAG_PERF,	    "perf",	0),
 };
 #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
 
@@ -865,6 +869,32 @@ bool rdt_cpu_has(int flag)
 	return ret;
 }
 
+/*
+ * Hardware features that do not have X86_FEATURE_* bits.
+ * There is no "hardware does not support this at all" case.
+ * Assume that the caller has already determined that
+ * support is present and just needs to check if the option has been
+ * disabled by a quirk that has not been overridden by a command
+ * line option.
+ */
+bool rdt_is_feature_enabled(char *name)
+{
+	struct rdt_options *o;
+	bool ret = true;
+
+	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
+		if (!strcmp(name, o->name)) {
+			if (o->force_off)
+				ret = false;
+			if (o->force_on)
+				ret = true;
+			break;
+		}
+	}
+
+	return ret;
+}
+
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt)
 {
 	if (!rdt_cpu_has(X86_FEATURE_BMEC))
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index bd6011a95d12..e64a4630e95c 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -49,6 +49,7 @@ struct pmt_event {
 
 /**
  * struct event_group - All information about a group of telemetry events.
+ * @name:		Name for this group (used by boot rdt= option)
  * @pfg:		Points to the aggregated telemetry space information
  *			within the OOBMSM driver that contains data for all
  *			telemetry regions.
@@ -61,6 +62,7 @@ struct pmt_event {
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
+	char				*name;
 	struct pmt_feature_group	*pfg;
 	struct list_head		list;
 	struct pkg_mmio_info		**pkginfo;
@@ -82,6 +84,7 @@ static LIST_HEAD(active_event_groups);
  * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
  */
 static struct event_group energy_0x26696143 = {
+	.name		= "energy",
 	.guid		= 0x26696143,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
@@ -96,6 +99,7 @@ static struct event_group energy_0x26696143 = {
  * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
  */
 static struct event_group perf_0x26557651 = {
+	.name		= "perf",
 	.guid		= 0x26557651,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
@@ -167,6 +171,9 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 	struct pkg_mmio_info *mmi;
 	int num_pkgs;
 
+	if (!rdt_is_feature_enabled(e->name))
+		return -EINVAL;
+
 	num_pkgs = topology_max_packages();
 
 	/* Get per-package counts of telemetry regions for this event group */
-- 
2.50.0

