Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4B31F19A
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886852; cv=none; b=du6LnBsAsyv6QsNF1gbFhpJZjKWk5nNQQKTcc2crylADMbI5mJ/PewLZZcwET2YK4zmyUqSr00vWl1nmpdIp4zDFZoQGz/PmeCAMHv9Pjqo7ExSxkvOFdkMXLYj75P8Fzcn+d9U7JKaxKnOxzBptIlwJq4J8M4qUTAVPzxnLnJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886852; c=relaxed/simple;
	bh=L1d/vvYdkqDxKWY4/nne6uJtR33vIUzSRBs3GCk6o/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jle6aqme3YCQDm3jvyUHYnHbcVFzYwKvZtCI+nCYZa3BJW7lVRBOOysreGKAcKg3Fh+geSlfV28szNxlzN8cE/WUjVTTKBzZaev5xMv+U7+XDVnO185pOfbaq4My74vYJ/5yA+AMQ+IWwfnSwnOUHmpbnYkqJ2UY/KnOdJ+FN08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SwnShG5v; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SwnShG5v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886851; x=1777422851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L1d/vvYdkqDxKWY4/nne6uJtR33vIUzSRBs3GCk6o/w=;
  b=SwnShG5vdPTsnwig3+XO6Pymr4X5LQ8SlBqEL7d8vaHVnbRZhI/Z+RT7
   9d502ogcSFk+dm7Zsxm7BaH0wZMF8wGPDC0ZHZsnJLjYAuMNUC3DrsOsC
   Xb/wDGdRJ+Oq9eXYaNc1QL+iKvoWO59IGVmFNwyuyVb8040vFtIjN1KRQ
   M1e75qwl7GOTxjQk+BVkDqWS75IoJtifA4USzcXp8XiHtmMFMYr1I4J1d
   efClIuAp13gEZHtJW1FvT6vgnuq5jp4NxfnfvTzx+bxUK8Kc8/ej6dFb0
   vNlwgV1X5azjJ3xJh98bXSSRJ+BGr8gegpJCij72bUMpU45GhJpcWL62+
   A==;
X-CSE-ConnectionGUID: uecGEdy0RVWg7K6a8JU06Q==
X-CSE-MsgGUID: N2AknpHJSqyqy+lP74BIUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148060"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148060"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:09 -0700
X-CSE-ConnectionGUID: p29M5rZHSuqVhD+JJa7eGw==
X-CSE-MsgGUID: NAh4lRZmSn2gkE6Qqvy+tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133393964"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:08 -0700
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
Subject: [PATCH v4 04/31] fs/resctrl: Change how and when events are initialized
Date: Mon, 28 Apr 2025 17:33:30 -0700
Message-ID: <20250429003359.375508-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Existing code assumes that all monitor events are associated with
the RDT_RESOURCE_L3 resource. Also that all event enumeration is
complete during early resctrl initialization. Neither of these
assumptions remain true for new events.

Each resource must include a list of enabled events that is used
to add appropriately named files when creating mon_data directories
and to for the contents of "info/{resource}_MON/mon_features" file.

Move the building of enabled event lists for each resource from
resctrl_mon_resource_init() to rdt_get_tree() to delay it until
mount of the resctrl file system.

Add a new field to struct mon_evt to record which resource each
event is associated with so that events are added to the correct
resource event list.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h |  4 ++++
 fs/resctrl/monitor.c  | 33 ++++++++++++++++++++++-----------
 fs/resctrl/rdtgroup.c |  2 ++
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 6029b3285dd3..b69170760316 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -68,6 +68,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
 /**
  * struct mon_evt - Entry in the event list of a resource
  * @evtid:		event id
+ * @rid:		index of the resource for this event
  * @name:		name of the event
  * @configurable:	true if the event is configurable
  * @enabled:		true if the event is enabled
@@ -75,6 +76,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  */
 struct mon_evt {
 	enum resctrl_event_id	evtid;
+	enum resctrl_res_level	rid;
 	char			*name;
 	bool			configurable;
 	bool			enabled;
@@ -397,6 +399,8 @@ enum resctrl_event_id resctrl_get_mon_event_by_name(char *name);
 
 char *resctrl_mon_event_name(enum resctrl_event_id evt);
 
+void resctrl_init_mon_events(void);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 625cd328c790..a5a523f73249 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -845,14 +845,17 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	[QOS_L3_OCCUP_EVENT_ID] = {
 		.name	= "llc_occupancy",
 		.evtid	= QOS_L3_OCCUP_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
 	},
 	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
 		.name	= "mbm_total_bytes",
 		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
 	},
 	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
 		.name	= "mbm_local_bytes",
 		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
 	},
 };
 
@@ -886,21 +889,31 @@ char *resctrl_mon_event_name(enum resctrl_event_id evt)
 }
 
 /*
- * Initialize the event list for the resource.
+ * Initialize the event list for all mon_capable resources.
  *
- * Note that MBM events are also part of RDT_RESOURCE_L3 resource
- * because as per the SDM the total and local memory bandwidth
- * are enumerated as part of L3 monitoring.
+ * Called on each mount of the resctrl file system when all
+ * events have been enumerated. Only needs to build the per-resource
+ * event lists once.
  */
-static void l3_mon_evt_init(struct rdt_resource *r)
+void resctrl_init_mon_events(void)
 {
 	enum resctrl_event_id evt;
+	struct rdt_resource *r;
+	static bool only_once;
+
+	if (only_once)
+		return;
+	only_once = true;
 
-	INIT_LIST_HEAD(&r->evt_list);
+	for_each_mon_capable_rdt_resource(r)
+		INIT_LIST_HEAD(&r->evt_list);
 
-	for (evt = 0; evt < QOS_NUM_EVENTS; evt++)
-		if (mon_event_all[evt].enabled)
-			list_add_tail(&mon_event_all[evt].list, &r->evt_list);
+	for (evt = 0; evt < QOS_NUM_EVENTS; evt++) {
+		if (!mon_event_all[evt].enabled)
+			continue;
+		r = resctrl_arch_get_resource(mon_event_all[evt].rid);
+		list_add_tail(&mon_event_all[evt].list, &r->evt_list);
+	}
 }
 
 /**
@@ -927,8 +940,6 @@ int resctrl_mon_resource_init(void)
 	if (ret)
 		return ret;
 
-	l3_mon_evt_init(r);
-
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index c06752dfcb7c..e66dc041be5f 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2591,6 +2591,8 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	resctrl_init_mon_events();
+
 	ret = rdtgroup_setup_root(ctx);
 	if (ret)
 		goto out;
-- 
2.48.1

