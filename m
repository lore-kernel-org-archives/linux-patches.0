Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3217B23BF9F
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867865; cv=none; b=KTAJzhw/v9n7JjOrkmEnqctZB62Gp0pxOJ38/HBeEegh4aRGV1R3aWtnJ5Xho+Ww1QK2VNpWa0wwvz1OdfBT1QFMWxCSv/RyuS3PbM5Q6WMieBtIszlI6790hqmaLDS3NCyBfsFWWVLwNvmDTmvAedJ5Tm6CwOcqKNWtN9qi9WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867865; c=relaxed/simple;
	bh=SDaugYWsXAZOMN3McHsAwSd3XAzRSKSYbucAMxD81bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKGCS/b2qqmBQ9P4D1y3JM1izApcv1nLcWCT3n2qFf/dA6/E6n1DhjUFzSesVKNng5tiz2wXJFAhFNuhC3+7FcZdB6v1Vc9/0b3CtxXxjX15btcwbMJG6ejm17oG5LHZZAjtOJ+dbgbArXwF1Q7yRI0fJoQqtLTM0ALLihnrJ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fXNfDMww; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fXNfDMww"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867863; x=1779403863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SDaugYWsXAZOMN3McHsAwSd3XAzRSKSYbucAMxD81bc=;
  b=fXNfDMwwGhVJWYcz0kmPTUt/Y47XL0mwcmKBW1pb7tilTFAXGrHRkEV+
   0mwgZqLsHqeC69TnZw7zPrp64WfJ2G0Z1x2mMgE72J2wsJJkAQOwiS3jW
   urofAq8vvvV6SKAs0ftYseuB/pNVFZOS2IPONNkPyba7YFIflgiXjKpWA
   b0rmCLgtDmTzaP8+ijXqsX2NOwmlyzFTR05LTmhZhZbV/sMyqvrMlOsn8
   J2UjAYjM+ZrFwmeoTK+veuunYzqMnXj9zKOa+TaCpFeuVd4C0z5mOZWxc
   VtCHSNiEfdxH2JKJsqkoL679iNRi//22ixUrFj0WY0E+HQQuwQ6u2gDT7
   Q==;
X-CSE-ConnectionGUID: 6oetoQVPSA6/kHbub3vPNw==
X-CSE-MsgGUID: lJO48kryTqyRv5/E70qU7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677690"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677690"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
X-CSE-ConnectionGUID: znuLcpe2RNCyNAucDITqAQ==
X-CSE-MsgGUID: aIBn2m5pTSOHEQidYHnb8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352147"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:57 -0700
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
Subject: [PATCH v5 09/29] x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Wed, 21 May 2025 15:50:27 -0700
Message-ID: <20250521225049.132551-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Historically all monitoring events have been associated with the L3
resource. This will change when support for telemetry events is added.

The RDT_RESOURCE_L3 resource carries a lot of state in the domain
structures which needs to be dealt with when a domain is taken offline
by removing the last CPU in the domain.

Refactor domain_remove_cpu_mon() so all the L3 processing is separated
from general actions of clearing the CPU bit in the mask and removing
directories from mon_data.

resctrl_offline_mon_domain() will still need to remove domain specific
directories and files from the "mon_data" directories, but can skip the
L3 resource specific cleanup when called for other resource types.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 17 +++++++++++------
 fs/resctrl/rdtgroup.c              |  5 ++++-
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 990a0c1af634..e4125161ffbd 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -643,17 +643,22 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
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
 		l3_mon_domain_free(hw_dom);
-
-		return;
+		break;
+	default:
+		pr_warn_once("Unknown resource rid=%d\n", r->rid);
+		break;
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 8aa9a7e68a59..828c743ec470 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4041,6 +4041,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	if (resctrl_mounted && resctrl_arch_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, d);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto done;
+
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4057,7 +4060,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	}
 
 	domain_destroy_mon_state(d);
-
+done:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-- 
2.49.0

