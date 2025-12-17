Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C951E2D7DCF
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992108; cv=none; b=Hjrftpm8JOYrTGnnaXyYpaTnmiFlXxKHcoT1txXVrT4tPwNKkoHcuH9uK51j63t+7DnoW0NY+u9uG7wnv+JclUX0c0ue82unoI/aRGmNrmH7Pi64LfqOuOdOJRWcJJbk7h674dKOQD+etoZ8q0KDq34Zle4rNZvcGCilv3yIU0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992108; c=relaxed/simple;
	bh=kQPIK+tN99kjei48Dlx/z5BxBZhnT1O2fsz9Q6iNaBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R354169l88a2h92HUxqaFM6SrDZrN8+JrqQpAwow/jnPamXtBy8AcTWjfIcrxTh8Z+DCsQ4lz4XqgVy495yM0rhVJyFogiC5hLeGXXq0bNsnL52gmjQPlkXKnxJyBZZa3k086mzlTccjKZdZ8HCR3FqKXyVExMXU0qNWByCknTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SdIvKqU/; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SdIvKqU/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992104; x=1797528104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kQPIK+tN99kjei48Dlx/z5BxBZhnT1O2fsz9Q6iNaBQ=;
  b=SdIvKqU/hckNUqZkUpNOQGcjy5l8UZJ44XkFRpcwIIiaLTltdATMZnH9
   Xrg1QovxDbFEd9fMjSIxPs2fstRvYRND5f9te4AaCyr3bW0WwDQfshQ7G
   LwTfr8kSgZJVKbW3x/HXPOZvSbbtOnX8qdkJdthv7ig5Ybs2pP9odqwGX
   FB2wvO+OXJBixCu7fEv5w6lzN23//+ZvPFY9LMZnxjYUJZ1nBIJXMPUlr
   UStmfHfSBuwUYLeWnY83bASV0ZLZ+q5M30OqHY33y0ObMGFhZwajQFOQd
   8PlF3ad2v9sAM6QoHeEE7gaIV4KJfqEJtL8kg2r9cALfWdpmsTnDU1+Vt
   w==;
X-CSE-ConnectionGUID: KHanD3RDTRuSHlTyyneIcQ==
X-CSE-MsgGUID: 47sqbckgQ56uptxBYM/aJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594632"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594632"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:32 -0800
X-CSE-ConnectionGUID: JEVW83isSb+LjxBnGTlgMQ==
X-CSE-MsgGUID: T/sQ0hKTRsijg3ZoYbMRWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748155"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:31 -0800
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
Subject: [PATCH v17 03/32] x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Wed, 17 Dec 2025 09:20:50 -0800
Message-ID: <20251217172121.12030-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
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
2.52.0

