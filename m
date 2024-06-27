Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DCC1A08CA
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 20:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520756; cv=none; b=sqY9skRwP13VrgcB89cjMDNdZCyaxbV3Bm6491CPJbKstxo7WHa8LFeCrK6MAa1RkTB/BVrP8rO9Kk6hteB55sSFEY6ShL4gU8AHfy/7uWxAg8rfODYm6a6MkD+UqjzRs5m9TdQovqpGVyaK99MOsh67LjGtryEnZXsSHOb1oJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520756; c=relaxed/simple;
	bh=pRMMuFAo+vgoaQPT6H9NbnUr8oF0p+OxKZvV5KwLCn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYEkb2Ycmsyw9k5X9nmxL/dycrsIcGPpC7xdobItBKcPQKiEFGHvMDT2sw1U5g6ZrXts7GcC2k01BXgh/PmNSNSz8nlI9hM0FtJJVc1yzshU/+Q6gylvSiAHaFrL1uqh8J9b3cep72+Qkgj7TeCJiMHXeZ4+IGTXeb+GHweKODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LcdaczpY; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LcdaczpY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719520755; x=1751056755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pRMMuFAo+vgoaQPT6H9NbnUr8oF0p+OxKZvV5KwLCn4=;
  b=LcdaczpYOALMczIAlvGeJIUrAV6ZigBxzP2m04YCthtjmGxyUX4wRtZK
   S+vXI6ob+O1JB9tBbqHaQ4QCQQ5yqNjG///p+Uocer4eHW3rw1d8fls8p
   SkOkdo8MbSZyQR9of1Axf7LKiVaDmCoOL39vhTGdAPpPmMqu6tEpkP0Qa
   1nmG5/xc4wfc7GDG4zlBf8R0yWdoB3qMFsUHg5g1gBcK6SKCC0Cx9REM4
   GiMkjhr2vJ271QN0e2JouG0VHKqM0Z5apd7HxAp1HmVHuLtuL7BIsKqp0
   rlkiC2ko1/ihphQs1G57wGPVzUEH1y9nz/x4l97PQKQu4VE4bCarwIGzM
   w==;
X-CSE-ConnectionGUID: az5F9gWoR26yStiHEQ5hVQ==
X-CSE-MsgGUID: ac19lXlfTx6no9zDRH7E0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16809808"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16809808"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:09 -0700
X-CSE-ConnectionGUID: waKzOfwBTjWeglPIaQTWBw==
X-CSE-MsgGUID: caARh1HyT1aqIu2h1Za/ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="82052906"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v22 10/18] x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
Date: Thu, 27 Jun 2024 13:38:48 -0700
Message-ID: <20240627203856.66628-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627203856.66628-1-tony.luck@intel.com>
References: <20240627203856.66628-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Sub-NUMA Cluster (SNC) mode Linux must create the monitor
files in the original "mon_L3_XX" directories and also in each
of the "mon_sub_L3_YY" directories.

Refactor mkdir_mondata_subdir() to move the creation of monitoring files
into a helper function to avoid the need to duplicate code later.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 45 ++++++++++++++++----------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index d0443589cd86..9c38ddcfe150 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3025,14 +3025,37 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	}
 }
 
+static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
+			     struct rdt_resource *r, struct rdtgroup *prgrp)
+{
+	struct rmid_read rr = {0};
+	union mon_data_bits priv;
+	struct mon_evt *mevt;
+	int ret;
+
+	if (WARN_ON(list_empty(&r->evt_list)))
+		return -EPERM;
+
+	priv.u.rid = r->rid;
+	priv.u.domid = d->hdr.id;
+	list_for_each_entry(mevt, &r->evt_list, list) {
+		priv.u.evtid = mevt->evtid;
+		ret = mon_addfile(kn, mevt->name, priv.priv);
+		if (ret)
+			return ret;
+
+		if (is_mbm_event(mevt->evtid))
+			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
+	}
+
+	return 0;
+}
+
 static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 				struct rdt_mon_domain *d,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
-	struct rmid_read rr = {0};
-	union mon_data_bits priv;
 	struct kernfs_node *kn;
-	struct mon_evt *mevt;
 	char name[32];
 	int ret;
 
@@ -3046,22 +3069,10 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	if (ret)
 		goto out_destroy;
 
-	if (WARN_ON(list_empty(&r->evt_list))) {
-		ret = -EPERM;
+	ret = mon_add_all_files(kn, d, r, prgrp);
+	if (ret)
 		goto out_destroy;
-	}
 
-	priv.u.rid = r->rid;
-	priv.u.domid = d->hdr.id;
-	list_for_each_entry(mevt, &r->evt_list, list) {
-		priv.u.evtid = mevt->evtid;
-		ret = mon_addfile(kn, mevt->name, priv.priv);
-		if (ret)
-			goto out_destroy;
-
-		if (is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
-	}
 	kernfs_activate(kn);
 	return 0;
 
-- 
2.45.2

