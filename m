Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49001283146
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715064; cv=none; b=XUrdOht0BlAUIpgGvmoFQhXq7+m7RV/XfMb1QAwOme9n4CpewOUXDrambSigLxBwW0tq+iqsJOkN6/o+iutqmK99axrC0MIE6MsxErfL1p4zoMLtvjt8qC+R9hifHqyXP0kqLlQwvjorxl9ElnE+DXDwlgy2DLN8dNofcZaWsm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715064; c=relaxed/simple;
	bh=W3l2LROmj/aidoZ9hHGzxBQReC1zNnYeaPcvHDs85co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHzNI/uDJzteXdE2itXQMmu+ZVOyc2h/6rM2+OIjRlsyLMYmR8q3l6l0/MP19ed0GVUm/VWOQR0jYqrrcnj+uVIO1MYGALbeJoEqShuSQPVqW+ujMVUfq/jPp/gvSZ4Kn9xtomUiXKk7MlwAXQtl1+Z/G82XPn4zQp/9aRm8Dz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GujtJxk6; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GujtJxk6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715063; x=1789251063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W3l2LROmj/aidoZ9hHGzxBQReC1zNnYeaPcvHDs85co=;
  b=GujtJxk6xAYL+DRdw8nqW/9w2XOKUrs8vtDZBrsN3cfQV1s8ZmZenqeC
   1xQWAHwJ6Kp4FW4U3KfGPimEbYUJu8mqjvCbItyek+gKo4Qlk6KU6SDGe
   GDKemKs7M5Ie58w24NaKQYs82kWxS13ym7Tus3ZDXIS/KayOAe/XPKHu/
   nwq2qPP971Q8gqAVAekjXxQ1Q8mxhjH0iRW+GcKQqTBN8CZZsEwZLE6t5
   1cT4DvkGpiHF2uLscpk7Kqp6zmazawsGolhwLgHnWeUlvPGNdC1s7oa2u
   87tnMQOvIfQkcMf1Anyd4zeVfciovFRGB00EGY/hPH7WJ4USleYvbP7Pf
   w==;
X-CSE-ConnectionGUID: SJxPCE7DRoON45txt8T1gw==
X-CSE-MsgGUID: 1ZT85/xVRziBHu/OmLMGYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002632"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002632"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:01 -0700
X-CSE-ConnectionGUID: vcrrK3YXQoqhkuteEBI+4w==
X-CSE-MsgGUID: 7mMrThukSpmA3UNg62MPxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265126"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:02 -0700
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
Subject: [PATCH v10 03/28] x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Fri, 12 Sep 2025 15:10:24 -0700
Message-ID: <20250912221053.11349-4-tony.luck@intel.com>
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

All monitoring events are associated with the L3 resource.

The RDT_RESOURCE_L3 resource carries a lot of state in the domain
structures which needs to be dealt with when a domain is taken offline
by removing the last CPU in the domain.

New telemetry events will be associated with a new package scoped
resource with new domain structures.

Refactor domain_remove_cpu_mon() so all the L3 processing is separate
from general actions of clearing the CPU bit in the mask and removing
sub-directories from the mon_data directory.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 055df4d406d0..b874cbe0218b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -648,20 +648,25 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
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

