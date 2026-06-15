Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EB033508E
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547915; cv=none; b=Ptw1PO8DW+51SOpsz+vRGtWpXMTb9MytCuH5Zl6aa8mErfI7VEa5gMeBQbUJTZNaBNJzNLbLlQjVCbyYW9620rTYSmkIzDjVdz40eUmyPRL+nN0F+nJrXJvW6vm+4xlIr2J0wu+Q8wmImlTLuZLP7UavuOMeLMzNOtDk3miHFTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547915; c=relaxed/simple;
	bh=8s+4l5dBFT8j0RbC0XLevFKHwJIItgN5f7cvG24Wo00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjhRYB6NAm6j0zNwKU37usZCqdh0E5dBxU52ZWbrdrKMJaZzuKmnWchcwXNgNOhE60jymO2YWEyOSYIkKR9vILz/Aqs8wUmDU5lhbNZjg/oKcjmdZvJAhLLyU7qPHEuxBOQ8amL1Hhk0xbvJu5YOAOWBVWvFlLVQsHR+c2cczd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JnAhQ1xo; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JnAhQ1xo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547914; x=1813083914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8s+4l5dBFT8j0RbC0XLevFKHwJIItgN5f7cvG24Wo00=;
  b=JnAhQ1xoR0DScEL24Sbg46Z4hb0zj/12BoW/0o/P111ieadvBf+QhKc0
   +KTGyJrRZR/vnSpvWJs7vVRo5Q6sz+KFzXy9eP0GToIsaTjgSp2/4KbTt
   jDFMh7E5IQUnBfRol8SZraOuScqrd6xb7RD6LHQeP8FbCZNaUCby+mfm3
   oc/hLZ2VowoI94E3AU4cvueYCntpmj3DEVQYhkYWFJmbLAm07l8hMhq7m
   wrdwN9n5FaA4rlVZbM3dSBF4uk0Zi7ANXU52GC/EbzbSLsCGBAD/guXfJ
   pG659aVNWcfqtrkNvWofc+O9q7h29s5KEhLW6Dbmlemn0piz8xXhCBXHQ
   g==;
X-CSE-ConnectionGUID: P1CscsMOQJaygIGmG8Il5A==
X-CSE-MsgGUID: eQ287OhxR6KYhrM90X6xzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789997"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789997"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:10 -0700
X-CSE-ConnectionGUID: XClgXzk2SYyjjKjvSLE7wA==
X-CSE-MsgGUID: dO6kUSfjR6Cy2fqolPdk4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620639"
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
Subject: [PATCH v8 09/16] x86/resctrl: Drop global 'rdt_mon_capable' flag
Date: Mon, 15 Jun 2026 11:24:50 -0700
Message-ID: <20260615182457.14725-10-tony.luck@intel.com>
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

File system code calls resctrl_arch_mon_capable() to determine if the
system supports any monitoring features.

x86 architecture code sets a global flag to support implementation of
resctrl_arch_mon_capable() but the upcoming change to enumerate AET
(Application Energy Telemetry) features on each mount introduces a new
corner case.

Specifically when AET is the only monitoring feature, loading and
unloading the pmt_telemetry module between resctrl mounts may result
in monitoring support enabled on some mounts, but not on others.

Replace the global flag with a scan of resources to check if any are
marked mon_capable.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
v8:
	Change from a count of monitor features to a scan of the
	rdt_resources checking for any that are mon_capable.

 arch/x86/include/asm/resctrl.h        |  6 +-----
 arch/x86/kernel/cpu/resctrl/core.c    | 18 +++++++++++++++---
 arch/x86/kernel/cpu/resctrl/monitor.c |  6 ------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 575f8408a9e7..a9f481b7a8ed 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -43,7 +43,6 @@ struct resctrl_pqr_state {
 DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
-extern bool rdt_mon_capable;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
@@ -66,10 +65,7 @@ static inline void resctrl_arch_disable_alloc(void)
 	static_branch_dec_cpuslocked(&rdt_enable_key);
 }
 
-static inline bool resctrl_arch_mon_capable(void)
-{
-	return rdt_mon_capable;
-}
+bool resctrl_arch_mon_capable(void);
 
 static inline void resctrl_arch_enable_mon(void)
 {
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..fb6d52ea3406 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -50,6 +50,20 @@ DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
  */
 bool rdt_alloc_capable;
 
+/*
+ * Need to re-evaluate on each mount whether any mon_capable resources
+ * are enabled.
+ */
+bool resctrl_arch_mon_capable(void)
+{
+	struct rdt_resource *r;
+
+	for_each_mon_capable_rdt_resource(r)
+		return true;
+
+	return false;
+}
+
 static void mba_wrmsr_intel(struct msr_param *m);
 static void cat_wrmsr(struct msr_param *m);
 static void mba_wrmsr_amd(struct msr_param *m);
@@ -779,7 +793,6 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_lock();
 	mutex_lock(&domain_list_lock);
 	r->mon_capable = true;
-	rdt_mon_capable = true;
 	for_each_online_cpu(cpu)
 		domain_add_cpu_mon(cpu, r);
 	mutex_unlock(&domain_list_lock);
@@ -1013,9 +1026,8 @@ static __init void check_quirks(void)
 static __init bool get_rdt_resources(void)
 {
 	rdt_alloc_capable = get_rdt_alloc_resources();
-	rdt_mon_capable = get_rdt_mon_resources();
 
-	return (rdt_mon_capable || rdt_alloc_capable);
+	return get_rdt_mon_resources() || rdt_alloc_capable;
 }
 
 static __init void rdt_init_res_defs_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 59215fef3924..682585fffe46 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -25,12 +25,6 @@
 
 #include "internal.h"
 
-/*
- * Global boolean for rdt_monitor which is true if any
- * resource monitoring is enabled.
- */
-bool rdt_mon_capable;
-
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
 static int snc_nodes_per_l3_cache = 1;
-- 
2.54.0

