Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447680;
	b=txcoAikxpYd4+pjIg1kpRp0myCnzC2OEaSIanbWDnX57xc65NxtymHoPLeOO5ki/DKqG
	 1SFXYTE+BEgrKFl/NBFWEhLDsHhFjmbejsF/4rdDpy47kgKIPJuOOihYMCf3z+i2ZthdQ
	 bp9dezVTp1qEtVtx4eqQYxdMW0NoEX3jFcfLmIMY5ogyUkjQUf5CdeJonzxPVZXIQZWES
	 QST6MtOP9BNUtyKE49NietLgM2a03/SjQJBfFTl1o5E+GTclzBnR2AuDLMx/xdqZLGLcT
	 FYQCWRlf3tMEEUOHkIUsVEznEjtEhenE054CshDs11TAysuADtH3oKwIK145vT9Qzfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447680;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z930aZdfvVpIFshW/GQIi7DQ5rFjXFIvOgbMJU6b2ac=;
	b=gtWtE12j2pUgxgLbikMOUlfwHMIYOpGmlxcoLCNKjEqchjKnK/nN0DeNHlF1Jd2FJW8H
	 9dwH4OaIKAxCZo0KwRdpQ+5E+r86Gr0vXAfCJrHhBbsYYgE+pzTJu/NJ9CP5iVA0mlO1+
	 RD9nkycy/V7pAaPWQqcEmgS9+kiYShBSF8XCSrCvMTnT+a/6YRv5dOn05b7+IONIV0ANG
	 ABKlJDTDb1Q76iNKCu0h7wbpLu0Wm9OrrvLLQoaRpAFozQyEmpHskryau/DHlTfg0fmbD
	 6OftuxjvtRgUjQgam4oXaCl6ABnFDuhxktMulr+1D2RiAbHYvF1Tk6c6WbdrpLO5ppg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Dm0UdOdV;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32685606A32C
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:08:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32685606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Dm0UdOdV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447681; x=1823983681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nfptYNOJXfNoHZ1ujlSgRKHthsMSykqMpirq6OtD6gs=;
  b=Dm0UdOdVk3QT+BCYYkdUI3pFy9evU9c6Dt+FjBFX1tbzWewOzrO5rsGp
   mgCWdMIKn4amIdCeXI7lDNL2nGmX3e7svPgCs3w6ypOEjppjHsJVcpCYZ
   pQhK9QcKoaC10IF4K6zhT9TBwyJUaO7ZkmKjtDgEihA4TaWopZMESHcOj
   ACW6LgqWnfRhJfGFxArVUvGZmEUTxVae/xH7+0CvXTxkwVgjuyEpyzKM+
   AuYkkUjfY0c0ff6QCACiFO9h7rlh4KVE601KtRyW3PlzCF5M8bxjGK3Do
   CFP0gfE5l61sbpczobtzae6d1cRpjYRpmOzpASUkqU2OO6p+sZ/KvLpAk
   A==;
X-CSE-ConnectionGUID: uZX58Ot9Sr++vGxNVhAOKw==
X-CSE-MsgGUID: IXMEvFZrTci1+8f2AiULXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144197"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144197"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:59 -0700
X-CSE-ConnectionGUID: Km7m/hfnQ7++EA4kzIpCSQ==
X-CSE-MsgGUID: yGBqu+ioQ1WIWQANzXeUNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708336"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:58 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH v2 04/10] arm_mpam: resctrl: Split control and monitoring domain setup into helpers
Date: Mon, 19 Oct 2026 15:07:38 -0700
Message-ID: <20621c28067916be2709fc4437473f1ccad7e334.1792443633.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1792443633.git.reinette.chatre@intel.com>
References: <cover.1792443633.git.reinette.chatre@intel.com>
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
---
 drivers/resctrl/mpam_resctrl.c | 116 ++++++++++++++++++++-------------
 1 file changed, 70 insertions(+), 46 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index dc442851fd7e..246560247a28 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1615,13 +1615,77 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
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
+	if (!any_mon_comp) {
+		WARN_ON_ONCE(0);
+		return -EFAULT;
+	}
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
@@ -1638,57 +1702,17 @@ static void mpam_resctrl_alloc_domain(unsigned int cpu,
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
-		if (!any_mon_comp) {
-			WARN_ON_ONCE(0);
-			goto offline_ctrl_domain;
-		}
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
@@ -1697,8 +1721,8 @@ static void mpam_resctrl_alloc_domain(unsigned int cpu,
 
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
2.55.0

