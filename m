Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8BA4E1C78
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600426; cv=none; b=rPM9kURgWnxkLT0MgA/RgrRdnrVLiDvKOZ+82RS5PME1x9FwSXNvc5/i/ZShjZx9T6iYcZPMevFhjoeT/it2px8FMpS9uvSf278DycOwkyrdZL84zRlcPZBf6jIFDHUAbYhAc6eXq0B9tPBgBhu8MPl9XJwDo8pBHesLn6RBDFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600426; c=relaxed/simple;
	bh=AOTgnRzzoC8PIhxgcqVQ7yQ+PJ606+1nZeY+ZVMUtPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMq1fNrtLNm5F0E18QX5ByDFnPoCT2rdbVFFxk5gAYpgd/8uP+LohnUdmRnlH/J/SnTe1ZnH7YaShE66DS+BcZYVqQbRQYSh5vylJTolGZ+pPTGCr6KewWAoQL90l8n03IWx6F+ZrF7AT9qCQ6jg8xSO9fH9399QDE839GfwoDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OB/hgLst; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OB/hgLst"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600424; x=1821136424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AOTgnRzzoC8PIhxgcqVQ7yQ+PJ606+1nZeY+ZVMUtPE=;
  b=OB/hgLstu+/oQKMDqqW1eprsF3H8Oe2AMZXRW9wst0k5ryv+mhZU2v9Q
   /rKdQ0YzgbivxIxSEeqiS/CGYHtkDlPM6/ekiQjrFLiYDIG/XYG7NZHfc
   7KhDuvrNNlDCPY7pNxmR7et6gInlfx129RBLIs4+SkBTa2rYSfzDMRRTF
   OTDMWXu8xbkoV93jhyht7etr3Ya68sAy+IJ9XA+iHzaU/x6WBr2LZ2lUr
   AvPhXu6G2ILRKvxiPxWzZA4gU/Wv0X+O64QdiNpUYx6ASfgXj8GZXS8EF
   FWe20Wi6F/us66B6mFeMoi+AP8qDke8WQAoc79o4xq8oGB62wNJmIDtRT
   A==;
X-CSE-ConnectionGUID: 3rP2HE+3Q9Crr2BN3PMZOw==
X-CSE-MsgGUID: eKG8PNxsSOWGaarj8qjRXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861415"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861415"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:35 -0700
X-CSE-ConnectionGUID: L+oIe3ktQY66zA0YI57MkQ==
X-CSE-MsgGUID: UeYhN7QdSWONac7nIkK10A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231462"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:35 -0700
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
Subject: [PATCH v12 11/25] fs/resctrl: Add interface to disable a monitor event
Date: Wed, 16 Sep 2026 16:13:06 -0700
Message-ID: <20260916231320.14502-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v12:
	Added Reinette RB tag (from v10 review).
	Better header comment for resctrl_disable_mon_event().
---
 include/linux/resctrl.h | 34 ++++++++++++++++++++++++++++++++++
 fs/resctrl/monitor.c    | 15 +++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 6b07ac2c8675..fbf737e884db 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -449,9 +449,43 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
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
+ * Never disable an event that may be accessed while the file system is unmounted.
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

