Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0FA47F2D9
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198290; cv=none; b=ftFcfGT3aFSDUOz3FpGamUCG0iWAyWm4ZP6MlSm8oY/WEHYWIcaoYaYreufHY2u0RtbXyyLwwUdUpMjAPUlQ7SoSSZ9/Fj7U0dAn4BFs4DIKDjyqaX82wDdfx8g2DDIyWQW7HOUlvNSiVj6vEvYTy9uIzDePeaOsTIw0c+ZnaTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198290; c=relaxed/simple;
	bh=2oL2tMiC8gldZ/2aEvGipZr9OCQfTdZexvNzvOG31DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxOxGMkwv8VA569FNOQsOxyX4NkFCr8GXQbHiKS2KBjqPopg3ZWA0lrSLLL3ade8piWnwe2/OdECBRwYF8WBLg+zaz3Mhvmh4V8Ql/y1gwdseLUHNRQxSaug/zjl2YN3Z4e6OPNT69LXdJ9z73J4OF3tIwz64RDCjP0hSZtEfEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AdqBzadR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AdqBzadR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198288; x=1819734288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2oL2tMiC8gldZ/2aEvGipZr9OCQfTdZexvNzvOG31DQ=;
  b=AdqBzadRCEvKkhbiSa1Qf6IfGqErhn7ErF6kTbokEjiPnQQNzjXPLwc7
   vuW39c8h6ofCyC3lwaH85hPxgtKu2gDxb6mkWFGh/9Zm3dC+FhQSuVlsp
   VBYD12ft88ucSEO3CCOeTsxEpBCFQYapYMFX6qL6g2PU7tkkp9YicXh2a
   RpdeUwfIqHcLPawUG8JDUEO6F4dgtChhQYtxQwv8HLBU6320egxgyGCDh
   UJmZJwPj0bo4h20HwaGdnvS69tEvhwjTNydilJUpEwIGVuxNelIFmGdTW
   qwg8XL0Oi3FEZcPSaL/KbFesG6H0vNYjNslxrqUTHFo+2g0JPn/jN4BSw
   w==;
X-CSE-ConnectionGUID: fqdlHJMZRzuwpNq8mol1aA==
X-CSE-MsgGUID: 9c8diAM1RCq1dzdGgxX6gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480102"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480102"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:43 -0700
X-CSE-ConnectionGUID: 8tD81Ln9TimZwgMRbEdsqA==
X-CSE-MsgGUID: PeeJdshaRF2ZMrJXCqll3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268907023"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:41 -0700
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
Subject: [PATCH v11 20/23] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
Date: Mon, 31 Aug 2026 10:44:18 -0700
Message-ID: <20260831174421.13921-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before destroying devices, tell resctrl that the virtual addresses
supplied by an earlier call to intel_pmt_get_regions_by_feature()
are about to be invalidated and should not be used again.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	Unbind/remove operations can't cross package boundaries.
	Psss package_id instead of bitmap of package IDs.
	Use dev_warn() to report failure to find package_id.

 drivers/platform/x86/intel/pmt/telemetry.c | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index 2d2282c636b2..92871ce51c57 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -366,11 +366,43 @@ pmt_telem_find_and_register_endpoint(struct device *dev, u32 guid, u16 pos)
 }
 EXPORT_SYMBOL_NS_GPL(pmt_telem_find_and_register_endpoint, "INTEL_PMT_TELEMETRY");
 
+static int pmt_telem_get_package_id(struct pmt_telem_priv *priv)
+{
+	u32 ret = -1;
+	int i;
+
+	mutex_lock(&ep_lock);
+	for (i = 0; i < priv->num_entries; i++) {
+		struct intel_pmt_entry *entry = &priv->entry[i];
+		struct pci_dev *pdev = to_pci_dev(entry->ep->dev);
+		struct oobmsm_plat_info *plat_info;
+
+		plat_info = intel_vsec_get_mapping(pdev);
+		if (!IS_ERR(plat_info)) {
+			ret = plat_info->package_id;
+			break;
+		}
+	}
+	mutex_unlock(&ep_lock);
+
+	return ret;
+}
+
 static void pmt_telem_remove(struct auxiliary_device *auxdev)
 {
 	struct pmt_telem_priv *priv = auxiliary_get_drvdata(auxdev);
+	int package_id = pmt_telem_get_package_id(priv);
 	int i;
 
+	/*
+	 * Tell resctrl/AET that virtual mappings for MMIO space in a CPU
+	 * packages are about to be torn down.
+	 */
+	if (package_id != -1)
+		intel_aet_invalidate(package_id);
+	else
+		dev_warn(&auxdev->dev, "Unable to determine package ID for removed device\n");
+
 	mutex_lock(&ep_lock);
 	for (i = 0; i < priv->num_entries; i++) {
 		struct intel_pmt_entry *entry = &priv->entry[i];
-- 
2.55.0

