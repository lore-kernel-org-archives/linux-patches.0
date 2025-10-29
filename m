Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A0434F46F
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754897; cv=none; b=VjXDr1ksQ8KICU9RbHNiHoWb7wSavs1yQizTan1Io6WlNE9UO4E/UEbwGyY5XQG5iMfocZA099m0GBYLk+4XwQjnJCzTmy24vU+swC2woICNHiIgtTJmgPRL9QQ1g8EdGaFxXtYY70XdOIyjrft23IKQlYhUzC4zfPCsLHRUjdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754897; c=relaxed/simple;
	bh=BFzzBcBsNPwLmYYPqw9ZqCaQ1hYVrnpLzhorJovMWCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7OOKU8jBqRgFy+pwSg/xgHcEqSEY710k0+NAK4euYt68+acUzFDJUv5Jy01dP3lPSsTFcR3qCi94KChjn+Ro7rZRJsG35DjmxTjr6wn+SrfbCR+z9B2lWuUXXo/K3Fa2m65HVaXgz3EO/pZgrRqsDeCqsbRO48ZLZfa8TmyJ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y1EQKN+I; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y1EQKN+I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754895; x=1793290895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BFzzBcBsNPwLmYYPqw9ZqCaQ1hYVrnpLzhorJovMWCk=;
  b=Y1EQKN+I73aaV9wnBbGHedFD1tUkWr8HzhWPiKLn80Ae/FMr94CZzYQ4
   9Z9nXi7T3PaKGye2nOc/iVow5XiWuLGvYzome0h0ZJOZVTqWEyQgg61QJ
   9x4yN8MnEHbzbClAyMc7UZVCP64sSDSVMwUEa9xIoELW0l3GwiXo2jYEu
   6evn9rySzekjLjIlTCaqFbwb5imnYGnF4qB+SaRjPQbUpPMEdgDQsa7IF
   x27DgcwMvrgq9T+oOdRXEcaHUZq0Nw5ieAYrxYiE0gpz9LpqjZrKuuMQE
   5dPFA8AFwIXVJHOhNALvPXn1pCAj7N5bPRNCF3v7s8W6YSCwuxsOlJU9M
   A==;
X-CSE-ConnectionGUID: jE/agj2/QyyBD5hH6CvV9Q==
X-CSE-MsgGUID: t7JS/237R2ej8jaxP9Unkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481321"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481321"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:29 -0700
X-CSE-ConnectionGUID: kb8MrSkNSxWdcacoutcFwQ==
X-CSE-MsgGUID: I8MprbcvRkqk3WO/Pk9a4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901334"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:28 -0700
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
Subject: [PATCH v13 11/32] x86,fs/resctrl: Handle events that can be read from any CPU
Date: Wed, 29 Oct 2025 09:20:54 -0700
Message-ID: <20251029162118.40604-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that monitor events can only be read from a CPU in the
cpumask_t set of each domain.  This is true for x86 events accessed
with an MSR interface, but may not be true for other access methods such
as MMIO.

Introduce and use flag mon_evt::any_cpu, settable by architecture, that
indicates there are no restrictions on which CPU can read that event.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 2 +-
 fs/resctrl/internal.h              | 2 ++
 arch/x86/kernel/cpu/resctrl/core.c | 6 +++---
 fs/resctrl/ctrlmondata.c           | 6 ++++++
 fs/resctrl/monitor.c               | 3 ++-
 5 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index a07542957e5a..702205505dc9 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -409,7 +409,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 12a2ab7e3c9b..40b76eaa33d0 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -61,6 +61,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  *			READS_TO_REMOTE_MEM) being tracked by @evtid.
  *			Only valid if @evtid is an MBM event.
  * @configurable:	true if the event is configurable
+ * @any_cpu:		true if the event can be read from any CPU
  * @enabled:		true if the event is enabled
  */
 struct mon_evt {
@@ -69,6 +70,7 @@ struct mon_evt {
 	char			*name;
 	u32			evt_cfg;
 	bool			configurable;
+	bool			any_cpu;
 	bool			enabled;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 99d1048d29d1..78ad493dcc01 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -893,15 +893,15 @@ static __init bool get_rdt_mon_resources(void)
 	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
-		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index c3656812848b..883be6f0810f 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -574,6 +574,11 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		}
 	}
 
+	if (evt->any_cpu) {
+		mon_event_count(rr);
+		goto out_ctx_free;
+	}
+
 	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
@@ -587,6 +592,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
+out_ctx_free:
 	if (rr->arch_mon_ctx)
 		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 5cf928e10eaf..6eab98b47816 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -975,7 +975,7 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
 		return;
@@ -984,6 +984,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
 		return;
 	}
 
+	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].enabled = true;
 }
 
-- 
2.51.0

