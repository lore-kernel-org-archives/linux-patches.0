Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A03247CC82
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198282; cv=none; b=ptMmOFmD8tNmJUYWaBfx5d4mH9V2b1WRBklhbF5rqW5zCDTjiY1erGlvg29lD61vqCJC14AEvOod6CvBgIWzu1zvLyB3uvjbhFGpTf+R7wdvngS4NtrmezXfDZmnajtbdteKFn4LPgHKWV4t6NPOnBESNDCg1kXXTWQeKIuVODw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198282; c=relaxed/simple;
	bh=yqJmDtGPMeVoNfkitPE6MyFQjizbvCmXb47clm5mNYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYGEIePwf7Efj+HP0MBT9BmGJS2i9D3cA/eyyWaCo5SmmSxK4J61jFnWCJXXUuQs1nYkRp6FOu+jLsUWoThnJzSQ8743iHLKg9g7kYeYc9wjEnbTXMxDjlb2k2fRBgVw64yYkzq7gzZ71A0VoS7PaRrmVocX2Xh4hQklBRwwReM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jw4CaHSE; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jw4CaHSE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198281; x=1819734281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yqJmDtGPMeVoNfkitPE6MyFQjizbvCmXb47clm5mNYA=;
  b=jw4CaHSE47vI0jgzNnY33jVn953HG6+PNUIMKvEUtLQg6HBICbHw4hD8
   U7UnlqoahojoHH84ZwMPTZyGceArQPGkHs2/WV7JbjNuI4g2R2+wbbdI/
   eA/AZhbuifev9LZvZe63O8VgIWugwKSgepm82j0cCLgjrT8ZYQgpK8NJb
   yvYqQDzfvRiDZqc6SjrpXd4cfWgGpwHy3xcx7hlNtgiMqYBN7E+4JAQJe
   K1YHi/griFulb4PazvisAzK3+t4oITy1wLrrypp8mP04NZekydVgeF8Ez
   V71XHn3bp5VijdYSXwNuNm/nJn21uNvJb8R3370SWjjSlDZabFqCdyNKo
   Q==;
X-CSE-ConnectionGUID: vvKxZgQtS6+LlBimnfPZYg==
X-CSE-MsgGUID: f4NOepheTzqaiuxraHHVEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480015"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480015"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:37 -0700
X-CSE-ConnectionGUID: g/9ucEPXQFOHgO+fRcnAgQ==
X-CSE-MsgGUID: J6BDVaDlSNWSftKTKwuS0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906986"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:36 -0700
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
Subject: [PATCH v11 11/23] fs/resctrl: Add interface to disable a monitor event
Date: Mon, 31 Aug 2026 10:44:09 -0700
Message-ID: <20260831174421.13921-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
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

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	Add Reinette RB tag.

 include/linux/resctrl.h | 34 ++++++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c    | 15 +++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 4a6b0c1833d6..e9094d886ba7 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -445,9 +445,43 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
+/**
+ * resctrl_enable_mon_event() - Enable monitoring event
+ * @eventid:	ID of the event
+ * @any_cpu:	True if event data can be read from any CPU.
+ * @binary_bits: Number of binary places of the fixed-point value expected to
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

