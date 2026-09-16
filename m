Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAAE4E2F35
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600426; cv=none; b=mjw0vJSPI51Fgp+fDapQis7qWNN+PvWwGdriSH3VyKjDmNaadOJm8fwNwpqMpc7EiZ4VhWLJUYRQY5vqVepls8mJHCurUwY3ecmTooMR5lEuQFNodrUA6HTC3nKckg2uFXjtbH+WRuDY577bqu6j3LZObRQ434rWR2vZbGxG5t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600426; c=relaxed/simple;
	bh=tNMbExkvVFOJ1CKrMUqgJLqIQ8y5YPWxH/cuiLOMbVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJAM9lKKLYXE9mDSBUvlDH8Cu3T6OMZVOtMwEpU7w6d1Xiu/EzcAAxJqNsJYDgf1ysuuAthjBX1KWz0IT0WGQYzPuDvKI3CBmjHkJSzehBjJBv54KzlkK17SWmUkq5145l1mqnqqPoTqye2b2G7O26z57tJ3tenj/Kqrxpxvtrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lYHg1JWy; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lYHg1JWy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600424; x=1821136424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tNMbExkvVFOJ1CKrMUqgJLqIQ8y5YPWxH/cuiLOMbVg=;
  b=lYHg1JWy2c8uXmCYqVyz1vhj5ia4z0u0k6LMn5apsVR6/fImXn2ErZbz
   5p0Umtvy0nTxYAST//Wsduxcf7R/Fe2Lai1kdLk3GotOdg8l4VNDrzdam
   eLdbzYTY5lUyfFJmk30L65+U0g6+5DoJbvvbWJCLYBE6QIZOsz9YcRKXD
   5LWKqepUzsGuC8qk3yNspx+9y/9HtupQHZpPlmU27lJ+BsL+cO9uZ/VPM
   /YPSLM4fAaC0rnTJfPhVVkJoG7BCdUSN6qPPdJ69IdvRqI3o3GC5UVzBN
   MmKPWaI7K/KeskMQ0bWHCIhYJMYO3rloIAyAo4ms7nyJUs0OeGDjhhQj7
   w==;
X-CSE-ConnectionGUID: vQWJs7SmQfK03ioA0Pj/3g==
X-CSE-MsgGUID: BD/yWsaXT6ebudM9mwN10w==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861424"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861424"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:35 -0700
X-CSE-ConnectionGUID: uI5VSaESQN+GAyHnb+X0UA==
X-CSE-MsgGUID: RY3VMEigTPG9hx3XO5oqVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231465"
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
Subject: [PATCH v12 12/25] arm,x86,fs/resctrl: Allocate maximum needed rmid_ptrs[]
Date: Wed, 16 Sep 2026 16:13:07 -0700
Message-ID: <20260916231320.14502-13-tony.luck@intel.com>
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

File system code allocates the rmid_ptrs[] array once during
initialization. The number of entries needed in this array is currently
constant. When changes are made to allow Application Energy Telemetry
(AET) to run with the pmt_telemetry driver as a module, then number of
entries needed may change from one mount to the next.

Allocate rmid_ptrs[] with enough entries for any future mount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	New patch. Split out from old patch 12.
	New global pqr_assoc_num_rmid to avoid repeat CPUID calls.
---
 include/linux/resctrl.h            |  1 +
 arch/x86/kernel/cpu/resctrl/core.c | 27 +++++++++++++++++++++++++++
 drivers/resctrl/mpam_resctrl.c     |  9 +++++++++
 fs/resctrl/monitor.c               |  2 +-
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index fbf737e884db..5535bde7b925 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -447,6 +447,7 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
 /* The number of closid supported by this resource regardless of CDP */
 u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
+u32 resctrl_arch_system_max_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2e3b9c16cbda..a9109f2bc43e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -45,6 +45,9 @@ static DEFINE_MUTEX(domain_list_lock);
  */
 DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
+/* Number of RMIDS values that can be written to IA32_PQR_ASSOC.RMID */
+static u32 pqr_assoc_num_rmid;
+
 static void mba_wrmsr_intel(struct msr_param *m);
 static void cat_wrmsr(struct msr_param *m);
 static void mba_wrmsr_amd(struct msr_param *m);
@@ -124,6 +127,28 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
+/**
+ * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
+ *
+ * Return: Maximum possible number of RMIDs used for boot time allocations.
+ */
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	u32 num_rmid = pqr_assoc_num_rmid;
+
+	/*
+	 * If the system is capable of L3 monitoring the maximum RMID value may
+	 * be lower than the system maximum. Either because the L3 monitoring
+	 * feature supports fewer RMIDs, or because SNC (Sub-NUMA Cluster)
+	 * is enabled and divides RMIDs per cluster.
+	 */
+	if (r->mon_capable)
+		num_rmid = r->mon.num_rmid;
+
+	return num_rmid;
+}
+
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 {
 	if (l >= RDT_NUM_RESOURCES)
@@ -967,6 +992,8 @@ static __init bool get_rdt_mon_resources(void)
 	if (!cpu_feature_enabled(X86_FEATURE_CQM))
 		return false;
 
+	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
+
 	/* Any of the L3 monitoring features? */
 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
 		return false;
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 0db62dd2a71c..0ffa25199f74 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -252,6 +252,15 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
 }
 
+/*
+ * File system calls this for one-time allocation of structures
+ * during initialization. Return the largest possible value.
+ */
+u32 resctrl_arch_system_max_rmid_idx(void)
+{
+	return resctrl_arch_system_num_rmid_idx();
+}
+
 u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
 {
 	return closid * (mpam_pmg_max + 1) + rmid;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 2a28fe04284b..e8775e08aa18 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -978,7 +978,7 @@ int setup_rmid_lru_list(void)
 	if (rmid_ptrs)
 		return 0;
 
-	idx_limit = resctrl_arch_system_num_rmid_idx();
+	idx_limit = resctrl_arch_system_max_rmid_idx();
 	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
 	if (!rmid_ptrs)
 		return -ENOMEM;
-- 
2.55.0

