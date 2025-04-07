Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79716253B7D
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069269; cv=none; b=R2VeX4I/gAqnz42R4dSbyDn4qMp9G8yPKBevC2D/TjiL6+ktvhGVGLLVC+4a6DuQelbS2syNFIGd24z5HNo6pmdSyeB7WQ7JzoMVMCdawz8Y/D4OIUIMg9DRyKigfYsWAz6jUVoPJJEE4Cee2TnS8Xkon6ACNcuF0yXS7lC6EKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069269; c=relaxed/simple;
	bh=YPgBmaGFxAjBWQ1H7JPon+CBlWuuyIL/tEBYIMVCULo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAV7Dq9U3yWS6+MdsAFf8u96wODbMRpLv+3X0WZqIZnj6RMpVVQOBK8OM9ESYFgqhl7k0iBFmd5tGuIUKz/xmYWHkgTzVk/4+LJv/NowqOWSbSA33ksyfmiZZCmrKogPRk5GR/xEPLYNmpivJ2nh5Pw0taqeroLEXKVnJGYGD3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RWiUV/jG; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RWiUV/jG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069267; x=1775605267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YPgBmaGFxAjBWQ1H7JPon+CBlWuuyIL/tEBYIMVCULo=;
  b=RWiUV/jG+ngoWF/XRMAy1xTMCZEjUdMdnPfmsww4UpTvCzdLgQtMWEAn
   /hyy2kBncMYgoYOca901Jg1t39xWuhC+4WGVYiYGaWVak/U9hJH8oGt2I
   WoKtqQi/uU5vWAz4YpK3vRcWM5vOGdH/wNt5aNbv0m0+UB8eIJMEkr9mI
   WCYjrXx6BQIkC9FEifKMNZyH8+ceZdphJ6vI4XfR+2DTteXwCMKNgIzKl
   oPhh61jblN/nr4OECdH4FyNHDTaC30YxMEAuEqJUFKk7LBmhbpNYd34UY
   fwd8FmfWEd9/H8AqkL/GFxlDACSzTLEsYFRrwYCDXSix5GryI3Rhb1Vw7
   Q==;
X-CSE-ConnectionGUID: 4ZWidSMmTGGKt/wfBT1d6w==
X-CSE-MsgGUID: mRFWKzcIQgScdFcFzcdkFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193292"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193292"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:57 -0700
X-CSE-ConnectionGUID: 6ZRJfK9HQTig6tJ5vgiMSw==
X-CSE-MsgGUID: 8IaI1KoAR5+RYI+M13hzkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315527"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 24/26] x86/resctrl: Final steps to enable RDT_RESOURCE_PERF_PKG
Date: Mon,  7 Apr 2025 16:40:26 -0700
Message-ID: <20250407234032.241215-25-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For each of the discovered telemetry events:
 Mark as enabled in the rdt_mon_features bitmap.
 Set the value display type.
 Mark that the event can be read from any CPU.

Because the resource was not marked as enabled during early
initialization no domain discovery and allocation was done.
Do that in the architecture first mount hook.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c      | 14 ++++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6f5d52a8219b..83da63b24f45 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -756,7 +756,9 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 
 void resctrl_arch_mount(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	static bool only_once;
+	int cpu;
 
 	if (only_once)
 		return;
@@ -764,6 +766,18 @@ void resctrl_arch_mount(void)
 
 	if (!intel_aet_get_events())
 		return;
+
+	/*
+	 * Late discovery of telemetry events means the domains for the
+	 * resource were not built. Do that now.
+	 */
+	cpus_read_lock();
+	mutex_lock(&domain_list_lock);
+	r->mon_capable = true;
+	for_each_online_cpu(cpu)
+		domain_add_cpu_mon(cpu, r);
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 0bcbac326bee..529f6d49e3a3 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -233,9 +233,14 @@ bool intel_aet_get_events(void)
 			continue;
 		for (int i = 0; i < (*tentry)->num_events; i++) {
 			enum resctrl_event_id evtid = (*tentry)->evts[i].evtid;
+			enum resctrl_event_type type;
 
 			evtinfo[evtid].telem_entry = *tentry;
 			evtinfo[evtid].pmt_event = &(*tentry)->evts[i];
+
+			__set_bit(evtid, rdt_mon_features);
+			type = (*tentry)->evts[i].type;
+			resctrl_set_event_attributes(evtid, type, true);
 		}
 	}
 
-- 
2.48.1

