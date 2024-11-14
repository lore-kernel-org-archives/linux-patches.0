Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60F3EEBA
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 00:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543444; cv=none; b=AkAdb/Zm33WW3mP0L/y4lYUzQ/WB2rGjSWzKMQ1IUuuawyxFBCztj6NEz6xMOjAHLLGi5Bp4/bGP3mSuy0Ww+N4w3KfTEkdFwUvTgEmSXyeXBOh+03bzBf3Kc8qvhVxNkOp0bqP7N2eRtvQ1+hfW8jhOjRli20BW0RHDxIbQMZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543444; c=relaxed/simple;
	bh=zzo2aTPnZlb8eHWTc7jsHa6kx3qkBJuqN1+to4NFkNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDhuiyI+qr1bTyIncRGgFcOhZdzuRC78HYxkFyM+t7L4dmWus+QBv+ZbW0wwEr3qAAcHrRNn4fFEyhRAGvGHywZe5TH99LDfrNrwJ2iqrAsQZxYYxDYhPIBCRDySmTM+lecGabz0lCXoT4zsLC2OmLGtqaCWNPjN6adi8Zup9ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qjt2N7sp; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qjt2N7sp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731543442; x=1763079442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zzo2aTPnZlb8eHWTc7jsHa6kx3qkBJuqN1+to4NFkNU=;
  b=Qjt2N7spAfk5lkwIgxd3+a/1ojmOylF7glIXThUKCfD5Ihf+/if+7lZQ
   9nhfHwdhO0UM9UQpaQbZmEQQVxc4FkabD4R0M2uS1paF/LDTgrJJGuxOh
   3e/C71MQMYQPYQhpyyTeuEHkGJ/24NUaT6awMWF3TTaq2pvmNDW54Wko6
   W7m3gSRKniK2be1nO25nqr7m8IH/eadAApR9rjAbrwlWKOs7KoPPGAWz9
   XfxjbYHFWkw5lqGV9mpHvskMPmF0ii5Uknnq/JysziJM4Aa7CLujssVkF
   NL7dISDfLkMzhEFGZKrhCF2i6TT3Ljggtx+Vnlu8+a84g2RVpLPYicGsw
   A==;
X-CSE-ConnectionGUID: +wjim4KJSWSbwgs7aE0ScQ==
X-CSE-MsgGUID: D5cidCqSRDW1RtxwLk8+uA==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="30869491"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="30869491"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:18 -0800
X-CSE-ConnectionGUID: i6zxnNvCTYCJsNXdkSVPzg==
X-CSE-MsgGUID: b1khOCY2SyCZqOsO8LdC6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92081160"
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
Subject: [PATCH v9 4/9] x86/resctrl: Compute memory bandwidth for all supported events
Date: Wed, 13 Nov 2024 16:17:06 -0800
Message-ID: <20241114001712.80315-5-tony.luck@intel.com>
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

Computing the bandwidth for an event is cheap, and only done once
per second. Doing so simplifies switching between events and allows
choosing different events per ctrl_mon group.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 72 ++++++++++++---------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 2176e355e864..da4ae21350c8 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -663,9 +663,12 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
  */
 static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
-	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
-	struct mbm_state *m = &rr->d->mbm_local[idx];
 	u64 cur_bw, bytes, cur_bytes;
+	struct mbm_state *m;
+
+	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+	if (WARN_ON_ONCE(!m))
+		return;
 
 	cur_bytes = rr->val;
 	bytes = cur_bytes - m->prev_bw_bytes;
@@ -826,54 +829,45 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
 }
 
-static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
-		       u32 closid, u32 rmid)
+static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
+				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
 {
 	struct rmid_read rr = {0};
 
 	rr.r = r;
 	rr.d = d;
+	rr.evtid = evtid;
+	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+	if (IS_ERR(rr.arch_mon_ctx)) {
+		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
+				    PTR_ERR(rr.arch_mon_ctx));
+		return;
+	}
+
+	__mon_event_count(closid, rmid, &rr);
 
 	/*
-	 * This is protected from concurrent reads from user
-	 * as both the user and we hold the global mutex.
+	 * If the software controller is enabled, compute the
+	 * bandwidth for this event id.
 	 */
-	if (is_mbm_total_enabled()) {
-		rr.evtid = QOS_L3_MBM_TOTAL_EVENT_ID;
-		rr.val = 0;
-		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
-		if (IS_ERR(rr.arch_mon_ctx)) {
-			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-					    PTR_ERR(rr.arch_mon_ctx));
-			return;
-		}
-
-		__mon_event_count(closid, rmid, &rr);
+	if (is_mba_sc(NULL))
+		mbm_bw_count(closid, rmid, &rr);
 
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
-	}
-	if (is_mbm_local_enabled()) {
-		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
-		rr.val = 0;
-		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
-		if (IS_ERR(rr.arch_mon_ctx)) {
-			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-					    PTR_ERR(rr.arch_mon_ctx));
-			return;
-		}
-
-		__mon_event_count(closid, rmid, &rr);
+	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+}
 
-		/*
-		 * Call the MBA software controller only for the
-		 * control groups and when user has enabled
-		 * the software controller explicitly.
-		 */
-		if (is_mba_sc(NULL))
-			mbm_bw_count(closid, rmid, &rr);
+static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
+		       u32 closid, u32 rmid)
+{
+	/*
+	 * This is protected from concurrent reads from user
+	 * as both the user and we hold the global mutex.
+	 */
+	if (is_mbm_total_enabled())
+		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
 
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
-	}
+	if (is_mbm_local_enabled())
+		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
 }
 
 /*
-- 
2.47.0

