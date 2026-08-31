Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B593BB131
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788220456; cv=none; b=L57dN3h/K8fQqDNmVngushUX1rrjbFpcAvAyrGMuCQSrMnCfqcAQonhlzDJxU2eW5ojXaf5xtixV8JhxsyMBa1Wufl8BonlmhqeDY5vCXyoxYFH3Nd3pieVD5cMBkGVN4Xeq3BXQv95Iaj76F2vSVRl5zUZLmDWNnzUKQ5bPhuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788220456; c=relaxed/simple;
	bh=Z7y/BV/kJrj9DjtSS2VYrqx6mra094jbvlaK4c6v1OE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lxs7UXYF8P0Kp+vMsp/iyFXkwq4VfmkVCho2pMV7nROcGL+H2SDirO7yLXyejCh+DyJAS+U3fArH+ohi88O4jr9Bi4ShNaWHCGGWsUz1blo+B4iFymFkfjWQ7FrdhpyrYBHJmzFiyQbzB7JDZzf380iB9XJ/1njT3UXKzH4dXAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kU0MRzdm; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kU0MRzdm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788220453; x=1819756453;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z7y/BV/kJrj9DjtSS2VYrqx6mra094jbvlaK4c6v1OE=;
  b=kU0MRzdmBW37CXYY6F+1cMDRl6aus0aKSzOU0JMoXnY9TsvwWMdf5n+3
   7TCtWrMU+bGnwSYj1lx6H8EL9MSFaUkxACaQe63MHw80ZIPSy+hip5YTj
   LSnz6mE2GpZdh5AuWDBwEzdC63j5ltuFfFepSPSmoIaSC2lxBPb8pqjsQ
   Xs/Vdoqp6SzDNtsn4IRzcedkbIpFu31CHVxa6iV9HLuQ7pMzdiFmu7mgH
   8RzwQOQXrEFJl+gu+hldprdWM+LCQOOvVItVjgINwU+tC3FFDVBoPQmzi
   shjKe/SaJ3EKew7XWl3mIXB0IO4GrD8Lz3clMFHVzVPK5G7dp+bSdxolQ
   Q==;
X-CSE-ConnectionGUID: NBGWMLLoSYOO1+chLGCT5A==
X-CSE-MsgGUID: GpnOsmXNQoWTo9/tuFswwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="88490193"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="88490193"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 16:54:12 -0700
X-CSE-ConnectionGUID: +jBDkSDpRMmdxq00eS5E+w==
X-CSE-MsgGUID: whqTzwLoS/K8O13towmAQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="269514458"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 16:54:12 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com
Cc: tony.luck@intel.com,
	babu.moger@amd.com,
	yu.c.chen@intel.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
Date: Mon, 31 Aug 2026 16:54:07 -0700
Message-ID: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A single struct mpam_resctrl_dom instance represents both an allocation and
monitor domain. When a system supports allocation and monitoring a single
struct mpam_resctrl_dom instance is created and then added to both the
monitor and control domain lists via
mpam_resctrl_dom::rdt_ctrl_domain::rdt_domain_hdr::list_head
and mpam_resctrl_dom::rdt_l3_mon_domain::rdt_domain_hdr::list_head
respectively.

Representing both allocation and monitoring domains with a single
architecture domain requires that allocation and monitoring be done at the
same scope and also requires a resource to have 1:1 support for an allocation
control and monitoring. The latter means that when a resource supports
multiple controls for allocation of a resource, for example a "min" bandwidth
control as well as a "max" bandwidth control for memory bandwidth allocation,
then each domain supporting each allocation control needs a matching
monitoring domain. This does not accurately represent the resource
capabilities.

Split MPAM allocation and monitoring domain management to enable a resource
to support multiple allocation controls. As an initial and knowingly
inefficient approach, duplicate struct mpam_resctrl_dom between the
monitoring and control lists while only initializing the relevant member
structs.

The goal of this conservative approach is to use something that can only
be compile tested by me to learn from MPAM folks on what the best approach
should be for MPAM to support multiple allocation controls.

This patch is extracted from the "Generic schema description" PoC [1] that,
among its various goals, aim to add support for MPAM's multiple controls
to resctrl.

This has only been compile tested by me but Fenghua's work to enable
MPAM's CPU-less NUMA nodes [2] is using it as a baseline.

I did consider a new layout as below but there seems to be a contradiction
in mpam_resctrl_alloc_domain() where domain addition for allocation as well
as monitoring domains unconditionally fails if there is no "ctrl_comp" while
a comment when adding a monitoring domain states "there may be no ctrl_comp
for the L3".
	struct mpam_resctrl_mon_dom {
		struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
		struct rdt_l3_mon_domain	resctrl_mon_dom;
	}

	struct mpam_resctrl_ctrl_dom {
		struct mpam_component		*ctrl_comp;
		struct rdt_ctrl_domain		resctrl_ctrl_dom;
	};

Any feedback is appreciated.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/ # [1]
Link: https://lore.kernel.org/lkml/20260831172245.42253-1-fenghuay@nvidia.com/ # [2]
---
- Extracted from "generic schema description"
  https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/

Changes since extract from PoC:
- Rebased on v7.3-rc1
- Re-wrote changelog
- Return NULL instead of ERR_PTR() when searching for monitoring domain
  to ensure the if (!dom) check works.
---
 drivers/resctrl/mpam_resctrl.c | 207 +++++++++++++++++++--------------
 1 file changed, 121 insertions(+), 86 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 9d223057953a..c888773f3d03 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1616,11 +1616,10 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
 }
 
 static struct mpam_resctrl_dom *
-mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
+mpam_resctrl_alloc_ctrl_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 {
 	int err;
 	struct mpam_resctrl_dom *dom;
-	struct rdt_l3_mon_domain *mon_d;
 	struct rdt_ctrl_domain *ctrl_d;
 	struct mpam_class *class = res->class;
 	struct mpam_component *comp_iter, *ctrl_comp;
@@ -1628,6 +1627,9 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 
 	lockdep_assert_held(&domain_list_lock);
 
+	if (!r->alloc_capable)
+		return ERR_PTR(-EINVAL);
+
 	ctrl_comp = NULL;
 	guard(srcu)(&mpam_srcu);
 	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
@@ -1646,70 +1648,97 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	if (!dom)
 		return ERR_PTR(-ENOMEM);
 
-	if (r->alloc_capable) {
-		dom->ctrl_comp = ctrl_comp;
+	dom->ctrl_comp = ctrl_comp;
 
-		ctrl_d = &dom->resctrl_ctrl_dom;
-		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
-		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
-		err = resctrl_online_ctrl_domain(r, ctrl_d);
-		if (err)
-			goto free_domain;
+	ctrl_d = &dom->resctrl_ctrl_dom;
+	mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
+	ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
+	err = resctrl_online_ctrl_domain(r, ctrl_d);
+	if (err)
+		goto free_domain;
 
-		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
-	} else {
-		pr_debug("Skipped control domain online - no controls\n");
-	}
+	mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
 
-	if (r->mon_capable) {
-		struct mpam_component *any_mon_comp = NULL;
-		struct mpam_resctrl_mon *mon;
-		enum resctrl_event_id eventid;
+	return dom;
 
-		/*
-		 * Even if the monitor domain is backed by a different
-		 * component, the L3 component IDs need to be used... only
-		 * there may be no ctrl_comp for the L3.
-		 * Search each event's class list for a component with
-		 * overlapping CPUs and set up the dom->mon_comp array.
-		 */
+free_domain:
+	kfree(dom);
+	dom = ERR_PTR(err);
+
+	return dom;
+}
+
+static struct mpam_resctrl_dom *
+mpam_resctrl_alloc_mon_domain(unsigned int cpu, struct mpam_resctrl_res *res)
+{
+	int err;
+	struct mpam_resctrl_dom *dom;
+	struct rdt_l3_mon_domain *mon_d;
+	struct mpam_class *class = res->class;
+	struct mpam_component *comp_iter, *ctrl_comp;
+	struct rdt_resource *r = &res->resctrl_res;
+	struct mpam_component *any_mon_comp = NULL;
+	struct mpam_resctrl_mon *mon;
+	enum resctrl_event_id eventid;
 
-		for_each_mpam_resctrl_mon(mon, eventid) {
-			struct mpam_component *mon_comp;
+	lockdep_assert_held(&domain_list_lock);
 
-			if (!mon->class)
-				continue;       // dummy resource
+	if (!r->mon_capable)
+		return ERR_PTR(-EINVAL);
 
-			mon_comp = find_component(mon->class, cpu);
-			dom->mon_comp[eventid] = mon_comp;
-			if (mon_comp)
-				any_mon_comp = mon_comp;
-		}
-		if (!any_mon_comp) {
-			WARN_ON_ONCE(0);
-			err = -EFAULT;
-			goto offline_ctrl_domain;
+	ctrl_comp = NULL;
+	guard(srcu)(&mpam_srcu);
+	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
+				 srcu_read_lock_held(&mpam_srcu)) {
+		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
+			ctrl_comp = comp_iter;
+			break;
 		}
+	}
 
-		mon_d = &dom->resctrl_mon_dom;
-		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
-		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
-		err = resctrl_online_mon_domain(r, &mon_d->hdr);
-		if (err)
-			goto offline_ctrl_domain;
+	/* class has no component for this CPU */
+	if (WARN_ON_ONCE(!ctrl_comp))
+		return ERR_PTR(-EINVAL);
 
-		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
-	} else {
-		pr_debug("Skipped monitor domain online - no monitors\n");
+	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
+	if (!dom)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Even if the monitor domain is backed by a different
+	 * component, the L3 component IDs need to be used... only
+	 * there may be no ctrl_comp for the L3.
+	 * Search each event's class list for a component with
+	 * overlapping CPUs and set up the dom->mon_comp array.
+	 */
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
 	}
+	if (!any_mon_comp) {
+		WARN_ON_ONCE(0);
+		err = -EFAULT;
+		goto free_domain;
+	}
+
+	mon_d = &dom->resctrl_mon_dom;
+	mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
+	mon_d->hdr.type = RESCTRL_MON_DOMAIN;
+	err = resctrl_online_mon_domain(r, &mon_d->hdr);
+	if (err)
+		goto free_domain;
+
+	mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
 
 	return dom;
 
-offline_ctrl_domain:
-	if (r->alloc_capable) {
-		mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
-		resctrl_offline_ctrl_domain(r, ctrl_d);
-	}
 free_domain:
 	kfree(dom);
 	dom = ERR_PTR(err);
@@ -1724,21 +1753,25 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
  * This relies on mpam_resctrl_pick_domain_id() using the L3 cache-id
  * for anything that is not a cache.
  */
-static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
+static struct mpam_resctrl_dom *
+mpam_resctrl_get_mon_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 {
 	int cache_id;
 	struct mpam_resctrl_dom *dom;
-	struct mpam_resctrl_res *l3 = &mpam_resctrl_controls[RDT_RESOURCE_L3];
+	struct rdt_resource *r = &res->resctrl_res;
 
 	lockdep_assert_cpus_held();
 
-	if (!l3->class)
+	if (r->rid != RDT_RESOURCE_L3)
+		return NULL;
+
+	if (!res->class)
 		return NULL;
 	cache_id = get_cpu_cacheinfo_id(cpu, 3);
 	if (cache_id < 0)
 		return NULL;
 
-	list_for_each_entry_rcu(dom, &l3->resctrl_res.mon_domains, resctrl_mon_dom.hdr.list) {
+	list_for_each_entry_rcu(dom, &res->resctrl_res.mon_domains, resctrl_mon_dom.hdr.list) {
 		if (dom->resctrl_mon_dom.hdr.id == cache_id)
 			return dom;
 	}
@@ -1747,7 +1780,7 @@ static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
 }
 
 static struct mpam_resctrl_dom *
-mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
+mpam_resctrl_get_ctrl_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 {
 	struct mpam_resctrl_dom *dom;
 	struct rdt_resource *r = &res->resctrl_res;
@@ -1759,11 +1792,7 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 			return dom;
 	}
 
-	if (r->rid != RDT_RESOURCE_L3)
-		return NULL;
-
-	/* Search the mon domain list too - needed on monitor only platforms. */
-	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
+	return NULL;
 }
 
 int mpam_resctrl_online_cpu(unsigned int cpu)
@@ -1779,18 +1808,25 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 		if (!res->class)
 			continue;	// dummy_resource;
 
-		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
-		if (!dom) {
-			dom = mpam_resctrl_alloc_domain(cpu, res);
-			if (IS_ERR(dom))
-				return PTR_ERR(dom);
-		} else {
-			if (r->alloc_capable) {
+		if (r->alloc_capable) {
+			dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, res);
+			if (!dom) {
+				dom = mpam_resctrl_alloc_ctrl_domain(cpu, res);
+				if (IS_ERR(dom))
+					return PTR_ERR(dom);
+			} else {
 				struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
 
 				mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
 			}
-			if (r->mon_capable) {
+		}
+		if (r->mon_capable) {
+			dom = mpam_resctrl_get_mon_domain_from_cpu(cpu, res);
+			if (!dom) {
+				dom = mpam_resctrl_alloc_mon_domain(cpu, res);
+				if (IS_ERR(dom))
+					return PTR_ERR(dom);
+			} else {
 				struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
 
 				mpam_resctrl_online_domain_hdr(cpu, &mon_d->hdr);
@@ -1815,36 +1851,35 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 		struct mpam_resctrl_dom *dom;
 		struct rdt_l3_mon_domain *mon_d;
 		struct rdt_ctrl_domain *ctrl_d;
-		bool ctrl_dom_empty, mon_dom_empty;
+		bool dom_empty;
 		struct rdt_resource *r = &res->resctrl_res;
 
 		if (!res->class)
 			continue;	// dummy resource
 
-		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
-		if (WARN_ON_ONCE(!dom))
-			continue;
-
 		if (r->alloc_capable) {
+			dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, res);
+			if (WARN_ON_ONCE(!dom))
+				continue;
 			ctrl_d = &dom->resctrl_ctrl_dom;
-			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
-			if (ctrl_dom_empty)
+			dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
+			if (dom_empty) {
 				resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl_d);
-		} else {
-			ctrl_dom_empty = true;
+				kfree(dom);
+			}
 		}
 
 		if (r->mon_capable) {
+			dom = mpam_resctrl_get_mon_domain_from_cpu(cpu, res);
+			if (WARN_ON_ONCE(!dom))
+				continue;
 			mon_d = &dom->resctrl_mon_dom;
-			mon_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
-			if (mon_dom_empty)
+			dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
+			if (dom_empty) {
 				resctrl_offline_mon_domain(&res->resctrl_res, &mon_d->hdr);
-		} else {
-			mon_dom_empty = true;
+				kfree(dom);
+			}
 		}
-
-		if (ctrl_dom_empty && mon_dom_empty)
-			kfree(dom);
 	}
 }
 
-- 
2.55.0

