Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5753D524D
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774459174; cv=none; b=rdbzBIPHcTccv8WOHc84EM0+BtNXPkfsWoz+qucknFcEH1j+PiHpQcr129z2hCZOeZrfSbCCa6BaxTyblPH1iRhCgfjx/8qZalcmql3Vwrslkyrbnias7wGaXc7/OBLLpmWAMvEnKs7wglnBVMl7NUoFQyJg/T/bGGaiZewSk2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774459174; c=relaxed/simple;
	bh=7S/qmWAAQZ0EoEp34hiHh1aj0O2tEpezcTB+e6k+xR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYY2KlJYE9YKv9rBvuDViFquVbBdexTqGptcKZyWItMurSDfk14Gh6kOETePw4PE6+pEdiLIjxeUJDLhzCzOHvE8lHOcaiPEL2dl0sQakBdtzNwe+YB/r14Hio7sAM1PHcrJs4caYwx65D6mVoW/KOaN2OrzfBeQfcCZxr4InMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P40tKvEZ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P40tKvEZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774459172; x=1805995172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7S/qmWAAQZ0EoEp34hiHh1aj0O2tEpezcTB+e6k+xR8=;
  b=P40tKvEZJti8+oK4fvmzSXFWbKWaUlUzllWIMJuOm1kxPfpSsAWlWkNp
   BO+1GkNGOIp6orjb14do6QflZTjJ/OuAQpO6XfDuCB5gLHFn9cFz+3VvL
   7sIAt6zDUA+jM2yCdvCAwEM9DxKID/zL44+9x6EoV55p8eTvlX47/pFSU
   2aYmxtYdzo8N3EaSM9JuKsqjNsLgM7s8w2aFyDFZa/x8P9tfuPxiNjxr+
   LTM452WHlDywUxuyu+9Dj/RtjdLaemzP4LTTPEHHuabwEScR4mqqRDT0O
   T9syBzl8HirR8r6gMNFdB2DPXf91CKDk/QdRGd2rD5h9WJou3LWyeIWln
   Q==;
X-CSE-ConnectionGUID: QkvNW6ACSyKBroa16Xnfrw==
X-CSE-MsgGUID: mrv+4xd2ReW8IQoI0jmqdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="75467527"
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="75467527"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 10:19:29 -0700
X-CSE-ConnectionGUID: ACO+MEg3SISv59ea+wWIkQ==
X-CSE-MsgGUID: u1hR6V/3RGaJC+Phd32O9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="224697829"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.183])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 10:19:28 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2] x86/resctrl: Allow AET to use PMT/TPMI as loadable modules
Date: Wed, 25 Mar 2026 10:17:38 -0700
Message-ID: <20260325171738.12207-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323163452.25044-1-tony.luck@intel.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl subsystem is always built into the base kernel. Currently,
enumerating Application Event Tracing (AET) features requires functions
from INTEL_PMT_TELEMETRY and INTEL_TPMI. Because resctrl makes direct calls
to these functions, it enforces a strict dependency requiring both PMT and
TPMI to be built-in.

This is overly restrictive. Use the symbol_get() mechanism to allow resctrl
to resolve these symbols at runtime, whether they reside in the base kernel
or in loadable modules.

Update the exports for intel_pmt_get_regions_by_feature() and
intel_pmt_put_feature_group() to be accessible via symbol_get(). Replace
the direct calls with indirect calls using function pointers.

Finally, adjust the Kconfig dependencies to allow X86_CPU_RESCTRL_INTEL_AET
to be enabled even when INTEL_PMT_TELEMETRY and INTEL_TPMI are configured
as modules.

Signed-off-by: Tony Luck <tony.luck@intel.com>
AI-Review-of-v1: https://sashiko.dev/#/patchset/20260323163452.25044-1-tony.luck%40intel.com
---

Sashiko reported three issues. I fixed the one real issue.

1) If the INTEL_PMT_TELEMETRY module is unloaded it will unmap the MMIO register
space and resctrl will page fault reading AET counters.

This patch fixes this issue by delaying symbol_put() calls to intel_aet_exit()
which holds module reference counts on INTEL_PMT_TELEMETRY.

2) Sashiko said that my change to Kconfig wouldn't work if INTEL_PMT_TELEMETRY
was configured as a module. It thought that Kconfig would try to force
X86_CPU_RESCTRL_INTEL_AET to be a module, which violates its "bool" definition.

By experiment, Sashiko is wrong about this. No changes for this.

3) In some deeper call analysis Sashiko pointed out that intel_aet_get_events()
is only called once on first mount. If the INTEL_PMT module isn't loaded when
that happens, AET won't be enabled and the user can't fix this by loading
the module.

By default (on Fedora) the INTEL_PMT_TELEMETRY module is loaded. So a user
could shoot themselves in the foot by unloading the module and then mounting
resctrl. But this doesn't seem worth defending against.

 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 22 +++++++++++++++++++---
 drivers/platform/x86/intel/pmt/telemetry.c |  4 ++--
 arch/x86/Kconfig                           |  2 +-
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 6fdb2cfa445a..881e3914578c 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -23,6 +23,7 @@
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
+#include <linux/module.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -380,6 +381,9 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
+static void (*put_feature)(struct pmt_feature_group *p);
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -398,16 +402,25 @@ bool intel_aet_get_events(void)
 	struct event_group **peg;
 	bool ret = false;
 
+	get_feature = symbol_get(intel_pmt_get_regions_by_feature);
+	if (!get_feature)
+		return ret;
+	put_feature = symbol_get(intel_pmt_put_feature_group);
+	if (!put_feature) {
+		symbol_put(intel_pmt_get_regions_by_feature);
+		return ret;
+	}
+
 	for_each_event_group(peg) {
 		pfid = lookup_pfid((*peg)->pfname);
-		p = intel_pmt_get_regions_by_feature(pfid);
+		p = get_feature(pfid);
 		if (IS_ERR_OR_NULL(p))
 			continue;
 		if (enable_events(*peg, p)) {
 			(*peg)->pfg = p;
 			ret = true;
 		} else {
-			intel_pmt_put_feature_group(p);
+			put_feature(p);
 		}
 	}
 
@@ -420,10 +433,13 @@ void __exit intel_aet_exit(void)
 
 	for_each_event_group(peg) {
 		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
+			put_feature((*peg)->pfg);
 			(*peg)->pfg = NULL;
 		}
 	}
+	symbol_put(intel_pmt_get_regions_by_feature);
+	symbol_put(intel_pmt_put_feature_group);
+
 }
 
 #define DATA_VALID	BIT_ULL(63)
diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index a52803bfe124..4504fb9fd83c 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -287,13 +287,13 @@ struct pmt_feature_group *intel_pmt_get_regions_by_feature(enum pmt_feature_id i
 
 	return no_free_ptr(feature_group);
 }
-EXPORT_SYMBOL(intel_pmt_get_regions_by_feature);
+EXPORT_SYMBOL_GPL(intel_pmt_get_regions_by_feature);
 
 void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
 {
 	kref_put(&feature_group->kref, pmt_feature_group_release);
 }
-EXPORT_SYMBOL(intel_pmt_put_feature_group);
+EXPORT_SYMBOL_GPL(intel_pmt_put_feature_group);
 
 int pmt_telem_read(struct telem_endpoint *ep, u32 id, u64 *data, u32 count)
 {
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..fb3e40fc1e03 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -542,7 +542,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY && INTEL_TPMI
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.53.0

