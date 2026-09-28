Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F98E503BF0
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633749; cv=none; b=N/W7KcEDpskz5j/FxJhFbVz+Gf+P85PGn2djv7ms6iMqJA0CtlNepHNey0zjJipMFhVJ/+VbdWL+7IJWj4edi83ao6srZ+ZjFs4yDzqc+oHY/fCnZI2omTbQ+F43s6EB5Il6SzIIUeUWvxiHZmtaScphZsBixVzxmdKhiRNx6GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633749; c=relaxed/simple;
	bh=DhWDUzqit36MmMWF71XQ8xF0iejy5cX8wk9OD0emNkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4d2x5o9G/dP07hwnEOdsfyW+U1VmYXYY5eOir2+z1airitwRNcbIj1L3A9L+gLQ2RAot/osSub5wGiqzwchAQAGq0htPX2DYCzGdvu3rEyDPF+wOXxBsOe9UY0K/1XT3gNa8MLV3lSa8McWZ7/98tOq259N9v6cVudx63e4YmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f6J0G4xl; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f6J0G4xl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633742; x=1822169742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DhWDUzqit36MmMWF71XQ8xF0iejy5cX8wk9OD0emNkY=;
  b=f6J0G4xlHGzPFRcnDMAUhcOyn2AuAxrGHgKdvx0Y3vTYH3OrJIF9853x
   w/xhIiE+rGClnVnVVK2BCzL6fXrGkArXLc5hq4ESn/KUBFwlJze61JePn
   2e67OzXgvMUEy5xgJ+cEvPasHzgw/vlPfX9w9oSnt+2exsj9ZywticDZm
   AjRaxbPjkUiEftccRRQU5Ft6s3jG94Todi5ssJXCjhfDqDWq04GNUBATl
   8GaLH8+V0FLK0L3T7VDqyeJAVK9U5gIIFJ03NdcGma8zljERJLhYFe/jx
   dSx1wMJoQ0n3ojM4WGYteOT1LAe017BPE9fgH7iljOzidq4dXSn56iP+f
   g==;
X-CSE-ConnectionGUID: Cq9iCBfJRnWIWhabRw8gOw==
X-CSE-MsgGUID: BrxaqnxeS66y5fk4k5YnuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387316"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387316"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:20 -0700
X-CSE-ConnectionGUID: xpfvfn9FSUK2jvkFJHJBow==
X-CSE-MsgGUID: 2h3JWHg/Sl+87zedjjGFwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685521"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:19 -0700
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
Subject: [PATCH v13 17/25] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Mon, 28 Sep 2026 15:15:01 -0700
Message-ID: <20260928221509.68002-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl exports register/unregister functions that the pmt_telemetry
driver should use to allow resctrl to call the Application Energy
Telemetry (AET) enumeration functions when this driver is configured
as a module.

By default module probe functions are called asynchronously. Change the
probe type to request synchronous execution to ensure that all probes
are complete before supplying the enumeration function to resctrl.

Unregister enumeration before beginning tear down of auxiliary devices
so that resctrl cannot attempt enumeration in parallel with unload of
the pmt_telemetry module.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Dropped empty line in pmt_telem_init()
	Rewrote commit message with accurate context.
---
 drivers/platform/x86/intel/pmt/telemetry.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index 953f35b6daec..57eb2967a4d0 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -427,16 +427,29 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
 	.id_table	= pmt_telem_id_table,
 	.remove		= pmt_telem_remove,
 	.probe		= pmt_telem_probe,
+	.driver		= {
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
+	},
 };
 
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
+
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
2.55.0

