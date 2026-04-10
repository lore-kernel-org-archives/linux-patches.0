Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559B93939A3
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 20:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851544; cv=none; b=bpg13ML6Kv8wEw6tPvv4DDX/DTdkd5XrHKfBK0bJ/pgoA+Cbe2+FVj8vKQSoD27HjFjnzA7ESjEUBPLgF9T0G1FX/D4kaM3hxZY84M/7sKJ1d4muAINNhe3O3N2uT0GpYWCaLPxWlMwgK5MuPCfEapmpJyoU1lrpDpgIj40TTz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851544; c=relaxed/simple;
	bh=iV4S5j2BrthBeOJkRN+K1btg+O2lMEcy08RQXWT+Hj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8gKMpFOzNdQrxgAUYfakZbHg8pdTgA2UcY6J//6U8hTqu4QQJLTo2RAgirBXA6tJcspt7CPHIkupgLo8v/xrQ1ot0QSArjU07/W3pQvFXrvBJYXp12vAt3HGERnnPoR6qGb1ZGp5QUFlMaqqKhbwA0xJRiEHfdPy4BjS2yC58s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hY/WwZcZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hY/WwZcZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775851544; x=1807387544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iV4S5j2BrthBeOJkRN+K1btg+O2lMEcy08RQXWT+Hj0=;
  b=hY/WwZcZzcOVEOwznkU8yhYeq9kXuMU68hBMCBPUDjIW2X0V7KFOBVy5
   I7eWxt84iyEKCH97lCvamLyiuTXeqh4Zy0gXLIU7M1AbscY0kxlWd/fm9
   VXSV34FXWG50XSaosxo2tAYsRVBY4pffR+Geesfm9Li2KAnpQ5d2eqV9y
   SJNgEH+y9M7LThJge+gRkhxxvIg4oTrrv0LfbejM3XzCpzCnmbRTYFt/C
   KyaxmuQSWSrvVWv3Ilm4+K7V67wQyKWQSj3PsoqBHsgBlv7crBZ0pt8Oy
   /o2jBCGrWe/NID4Z44algKxf1FnTdgG3dLFpy+EiW3vrq2hOs6gbltEON
   g==;
X-CSE-ConnectionGUID: lPlCZM4OTX6wtPeaaDnaOg==
X-CSE-MsgGUID: 01S9+mjzTBWL0F7mSJKoPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76898089"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76898089"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:41 -0700
X-CSE-ConnectionGUID: ibWS4kWOSPiuRpWr1/m+vQ==
X-CSE-MsgGUID: z3Dcjo0sRvK8lFRSOni/Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="228155017"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:40 -0700
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
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH v5 4/7] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Fri, 10 Apr 2026 13:05:29 -0700
Message-ID: <20260410200532.58602-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410200532.58602-1-tony.luck@intel.com>
References: <20260410200532.58602-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
call PMT functions directly.  Register the telemetry enumeration function
pointers at resctrl module init, and unregister them at module exit.

Add module_{get,put} calls to the PMT get/put functions to ensure that
INTEL_PMT_TELEMETRY cannot be unloaded while resctrl is mounted and
referencing the MMIO register space mapped by INTEL_PMT_TELEMETRY.

Note that checkpatch complains about the #include of <asm/resctrl.h>.
This is needed rather than <linux/resctrl.h> to get the function stub
definitions when CONFIG_X86_CPU_RESCTRL=n.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/pmt/telemetry.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index a52803bfe124..e76927cabc97 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -25,6 +25,8 @@
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
 
+#include <asm/resctrl.h>
+
 #include "class.h"
 
 #define TELEM_SIZE_OFFSET	0x0
@@ -283,6 +285,9 @@ struct pmt_feature_group *intel_pmt_get_regions_by_feature(enum pmt_feature_id i
 		region++;
 	}
 
+	if (!try_module_get(THIS_MODULE))
+		return ERR_PTR(-EINVAL);
+
 	kref_init(&feature_group->kref);
 
 	return no_free_ptr(feature_group);
@@ -292,6 +297,7 @@ EXPORT_SYMBOL(intel_pmt_get_regions_by_feature);
 void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
 {
 	kref_put(&feature_group->kref, pmt_feature_group_release);
+	module_put(THIS_MODULE);
 }
 EXPORT_SYMBOL(intel_pmt_put_feature_group);
 
@@ -404,6 +410,9 @@ static int pmt_telem_probe(struct auxiliary_device *auxdev, const struct auxilia
 		intel_pmt_get_features(entry);
 	}
 
+	intel_aet_register_enumeration(intel_pmt_get_regions_by_feature,
+				       intel_pmt_put_feature_group);
+
 	return 0;
 abort_probe:
 	pmt_telem_remove(auxdev);
@@ -432,6 +441,7 @@ static void __exit pmt_telem_exit(void)
 {
 	auxiliary_driver_unregister(&pmt_telem_aux_driver);
 	xa_destroy(&telem_array);
+	intel_aet_unregister_enumeration();
 }
 module_exit(pmt_telem_exit);
 
-- 
2.53.0

