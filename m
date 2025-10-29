Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A8325737
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754889; cv=none; b=P2aJAEpLyVqJTC61FWyY6RdYi0WE1Bl7eFvEKmFeoS/o5JUOsDQ1Se4aTNPaAzdOSmkVhBZXGU2Ko0jqq/PR+Cpskfrvt4NFfXUQImkcESAEDXBT2RwfindfsfQMElXF+eUyd0OpRYLxBmmgs2lQ0BWcLXr7e+R0ZUi/aPxC26M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754889; c=relaxed/simple;
	bh=9Lb7jWBMmJdZuko7jvibgwX+fDcSvQ7E+lwTn2rHF/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tccuhfElsKUh4P6fM3vYDJGwPEkP5QmsQtAVQjjYw+SOlwIyi7VorGdKMrLhIFRIBA5tPjNZF4eYD6sjBsih9Z+ixmYxa6r2Xc0QMSO3lPwBlOLPUcWXLP+6Mj06/OBH6ZwNRHUyaue1kAeLsa67NWCe7HpKk3oIu70iFLI5XkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=adNOH466; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="adNOH466"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754888; x=1793290888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Lb7jWBMmJdZuko7jvibgwX+fDcSvQ7E+lwTn2rHF/8=;
  b=adNOH4666Ke2HIDGKqk04/43QrOHeuDBRgQXMfY7slARmnVG3VQR3uMO
   am5CRsMyaeGJoSWk6MT+ygkgdmAhgOu9iakZzO2WLzgwEeuonXcFpAPSj
   +YyeR21VE+gGI0SmDcS43SLJQAQcEP13z5rP7Ys9QTd6+qDbCbXmxiX9p
   KE08W5vkg5mOHrRRRcjpND22CXY7tlK9Hs9qbtxKmx6mY89/QfsFJnPtK
   PhZK8e5VDct7e3Cfrj3M6P4O9zBuY9N0FWVFMoP3x0vTV0v2ewS7DhjUt
   jXWOXPrwYIAS2F1oEiCbBVx1cxV5r5zQ2tNaINBA4PZx6jUcmsn3Uby+P
   g==;
X-CSE-ConnectionGUID: 7DSiVKAqTpyNj32RSP9JXg==
X-CSE-MsgGUID: o0uGPuicRQOoWCETGUSsFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481313"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481313"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:26 -0700
X-CSE-ConnectionGUID: 2sSGvrU1TPeyO4CYMgZioA==
X-CSE-MsgGUID: XY2v1OCBSTqfEEj1HAJisg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901304"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:25 -0700
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
Subject: [PATCH v13 03/32] x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Wed, 29 Oct 2025 09:20:46 -0700
Message-ID: <20251029162118.40604-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New telemetry events will be associated with a new package scoped resource with
new domain structures.

Refactor domain_remove_cpu_mon() so all the L3 domain processing is separate
from general domain actions of clearing the CPU bit in the mask.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index d422ae3b7ed6..c7bfaa391e9f 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -626,9 +626,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 {
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct rdt_hw_mon_domain *hw_dom;
 	struct rdt_domain_hdr *hdr;
-	struct rdt_mon_domain *d;
 
 	lockdep_assert_held(&domain_list_lock);
 
@@ -645,20 +643,29 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
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
2.51.0

