Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4617A2ED870
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408477; cv=none; b=krTcTomY+Jl0qZufzqLktsYyN+bi8r6otdX2X3N2T5RoFV0IdRVpT+vcgYCRQawYv+GLv3fJiTkJpsLXW1zEuL6xdv8u/c6PT2c8lx5ykvLGlgdPPdHz/r7nuYZTj2ClbGk5n3WQxmyYqj3FOMHZHUOmpx3qn3ngIFngW/rnmuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408477; c=relaxed/simple;
	bh=4TavaMTu7axZkv0Du315ayr07cIT7myhftmXcK2c5+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6Cx/KsZ2CiA1cl/Y0El0YV/OV1n2+aHVDCD8CNF0aB0Yffs0kE0Ge21lBEtahRRroqL1WN3ofkxCKOpk+icr5GjrSxgWL+h4mYNiyWY3P0NeHzP1AB+6eB06VTHTE0U8MUdGsCKt2i67Ay1ItOPW5/AY27opGQ1ho4HSi5cX1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fOjKemVm; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fOjKemVm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408474; x=1796944474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4TavaMTu7axZkv0Du315ayr07cIT7myhftmXcK2c5+g=;
  b=fOjKemVmlzLok1YIRCa2frR8Sxi26eOLzxVmpVM31VTSlKRjVS9ITaK/
   26UO6OQcxsP87V9nXjvL2GBevaeovczgkLVWSwsNh12tsDhiCp3JU59FW
   p7rKMqh/Bk83IdDZh6LJ5Kp6Prm7h8CG/c25paE1OKfbOZw5ro6XNKS+l
   1GE689V1uMsjygUBejdOhHx0ILAfO3KL/41WAi6xynP0i1xtoFc2tsAft
   RKj6+U5yen/Y9YB0etb2bvBv7kOhjdmwvyj9i+XWXhcOUhDd3/vgaH2Yp
   SgHY3mXQ0xunMoveBqt+BhcjxHRgtNXhuB7tQk6OTvhRDpTROr7cKFYSz
   w==;
X-CSE-ConnectionGUID: DpEe8HQdT4aBJZcJpZIs7w==
X-CSE-MsgGUID: uGxFq67XQTmRfZ3bVXNY3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973496"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973496"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:25 -0800
X-CSE-ConnectionGUID: uZUUDIQEQNOYa8bODt0B0g==
X-CSE-MsgGUID: Q80ZxPAuQN6VcvGKdMfc+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297034"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:24 -0800
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
Subject: [PATCH v16 03/32] x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Wed, 10 Dec 2025 15:13:42 -0800
Message-ID: <20251210231413.59102-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New telemetry events will be associated with a new package scoped resource with
a new domain structure.

Refactor domain_remove_cpu_mon() so all the L3 domain processing is separate
the general domain action of clearing the CPU bit in the mask.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2a568b316711..49b133e847d4 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -631,9 +631,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 {
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct rdt_hw_mon_domain *hw_dom;
 	struct rdt_domain_hdr *hdr;
-	struct rdt_mon_domain *d;
 
 	lockdep_assert_held(&domain_list_lock);
 
@@ -650,20 +648,29 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
 		return;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
-	hw_dom = resctrl_to_arch_mon_dom(d);
+	switch (r->rid) {
+	case RDT_RESOURCE_L3: {
+		struct rdt_hw_mon_domain *hw_dom;
+		struct rdt_mon_domain *d;
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+			return;
+
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		hw_dom = resctrl_to_arch_mon_dom(d);
 		resctrl_offline_mon_domain(r, d);
-		list_del_rcu(&d->hdr.list);
+		list_del_rcu(&hdr->list);
 		synchronize_rcu();
 		mon_domain_free(hw_dom);
-
-		return;
+		break;
+	}
+	default:
+		pr_warn_once("Unknown resource rid=%d\n", r->rid);
+		break;
 	}
 }
 
-- 
2.51.1

