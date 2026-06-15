Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6883164BB
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547916; cv=none; b=nDvRyVUdZIS6pJ29CDtmw0wvjaZ7wglPfGnb+S7ZNOYHSop7VRQQSSZ12KcSN6bvYyboZvTPDxAYjaFSec1lSAvuTqG/UaLmiwYmOZjXAVngMBMTGTde/pk5Me35JUNFM42hh7zTqjlvF2oL+64zpbZQIp57sovQcTgeuEJDaIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547916; c=relaxed/simple;
	bh=Phroedg9xgFNldBgvX+72+A5/sONrbvincUmkJpw8XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vaqhqv3pxmZja/1/5sU1xJ36DcQRR7co8KZitxKo/fAnFQ6gN1216OgEzj6/7kcOFdUpjtkpc07E/ZaPmcX5l/+stoVMALi11/dUffScuxFEzOlj73Eokfmv7UyfVxhJ03Fd4QdVhLa0Cq2H77Y5Qd+xfWFeBCl+mGvKsT5Qk2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bOYoSOFN; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bOYoSOFN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547914; x=1813083914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Phroedg9xgFNldBgvX+72+A5/sONrbvincUmkJpw8XU=;
  b=bOYoSOFNgLtN6maQ/O1GO6zIt7LlnzhYOnYTfCCG/dkKWPwoG/MAz3mB
   8pYtlo3/iN9734uPvwFYmYFlcps2q38aGNJbEQXCjTp14lbWmZrXvghGB
   evD9bpSO11EnhsRzSvQq1w3fwRfQQ/xBW26YXIzzB+xpoDTwQSpvJtZ/L
   hrvYDHJ5W8lzKx2SAaRdywRUrvlq/RHSlcTVxefVU8mt5ablCgT6av+jn
   MpJFEaiq4F1Bh0fwcZTUCn5J/XjJtbPpmbmous/wEo+Uihguz/Fgshi9K
   LfUReyxrQnHAs1YiBQdWa+g9Pit8p8qjH5qiDNiBz2PMxW3Pr2Za7XtoD
   A==;
X-CSE-ConnectionGUID: d2KxqPfsQ0mtXz2Suq61QA==
X-CSE-MsgGUID: WBPfnibVSdeP+Xua/insfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789990"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789990"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:10 -0700
X-CSE-ConnectionGUID: FGKnyo4xQwynXnR07FUgEA==
X-CSE-MsgGUID: Ix5WBpwmQR6PB7vSGDT6GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620635"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:09 -0700
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
Subject: [PATCH v8 08/16] fs/resctrl: Add interface to disable a monitor event
Date: Mon, 15 Jun 2026 11:24:49 -0700
Message-ID: <20260615182457.14725-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
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
v8:
	Updated commit message
	Clear all architecture controlled mon_event::* fields.

 include/linux/resctrl.h | 34 ++++++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c    | 15 +++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..138810ada049 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -414,9 +414,43 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
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
index 3df188bee433..8178fc65318e 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1012,6 +1012,21 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
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

