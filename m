Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D2D2D5957
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010486; cv=none; b=GSR+9xyn6L2JlgKX2f3DBqPuLvzKvqtpnHN/CwYoImV4p8os7qTq7FSkCyE425+J8NuKoqVXHxb4DCW2kn1oKsCgMVskeBUWg/XoXwSsTJZyiTodymWlJpzKOIt9zuUPVPxYHgoI6h5UrHR0bNr8R8HHAVKvHomFqMFQXuCTjDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010486; c=relaxed/simple;
	bh=LlRdkmpBiMV2KJh/axg+W+2z6l7UPK5CIKtf/6Q8CGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vvd9+Apk+Y8eGIGDdARibIZ9jn8yuPAV9EBph85VUZDK/7aImCnH2SZwgL1sFieWR0IyHwhcOAJfG77k+K96GwxHYZRx+b01+EPWdRPfs2IN/8b0nYqtTOdamI1tCk0Lvvmikjp2pnXDcdJnY10TKxeppuvfGsDs5bLa5dz0fZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJSkAJai; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJSkAJai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010485; x=1795546485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LlRdkmpBiMV2KJh/axg+W+2z6l7UPK5CIKtf/6Q8CGY=;
  b=gJSkAJaimf7FPpfBeAzd35MiF2GuDSrO/2NcNF+YlBc1N6GvgIUx8116
   3L2iaRAJ/CPQsRk1nrVPJjRzE3ehhVOrgatAmYsSyTUJ7oCfaDAfGXwRg
   ehBh1TtKiPwScR75pOyhiEX2S043Jo61AtijE7j5RgjfpQL0oP6L0sIx/
   PDoOjbQ7QVZqfQsFVqJIQtwTmLGj4fcvQs5i14H1Rzfrnrldpv5wShDJ5
   WvvSPa1/X2AbB8RI+uozFt/GP8mNCTMCHMEsWq6JxakGoKMrKrdKA7Z5Z
   KYb0OKo4oLQHMPg9NLsbGd2F+VKKUOU6Ru7j+EjXJ5aJkEZP8NmarjrZ/
   A==;
X-CSE-ConnectionGUID: MyJBdnm6TKCqQ4x6nN9xSQ==
X-CSE-MsgGUID: Nc4Z/FmNTP6rE7C3kYVoqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636445"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636445"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:22 -0800
X-CSE-ConnectionGUID: nZjLJhW4TjOjV2FxGa/91g==
X-CSE-MsgGUID: a3JtKyx4QF2Mm0pNm0+IjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224944"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:21 -0800
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
Subject: [PATCH v14 02/32] x86/resctrl: Move L3 initialization into new helper function
Date: Mon, 24 Nov 2025 10:53:39 -0800
Message-ID: <20251124185412.24155-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Carve out the resource monitoring domain init code into a separate helper in
order to be able to initialize new types of monitoring domains besides the
usual L3 ones.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 64 ++++++++++++++++--------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 0b8b7b8697a7..2a568b316711 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -501,37 +501,13 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
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
@@ -539,7 +515,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_MON_DOMAIN;
-	d->hdr.rid = r->rid;
+	d->hdr.rid = RDT_RESOURCE_L3;
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
@@ -549,10 +525,6 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d->ci_id = ci->id;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
-	/* Update the mbm_assign_mode state for the CPU if supported */
-	if (r->mon.mbm_cntr_assignable)
-		resctrl_arch_mbm_cntr_assign_set_one(r);
-
 	arch_mon_domain_online(r, d);
 
 	if (arch_domain_mbm_alloc(r->mon.num_rmid, hw_dom)) {
@@ -570,6 +542,38 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
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
2.51.1

