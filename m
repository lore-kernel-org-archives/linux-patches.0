Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4A038F653
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 20:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851543; cv=none; b=VUaPEOHAF48+twWcJgAuvJgl2sq9zhdXwu2bCgOs7mk0yxqLFzMHd43ibwiutpTJMhBtEIWven1K+ppEl1yey9G7edEdQtxwiuQYGPDW3m8oxnJCovwWkVdHMmPoT2o33/g+cID6dA5QVEEevzaJcGA+yLlfzx/8Yu4o+r83n54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851543; c=relaxed/simple;
	bh=fk2FeTa5sC5C/JCX1a5sNfgQLpavS6OsCw5bkUgeGFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYLs5H1JHgCt4/SmUsiw30mRVWDdRninyAluCYw5dtEFQAmo8OHdXqfE0TbfnU1blqyCyqMhxCu4beeZMym5DMAVfy4gYBzVUA+Co7mxb8aPQsvLp+fW/WY/TotCSswHwIM5rePQqIv9gFq3AtJyzr6ghu2LfJpfCPWdmnn1RIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AgtuAHto; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AgtuAHto"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775851542; x=1807387542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fk2FeTa5sC5C/JCX1a5sNfgQLpavS6OsCw5bkUgeGFg=;
  b=AgtuAHtognfhnXYoTLr7ni7oemgmEtFRvWti6J9KddN5bhq0rik3kr/I
   /sBRUiSTfu+tnes2vFoQOzTvtmki+ARm4MRdCn9uPpHpYYrJMszKSnn7a
   8+x5D/L2b0/b77r7DuEWJ0GcbN+DGNtV5EiR/Keq/o88HOhyN949H6k8C
   ZouUvvMNguu93owEUybxPSFLKjLw/jG8+lNunp4ZN56BeM8HhaplRD0jz
   LS51sHNRFRCwyYWlH2z2zdZHqF7zhKDwgQ8l7Xae4msozoDYXR3iH5lII
   4nKGx5B3CSiFgrsbT68tcMYxIV4NVsjnUyVSGPf7xeEmpDcuPCHGWomMN
   Q==;
X-CSE-ConnectionGUID: sg0TqeQSQRiS8IYvSrH8BQ==
X-CSE-MsgGUID: GB1GtUZGSumVBiMqdOyKHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76898070"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76898070"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:40 -0700
X-CSE-ConnectionGUID: SMvz9TcQSoq3RVSDU8qzyg==
X-CSE-MsgGUID: kM7dIBIySS6kCOHsD39fdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="228155006"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH v5 2/7] fs/resctrl: Add interface to disable a monitor event
Date: Fri, 10 Apr 2026 13:05:27 -0700
Message-ID: <20260410200532.58602-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410200532.58602-1-tony.luck@intel.com>
References: <20260410200532.58602-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for re-running AET enumeration on every mount, AET code
must be able to disable events on unmount so the next mount starts from
a clean slate.

Add resctrl_disable_mon_event(eventid) which clears the enabled flag for the
given event. Add kerneldoc comments to describe limitations on when events
may be enabled or disabled.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h | 34 ++++++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c    | 12 ++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..a8338656f836 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -414,9 +414,43 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
+/**
+ * resctrl_enable_mon_event() - Enable monitoring event
+ * @eventid:	ID of the event
+ * @any_cpu:	True if event data can be read from any CPU.
+ * @binary_bits:Number of binary places of the fixed-point value expected to
+ *		back a floating point event. Can only be set for floating point
+ *		events.
+ * @arch_priv:  Architecture private data associated with event. Passed back to
+ *		architecture when reading the event via resctrl_arch_rmid_read().
+ *
+ * The file system must not be mounted when enabling an event.
+ *
+ * Events that require per-domain (architectural and/or filesystem) state must
+ * be enabled before the domain structures are allocated. For example before
+ * CPU hotplug callbacks that allocate domain structures are registered. If the
+ * architecture discovers a resource after initialization it should enable
+ * events needing per-domain state before any domain structure allocation which
+ * should be coordinated with the CPU hotplug callbacks.
+ *
+ * Return:
+ * true if event was successfully enabled, false otherwise.
+ */
 bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 			      unsigned int binary_bits, void *arch_priv);
 
+/**
+ * resctrl_disable_mon_event() - Disable monitoring event
+ * @eventid:	ID of the event
+ *
+ * The file system must not be mounted when disabling an event.
+ *
+ * Events that require per-domain (architectural and/or filesystem) state
+ * will require additional cleanup which should be coordinated with the CPU
+ * hotplug callbacks.
+ */
+void resctrl_disable_mon_event(enum resctrl_event_id eventid);
+
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 49f3f6b846b2..0def41c26edc 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1010,6 +1010,18 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 	return true;
 }
 
+void resctrl_disable_mon_event(enum resctrl_event_id eventid)
+{
+	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
+		return;
+	if (!mon_event_all[eventid].enabled) {
+		pr_warn("Repeat disable for event %d\n", eventid);
+		return;
+	}
+
+	mon_event_all[eventid].enabled = false;
+}
+
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
 {
 	return eventid >= QOS_FIRST_EVENT && eventid < QOS_NUM_EVENTS &&
-- 
2.53.0

