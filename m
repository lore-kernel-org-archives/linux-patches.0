Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F12333B94B
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992147; cv=none; b=VSjuMXXOvg6hndb0GoEBjqh9fDf4mgZQrIk3iVQG5aW8asH77vhgtzNiD45S6k7ugU0AmUdmt8BGJtm0CYKyhyScublrw3qCvq8EPkVAXRJqaPnR+YBJ/BpxUR3MyTM21FzFaA4x3A/9tCyWzgPwj6f9uAE765NGOevNFVNsfxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992147; c=relaxed/simple;
	bh=fwQpZCo6wZ6TCXL4jFzzJ4LUVZrRI1cxiMffrdGoepg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sI82Z7YbV30aaYIB7rM2UeMaFgd3VDj8R3d1Xw8bvju2sJVfW7NRK24iqo3/M9xKBK1aTnA+1iaJCrGn/9Porx/xYiyF/63aI85Fflx1y2astyd1fOtizMhDTHuiE+6ZMv1naV2W+rSbBiwsEVo6CUbdt9EjaP1PrLjPLf+yfPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gNavd7id; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gNavd7id"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992140; x=1797528140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fwQpZCo6wZ6TCXL4jFzzJ4LUVZrRI1cxiMffrdGoepg=;
  b=gNavd7idNarGGQJS12VTgjXgI4HnrGBXVIIDdZTzTUKEv8XewU9FWmcI
   kjsyqZ7/qqsCsuKaun7fD/78xSScBKwFBcOpLk9yIx0bYt1xIF5qnHK3R
   7U5SE6budeWT8aszGVW83dhV6UiaMm/viIRht6n0SXMxhfs/G+YapFeri
   0FDkuEGU9hn+nPUL0pOHrir1iDerYQs+TLGMFK4iNTACsHWFoBtybyTol
   bIYKKFZ4UoJWYiQif5Vn3X5Fr9evUsstHGSYZJderacf4tMNl9hyTWyBm
   sLI0YHS/G5XbQ+QjI8Vbad4MRIhEVtexK8WUll9pXYZS3CuJAiqD7YzyS
   Q==;
X-CSE-ConnectionGUID: EKz/ZSd4Qey0XpJu7xQmtw==
X-CSE-MsgGUID: G0HpYrIERB6pOtZPBrC96w==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594817"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594817"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:37 -0800
X-CSE-ConnectionGUID: 8FHx1ngJTE+P1n5C0SfbxA==
X-CSE-MsgGUID: 5n7QD1gsRwqcCnWfhYSL3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748248"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:35 -0800
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
Subject: [PATCH v17 24/32] x86/resctrl: Add energy/perf choices to rdt boot option
Date: Wed, 17 Dec 2025 09:21:11 -0800
Message-ID: <20251217172121.12030-25-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++-
 arch/x86/kernel/cpu/resctrl/internal.h        |  2 +
 arch/x86/kernel/cpu/resctrl/core.c            |  2 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 38 +++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a8d0afde7f85..abd77f39c783 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6325,9 +6325,14 @@ Kernel parameters
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
2.52.0

