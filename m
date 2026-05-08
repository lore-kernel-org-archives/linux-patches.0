Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41523CFF40
	for <patches@lists.linux.dev>; Fri,  8 May 2026 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778264518; cv=none; b=rEYPlqUX6pAu2vD5YuxvcHN2CkyBDWSDBIC1x7kRTMDSOEWv+FYbwySWmzkgYUJFmkFc6JTC8o/ODAjh4cb4hAAJArm1tJDySD1Is9SB4sWTsI7hWb4mnheFcF+cojYBLesZoDZZYF+B1y2ZOVLWCL+kx/O9ZkSf9FAvwxDIaxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778264518; c=relaxed/simple;
	bh=mqPKAKENpxqDTUksGBOXYvclAaeRmAP8h/OdzeG4Fjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVUX8xVLbIxvIjnTNF1E1ntdq6rWEVyKdayDdEc2zt2UL67zHOYsGJZTojL/6LtJhSr+rX7fxnxhSKzEdi3HP80jkgJvwLY+q1F3e5vqrJ00HewdsF6T+XRBOH8B/X3hRYPQUrBj3GgFuOKaqMrHMLwTRbR0b+2VfVoYX0ApSbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YjJSXmwS; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YjJSXmwS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778264513; x=1809800513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mqPKAKENpxqDTUksGBOXYvclAaeRmAP8h/OdzeG4Fjs=;
  b=YjJSXmwSCP+AZIOxuY65p7yk4tZzOi9iJeU9mRU3HOOL+pHpTdAwG0lF
   y5KVsPjDvLZBTB18PFjY+7KpR1oAVqv4jYfioEUslV+O167U/tR2A8bdp
   ZE38G+7NgAsVo9xFVMLYARbpfVxoWvkby0i6gFW70GWhuLz98/MVyW7WL
   nlnkOnxTWTjep21CsKBM5p1LIbOa6NaupPpv0JcE4JtRPYz3nRRrX0bRL
   vJKtl7oCT5dHzIlaXu8JwgDUnmxWFtziguZZUIbA5t7dSumF5wb3kN7oT
   jRr9bdD5l26xi1QuL8BMoKx1gJ9TzNOymMccfrdhAoPvAnnH9O6HjGEA/
   Q==;
X-CSE-ConnectionGUID: ZULSHhMTQsG9gGD7Wawh4Q==
X-CSE-MsgGUID: IGrROZwxT3SW+3li5dmSNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="79264166"
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="79264166"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 11:21:50 -0700
X-CSE-ConnectionGUID: NAPzry18RjShpNYyXNeLvw==
X-CSE-MsgGUID: bBPE7fLZTfCn04iitsO7hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="233776436"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.98])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 11:21:49 -0700
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
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4/4] fs/resctrl: Fix issues with worker threads when CPUs are taken offline
Date: Fri,  8 May 2026 11:21:43 -0700
Message-ID: <20260508182143.14592-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260508182143.14592-1-tony.luck@intel.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Reinette Chatre <reinette.chatre@intel.com>

Sashiko noticed[1] a user-after-free in the resctrl worker thread code
where the rdt_l3_mon_domain structure was freed while the worker was blocked
waiting for locks.

The root issue is that cancel_delayed_work() does not block in the case where
the worker thread is executing. This results in the race that Sashiko noticed,
but also causes problems when the CPU that has been chosen to service the
worker thread is taken offline.

Note that worker threads are allowed to delete their own work_struct
(see comment in kernel/workqueue.c:process_one_work()) so there can't be
any problems on the return path from the worker in this case where the
work_struct was deleted by other code while the worker was executing.

Indicate failure of cancel_delayed_work() calls in resctrl_offline_cpu()
by setting d->mbm_work_cpu or d->cqm_work_cpu to nr_cpu_ids. Make the worker
threads check to see if they are no longer bound to the right CPU. In this
case search the L3 domain list for any domain(s) with the work cpu set to
nr_cpu_ids. In the case where the last CPU was removed from a domain, the
domain has been removed from the list and there is nothing to do. If the
domain still exists, then restart the worker on any of the remaining CPUs.

Remove redundant cancel_delayed_work() calls from resctrl_offline_mon_domain().

Fixes: 24247aeeabe9 ("x86/intel_rdt/cqm: Improve limbo list processing")
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
---
 fs/resctrl/monitor.c  | 55 +++++++++++++++++++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c | 27 +++++++++++++++------
 2 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9fd901c78dc6..02434d11e024 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -791,12 +791,38 @@ static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
  */
 void cqm_handle_limbo(struct work_struct *work)
 {
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
 	struct rdt_l3_mon_domain *d;
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
+	/*
+	 * Worker was blocked waiting for the CPU it was running on to go
+	 * offline. Handle two scenarios:
+	 * - Worker was running on the last CPU of a domain. The domain and
+	 *   thus the work_struct has been freed so do not attempt to obtain
+	 *   domain via container_of(). All remaining domains have limbo
+	 *   handlers so the loop will not find any domains needing a
+	 *   limbo handler. Just exit.
+	 * - Worker was running on CPU that just went offline with other
+	 *   CPUs in domain still running and available to take over the
+	 *   worker. Offline handler could not schedule a new worker on
+	 *   another CPU in the domain but signaled that this needs to be
+	 *   done by setting mbm_work_cpu to nr_cpu_ids. Find the domain
+	 *   that needs a worker and schedule it after the normal CQM
+	 *   interval.
+	 */
+	if (!is_percpu_thread()) {
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			if (d->cqm_work_cpu == nr_cpu_ids)
+				cqm_setup_limbo_handler(d, CQM_LIMBOCHECK_INTERVAL,
+							RESCTRL_PICK_ANY_CPU);
+		}
+		goto out_unlock;
+	}
+
 	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
 
 	__check_limbo(d, false);
@@ -808,6 +834,7 @@ void cqm_handle_limbo(struct work_struct *work)
 					 delay);
 	}
 
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 }
@@ -852,6 +879,34 @@ void mbm_handle_overflow(struct work_struct *work)
 		goto out_unlock;
 
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+
+	/*
+	 * Worker was blocked waiting for the CPU it was running on to go
+	 * offline. Handle two scenarios:
+	 * - Worker was running on the last CPU of a domain. The domain and
+	 *   thus the work_struct has been freed so do not attempt to obtain
+	 *   domain via container_of(). All remaining domains have overflow
+	 *   handlers so the loop will not find any domains needing an
+	 *   overflow handler. Just exit.
+	 * - Worker was running on CPU that just went offline with other
+	 *   CPUs in domain still running and available to take over the
+	 *   worker. Offline handler could not schedule a new worker on
+	 *   another CPU in the domain but signaled that this needs to be
+	 *   done by setting mbm_work_cpu to nr_cpu_ids. Find the domain
+	 *   that needs a worker and schedule it to run after the normal
+	 *   MBM interval. This is completely safe on CPUs with wide MBM
+	 *   counters. Likely OK for old CPUs with narrow counters as the
+	 *   MBM_OVERFLOW_INTERVAL was picked conservatively.
+	 */
+	if (!is_percpu_thread()) {
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			if (d->mbm_work_cpu == nr_cpu_ids)
+				mbm_setup_overflow_handler(d, MBM_OVERFLOW_INTERVAL,
+							   RESCTRL_PICK_ANY_CPU);
+		}
+		goto out_unlock;
+	}
+
 	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 62e1e4c30f78..bab9afd5066e 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4343,8 +4343,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	if (resctrl_is_mbm_enabled())
-		cancel_delayed_work(&d->mbm_over);
+
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
 		/*
 		 * When a package is going down, forcefully
@@ -4355,7 +4354,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		 * package never comes back.
 		 */
 		__check_limbo(d, true);
-		cancel_delayed_work(&d->cqm_limbo);
 	}
 
 	domain_destroy_l3_mon_state(d);
@@ -4536,13 +4534,28 @@ void resctrl_offline_cpu(unsigned int cpu)
 	d = get_mon_domain_from_cpu(cpu, l3);
 	if (d) {
 		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu) {
-			cancel_delayed_work(&d->mbm_over);
-			mbm_setup_overflow_handler(d, 0, cpu);
+			if (cancel_delayed_work(&d->mbm_over)) {
+				mbm_setup_overflow_handler(d, 0, cpu);
+			} else {
+				/*
+				 * Unable to schedule work on new CPU if it
+				 * is currently running since the re-schedule
+				 * will just force new work to run on
+				 * current CPU. Mark domain's worker as
+				 * needing to be rescheduled to be handled
+				 * by worker itself.
+				 */
+				d->mbm_work_cpu = nr_cpu_ids;
+			}
 		}
 		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) &&
 		    cpu == d->cqm_work_cpu && has_busy_rmid(d)) {
-			cancel_delayed_work(&d->cqm_limbo);
-			cqm_setup_limbo_handler(d, 0, cpu);
+			if (cancel_delayed_work(&d->cqm_limbo)) {
+				cqm_setup_limbo_handler(d, 0, cpu);
+			} else {
+				/* Same as mbm_work_cpu case above */
+				d->cqm_work_cpu = nr_cpu_ids;
+			}
 		}
 	}
 
-- 
2.54.0

