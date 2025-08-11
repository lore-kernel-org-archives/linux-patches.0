Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B0C2E0B68
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936255; cv=none; b=L8hbl+a21GaRnnB9mEy+YAYGxE7mgW6IeCutsPr+UOASiJ4jGjDEBg+nWHyxpYNgdXHqxDO7ogepxpdINHXGnPfoSPybTSS4+h9NNaEqf0bF4YI7Q1Kn2SKiPKGpajy6El2DLBgX3XrRRIOdBcTeoCnBaZEOai8K0gGIjWPPUGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936255; c=relaxed/simple;
	bh=KQC4IXN5w5C/nDLMZOPXo7/9Tk1KyuWT0KnhDFzVnms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdDNomiWDwDbYNTMJql5MaWrCxLW5IxSJW1EONGEw6AmASLKRZYJutTtfGH/5PqryG65zbstwkE1Jk7VU1JElp1BGmWsYoSOXqZk0n6wo9KwcuKjundrbXpjVWIJKKuA2PoMBOM24+TlDhEvEEudlFG1o19EW29tAetg84FwRw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mWbiJ+Fp; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mWbiJ+Fp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936254; x=1786472254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KQC4IXN5w5C/nDLMZOPXo7/9Tk1KyuWT0KnhDFzVnms=;
  b=mWbiJ+FpKjnvwhWLSef5IOeRm9zxY7v9MzL/7vEhAPwZPw1/7RRISIHo
   b1Rhb7jbCHRrzr8V+HFvQlcApDcNmOjfk/mvzfBufo0g4EXj0wQIf38fv
   fOcViBQu7JzOG3Te+Bi546nvfvYcZzloYu9BAGSsv1dp5JJ4yn0HLRq6L
   8LYTysHYtztjocQwl5uFhmoLQyG9M7nSnjA+IVGgXRyz/tsJBMjtI+6WP
   E/zSBCR/a8zic3d6nHxzdIpi9eYpOf4bgfh28CIwHVAKIxAlZUTbauHn1
   bPPFB3UvU9mEo55lMt3RxfLozEd22iqOFQF+gKBVmWB4v0StwbCkCbzSG
   Q==;
X-CSE-ConnectionGUID: E3hJ3j+hTi2p3yUUFwRIJg==
X-CSE-MsgGUID: +xORe6f7R8yfjrlZ90Dmdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277335"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277335"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
X-CSE-ConnectionGUID: pHEEAr65QWqUWxf6rnX95g==
X-CSE-MsgGUID: P3J576ORSfWoc9E3+VwzAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825612"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:22 -0700
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
Subject: [PATCH v8 01/32] x86,fs/resctrl: Consolidate monitor event descriptions
Date: Mon, 11 Aug 2025 11:16:35 -0700
Message-ID: <20250811181709.6241-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are currently only three monitor events, all associated with
the RDT_RESOURCE_L3 resource. Growing support for additional events
will be easier with some restructuring to have a single point in
file system code where all attributes of all events are defined.

Place all event descriptions into an array mon_event_all[]. Doing
this has the beneficial side effect of removing the need for
rdt_resource::evt_list.

Add resctrl_event_id::QOS_FIRST_EVENT for a lower bound on range
checks for event ids and as the starting index to scan mon_event_all[].

Drop the code that builds evt_list and change the two places where
the list is scanned to scan mon_event_all[] instead using a new
helper macro for_each_mon_event().

Architecture code now informs file system code which events are
available with resctrl_enable_mon_event().

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            |  4 +-
 include/linux/resctrl_types.h      | 12 ++++--
 fs/resctrl/internal.h              | 13 ++++--
 arch/x86/kernel/cpu/resctrl/core.c | 12 ++++--
 fs/resctrl/monitor.c               | 63 +++++++++++++++---------------
 fs/resctrl/rdtgroup.c              | 11 +++---
 6 files changed, 66 insertions(+), 49 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 6fb4894b8cfd..2944042bd84c 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -269,7 +269,6 @@ enum resctrl_schema_fmt {
  * @mon_domains:	RCU list of all monitor domains for this resource
  * @name:		Name to use in "schemata" file.
  * @schema_fmt:		Which format string and parser is used for this schema.
- * @evt_list:		List of monitoring events
  * @mbm_cfg_mask:	Bandwidth sources that can be tracked when bandwidth
  *			monitoring events can be configured.
  * @cdp_capable:	Is the CDP feature available on this resource
@@ -287,7 +286,6 @@ struct rdt_resource {
 	struct list_head	mon_domains;
 	char			*name;
 	enum resctrl_schema_fmt	schema_fmt;
-	struct list_head	evt_list;
 	unsigned int		mbm_cfg_mask;
 	bool			cdp_capable;
 };
@@ -372,6 +370,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
+void resctrl_enable_mon_event(enum resctrl_event_id eventid);
+
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
 
 /**
diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index a25fb9c4070d..2dadbc54e4b3 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -34,11 +34,15 @@
 /* Max event bits supported */
 #define MAX_EVT_CONFIG_BITS		GENMASK(6, 0)
 
-/*
- * Event IDs, the values match those used to program IA32_QM_EVTSEL before
- * reading IA32_QM_CTR on RDT systems.
- */
+/* Event IDs */
 enum resctrl_event_id {
+	/* Must match value of first event below */
+	QOS_FIRST_EVENT			= 0x01,
+
+	/*
+	 * These values match those used to program IA32_QM_EVTSEL before
+	 * reading IA32_QM_CTR on RDT systems.
+	 */
 	QOS_L3_OCCUP_EVENT_ID		= 0x01,
 	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
 	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 0a1eedba2b03..4f315b7e9ec0 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -52,19 +52,26 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
 }
 
 /**
- * struct mon_evt - Entry in the event list of a resource
+ * struct mon_evt - Properties of a monitor event
  * @evtid:		event id
+ * @rid:		resource id for this event
  * @name:		name of the event
  * @configurable:	true if the event is configurable
- * @list:		entry in &rdt_resource->evt_list
+ * @enabled:		true if the event is enabled
  */
 struct mon_evt {
 	enum resctrl_event_id	evtid;
+	enum resctrl_res_level	rid;
 	char			*name;
 	bool			configurable;
-	struct list_head	list;
+	bool			enabled;
 };
 
+extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
+
+#define for_each_mon_event(mevt) for (mevt = &mon_event_all[QOS_FIRST_EVENT];	\
+				      mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++)
+
 /**
  * struct mon_data - Monitoring details for each event file.
  * @list:            Member of the global @mon_data_kn_priv_list list.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 187d527ef73b..7fcae25874fe 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -864,12 +864,18 @@ static __init bool get_rdt_mon_resources(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 
-	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
+	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
+		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
 		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
-	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL))
+	}
+	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
+		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
 		rdt_mon_features |= (1 << QOS_L3_MBM_TOTAL_EVENT_ID);
-	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
+	}
+	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
+		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
 		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
+	}
 
 	if (!rdt_mon_features)
 		return false;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index f5637855c3ac..2313e48de55f 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -844,38 +844,39 @@ static void dom_data_exit(struct rdt_resource *r)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-static struct mon_evt llc_occupancy_event = {
-	.name		= "llc_occupancy",
-	.evtid		= QOS_L3_OCCUP_EVENT_ID,
-};
-
-static struct mon_evt mbm_total_event = {
-	.name		= "mbm_total_bytes",
-	.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
-};
-
-static struct mon_evt mbm_local_event = {
-	.name		= "mbm_local_bytes",
-	.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
-};
-
 /*
- * Initialize the event list for the resource.
- *
- * Note that MBM events are also part of RDT_RESOURCE_L3 resource
- * because as per the SDM the total and local memory bandwidth
- * are enumerated as part of L3 monitoring.
+ * All available events. Architecture code marks the ones that
+ * are supported by a system using resctrl_enable_mon_event()
+ * to set .enabled.
  */
-static void l3_mon_evt_init(struct rdt_resource *r)
+struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
+	[QOS_L3_OCCUP_EVENT_ID] = {
+		.name	= "llc_occupancy",
+		.evtid	= QOS_L3_OCCUP_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
+	},
+	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
+		.name	= "mbm_total_bytes",
+		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
+	},
+	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
+		.name	= "mbm_local_bytes",
+		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
+	},
+};
+
+void resctrl_enable_mon_event(enum resctrl_event_id eventid)
 {
-	INIT_LIST_HEAD(&r->evt_list);
+	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
+		return;
+	if (mon_event_all[eventid].enabled) {
+		pr_warn("Duplicate enable for event %d\n", eventid);
+		return;
+	}
 
-	if (resctrl_arch_is_llc_occupancy_enabled())
-		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
-	if (resctrl_arch_is_mbm_total_enabled())
-		list_add_tail(&mbm_total_event.list, &r->evt_list);
-	if (resctrl_arch_is_mbm_local_enabled())
-		list_add_tail(&mbm_local_event.list, &r->evt_list);
+	mon_event_all[eventid].enabled = true;
 }
 
 /**
@@ -902,15 +903,13 @@ int resctrl_mon_resource_init(void)
 	if (ret)
 		return ret;
 
-	l3_mon_evt_init(r);
-
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
-		mbm_total_event.configurable = true;
+		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_LOCAL_EVENT_ID)) {
-		mbm_local_event.configurable = true;
+		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_local_bytes_config",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 77d08229d855..b95501d4b5de 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1152,7 +1152,9 @@ static int rdt_mon_features_show(struct kernfs_open_file *of,
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 	struct mon_evt *mevt;
 
-	list_for_each_entry(mevt, &r->evt_list, list) {
+	for_each_mon_event(mevt) {
+		if (mevt->rid != r->rid || !mevt->enabled)
+			continue;
 		seq_printf(seq, "%s\n", mevt->name);
 		if (mevt->configurable)
 			seq_printf(seq, "%s_config\n", mevt->name);
@@ -3057,10 +3059,9 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 	struct mon_evt *mevt;
 	int ret, domid;
 
-	if (WARN_ON(list_empty(&r->evt_list)))
-		return -EPERM;
-
-	list_for_each_entry(mevt, &r->evt_list, list) {
+	for_each_mon_event(mevt) {
+		if (mevt->rid != r->rid || !mevt->enabled)
+			continue;
 		domid = do_sum ? d->ci_id : d->hdr.id;
 		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
 		if (WARN_ON_ONCE(!priv))
-- 
2.50.1

