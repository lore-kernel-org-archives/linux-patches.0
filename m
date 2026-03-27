Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0AC33AD91
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652562; cv=none; b=Oc4dBLCwXNXf7kYaAsLe0IbWfhBdHkCUgDErn/BFm0kCj0d1ZkSGjVovkFXMtWiha06r6e/gET3AQarOfZI54FRBfrFN8avK5307EfWRxaFnrVaA07jrse5R9dWxjaQCp+KydalsRykNl6GdSa+yoDq2ky4knoA9eVWa6y5Nyo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652562; c=relaxed/simple;
	bh=JeiQHXv+lAk/aEcbaYPKYv6PqQufxOxQZD0OfzAcX8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWIatbJRGkT1afD1rDL7gJ47/7400ghDHp/tJVXvzZ/PyaesN/7EH8yq/3rXahWqjbWSz8OtYpuXumRDeK5p2scemu1tKcSMVYHXVJWcccb4Muu8s8V/HDDRb+8OA83qC1NOMWV9VcDOVN7m6hT4qZIEnSXpiagaMpyJHVU3goA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KHPR38MH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KHPR38MH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774652561; x=1806188561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JeiQHXv+lAk/aEcbaYPKYv6PqQufxOxQZD0OfzAcX8U=;
  b=KHPR38MHbPC81gGu3cdGM06Z4Rige6xoFzK7CLtT/hHbkaMwQoEg7EnD
   2c1ire1t1g5Z8h8+sEkHRGivTux7ACecY4b7AAqJ2eiYZGTVr0VpLdrHu
   jbQz9HH1LC88tSfvQ5BUycr5WeG5f9okMX0km+xTZZVu7cFyDQ4jB/3NQ
   BbZXsYlSziQLiLdIG/LDm78v2MjkXRltIVGLhNCqdtTmw0HhVu4d2+9/f
   gE0PjRn4kvllaY7TnMZFvYQI6+g5oH4KJ1oKVZ610QVdK5cxK/FRdBPyd
   SbgGyyyZgam7JX1ryVOH0F7ZN+U3+MRYbLkCdu5c2JaCKhBStuo1NKN7B
   A==;
X-CSE-ConnectionGUID: GAxOA4/RT76BGdttIRdLtg==
X-CSE-MsgGUID: deQLnieJT62jLQ4ydrj8vQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75613277"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75613277"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:39 -0700
X-CSE-ConnectionGUID: 7eOKjYShSAevpFLNV1i17g==
X-CSE-MsgGUID: 0AuwQNDcRWCtmazjBCh6Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218816031"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.83])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:15 -0700
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
Subject: [PATCH v3 5/7] x86/resctrl: Allow AET to use PMT/TPMI as loadable modules
Date: Fri, 27 Mar 2026 16:02:06 -0700
Message-ID: <20260327230208.18094-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327230208.18094-1-tony.luck@intel.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
 <20260327230208.18094-1-tony.luck@intel.com>
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

Use symbol_get() to obtain the addresses of intel_pmt_get_regions_by_feature()
and intel_pmt_put_feature_group() and use indirect calls using function
pointers.

Change the pre-mount hook from once-only on first mount to call the hook
every time. Add hooks for mount success/failure and unmount so that
the hold on the INTEL_PMT_TELEMETRY module is only while the resctrl
file system is mounted. Unmount now cleans up all AET structures and
disables AET events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 97 ++++++++++++++++++++++---
 1 file changed, 87 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 743a1894fe9a..2d5766904fd8 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -23,6 +23,8 @@
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -289,6 +291,9 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
+static void (*put_feature)(struct pmt_feature_group *p);
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -300,7 +305,7 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool get_events(void)
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -309,14 +314,14 @@ bool intel_aet_get_events(void)
 
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
 
@@ -325,27 +330,99 @@ bool intel_aet_get_events(void)
 
 void __exit intel_aet_exit(void)
 {
-	struct event_group **peg;
+}
 
-	for_each_event_group(peg) {
-		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
-			(*peg)->pfg = NULL;
-		}
+static bool get_pmt_references(void)
+{
+	get_feature = symbol_get(intel_pmt_get_regions_by_feature);
+	if (!get_feature)
+		return false;
+	put_feature = symbol_get(intel_pmt_put_feature_group);
+	if (!put_feature) {
+		symbol_put(intel_pmt_get_regions_by_feature);
+		get_feature = NULL;
+		return false;
+	}
+
+	return true;
+}
+
+static void put_pmt_references(void)
+{
+	if (get_feature) {
+		symbol_put(intel_pmt_get_regions_by_feature);
+		get_feature = NULL;
+	}
+	if (put_feature) {
+		symbol_put(intel_pmt_put_feature_group);
+		put_feature = NULL;
 	}
 }
 
+static DEFINE_MUTEX(pmt_lock);
+
+static enum {
+	AET_UNINITIALIZED,
+	AET_PRESENT,
+	AET_NOT_PRESENT
+} aet_state;
+
 bool intel_aet_pre_mount(void)
 {
-	return false; // Temporary stub
+	bool ret;
+
+	mutex_lock(&pmt_lock);
+
+	if (aet_state == AET_PRESENT)
+		return true;
+
+	if (aet_state == AET_NOT_PRESENT || !get_pmt_references())
+		return false;
+
+	ret = get_events();
+
+	if (ret) {
+		aet_state = AET_PRESENT;
+	} else {
+		aet_state = AET_NOT_PRESENT;
+		put_pmt_references();
+	}
+
+	return ret;
+}
+
+static void aet_cleanup(void)
+{
+	struct event_group **peg;
+
+	if (aet_state == AET_PRESENT) {
+		for_each_event_group(peg) {
+			if ((*peg)->pfg) {
+				struct event_group *e = *peg;
+
+				for (int j = 0; j < e->num_events; j++)
+					resctrl_disable_mon_event(e->evts[j].id);
+				put_feature((*peg)->pfg);
+				(*peg)->pfg = NULL;
+			}
+		}
+		put_pmt_references();
+		aet_state = AET_UNINITIALIZED;
+	}
 }
 
 void intel_aet_mount_result(int ret)
 {
+	if (ret && ret != -EBUSY)
+		aet_cleanup();
+	mutex_unlock(&pmt_lock);
 }
 
 void intel_aet_unmount(void)
 {
+	mutex_lock(&pmt_lock);
+	aet_cleanup();
+	mutex_unlock(&pmt_lock);
 }
 
 #define DATA_VALID	BIT_ULL(63)
-- 
2.53.0

