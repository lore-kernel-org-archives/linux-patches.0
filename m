Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA942E763F
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956596; cv=none; b=FMs3/kR+B/UeVZeKO8IPcJM1sHdzXMYq2wd1aPi3kNJ8F19xQZwDM7dN9lnt/SWad3odZxJxlK9CgGE5E/yCWHqdsZB4RKxp6zC/O2EL+1HOiIoMj3UJw0MEPOLAlA7ZAXgQ+fw2lOfALfK9FKqbi+Khm0ar6ieepLRigW59+PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956596; c=relaxed/simple;
	bh=efY5A4hn1YAZyIj3uRHRsm5NdIHqw/pWvjOTIdIQwr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkLitgx10jEYWwCjlq3l4f7r1hp4SIdp57JsC7bUcYgOtkBoAIS97EiqhqAMRiQO8aV3N9KZWE9EqzlXDxvDSjbbBEaXYzFbJqf9AxGPB7U0//S36WIe/Ea+m3d+ACM5SBO3aw9tG/G3lUhcM2YaGtREDy2SeKDe1vbM6/XEtj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n2Puj+um; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n2Puj+um"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956595; x=1782492595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=efY5A4hn1YAZyIj3uRHRsm5NdIHqw/pWvjOTIdIQwr0=;
  b=n2Puj+umPLdv6HNifvgZlaxm84Gnr6jwMsGUfMLEangYkTr4dUp6kBeo
   xcBDeS6RKLxM86UaqV7vpnG+uzQJArKPe+kncjVue7XgLhflNs0gh9qsS
   0J1otqp7WN2W/VPWXBHqTWW6E7OlcODXsWkQWmALnIhZYa1EtJbFyfxe0
   DxZaayrYaMmdmd1PoCMyD5Su/9T3Da+id/fxR2kuIUEWgt476+jJ47Fvh
   9p4kIQRB0/I376YLTyOpVsExwMuoIR6/5+5bx1jF8BdIGa95HYWTUft2A
   h4VdiF+yLBRxPePPliDxaBM9tf2+ni4UNMAQDY4RG8GhGbw2d+bs1tn+C
   Q==;
X-CSE-ConnectionGUID: Wra03debRfuHf+MM9/lWyQ==
X-CSE-MsgGUID: +wMUvQ4sQFayKyhH8I1fXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136347"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136347"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:53 -0700
X-CSE-ConnectionGUID: jWMStVZTRquUH4aO6oWWPg==
X-CSE-MsgGUID: c1/2gDItRMeAvoyGZAoxMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069167"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:52 -0700
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
Subject: [PATCH v6 05/30] x86,fs/resctrl: Improve domain type checking
Date: Thu, 26 Jun 2025 09:49:14 -0700
Message-ID: <20250626164941.106341-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rdt_domain_hdr structure is used in both control and monitor
domain structures to provide common methods for operations such as
adding a CPU to a domain, removing a CPU from a domain, accessing
the mask of all CPUs in a domain.

The "type" field provides a simple check whether a domain is a
control or monitor domain so that programming errors operating
on domains will be quickly caught.

To prepare for additional domain types that depend on the rdt_resource
to which they are connected add the resource id into the header
and check that in addition to the type.

At this point all monitoring events are tied to the RDT_RESOURCE_L3
resource. So hard code the check in rdtgroup_mondata_show() to
that resource id.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  9 +++++++++
 arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++----
 fs/resctrl/ctrlmondata.c           |  2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 478d7a935ca3..dc7ccd60e8c2 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -131,15 +131,24 @@ enum resctrl_domain_type {
  * @list:		all instances of this resource
  * @id:			unique id for this instance
  * @type:		type of this instance
+ * @rid:		index of resource for this domain
  * @cpu_mask:		which CPUs share this resource
  */
 struct rdt_domain_hdr {
 	struct list_head		list;
 	int				id;
 	enum resctrl_domain_type	type;
+	enum resctrl_res_level		rid;
 	struct cpumask			cpu_mask;
 };
 
+static inline bool domain_header_is_valid(struct rdt_domain_hdr *hdr,
+					  enum resctrl_domain_type type,
+					  enum resctrl_res_level rid)
+{
+	return !WARN_ON_ONCE(hdr->type != type || hdr->rid != rid);
+}
+
 /**
  * struct rdt_ctrl_domain - group of CPUs sharing a resctrl control resource
  * @hdr:		common header for different domain types
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index fbf019c1ff11..420e4eb7c160 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -459,7 +459,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->ctrl_domains, id, &add_pos);
 	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
+		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 			return;
 		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 
@@ -476,6 +476,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_CTRL_DOMAIN;
+	d->hdr.rid = r->rid;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
 	rdt_domain_reconfigure_cdp(r);
@@ -515,7 +516,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
 	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 			return;
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 
@@ -530,6 +531,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_MON_DOMAIN;
+	d->hdr.rid = r->rid;
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
@@ -586,7 +588,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
+	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
@@ -632,7 +634,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_mon_domain, hdr);
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index ad7ffc6acf13..cdb4bc8baa99 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -643,7 +643,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 * the resource to find the domain with "domid".
 		 */
 		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
-		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+		if (!hdr || !domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)) {
 			ret = -ENOENT;
 			goto out;
 		}
-- 
2.49.0

