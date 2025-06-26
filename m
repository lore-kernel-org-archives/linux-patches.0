Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F632F0E5E
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956611; cv=none; b=thCUx5YyFAPQz0F5gRYZQ4TV6/mAwinmWXA1oMG8R+DPVclXNDwRdW/6ucecUCfWyMVqg7gdY+i+o1yJCTluWr4FvBGmtDm9HlI106Ql+7fCU9rC+jrYTD98UeHZS/HC68cByN40wf9hUXlhxzLPuGRyj6oDOdZIRyicvPvo1/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956611; c=relaxed/simple;
	bh=eHqRIwvz9yrJBxiTor1hivziZIApiB48bbpm0qp3sr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+LF9+keX5EBM+qyGxiCn64/RGuXU8Nfu88dsEG9uP/3lyP4L8bAoR7sAoHRwfljxOCGBWMAbhz3DMlz3uWNA8WEfWIROCReDpk6Zos/eDTNu5RGGoxfvbqgYnHQ+CJOgtr21fidTzYvZqLzvgPNmxJuSRIuXwjzq087c53wChE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EEAlozBj; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EEAlozBj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956609; x=1782492609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eHqRIwvz9yrJBxiTor1hivziZIApiB48bbpm0qp3sr4=;
  b=EEAlozBjYEOLTguee6L1UYtdnvA2ZAxeHKlxA7ZYW5//LtdfKZOSxOr/
   q1ylxwVxe8z7lqLvQAchHm3P+vQ00Yrdes2GaoEF1JSuhDEct2khNHDj5
   jCLdlKTCeTRNBDCOCzrqOMJXYwK307zKTrFDwcE7wMbkqM12DyUzn2ULk
   87SriO4LKmW5FU/g5+3CJcq3RzMVFqbKP/TRJFOXysvOQXyP13dnPrLh2
   c2SPrXU0sxE4wLf35tuLExBGx03tzmcHxY/3LgCleOZU7JQpZUVcbD45h
   lJlduKXgV1frWuVnoucxTZgWDB9R2sqJqZGI4AMkMlwjjDsZcC6lBBRHA
   A==;
X-CSE-ConnectionGUID: 6H7Wsx5MS26Rup7+wzaxig==
X-CSE-MsgGUID: 8OcXttM0QGyNExtqWid0uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136511"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136511"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:02 -0700
X-CSE-ConnectionGUID: 7x4uhwhbTyCWepyoy4Zkng==
X-CSE-MsgGUID: L6aNukbNRoSDXyhUeKIaSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069306"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:01 -0700
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
Subject: [PATCH v6 24/30] x86/resctrl: Add energy/perf choices to rdt boot option
Date: Thu, 26 Jun 2025 09:49:33 -0700
Message-ID: <20250626164941.106341-25-tony.luck@intel.com>
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

Hardware backed resctrl features are enumerated by X86_FEATURE_*
flags. These may be overridden by quirks to disable features in the case
of errata.

Users can use kernel command line options to either disable a feature,
or to force enable a feature that was disabled by a quirk.

Provide similar functionality for software defined features that do not
have an X86_FEATURE_* flag.

Unlike other options that are tied to X86_FEATURE_* flags, these must be
queried by name. Add rdt_is_software_feature_enabled() to check whether
quirks or kernel command line have disabled a feature. Just like the
hardware feature options the command line enable overrides quirk disable.

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
index e8d2a754bc0c..ee1c6204722e 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -169,6 +169,8 @@ void __init intel_rdt_mbm_apply_quirk(void);
 
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
+bool rdt_is_software_feature_enabled(char *option);
+
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f857f92e7b8b..f9f3bc58290e 100644
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
+ * Software options that are not based on X86_FEATURE_* bits.
+ * There is no "h/w does not support this at all" case.
+ * Assume that the caller has already determined that s/w
+ * support is present and just needs to check if the option has been
+ * disabled by a quirk that has not been overridden * by a command
+ * line option.
+ */
+bool rdt_is_software_feature_enabled(char *name)
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
index 10fd8b04105e..1d2511984156 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -49,6 +49,7 @@ struct pmt_event {
 
 /**
  * struct event_group - All information about a group of telemetry events.
+ * @name:		Name for this group (used by boot rdt= option)
  * @pfg:		Points to the aggregated telemetry space information
  *			within the OOBMSM driver that contains data for all
  *			telemetry regions.
@@ -60,6 +61,7 @@ struct pmt_event {
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
+	char				*name;
 	struct pmt_feature_group	*pfg;
 	struct mmio_info		**pkginfo;
 
@@ -78,6 +80,7 @@ struct event_group {
  * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
  */
 static struct event_group energy_0x26696143 = {
+	.name		= "energy",
 	.guid		= 0x26696143,
 	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 	.num_events	= 2,
@@ -92,6 +95,7 @@ static struct event_group energy_0x26696143 = {
  * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
  */
 static struct event_group perf_0x26557651 = {
+	.name		= "perf",
 	.guid		= 0x26557651,
 	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 	.num_events	= 7,
@@ -157,6 +161,9 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
 	struct mmio_info *mmi;
 	int num_pkgs;
 
+	if (!rdt_is_software_feature_enabled(e->name))
+		return -EINVAL;
+
 	num_pkgs = topology_max_packages();
 
 	/* Get per-package counts of telemetry_regions for this event group */
-- 
2.49.0

