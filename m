Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CE6384CD1
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343806; cv=none; b=sL+Jgt0ALGlQqYyO7O7tQe2zEM62vLTIkZbXIcdwSMaMmT9DyIhqgpnJBOKe6Dzox2yZ+riVIW3ww9n8moppmgpdTPAPj5lr9aPx7EiN56NSSMZX0+5EjAEbmm3rP3UEWnto9JZELxlxgNipr4Bf9jgQpo6PGV5GnxhxFVzXWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343806; c=relaxed/simple;
	bh=gn29ksqcgLqQx3BYgdSXJ9a+ZmiZ8zoguD3IHim5rWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4AKnn6y7NMQGp3tCoAO/D/vGFck13ZQW4PeBUld5xAC1bDakQkub4W4smU6yipu51fFTfW6syE1GvA/6mMXz3panmCYvRfRlbu98mb+nWPfNemUi/e56Afm+TBbHD7FTrXSx8VtOjEP/4AqpwtOAwzRQa+EGM2Zswtp+nRDIxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bicUM6zt; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bicUM6zt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343805; x=1811879805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gn29ksqcgLqQx3BYgdSXJ9a+ZmiZ8zoguD3IHim5rWE=;
  b=bicUM6ztmh2LVCK/X0FiGKXg1Br65CqwQ5v1W5JlVfxkoC3Y3PBKzIwE
   xUwZIvHpdmxvquq9NLOQLr2ZaLmTwhJ26YkG5wpnpkZz7WxBo+RhgOwue
   BAxhTP/sQ9NVGd0RM15B8Ir3oXMkTv3PBpPxrIXLK1C5lzyLmPrQFvQLq
   DndBanhuQEVGzHJOORFwoeKx4v6n+9zDwRF0RNrcFlljhaf5LJLlSRHl0
   Z2FhrMozwGmTZcQDESAccgU5+lZ1FimhnxfIVVlYuxcNDal45msHLRYmC
   20mqgxOJt/k7n1qTLIBGqrOQomCt+Hfg/onKKT2cuZFs/0yhlY9THnen4
   g==;
X-CSE-ConnectionGUID: /TW6nW+JRBml3mbDWWyvUQ==
X-CSE-MsgGUID: PDKs5zjqQ5GM232GBtMnsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011606"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011606"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:42 -0700
X-CSE-ConnectionGUID: XoVOOPm+QiSh/JsmGuH/RQ==
X-CSE-MsgGUID: 0QIUE/lpQ+eFQUWTF6K1Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946507"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:41 -0700
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
Subject: [PATCH v7 06/14] fs/resctrl: Add interface to disable a monitor event
Date: Mon,  1 Jun 2026 12:56:24 -0700
Message-ID: <20260601195632.15876-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601195632.15876-1-tony.luck@intel.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for re-running AET enumeration on every mount, AET code must be
able to disable events on unmount so the next mount starts from a clean slate.

Add a file system interface for architecture to clear the enabled flag for
a given event.

Add kerneldoc comments to describe limitations on when events may be enabled
or disabled.

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
index 9fd901c78dc6..327e7a863614 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1012,6 +1012,18 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
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
2.54.0

