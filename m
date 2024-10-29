Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F65C20514E
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222923; cv=none; b=aFMLKPuU/dKf/4NL9SeyScExq/WIuKZwVLtr7t3/eJFh7EcqFPB/7Oq9OXSDtyS+aD/avkKLBbQ/nFcgKh316PFXIRmUgTlql+vDyjGe8rV0r14zTECqwB88zXWAHEy1PJ5I3LSXXQDM0djHHtoZSbC6ogi5T2/goTF/bD3SxXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222923; c=relaxed/simple;
	bh=SHRi/W/hccHUHwXfh2MbFeVEffxuPn8jRJHIpiMoqm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwVUlOgKwWNcirFm+yGuZmFN9yGdL+3jRs+r8dWtniVP1EASPu9r2b5Woa1U+xZaqmn3wUKoA3+ohtCEISTyIxT0LY00iAWICC75tcVCgVtM2gDECC61uCfBhZZNHgHfHyjayu6xOWQbreV8Yb2QiuiT9tduCZ+pmZspYJumH/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IkyaEsUq; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IkyaEsUq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730222921; x=1761758921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SHRi/W/hccHUHwXfh2MbFeVEffxuPn8jRJHIpiMoqm8=;
  b=IkyaEsUqwmJgGyfhAIQPXBsC3FslnP2Hpj3yL976b35+hT6U5L+0rz6K
   3XAwSNdY3ckuKbqN3A7/96Fr1KkXKN/a7fV6uv5LbvQ7D9jxedUB87xH2
   mbn4qPOd4iLTRG+TxtqAZ1LYj0qjG253dlmHjKzTVyRFa73OQQAPzfAT1
   MF+QF8RS4DKPiKuTTuARGNRFDvFacTzDhMpFf1bu7TMn2ZWpi9ix3J4B6
   VANzAg+9GWXyKzJXPt4PFcv9KCoPYyZYH7NAGFrAlO9MTQLAPMM58cxzm
   2a1frGbIHD6e6ZE/VCpAqONcbENtTmtYwrZm2hEqqSl/kqI32gEY2XreS
   Q==;
X-CSE-ConnectionGUID: mynxg0XDQ6SF17RpbvzU4Q==
X-CSE-MsgGUID: wmjUW+tGRsiy3V62QKWGSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="17515645"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="17515645"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:39 -0700
X-CSE-ConnectionGUID: BOFCIB5QRBKbdxtkvryHQQ==
X-CSE-MsgGUID: xYAeSO2AQSKDliCw3GcSrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81585597"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
Subject: [PATCH v8 1/7] x86/resctrl: Prepare for per-ctrl_mon group mba_MBps control
Date: Tue, 29 Oct 2024 10:28:26 -0700
Message-ID: <20241029172832.93963-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241029172832.93963-1-tony.luck@intel.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/core.c     | 5 +++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 6 ++++++
 4 files changed, 15 insertions(+)

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
index 955999aecfca..a6f051fb2e69 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -283,6 +283,7 @@ struct pseudo_lock_region {
  *				monitor only or ctrl_mon group
  * @mon:			mongroup related data
  * @mode:			mode of resource group
+ * @mba_mbps_event:		input event id when mba_sc mode is active
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
index b681c2e07dbf..5b55a7ac7013 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -958,6 +958,11 @@ static __init bool get_rdt_mon_resources(void)
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
 		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
 
+	if (rdt_mon_features & (1 << QOS_L3_MBM_LOCAL_EVENT_ID))
+		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
+	else if (rdt_mon_features & (1 << QOS_L3_MBM_TOTAL_EVENT_ID))
+		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
+
 	if (!rdt_mon_features)
 		return false;
 
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index d7163b764c62..dbfb9d11f3f8 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -65,6 +65,8 @@ static void rdtgroup_destroy_root(void);
 
 struct dentry *debugfs_resctrl;
 
+enum resctrl_event_id mba_mbps_default_event;
+
 static bool resctrl_debug;
 
 void rdt_last_cmd_clear(void)
@@ -2665,6 +2667,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_schemata_free;
 
+	rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
+
 	kernfs_activate(rdtgroup_default.kn);
 
 	ret = rdtgroup_create_info_dir(rdtgroup_default.kn);
@@ -3624,6 +3628,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 		}
 	}
 
+	rdtgrp->mba_mbps_event = mba_mbps_default_event;
+
 	goto out_unlock;
 
 out_del_list:
-- 
2.47.0

