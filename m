Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86373A63FD
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907017; cv=none; b=npIVvauxcBA+hmQNmHP/6p4MbdBB1doBWKrZdFoZQpYUN0qNfqDsaDnd3ujaSf8DtmYyhIsn7oKVHcWZTgkiMp4V/fn+odjXcDZxFyxR1tBqMqtWRAiSx+rUuA1nABrVfCnzjMFgbHDKHK4/SMAsUT8dp4jUhWeyw6/3saB4JAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907017; c=relaxed/simple;
	bh=xtE44q2ZzCMv7I6kbznslRjiV+xZN4F/4mn+Kkwu6zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdcmMDlpstTZ5bP1UgSv5BZSy2PaP6z8Qp3F4lypTrmylO5fNjPAs1lvV/TJW4UreA0glfG1lGe172Ebil/VYwenG08UDysOXsQm85Jr2DCLH+JiP7uZn5NxiFS6eypHNQ47To/8KZpe/WOB0Y5Y+kmnW71qohKsrpva7l4CfYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gp7mJySp; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gp7mJySp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774907016; x=1806443016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xtE44q2ZzCMv7I6kbznslRjiV+xZN4F/4mn+Kkwu6zc=;
  b=gp7mJySpTxJU9zQBaGYKGvzX2F8U8z8gvIMA6GkXg+lCAqb4zYpzKLQr
   qHOCdVEvqtrSZVqmGb0BCz8gDuTsVBqjjv7RvLbBKvII9cbPKvSc6DPrO
   TrR3YKfVj/7tuSWPaZy9Em7Hmys1hoTBAbzD83QRyVev4kOUrxSs1gFxa
   WPveHpfryNHTwSMMeOnmDAIhkk21nGJqSIGGRDfTD7xdJ+2THKHyDHOUS
   Pq6iMBZD+ZPLVOQd3h2oUSQY4ZYdibHz3wqpDWf4eR1ht+NH0nufS6VeW
   V3a0mRev189jBe7438fgCK3TmgoBJATOYhglixHneQWQeOy9wDsPfd04f
   Q==;
X-CSE-ConnectionGUID: NuQVFEjgTOyZlCe1xJTlng==
X-CSE-MsgGUID: 8CNh5Th1QCmKDKtBDS+QNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79772171"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79772171"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:34 -0700
X-CSE-ConnectionGUID: 5EY3sljkSMi0YeWwcu5PXQ==
X-CSE-MsgGUID: n5e0aSZKRxeD11wK7lqG4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225185952"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:34 -0700
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
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 6/7] x86/resctrl: Delete intel_aet_exit()
Date: Mon, 30 Mar 2026 14:43:21 -0700
Message-ID: <20260330214322.96686-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330214322.96686-1-tony.luck@intel.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All cleanup for AET is now handled during file system unmount.

Drop intel_aet_exit().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 2 --
 arch/x86/kernel/cpu/resctrl/core.c      | 2 --
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 4 ----
 3 files changed, 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 6f322818a9e6..2230b64fa2ba 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -237,7 +237,6 @@ void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 bool intel_aet_pre_mount(void);
 void intel_aet_mount_result(int ret);
 void intel_aet_unmount(void);
-void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
@@ -246,7 +245,6 @@ bool intel_handle_aet_option(bool force_off, char *tok);
 static inline bool intel_aet_pre_mount(void) { return false; }
 static inline void intel_aet_mount_result(int ret) { }
 static inline void intel_aet_unmount(void) { }
-static inline void __exit intel_aet_exit(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 162eca2cfcdb..1951df519dea 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1172,8 +1172,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 14b472106f52..b708c94a4a83 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -327,10 +327,6 @@ static bool aet_get_events(void)
 	return ret;
 }
 
-void __exit intel_aet_exit(void)
-{
-}
-
 static bool get_pmt_references(void)
 {
 	get_feature = symbol_request(intel_pmt_get_regions_by_feature);
-- 
2.53.0

