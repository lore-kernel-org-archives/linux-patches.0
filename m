Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E767B356779
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941764; cv=none; b=JAuZRSYFVrOwvQGX1I+P5LfQ0yYaREwkF231vQvs0vrgjKik78WsG6iz7EQq9PoZ7AgNMYyEdyBGE/N1E/zZSFuF0QbLQ4inGUkPQrz+XJuVE1EkyFryvSCMw0MOH6FJeR3TozwVlSFdyTqOIAKvxumGaxpfDXzMT3TwrOti0ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941764; c=relaxed/simple;
	bh=xwyCxIUGNTzdLv5SV41fiYRpexFCHrDs5pa1DYFWtMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiBXfiLd4az2QzQHvXZJiwapDqgcxmTnbz2emm8oms2IG/hyiDIJ0VprXu4DuSRlqBbbDbzx3ZQ04wB7Psn0o1NEhVfggq4WC3T6/mjhvZeiWt9bbkmCvDeENTldBZaMsMNTfQKCWk9kFxFoyKQ5xrsqxFCZw1GPctymCMFP1Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jx7i6i9z; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jx7i6i9z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941763; x=1814477763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xwyCxIUGNTzdLv5SV41fiYRpexFCHrDs5pa1DYFWtMo=;
  b=jx7i6i9zCcpTBc+O38+CDvBE5f+7fyK3VCJjKx3On95cUr//uOUGNc7n
   5X3/8nKL1eihvMe/iFpCbbc/OhCJiddM5bWKhpGzJ7JakfKOMFCktsY2d
   xFjiGS1owfBoemvS2hmPn/RVyhEGHgRbqdV4AJPS1Xd1FOjzIv5tTZFeQ
   Pu+UAzWRLac7DACo6n4TbIq2GYPUNavbCwYxJPcUBpMmL+nffiax4Yz8N
   Z3E4kXKzm1HVb/9MXbmvkUGlpDr/Y9px4vzdiXCAxFzgr1dcMd/M6Euyz
   guKF+7qt2lYRut75SQyYYP/Dn87oByRo/SCkfTSXTz8bMFTc24FdpGuSB
   w==;
X-CSE-ConnectionGUID: oo5kYNPQQ9OCPWgz3WmLBg==
X-CSE-MsgGUID: hVbKfcqsSr+lbUfajtrnWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285750"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285750"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:02 -0700
X-CSE-ConnectionGUID: nidQTaqBSvamvG9DU2jD9w==
X-CSE-MsgGUID: XJqtDrPcS/WY+pcSJKvd8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242520"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:01 -0700
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
Subject: [PATCH v9 01/12] platform/x86/intel/{pmt,vsec}: Prevent unbind via sysfs
Date: Wed,  1 Jul 2026 14:35:42 -0700
Message-ID: <20260701213553.15222-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl AET code uses intel_pmt_get_regions_by_feature() (exported by the
pmt_telemetry module) to obtain pmt_feature_group instances that are populated
using data from the pmt_discovery module. The returned telemetry_region::addr
values are MMIO mappings created in the telemetry driver's probe path,
and resctrl reads from them while a mount is active.

However, a user can unbind the intel_pmt driver or its parent intel_vsec
from their devices via sysfs "unbind" attributes. Unbinding either of these
drivers would tear down the MMIO mappings, leaving resctrl with stale pointers
and causing a fault on the next access.

It is safe for the discovery driver to be unbound. It does all its work at
initial probe time and saves a copy of the features and RMID count.

Set device_driver::suppress_bind_attrs in each driver so that the "bind"
and "unbind" sysfs attributes are not exposed and the user cannot detach
the driver from its devices while resctrl (or any other in-kernel consumer)
may be using the resources.

Fixes: 1fb2daa60de6 ("x86/resctrl: Discover hardware telemetry events")
Assisted-by: Claude:Opus-4.7
Signed-off-by: Tony Luck <tony.luck@intel.com>
--
v9:
	Set .suppress_bind_attrs for intel_vsec as well as intel_telemetry
---
 drivers/platform/x86/intel/pmt/telemetry.c | 3 +++
 drivers/platform/x86/intel/vsec.c          | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index 953f35b6daec..f243ccf3185b 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -427,6 +427,9 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
 	.id_table	= pmt_telem_id_table,
 	.remove		= pmt_telem_remove,
 	.probe		= pmt_telem_probe,
+	.driver = {
+		.suppress_bind_attrs = true,
+	},
 };
 
 static int __init pmt_telem_init(void)
diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 3ae4557b32b4..50e9e122866c 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -893,6 +893,9 @@ static struct pci_driver intel_vsec_pci_driver = {
 	.id_table = intel_vsec_pci_ids,
 	.probe = intel_vsec_pci_probe,
 	.err_handler = &intel_vsec_pci_err_handlers,
+	.driver = {
+		.suppress_bind_attrs = true,
+	},
 };
 module_pci_driver(intel_vsec_pci_driver);
 
-- 
2.54.0

