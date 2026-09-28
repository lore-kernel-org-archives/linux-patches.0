Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4AF509EE9
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633756; cv=none; b=P82YbqK0XP8JcjVBomv86pGvtFTIb4Yx11pg+tkdC39BdxHP7eCDQXjyl6Dt2Qj8QGEqfqjA+lIiiz9CjRP+l2vfjDokVjxiEyahELdlVdxglO5oKE3YUMYnPV+rrfX8hsgp7qHftO7QiOFggydd151qtf7qOzXHZoGGTpXv/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633756; c=relaxed/simple;
	bh=1VQspnzX74QyFv8aqwqudsOJTo/9hsK3Ncf9cUiiQPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zx4JKgpJRCUnR1B98j8NNhtPDfh8Sg2RM/NgwsFYjcSKG4m4lPlhoY0mGgU/4gzW54s7roYMoMprSP/+1CtH8G0yNAJis59W38u/gkhy+WotHYhuTbbYYXZ2jYg3SUzS2nkvZAPFX4Ji/ptFO91EzOd1PadYXzJkViKRNVK6fOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQ9eoo55; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQ9eoo55"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633754; x=1822169754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1VQspnzX74QyFv8aqwqudsOJTo/9hsK3Ncf9cUiiQPE=;
  b=AQ9eoo551AbC+SZmk57OzLfLbAMxOiD8oFNQX05WSXEwrLLI6L/C/UOT
   3OHsqs70PJY/5fPk6jmrtito+0LDX38g9jZGy/LmiJMLJg/zLARtCHnIC
   lurXMEsaUHjtp0xzKEksKIZgfTYwpdyHaoL2qOPhnx2YvoeJvfQblsePh
   oOux5cYVnCfsRv5gAKGBWOvMLb7lFMSN0zgV2p6E2gU+IHw1cRSeVWAzw
   ubxaW8qz4JKRKHNd07kIxeeZIUzyaF1P745w1QZHpVC59EryAYSEIYZXg
   T6YbshIjYpsXIpAFNAp0dcymUfJYSa+Y9DOsrMl6Mk59ArC3eVnGMysXn
   Q==;
X-CSE-ConnectionGUID: Hf80xLSaSSWKl3lhF4QNnA==
X-CSE-MsgGUID: NKFQ/XyET9epmzr2Cac5CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387350"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387350"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:21 -0700
X-CSE-ConnectionGUID: emYv+3JETtCYzx00ylaOMw==
X-CSE-MsgGUID: YUCg4K5RQk2tT4aqSsfGRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685541"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:20 -0700
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
Subject: [PATCH v13 22/25] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
Date: Mon, 28 Sep 2026 15:15:06 -0700
Message-ID: <20260928221509.68002-23-tony.luck@intel.com>
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

When a telemetry device is unbound from its driver or deleted the
pmt_telemetry driver invalidates all the MMIO mappings for that
device. When resctrl reads a telemetry event it faults on the access
to the event counter.

Before destroying devices, tell resctrl that the virtual addresses
supplied by an earlier call to intel_pmt_get_regions_by_feature()
are about to be invalidated and should not be used again.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Context paragraph added describing the problem.

	New aet_mmio_lock moved to previous patch to avoid
	churn here changing lines that were just changed there.

	Add a comment in code that all entries for a removed device
	are on the same package.
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
2.55.0

