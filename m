Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE44413259
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 18:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488561; cv=none; b=VPz1BDu/bcwvMa8Lg9x1+2QQaDLuscFqaCkTNWhzo956k5MdMn9Vcp/1CQtG+sqoFochjxMlCE3H6xc+ujdpMgbyiQslOjIGqxRGdKFHVE1FMEODdos0ZCZ288bwPpCcvCgq5xCAXq/lJwvdyivVWVcjRLw85aOF92yFv/l1BYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488561; c=relaxed/simple;
	bh=R5ipzQsFGiwFF2x8vYufOfcDSE3QnQ50EK420XzTosg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOKocKD8n1GbQeQSLFVKyk7F2IWobBCz3Dkf6EEOqnZkwsHuy2GBdwb4yzb4a65lRecw1RX9m2cuPFdk98rBoTScvyNP7zZhg1BTJIvp0gwIPrp1T96EpGugKDgm5inWmipbBP/uTbYm48tC5D0MUNKEtZXp8XIa0bA4jcxeo4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JcQW/vhS; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JcQW/vhS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777488559; x=1809024559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R5ipzQsFGiwFF2x8vYufOfcDSE3QnQ50EK420XzTosg=;
  b=JcQW/vhSncMR9eBfqq+NCLbaP4r6TR7aSrqZPJEcezNSE3MsW5TzxL5W
   V+BqYvIH10+ife86zWg7woE0Q4SBpI0qXm4cqMJjD2DKgC3uzel3Bsg5x
   BRrSl8kJH6v6kT/bpdiY/Lgv/lsgmNgw97JUB9RCnKaXLJSPCm9dD7NBh
   BmHL8GEhsTMLbk14WTaugmDWMg0800NbPLuyqgxh+yg6wQp/tPt9c9O9Z
   1bZ1dw+6+ZgPFKT2ldcB/On4GgUvUJNrWjBySg3d52pjEVLUUtEpA3gfq
   79s6mYSNLlsFJ+9p2/hIJAJPz05BAmSwvwX0Z6D/1LLQJiBRUKIFPBe9X
   g==;
X-CSE-ConnectionGUID: WeGy5PC6SYGROFR+4tEWYw==
X-CSE-MsgGUID: xLf4R9e0RiuhdUoSyCLtTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89890733"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89890733"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:08 -0700
X-CSE-ConnectionGUID: YqhGi1EFSM+O7dun9m0YEw==
X-CSE-MsgGUID: KTlQ7q1xQ8Ks5RLKnmijLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="238323022"
Received: from mjruhl-desk.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.13])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:08 -0700
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
Subject: [PATCH v6 06/10] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Wed, 29 Apr 2026 11:48:54 -0700
Message-ID: <20260429184858.36423-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429184858.36423-1-tony.luck@intel.com>
References: <20260429184858.36423-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
call PMT functions directly.  Register the telemetry enumeration function
pointers at pmt_telemetry module init, and unregister them at module exit.

Add module_{get,put} calls to the PMT get/put functions to ensure that
INTEL_PMT_TELEMETRY cannot be unloaded while resctrl is mounted and
referencing the MMIO register space mapped by INTEL_PMT_TELEMETRY.

Note that checkpatch complains about the #include of <asm/resctrl.h>.
This is needed rather than <linux/resctrl.h> to get the function stub
definitions when CONFIG_X86_CPU_RESCTRL=n.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/pmt/telemetry.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index bdc7c24a3678..0088027c1b15 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -25,6 +25,8 @@
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
 
+#include <asm/resctrl.h>
+
 #include "class.h"
 
 #define TELEM_SIZE_OFFSET	0x0
@@ -284,6 +286,9 @@ struct pmt_feature_group *intel_pmt_get_regions_by_feature(enum pmt_feature_id i
 		region++;
 	}
 
+	if (!try_module_get(THIS_MODULE))
+		return ERR_PTR(-EINVAL);
+
 	kref_init(&feature_group->kref);
 
 	return no_free_ptr(feature_group);
@@ -293,6 +298,7 @@ EXPORT_SYMBOL(intel_pmt_get_regions_by_feature);
 void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
 {
 	kref_put(&feature_group->kref, pmt_feature_group_release);
+	module_put(THIS_MODULE);
 }
 EXPORT_SYMBOL(intel_pmt_put_feature_group);
 
@@ -425,7 +431,15 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
 
 static int __init pmt_telem_init(void)
 {
-	return auxiliary_driver_register(&pmt_telem_aux_driver);
+	int ret;
+
+	ret = auxiliary_driver_register(&pmt_telem_aux_driver);
+	if (ret)
+		return ret;
+
+	intel_aet_register_enumeration(intel_pmt_get_regions_by_feature,
+				       intel_pmt_put_feature_group);
+	return 0;
 }
 module_init(pmt_telem_init);
 
@@ -433,6 +447,7 @@ static void __exit pmt_telem_exit(void)
 {
 	auxiliary_driver_unregister(&pmt_telem_aux_driver);
 	xa_destroy(&telem_array);
+	intel_aet_unregister_enumeration();
 }
 module_exit(pmt_telem_exit);
 
-- 
2.53.0

