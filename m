Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284363;
	b=wQo8KWCzfk9DDcIVbeVDDmgFK7rLasLyUFSppNW/7fvicjZIKrPvPE3ll9XSI5HXgWvJ
	 4d3pnHWOx5RZix4DudjUJJHzhqwNEyaTLtYP8Z/cQGvpW1WC6GtcVB6ONpQ0HxlSISZmI
	 1L+8KzlwVNy4y2BZjgM6HVf8vQPsedGilXatP7MCxSd7IyZGtmz5c0fkFR+Rx2dLObqKL
	 vJoIm0KGEkJCCN7QqVv5DFoxuZS1t2M1PgeiEU55sZz9ehGy//0iwocNx9zQ65hqzOgp6
	 lPcZ8PQXR4lgFyD++L7++V4rcOwuABfHoYzcAsc5L7d+SQkEs5SpXIpc6pKCWtJ2Z+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284363;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uNkodtGfaGvK/RnG0tWJFxtQ8S5QNvRorQlF1x98Yas=;
	b=vwf2stn0IOuBRe0vxAXlkaWwgi2NmHkYLBkSB9QfubY/iO+w1wpnM00Bmi9aD45j9YNm
	 G/7w1ayKI/c+9toY43jACaeRCxiq2hxPxnAwRhaup3imkDKN/w1vGnsUnFhZHMEI9G1hh
	 Hfx+Pp6pVhegKQOypHnVnIRCzGFmiEYXvtRVzk6ACxizIM+g8h2YRPANqh4pVawHK+13Z
	 0zNtNuLCl1UCylnfyN7FS2ICvhn0ZD+V//n2Be2K2Q9ATRtGkyKLtY/6G+swoEIAUsMRP
	 oaOr+Yy6pHcxBROffWAmMN6mYRLnCVe6bq+nKezwhgSV5umH4cmKzuPiw4BR2l0YK/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=E5c6rLkH;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B57E60A3816
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B57E60A3816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=E5c6rLkH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284361; x=1825820361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XdIHGTi4CqhY3nClCkwX8TaottA7wlWhLKc1dTggAuw=;
  b=E5c6rLkHabkAWkywx+7+Ko0oL5Rr/gdI6IYgPwhXbHflH5L8eh1d/nRh
   4wh2A8E0gq9gATsEpTqvGBN322mm01vOK8KmdXB5qNqlg8NAQeethVOk5
   yIZ2mLWRVdCRHno6ghtQI4+3RcbInxckuL8dYs0WUGPE/NZBrQzy4Ni0F
   xyrx2HTBP2n0X/+i3v/hIZr4ulfuNXwjawNTuLnNg8CDgua17JUnY7hQr
   9rBpvA2OTgvTaxcSV4li9zlRH7Xv524albDeD0NmxSuB42K6AD8mH0mii
   C0PPwKCQzG2p5rXD0jK4iiQsvUOw734Y6GIRbMWAHqkGouzDM5s0XsRyU
   g==;
X-CSE-ConnectionGUID: /1+v2L7aS/6xQRwZ6aaA7w==
X-CSE-MsgGUID: ehr3Fa77QNSML4hIWtRXXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901346"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901346"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
X-CSE-ConnectionGUID: bTsbRN/3QQW59vmY1UC2vQ==
X-CSE-MsgGUID: 66zk+XnuRym5L/Lgq4xe/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856927"
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
Subject: [PATCH v3 7/8] arm_mpam: resctrl: Give the monitoring domain its own structure
Date: Mon,  9 Nov 2026 20:19:07 -0800
Message-ID: <1fb52d1c2b854e917fa14240f8f0905cd7ebc850.1794283825.git.reinette.chatre@intel.com>
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

Fail setting up the monitoring domain, with a warning, if the components
backing its events do not all cover the same CPUs, since an event's
counts would then not belong to the CPUs the domain represents. Compare
each component with the one found before it, instead of naming the
events, so that the check applies to any monitoring event.

Drop the debug messages about resources without controls or monitors.
They reported which of the two domains in the shared structure was left
unused, which no longer applies now that each domain type has its own
structure.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
Changes since RFC v2:
- Add Jinjie's Reviewed-by tag.
- Add Jinjie's Tested-by tag.
- WARN when control or monitoring domain allocation fails. (Ben)
- Squash "arm_mpam: resctrl: Require monitoring components to cover
  the same CPUs" and "arm_mpam: resctrl: Update the comment on
  monitoring domain setup". (Ben)
- Update the mpam_resctrl_get_mon_domain_from_cpu() comment that still
  referred to the control component.
---
 drivers/resctrl/mpam_internal.h |   5 +-
 drivers/resctrl/mpam_resctrl.c  | 242 +++++++++++++++++---------------
 2 files changed, 128 insertions(+), 119 deletions(-)

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
index ca90b293b697..263bbbc27dac 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -516,7 +516,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
 			   void *arch_priv, u64 *val, void *arch_mon_ctx)
 {
-	struct mpam_resctrl_dom *l3_dom;
+	struct mpam_resctrl_mon_dom *l3_dom;
 	struct mpam_component *mon_comp;
 	u32 mon_idx = *(u32 *)arch_mon_ctx;
 	enum mpam_device_features mon_type;
@@ -530,7 +530,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	if (eventid >= QOS_NUM_EVENTS || !mon->class)
 		return -EINVAL;
 
-	l3_dom = container_of(hdr, struct mpam_resctrl_dom, resctrl_mon_dom.hdr);
+	l3_dom = container_of(hdr, struct mpam_resctrl_mon_dom, resctrl_mon_dom.hdr);
 	mon_comp = l3_dom->mon_comp[eventid];
 
 	if (eventid != QOS_L3_OCCUP_EVENT_ID)
@@ -558,7 +558,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 static struct mpam_component *find_mbwu_mon_comp(struct rdt_l3_mon_domain *d,
 						 enum resctrl_event_id eventid)
 {
-	struct mpam_resctrl_dom *l3_dom;
+	struct mpam_resctrl_mon_dom *l3_dom;
 	struct mpam_resctrl_mon *mon;
 
 	if (!mpam_is_enabled())
@@ -568,7 +568,7 @@ static struct mpam_component *find_mbwu_mon_comp(struct rdt_l3_mon_domain *d,
 	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
 		return ERR_PTR(-EINVAL);
 
-	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
+	l3_dom = container_of(d, struct mpam_resctrl_mon_dom, resctrl_mon_dom);
 
 	return l3_dom->mon_comp[eventid];
 }
@@ -1663,7 +1663,7 @@ static int mpam_resctrl_setup_ctrl_domain(unsigned int cpu,
 
 static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 					 struct rdt_resource *r,
-					 struct mpam_resctrl_dom *dom)
+					 struct mpam_resctrl_mon_dom *dom)
 {
 	struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
 	struct mpam_component *any_mon_comp = NULL;
@@ -1672,11 +1672,12 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 	int err;
 
 	/*
-	 * Even if the monitor domain is backed by a different
-	 * component, the L3 component IDs need to be used... only
-	 * there may be no ctrl_comp for the L3.
-	 * Search each event's class list for a component with
-	 * overlapping CPUs and set up the dom->mon_comp array.
+	 * The monitoring domain takes the L3 cache ID as its ID even when its
+	 * events are backed by components of other classes, see
+	 * mpam_resctrl_pick_domain_id().
+	 * Find the component of each event's class that contains the CPU and
+	 * set up the dom->mon_comp array. All these components must cover the
+	 * same CPUs.
 	 */
 
 	for_each_mpam_resctrl_mon(mon, eventid) {
@@ -1689,6 +1690,12 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
 		if (WARN_ON_ONCE(!mon_comp))
 			return -EFAULT;
 
+		/* All components of a monitoring domain cover the same CPUs */
+		if (WARN_ON_ONCE(any_mon_comp &&
+				 !cpumask_equal(&any_mon_comp->affinity,
+						&mon_comp->affinity)))
+			return -EFAULT;
+
 		dom->mon_comp[eventid] = mon_comp;
 		any_mon_comp = mon_comp;
 	}
@@ -1706,64 +1713,16 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
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
-	if (WARN_ON_ONCE(!dom))
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
- * We know all the monitors are associated with the L3, even if there are no
- * controls and therefore no control component. Find the cache-id for the CPU
+ * All the monitors are associated with the L3. Find the cache-id for the CPU
  * and use that to search for existing resctrl domains.
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
@@ -1783,7 +1742,7 @@ static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
 }
 
 static struct mpam_resctrl_dom *
-mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
+mpam_resctrl_get_ctrl_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 {
 	struct mpam_resctrl_dom *dom;
 	struct rdt_resource *r = &res->resctrl_res;
@@ -1795,11 +1754,97 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
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
 
-	/* Search the mon domain list too - needed on monitor only platforms. */
-	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
+	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
+	if (WARN_ON_ONCE(!dom))
+		return;
+
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
+	if (WARN_ON_ONCE(!dom))
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
@@ -1809,33 +1854,21 @@ void mpam_resctrl_online_cpu(unsigned int cpu)
 
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
@@ -1850,40 +1883,15 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 
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
2.56.0

