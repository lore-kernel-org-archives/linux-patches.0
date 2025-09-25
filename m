Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6546A31C591
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830647; cv=none; b=lDqZp2a9JuqmV8Cxn5OKHyVpFe48QJEnlxLOO40mw+nx0qJ08WDBwmvBCUnuwmUf8i5EcFihZP/XZ3Zy46lq/VlGwLZTHdtHnxwh5UBNsbQgL7H7LjVrv9oHVprLFNkJPbDLu6aX9kCiMSmDABTC7BNjWPRBKwUWWpfqtU5n8tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830647; c=relaxed/simple;
	bh=QpDDN10wiuqjDcD8OQKIjrS6jeO4TdOlFQbokXt5DZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTwIrLZgo5sc7XiXZVVwiBKdwERKKg5lIRUcfTKRwiTMOlEYC9ndXKcdcdJJzk6D7vhjy4brHo+wPmH18phLvxh4QUr1vT0ElWaNPDu83aDitj84yXBC5/FYZGvy3DDD+bxkhjkWqqRLDr9DAzdP1PXXvwkSML58KritFscjAx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LX7Q3Tr2; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LX7Q3Tr2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830647; x=1790366647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QpDDN10wiuqjDcD8OQKIjrS6jeO4TdOlFQbokXt5DZE=;
  b=LX7Q3Tr2a3LLpET6cc/3xA5xBF5It+fBZFLkk88UEGF7e8tCq1Ppx90O
   aXpCHwp7Vb/3VbJpeDEhhXAE6d6LkAfDzgpyzgY3798JEMAR6zZJMjC4b
   PeQqkNAHN2VJP9MbK4RiAgQb5/ReDgbKJnvqmieshN3nxSSDoAzS+KeDn
   xRTN1ztGlULjCDoHpcN0cKr14viIPFRsqdxqCA555vugZLmY9SH1X75tP
   sgFHWsZUj72al5zHaIrvuYDYJpal9F+rkdXz7C+/YWbvQKWzt+aWvHtdp
   NXB4PbHmiBbG15OK1jBX5mJyLCyeMm98VBWikwWjYZFtnoz7FSpd+H1wa
   Q==;
X-CSE-ConnectionGUID: V8u+mpaWRVG1Lvn3U7fMSg==
X-CSE-MsgGUID: od3Yxt/ORjmF2yTDmTgwSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074145"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074145"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:05 -0700
X-CSE-ConnectionGUID: pJsaP+pZQdmBTMXc5SHqog==
X-CSE-MsgGUID: 9Hd5LD+ZTHCbTILRVq0uiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003600"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:04 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 02/31] x86/resctrl: Move L3 initialization into new helper function
Date: Thu, 25 Sep 2025 13:02:56 -0700
Message-ID: <20250925200328.64155-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Carve out the resource monitoring domain init code into a separate helper
in order to be able to initialize new types of monitoring domains besides
the usual L3 ones.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 64 ++++++++++++++++--------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8be2619db2e7..d422ae3b7ed6 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -496,37 +496,13 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 	}
 }
 
-static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
 {
-	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct list_head *add_pos = NULL;
 	struct rdt_hw_mon_domain *hw_dom;
-	struct rdt_domain_hdr *hdr;
 	struct rdt_mon_domain *d;
 	struct cacheinfo *ci;
 	int err;
 
-	lockdep_assert_held(&domain_list_lock);
-
-	if (id < 0) {
-		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
-			     cpu, r->mon_scope, r->name);
-		return;
-	}
-
-	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
-	if (hdr) {
-		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
-			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-
-		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
-		/* Update the mbm_assign_mode state for the CPU if supported */
-		if (r->mon.mbm_cntr_assignable)
-			resctrl_arch_mbm_cntr_assign_set_one(r);
-		return;
-	}
-
 	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
 	if (!hw_dom)
 		return;
@@ -534,7 +510,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_MON_DOMAIN;
-	d->hdr.rid = r->rid;
+	d->hdr.rid = RDT_RESOURCE_L3;
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
@@ -544,10 +520,6 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d->ci_id = ci->id;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
-	/* Update the mbm_assign_mode state for the CPU if supported */
-	if (r->mon.mbm_cntr_assignable)
-		resctrl_arch_mbm_cntr_assign_set_one(r);
-
 	arch_mon_domain_online(r, d);
 
 	if (arch_domain_mbm_alloc(r->mon.num_rmid, hw_dom)) {
@@ -565,6 +537,38 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	}
 }
 
+static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+{
+	int id = get_domain_id_from_scope(cpu, r->mon_scope);
+	struct list_head *add_pos = NULL;
+	struct rdt_domain_hdr *hdr;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	if (id < 0) {
+		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
+			     cpu, r->mon_scope, r->name);
+		return;
+	}
+
+	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
+	if (hdr)
+		cpumask_set_cpu(cpu, &hdr->cpu_mask);
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		/* Update the mbm_assign_mode state for the CPU if supported */
+		if (r->mon.mbm_cntr_assignable)
+			resctrl_arch_mbm_cntr_assign_set_one(r);
+		if (!hdr)
+			l3_mon_domain_setup(cpu, id, r, add_pos);
+		break;
+	default:
+		pr_warn_once("Unknown resource rid=%d\n", r->rid);
+		break;
+	}
+}
+
 static void domain_add_cpu(int cpu, struct rdt_resource *r)
 {
 	if (r->alloc_capable)
-- 
2.51.0

