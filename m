Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EB9170843
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009561; cv=none; b=JmJ0AOgB4oYbNFARSRD9X3tAwaY0884+AVktItj21eCpsqaEVeazf0w5HlgwQbqLyGr4CqGWeaSFF2MtvhPbZVx7+eEInBHzSe644BIj6FRJTuNPIHR1iUpuZsVQltbj3yuM85KdyN7mm/RTt6np10nMhIpZXjt17HOiSFrWDr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009561; c=relaxed/simple;
	bh=lZYzm3lNTQIwPtmBGlNcykYl5a3Sth3jQBN2NdO1s4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkeG6eA5jl6fH2+SD70+TW8J40ucQcPfKrCdJgGoLDyZlpnO+wS2lYoZ/pu/66ZMf6y/OBQBE82yh4Eoz92R89YjHdSRP1ZW48OoIHP1mN4tR8UH/PpAjBE1e40T0o1PARU/QGSezU2Iezp6Ltf9sJczL396zkw66rmYHnaXVRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QZM06UGo; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QZM06UGo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009559; x=1750545559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lZYzm3lNTQIwPtmBGlNcykYl5a3Sth3jQBN2NdO1s4I=;
  b=QZM06UGoYaGjlujjBXyNDGY6OWIGzv+NMllS/9qUwcTnIcVSK4c2s0J2
   yO/AKOlg6o483hb7IsnXOO1+A2Usmz9qsBnmk8a+MV7MwuHiM7OmRgdk9
   Yi/ooqOf5VFrGQiHHIoNT/zmhdxNGhzVbKDUrAK98e5vEdu6HuZQOpwVR
   ITDk0vJCIk3X4OYZZv/sP85ZKF2+WzW7eSnPBatK/zsd/SJ7Wau4AVRh1
   g32j1j6eat13FnncaANinDa8jk6S74aSkvf3pwciuuWGD2m6yuHd+8bdb
   9fBfioVODlyvuF9Wp+jTb96s4YOpuKiY2MneWI38IRkXDzV7yKAELhxns
   A==;
X-CSE-ConnectionGUID: WuzSaFZsS6OeozEcG4jISg==
X-CSE-MsgGUID: qvjycOKlS4GqJUrsGDZWKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691348"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691348"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:09 -0700
X-CSE-ConnectionGUID: 9A6lfZKSSoKUwGgFqehWOg==
X-CSE-MsgGUID: zxqyvMAUT8KFDAa25lNaow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935683"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:09 -0700
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
Subject: [PATCH v21 14/18] x86/resctrl: Fill out rmid_read structure for smp_call*() to read a counter
Date: Fri, 21 Jun 2024 15:38:55 -0700
Message-ID: <20240621223859.43471-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621223859.43471-1-tony.luck@intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
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
---
 arch/x86/kernel/cpu/resctrl/internal.h    |  2 +-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 40 ++++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/monitor.c     |  1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  2 +-
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index f66c7f12e91e..e5013c8dac84 100644
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
index 3b9383612c35..7da2992e2c45 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -515,7 +515,7 @@ static int smp_mon_event_count(void *arg)
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
-		    int evtid, int first)
+		    cpumask_t *cpumask, int evtid, int first)
 {
 	int cpu;
 
@@ -537,7 +537,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		return;
 	}
 
-	cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask, RESCTRL_PICK_ANY_CPU);
+	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
 	 * cpumask_any_housekeeping() prefers housekeeping CPUs, but
@@ -546,7 +546,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * counters on some platforms if its called in IRQ context.
 	 */
 	if (tick_nohz_full_cpu(cpu))
-		smp_call_function_any(&d->hdr.cpu_mask, mon_event_count, rr, 1);
+		smp_call_function_any(cpumask, mon_event_count, rr, 1);
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
@@ -575,16 +575,40 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
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
+		 * This file requires summing across all SNC domains that share
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
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index ff4e74594a19..877d898e8fd0 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -785,6 +785,7 @@ static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
 	rr.first = false;
 	rr.r = r;
 	rr.d = d;
+	rr.ci = NULL;
 
 	/*
 	 * This is protected from concurrent reads from user
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 14482d88b68c..5b980cb05c5f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3072,7 +3072,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 			return ret;
 
 		if (!do_sum && is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
+			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
 	}
 
 	return 0;
-- 
2.45.2

