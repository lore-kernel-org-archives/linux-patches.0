Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F802E1743
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936258; cv=none; b=Ijb7EQ26jbJrFfu6n/a/9TaYo9TGSFb0wjn6lWic0JOsr/LN/a23u355TRfJathAgmNZd9aOpZXnAuloSrmV68xsHLXQQsSfguonNHyG/U7rG77x8hZsF/Ptr2aXgNmxPju9Ehue7iYCqUbxyh3lO3AUpIJ11aTXeev6Frp60Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936258; c=relaxed/simple;
	bh=a3IoQ4GLCGMOmHG8RwRmViQVRz47yCvJdkrtlgqqV3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKaq/5+xY9Iees0lRoXcJjh6hwDxL2jV7s5FnZLNAPhuVV8/58z7VISUkwaVYFRnYbtLHCROfwr2sETfbF9VNjxQdyJhcVSAARi2QY2vmpL51KlnFqCa4RhHxgrOFip8oNuzx/47KDqO5iI399BmAOA2GM19wooWFvtjxXnshuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I1qtIsTn; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I1qtIsTn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936256; x=1786472256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a3IoQ4GLCGMOmHG8RwRmViQVRz47yCvJdkrtlgqqV3Y=;
  b=I1qtIsTnmRQ9MehXRm52ShNqsRQ93DUGaJBVDpIqNO4RL6elJd1LwIW0
   ezkemXYTyvXSmNbA7ZxPOTFpLf9P+JNsJ7toyQVssVofYCrljekMwv8CA
   6d3hKTe1g0z2ZcbZOij+9T5j9Hd3n7zwKgrKWAi6cJwdMqYptV/K8qNO/
   GTnyDoBXfJM6Dbn8ZkHUjsZ0IbW2zMMKdyGW/Q0lpns/PPY+y1yywQWEb
   o7o2/2U/jS4ka/CkndAYrPxOT91j6GWsbyDDu0yRfTBegd5ijkLYnA+vG
   P1wSIp/FUfollTsGx5Got5qc3/IbWF2f/gNk0NCTkh0xe84qJxy7uKlM5
   Q==;
X-CSE-ConnectionGUID: hc2vvhiTQHKN0trQ/zrSSA==
X-CSE-MsgGUID: N6TE1tb8Ts+YhSlQNnn6eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277360"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277360"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
X-CSE-ConnectionGUID: cKmOIHcTRaiza2KEJwTpxA==
X-CSE-MsgGUID: 2UofFD33R6OOrswfaDe9DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825631"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:23 -0700
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
Subject: [PATCH v8 07/32] x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Mon, 11 Aug 2025 11:16:41 -0700
Message-ID: <20250811181709.6241-8-tony.luck@intel.com>
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

All monitoring events are associated with the L3 resource.

The RDT_RESOURCE_L3 resource carries a lot of state in the domain
structures which needs to be dealt with when a domain is taken offline
by removing the last CPU in the domain.

New telemetry events will be associated with a new package scoped
resource with new domain structures.

Refactor domain_remove_cpu_mon() so all the L3 processing is separated
from general actions of clearing the CPU bit in the mask and removing
sub-directories from the mon_data directory.

resctrl_offline_mon_domain() continues to remove domain specific
directories and files from the "mon_data" directories, but can skip the
L3 resource specific cleanup when called for other resource types.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 17 +++++++++++------
 fs/resctrl/rdtgroup.c              |  5 ++++-
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 66270c230b4e..448c2bf9837d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -649,17 +649,22 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		return;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
-	hw_dom = resctrl_to_arch_mon_dom(d);
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		hw_dom = resctrl_to_arch_mon_dom(d);
 		resctrl_offline_mon_domain(r, d);
 		list_del_rcu(&d->hdr.list);
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
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 77336d5e4915..05438e15e2ca 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4047,6 +4047,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	if (resctrl_mounted && resctrl_arch_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, d);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto out_unlock;
+
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4063,7 +4066,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	}
 
 	domain_destroy_mon_state(d);
-
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-- 
2.50.1

