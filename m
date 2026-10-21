Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792621330;
	b=GDFzxvFzAz3neNipwb/VragFF5g5mEJbyLhFP9956pkjBuI8KsBDNQ9DpKbmitPvZxD0
	 s1e4ObQWrlndlQirRJDD/YEBCflPYuXwF4N9qhM5yy9cqNgGHwOLXMiu7yEXtnsk00OmC
	 683lJLUXwXzbjkiflEhnQYC4kLxwsQCs39yGLnFPAxS9sn+H104QdxcxIQHh4T5BwZNpV
	 SgCnoQjfBBTyzPH0gYRuY4tMqNpx1f06UMTQBnupU9GhRxKgBLXxf2ZcOVG+6PG46GOUw
	 pAhAxtiT2P0DwbdgHWfmA/niCcTZzibYIfVDAqC0GqgVfCQj8tK8kWXszmZl8UFHlsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792621330;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SstS/aerNK8KvlijOKFS7nqpS6vEQAL24S1VtRAhY4Q=;
	b=bigFt+zB2jrjQOfy6mqVqhrF6aKH10917x5ZHaZ2v703v9IdNBrKQ83C5F7AnljcFh4b
	 EDX5IWL/jFDw+7LDEnR0RBhO21InaBNb5wyhSXvhwE5IMtToRgI0VdYsLf9ojlcT3SgqD
	 onkldRq32WWsWZsCvzusuU11VFfTK9ZgrEbZpJMOkKa2KwqTIXhTUxrz/ApKymAmJ1JWt
	 RZaKPwBieKy546vkOyeZ75F2m5KjXjkNAIv5kmqjPaRLAzL5ipDWEz9IjGR6N6KEWlkkv
	 joDsSfFf88ZsOFWtkx3tasi9J020ZU5vx4gmqjwLOdaMK19pa+yEwGFaCIxQJcEoMiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dfNGc1y1;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F18606A31A
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 22:22:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48F18606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dfNGc1y1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792621329; x=1824157329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4pbGT3tKNIqn7SCAYqOmly57C4LwkQGCdYDhKsNxvIc=;
  b=dfNGc1y1dE98P3hC/sTWJl1O81hBiE3omt0nyROeNCg1ey0nc8mfLOrS
   xpyVpGvTfD9JE0jUXym+neWvCuQAfjKQc5fyjErmaKc556x/9KN1na3aR
   FcH18CxXPt9I+iZ/CXZOGxNyjMlx1stnV+Vw34JJLJyrJfxfFM2b6lDJD
   I5TZtdauRnkAkVNaJXd5sTXcJbdIYThWG/DnwUlRmm540H8TmDnC/EjCf
   YADG3NdGM5CzeAl1jsYUurh5oIbpnnsgff4DkDvO14wLvkbJeNfXOn4m3
   l4kjmkvK3C7KHf4qxYL6lHe71YD5/+QgeqdqqX/Fhv/HkXKXTuytDuqTF
   g==;
X-CSE-ConnectionGUID: BOMb12eBQ9+FBcWXbNRqYA==
X-CSE-MsgGUID: f94PQA1PT1a7jlIEjgcTSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1346487"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1346487"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 15:22:08 -0700
X-CSE-ConnectionGUID: UH5h7j24QkGtyg1RSQPUQg==
X-CSE-MsgGUID: aIxcM1FNTjmSVNDtsHJ3DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="3127857"
Received: from rodrigoa-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.213])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 15:22:08 -0700
From: Tony Luck <tony.luck@intel.com>
To: tony.luck@intel.com
Cc: Dave.Martin@arm.com,
	babu.moger@amd.com,
	david.e.box@intel.com,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	hch@infradead.org,
	james.morse@arm.com,
	linux-kernel@vger.kernel.org,
	maciej.wieczor-retman@intel.com,
	patches@lists.linux.dev,
	peternewman@google.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	yu.c.chen@intel.com
Subject: [PATCH v14+ 14/24] x86,fs/resctrl: Handle systems where AET is the only monitoring feature
Date: Wed, 21 Oct 2026 15:22:00 -0700
Message-ID: <20261021222200.16310-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-15-tony.luck@intel.com>
References: <20261019205031.16977-15-tony.luck@intel.com>
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

Application Energy Telemetry (AET) is not enumerated via CPUID. Its presence
is discovered on the first mount of the resctrl file system by querying the
pmt_telemetry driver. resctrl is initialized at boot only if CPUID
enumeration finds allocation or monitoring features.

On a system that supports monitoring (X86_FEATURE_CQM) but no L3 monitoring
features, get_rdt_mon_resources() reports that no monitoring is supported.
If the system also does not support allocation, resctrl is not initialized
and AET can never be used.

Assume that AET may be supported whenever the system supports monitoring,
but check for non-zero supported RMIDs to deal sanely with misconfigured
systems.

If AET is not supported either, the mount finds neither allocation nor
monitoring support. rdt_get_tree() then lets the mount succeed with nothing
to allocate or monitor, but does not mark resctrl as mounted. Fail the mount
with an error message instead, before any of the file system is set up.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14+
	Add check that there are some RMIDs to address Sashiko report
	about booting with "clearcpuid=cqm".

 arch/x86/kernel/cpu/resctrl/internal.h  |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c      | 22 +++++++++++++---------
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  3 +++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  4 +---
 fs/resctrl/rdtgroup.c                   |  8 ++++++--
 5 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 086282a82fca..c038b7d80ce3 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -226,7 +226,7 @@ union l3_qos_abmc_cfg {
 
 void rdt_ctrl_update(void *arg);
 
-int rdt_get_l3_mon_config(struct rdt_resource *r);
+void rdt_get_l3_mon_config(struct rdt_resource *r);
 
 bool rdt_cpu_has(int flag);
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b32fa143283e..0262174df7ad 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -991,7 +991,7 @@ static __init bool get_rdt_alloc_resources(void)
 static __init bool get_rdt_mon_resources(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
-	bool ret = false;
+	bool l3_mon_found = false;
 
 	/* Any monitoring at all? */
 	if (!cpu_feature_enabled(X86_FEATURE_CQM))
@@ -1001,27 +1001,31 @@ static __init bool get_rdt_mon_resources(void)
 
 	/* Any of the L3 monitoring features? */
 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
-		return false;
+		goto out;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
 		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
-		ret = true;
+		l3_mon_found = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
-		ret = true;
+		l3_mon_found = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
-		ret = true;
+		l3_mon_found = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
-		ret = true;
+		l3_mon_found = true;
 
-	if (!ret)
-		return false;
+	if (l3_mon_found)
+		rdt_get_l3_mon_config(r);
+	else
+		pr_info("CPUID reports L3 monitoring support, but no L3 monitoring features found\n");
 
-	return !rdt_get_l3_mon_config(r);
+out:
+	/* Non-L3 features, e.g. AET, may be supported */
+	return true;
 }
 
 static __init void __check_quirks_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 9f0829a82cb0..9d666cf080d5 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -343,6 +343,9 @@ bool intel_aet_get_events(void)
 	struct event_group **peg;
 	bool ret = false;
 
+	if (!resctrl_arch_system_max_rmid_idx())
+		return false;
+
 	for_each_event_group(peg) {
 		pfid = lookup_pfid((*peg)->pfname);
 		p = intel_pmt_get_regions_by_feature(pfid);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 82a555855c1b..bd45d72d1d05 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -431,7 +431,7 @@ static void __init intel_rdt_mbm_apply_quirk(u32 num_rmid)
 	mbm_cf = mbm_cf_table[cf_index].cf;
 }
 
-int __init rdt_get_l3_mon_config(struct rdt_resource *r)
+void __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	unsigned int mbm_offset;
@@ -519,8 +519,6 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 		intel_rdt_mbm_apply_quirk(num_rmid);
 
 	r->mon_capable = true;
-
-	return 0;
 }
 
 static void resctrl_abmc_set_one_amd(void *arg)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 79d4ddc3d64d..ecdb5da50179 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3193,6 +3193,11 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
+		ret = invalfc(fc, "No allocation or monitoring features are available or enabled");
+		goto out;
+	}
+
 	ret = setup_rmid_lru_list();
 	if (ret)
 		goto out;
@@ -3251,8 +3256,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (resctrl_mon_capable())
 		resctrl_arch_enable_mon();
 
-	if (resctrl_alloc_capable() || resctrl_mon_capable())
-		resctrl_mounted = true;
+	resctrl_mounted = true;
 
 	if (resctrl_is_mbm_enabled()) {
 		r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-- 
2.56.0

