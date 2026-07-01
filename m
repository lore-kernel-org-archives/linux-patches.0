Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E1E3BB11D
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941767; cv=none; b=l+vHwM3MPYgxLlB8SE/ysxt/NSBetdmxHOcvPT+VhfVb4QWI+e3r5bEKOQBMK3IaQisWW/NzadBAyZ0aHbQutmKHF8OQLZ/reIkpXfwSq+WfR6OxZmb+DXVkZqjOkfNJwJZ3V3mw/uU4J4enyweJfDLfMVoWDJoa+NQAzSlYvy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941767; c=relaxed/simple;
	bh=6v9VHpCOpu3PyGWT0Ig27QN5KG+7QWTu5fHuzFyxjP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blJzQ5/E+D4yxi23RPnUOKBHRWo7bJonH8rWO6M04itFsWaOaOa51oxLntCUJB5upz3o/dr+suIwSx7XcNOY/Yc+FqZpD3J8wMaH7icvMvK1myowxMvQN9ONhq0EUn8c+DfsHFg4uavDNB1h5VcBGXsMSQc2bE1AE4M9XRCsU18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0TTA4vh; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0TTA4vh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941765; x=1814477765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6v9VHpCOpu3PyGWT0Ig27QN5KG+7QWTu5fHuzFyxjP8=;
  b=B0TTA4vh3gLkeWPn05XJeRGJpO7Tn2aIPZzyle3QZ1ZTi3yR6RqXCnkI
   uzNYGXeeKtIbLBFHBTLouPUSh1mmhr/ku/0tMmks3nwrHJbWHYEUMXxZt
   mP+e8oPLIKWEdUR15gy8Vi2CYyF2zzdysYYsBsA09fPur3bArfBSjRNqg
   y55LrByskWfV5cwTiOyemOp/4t0WzsxA+5kZX2xdg9H9zdsfLO0ZW9N6E
   PXq7IjacXcvloQQ8//DTqiT0pxroV4fHHFCcjQJTPGtocjnL6aiH06R59
   I+hCCWpWmU6KumWySiHjjDs8qEBCRRkLKU9othKhF/nleYpmtHjuvX1Cu
   Q==;
X-CSE-ConnectionGUID: x8oCulqTTqam3DwX4CNzYg==
X-CSE-MsgGUID: 6sSnIFn5RpmkLb1Df/JwKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285778"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285778"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:03 -0700
X-CSE-ConnectionGUID: qQn38x2TS/2lWjq80kUscQ==
X-CSE-MsgGUID: GbwB8NpaRX62quqKITVRFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242529"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:02 -0700
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
Subject: [PATCH v9 04/12] fs/resctrl: Add interface to disable a monitor event
Date: Wed,  1 Jul 2026 14:35:45 -0700
Message-ID: <20260701213553.15222-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
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
 include/linux/resctrl.h | 34 ++++++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c    | 15 +++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index dd09c2ce9a0f..a184500745f8 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -419,9 +419,43 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
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
index 6acf6106e6f1..5d5625e4e3b4 100644
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
+		pr_warn("Repeat disable for event %d\n", eventid);
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
2.54.0

