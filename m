Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B762E54BC
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936271; cv=none; b=Yqpdqv4DQWHkgMvn8f5ZnfNoXJ9nMbvQSdBYmEf/CNwjSaP/m0VKd8qNfF4xBjC9NEdCBSF6U5WpoyE3X5Rsjzh4Xg3sDhjQJE2yWYe+QuiAymkpnW2jlJ7A577Pz+LYZ+ihzHaiXF1oqUry6agfDa1q+41NVIxKlE4yfbXUSMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936271; c=relaxed/simple;
	bh=b6IVqR9pDUjerzkW1aPFwxLkZVvGGdytWKlMSyP1xH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2Axaxym1YRpYju77Gm8EEi+t12jh0pMhULpy0E1lPmMK8caeQVpP3XOp1irwape643kqsXOV29R+ihbLT81Y3YfjTrIZd1g0EMKbYArCra3RW6G7hUK8/4HFx54Pf9hBCuA0A4O4QmCBUsz3RHoP5ezullT+wEZlB6bGO42yoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RwN0/FXD; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RwN0/FXD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936269; x=1786472269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b6IVqR9pDUjerzkW1aPFwxLkZVvGGdytWKlMSyP1xH8=;
  b=RwN0/FXDoL625HNaCsXzpECMXqcK1BaWIQXbNX/0uEwogJAnS0VnbZWe
   EbpYDXmFHpNgawOCzN85jqTGnKoFb4n4rH388Xbu6zyiYhSH6STX0FfCS
   QFOKirKD166Lu1es42hji7EK70+YdLaAd4pqbrAWly80XpjdvVvIArKhW
   vjo8slnitKe9qTHv+FV+WwxH6h3WRbD5l4TIiLME2DXQNQY8HezsqAQBo
   5CsrmLFOVgeU+MhVr95G92Axf5e/X16HhMS0x3pHpRLmCmUi3lw9C0Cbj
   QekvuMQl7lQBgqC7aiEXqC9GR/TMnUYiQ+CHa36m4OjYP+quWSQq14ADT
   w==;
X-CSE-ConnectionGUID: ig14ZRVoSV6NBESlP13TdA==
X-CSE-MsgGUID: nWj4CTCKQqyqG0ccWJQfvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277487"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277487"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: zuPWe7FZTe+htSNyvV3dVw==
X-CSE-MsgGUID: cu2geDdiTKu24k7Sm9UdyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825702"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 26/32] fs/resctrl: Move allocation/free of closid_num_dirty_rmid
Date: Mon, 11 Aug 2025 11:17:00 -0700
Message-ID: <20250811181709.6241-27-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

closid_num_dirty_rmid[] is allocated in dom_data_init() and freed by
dom_data_exit() giving it the same life cycle as rmid_ptrs[].

Move the alloc/free out to resctrl_mon_l3_resource_init() and
resctrl_mon_l3_resource_exit() in preparation for rmid_ptrs[] to be
allocated on resctrl mount in support of the new telemetry events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/monitor.c | 56 ++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 40c66caf299d..0d9c8d4e0e9c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -805,36 +805,14 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 static int dom_data_init(struct rdt_resource *r)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
-	u32 num_closid = resctrl_arch_get_num_closid(r);
 	struct rmid_entry *entry = NULL;
 	int err = 0, i;
 	u32 idx;
 
 	mutex_lock(&rdtgroup_mutex);
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-		u32 *tmp;
-
-		/*
-		 * If the architecture hasn't provided a sanitised value here,
-		 * this may result in larger arrays than necessary. Resctrl will
-		 * use a smaller system wide value based on the resources in
-		 * use.
-		 */
-		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
-		if (!tmp) {
-			err = -ENOMEM;
-			goto out_unlock;
-		}
-
-		closid_num_dirty_rmid = tmp;
-	}
 
 	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
 	if (!rmid_ptrs) {
-		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-			kfree(closid_num_dirty_rmid);
-			closid_num_dirty_rmid = NULL;
-		}
 		err = -ENOMEM;
 		goto out_unlock;
 	}
@@ -870,11 +848,6 @@ static void dom_data_exit(struct rdt_resource *r)
 	if (!r->mon_capable)
 		goto out_unlock;
 
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-		kfree(closid_num_dirty_rmid);
-		closid_num_dirty_rmid = NULL;
-	}
-
 	kfree(rmid_ptrs);
 	rmid_ptrs = NULL;
 
@@ -957,9 +930,31 @@ int resctrl_mon_l3_resource_init(void)
 	if (!r->mon_capable)
 		return 0;
 
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+		u32 num_closid = resctrl_arch_get_num_closid(r);
+		u32 *tmp;
+
+		/*
+		 * If the architecture hasn't provided a sanitised value here,
+		 * this may result in larger arrays than necessary. Resctrl will
+		 * use a smaller system wide value based on the resources in
+		 * use.
+		 */
+		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+
+		closid_num_dirty_rmid = tmp;
+	}
+
 	ret = dom_data_init(r);
-	if (ret)
+	if (ret) {
+		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+			kfree(closid_num_dirty_rmid);
+			closid_num_dirty_rmid = NULL;
+		}
 		return ret;
+	}
 
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
@@ -984,5 +979,10 @@ void resctrl_mon_l3_resource_exit(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+		kfree(closid_num_dirty_rmid);
+		closid_num_dirty_rmid = NULL;
+	}
+
 	dom_data_exit(r);
 }
-- 
2.50.1

