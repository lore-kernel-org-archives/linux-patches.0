Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B13920720D
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222926; cv=none; b=Fwa5GDB7gBCoVDyheS5uDpb4XX1oO1PPDEuKVxsWfJ/FCMF6ltuVi5oF5dMs6122ZQ/KhYLVhJt1zwZP87dwNqmRJtE1/MEneWXB9YrSe4iU2EIbzYl5rN1FBsQDAiBLMFbgKCBiQIGecXlZAzqVmqMRD7rcP63Ikd4FCMD3428=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222926; c=relaxed/simple;
	bh=v+xCJOJVDhdzdFGOhm7Qwh+e7FfyEjIfLSDzmGGOMgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0JFhGviJUQYbgUaNe5M0EISGzq4iONYpxtNavEtvSvktg47QuTsheHWDPtqQNFwKGET47wPtWKa8RN23avz1FG24EVNi5Tx4R2q1aXJuAuJiTWidNwLf3/xT1M2xdmgoIX/anq+UnqiiuULIvHJUAG210WZkoHfSXTn4AfTgZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hs873iJA; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hs873iJA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730222922; x=1761758922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v+xCJOJVDhdzdFGOhm7Qwh+e7FfyEjIfLSDzmGGOMgQ=;
  b=hs873iJAWrfLFejv1z1za4r7Y9MWHExBT+6unb+keVOZd7kjI5dnFnFj
   OPbocuYiP3WUsTFHSawx3RWRY8+ib3BbcbTCYWHbw2mjo6wJsCNy9XhGh
   EV3CrAYdFb5za1QUoKXEY/F/z23R6xiwbSKK3ZCNLgDb16h0vdTWVqD9H
   0gg3Gt+cE70OU5ZNxVuoI37QZD2cOg4bhbTVgnxdw2n/VCk3ZN8XQM0kF
   zG2OQsYn3pMNzeUYXnlvKRDrpLSQfFakdUwJsG2ndFg7IMwKAVa+oviV0
   tTzEzzTGYIcX71YHMFHbOEYzbQ9NjbqmIP3oKuM6kOLNx7hag8vfUWzvg
   Q==;
X-CSE-ConnectionGUID: mvfc7LTbS1qk9XM+TkXXgw==
X-CSE-MsgGUID: nWF6/vDGTGe1802E279NmQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="17515667"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="17515667"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:39 -0700
X-CSE-ConnectionGUID: YbGM6yPjRA+TbtWKUmg+QQ==
X-CSE-MsgGUID: apXHOrM1RPSSX9LhriNZUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81585603"
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
Subject: [PATCH v8 3/7] x86/resctrl: Refactor mbm_update()
Date: Tue, 29 Oct 2024 10:28:28 -0700
Message-ID: <20241029172832.93963-4-tony.luck@intel.com>
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

Computing memory bandwidth for all enabled events resulted in
identical code blocks for total and local bandwidth in mbm_update().

Refactor with a helper function to eliminate code duplication.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 69 ++++++++++-----------------
 1 file changed, 24 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 3ef339e405c2..1b6cb3bbc008 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -829,62 +829,41 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
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
+
+	if (is_mba_sc(NULL))
+		mbm_bw_count(closid, rmid, &rr);
+
+	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+}
 
+static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
+		       u32 closid, u32 rmid)
+{
 	/*
 	 * This is protected from concurrent reads from user
 	 * as both the user and we hold the global mutex.
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
-
-		/*
-		 * Call the MBA software controller only for the
-		 * control groups and when user has enabled
-		 * the software controller explicitly.
-		 */
-		if (is_mba_sc(NULL))
-			mbm_bw_count(closid, rmid, &rr);
-
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
-
-		/*
-		 * Call the MBA software controller only for the
-		 * control groups and when user has enabled
-		 * the software controller explicitly.
-		 */
-		if (is_mba_sc(NULL))
-			mbm_bw_count(closid, rmid, &rr);
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

