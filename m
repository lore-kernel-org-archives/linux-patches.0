Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2118137205D
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343815; cv=none; b=PKJKnuRuAJzSAlbP3A2+o1FI8iucH0W8jNItSZSGC8vmlmY+l+/tMoLJA8TyW+Wnvzzx2MejqrMJD4Rb6OE8izxsIDIAiv1qLKqOaHjIbbvZ2whUL0LLxmwIbYQWUBNV5d7Rcj+NWhpoJDevaH9rA1sT1XSgHJ/wfhoFHCf47mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343815; c=relaxed/simple;
	bh=+hfZeCBGK1YwjNIsH0I9wSKydbOTanbZiJHodPfMrkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaoIK5kmm+y5n1ItZC356Rd2Ky/IRq7ikZu8U34MuykUr8n4+fC/PHyIzEc+0UWZL/++k0Ca5oOPqCR7T5nseAPEjnGtkNvo9gpOu1O5Ab/Q5+lPB96hCp74Llh9td/AWd/8iaiddPOzZ6r63LXATEfyL2qibndFSkwVnTYPxIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SCaDguZe; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SCaDguZe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343815; x=1811879815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+hfZeCBGK1YwjNIsH0I9wSKydbOTanbZiJHodPfMrkc=;
  b=SCaDguZe13av519SLKoU2gfQsMkcRL/EBZZ+gJ1vJMuY1SpGJh2KPo6O
   0eXyI1FqASzXDxqDnziBEMbbTy3QXdGXYgEtGQw/3bdWaLQSRO2VM83Z+
   Q65B56POoMSyfoE3LOfibf3nPhZvFBwitIa12kKb+ztSQDH19R3N4BwcN
   RmhSgwskqBemjRdHCgf6g4sURVqPfWJSDpDfIacfXjzJLgaQleFhXSiHS
   hRUimLLIkwNBeOagSj8GovU5ny2xv00CkPUonGP9G+sdOQZNmjRWynbrW
   UfNx1CHI+eFtCZnmuLpWcFTs4xPOLNxRXWoJp8+/QvY5cR1h+LJJIdle1
   g==;
X-CSE-ConnectionGUID: MroA9L80SPiA7AucZ8rR3A==
X-CSE-MsgGUID: WdhU9lMtQjWVIR6045Egsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011643"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011643"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:44 -0700
X-CSE-ConnectionGUID: Q46sFpuZRBeubJKzHKgEuQ==
X-CSE-MsgGUID: ztUamcPOT8yXZyIJRSuQ3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946523"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:43 -0700
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
Subject: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Mon,  1 Jun 2026 12:56:28 -0700
Message-ID: <20260601195632.15876-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601195632.15876-1-tony.luck@intel.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
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

Note that checkpatch complains about the #include of <asm/resctrl.h>.
This is needed rather than <linux/resctrl.h> to get the function stub
definitions when CONFIG_X86_CPU_RESCTRL=n.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/pmt/telemetry.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index bdc7c24a3678..33c1f8e7022f 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -25,6 +25,8 @@
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
 
+#include <asm/resctrl.h>
+
 #include "class.h"
 
 #define TELEM_SIZE_OFFSET	0x0
@@ -425,12 +427,21 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
 
 static int __init pmt_telem_init(void)
 {
-	return auxiliary_driver_register(&pmt_telem_aux_driver);
+	int ret;
+
+	ret = auxiliary_driver_register(&pmt_telem_aux_driver);
+	if (ret)
+		return ret;
+
+	intel_aet_register_enumeration(THIS_MODULE, intel_pmt_get_regions_by_feature,
+				       intel_pmt_put_feature_group);
+	return 0;
 }
 module_init(pmt_telem_init);
 
 static void __exit pmt_telem_exit(void)
 {
+	intel_aet_unregister_enumeration();
 	auxiliary_driver_unregister(&pmt_telem_aux_driver);
 	xa_destroy(&telem_array);
 }
-- 
2.54.0

