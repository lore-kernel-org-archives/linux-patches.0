Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443075;
	b=kTjQft7h3OF/bCDvyjF6DbRN1Z+XDWGQP/pwYdmSTv1BFJPOT9Wi8di+paKWXzHV3uzN
	 Ru8UTJJ0dIXwfJO4/z3Sxl8B+X8HiFmtwwYKD5qSpTmZARl42MOS2gdWo/I+cBJc5j/lZ
	 OjmS9e/9WcybaNpiFNnBGmyrtv84ZGZfixiB3nkTlydrxuhFJSZkX1VYB6jZJPTFL2TIO
	 orMmRlTSG/0l9YGmNFhgq3B54L9vBD50oT4l0shh5lEBNBKtUVmKBFIYgbd+5ABVZncCr
	 C9MuDHOu9slixyl+19RyhuW+VOG3N+w3kBhaKWePC6zJiclH3CF+pVjXeclmFuLlJNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443075;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aCS690AWyhr4RtY44shfUMTW6R8wi29+vQiNI8Fiueo=;
	b=CrIAjMTPNY/aDd9sR1yE+fJ+3k/+JQBmTIqN7aG4AMkXcVPkCIvb/PoU2jtqBBUfd293
	 c6BbXmLRnSODyikGrOMwC0XocGKAWD6tHhpVpwgRXZceTWM0SdIXJGn9FWtwIK0A4Y/Tb
	 m8ib2ns/0mWPWss/wq+3UD+f74B13MLTSADItO10l+LvN45vL46WYMdbrA4xJ/hta3g6o
	 bw6werQ6r8RCnrQ8lodAf6KU4/u3y9mVbmF/5++5sPhP6CAOVkWm3r0eLle/wp56mPpau
	 g6FrFM6ROj6VjCmjFtxq706qbO4qZCvWAIO8ReJUnpLhgtxPlulf8g/OBM14t7YEwuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GCDCzglP;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08F160A3834
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A08F160A3834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GCDCzglP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443070; x=1823979070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eRK8ux2G90gG/bhywdD3Q4ntlviEXyh8a9xQxKa+XXY=;
  b=GCDCzglP6Dp+OfaNNQcgbQtLkhtKR7EHZlvSWXZm+02uDprbHg0rlTZA
   HAuibTOn1+al6q78/L7AJYP5H8uPAIlqVEaKG7PmBRmWxMIX6eAL9De0L
   TaxAlZj4Yr1P5kXjs3CbnT5ixdd2UVzr+sXFI52qj7LT/WV2ZvGD/WMFi
   iqtGBMGtg9sdCQ8ZdbFtHegjdh3uNtMr4A4GT06GchoOrLHNpIgMvDMQ4
   CWt9HSKQkGdUWUzkz/o0KrKKxZaqPTHL033IvkXT4mOO6zfuW7CoJGSOX
   0DkOnA0QxBgmXJbuPoiKxH2TmbkRpTyTkG8aIuhbyo6sf4KmEYLOzGuYg
   A==;
X-CSE-ConnectionGUID: DU7aFLg4SOu6tIL+UJmSYg==
X-CSE-MsgGUID: m9m72mgKR72i5DD0ELyvnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131296"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131296"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:51 -0700
X-CSE-ConnectionGUID: koMSN9d8RJS1+w1LHwgj7A==
X-CSE-MsgGUID: KVE9HbSnQb2FHc6ldu2loA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008698"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:52 -0700
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
Subject: [PATCH v14 21/24] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
Date: Mon, 19 Oct 2026 13:50:28 -0700
Message-ID: <20261019205031.16977-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl obtains the virtual addresses of the telemetry MMIO regions from
intel_pmt_get_regions_by_feature() at mount time and reads event counters
from them until unmount.

When a telemetry device is unbound from the pmt_telemetry driver or
removed, the driver tears down those mappings. A subsequent read of a
telemetry event by resctrl faults on the stale address.

Before destroying the devices, tell resctrl that the mappings of the
device's package are about to be torn down and must not be used again.
Telemetry regions are organised per package, so the package ID identifies
the regions resctrl has to drop. This may be overly broad if there are
multiple telemetry devices on a package.

Notify resctrl while holding ep_lock so that the notification is ordered
against concurrent lookups of the regions. This is safe because ep_lock
is always taken before aet_lock.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	Added commit comment on lock order.
	New commit comment.
---
 drivers/platform/x86/intel/pmt/telemetry.c | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index 57eb2967a4d0..bd63653802d9 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -366,12 +366,42 @@ pmt_telem_find_and_register_endpoint(struct device *dev, u32 guid, u16 pos)
 }
 EXPORT_SYMBOL_NS_GPL(pmt_telem_find_and_register_endpoint, "INTEL_PMT_TELEMETRY");
 
+static int pmt_telem_get_package_id(struct pmt_telem_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_entries; i++) {
+		struct intel_pmt_entry *entry = &priv->entry[i];
+		struct pci_dev *pdev = to_pci_dev(entry->ep->dev);
+		struct oobmsm_plat_info *plat_info;
+
+		plat_info = intel_vsec_get_mapping(pdev);
+		if (!IS_ERR(plat_info)) {
+			/* All entries for a device have the same package ID */
+			return plat_info->package_id;
+		}
+	}
+
+	return -ENODEV;
+}
+
 static void pmt_telem_remove(struct auxiliary_device *auxdev)
 {
 	struct pmt_telem_priv *priv = auxiliary_get_drvdata(auxdev);
+	int package_id;
 	int i;
 
 	mutex_lock(&ep_lock);
+	package_id = pmt_telem_get_package_id(priv);
+	/*
+	 * Tell resctrl/AET that virtual mappings for MMIO space in a CPU
+	 * package are about to be torn down.
+	 */
+	if (package_id < 0)
+		dev_dbg(&auxdev->dev, "Unable to determine package ID for removed device\n");
+	else
+		intel_aet_invalidate(package_id);
+
 	for (i = 0; i < priv->num_entries; i++) {
 		struct intel_pmt_entry *entry = &priv->entry[i];
 
-- 
2.56.0

