Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDF1391512
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346096; cv=none; b=WfdzQFvN33tDrk3meFwKP7bdrrkKIj2xLClawcqNE8TQyVnQJrpSM8lQEkoSOmk/DUWOF18wh8ug8I6GJD/GfJMpvS1zlZLWRLLGIxUhZyV9P2WgOWl3CBlqGJXNlYUlhTcpJShrJmX31szjoxOkAtLP+wl3phYZOc4cJv6nGLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346096; c=relaxed/simple;
	bh=UWOsFkzzIc7CCJKc0nEg0426WN9VqyRr6G0VYeTBEJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjfEYEGJwq0IoTOfofcB1iS7QwDhH5j30qN6F4PrNY0GMxUfHHDHVlwll4++9XMUPmDXge9EzLyeZxgDyEL8qWAelAKDMuC0DvLBGWEH8/AQHymFjIlstX0t8YuV149RBddzAnJRybitfH8Ov9iBUMKPvEajJWIpHloBl1jEGIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iS3qExzs; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iS3qExzs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346092; x=1816882092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UWOsFkzzIc7CCJKc0nEg0426WN9VqyRr6G0VYeTBEJ4=;
  b=iS3qExzstt5gEsnRRboVEz4su3MfBjYSStk4aVabeIehdwq5Ie7De3lR
   KppFvpSj53ZfYDMf0wJxYbetfO7/myOmUkRTt3bWhCxVcAiJTq5ktIQwQ
   9Nlu0+9593CvGOPUy/U2799XkT5sjoXQ8IBVHK3Ji8IT3ljl/6BQJDoSV
   QTVvxwDkJdG2e4PT1prjBGZWfMuFqv5oGOs09w8JqB00H642ccp26SalE
   D+kZSaEub0nvjmhMJljVKgz802A3NH9TGvhG+usoO8QYNN+oodD4YDWWj
   qOQMk0XJIsMAv/QUocFbQGgo8h7JtD4tSsRQbEOyMY2lQDtXVlEx3Qm+C
   Q==;
X-CSE-ConnectionGUID: vHO4OxftQ4qjbJjQCGKlhg==
X-CSE-MsgGUID: nAYoq0zNTayVThAhAmXCFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473702"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473702"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:03 -0700
X-CSE-ConnectionGUID: wtBVrJRqSSWJBApJraRU3g==
X-CSE-MsgGUID: YwmnCz62RfWcLN3mPW0sdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024620"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:03 -0700
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
Subject: [PATCH v10 15/17] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
Date: Wed, 29 Jul 2026 10:27:50 -0700
Message-ID: <20260729172752.11561-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
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
v10:
	New patch

 drivers/platform/x86/intel/pmt/telemetry.c | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index cafa2288600d..e0ad5cea2922 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -366,11 +366,43 @@ pmt_telem_find_and_register_endpoint(struct device *dev, u32 guid, u16 pos)
 }
 EXPORT_SYMBOL_NS_GPL(pmt_telem_find_and_register_endpoint, "INTEL_PMT_TELEMETRY");
 
+static u64 pmt_telem_pkg_mask(struct pmt_telem_priv *priv)
+{
+	u64 mask = 0;
+	int i;
+
+	mutex_lock(&ep_lock);
+	for (i = 0; i < priv->num_entries; i++) {
+		struct intel_pmt_entry *entry = &priv->entry[i];
+		struct pci_dev *pdev = to_pci_dev(entry->ep->dev);
+		struct oobmsm_plat_info *plat_info;
+
+		plat_info = intel_vsec_get_mapping(pdev);
+		if (IS_ERR(plat_info)) {
+			mask = ~0ULL;
+			break;
+		}
+		if (plat_info->package_id < BITS_PER_LONG_LONG)
+			mask |= BIT_ULL(plat_info->package_id);
+		else
+			mask = ~0ULL;
+	}
+	mutex_unlock(&ep_lock);
+
+	return mask;
+}
+
 static void pmt_telem_remove(struct auxiliary_device *auxdev)
 {
 	struct pmt_telem_priv *priv = auxiliary_get_drvdata(auxdev);
 	int i;
 
+	/*
+	 * Tell resctrl/AET that virtual mappings for MMIO space in
+	 * one or more CPU packages are about to be torn down.
+	 */
+	intel_aet_invalidate(pmt_telem_pkg_mask(priv));
+
 	mutex_lock(&ep_lock);
 	for (i = 0; i < priv->num_entries; i++) {
 		struct intel_pmt_entry *entry = &priv->entry[i];
-- 
2.55.0

