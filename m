Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE91281376
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715064; cv=none; b=pQ0qXTgivs2u1GBqQxiIeOYjMg1iJmlMtSz2aM+KfUr7jyjhtwJ7MCVhogJdtDw3OKnQq74viy2Ac3HFBse/QlfBhZk3HexEbboiNiEi1ZtAq8EQnjnTx4HGBd09RMqqpx4zS8UB7UAYD8Ot9psOsqvuFCe0F3bE29xkqaGluS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715064; c=relaxed/simple;
	bh=8FUSSIDKzWGYa5DO7RWGqBgks6ejPObFldpUChfAFdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXac/tH0cqi1AEVS3w1frhjb56oAkNeKkm78ztnylKvmy3shU1iJ72/aI9PEZbp0BETVqfB7Ho6BnrpJp1DEavFTPDZPyJ0QKMGmQjXpi3/ilWkTN7Vd5yh3fq35ezBG+FTUdYmbzXEP5qOEqPP0KJgDmLZqf4Wn6O0qEZDDmLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CFJRiuoh; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CFJRiuoh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715063; x=1789251063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8FUSSIDKzWGYa5DO7RWGqBgks6ejPObFldpUChfAFdw=;
  b=CFJRiuohMmFlnPmsdSfRUW/YVNf4l51zse+q6wJ0XkuJ3makkWU1pH8E
   OeJXJFwpe7cl/I2YUyAs/tiIVGdSdbyNY5RaCRCuCvYotcilV12W1jl0c
   k262l/mGG6/TrIWbKOGe+Q6RxKMYpNZ8KUuuxZ1hSVQXt+lDDQYmH/KOs
   cICXrucWh5x65Mg0UWX69B8pUoDarJgn1m5Q9NzqQrVg8zXzfn+/v4LKM
   GGq/qDvTKcchbtkAdtheYfsJom5cm8OnKGRLkHhQQUN051DvvGbSpXkdf
   nUapR83b8u4c6Vk9lsHdkxCRjrIWnJ7TEJ/S8eQz5eGPHrb/RsUh/P5ta
   A==;
X-CSE-ConnectionGUID: 8EAVsRxKR2m5JIRlSeP5tw==
X-CSE-MsgGUID: 40CPYCcwT7O05pNFbHJVrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002624"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002624"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:01 -0700
X-CSE-ConnectionGUID: Ojd/o95qRjGOBtxxgTSMQQ==
X-CSE-MsgGUID: g/f1WU7JStO4k6T5j1tBEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265121"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:01 -0700
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
Subject: [PATCH v10 02/28] x86/resctrl: Move L3 initialization into new helper function
Date: Fri, 12 Sep 2025 15:10:23 -0700
Message-ID: <20250912221053.11349-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All resctrl monitor events are associated with the L3 resource, but
this is about to change.

To prepare for additional types of monitoring domains, move open coded L3
resource monitoring domain initialization from domain_add_cpu_mon() into
a new helper l3_mon_domain_setup() called by domain_add_cpu_mon().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 57 +++++++++++++++++-------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8be2619db2e7..055df4d406d0 100644
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
@@ -565,6 +541,37 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
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
+	if (hdr) {
+		cpumask_set_cpu(cpu, &hdr->cpu_mask);
+
+		return;
+	}
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		l3_mon_domain_setup(cpu, id, r, add_pos);
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

