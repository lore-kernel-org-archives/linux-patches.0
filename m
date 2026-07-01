Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FDC3BD651
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941767; cv=none; b=ivDDJNY8b+slYsfTTID7GEQ8/H7iCRIRlk8hdESgemfYvapZTFzcWSDYdMnXDFIOkuEIy13joHAA5XhwMPi1tZ5sEH+Nb1UhNKfpWU580tc9VSXQnJpbbv5Hg9KrqJj+jlNFueSQXzIkq6vJ3HE3PXPMxCRIIsMkIug5MP/6zdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941767; c=relaxed/simple;
	bh=UGP+D34ZGO6ZxBBP4DI4jYcTMnLnvqglZe6HvnsQvTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bpca2Q7BZl06u4/1KTPs66geLxCeUEIJid+urO7KIrZKQrxiqm5rZm3DwWpu7VCm3OUZd5bcxFiALRfeDKw3ChtjrxovMFRvzdpF1yFlYu0WoPhFYYvNrLSyq+b55KSUA+4wbeNW+S1Gk80NJ8KYNwwi54E0NW2wKK/hGdUY1Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lG1cu9Fx; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lG1cu9Fx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941765; x=1814477765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UGP+D34ZGO6ZxBBP4DI4jYcTMnLnvqglZe6HvnsQvTo=;
  b=lG1cu9FxvgYNPKk4NSH4Xzgu3h4Bei2UyiauB+u60u/SC5R55BZBxw4M
   w9g5Mi5St1brKFCGjzgMopmlzgh7niGir7BqNEajMn1HZU8W14RBoka2N
   hBNelXJeNQoXt9Ukspbtbm9yJaeleVg4l7oOpo96uGUUYG2BINxoJ22k0
   /Rj5WDCL2RgHQpwv08gaiKTtK01oj1H94KTA9XQdea1nRtTBjGpBB+Xf7
   En56MFZvIlnNl24kliqqWaU8c+cd/M3ZHi022xEKk86eMsS+LZdJANos8
   gvllywYEHST+YYFZA/gJFuP7DjdJMouDSQv7l9L7YxbmKkrYeUW43NF+f
   A==;
X-CSE-ConnectionGUID: lzf7XiQcRTuElFOazXWkkQ==
X-CSE-MsgGUID: ESmWREHHRYiOnd6Rq4unqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285787"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285787"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:03 -0700
X-CSE-ConnectionGUID: cAQ1IQSDRYSOYmwcvDYVWQ==
X-CSE-MsgGUID: rKTcIeEHRXeCTmp0l4VwcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242532"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:03 -0700
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
Subject: [PATCH v9 05/12] x86/resctrl: Drop global 'rdt_mon_capable' flag
Date: Wed,  1 Jul 2026 14:35:46 -0700
Message-ID: <20260701213553.15222-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
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
index 9b9495174041..60d50ac79e7b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -51,6 +51,20 @@ DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
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
@@ -780,7 +794,6 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_lock();
 	mutex_lock(&domain_list_lock);
 	r->mon_capable = true;
-	rdt_mon_capable = true;
 	for_each_online_cpu(cpu)
 		domain_add_cpu_mon(cpu, r);
 	mutex_unlock(&domain_list_lock);
@@ -1014,9 +1027,8 @@ static __init void check_quirks(void)
 static __init bool get_rdt_resources(void)
 {
 	rdt_alloc_capable = get_rdt_alloc_resources();
-	rdt_mon_capable = get_rdt_mon_resources();
 
-	return (rdt_mon_capable || rdt_alloc_capable);
+	return get_rdt_mon_resources() || rdt_alloc_capable;
 }
 
 static __init void rdt_init_res_defs_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 430b8fae0b77..1fea893f2cc1 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -26,12 +26,6 @@
 
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

