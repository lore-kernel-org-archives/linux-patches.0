Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4212653D0CB
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600437; cv=none; b=dnGJGvIkgs/Z3l3FbR4u5+SW/ZDVDCvWWmXoU70aTNNGDBhOW6bgNqCuKOoJ7yvd1YaAxzMbC/ySt8gsXVpc29mLmgosEKTUUQd+Nwa3V51vGYbEuRsKWy5kDFJ9xQgiJZGE0deEia40UOnbPkx28dYhpfHe7fVq23XzdjRFbjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600437; c=relaxed/simple;
	bh=eVmXOFlkRN5iaG26DigKaIsj/0UtV30S+C6g+/Kkx1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clWxde0KsbTxg5vVxXSFdMSKV4gYGRGZqfXyLd/UQBV634+AlQH1vcGPCr/Ad7uazKbC7uw8S5MZmvs7umPHzluSzyOPD7l/J6lrgQYsouRi3DZcnZ3A1bxMUzF6ArWcfLKNuoLzcGYPrSppTemXASprLwPYoZL0lmiuG6wCB6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YRWykCJ0; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YRWykCJ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600435; x=1821136435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eVmXOFlkRN5iaG26DigKaIsj/0UtV30S+C6g+/Kkx1s=;
  b=YRWykCJ0a/s++c8C56QwnAUjC1qZqNMKcCpaEoPqkv5t+EcJ+SOpvaL7
   xarwtrGbSqXMsoLECh9AYoHyfZqtVXJL4qvY7XYfF9iiAL4sIw2myiyn0
   /MVRB6lpWUgmVzwyMkVZ5K3K2QaF/HNK9j43EkY5YV0AyclQG821oUgP1
   rTu7yH19AyLWDUFyZ8nHhrt4kPftzj+5pg437v5thb7nsH+ISmy5MNKsr
   GCz8Fa0Wu5I0y+tC0bPKABfUR+pDynXpxUwZT0QMa0P0myI23kvNXpfyk
   y84NQ0+8zriVYSmt4Ls5s9VOiwyTnI7w7eEOmW0NmVzWKF0+hgTGVz6xi
   Q==;
X-CSE-ConnectionGUID: FUk1gA3RRLyo3qxA5G+8ow==
X-CSE-MsgGUID: lZAhxQzARjuVjc5svG0fww==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861519"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861519"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:40 -0700
X-CSE-ConnectionGUID: gYXTOZHxTEm1wFn0kBsWQg==
X-CSE-MsgGUID: YJz8K/Q5QYKeu1GlIvDOGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231501"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:40 -0700
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
Subject: [PATCH v12 22/25] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
Date: Wed, 16 Sep 2026 16:13:17 -0700
Message-ID: <20260916231320.14502-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
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

Avoid A-B deadlock between ep_lock and aet_register_lock.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Ilpo: Downgrade "can't happen" dev_warn() to dev_debug()
	Ilpo's suggestion to use guard(mutex) moot due to refactor.
	Reinette: Refactor and eliminate "u32 ret" and s/packages/package/
	Reinette: Explain ep_lock release/acquire.
---
 drivers/platform/x86/intel/pmt/telemetry.c | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index bf0c9295feb3..527563043777 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -366,12 +366,43 @@ pmt_telem_find_and_register_endpoint(struct device *dev, u32 guid, u16 pos)
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
+		if (!IS_ERR(plat_info))
+			return plat_info->package_id;
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
+	if (package_id < 0) {
+		dev_dbg(&auxdev->dev, "Unable to determine package ID for removed device\n");
+	} else {
+		mutex_unlock(&ep_lock);
+		intel_aet_invalidate(package_id);
+		mutex_lock(&ep_lock);
+	}
+
 	for (i = 0; i < priv->num_entries; i++) {
 		struct intel_pmt_entry *entry = &priv->entry[i];
 
-- 
2.55.0

