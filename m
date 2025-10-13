Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC9E30DEAC
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394856; cv=none; b=Ae4dWCIrdwoJIEcfj9WvNaekr3v5pW+VPeU4N+PLdUEygxTJbygotNLqCYs49x80O4KK501H+Wd3ciZesrqfI2BxXrX+gGfP0PXJROKPaB6oibObJsb1rpjiE7Ruw1Gz7oA8UeHjniavx4kZeWWVLvm68hSM3JG89O5qobhG/SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394856; c=relaxed/simple;
	bh=A0xpIAFNXiudoU6zMfneZZyG8i4phbCa2TqXAtfSSMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3z+ppMpB/6xBRCUFAnASsHdumnMntJNXDtpFTPbJqVtEW9jRd39kwkDVbnV7jaMUDpb4phBW/Q5JZC/LnUDC3BKzU3GOxLz0BDCDgPM7jUqVZRpD+B0ohAHIgwMfJK6qh7x8Wxy9jCKyNhBgtKkP2/3WEBliIXXwgcuofqDIHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IVhZN0re; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IVhZN0re"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394854; x=1791930854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A0xpIAFNXiudoU6zMfneZZyG8i4phbCa2TqXAtfSSMo=;
  b=IVhZN0reNzSHXd3rP48mvyyjCN1LgJFsYvcHAhhLxQzUEbe6Aoju7f+1
   uTTab4MI0XBT20U5zDLi7wGgiU5wg0DbKZf5tKUdMjQ9yGkiA08gX0Jhv
   nuFKzC46f9ivpEnbdkQI9YWyp/Q03AieWL6UmOdKD78gRepBTHX7htdfZ
   PFc1iOA3DehQKsRbxFFWuprklUSMEqaftRDc+bDeUYKv2zRjxqDMzwVKz
   zS1OeAmciSYhywdPbuePlB5HnzKiUHDJLfIO2BRSZHtMXTaFetSxvjJB9
   z5uTpuAcu8B+XKTWMUpJtLoA/HOE56XbSfVZ42S7cw00wCLLZToKchZF/
   A==;
X-CSE-ConnectionGUID: Oe0zjqXaQXeGMKq47jdU0w==
X-CSE-MsgGUID: ZMNYiI71SIugpoM5hraIyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168914"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168914"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:03 -0700
X-CSE-ConnectionGUID: UVKu5CDmTFOqXJZbnQmNEw==
X-CSE-MsgGUID: 344k9HAVSi6BOanix+eeHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145323"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:03 -0700
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
Subject: [PATCH v12 23/31] x86/resctrl: Add energy/perf choices to rdt boot option
Date: Mon, 13 Oct 2025 15:33:37 -0700
Message-ID: <20251013223348.103390-24-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
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
X86_FEATURE_* flag.  Unlike other features that are tied to X86_FEATURE_*
flags, these must be queried by name. Add rdt_is_feature_enabled()
to check whether quirks or kernel command line have disabled a feature.

Users may force a feature to be disabled. E.g. "rdt=!perf" will ensure
that none of the perf telemetry events are enabled.

Resctrl architecture code may disable a feature that does not provide
full functionality. Users may override that decision.  E.g. "rdt=energy"
will enable any available energy telemetry events even if they do not
provide full functionality.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 arch/x86/kernel/cpu/resctrl/internal.h        |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c            | 29 +++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..bb8f5d73ebf8 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6207,7 +6207,7 @@
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, smba, bmec, abmc.
+			mba, smba, bmec, abmc, energy, perf.
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
 
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index b920f54f8736..e3710b9f993e 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -225,6 +225,8 @@ void __init intel_rdt_mbm_apply_quirk(void);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
+bool rdt_is_feature_enabled(char *name);
+
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7d15112c5868..9d14ebde9d89 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -772,6 +772,8 @@ enum {
 	RDT_FLAG_SMBA,
 	RDT_FLAG_BMEC,
 	RDT_FLAG_ABMC,
+	RDT_FLAG_ENERGY,
+	RDT_FLAG_PERF,
 };
 
 #define RDT_OPT(idx, n, f)	\
@@ -798,6 +800,8 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
 	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
 	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
 	RDT_OPT(RDT_FLAG_ABMC,	    "abmc",	X86_FEATURE_ABMC),
+	RDT_OPT(RDT_FLAG_ENERGY,    "energy",	0),
+	RDT_OPT(RDT_FLAG_PERF,	    "perf",	0),
 };
 #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
 
@@ -847,6 +851,31 @@ bool rdt_cpu_has(int flag)
 	return ret;
 }
 
+/*
+ * Hardware features that do not have X86_FEATURE_* bits. There is no
+ * "hardware does not support this at all" case. Assume that the caller
+ * has already determined that hardware support is present and just needs
+ * to check if the feature has been disabled by a quirk that has not been
+ * overridden by a command line option.
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
-- 
2.51.0

