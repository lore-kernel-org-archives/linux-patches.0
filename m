Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A31E1FFC5F
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733502719; cv=none; b=mLR0Cw1jt/9iAqygs+aSAKRMWeOPKFhje38fCqFulDgK6qoKtqPm1rHqyokc/M1v6Yib7ayPEDJpvsi2A5r+r9VZWyUgV/C8q3qp9Trk9qXETkrzTWAkoQ9jT4tNIt7hkwPUTupBjxZvsd1kXgjPe6MSpCd3BSCTQMbHznvcVx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733502719; c=relaxed/simple;
	bh=JG3z7yTbByVBYHLz+pJgSPAGR9jxx7TOcdejCgHSi+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hz4K0Z0oxSVVYUmzB3e1CfBohbM6bVBV/gXSRm0rPNS9y+z56LGgMOiC5936VWLj7oQoxaiZ03ecibmfFFw9CeyoilQdChH2xBR7ZdhuhW7/OlgOJzdtggYKiUpNY0O/pdDj0QKM+0IZswx1ncPp/SL2OsED7yUg8fv3gZaHB5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fC3E3IRI; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fC3E3IRI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733502717; x=1765038717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JG3z7yTbByVBYHLz+pJgSPAGR9jxx7TOcdejCgHSi+k=;
  b=fC3E3IRIwNMoaLg7cxk38moOBXQRb9lZ9ufFWKw0VvJpSlbrHecBfv7l
   zNYQ3n6hOGX+PwHyj5eLUjG/ytxKLI1EI/h8C5nsibiPZs7gGLuYJPeyZ
   UM85WxtQXOFxSHBArjXok7UO5P7oPApfZfl5w/S0PJJFy6I+qjsGuyIFZ
   v3bWYIJV5WeND82UCsMiecer6ppwiyujBRF+ilBSDv4yKiwV3rRUL0kS9
   wQAsn9v1tk/UfKSFySjkdZBEUJZJNZmeWEAHaWzWvwOKdgw6/Z6h0EhTp
   jfAriIg+NMpaj8J3dHSX7qYmjSHcoNXzFAS784XBHzMC3NnvYINW7mYgk
   w==;
X-CSE-ConnectionGUID: Lfw9v9cvTeiemtmSXIMFVA==
X-CSE-MsgGUID: VuduhUGBScGtd3QtHKIXuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="44470411"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="44470411"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:54 -0800
X-CSE-ConnectionGUID: nN6+PwVaT+CR0f3E5h3fXw==
X-CSE-MsgGUID: b6p8EBjlSq6JCv+AsXuGrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="95258517"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:54 -0800
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
Subject: [PATCH v11 4/8] x86/resctrl: Compute memory bandwidth for all supported events
Date: Fri,  6 Dec 2024 08:31:44 -0800
Message-ID: <20241206163148.83828-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206163148.83828-1-tony.luck@intel.com>
References: <20241206163148.83828-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switching between local and total memory bandwidth events as the input
to the mba_sc feedback loop would be cumbersome and take effect slowly
in the current implementation as the bandwidth is only known after two
consecutive readings of the same event.

Compute the bandwidth for all supported events. This doesn't add
significant overhead and will make changing which event is used
simple.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 72 ++++++++++++---------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index adb18f088979..94a1d9780461 100644
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
@@ -815,54 +818,45 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
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
+	if (is_mba_sc(NULL))
+		mbm_bw_count(closid, rmid, &rr);
 
-		__mon_event_count(closid, rmid, &rr);
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
+	 * This is protected from concurrent reads from user as both
+	 * the user and overflow handler hold the global mutex.
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

