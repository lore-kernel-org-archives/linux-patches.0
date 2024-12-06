Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D45F1FD7A5
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 16:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733502716; cv=none; b=p2EglsW+VtrgqT4ryOLLheVTsXW5iMCf/9jz4QmtaLJBVCb/wKgb2CgJizxciSYrXMHD+BPZ+b+Rpovo/0oHGlbvUdznCYNiV3k73wPNYToHhinq+QVn8LJhVzRrlpr6ig0+hUFrC+Tetg1svczAzIPIP2O2sjbWGq4bnPG6N2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733502716; c=relaxed/simple;
	bh=pJ/tsmO8xEKFasqra1vQfrzHy5pCaTXX58/S2T5W1Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REzu8gblW72sS4sPeXH1MOOyJAaJkc+vga8YqUwpldZjTaR6wCLhQMxLqk28QkO4upxkcV3Tjhs8jABLnLTM0IroT/VnyPZI/ZX/REPLLbayQq05JKaOu5Gmtu2ilOHgoWUk3oF7UhM/mKL/ThbzzvhBBEygxUqEkwynJh5R2AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSOLxUWu; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSOLxUWu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733502715; x=1765038715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pJ/tsmO8xEKFasqra1vQfrzHy5pCaTXX58/S2T5W1Cs=;
  b=hSOLxUWuAjlXMrO5OjqkvG0Y5JvjydQgK4dzFdtGZrHBMN0hb3KnuI1g
   KgcK0D93HxvCwXoyMYcJgw8hIKyvDpWpFxEgJhmOTBX4NERQGlQDrHKSd
   OhNErkiWtp6gNc6BMCds3Z3AWvI5QQz5i5LdWw+bXUsFLDzbZT00AHGeo
   AAcB/hKW4G5qZ8ZCsleBVQxf5m5GU5onWh7wP/FPznTPeyy1arYfSAsqb
   y/ZS1dsCDmEPkJPNVNA4/JFuuOOuwk/Nn+GsGJIvIMDkIHci++qMcpsz5
   PoVjaT53H9+hM4mTzLkoWJHnYA/BV+pWA4a/Pe3y8ua/XS9ZBqn59Zaee
   Q==;
X-CSE-ConnectionGUID: XO76bJ9hTGmthobxz7HX8g==
X-CSE-MsgGUID: wvznvGTrReC4h6JpEP1HeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="44470390"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="44470390"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:54 -0800
X-CSE-ConnectionGUID: 1q793AjgTHyi1PteVP4Dyw==
X-CSE-MsgGUID: bp2Xcc54QHuVF+qZRkJspg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="95258506"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:54 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 2/8] x86/resctrl: Prepare for per-CTRL_MON group mba_MBps control
Date: Fri,  6 Dec 2024 08:31:42 -0800
Message-ID: <20241206163148.83828-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206163148.83828-1-tony.luck@intel.com>
References: <20241206163148.83828-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resctrl uses local memory bandwidth event as input to the feedback
loop when the mba_MBps mount option is used. This means that this
mount option cannot be used on systems that only support monitoring
of total bandwidth.

Prepare to allow users to choose the input event independently for
each CTRL_MON group by adding a global variable "mba_mbps_default_event"
used to set the default event for each CTRL_MON group, and a new
field "mba_mbps_event" in struct rdtgroup to track which event is
used for each CTRL_MON group.

Notes:
1) Both of these are only used when the user mounts the filesystem with
the "mba_MBps" option.
2) Only check for support of local bandwidth event when initializing
mba_mbps_default_event. Support for total bandwidth event can be added
after other routines in resctrl have been updated to handle total
bandwidth event.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h                |  2 ++
 arch/x86/kernel/cpu/resctrl/internal.h |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c     |  3 +++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 13 +++++++++++++
 4 files changed, 20 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index d94abba1c716..fd05b937e2f4 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -49,6 +49,8 @@ enum resctrl_event_id {
 	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
 };
 
+extern enum resctrl_event_id mba_mbps_default_event;
+
 /**
  * struct resctrl_staged_config - parsed configuration to be applied
  * @new_ctrl:		new ctrl value to be loaded
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index faaff9d64102..485800055a7d 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -283,6 +283,7 @@ struct pseudo_lock_region {
  *				monitor only or ctrl_mon group
  * @mon:			mongroup related data
  * @mode:			mode of resource group
+ * @mba_mbps_event:		input monitoring event id when mba_sc is enabled
  * @plr:			pseudo-locked region
  */
 struct rdtgroup {
@@ -295,6 +296,7 @@ struct rdtgroup {
 	enum rdt_group_type		type;
 	struct mongroup			mon;
 	enum rdtgrp_mode		mode;
+	enum resctrl_event_id		mba_mbps_event;
 	struct pseudo_lock_region	*plr;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f3ee5859b69d..94bf559966d6 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -963,6 +963,9 @@ static __init bool get_rdt_mon_resources(void)
 	if (!rdt_mon_features)
 		return false;
 
+	if (is_mbm_local_enabled())
+		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
+
 	return !rdt_get_mon_l3_config(r);
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index d333570e893d..8a52b25ce26b 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -65,6 +65,15 @@ static void rdtgroup_destroy_root(void);
 
 struct dentry *debugfs_resctrl;
 
+/*
+ * Memory bandwidth monitoring event to use for the default CTRL_MON group
+ * and each new CTRL_MON group created by the user.  Only relevant when
+ * the filesystem is mounted with the "mba_MBps" option so it does not
+ * matter that it remains uninitialized on systems that do not support
+ * the "mba_MBps" option.
+ */
+enum resctrl_event_id mba_mbps_default_event;
+
 static bool resctrl_debug;
 
 void rdt_last_cmd_clear(void)
@@ -2353,6 +2362,8 @@ static int set_mba_sc(bool mba_sc)
 
 	r->membw.mba_sc = mba_sc;
 
+	rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
+
 	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
 		for (i = 0; i < num_closid; i++)
 			d->mbps_val[i] = MBA_MAX_MBPS;
@@ -3611,6 +3622,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 			rdt_last_cmd_puts("kernfs subdir error\n");
 			goto out_del_list;
 		}
+		if (is_mba_sc(NULL))
+			rdtgrp->mba_mbps_event = mba_mbps_default_event;
 	}
 
 	goto out_unlock;
-- 
2.47.0

