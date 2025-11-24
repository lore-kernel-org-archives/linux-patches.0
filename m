Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9372D3225
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010484; cv=none; b=V0RxGIUgdy02nM/jz622QOrtIQdtqaW/h3df2gC9NulwYTbtZTtcF/8k4hvw/0Xdc/Yk13U8waBIpqp6bTfbDCytHRj1E7DQ839ovwlGw0SkS3BWK7209GFwz26dNkcjN4PIODvxtjEiMEjhVdDRTIKo0yXyU7sV1t8WADtt3FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010484; c=relaxed/simple;
	bh=2QSZ+iQh8XbZwvpPzBCkKPoQpx6hD8+W+fzq0/XIfY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwKPTgs9579MiWr2SoySrmq7ovE9Dg4bv3lYTaJt5HFoecItfY2k8uSGTwhFJNEZTKlc4dYJ+hLE8Mfdn6N8Uh/51zrcTSQoDoE8+4jS5AHN1EdU+N1NBtFePSaE/weMeb5AjmrOGpy99engn3/TgOANaGMWfLKkE/2r+tSv68w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L6d0aLuL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L6d0aLuL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010483; x=1795546483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2QSZ+iQh8XbZwvpPzBCkKPoQpx6hD8+W+fzq0/XIfY4=;
  b=L6d0aLuL13YE4uR2rnXp4lFFKzV3dfZsFrdMkSu/cfIQMrGbUc+Sng5V
   wEGqQSN7KgrWMpzTvaZqtKYIy727ek0Iqc/d9kxhzzbSmi3n+ZP6oOex8
   udQm6UcjHHZyGkYU38mxOEzVKyKx7JduvDYdwX9Q66I56lkR3AD/wdR4Z
   HE6dO0H116/ZkXb9qERUI+VTVxsDfVRe3ygymIPxAWS7r9bFRa9DUTbjk
   ZXlGiJlP2Aa4ota0W+r72DHHPRv7xd5M4W9C2wEqkTSfRmtoS4N3l6N/q
   6yXeZsCUDH3/Wy8DmBKd9O2Dy1/eymjyUF3QDxdWIqRn6rALgv+9voPDH
   w==;
X-CSE-ConnectionGUID: ZwbCFIK5Sm6GeaR4g++npA==
X-CSE-MsgGUID: BJ0484QuSwW5wDvMPKvR4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636456"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636456"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:22 -0800
X-CSE-ConnectionGUID: DeI8KOmCTU+eMwO041mgVQ==
X-CSE-MsgGUID: mmwNsk/vQBGqbooCVTncrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224947"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:22 -0800
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
Subject: [PATCH v14 03/32] x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Mon, 24 Nov 2025 10:53:40 -0800
Message-ID: <20251124185412.24155-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
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

