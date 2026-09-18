Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA7C5158BB
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 16:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789748951; cv=none; b=kXW4eA96WQDowej7WAL4Ws/G5DMBt3F9tUybJt5ZLEp7IjhOM/js+yiGn3tM4G6q4Ns2aQa/eVkrWRVdqsdOhjy73LBEbec45LwkmTz8rCvCSewMYqc9MmeTBPcpuFBjmGTDTHGI93f2w6CO1A2mPPwGlpWZwUFzUHfeqarCghU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789748951; c=relaxed/simple;
	bh=uFsQEfc58ykBrOzVcivOg2BZzvmpOoJm1w4prWj7reo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLOceNVt4X2FI9CsL5HMGcqAMWvFcqvK9Fbsm/QVMTWjkFczPgdGApcxbGpb2l1w6TC6vnyhc41rvsyIz867ZAAG+z0aZQuUIwZAXELxtbTxeh8fuISQPyheWgPSknLDhOkkTBxN85ep3A69xw/T6QKCWx0Tl2PGBeP2ROqgqBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hGz3AhsL; arc=none smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hGz3AhsL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789748948; x=1821284948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uFsQEfc58ykBrOzVcivOg2BZzvmpOoJm1w4prWj7reo=;
  b=hGz3AhsLnoQU620aUboNX+YCZxNCCWDmieVq6IqPTVNublq+64ASwCkc
   ZlKERC8ttCQ13gufbINCV6c9JjMncRtsaH1UZ1KJONaokqzYugRoSR54O
   h7D1GubLWm4IRn2T8kLQYpBTyK1HOM5SLeSDjGHpsyo7GuKbo6eLJQE+x
   O0TOL1B7mmYjAnoNfj8DUfpzuKPTcrQ/d8/Ktk1mHc5WBgNu3VR5yBwYY
   WWbA9TW7UblIxAq7dAlnRtmLlrOjuo9eh+EUgrWba2Eo7sIF4hmmj/rIg
   E90+Dl+y+IzrsoY86nyoxp7AWdosS/BdjX6HaJbRn4mV2O+/yq7DLjYdB
   A==;
X-CSE-ConnectionGUID: KJ1vr1itREGSXnD5GpdeDA==
X-CSE-MsgGUID: 2xChXQHUR0+zbmUkOuKTVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11909"; a="778882"
X-IronPort-AV: E=Sophos;i="6.27,109,1787036400"; 
   d="scan'208";a="778882"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 09:29:08 -0700
X-CSE-ConnectionGUID: 24fx202xTqWCI6Y4jB9Avg==
X-CSE-MsgGUID: o++7YqhWRmq44ML4Cx6hWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,109,1787036400"; 
   d="scan'208";a="279705660"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.220.128])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 09:29:07 -0700
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
Subject: [PATCH 12 22/25 UPDATED] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
Date: Fri, 18 Sep 2026 09:29:00 -0700
Message-ID: <20260918162901.10724-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-23-tony.luck@intel.com>
References: <20260916231320.14502-23-tony.luck@intel.com>
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
v12.1:
	Add new aet_mmio_lock.
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c    |  9 ++++---
 drivers/platform/x86/intel/pmt/telemetry.c | 29 ++++++++++++++++++++++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 1fd25fd9cd96..dafd69b8249a 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -298,10 +298,13 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 /*
  * Protects pmt_module, get_feature, put_feature against races between module
  * load/unload of the pmt_telemetry module and mount/unmount of the resctrl
- * file system. Also protects pmt_in_use telemetry_region::addr.
+ * file system. Also protects pmt_in_use.
  */
 static DEFINE_MUTEX(aet_register_lock);
 
+/* Protects telemetry_region::addr. */
+static DEFINE_MUTEX(aet_mmio_lock);
+
 static struct module *pmt_module;
 static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
 static void (*put_feature)(struct pmt_feature_group *p);
@@ -374,7 +377,7 @@ void intel_aet_invalidate(u8 package_id)
 {
 	struct event_group **peg;
 
-	guard(mutex)(&aet_register_lock);
+	guard(mutex)(&aet_mmio_lock);
 
 	for_each_event_group(peg) {
 		struct event_group *e = *peg;
@@ -452,7 +455,7 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 	void *pevt0;
 	u32 idx;
 
-	guard(mutex)(&aet_register_lock);
+	guard(mutex)(&aet_mmio_lock);
 
 	pevt0 = pevt - pevt->idx;
 	e = container_of(pevt0, struct event_group, evts);
diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index bf0c9295feb3..f11b25ece4f9 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -366,12 +366,41 @@ pmt_telem_find_and_register_endpoint(struct device *dev, u32 guid, u16 pos)
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
+		intel_aet_invalidate(package_id);
+	}
+
 	for (i = 0; i < priv->num_entries; i++) {
 		struct intel_pmt_entry *entry = &priv->entry[i];
 
-- 
2.55.0

