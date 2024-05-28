Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0264140367
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934828; cv=none; b=mimFFlCjMYxChaF4Xe9QODblS+LQ5eWIHVfowBcu0r58vILlInKatm+/TQ45AIz7SA9iTjLGCbn54NEqsloJtvOO5ebwleHwm657kVQeEztaAnNyWm6I6oVEFhEGNvtTWgzkw+LAEsolGgmGmVQ5HfX+L47ZrqkkJ2ONB3kLsJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934828; c=relaxed/simple;
	bh=gvFMDpgaVv7QnSj3PgD23X9RCDFZmZbHhJTigmpS9f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFF/+FCcACV/IOGkdwdaFKaYNFvpE4BiITLpmC64FqIEMFydOtD8d8lDoiKDbyLZqKfc9G+qFwmZw1aR2gTx87RDlE/zUzigJjzubwbEP9pqlwTNIcJZs3Ed9Qdoy/35OS5ZDKiPHZGvUMGRdUnNN0rDP2FHEFKKPQWBdjfDsJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WmWz8JGh; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmWz8JGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934825; x=1748470825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gvFMDpgaVv7QnSj3PgD23X9RCDFZmZbHhJTigmpS9f8=;
  b=WmWz8JGhiB9TiLoEWWTKymt78U+URXb1P5dldU9saqWodQzT7X1WY+So
   BmLPK0DepOSARv7DIJ6w5FHF7an6pAwv+GVO42r/Sp8lomjG5ymstP5eX
   kWJfxsrPxMCiimWhkcCTZxgM0VWc3yy0jy4ZAW9ZmGh4nHb1wNXPZGvlH
   yRqrUfBk918BuA9aJsM6i3ISeuGKbEVrGXpln3htcmHr25qLKATHfqgdu
   tfciHT1JqHe2DhUEjaYFXM1CITYySjwoT6wz9RX94c4u31Gf1cWku0DTD
   NBXAu3mrF/qKZYQieGSSgPoQwbEB6WIIIHkHPZLDC8/CXMM1Pbp+I7Rek
   g==;
X-CSE-ConnectionGUID: VLq5XPpeQM67wL5qYVYeCw==
X-CSE-MsgGUID: BSfsCXbIQGyMDy12BE+jrw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812241"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812241"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:19 -0700
X-CSE-ConnectionGUID: j6MTe7BOQAqwVFNC29tC8g==
X-CSE-MsgGUID: 2qrs8swnQWSYsoRuuKSojw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090761"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v19 15/20] x86/resctrl: Pass two extra arguments to resctrl_arch_rmid_read()
Date: Tue, 28 May 2024 15:20:00 -0700
Message-ID: <20240528222006.58283-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For backwards compatibility on Sub-NUMA Cluster (SNC) systems the legacy
files in the mon_L3_XX directories must report the sum of data from each
SNC node sharing that L3 cache instance.

To make this possible, pass the "sumdomains" and "ci" fields from
rmid_read structure as extra arguments to resctrl_arch_rmid_read().

Note that the call from check_limbo() never operates on a "sum" basis,
so pass sumdomains=false, ci=NULL.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h               | 4 +++-
 arch/x86/kernel/cpu/resctrl/monitor.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index d733e1f6485d..d0281c93229d 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -276,6 +276,8 @@ void resctrl_offline_cpu(unsigned int cpu);
  * @rmid:		rmid of the counter to read.
  * @eventid:		eventid to read, e.g. L3 occupancy.
  * @val:		result of the counter read in bytes.
+ * @sum:		sum across all domains sharing an L3 cache instance
+ * @ci:			cacheinfo structure for the cache when @sum is true
  * @arch_mon_ctx:	An architecture specific value from
  *			resctrl_arch_mon_ctx_alloc(), for MPAM this identifies
  *			the hardware monitor allocated for this read request.
@@ -292,7 +294,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  */
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *arch_mon_ctx);
+			   u64 *val, bool sum, struct cacheinfo *ci, void *arch_mon_ctx);
 
 /**
  * resctrl_arch_rmid_read_context_check()  - warn about invalid contexts
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index b9b4d2b5ca82..5f89ed4823ee 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -300,7 +300,7 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
 
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *ignored)
+			   u64 *val, bool sum, struct cacheinfo *ci, void *ignored)
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
@@ -380,6 +380,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
 		entry = __rmid_entry(idx);
 		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
 					   QOS_L3_OCCUP_EVENT_ID, &val,
+					   false, NULL,
 					   arch_mon_ctx)) {
 			rmid_dirty = true;
 		} else {
@@ -589,7 +590,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	}
 
 	rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid, rr->evtid,
-					 &tval, rr->arch_mon_ctx);
+					 &tval, rr->sumdomains, rr->ci, rr->arch_mon_ctx);
 	if (rr->err)
 		return rr->err;
 
-- 
2.45.0

