Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1462E0B64
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936254; cv=none; b=hodRwg3/6P4CmOsNLxrBDvn7WGnMMscWdIT7vYyxrsBKj7SUGMocMXGdQklJDiOKsRBu6S6MuAXzMQ+0A2BbZTIztrbXBC5YANPcaz6BoLWMGzOvfhU38HWOIDGc1kQsBEYnK+d0uy8a5GhLRZu6TRR73YlP+uMYEmWqouqeLjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936254; c=relaxed/simple;
	bh=7QBrtRskse4L3xMOD1F3XTtyuESFrW+HXy/mdDGVhc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpP7c/EKWAUWiiI7xenTlDcQ5cr2tjhqivellGvJCCcE1UGik6x7wK9tw2EaUhf3oQnLTCQpCs1oKD4Yezdp8XAnF4BooTAn4AtNesSBQFR+grkwe3ILVCwa/tF+M6JUWKGuZaF+JKqlurQR4ngRXG4BdZXldYdq2dVGcYfAFck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iKsEEmAZ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iKsEEmAZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936254; x=1786472254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7QBrtRskse4L3xMOD1F3XTtyuESFrW+HXy/mdDGVhc8=;
  b=iKsEEmAZGD0QWd4H2Rh2lUHkfKHlFW7zx98EgKAP+7stxUAr9u2p1T8X
   zAVKz/Xg0N4Lqo7xbxGU+XUNQjCxuS2EI3Q8F553x6AB9GLScQ5iQlQ0H
   Kjaf6lDgdK0djU4/foAaAZAfHhlANO/a7lgMuxdVkvBiICJpJvb0Mg6+e
   r962m1n4Oih3Qp88U/RHQyqiqdJ6CPB9EkL8me9x//KDKgFd6hSHRxDYE
   kFc9gZYeR0pAO0wmzOEakcq0Mx3umYOzrC+4yZ18mGGfTJ2QFBz99DdR3
   KActjQRrOng3dS3FfvlmnHlh9Rw6cUHjOEgukHu2ij1gCI8QDybdD6mxK
   g==;
X-CSE-ConnectionGUID: MevvygVHSXOjuZmN8nBYOA==
X-CSE-MsgGUID: hHm95H7ZSfKa+jesV58FgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277354"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277354"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
X-CSE-ConnectionGUID: ya4PTvRHRIuCMFq4sjjCzw==
X-CSE-MsgGUID: qQH+J6ZaRw2VaKdg0mjWCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825624"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:22 -0700
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
Subject: [PATCH v8 05/32] x86,fs/resctrl: Improve domain type checking
Date: Mon, 11 Aug 2025 11:16:39 -0700
Message-ID: <20250811181709.6241-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
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
on domains will be quickly caught. This is insufficient to
catch errors when other resources besides L3 support monitor
events.

Add a new rdt_domain_hdr::rid field that is initialized when domain
structures are allocated. Call domain_header_is_valid() to sanity
check both the type and resource id before using container_of()
to get a pointer to the associated domain.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  9 +++++++++
 arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++----
 fs/resctrl/ctrlmondata.c           |  2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 478d7a935ca3..091135eca2b8 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -131,15 +131,24 @@ enum resctrl_domain_type {
  * @list:		all instances of this resource
  * @id:			unique id for this instance
  * @type:		type of this instance
+ * @rid:		resource id for this instance
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
index ad7ffc6acf13..a7d60e74a29d 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -643,7 +643,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 * the resource to find the domain with "domid".
 		 */
 		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
-		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+		if (!hdr || !domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, resid)) {
 			ret = -ENOENT;
 			goto out;
 		}
-- 
2.50.1

