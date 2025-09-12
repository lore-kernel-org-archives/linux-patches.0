Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA8B283FF0
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715065; cv=none; b=uBK5Y2V/VbKiUgK9UJx1kY7YJVcLaoFft9XvVCBZqghjeLK/bBN1Fgtj0vBP856EyJmknkgnrikt2S+MeJJGUQD9CRj0o9IMvTzLYevApIvQPbv7jfz6sChn+etLOCg+HTxBZU4vLvaTOgAtbk9h6RpFAGIP4z615rjJBeBuQnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715065; c=relaxed/simple;
	bh=HOJg69kJodiDM46bqMEfu1DfPx4T2Ri8GIbPyqaznWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIL7R7rAGIpJDcSpCyJbSRCTUimAHvI1jNiy/vV3qXojbD+UAltksBOB4QHE5NdsAYujwXi0wJGcU5K+HGV54lnYukZz4bG2jgb6hcLD79D4OhzlvEhBikOk69EqOxpafAPJRm29dTQiKCHc69QhhQODIvTMlF6w320ItwlnMxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQ++gfP3; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQ++gfP3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715064; x=1789251064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HOJg69kJodiDM46bqMEfu1DfPx4T2Ri8GIbPyqaznWk=;
  b=hQ++gfP3PSo8g83201ml/GD4wGzODsSxvBJxI93oYxTt8Laq+TqDq7U0
   BcvCKJthAfJoQ9L5jke2zolI6l6M3PGucx2c4QVJOQkHA4BiDS01fpI1l
   xc1Wid7e7pP+zPh0Mts/b0zPitkAtE6GAedRihVJ3yaqDW1DNWCO8FOXP
   jTexK3GfUUVH3HrswjPSDy0+uADhsIn5lM1iscisl3riqyxpZixRyTKU4
   85W56YITyloVl+rzbKCOzrnWYBApI/tVHSLuUPW26/1yEPLQ8QeQl27Ya
   BIsqrnBtpjAuTymnjkHM9KOA16mqXwckAx7vYX9WEmBH0lVxxoBFeQqN1
   w==;
X-CSE-ConnectionGUID: Xm7pjvZXSi2AHSCbZYJrLA==
X-CSE-MsgGUID: /YL4LhcvTH6APPHFhxS83A==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002640"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002640"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:02 -0700
X-CSE-ConnectionGUID: GTL3r82lQI+rjUHuEjwQ0g==
X-CSE-MsgGUID: 9R3SD3wfTPOCOtv6k8GGPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265130"
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
Subject: [PATCH v10 04/28] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Fri, 12 Sep 2025 15:10:25 -0700
Message-ID: <20250912221053.11349-5-tony.luck@intel.com>
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

For symmetry with domain_remove_cpu_mon() refactor
domain_remove_cpu_ctrl() to take an early return when removing
a CPU does not empty the domain.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b874cbe0218b..c6ce72cba543 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -602,28 +602,27 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
-		resctrl_offline_ctrl_domain(r, d);
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
-
-		/*
-		 * rdt_ctrl_domain "d" is going to be freed below, so clear
-		 * its pointer from pseudo_lock_region struct.
-		 */
-		if (d->plr)
-			d->plr->d = NULL;
-		ctrl_domain_free(hw_dom);
+	resctrl_offline_ctrl_domain(r, d);
+	list_del_rcu(&hdr->list);
+	synchronize_rcu();
 
-		return;
-	}
+	/*
+	 * rdt_ctrl_domain "d" is going to be freed below, so clear
+	 * its pointer from pseudo_lock_region struct.
+	 */
+	if (d->plr)
+		d->plr->d = NULL;
+	ctrl_domain_free(hw_dom);
 }
 
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
-- 
2.51.0

