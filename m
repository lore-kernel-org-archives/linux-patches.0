Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCF53BED75
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283704; cv=none; b=ad8aQ/ci6fpPFEVmkpq+IkO5mSynOEg9Asfas2lo+2K3hBAI9H+t11fVLR7/K+s+ZGbgcgqomU0S/rRc8XjBg2h0xBZiV7aHnm2WhqjWPscSRAAzTf5fXm5U+CqpugBMUM0gL0LbDTeYE8owZBEIc3oDlYmw61YGaS+Iu8R2bKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283704; c=relaxed/simple;
	bh=g+SqY4bqFRaZ09OLJYU/pBmrMrQqRKHUQOq8/+lqPaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sAPW1NJme16VEpMd22ErY8YMD+DNEXoJ/79ehBZGqOVu17OeNF7OK2HE6k5nN+sc0PfPxwuIStDiWchM/BclzxuI17tjYRMIoDY7kvLia9x21q08M8Re+O9lNoRSJ4Axa59oCjnp90b7LCArZMp7nJlQG6Rzu3pLAWrFgybgp+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fuYS9kp9; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fuYS9kp9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774283702; x=1805819702;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=g+SqY4bqFRaZ09OLJYU/pBmrMrQqRKHUQOq8/+lqPaY=;
  b=fuYS9kp9nvvBSTqJVq4vs26PNhePeCOQBXW4BfguC7SKtujAA8ZtHaf9
   T9z8Aik89DaaVb6u5Of2o1UeTyRriGV2fvrkVzmPNpwEZvfhwAjDerchP
   8PpZ+ftEMnEWXubpHR+TO4i5jY/fdSfa7ehLG5yQcwz8wtgh2ohap3YeT
   LXWfAy+naU9aBOC2y7TcI4L7sDHhe1CGbR+XZNcqfuQy3H218QLE+6WcZ
   yBDB9UI6G/PWiuvJZtZ+POVTa0dCr6xCp6Qss7ekIwXlPbeiqdKVk10G0
   7+NufJ+BlLjWqC4+ZtkHKPoT9l5dk7ReVASqChrvWhZ0cCUZZ3oY3C4hn
   Q==;
X-CSE-ConnectionGUID: 95+XOT3zQfSCRk9ziavC6Q==
X-CSE-MsgGUID: JXElSjo0TGunWE1yxPfg7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="62844987"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="62844987"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 09:35:01 -0700
X-CSE-ConnectionGUID: RoaPs219TGGIB2RFYVItoA==
X-CSE-MsgGUID: R4JtCDRGTv24LtJopLKn7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="229003565"
Received: from jjgreens-desk21.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.35])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 09:35:01 -0700
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
Subject: [PATCH] x86/resctrl: Allow AET to use PMT/TPMI as loadable modules
Date: Mon, 23 Mar 2026 09:34:51 -0700
Message-ID: <20260323163452.25044-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
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
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 27 +++++++++++++++++++---
 drivers/platform/x86/intel/pmt/telemetry.c |  4 ++--
 arch/x86/Kconfig                           |  2 +-
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 89b8b619d5d5..b2a47774157f 100644
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
@@ -304,37 +305,57 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
  */
 bool intel_aet_get_events(void)
 {
+	struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
+	void (*put_feature)(struct pmt_feature_group *p);
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
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
 
+	symbol_put(intel_pmt_get_regions_by_feature);
+	symbol_put(intel_pmt_put_feature_group);
+
 	return ret;
 }
 
 void __exit intel_aet_exit(void)
 {
+	void (*put_feature)(struct pmt_feature_group *p);
 	struct event_group **peg;
 
+	put_feature = symbol_get(intel_pmt_put_feature_group);
+	if (!put_feature)
+		return;
+
 	for_each_event_group(peg) {
 		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
+			put_feature((*peg)->pfg);
 			(*peg)->pfg = NULL;
 		}
 	}
+	symbol_put(intel_pmt_put_feature_group);
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

