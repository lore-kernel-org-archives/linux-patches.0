Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B439131D74E
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830648; cv=none; b=S+z54thm7HyuL0AOIpjXlXj+mRfrFYGpYLfUrpWLV3pEbrFs4hFVQ8WGX1j+K3DZ+gbg2o9dbPBcAQre0c2WkCdH37ijto3pydqtEeckNAtqLChO57t9qYvtjOPJrt5FF2KSen10P5cleG9a9oOMNMp+djVTL3jXF6ye/3rATjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830648; c=relaxed/simple;
	bh=vO9qC1IKNnoJg1FEY+mpdsCvg9yf+NzRFgSMvAtgDrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFbmuun/ZdZVDAxMdzkz9fZbx2xVBTBv8MpmcYiNyE607IO0mcVtfLfH73x7gWT2yRbkG8shZJN9yPutbQw5J91clcg2l2e4pqOZy3cXThA5PrZQhUeJJbMAMV/GqPrzQpvmjDwavE0O9KjHafLEq8+vZVwjqRFdVkmE3fk6Pgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TpvFK/dx; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TpvFK/dx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830647; x=1790366647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vO9qC1IKNnoJg1FEY+mpdsCvg9yf+NzRFgSMvAtgDrQ=;
  b=TpvFK/dxXLHZa2MnHd+OEp3Q+cupDrNle2umwPzmrstwOCYjOF7Yy9wu
   MZ67jJFxfzv27thxJwmjBbMKbgq9OkOqS1b1jp18e/0wy0HxXXo5V6h0H
   TIIW1qbgyUQ1lE/G6Ah+yetNm+1MXRHBHhHTYDR7Zjuu+FPmyAjEKKopi
   0mkG+QUU0V1YZZIVw81ri/ZcZM6cJmVJ2g8fpZu/KGIFHw9Ww0d1D4fWy
   MJk/syRY5rt1fsJQpmAX2uVSn7RnnihFzNzJ5E7EhUJr9mLk1G0q8qBbR
   ZEsbCKlx1tsiig/ZDowD/jHN+UxMDmH7Fhj/N5J62N/NnUJrY0ITAmJEH
   w==;
X-CSE-ConnectionGUID: aGJrag+LRwWbW6t8TKBUcg==
X-CSE-MsgGUID: 6guFV4eYRnWns62LoB4jPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074153"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074153"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:05 -0700
X-CSE-ConnectionGUID: 3PCIaxO9QGGCUwWkxoP4gg==
X-CSE-MsgGUID: wYgKQ2NYSz6NZI0hO6HBUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003603"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:05 -0700
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
Subject: [PATCH v11 03/31] x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Thu, 25 Sep 2025 13:02:57 -0700
Message-ID: <20250925200328.64155-4-tony.luck@intel.com>
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

New telemetry events will be associated with a new package scoped
resource with new domain structures.

Refactor domain_remove_cpu_mon() so all the L3 processing is separate
from general actions of clearing the CPU bit in the mask.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index d422ae3b7ed6..b471918bced6 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -645,20 +645,25 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
 		return;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
-	hw_dom = resctrl_to_arch_mon_dom(d);
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+			return;
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
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
+	default:
+		pr_warn_once("Unknown resource rid=%d\n", r->rid);
+		break;
 	}
 }
 
-- 
2.51.0

