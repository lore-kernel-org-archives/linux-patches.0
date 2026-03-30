Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E593A4F25
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907016; cv=none; b=cdabPQI6KCUUjYp4ldegm70EwNkeY+s6mnD3LofctqedvepmeF8R3bm1izFeR2LtOmYMIEb/OxxGZ63wTbWi+iU1aaMujj/fEquUU5wZFJh/dmDutjFKiSW/eR8jZS/LwOjXprjJVkxtI27dEcp0NEAhYWHbdNHaKYOrHacfRDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907016; c=relaxed/simple;
	bh=csRUE11ocLzItOsYrwL4+mhKQY6L45tfuJmxgVxembA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeytjoslYMvlmN6GFlLzhTtxEJ5mRVre5SHOLE5dQ1EkxRNIzuOVSLaLTY4nu94sTrxiuo3qVo58ZqaGezB94S6UBd9TQ1Djx65wH75qahzc6c0TZBOdq6C/MRIxePnIf5V3MV02k14Rcq3RQYmwysCXOy/61sC47ADKkNlBqKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E/2VC0VV; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E/2VC0VV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774907015; x=1806443015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=csRUE11ocLzItOsYrwL4+mhKQY6L45tfuJmxgVxembA=;
  b=E/2VC0VVF3+9v1m5zCW6gMyYMZfALJu+oqJc8SX4R4nmXZEZx3ltRa8Z
   pq1e1N6Sj3jLLbhsd359kHAIxzZamsjJ2KO7mVbJH1hPWvkdv0j6CxkWz
   /FfVG6lFBCQTUnKEGZHfDSoJVyMeTzysuomvwYu7LR/XQlRnrosqxv1XQ
   O0pGS8uSES7ITnTBB1i1aSmKg+fxgXIvhzza15XfSrocIBhXtXVmgCPM1
   LHnpAYKeQPpKbyLf3vqCNihox4ZTqSiAvHBUUKIefHoHSh7JvTrg1XnEf
   aaUvg+9n1YBUc7oXI210aowPQjqEN8jldBFTGq+waCzu/zYwwqlaLezLf
   A==;
X-CSE-ConnectionGUID: 0esBN3zjQ92kDN4yd1ZA3A==
X-CSE-MsgGUID: F8WBQx7rQ0+o4gE8YmqNMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79772163"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79772163"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:34 -0700
X-CSE-ConnectionGUID: LD3UUsamSYeV2fttorrRdQ==
X-CSE-MsgGUID: d6lmtt29QBqNb7sCQRidYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225185948"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:33 -0700
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
Subject: [PATCH v4 5/7] x86/resctrl: Resolve PMT and TPMI symbols at runtime
Date: Mon, 30 Mar 2026 14:43:20 -0700
Message-ID: <20260330214322.96686-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330214322.96686-1-tony.luck@intel.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl subsystem is always built-in. Currently, it has a direct
dependency on INTEL_PMT_TELEMETRY and INTEL_TPMI for Application Event
Telemetry (AET) features. This forces these drivers to be built-in as well,
even though they are logically separate.

Switch to using symbol_request() to resolve AET-related symbols at
runtime. This allows PMT and TPMI to be built as loadable modules.

Update the mount/unmount logic to manage these references:
- Acquire symbol references and pin the modules during resctrl mount.
- Ensure AET structures are cleaned up and events disabled on unmount.
- Release symbol references and unpin modules on unmount or if
  mounting fails.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 93 ++++++++++++++++++++++---
 1 file changed, 83 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 743a1894fe9a..14b472106f52 100644
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
@@ -289,6 +290,9 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
+static void (*put_feature)(struct pmt_feature_group *p);
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -300,7 +304,7 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool aet_get_events(void)
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -309,14 +313,14 @@ bool intel_aet_get_events(void)
 
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
 
@@ -325,27 +329,96 @@ bool intel_aet_get_events(void)
 
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
+	get_feature = symbol_request(intel_pmt_get_regions_by_feature);
+	if (!get_feature)
+		return false;
+	put_feature = symbol_request(intel_pmt_put_feature_group);
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
+	if (aet_state == AET_PRESENT)
+		return true;
+
+	if (aet_state == AET_NOT_PRESENT || !get_pmt_references())
+		return false;
+
+	ret = aet_get_events();
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
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+
+	if (ret) {
+		r->mon_capable = false;
+		aet_cleanup();
+	}
 }
 
 void intel_aet_unmount(void)
 {
+	aet_cleanup();
 }
 
 #define DATA_VALID	BIT_ULL(63)
-- 
2.53.0

