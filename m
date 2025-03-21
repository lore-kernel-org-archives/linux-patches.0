Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6780C23372A
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598987; cv=none; b=F7EBMByJ2HZ2Rcmw3fKuW9PFFKShiBDwTNH+GoSnW+pR/awQVxmpeaeKfRox8vtIWQh1AoYnnpOJuaLBARh3M/MlNeC1/SK3INiwssxxY6ikqKujI1+vrtNUilrroRFURLQzHkGWMmrZN0TjQS/9cSKkqjZCQAVQxK8Z4GZQKnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598987; c=relaxed/simple;
	bh=Tevqw1RmArPpC2Ze0nf0CBxzpci8OzxKGJJTa6CwTvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J80EoQYZP2uEJ7f5FHfNHpg6G7GafLDH6HBPfOpj8E/6jAnfBIsEoYe/piNlMHLokwst0pl68Nffc+ysajZk8JxC8A9kk6KpziTLhracX9F+ECPg4+sT84hQKEXmgkDx+FT8MWgFO3tfyjpQHWQTHpCbM5YfQqgEtDaY+JtqrBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J2aqy2Cb; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J2aqy2Cb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598986; x=1774134986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tevqw1RmArPpC2Ze0nf0CBxzpci8OzxKGJJTa6CwTvc=;
  b=J2aqy2CbP/hNCx4ZMDgatOWjAiQzAEX0TAIh3Qlgv6vzXF66fyeIVveX
   UIcA6j+M1mx/VHgCUYFhABzJXjerUhcHHRRpEjAxz1DNft3z1IGwFLJzU
   sPd67Tvc1rclQlnTgigRhxXx/Rdq8FH1VnkuZ7CK3U8L94O19gvJLNFhN
   dBs3GgdJsPDONkVCA9Ssbyl7TBbGHLLi2NZ6Fb2HI3hZXhW6u/ixZOoCU
   aJHfaq5fCBa3IhxnyLqHD7CM0Tmq6HBC9VKomtfTkLuQBD0Vkqnq+bB9p
   csyDee112JLhl3Wb6g1E5DI2xPVf68QeMSKwtn8CSQvdY9urN4HZ1jvSy
   g==;
X-CSE-ConnectionGUID: 5BiY4umGS8+gs6M40CM+Pw==
X-CSE-MsgGUID: UXrToGkoSe+0nLEwognRGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604596"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604596"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:22 -0700
X-CSE-ConnectionGUID: v4xcqgwoTVKEay4ZRmficw==
X-CSE-MsgGUID: 27922Y0nQfierbmeQ9yyzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354312"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 08/16] x86/resctrl: Add Intel PMT domain specific code
Date: Fri, 21 Mar 2025 16:15:58 -0700
Message-ID: <20250321231609.57418-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Domain specific initialization and tear down. Very simple as
there are no domain specific elements that need to be allocated
or initiailazed. Just the domain itself.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 32 ++++++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c              | 11 ++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 1ab0f5eec244..2adf40d8de32 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -541,6 +541,29 @@ static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct
 	}
 }
 
+static void setup_intel_aet_mon_domain(int cpu, int id, struct rdt_resource *r,
+				       struct list_head *add_pos)
+{
+	struct rdt_core_mon_domain *d;
+	int err;
+
+	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
+	if (!d)
+		return;
+
+	d->hdr.id = id;
+	d->hdr.type = RESCTRL_MON_DOMAIN;
+	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+	list_add_tail_rcu(&d->hdr.list, add_pos);
+
+	err = resctrl_online_mon_domain(r, &d->hdr);
+	if (err) {
+		list_del_rcu(&d->hdr.list);
+		synchronize_rcu();
+		kfree(d);
+	}
+}
+
 static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 {
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
@@ -565,6 +588,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	case RDT_RESOURCE_L3:
 		setup_l3_mon_domain(cpu, id, r, add_pos);
 		break;
+	case RDT_RESOURCE_INTEL_AET:
+		setup_intel_aet_mon_domain(cpu, id, r, add_pos);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 	}
@@ -661,6 +687,12 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		synchronize_rcu();
 		mon_domain_free(hw_dom);
 		break;
+	case RDT_RESOURCE_INTEL_AET:
+		resctrl_offline_mon_domain(r, d);
+		list_del_rcu(&hdr->list);
+		synchronize_rcu();
+		kfree(container_of(hdr, struct rdt_core_mon_domain, hdr));
+		break;
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 4833dfa08ce3..d3919642aa9b 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4077,6 +4077,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	if (resctrl_mounted && resctrl_arch_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, &d->hdr);
 
+	if (r->rid == RDT_RESOURCE_INTEL_AET)
+		goto done;
+
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_arch_is_llc_occupancy_enabled() && has_busy_rmid(d)) {
@@ -4093,7 +4096,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	}
 
 	domain_destroy_mon_state(d);
-
+done:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
@@ -4160,11 +4163,14 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
 	struct rdt_mon_domain *d;
-	int err;
+	int err = 0;
 
 	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	mutex_lock(&rdtgroup_mutex);
 
+	if (r->rid == RDT_RESOURCE_INTEL_AET)
+		goto do_mkdir;
+
 	err = domain_setup_mon_state(r, d);
 	if (err)
 		goto out_unlock;
@@ -4178,6 +4184,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	if (resctrl_arch_is_llc_occupancy_enabled())
 		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
 
+do_mkdir:
 	/*
 	 * If the filesystem is not mounted then only the default resource group
 	 * exists. Creation of its directories is deferred until mount time
-- 
2.48.1

