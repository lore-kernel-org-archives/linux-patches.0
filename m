Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26D1329394
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881679; cv=none; b=luq199r+5ws323Nhzygmkmn/L3gHgwgYJKtUo64ymQBX92qODrYtmH0gEsQwL6StIpP1mhC5UPbRwwfkfoepKDMC5sshyB5bUuApdRehlOfI1dTn/931FWU3h42RiD8wVmtvBLa/S1+BwJNQkVcVWXTXsN9ld/eG1Pm7dob/LKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881679; c=relaxed/simple;
	bh=b0DstXJmh/PBquGnFrytjf8CQVVS81XVAER4YDpRZ6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLD5yn/6f8+DT1Jv7ulwmgRClxSVOzyVH/i0HEkKguxuAdmadZ7v84bJ5e/Ugal1O9nwAtvtYPcmHE5iHfyTKGsOC61zzRhv0MMfYTo/0flCg00JaEwm9g90zog0zNm/DhEQ6Y8B27MP/6FK7rwTgzODNISA6gGRn4jgjQqh5fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OgHpDqdE; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OgHpDqdE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881677; x=1796417677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b0DstXJmh/PBquGnFrytjf8CQVVS81XVAER4YDpRZ6M=;
  b=OgHpDqdEhoIbIMUvpe9RFw2Fl46aZ+IN/lMnUzRa0gJNWJbdd6SPkI5K
   XsbpbnVqcbp/U/FgdVtFPIG9FmCQNH6Ana6BhBinHlsHNf/iXx1kHZBSL
   JhBbKZShgcNKAKfcan5v5tbpFwVgO/INQayww6Nggg/x1ub+AvlBPr1NW
   C0CMS+L4b18xDS1yxkw/0nB3TL6R5o6QXuR2KjSlbT4O0egjxDxF3NT23
   qxUsLg7Ar47v4y8fld9jaz3yj8GzXElP8sKOXlYjSUuYv+jqDvJVpGdIe
   M7bLDd6E8zN7NBYHQZTxG8L9ibB3/21uA5WqE+XPqmoIIkA+mhJHl4zcE
   Q==;
X-CSE-ConnectionGUID: YuWH7OPpT7axhDMtg7OIAg==
X-CSE-MsgGUID: +ATNQfHkSqeGwIr74pj7wQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69511053"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69511053"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:29 -0800
X-CSE-ConnectionGUID: hmf6gR/RRPqtBzhPKCGA4w==
X-CSE-MsgGUID: QBKjAOl2QtuKwOFscCiklg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752852"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:28 -0800
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
Subject: [PATCH v15 24/32] x86/resctrl: Add energy/perf choices to rdt boot option
Date: Thu,  4 Dec 2025 12:53:54 -0800
Message-ID: <20251204205404.12763-25-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
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

Update the parse loop of the "rdt=" boot option with a call to intel_aet_option()
to handles "perf" and "energy" options. Prefixing an option with "!" force
disables a feature. A ":guid" suffix allows for fine grain control per-guid.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++-
 arch/x86/kernel/cpu/resctrl/internal.h        |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c            |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 34 +++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

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
index 8fcd72fca81f..fec4bb781f82 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -59,6 +59,10 @@ struct pmt_event {
  *			data for all telemetry regions of type @pfname.
  *			Valid if the system supports the event group,
  *			NULL otherwise.
+ * @force_off:		True when "rdt" command line disables this @guid
+ *			or architecture code disables this @guid.
+ * @force_on:		True when "rdt" command line overrides disable of
+ *			this @guid.
  * @guid:		Unique number per XML description file.
  * @mmio_size:		Number of bytes of MMIO registers for this group.
  * @num_events:		Number of events in this group.
@@ -68,6 +72,7 @@ struct event_group {
 	/* Data fields for additional structures to manage this group. */
 	const char			*pfname;
 	struct pmt_feature_group	*pfg;
+	bool				force_off, force_on;
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
@@ -122,6 +127,32 @@ static struct event_group *known_event_groups[] = {
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
@@ -173,6 +204,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int skipped_events = 0;
 
+	if (e->force_off)
+		return false;
+
 	if (!group_has_usable_regions(e, p))
 		return false;
 
-- 
2.51.1

