Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960011ABED4
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 19:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727982761; cv=none; b=gKx82GcvvBrVE7Bu2ahev5pFoIc+BQEjI0COBB1nPTMJPATYLlap55LK/1gi9aOgkME54f1iveQsGMDMIsxtmq4lJdJngOVA9m6FSj3iKio+Aaroq8pfzrGzl23qYlSOj3Z4wLqnIvmIxP3e/dgiFHQoKijhKTYuY12X/YGduh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727982761; c=relaxed/simple;
	bh=5d03wtvW5lJdk3P0f1faBD/S2847o8ZU5ziGMFCBQUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUq+XJcteNmDqNDpIQdxPXr4m6l3rwfra5V1uqZZ/E7RBb/2CsxdlFPUfyqRKiExray2hUtLJLN83cA6dkZJGTfPQiL5aanmbypZIhdJdTlgUvTzx4t/ldYfknTSFVj/T9HTmx8rcr64sMIujcQZ0dohRFR/GYXTGqhheAFH/Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ftATdjfe; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ftATdjfe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727982759; x=1759518759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5d03wtvW5lJdk3P0f1faBD/S2847o8ZU5ziGMFCBQUQ=;
  b=ftATdjfera2tXhLw2TfTa71j6o+PUrIVy2S3E0EnM4zVgMFvr2Nn1wC4
   z+VL4+TkUIytsXKM2GYsBDubNFnKtH+U4FelhMWli2cqD3y3tkt6j7p7+
   9arhryHcc/CbvG0wroOnVpRicHnMmn/PMQBFe/iCbuphbbTdDa6QbGdQM
   K8MWBKkEozYPjIsS/8n+KAzRThvruANC5HAAUjhurOXQ3Q3F8Ks7j0256
   tAvpGuE90Vc/gjoJbcR2G30etnyASENc4USl8V6rQaFmTBwhtLKluHyW7
   zJY+MNWkK5K7+bCDc7FdOqjLrtOz3h2QlR7grsGBIZ99zzbY6k+wd8wV/
   w==;
X-CSE-ConnectionGUID: buRQE0YNTYiq6OYvhvXY9A==
X-CSE-MsgGUID: UJkzeWsuSQqgU65679L6tA==
X-IronPort-AV: E=McAfee;i="6700,10204,11214"; a="27287509"
X-IronPort-AV: E=Sophos;i="6.11,175,1725346800"; 
   d="scan'208";a="27287509"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2024 12:12:36 -0700
X-CSE-ConnectionGUID: JQamvRccRG6Go8h/bRKzcw==
X-CSE-MsgGUID: xiC6pfURQO6OSh73VMzSlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,175,1725346800"; 
   d="scan'208";a="74031036"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2024 12:12:36 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 2/4] x86/resctrl: Add mount option to pick input event for mba_MBps mode
Date: Thu,  3 Oct 2024 12:12:26 -0700
Message-ID: <20241003191228.67541-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241003191228.67541-1-tony.luck@intel.com>
References: <20241003191228.67541-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new mount option "mba_MBps_event={event_name}" where event_name
is one of "mbm_local_bytes" or "mbm_total_bytes" that allows a user to
specify which monitoring event to use. Do not allow both options at
the same time.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h |  1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 49 ++++++++++++++++++++------
 2 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 955999aecfca..b3d4fc80a496 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -102,6 +102,7 @@ struct rdt_fs_context {
 	bool				enable_cdpl2;
 	bool				enable_cdpl3;
 	bool				enable_mba_mbps;
+	enum resctrl_event_id		mba_mbps_event;
 	bool				enable_debug;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index aedb30120d50..606cf635ea94 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2343,7 +2343,7 @@ static bool supports_mba_mbps(void)
 	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
-	return (is_mbm_local_enabled() &&
+	return (is_mbm_enabled() &&
 		r->alloc_capable && is_mba_linear() &&
 		r->ctrl_scope == rmbm->mon_scope);
 }
@@ -2521,7 +2521,7 @@ static int rdt_enable_ctx(struct rdt_fs_context *ctx)
 	}
 
 	if (ctx->enable_mba_mbps) {
-		r->membw.mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
+		r->membw.mba_mbps_event = ctx->mba_mbps_event;
 		ret = set_mba_sc(true);
 		if (ret)
 			goto out_cdpl3;
@@ -2739,15 +2739,17 @@ enum rdt_param {
 	Opt_cdp,
 	Opt_cdpl2,
 	Opt_mba_mbps,
+	Opt_mba_mbps_event,
 	Opt_debug,
 	nr__rdt_params
 };
 
 static const struct fs_parameter_spec rdt_fs_parameters[] = {
-	fsparam_flag("cdp",		Opt_cdp),
-	fsparam_flag("cdpl2",		Opt_cdpl2),
-	fsparam_flag("mba_MBps",	Opt_mba_mbps),
-	fsparam_flag("debug",		Opt_debug),
+	fsparam_flag("cdp",			Opt_cdp),
+	fsparam_flag("cdpl2",			Opt_cdpl2),
+	fsparam_flag("mba_MBps",		Opt_mba_mbps),
+	fsparam_string("mba_MBps_event",	Opt_mba_mbps_event),
+	fsparam_flag("debug",			Opt_debug),
 	{}
 };
 
@@ -2770,9 +2772,25 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ctx->enable_cdpl2 = true;
 		return 0;
 	case Opt_mba_mbps:
-		msg = "mba_MBps requires local MBM and linear scale MBA at L3 scope";
-		if (!supports_mba_mbps())
+		msg = "mba_MBps requires MBM and linear scale MBA at L3 scope";
+		if (!supports_mba_mbps() || ctx->enable_mba_mbps)
 			return invalfc(fc, msg);
+		if (is_mbm_local_enabled())
+			ctx->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
+		else
+			return invalfc(fc, msg);
+		ctx->enable_mba_mbps = true;
+		return 0;
+	case Opt_mba_mbps_event:
+		msg = "mba_MBps requires MBM and linear scale MBA at L3 scope";
+		if (!supports_mba_mbps() || ctx->enable_mba_mbps)
+			return invalfc(fc, msg);
+		if (!strcmp("mbm_local_bytes", param->string))
+			ctx->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
+		else if (!strcmp("mbm_total_bytes", param->string))
+			ctx->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
+		else
+			return invalfc(fc, "unknown MBM event %s", param->string);
 		ctx->enable_mba_mbps = true;
 		return 0;
 	case Opt_debug:
@@ -3931,16 +3949,27 @@ static int rdtgroup_rename(struct kernfs_node *kn,
 	return ret;
 }
 
+static const char *mba_sc_event_opt_name(struct rdt_resource *r)
+{
+	if (r->membw.mba_mbps_event == QOS_L3_MBM_LOCAL_EVENT_ID)
+		return ",mba_MBps_event=mbm_local_bytes";
+	else if (r->membw.mba_mbps_event == QOS_L3_MBM_TOTAL_EVENT_ID)
+		return ",mba_MBps_event=mbm_total_bytes";
+	return "";
+}
+
 static int rdtgroup_show_options(struct seq_file *seq, struct kernfs_root *kf)
 {
+	struct rdt_resource *r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
+
 	if (resctrl_arch_get_cdp_enabled(RDT_RESOURCE_L3))
 		seq_puts(seq, ",cdp");
 
 	if (resctrl_arch_get_cdp_enabled(RDT_RESOURCE_L2))
 		seq_puts(seq, ",cdpl2");
 
-	if (is_mba_sc(&rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl))
-		seq_puts(seq, ",mba_MBps");
+	if (is_mba_sc(r_mba))
+		seq_puts(seq, mba_sc_event_opt_name(r_mba));
 
 	if (resctrl_debug)
 		seq_puts(seq, ",debug");
-- 
2.46.1

