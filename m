Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443057;
	b=GvfbcxRUvw7fmNWsQY+5AovnADNbsE7dOhrbV3iAoKsVIUdeeasYU+27RjfbHV14Y2fP
	 AiRvDGk2Omsqj2ZKC0vsfaPp0C/6c3WRa2befkSNN3zjbZX5wxjnMSDTkbBv3Cu+7GACV
	 RMJwd2MZBlfBBpWgM7RNbYqX0M7S10J6yfbF7OVq/U0bkJ1XkzCO+upmA7/FOesv+pEPh
	 8Z3PCdmQEejYZDEP4mQAOyP5I0d4s6lTyPK+aoGh5eTjiyXdj+UY20qQ9TonANWqjERPJ
	 OMIUPQ1bGXSAav7aTnjHn4aeDAtdnvvPDELAiG7zMazQdk7unw+NnxV3GykdYgOj0Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443057;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=b6sFqVcK9TmYk4uNli988YT73/sawBcMefs54y4lE+c=;
	b=l0RHqJJ0DQgWPnCrVHIkaP3ZqLZEOtI2DOrYaldiIz6v7YXgA+/xdvb+QZe8ZFi52hyy
	 nR1FHIoh5ecty8+N9Za2icujUVy2bGmTRlgl7mR9auH7W0U4JHlfliBOXnyiY2uzEOpdN
	 coUGDWMmddbE5BsS8Mer+XkYrCA7YB+LP3JbQ4LQ4GI2L0bucKPUD4GwwOy1sGeDJaTi3
	 6hXZVOHwCwu5wGz6PeODTQ3jWpHUgYotf+RT3PXYJT3LM/IFtW34kKij0ZvY3CoigrGqA
	 1oIbcqC3HMXJs8w18BbYXWw4+19XH3S6fjondgJT0kBbyyTs19Hz7PLk+TKCT5J7CLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kVY7B5yT;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D235160A2602
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D235160A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kVY7B5yT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443057; x=1823979057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DfeSBr9wkJljBUmBXYtLnlQczM0GujksKrgn/Ar85jQ=;
  b=kVY7B5yTPUaplJodtSI7MwqLolwz5yjwusi2of/H5gTKEAoUUxSEgF2g
   GFVcJPTHnVp2ciIrMx2+qgb9sAwnId2TQLieAaDiyekzes0l8LnIvwzFW
   1mP/LSU3IgQqLHTS6T2srBl/xIvKRxHkk3ESNIw9lG8BoFsJBZs+Olmf7
   ly+IQ0CDAa3R0Gk0vaJUnTSFVXiMY3thhaXxR4nEvcaRyHYGqD9f24TWc
   CcVe7z3xnjCtaCsFJ4DImVYPPhdrBpexAx7UO8t53I3KcXasUYmYgtkap
   FX6trN3a0NUr9Jt+GW2XrWRJ8jzjZ4a4+/BHulzj9ix2ykZ87wxR1bS+i
   A==;
X-CSE-ConnectionGUID: 7wmfJgE4THaMILkyJnAqeQ==
X-CSE-MsgGUID: mUUIoYcxR6OV/ASLSBqaNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131197"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131197"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:50 -0700
X-CSE-ConnectionGUID: rFQcCMokSnmxT5iVKwvZ9A==
X-CSE-MsgGUID: sE/Jh+qrQXi9TKSRhZtRpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008653"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:50 -0700
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
Subject: [PATCH v14 11/24] fs/resctrl: Add interface to disable a monitor event
Date: Mon, 19 Oct 2026 13:50:18 -0700
Message-ID: <20261019205031.16977-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that every monitor event is enabled before any domain is
created, since domains are created from CPU hotplug callbacks and their
per-domain state depends on the events enabled at that time. Events, once
enabled, stay enabled.

resctrl enumerates Application Energy Telemetry (AET) events from data provided
by the pmt_telemetry driver, which currently must be built in. Allowing the
driver to be a loadable module means AET events must be enumerated on every
mount and disabled again on unmount, so the driver can be unloaded while
resctrl is not mounted. There is no way to disable an event.

Add resctrl_disable_mon_event(). The architecture owns domain lifetime, so
it is responsible for calling this only while resctrl is unmounted and for
cleaning up any per-domain state. These requirements are not enforced in
code, so document them in kerneldoc, alongside the matching requirements
for enabling an event.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	New commit message. Dropped previous applied Reinette RB tag.
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
index f05be52ab5b3..fbbb31e9618b 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1068,6 +1068,21 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
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
2.56.0

