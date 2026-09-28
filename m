Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8915B503904
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633741; cv=none; b=fBxhHffSnTzlxhgGeOe7hW2kv4twsHzdJqkZRbHBMB/gr2JfhSIf6sycJ+4tK3nJwlFk4gMb45QHZl10/DPGeQmUSsDTXx/L9ebRunS7vqMzUoxkAK/9atOzAZa58p7YP++Lr3di9Lxsr7CEtMKtzLYS69l3TtxPbuxHOU56yg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633741; c=relaxed/simple;
	bh=W9SUMAKEp6uQYNF/QXoPJieRLJ1qE5TKiWgLl6QzdU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW5I5tkbtwavl3Hg/fHCdtk+sKFx0iTa15OOJB6rmQc2JLawUrYrNgqMiT38oQ0545dz5G539lGkmRziSQ6Kr9Iy+aogFOzWuMhLamUv5jBWo2dX6DyzhxG2lLEp5cxoYKC1LQAKGw4LbM8tw47tOU/Otszo5P3OXw7jwYgB1lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mOtQzhhQ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mOtQzhhQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633738; x=1822169738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W9SUMAKEp6uQYNF/QXoPJieRLJ1qE5TKiWgLl6QzdU0=;
  b=mOtQzhhQlHHW28RP+CVWvgegiQ4GkGcVqkWkZELOIwu7HmLZRbI2gSpS
   /7BXpFqWo02umMzMlpCpUsgh2hzrabNqR7d42P+V1TgGMdoLj/NdRX/7d
   kVMCNSPgQWTdVlEhzVqWF7f9KKv8bfKJMpWL6L0mZTU2uX3Q3R3Hrge29
   Dvd9O5YmOnJEk+RQKPJ+mLtAZHbwuSOcGTPZFFjtUTst64OjBBPgVMR59
   bH33C19IXrH7qs6YjtKU5d5CQktIo8i8FKHxSXTZoxA7clM1X75AJ5YYX
   mMhzq3lkJ+5EEomwZJSfDhP+wgH6FR2ThzxzfeOn+V1cBs18i9edritaP
   g==;
X-CSE-ConnectionGUID: E2k1t+GdRVOynWj34WBIuw==
X-CSE-MsgGUID: V+F4SCuZT9u091m08YrmLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387264"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387264"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:19 -0700
X-CSE-ConnectionGUID: Jis3anmsRj6CpGr4ljRHdw==
X-CSE-MsgGUID: DdS0XnZrSKy2dKhh/mJAGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685500"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:18 -0700
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
Subject: [PATCH v13 12/25] fs/resctrl: Add interface to disable a monitor event
Date: Mon, 28 Sep 2026 15:14:56 -0700
Message-ID: <20260928221509.68002-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl currently assumes all monitor events are enabled before any domain
is created, because per-domain state is allocated by the architecture's CPU
hotplug callbacks. There is no way to disable an event once registered.

AET events are enumerated by the INTEL_PMT_TELEMETRY driver. To allow that
driver to be a loadable module, resctrl must tolerate AET events appearing
and disappearing, which requires the ability to disable an event when the
driver is unloaded.

Add resctrl_disable_mon_event(). The architecture owns domain lifetime
and knows mount state, so it is responsible for calling this only while
resctrl is unmounted and for cleaning up any per-domain state. Document
those requirements in the kerneldoc since they are not enforced in code.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Add back the comment that events must not be disabled while
	the file system is mounted.
---
 include/linux/resctrl.h | 36 ++++++++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c    | 15 +++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0e7fce070fde..764c45be2d59 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -449,9 +449,45 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
+/**
+ * resctrl_enable_mon_event() - Enable monitoring event
+ * @eventid:	ID of the event.
+ * @any_cpu:	True if event data can be read from any CPU.
+ * @binary_bits: Number of binary places of the fixed-point value expected to
+ *		back a floating point event. Can only be set for floating point
+ *		events.
+ * @arch_priv:	Architecture private data associated with event. Passed back to
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
+ * Never disable an event while the file system is mounted. Never
+ * disable an event that may be accessed while the file system is
+ * unmounted.
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
index 02e81fc82b14..2a28fe04284b 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1066,6 +1066,21 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 	return true;
 }
 
+void resctrl_disable_mon_event(enum resctrl_event_id eventid)
+{
+	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
+		return;
+	if (!mon_event_all[eventid].enabled) {
+		pr_warn("Event %d already disabled\n", eventid);
+		return;
+	}
+
+	mon_event_all[eventid].any_cpu = false;
+	mon_event_all[eventid].binary_bits = 0;
+	mon_event_all[eventid].arch_priv = NULL;
+	mon_event_all[eventid].enabled = false;
+}
+
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
 {
 	return eventid >= QOS_FIRST_EVENT && eventid < QOS_NUM_EVENTS &&
-- 
2.55.0

