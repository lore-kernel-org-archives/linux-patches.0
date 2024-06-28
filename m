Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA3913E04B
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611801; cv=none; b=RE3M09uu2udBlpfmFpEughwbmSJ8jYueh3e5qNt5Wo4xrGG2Z1AZcAVjvXBSibY/iY02tBvHFJvm8Ph9z/87NjdwJBf6p5iNXB0bVPThDypHHBsDEL2zXHW/P0cX4hYNgcuQ2kAv9qOWiWm08ShZ/6W9SL7DLTSNIt2+QBKKjTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611801; c=relaxed/simple;
	bh=XHqnON1ZlIgjEQVtBP33bJ1OgEYv4ca7K5/9djHRK90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca/Z+tev6CPmcJpMvGU+MonpDiYeivQ0K9dM2dXO/ZtXBk3/Z29JdYeu4UiUfYP9fGwR/Ueu9bYQ+HK+lzWZycC/aoKNNFvWia7n5gLYloRd2g0ORHCFMuHArcGJkAA7FqRe+xmvipRvthnBz7XlMkDWijHt9N1Fd0AorxsTAcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DSea7mSy; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DSea7mSy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719611799; x=1751147799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XHqnON1ZlIgjEQVtBP33bJ1OgEYv4ca7K5/9djHRK90=;
  b=DSea7mSysjSOddygD4bu+of8yxeF2MKKEGGZslT2jloVqUI0YB8Yjfsh
   /QXPgjXbaaPDJB7VMtIMprqSC/WUq+x8J1QIqQF0tdRfyF6hfDKpAKBh9
   fBNEjq6qP8eMHr7AnYfCTSn41ttJlLiyP4zSUsx/Lcq4xjszCgu7b04gw
   akTPhtsHW+24AI27/JRifA5iAl9BkKygB7uf6/twRjNSbtFZWDGDcoVwt
   jXgAl/cKsyP8hRO8U9aKjReV4UHcmw97P18l7sNp5XHlj9YEEACzdWbby
   9MynWZh+cfkTFuSNfa61KN6MLiYim5J7dramzjp86qoUoju4NCwdXkZnu
   Q==;
X-CSE-ConnectionGUID: gnnBzBMaQw+T1toRNC4Raw==
X-CSE-MsgGUID: 7n5RWbqBQJSLPKO1QhfVRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16762635"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="16762635"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:28 -0700
X-CSE-ConnectionGUID: 5gj9MZB9QeC6jfoUWpTfSQ==
X-CSE-MsgGUID: jn2ymCsXScujguKHnJ4VYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="68065678"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:27 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v23 15/19] x86/resctrl: Fill out rmid_read structure for smp_call*() to read a counter
Date: Fri, 28 Jun 2024 14:56:15 -0700
Message-ID: <20240628215619.76401-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240628215619.76401-1-tony.luck@intel.com>
References: <20240628215619.76401-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mon_event_read() fills out most fields of the struct rmid_read that is
passed via an smp_call*() function to a CPU that is part of the correct
domain to read the monitor counters.

With Sub-NUMA Cluster (SNC) mode there are now two cases to handle:

1) Reading a file that returns a value for a single domain.
   + Choose the CPU to execute from the domain cpu_mask

2) Reading a file that must sum across domains sharing an L3 cache
   instance.
   + Indicate to called code that a sum is needed by passing a NULL
     rdt_mon_domain pointer.
   + Choose the CPU from the L3 shared_cpu_map.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    |  2 +-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 40 ++++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  2 +-
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 13d862221f9c..16982d1baf99 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -632,7 +632,7 @@ void mon_event_count(void *info);
 int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
-		    int evtid, int first);
+		    cpumask_t *cpumask, int evtid, int first);
 void mbm_setup_overflow_handler(struct rdt_mon_domain *dom,
 				unsigned long delay_ms,
 				int exclude_cpu);
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 4d76ff31a9e0..50fa1fe9a073 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -515,7 +515,7 @@ static int smp_mon_event_count(void *arg)
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
-		    int evtid, int first)
+		    cpumask_t *cpumask, int evtid, int first)
 {
 	int cpu;
 
@@ -536,7 +536,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		return;
 	}
 
-	cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask, RESCTRL_PICK_ANY_CPU);
+	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
 	 * cpumask_any_housekeeping() prefers housekeeping CPUs, but
@@ -545,7 +545,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * counters on some platforms if its called in IRQ context.
 	 */
 	if (tick_nohz_full_cpu(cpu))
-		smp_call_function_any(&d->hdr.cpu_mask, mon_event_count, rr, 1);
+		smp_call_function_any(cpumask, mon_event_count, rr, 1);
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
@@ -574,16 +574,40 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	resid = md.u.rid;
 	domid = md.u.domid;
 	evtid = md.u.evtid;
-
 	r = &rdt_resources_all[resid].r_resctrl;
-	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
-	if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+
+	if (md.u.sum) {
+		/*
+		 * This file requires summing across all domains that share
+		 * the L3 cache id that was provided in the "domid" field of the
+		 * mon_data_bits union. Search all domains in the resource for
+		 * one that matches this cache id.
+		 */
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			if (d->ci->id == domid) {
+				rr.ci = d->ci;
+				mon_event_read(&rr, r, NULL, rdtgrp,
+					       &d->ci->shared_cpu_map, evtid, false);
+				goto checkresult;
+			}
+		}
 		ret = -ENOENT;
 		goto out;
+	} else {
+		/*
+		 * This file provides data from a single domain. Search
+		 * the resource to find the domain with "domid".
+		 */
+		hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
+		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+			ret = -ENOENT;
+			goto out;
+		}
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
 	}
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
 
-	mon_event_read(&rr, r, d, rdtgrp, evtid, false);
+checkresult:
 
 	if (rr.err == -EIO)
 		seq_puts(m, "Error\n");
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 67a8188c6d8f..cd0229f7c30e 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3073,7 +3073,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 			return ret;
 
 		if (!do_sum && is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
+			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
 	}
 
 	return 0;
-- 
2.45.2

