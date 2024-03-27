Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D4E15358C
	for <patches@lists.linux.dev>; Wed, 27 Mar 2024 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569850; cv=none; b=i8mOYLdmVR9oAkSGYKDoVNtAt0NEO/v9GnzzOLzUH4YxFXSZM2tHi2TeEfcXVsDGjrG7xPd2CntsmBc0+QCf8uHde+hTBvRVvU23IQN6jW1olA4/joQDjEpCiCdKb/6cJoDZ7p+9c8kG5FbZhU4rnzdbV7hZa8CfAA/9oHg+FIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569850; c=relaxed/simple;
	bh=CLmeyEJVusEGYfnF/7WHgMN0KkjloHLy09ihZfkY5qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMqNNBBse3nPIjzn0+Yjn0o1r5Ev+Xaz31WQOnU/ZyVOuwcB7Oew5agDB0cpoh1HKOjhj59hfavoIUeYUKUi4VCsa4RoWIMiILtTZj4okZLEdK6eSGxJxvK04VguzTtKUnw9SryB9XmvFnPsEaVVIcXF3t6zDQC2NsRwO/wPAIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FtoCPT88; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FtoCPT88"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569849; x=1743105849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLmeyEJVusEGYfnF/7WHgMN0KkjloHLy09ihZfkY5qU=;
  b=FtoCPT88xkjJRmP53gyf5uqlLBP/XqQs5NFh50hU0HSaSnigbrjtxg7c
   S55R4H4VS5yTcMbefkQatOUPp0xcLnwwDSnmy79KWnrw5HQpE3WL0d0kw
   +Css1wbDPN5eEZsoXFOnGI4zeC12zqmv6kSNqV6wTqNnTh40IhVMKklXP
   PZjeIEh1uvg5I8Qy57Kh4I7jimZ+nDAfWMhjRD6m/ys+YqW4xJiKGxoJr
   q3mypmdqftcQBIZbVIS1L88sz7V+Gqad07BPRfbnXKwBf4da3lEe/Nl2b
   19CJC21Y7ricaqR51e+rPMPtYFvnCPd75QZZ9OGf2tyakkbkPFf7CMHy9
   A==;
X-CSE-ConnectionGUID: L5TgsKk1SHGYlBSPa9tNZA==
X-CSE-MsgGUID: SvK/p5HbQe6f/KPUIL1NHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="18133015"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="18133015"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 13:04:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="16246139"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 13:04:03 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 08/10] x86/resctrl: Mark L3 monitor files with summation flag.
Date: Wed, 27 Mar 2024 13:03:50 -0700
Message-ID: <20240327200352.236835-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240327200352.236835-1-tony.luck@intel.com>
References: <20240327200352.236835-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When Sub-NUMA cluster mode is enabled, the parent monitor
files in the mon_L3_XX directories need to sum all child
siblings from the SUBL3 domains.

Add a flag to the parent files and pass that down to the routines
that will read values from hardware RMID counters.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    | 5 ++++-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 8 +++++---
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 7f05502454c5..4263fbdf7ee7 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -130,6 +130,7 @@ struct mon_evt {
  * @priv:              Used to store monitoring event data in @u
  *                     as kernfs private data
  * @rid:               Resource id associated with the event file
+ * @sumdomains:        Report total of all SNC domains sharing an L3 cache
  * @evtid:             Event id associated with the event file
  * @domid:             The domain to which the event file belongs
  * @u:                 Name of the bit fields struct
@@ -137,7 +138,8 @@ struct mon_evt {
 union mon_data_bits {
 	void *priv;
 	struct {
-		unsigned int rid		: 10;
+		unsigned int rid		: 9;
+		unsigned int sumdomains		: 1;
 		enum resctrl_event_id evtid	: 8;
 		unsigned int domid		: 14;
 	} u;
@@ -149,6 +151,7 @@ struct rmid_read {
 	struct rdt_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
+	bool			sumdomains;
 	int			err;
 	u64			val;
 	void			*arch_mon_ctx;
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 2bf021d42500..fedcf50df6e5 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -574,6 +574,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	resid = md.u.rid;
 	domid = md.u.domid;
 	evtid = md.u.evtid;
+	rr.sumdomains = md.u.sumdomains;
 
 	r = &rdt_resources_all[resid].r_resctrl;
 	d = rdt_find_domain(r, domid, NULL);
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 399dc3175292..3e7f2e36b71e 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3059,7 +3059,8 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 }
 
 static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain *d,
-			     struct rdt_resource *r, struct rdtgroup *prgrp)
+			     struct rdt_resource *r, struct rdtgroup *prgrp,
+			     bool sumdomains)
 {
 	union mon_data_bits priv;
 	struct mon_evt *mevt;
@@ -3071,6 +3072,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain *d,
 
 	priv.u.rid = r->rid;
 	priv.u.domid = d->id;
+	priv.u.sumdomains = sumdomains;
 	list_for_each_entry(mevt, &r->evt_list, list) {
 		priv.u.evtid = mevt->evtid;
 		ret = mon_addfile(kn, mevt->name, priv.priv);
@@ -3109,7 +3111,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		ret = rdtgroup_kn_set_ugid(kn);
 		if (ret)
 			goto out_destroy;
-		ret = mon_add_all_files(kn, d, r, prgrp);
+		ret = mon_add_all_files(kn, d, r, prgrp, true);
 		if (ret)
 			goto out_destroy;
 	}
@@ -3124,7 +3126,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	if (ret)
 		goto out_destroy;
 
-	ret = mon_add_all_files(ckn, d, r, prgrp);
+	ret = mon_add_all_files(ckn, d, r, prgrp, false);
 	if (ret)
 		goto out_destroy;
 	kernfs_activate(kn);
-- 
2.44.0

