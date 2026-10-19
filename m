Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447682;
	b=c9o8IpulDCojeXAa0vvBKeFvD4DIhWniqKiBsBr671tBWk6z2RWvahGX49B/aUiaSvsK
	 tzcPJ7sO71DJL4oMVLbNEuDpaKfGIa8P1WY6YrtKndrcW8UegPXm9D3hGg5Dyn9Jz947E
	 XpL6u+bya4L90OonjoHERUbOzEQwMMnF8vU29pjckmVQRkQ8n73+vUnYwC9sTAGRiaPT2
	 adduQs09ZvjKJKZ5P3/Wcd1iIqcV58QSR+GuFGucNkRBSWM5V9GYQZXi1DIdUZ9VVIsEk
	 P1sqIQkppxWgwges8YSaPGHDjiNCzi/FFtPQ7BKniTz35TXGfDxrU9PFgiyhuwXRyjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447682;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AFtwyfxLr5GFgAON1RsdtP16Tz5z4/baZH98ZPkOWQI=;
	b=U6tfZhP5E7VJj6EVEEC+cDReQF8YbXeE9/ZPYxmugrE/qEjMNT4n1L9XWrFZBNMC82iG
	 bXdyxn7/oB1JFrqRiADGdIvpfziZQ1tY/1trMroBXs9TyK5t3jKk2p3Kbo2wdN2ImWRgi
	 GInbwgvVw3xFqb7ITeUrd7nSlvZsreENn/qXeJhMgpbdcNbiC9IFbKC4mmeGOwadQ0lgN
	 iKFvTL3gQKTRNQu0YYqJZBKwen2++1QsQXssBSYjrToutqXbm4k8yMOQbfOXoBzSoNMUX
	 wEHkpkGJKH77LPihtW5+B799nVZx68yIPD9YTIgFI/+GoxNsSiDhufsbjRU4sLLXWDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FvYgU400;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1392606A332
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:08:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1392606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FvYgU400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447681; x=1823983681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C/BtAMfkRrWL4wEqht4DC9WNmUti1x/o/QqUF2yKxeY=;
  b=FvYgU400cBpcSIQcML35fdYvBTmGu6u77J3EI4VeSJdM6D1BL1SY/hWS
   iLR7/TNAo7u16HPDp6PP/lAbDEmWfIFGz1VLm/HfM7qiFMp/GkgFILdy5
   f4lR25C9nhYYk6bha31u/ORLHXpABjAUlncl4A5MuBJyZx8R2Jdjp5exl
   y5I2m+rgvRJyL5llMFm6dLiXBARzdEuTYEBEzmjnaElhVtq0wEkY9jegK
   dTYP55a//oB8eQFSbKp23cCZB2tuzRdbOuMcCMqdFSwaA/fO8kB0eBZ5r
   AWwWpG60XB70IW+SsJJNqcwDRhJSeEv7XT6MSIQvk/0ZzhFQz9+haVHik
   Q==;
X-CSE-ConnectionGUID: jlHhroz+S7K0l+8Omc9tvA==
X-CSE-MsgGUID: +g5BBYFdR/OIzPu6UqVk2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144204"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144204"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:59 -0700
X-CSE-ConnectionGUID: xy2ikk9ySGG5kvNUp7qfUQ==
X-CSE-MsgGUID: CfjKMWl1RgiYfO2QyNwzLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708339"
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
Subject: [RFC PATCH v2 05/10] arm_mpam: resctrl: Give the monitoring domain its own structure
Date: Mon, 19 Oct 2026 15:07:39 -0700
Message-ID: <2238eab97cc66852d0d0d1a5c6ff191c03ce9e0d.1792443633.git.reinette.chatre@intel.com>
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

One structure holds both the control domain and the monitoring domain of
a resource. The two domains are allocated together when the first CPU of
the domain comes online and freed together once both have lost their
last CPU. A failure to set up the monitoring domain undoes the control
domain.

Apart from the code that manages domains, nothing uses both domains of
the structure. Keeping them in one structure nevertheless ties each
control domain to a monitoring domain, which does not fit supporting
multiple controls per resource.

Move the monitoring domain and its components into a new structure,
struct mpam_resctrl_mon_dom. Manage control and monitoring domains
separately when CPUs come online and go offline: look up, set up, and
tear down each domain on its own and free it once it has lost its last
CPU.

Do not let a failure to set up one type of domain affect the other. Keep
a control domain that was set up when setting up the monitoring domain
for the same CPU fails, and set up the monitoring domain even when
setting up the control domain fails. This is consistent with domain
setup failures not failing CPU online: only domains that were set up are
exposed through resctrl.

Look for a component of the resource's class that contains the CPU only
when setting up a control domain, since that component backs the
control domain. Setting up a monitoring domain already fails if no
monitoring class has a component for the CPU.

Look up monitoring domains by L3 cache ID on all systems, as was already
done on systems without controls. Monitoring domain IDs are always those
of the L3, so this finds the same domain as looking it up through its
control domain did.

Drop the debug messages about resources without controls or monitors.
They reported which of the two domains in the shared structure was left
unused, which no longer applies now that each domain type has its own
structure.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/resctrl/mpam_internal.h |   5 +-
 drivers/resctrl/mpam_resctrl.c  | 226 ++++++++++++++++----------------
 2 files changed, 117 insertions(+), 114 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 84c7adbb1a40..1df439ecb055 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -434,15 +434,16 @@ struct mpam_msc_ris {
 
 struct mpam_resctrl_dom {
 	struct mpam_component		*ctrl_comp;
+	struct rdt_ctrl_domain		resctrl_ctrl_dom;
+};
 
+struct mpam_resctrl_mon_dom {
 	/*
 	 * There is no single mon_comp because different events may be backed
 	 * by different class/components. mon_comp is indexed by the event
 	 * number.
 	 */
 	struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
-
-	struct rdt_ctrl_domain		resctrl_ctrl_dom;
 	struct rdt_l3_mon_domain	resctrl_mon_dom;
 };
 
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 246560247a28..ce5519635c51 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -510,7 +510,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
 			   void *arch_priv, u64 *val, void *arch_mon_ctx)
 {
-	struct mpam_resctrl_dom *l3_dom;
+	struct mpam_resctrl_mon_dom *l3_dom;
 	struct mpam_component *mon_comp;
 	u32 mon_idx = *(u32 *)arch_mon_ctx;
 	enum mpam_device_features mon_type;
@@ -524,7 +524,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	if (eventid >= QOS_NUM_EVENTS || !mon->class)
 		return -EINVAL;
 
-	l3_dom = container_of(hdr, struct mpam_resctrl_dom, resctrl_mon_dom.hdr);
+	l3_dom = container_of(hdr, struct mpam_resctrl_mon_dom, resctrl_mon_dom.hdr);
 	mon_comp = l3_dom->mon_comp[eventid];
 
 	if (eventid != QOS_L3_OCCUP_EVENT_ID)
@@ -542,7 +542,7 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 			   enum resctrl_event_id eventid, u64 *val)
 {
 	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
-	struct mpam_resctrl_dom *l3_dom;
+	struct mpam_resctrl_mon_dom *l3_dom;
 	struct mpam_component *mon_comp;
 
 	if (!mpam_is_enabled())
@@ -551,7 +551,7 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
 		return -EINVAL;
 
-	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
+	l3_dom = container_of(d, struct mpam_resctrl_mon_dom, resctrl_mon_dom);
 	mon_comp = l3_dom->mon_comp[eventid];
 
 	return read_mon_cdp_safe(mon, mon_comp, mpam_feat_msmon_mbwu,
@@ -599,7 +599,7 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d
 			     enum resctrl_event_id eventid)
 {
 	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
-	struct mpam_resctrl_dom *l3_dom;
+	struct mpam_resctrl_mon_dom *l3_dom;
 	struct mpam_component *mon_comp;
 
 	if (!mpam_is_enabled())
@@ -608,7 +608,7 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d
 	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
 		return;
 
-	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
+	l3_dom = container_of(d, struct mpam_resctrl_mon_dom, resctrl_mon_dom);
 	mon_comp = l3_dom->mon_comp[eventid];
 
 	reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmid);
@@ -1638,7 +1638,7 @@ static int mpam_resctrl_setup_ctrl_domain(unsigned int cpu,
 
 static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 					 struct rdt_resource *r,
-					 struct mpam_resctrl_dom *dom)
+					 struct mpam_resctrl_mon_dom *dom)
 {
 	struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
 	struct mpam_component *any_mon_comp = NULL;
@@ -1681,53 +1681,6 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 	return 0;
 }
 
-static void mpam_resctrl_alloc_domain(unsigned int cpu,
-				      struct mpam_resctrl_res *res)
-{
-	int err;
-	struct mpam_resctrl_dom *dom;
-	struct mpam_class *class = res->class;
-	struct mpam_component *comp;
-	struct rdt_resource *r = &res->resctrl_res;
-
-	lockdep_assert_held(&domain_list_lock);
-
-	comp = find_component(class, cpu);
-	/* class has no component for this CPU */
-	if (WARN_ON_ONCE(!comp))
-		return;
-
-	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
-	if (!dom)
-		return;
-
-	if (r->alloc_capable) {
-		err = mpam_resctrl_setup_ctrl_domain(cpu, r, comp, dom);
-		if (err)
-			goto free_domain;
-	} else {
-		pr_debug("Skipped control domain online - no controls\n");
-	}
-
-	if (r->mon_capable) {
-		err = mpam_resctrl_setup_mon_domain(cpu, r, dom);
-		if (err)
-			goto offline_ctrl_domain;
-	} else {
-		pr_debug("Skipped monitor domain online - no monitors\n");
-	}
-
-	return;
-
-offline_ctrl_domain:
-	if (r->alloc_capable) {
-		mpam_resctrl_offline_domain_hdr(cpu, &dom->resctrl_ctrl_dom.hdr);
-		resctrl_offline_ctrl_domain(r, &dom->resctrl_ctrl_dom);
-	}
-free_domain:
-	kfree(dom);
-}
-
 /*
  * We know all the monitors are associated with the L3, even if there are no
  * controls and therefore no control component. Find the cache-id for the CPU
@@ -1735,10 +1688,10 @@ static void mpam_resctrl_alloc_domain(unsigned int cpu,
  * This relies on mpam_resctrl_pick_domain_id() using the L3 cache-id
  * for anything that is not a cache.
  */
-static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
+static struct mpam_resctrl_mon_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
 {
 	int cache_id;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_mon_dom *dom;
 	struct mpam_resctrl_res *l3 = &mpam_resctrl_controls[RDT_RESOURCE_L3];
 
 	lockdep_assert_cpus_held();
@@ -1758,7 +1711,7 @@ static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
 }
 
 static struct mpam_resctrl_dom *
-mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
+mpam_resctrl_get_ctrl_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 {
 	struct mpam_resctrl_dom *dom;
 	struct rdt_resource *r = &res->resctrl_res;
@@ -1770,11 +1723,97 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 			return dom;
 	}
 
-	if (r->rid != RDT_RESOURCE_L3)
-		return NULL;
+	return NULL;
+}
+
+static void mpam_resctrl_add_cpu_ctrl_domain(unsigned int cpu,
+					     struct mpam_resctrl_res *res)
+{
+	struct rdt_resource *r = &res->resctrl_res;
+	struct mpam_resctrl_dom *dom;
+	struct mpam_component *comp;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, res);
+	if (dom) {
+		mpam_resctrl_online_domain_hdr(cpu, &dom->resctrl_ctrl_dom.hdr);
+		return;
+	}
+
+	comp = find_component(res->class, cpu);
+	/* class has no component for this CPU */
+	if (WARN_ON_ONCE(!comp))
+		return;
+
+	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
+	if (!dom)
+		return;
 
-	/* Search the mon domain list too - needed on monitor only platforms. */
-	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
+	if (mpam_resctrl_setup_ctrl_domain(cpu, r, comp, dom))
+		kfree(dom);
+}
+
+static void mpam_resctrl_add_cpu_mon_domain(unsigned int cpu,
+					    struct mpam_resctrl_res *res)
+{
+	struct rdt_resource *r = &res->resctrl_res;
+	struct mpam_resctrl_mon_dom *dom;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	dom = mpam_resctrl_get_mon_domain_from_cpu(cpu);
+	if (dom) {
+		mpam_resctrl_online_domain_hdr(cpu, &dom->resctrl_mon_dom.hdr);
+		return;
+	}
+
+	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
+	if (!dom)
+		return;
+
+	if (mpam_resctrl_setup_mon_domain(cpu, r, dom))
+		kfree(dom);
+}
+
+static void mpam_resctrl_remove_cpu_ctrl_domain(unsigned int cpu,
+						struct mpam_resctrl_res *res)
+{
+	struct rdt_resource *r = &res->resctrl_res;
+	struct mpam_resctrl_dom *dom;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	/* The domain may be missing if its setup failed. */
+	dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, res);
+	if (!dom)
+		return;
+
+	if (!mpam_resctrl_offline_domain_hdr(cpu, &dom->resctrl_ctrl_dom.hdr))
+		return;
+
+	resctrl_offline_ctrl_domain(r, &dom->resctrl_ctrl_dom);
+	kfree(dom);
+}
+
+static void mpam_resctrl_remove_cpu_mon_domain(unsigned int cpu,
+					       struct mpam_resctrl_res *res)
+{
+	struct rdt_resource *r = &res->resctrl_res;
+	struct mpam_resctrl_mon_dom *dom;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	/* The domain may be missing if its setup failed. */
+	dom = mpam_resctrl_get_mon_domain_from_cpu(cpu);
+	if (!dom)
+		return;
+
+	if (!mpam_resctrl_offline_domain_hdr(cpu, &dom->resctrl_mon_dom.hdr))
+		return;
+
+	resctrl_offline_mon_domain(r, &dom->resctrl_mon_dom.hdr);
+	kfree(dom);
 }
 
 void mpam_resctrl_online_cpu(unsigned int cpu)
@@ -1784,33 +1823,21 @@ void mpam_resctrl_online_cpu(unsigned int cpu)
 
 	guard(mutex)(&domain_list_lock);
 	for_each_mpam_resctrl_control(res, rid) {
-		struct mpam_resctrl_dom *dom;
 		struct rdt_resource *r = &res->resctrl_res;
 
 		if (!res->class)
 			continue;	// dummy_resource;
 
-		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
-		if (!dom) {
-			/*
-			 * On failure the CPU is left without a domain for this
-			 * resource, which mpam_resctrl_offline_cpu() tolerates.
-			 * resctrl_online_cpu() still adds the CPU to the default
-			 * group because the CPU is online and runs tasks.
-			 */
-			mpam_resctrl_alloc_domain(cpu, res);
-		} else {
-			if (r->alloc_capable) {
-				struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
-
-				mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
-			}
-			if (r->mon_capable) {
-				struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
-
-				mpam_resctrl_online_domain_hdr(cpu, &mon_d->hdr);
-			}
-		}
+		/*
+		 * A domain that fails to be set up leaves the CPU without that
+		 * domain, which mpam_resctrl_offline_cpu() tolerates.
+		 * resctrl_online_cpu() still adds the CPU to the default group
+		 * because the CPU is online and runs tasks.
+		 */
+		if (r->alloc_capable)
+			mpam_resctrl_add_cpu_ctrl_domain(cpu, res);
+		if (r->mon_capable)
+			mpam_resctrl_add_cpu_mon_domain(cpu, res);
 	}
 
 	resctrl_online_cpu(cpu);
@@ -1825,40 +1852,15 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 
 	guard(mutex)(&domain_list_lock);
 	for_each_mpam_resctrl_control(res, rid) {
-		struct mpam_resctrl_dom *dom;
-		struct rdt_l3_mon_domain *mon_d;
-		struct rdt_ctrl_domain *ctrl_d;
-		bool ctrl_dom_empty, mon_dom_empty;
 		struct rdt_resource *r = &res->resctrl_res;
 
 		if (!res->class)
 			continue;	// dummy resource
 
-		/* The domain may be missing if its setup failed. */
-		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
-		if (!dom)
-			continue;
-
-		if (r->alloc_capable) {
-			ctrl_d = &dom->resctrl_ctrl_dom;
-			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
-			if (ctrl_dom_empty)
-				resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl_d);
-		} else {
-			ctrl_dom_empty = true;
-		}
-
-		if (r->mon_capable) {
-			mon_d = &dom->resctrl_mon_dom;
-			mon_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
-			if (mon_dom_empty)
-				resctrl_offline_mon_domain(&res->resctrl_res, &mon_d->hdr);
-		} else {
-			mon_dom_empty = true;
-		}
-
-		if (ctrl_dom_empty && mon_dom_empty)
-			kfree(dom);
+		if (r->alloc_capable)
+			mpam_resctrl_remove_cpu_ctrl_domain(cpu, res);
+		if (r->mon_capable)
+			mpam_resctrl_remove_cpu_mon_domain(cpu, res);
 	}
 }
 
-- 
2.55.0

