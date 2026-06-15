Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10514318B83
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547913; cv=none; b=Rt1CWNB8JDhVqEsIGmxaEczaSiXbPbDTyTLyQ/DZFbkELHZhGTCPZ/3Hue/2YdLjrN5U3upn3WfsSpE/88W8s92cQRBvVsot4NJm2NARRFsyJPLyZLYrLjB96RGA4b5CdjlCld/lVvqaiVmUlLVpJQTBQT84BLhiIE8YGH1zwYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547913; c=relaxed/simple;
	bh=0iKcIZsqX45bD5N+at4BI0K+0YFsdRGRBhddBITR9bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dkp0s8y7T7PtJmP7r6hBFajJ/3Ag5XxivNYi5l/OICyVj5TWkB2Dc8q3vSpznz4X3vizAc8DyqplMcgJxhAk9Zg4APrgpdnnFdUaJ+VxzP/CABOq2+UE6oucsGikxsRw2IjsEhpFmd+eweceLwHNSq53STg+3mNswSAYBsy3n5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D59bdVo0; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D59bdVo0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547912; x=1813083912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0iKcIZsqX45bD5N+at4BI0K+0YFsdRGRBhddBITR9bM=;
  b=D59bdVo0BlWRfV8ffk6zpYxkraiMRRviJkA56JylrZkpwNz6sBIue6gb
   z6cL0wsE2zb/V8KWrfTrNntxe7qy895Di7FeIU2OpimmmMOQ7yBuaJLCz
   ACpHFOJFYbd+egyKhOKDaNJQyKV3vNtFkava6t0ICPu/qzUBM7trUlT1K
   UNWYwUjEaNt1F9CiRKJzgNbu4mGhuruc2XrdXK8YePZQKEOYmQr+k2ekL
   OsjIDtEjey/QqhY/t93b3jP7T2esfCrjOZ9zA7CBVkMCTDid1mncIMvly
   z7MayvMgIwTqcpdSc3F0UVUmM9iW7F57uLOfThI7zj27+FSmzu1g8VJYI
   Q==;
X-CSE-ConnectionGUID: zgUEc504SnGPlbLsRYKICQ==
X-CSE-MsgGUID: UblkQfyyTXatCF1HUV9OYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789958"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789958"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:08 -0700
X-CSE-ConnectionGUID: PJAP5uxIRBCBVnijK3BMRw==
X-CSE-MsgGUID: ehw1ztdFRZeM5dMTtITsiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620619"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:07 -0700
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
Subject: [PATCH v8 05/16] platform/x86/intel/pmt: Prevent unbind of PMT telemetry driver
Date: Mon, 15 Jun 2026 11:24:46 -0700
Message-ID: <20260615182457.14725-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl AET code uses intel_pmt_get_regions_by_feature() (exported
by the pmt_telemetry module) to obtain pmt_feature_group instances that
are populated using data from the pmt_discovery module. The returned
telemetry_region::addr values are MMIO mappings created in the
telemetry driver's probe path, and resctrl reads from them while a
mount is active.

However, a user can unbind the auxiliary driver from its device
via the sysfs "unbind" attribute. Unbinding the telemetry driver would
tear down the MMIO mappings, leaving resctrl with stale pointers and
causing a fault on the next access.

It is safe for the discovery driver to be unbound. It does all its work
at initial probe time and saves a copy of the features and RMID count.

Set device_driver::suppress_bind_attrs in the telemetry driver so
that the "bind" and "unbind" sysfs attributes are not exposed and the
user cannot detach the driver from its devices while resctrl (or
any other in-kernel consumer) may be using the resources.

Fixes: 1fb2daa60de6 ("x86/resctrl: Discover hardware telemetry events")
Assisted-by: Claude:Opus-4.7
Signed-off-by: Tony Luck <tony.luck@intel.com>
--
v8:
	New patch
---
 drivers/platform/x86/intel/pmt/telemetry.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index bdc7c24a3678..daa6da9bad2a 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -421,6 +421,9 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
 	.id_table	= pmt_telem_id_table,
 	.remove		= pmt_telem_remove,
 	.probe		= pmt_telem_probe,
+	.driver = {
+		.suppress_bind_attrs = true,
+	},
 };
 
 static int __init pmt_telem_init(void)
-- 
2.54.0

