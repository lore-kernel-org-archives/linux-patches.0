Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C132EA48A
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956596; cv=none; b=PDs4Do7zAqcAKfG8+o/bUNaimSsf4KfbrQZfxMsUZEqBYAouCSnPBtMHNZhH1DiNyxsbx/nM66SXOy+QTOa3Fg8WVHVDBd5fb2XK6PrB0ZtBqM1ZMyHx5QHCmM6kaW4fiVhQ/XoQAUUU8i5BxhkaD5yoZBwEeOb7TVjI636R4HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956596; c=relaxed/simple;
	bh=Zv1eHL7bD5PZfEzAa30P++8w0+X3h9FO+wtSQI3RpE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTo2vvpgVd4bHJwqb0BQVnstd1emNygzf/sBz1qK5/X6EbdKbArAL72E8YZY0dhJcKy5s7pXYrX2rLOkvY8yRvN70sAMOn6WnYlV1EfEDh5CMXtloiyGGZ5NLTnTXZnMwSJ7oVsRlIZu2dn4OYfRaRsn3KvGGlYBYEO0D4xr4UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=niNqdodf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="niNqdodf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956596; x=1782492596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zv1eHL7bD5PZfEzAa30P++8w0+X3h9FO+wtSQI3RpE4=;
  b=niNqdodfxcPJlKKea9LOLswS3h/Vr7BdJAg6bCbvZQkv8rC+yiUNHcDa
   xybZING+I/pcjVST/B9exSPuL7FJ8DgEZhGIQbmthBVlVRFJvf8kJW2Dk
   yGNYRgiPJTSeLLQbcBR8G9E3hYuldqCvv8/2wEFl/V+LKkLkMKSjp3Sol
   2lSxWinYzooi6LJARlJ+XaqZx6/UE0XMGL9tYKH/xsfPdJ0tI6q9rBFrF
   MqT7xKHecUKVaZf3eelu71AGR3oUKfE8rIhSJxuHZuM6IW+1wiLzCIE0Y
   FC0Ix9f10UlOxt3PykEqx8Du7I4/BohPg3v8NB+4c9zdYsW5K06gougk6
   A==;
X-CSE-ConnectionGUID: AVv7cR95SoK1XMk5/4Hthw==
X-CSE-MsgGUID: nJXK9iqMQC6XbSbwECr/rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136356"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136356"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:53 -0700
X-CSE-ConnectionGUID: SVCo2lWfQAaKIzc+qBRz+A==
X-CSE-MsgGUID: YrHU+dhiRKeQ8jeCe9CP2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069177"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:52 -0700
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
Subject: [PATCH v6 06/30] x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
Date: Thu, 26 Jun 2025 09:49:15 -0700
Message-ID: <20250626164941.106341-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare for additional types of monitoring domains, move all the L3
resource monitoring domain initialization out of domain_add_cpu_mon()
and into a new helper function l3_mon_domain_setup() (name chosen
as the partner of existing l3_mon_domain_free()).

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 55 ++++++++++++++++++------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 420e4eb7c160..20b6f2bbf858 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -496,34 +496,13 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 	}
 }
 
-static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
 {
-	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct list_head *add_pos = NULL;
 	struct rdt_hw_mon_domain *hw_dom;
-	struct rdt_domain_hdr *hdr;
 	struct rdt_mon_domain *d;
 	struct cacheinfo *ci;
 	int err;
 
-	lockdep_assert_held(&domain_list_lock);
-
-	if (id < 0) {
-		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
-			     cpu, r->mon_scope, r->name);
-		return;
-	}
-
-	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
-	if (hdr) {
-		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
-			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-
-		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
-		return;
-	}
-
 	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
 	if (!hw_dom)
 		return;
@@ -558,6 +537,38 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	}
 }
 
+static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+{
+	int id = get_domain_id_from_scope(cpu, r->mon_scope);
+	struct list_head *add_pos = NULL;
+	struct rdt_domain_hdr *hdr;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	if (id < 0) {
+		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
+			     cpu, r->mon_scope, r->name);
+		return;
+	}
+
+	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
+	if (hdr) {
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
+			return;
+		cpumask_set_cpu(cpu, &hdr->cpu_mask);
+
+		return;
+	}
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		l3_mon_domain_setup(cpu, id, r, add_pos);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
 static void domain_add_cpu(int cpu, struct rdt_resource *r)
 {
 	if (r->alloc_capable)
-- 
2.49.0

