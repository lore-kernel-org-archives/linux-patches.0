Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2224140362
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934826; cv=none; b=Wlt+TUtBXcDEe6rzfHiX90QnCr9dcrjP19yI5BD4z4Q3wQz2EGM7j/PBEskzxwrJ/ie3et4+ztKUdAQnlaQa1eF9qq4x5VmJVqAsQO+gT+ilrKK3w3ztNcdNn2UfAE+OJulxo8433nS+lQLW6gftteotLqrHwULYib2mZINreJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934826; c=relaxed/simple;
	bh=IorIMWxs/gs9G2e+fIJjKu+T6wnYFb7FW0tiY1sOfW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI0ZVIwraYvkT/UXqq3SXowBN4Tfk+I1uqqPs9zxkDutHGypqaUxaMbk9UIgngDdRzDsaUEjlGgp76nMCgccxFbk4Wlj7aelRo2Y8ftw73ltNw6VWIUnOimHfIyvJXKXMcj69U5C3iS6UDygGQtOhmfWFIenYH62FCUlRD6rpKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iUJc9hbS; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iUJc9hbS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934825; x=1748470825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IorIMWxs/gs9G2e+fIJjKu+T6wnYFb7FW0tiY1sOfW8=;
  b=iUJc9hbSILDzOx1VHqhahmODOgT+AYBeaJ1Sj0FA/s+OneOaez3dsUUP
   aeD6oixsfGWNS8uHlavFSrcuiwUPgKwwF3y00/N+7wd4frVvAdfwUA1OV
   9GNnxfjyNbGs28wDBzARW1EQz53qYLlkYC2fYH7NRzgXI7xYlARibEUGK
   WTy6bjmDdXVcO95RnsKfiFVY6cYPDJao0sd0gW9+4ygUrOrzR9Xp0h16F
   wCZvsgwcbkpLkJQ4bwf7iEgga8NbCbQxY/adX206XRdPfaz8W4jdOFm0t
   wr73mUqcv2+f1n7F31mA9j4MVvyHGsefB0HwDncliwHJz7bxTjTWE0reV
   A==;
X-CSE-ConnectionGUID: btQaChI/R8y8uIJWWi82Ag==
X-CSE-MsgGUID: XMb0MYxsQ+em0rJhsDVymw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812234"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812234"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:19 -0700
X-CSE-ConnectionGUID: bAd8cXkbSu2OItmG3YHEDw==
X-CSE-MsgGUID: L5hHJfCnQne9S7kgBGZymg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090756"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:18 -0700
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
Subject: [PATCH v19 14/20] x86/resctrl: Fill out rmid_read structure for smp_call*() to read a counter
Date: Tue, 28 May 2024 15:19:59 -0700
Message-ID: <20240528222006.58283-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
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

The one exception is the sumdomains field that is set by the caller
(either rdtgroup_mondata_show() or mon_add_all_files()).

When rmid_read.sumdomains is false:
	The domain field "d" specifies the only domain to read
	CPU to execute is chosen from d->hdr.cpu_mask

When rmid_read.sumdomains is true:
	The domain field is NULL.
	The cache_info field indicates that all domains
	that are part of that cache instance should be
	summed.
	CPU to execute is chosen from ci->shared_cpu_mask

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 28 ++++++++++++++++++-----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 3b9383612c35..4e394400e575 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -517,6 +517,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
 		    int evtid, int first)
 {
+	cpumask_t *cpumask;
 	int cpu;
 
 	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
@@ -537,7 +538,8 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		return;
 	}
 
-	cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask, RESCTRL_PICK_ANY_CPU);
+	cpumask = rr->sumdomains ? &rr->ci->shared_cpu_map : &d->hdr.cpu_mask;
+	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
 	 * cpumask_any_housekeeping() prefers housekeeping CPUs, but
@@ -546,7 +548,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * counters on some platforms if its called in IRQ context.
 	 */
 	if (tick_nohz_full_cpu(cpu))
-		smp_call_function_any(&d->hdr.cpu_mask, mon_event_count, rr, 1);
+		smp_call_function_any(cpumask, mon_event_count, rr, 1);
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
@@ -575,15 +577,29 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	resid = md.u.rid;
 	domid = md.u.domid;
 	evtid = md.u.evtid;
-
+	rr.sumdomains = md.u.sum;
 	r = &rdt_resources_all[resid].r_resctrl;
-	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
-	if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+
+	if (rr.sumdomains) {
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			if (d->ci->id == domid) {
+				rr.ci = d->ci;
+				d = NULL;
+				goto got_cacheinfo;
+			}
+		}
 		ret = -ENOENT;
 		goto out;
+	} else {
+		hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
+		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+			ret = -ENOENT;
+			goto out;
+		}
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
 	}
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
 
+got_cacheinfo:
 	mon_event_read(&rr, r, d, rdtgrp, evtid, false);
 
 	if (rr.err == -EIO)
-- 
2.45.0

