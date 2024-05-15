Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26AA15E200
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811824; cv=none; b=nWtFhp9mNIBFraiWpSJXeh9lz0GqWg0gqnQjlPemHcTWtgybqzXvK4k79JeSxxkWXGmjo1iK0wxlvAI8Mabq2rUhHKvPQUWOa2l3tn+iMkcDzIUWYz6ihvWNLEjrxZz9HjcnnULIPucVJ6t7P5dRtRmGBuumvdBmnjMPc7nNfVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811824; c=relaxed/simple;
	bh=soQkrx+91u7qTspgGFOcYDqwxHpz6MbduDMvA+P81gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rmb9On0pkA+N4dCZ2EyGwTBGv01oswlgsr2I8GMpyXPOkvWxXHsFcWbglE2vgGt3PRFfhmAbIJdL2VCgfmB2pG6eFrBQd553+cpEPN52Gjgt43gSgNz+GrfMttYdYbw22kYVmquFwOFeuayiRNXNBn1ZWyADUVYok+FCuSNfwkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMcIUnp/; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMcIUnp/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811823; x=1747347823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=soQkrx+91u7qTspgGFOcYDqwxHpz6MbduDMvA+P81gI=;
  b=nMcIUnp/2qwwj8Lnokq0UY3KBdrqoCo6nc7QlYvgtUH+MKNyguh2RY+I
   ebWRHVqfexTM3doWrRj9K5YGQaEZSuqHMv7X9YAQQR3vL3ElxfB0m5fW3
   rWyfT0kmhuU1eyL6HYLIWE8aHfcxFWKMx4bvPrsh7EN6IfrVrc3DVmPQl
   DWc7R6B06jNcWZ+ETCTPDZpaPbvgkFxuMrtSUxG15J7MZrXvaxYsqH/a/
   /PsX9ZZWOYUziBOfwn3aWTXHtdfBmQvniAuOEo7OBCGVsL5d0v3Pnd4EM
   uQTjwLxB8n1xyVmcOqIKUkEQge2GDvRQ9hjaBtmJmA6KivSMTjexYmuCw
   Q==;
X-CSE-ConnectionGUID: YiBxcmyeRT2s6/LeK65YQQ==
X-CSE-MsgGUID: EYLRdLuESbmzXt5lq9bQdA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671670"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671670"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:35 -0700
X-CSE-ConnectionGUID: hZsTzADGQKSMzu+SEDWKPg==
X-CSE-MsgGUID: dldCONw5T/+FkIHM2sqj1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989176"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:35 -0700
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
Subject: [PATCH v18 10/17] x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
Date: Wed, 15 May 2024 15:23:18 -0700
Message-ID: <20240515222326.74166-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the creation of monitoring files into a helper function.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 45 ++++++++++++++++----------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 0923492a8bd0..7a6c40aefdcc 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3025,14 +3025,37 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	}
 }
 
+static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
+			     struct rdt_resource *r, struct rdtgroup *prgrp)
+{
+	union mon_data_bits priv;
+	struct mon_evt *mevt;
+	struct rmid_read rr;
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
-	union mon_data_bits priv;
 	struct kernfs_node *kn;
-	struct mon_evt *mevt;
-	struct rmid_read rr;
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
2.44.0

