Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2E63859CB
	for <patches@lists.linux.dev>; Fri, 15 May 2026 19:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778873997; cv=none; b=uiqJU0oP/R5W7dQ8ODg94pqQ6y8CMStIEYyAtQpTEnsz8v23tlpexViJSaDs3E3exXPyTZRs6diOqNGg41ZCAOZGuzZwPLemhLPFrYsTh9Gxa4OEyJs1Rbo71ep1/Ns7MEPWJnG2KZdWFQNiS0e6u9fAdcxE38I74RdhdhNQke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778873997; c=relaxed/simple;
	bh=Gzr2KNycChzD6zGq8x9xnRncTWTf8aVr1UXawk7ZQYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DI/ozwE2v1KlPpSepx7qgXrurNBl0a3qg1C0kTgJP6xxtyo4QjrOcRK98LVTGnpqCI66UKuKc3ZIKM1/3yQHl97N/BTuClouQVFksezAckWjcxIkKtY+o3v3xRtY6maIIhvFh/4m3Jy5GmbqNqhlHhbZxodvSsHcenlbxSPyegU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RLV+s1cX; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RLV+s1cX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778873995; x=1810409995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gzr2KNycChzD6zGq8x9xnRncTWTf8aVr1UXawk7ZQYA=;
  b=RLV+s1cXVBnHeSDAzGmTp2HjmikcjX90EAAJvUn4p5I9lrkCAqN0fPjO
   3gURxyyqxOubCZFuhKY/IYfCxdX64qA5R2i0mVATkHP9x0kJXr9n+BhFU
   TCkBArK7th3yNKTC3if43p5lJ1biEIy9CrxBqXe9K6AfLrlYBs8l9v4b+
   oH1uWsp7Y2r0KXVDpI7wM9vChuZks2fL0tkCVjFaFtSWfaWHyPVp0Pvup
   z8U33pk2fNUiCdNm6mTIhE1sCuYqk9RKTDJtBxGPK5+CTD+GqjqIdi3uB
   VBiog86VICPb6NpYShQq6QBtW5eKNlN4oTKSsqiTwXhx56BJyvRbA1KQb
   w==;
X-CSE-ConnectionGUID: Rn5VsB3gTo2xHzSjNXk4RA==
X-CSE-MsgGUID: ZF6Y8/LFQfC3W+Ns6NZdWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11787"; a="78972253"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="78972253"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:52 -0700
X-CSE-ConnectionGUID: SMm6XVgET3mxL6vwPlJpiw==
X-CSE-MsgGUID: f5KDMiVFTsOfNhbccgMoOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="237916580"
Received: from hanvin-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:52 -0700
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
Subject: [PATCH v2 5/5] fs/resctrl: Fix issues with worker threads when CPUs are taken offline
Date: Fri, 15 May 2026 12:39:44 -0700
Message-ID: <20260515193944.15114-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515193944.15114-1-tony.luck@intel.com>
References: <20260515193944.15114-1-tony.luck@intel.com>
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
index 9fd901c78dc6..c422850f044b 100644
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
+	 *   done by setting cqm_work_cpu to nr_cpu_ids. Find the domain
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
index 282a0acedea8..fd82fc78b058 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4376,8 +4376,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	if (resctrl_is_mbm_enabled())
-		cancel_delayed_work(&d->mbm_over);
+
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
 		/*
 		 * When a package is going down, forcefully
@@ -4388,7 +4387,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		 * package never comes back.
 		 */
 		__check_limbo(d, true);
-		cancel_delayed_work(&d->cqm_limbo);
 	}
 
 	domain_destroy_l3_mon_state(d);
@@ -4569,13 +4567,28 @@ void resctrl_offline_cpu(unsigned int cpu)
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

