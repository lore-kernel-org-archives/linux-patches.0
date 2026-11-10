Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284360;
	b=rszICbcOAd1wwVNmp4tRSGyTepHakJMYgesvZa9UPUp20+vx5Wqw4IFs0IWLFbD83WMU
	 M4I9qv45tzUdb2YiRtOxBK0KyfksPkpO0MlxW0hLSnhW7seF+sO3a5UwcoYWGNgWgu4qL
	 FITXgvVz8F8EnTGxmtfB8TGsU4DWJob5TJKMdnTTskmTj3HJIS6TfM7GqyJU7tzIQtO78
	 moICrzqw5niexVN1HaWRAdhm/te/8DVGCNf6p9sB2VXUhfd9T+jJ+3nFxqTAyldhUuacZ
	 RGpJNnUaItvDpP4cCeRwiESQXVYH04luFBpOkzaA1O+/1J1Ji4Ru0b487w/iWldDO2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284360;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dV7nfFgA9q61rNs9FjEhDdwleHEpdNZXflZd5bDTkeE=;
	b=zRl64EIpdbSB9qmOitypqRaAwFZSSg0Od+E+Q82Rs357OtaLlzpLtSdgP1OCh0u1FoX1
	 SKcTRziUq/eu0h9D8RgY1lkSPQqpp2vXMz5+ISFvD05+SCTxJLSbIAQbd4CWDa7v44zz0
	 2GPThkAw9B/2qU/KZkZTGG7fRX7suEi8ARriC2ESownw8Zfy/wec3DNol3gtSHuWPzX6f
	 TdsPZpC8NCtyf0xaq7katm6O2O9ArHCdEOopSW8qce5owQvP3th3NIQFr83cNrO+bwccJ
	 yebd1P1BM13+i5tNYP+pNC7lSwAdOjjHyYQ+KPtL1jKTZu5BSgYlk2cyCtEg1jw1HLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="QZD/DmZ3";
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158DC606A334
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 158DC606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QZD/DmZ3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284360; x=1825820360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=siJ+HXBZa096ZlEQsTVh9iBvtYiYyaDLPZk/Svng8yE=;
  b=QZD/DmZ3whtPa1/YGaP1hu5INETJl60XjgQ8nCxqt/EKGf8lunTDj8Jd
   Oy3NLH1DuNzNFL1fQAKaIHxAdxtpuzwdzSeTWlKqOz71KjH1PbwG/r94r
   rXaU44ui3fLbhFHCGN2RBUDtjWX1GqmtCoLwJAdRpGOPLv1gxbSdmk+4v
   dYQhLgDivoU7FbK5g18qMK14Ur9m3Roi+wnFnELC5AIH/OxOyvO1NpfgZ
   ey67C5B+m8WYrKZMwV4eHugluyTJOj0rgffd4+YkaWT9XQlRcJ0zAXLT6
   TogEabl1VTLXLhQMTcXi0Hskch4gXO3YxWFi42h6XAZjfmxr3j8Ele/jB
   g==;
X-CSE-ConnectionGUID: tyHAc6XRQy+kWPygHKQjzw==
X-CSE-MsgGUID: sYCMcr3ATdSNi0tPy3mYsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901328"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901328"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
X-CSE-ConnectionGUID: 53hkaHfDQ5KoBJWqFxCqnw==
X-CSE-MsgGUID: I4ySf9UwS0mAzV6XUPrsJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856920"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com,
	ruanjinjie@huawei.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	tan.shaopeng@fujitsu.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 5/8] arm_mpam: resctrl: Split control and monitoring domain setup into helpers
Date: Mon,  9 Nov 2026 20:19:05 -0800
Message-ID: <3d67a3dddd76cdb9981d4d7e78d657c930eb2cb6.1794283825.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794283825.git.reinette.chatre@intel.com>
References: <cover.1794283825.git.reinette.chatre@intel.com>
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

mpam_resctrl_alloc_domain() allocates one structure that holds both the
control domain and the monitoring domain of a resource. It sets up
whichever of the two domains the resource supports, with the setup of
both open coded in the function, and undoes the control domain if
setting up the monitoring domain fails.

Apart from the code that manages domains, every user of the structure
accesses only one of its two domains, so the monitoring domain can be
given a structure of its own. Doing so starts with separating its setup
from that of the control domain.

Move the setup of each domain into its own helper in preparation for
giving the monitoring domain its own structure as part of supporting
multiple controls per resource. Keep the allocation and the error
handling in mpam_resctrl_alloc_domain() so that a failure to set up the
monitoring domain still undoes the control domain.

No functional change intended.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
Changes since RFC v2:
- Add Jinjie's Reviewed-by tag.
- Add Jinjie's Tested-by tag.
---
 drivers/resctrl/mpam_resctrl.c | 112 ++++++++++++++++++++-------------
 1 file changed, 68 insertions(+), 44 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index ec39f3909388..db1df6e8d8c0 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1640,13 +1640,75 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
 	return NULL;
 }
 
+static int mpam_resctrl_setup_ctrl_domain(unsigned int cpu,
+					  struct rdt_resource *r,
+					  struct mpam_component *comp,
+					  struct mpam_resctrl_dom *dom)
+{
+	struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
+	int err;
+
+	dom->ctrl_comp = comp;
+
+	mpam_resctrl_domain_hdr_init(cpu, comp, r->rid, &ctrl_d->hdr);
+	ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
+	err = resctrl_online_ctrl_domain(r, ctrl_d);
+	if (err)
+		return err;
+
+	mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
+
+	return 0;
+}
+
+static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
+					 struct rdt_resource *r,
+					 struct mpam_resctrl_dom *dom)
+{
+	struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
+	struct mpam_component *any_mon_comp = NULL;
+	enum resctrl_event_id eventid;
+	struct mpam_resctrl_mon *mon;
+	int err;
+
+	/*
+	 * Even if the monitor domain is backed by a different
+	 * component, the L3 component IDs need to be used... only
+	 * there may be no ctrl_comp for the L3.
+	 * Search each event's class list for a component with
+	 * overlapping CPUs and set up the dom->mon_comp array.
+	 */
+
+	for_each_mpam_resctrl_mon(mon, eventid) {
+		struct mpam_component *mon_comp;
+
+		if (!mon->class)
+			continue;       // dummy resource
+
+		mon_comp = find_component(mon->class, cpu);
+		dom->mon_comp[eventid] = mon_comp;
+		if (mon_comp)
+			any_mon_comp = mon_comp;
+	}
+	if (WARN_ON_ONCE(!any_mon_comp))
+		return -EFAULT;
+
+	mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
+	mon_d->hdr.type = RESCTRL_MON_DOMAIN;
+	err = resctrl_online_mon_domain(r, &mon_d->hdr);
+	if (err)
+		return err;
+
+	mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
+
+	return 0;
+}
+
 static void mpam_resctrl_alloc_domain(unsigned int cpu,
 				      struct mpam_resctrl_res *res)
 {
 	int err;
 	struct mpam_resctrl_dom *dom;
-	struct rdt_l3_mon_domain *mon_d;
-	struct rdt_ctrl_domain *ctrl_d;
 	struct mpam_class *class = res->class;
 	struct mpam_component *comp;
 	struct rdt_resource *r = &res->resctrl_res;
@@ -1663,55 +1725,17 @@ static void mpam_resctrl_alloc_domain(unsigned int cpu,
 		return;
 
 	if (r->alloc_capable) {
-		dom->ctrl_comp = comp;
-
-		ctrl_d = &dom->resctrl_ctrl_dom;
-		mpam_resctrl_domain_hdr_init(cpu, comp, r->rid, &ctrl_d->hdr);
-		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
-		err = resctrl_online_ctrl_domain(r, ctrl_d);
+		err = mpam_resctrl_setup_ctrl_domain(cpu, r, comp, dom);
 		if (err)
 			goto free_domain;
-
-		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
 	} else {
 		pr_debug("Skipped control domain online - no controls\n");
 	}
 
 	if (r->mon_capable) {
-		struct mpam_component *any_mon_comp = NULL;
-		struct mpam_resctrl_mon *mon;
-		enum resctrl_event_id eventid;
-
-		/*
-		 * Even if the monitor domain is backed by a different
-		 * component, the L3 component IDs need to be used... only
-		 * there may be no ctrl_comp for the L3.
-		 * Search each event's class list for a component with
-		 * overlapping CPUs and set up the dom->mon_comp array.
-		 */
-
-		for_each_mpam_resctrl_mon(mon, eventid) {
-			struct mpam_component *mon_comp;
-
-			if (!mon->class)
-				continue;       // dummy resource
-
-			mon_comp = find_component(mon->class, cpu);
-			dom->mon_comp[eventid] = mon_comp;
-			if (mon_comp)
-				any_mon_comp = mon_comp;
-		}
-		if (WARN_ON_ONCE(!any_mon_comp))
-			goto offline_ctrl_domain;
-
-		mon_d = &dom->resctrl_mon_dom;
-		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
-		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
-		err = resctrl_online_mon_domain(r, &mon_d->hdr);
+		err = mpam_resctrl_setup_mon_domain(cpu, r, dom);
 		if (err)
 			goto offline_ctrl_domain;
-
-		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
 	} else {
 		pr_debug("Skipped monitor domain online - no monitors\n");
 	}
@@ -1720,8 +1744,8 @@ static void mpam_resctrl_alloc_domain(unsigned int cpu,
 
 offline_ctrl_domain:
 	if (r->alloc_capable) {
-		mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
-		resctrl_offline_ctrl_domain(r, ctrl_d);
+		mpam_resctrl_offline_domain_hdr(cpu, &dom->resctrl_ctrl_dom.hdr);
+		resctrl_offline_ctrl_domain(r, &dom->resctrl_ctrl_dom);
 	}
 free_domain:
 	kfree(dom);
-- 
2.56.0

