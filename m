Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6C022A1ED
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069256; cv=none; b=C2uXHFNxoC6uvU8gIvs7R9C3RmqSmU1tk1Y+mPlR/VkFxC1nOTSNUehByKiB/1O2vzIvOKFdqQe/+lCeZkqTn3hxI+KZU1vnal6filbEhjtiN93B5jFFLu/EBmsDgWrYbNXw77jt+FJGfoktqTt5zXrGid8h7jz7JUhU2qg2CJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069256; c=relaxed/simple;
	bh=fOflmPEON7VNLFevfHomSgOTaVeafcUEUr7FELTDLyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSFj6TTrmjkRafX7ebwrHEAvtRAMiLsnOjEU2amYf0Z53IpRRdtimTY3Xjn8fgWW7T7wyGwgO7DqCialESkb3eSXqeRXt091eOcF9wxaD7f3F6ae1OjRVcWr6FTwPAS3t2fwma8jpUT9WtadE+M4ZWPzRpqMcVwfjbjayWKEEzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Btk0WyfI; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Btk0WyfI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069254; x=1775605254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fOflmPEON7VNLFevfHomSgOTaVeafcUEUr7FELTDLyw=;
  b=Btk0WyfIn9R+62rbrUetpFJEnYusNpZp+8KssLV1+2peeKKrz80O0zOf
   Gnt5vrygJ4SWeoqLd+v7FG+XA27/pnudjbxUDsAzyvuf2seeibMZg2fhS
   ehkmX46LStpsWqHlGLI47lrW6USO6tSjapeSt6nXZd7Kloe1kYd8o7QgT
   xmnXDYWOqkhhdXh2zuaU4nHlak/oYddFEC+cFaoL+wJ+9KppD60EOIZlF
   ji8LhRwacMnMoeemfVM8u7orlF2KdMe07mTE/ayZPiD377JnILzmxKopO
   7cnMHCmJgjgtoooe67YeJ3UDsg5KU2oaMGdGU786Ujh2sgGJTIpl6XurP
   g==;
X-CSE-ConnectionGUID: 2GCLj8eFQxiP9yGyORH6eg==
X-CSE-MsgGUID: obcP4XwrQo+gJx66VYoYjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193152"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193152"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:47 -0700
X-CSE-ConnectionGUID: K0UFichZQZ+MXLlBko4r0g==
X-CSE-MsgGUID: Jt0TBXEUQsC+NQoujNg68g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315462"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 06/26] fs-x86/rectrl: Improve domain type checking
Date: Mon,  7 Apr 2025 16:40:08 -0700
Message-ID: <20250407234032.241215-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
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
to which they are connected add the resource id into the type.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 19 ++++++++++---------
 arch/x86/kernel/cpu/resctrl/core.c | 12 ++++++------
 fs/resctrl/ctrlmondata.c           |  2 +-
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index d6a926b6fc0e..177f9879bae1 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -111,11 +111,6 @@ struct resctrl_staged_config {
 	bool			have_new_ctrl;
 };
 
-enum resctrl_domain_type {
-	RESCTRL_CTRL_DOMAIN,
-	RESCTRL_MON_DOMAIN,
-};
-
 /**
  * struct rdt_domain_hdr - common header for different domain types
  * @list:		all instances of this resource
@@ -124,12 +119,18 @@ enum resctrl_domain_type {
  * @cpu_mask:		which CPUs share this resource
  */
 struct rdt_domain_hdr {
-	struct list_head		list;
-	int				id;
-	enum resctrl_domain_type	type;
-	struct cpumask			cpu_mask;
+	struct list_head	list;
+	int			id;
+	u32			type;
+	struct cpumask		cpu_mask;
 };
 
+/* Bitfields in rdt_domain_hdr.type */
+#define	DOMTYPE_RID		GENMASK(8, 0)
+#define DOMTYPE_CTRL		BIT(9)
+#define DOMTYPE_MON		BIT(10)
+#define DOMTYPE(rid, type)	(((rid) & DOMTYPE_RID) | (type))
+
 /**
  * struct rdt_ctrl_domain - group of CPUs sharing a resctrl control resource
  * @hdr:		common header for different domain types
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6f4a3bd02a42..d82a4a2db699 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -457,7 +457,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->ctrl_domains, id, &add_pos);
 	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
+		if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_CTRL)))
 			return;
 		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 
@@ -473,7 +473,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
-	d->hdr.type = RESCTRL_CTRL_DOMAIN;
+	d->hdr.type = DOMTYPE(r->rid, DOMTYPE_CTRL);
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
 	rdt_domain_reconfigure_cdp(r);
@@ -512,7 +512,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
 	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+		if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON)))
 			return;
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 
@@ -526,7 +526,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
-	d->hdr.type = RESCTRL_MON_DOMAIN;
+	d->hdr.type = DOMTYPE(r->rid, DOMTYPE_MON);
 	d->ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!d->ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
@@ -582,7 +582,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
+	if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_CTRL)))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
@@ -628,7 +628,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+	if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON)))
 		return;
 
 	d = container_of(hdr, struct rdt_mon_domain, hdr);
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index ce02e961a6c3..0c245af0ff42 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -614,7 +614,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 * the resource to find the domain with "domid".
 		 */
 		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
-		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+		if (!hdr || WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON))) {
 			ret = -ENOENT;
 			goto out;
 		}
-- 
2.48.1

