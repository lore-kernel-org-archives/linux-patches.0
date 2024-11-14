Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72768489
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 00:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543441; cv=none; b=iL7ngXXmQ0F3ghv9IbV9MU9PtPLYjkRZjaW0/9Au8ibVHJs+a1twib8FENo7ZH1kVGMaJQ/vjjPHp2w0Lp8K51564macWffaSjETvgYffsX8iVD7N87GdgDT+trKpXj9FPD6s+YujGntgLOsMLSamaRPLYCRPsn9ZMTBEmwNZl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543441; c=relaxed/simple;
	bh=QOP2S3/eSZU055KgxYEaUwnTF8QcW5KmqwswnyWxDoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULr7NhjpnibK+NKj7DR77AYqyEBckI8Fl/fGWcGehTmmuueR1uhRc6iUTc/mUZe7ONJ2e6HACrE+YRdgNKjvMbm97ntw8oXiprE3ijzh/9fzenQc08iwzP5l2j9Ve7C4ryggwc3iQp6M6clzECp5fUU3W033sXNVLrAtQH5Sf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R4VsRydL; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R4VsRydL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731543440; x=1763079440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QOP2S3/eSZU055KgxYEaUwnTF8QcW5KmqwswnyWxDoc=;
  b=R4VsRydLfTN/AlTVE1CWM1ZrbVa/E+REmaEAN0y3XfgGzBJk7qOnUdlQ
   fZldjNJ9ixQ9u38jAi+QyPTlrpMdNsmwGbo0eB/mHMqfZFoFk7WfpGxJ3
   NJtZu3W2I1P3/XEM3TtAtkO2ONKhlocCYRZp81mHmHcNiw5ib0ozPLSS9
   CVklL0I4cHQ2weT+Ncs1zNUw8rG82mSf0YkpSkBSmNBQ3P94AeWK6hisP
   bDHB/pSRN8VJ/2nCCLK+qpoavqkcCzIPJA+fFW83//GBcYD4u5z5W2LKn
   1luP8jpkQ8agaC9yJWRK7+dGhbdqbw+fDup+lzLw1fBYN0v3gmUa26KBg
   A==;
X-CSE-ConnectionGUID: jYYjGI75R2GXMQMRXSXBkQ==
X-CSE-MsgGUID: irr0yGVpTs22G5MGmdXH7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="30869470"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="30869470"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:18 -0800
X-CSE-ConnectionGUID: +3PNhHgqQlKzSxPlggOKCg==
X-CSE-MsgGUID: sgkj0/zaTFWCPSuOgs1LHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92081154"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:18 -0800
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
Subject: [PATCH v9 2/9] x86/resctrl: Prepare for per-ctrl_mon group mba_MBps control
Date: Wed, 13 Nov 2024 16:17:04 -0800
Message-ID: <20241114001712.80315-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114001712.80315-1-tony.luck@intel.com>
References: <20241114001712.80315-1-tony.luck@intel.com>
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
each ctrl_mon group.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                | 2 ++
 arch/x86/kernel/cpu/resctrl/internal.h | 2 ++
 arch/x86/kernel/cpu/resctrl/core.c     | 3 +++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 6 ++++++
 4 files changed, 13 insertions(+)

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
index 2b198ef95e1e..a8022bddf9f7 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -65,6 +65,8 @@ static void rdtgroup_destroy_root(void);
 
 struct dentry *debugfs_resctrl;
 
+enum resctrl_event_id mba_mbps_default_event;
+
 static bool resctrl_debug;
 
 void rdt_last_cmd_clear(void)
@@ -3611,6 +3613,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 			rdt_last_cmd_puts("kernfs subdir error\n");
 			goto out_del_list;
 		}
+		if (is_mba_sc(NULL))
+			rdtgrp->mba_mbps_event = mba_mbps_default_event;
 	}
 
 	goto out_unlock;
@@ -3970,6 +3974,8 @@ static void __init rdtgroup_setup_default(void)
 	rdtgroup_default.closid = RESCTRL_RESERVED_CLOSID;
 	rdtgroup_default.mon.rmid = RESCTRL_RESERVED_RMID;
 	rdtgroup_default.type = RDTCTRL_GROUP;
+	if (supports_mba_mbps())
+		rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
 	INIT_LIST_HEAD(&rdtgroup_default.mon.crdtgrp_list);
 
 	list_add(&rdtgroup_default.rdtgroup_list, &rdt_all_groups);
-- 
2.47.0

