Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E880E3081D6
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394844; cv=none; b=MnQSU0HbcQ9DfKSnlZ9RdnmUwI44spXjLJk/ItnBY38ab10eqXBStekxLrMwcxGuDVqCLSqTwGQWyj9z19RG8epkqSckV/ViP9ltauuJH94F4zMLdP9eMe3Dt/8B7E6sa0n3Lv7heaZgfzxfIFVPKHrozazN3jfPncSf+bL+g08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394844; c=relaxed/simple;
	bh=CXSkuQZDd3X/TQ8dxx/SG82mfLvO4sV6yEaaCfxbpQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCbr8KVeDeNLdZb/XLnJKruuHPelo0+0hOh0immz7mXIPc5qBZD5eLE87RdGtBXw1mEEm9l2bfYv8ztLisbvexSNd09AA1Eq/pt3AyTjBHWd4/eoW8twpZsjU2Ng/M4ltMgGsj7lp7M0vbVUyOFkPRbvgjQFKhErbMzTLANiDSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kl6guHeB; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kl6guHeB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394843; x=1791930843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CXSkuQZDd3X/TQ8dxx/SG82mfLvO4sV6yEaaCfxbpQo=;
  b=Kl6guHeB7sedrjTEvvpdzAEk/cCNlbh0IgY+fQ45n63i+MbzfIXMyHUC
   594X27yaJ4AvocJCIsQtChzWbyWK1ryBGlKdsRM4ZSAOf93i/x2wXpHM9
   CEpYtSlDJUcFXxXUyXAAPYgIlviO+yhFFlFem2/QMAj/gWONknOlevcNU
   eY6wOzL0MIdRrJ3+llyEZIaVxCt3u4+O+NtHMKuswdz79GN3A9otRFbOl
   GB77LpNCK8t4FIX+ZJ2iXXVEcDCW49xZO18zA2wxBD9kYEqy+PK+RupcH
   mShT6nirqLnjg+GggEuKZtVpkqvEUYdz8u7eTgf/dB075n1w6vRH/dXf2
   w==;
X-CSE-ConnectionGUID: IZPvVMvQQB+WGyooHJpseQ==
X-CSE-MsgGUID: v/ZQUoYHTLudf6OIw/5ioQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168776"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168776"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:00 -0700
X-CSE-ConnectionGUID: dGIzacfhRA2VaiMcfktnLw==
X-CSE-MsgGUID: HFAdzW2lRMOKw/KFd1y/AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145251"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:33:59 -0700
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
Subject: [PATCH v12 03/31] x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Mon, 13 Oct 2025 15:33:17 -0700
Message-ID: <20251013223348.103390-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
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

