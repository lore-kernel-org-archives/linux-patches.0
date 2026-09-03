Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67A44A2061
	for <patches@lists.linux.dev>; Thu,  3 Sep 2026 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454640; cv=none; b=jYiSkW33T07wRXUCjG3QRZphiWfrbjg1ZEfjdV9dw3J+a5w1zUErNJmB5PE2jqNup2KfOiZhTXyeKx2T1Rk9LaPr0/6lQwk+W4eh7bOgGJLIxvGB4VQbjEucroU6cUIFCUmm3yIpA+j3HtjQ89D9HGGJB+lhZmBCNOz98Br5t2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454640; c=relaxed/simple;
	bh=Q1F+Pt5vvbs7KnFk4LhRxvetCzPXQfzfyDR7LXcDy2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJtbR+Mls2GluXyWqLUdcMxS7Wi3NdFSlx60RK4Y1NMEF6LmE/LDJ205fbR9AR1mRRdFSjIrohgx/B48nW+T3WNRDKu5Vdry8tKyP9+db0NvyYQccH7uCZFMfyrJ9QxZbLcElPAtF3ucNvPHRzZRspr4tDV0h/hZCp5as5li1vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CiBT4poY; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CiBT4poY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788454638; x=1819990638;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q1F+Pt5vvbs7KnFk4LhRxvetCzPXQfzfyDR7LXcDy2Q=;
  b=CiBT4poYnvRSKDvUYPmqlZwl1F4nNppEwyiFhKDzJrVnXva91QC5vTmR
   XeJPeIlXOX0b5YfrJTxbbuBLtExY1sKnLvQZ/eO/oUrGcv01c/+Qe48fq
   LKbShkpecYJ86JrRoAPaPPcClrygr5N/WQi+r6eY7F0j3Ze9iL5dMgcBM
   0frh66CGihAKO22k0YSM2N/3X2+xXFRKaZLRxAGFvPzbeLBbvp5dsGdNG
   4Iy5c7fAE6c8fKposYwYRjbdyl9I+nOTJoik5/nhLonckO0/zFxbo0RqP
   OKZToy4QDbUb6+H9A1wZKVrtx/W1xH6UXddix3s4ALBLNpkyERmxnCTSd
   g==;
X-CSE-ConnectionGUID: Sw/LFLFqTi2MHZg0UBq4yQ==
X-CSE-MsgGUID: ayEuqIdEQj+T1lEg3Z8wiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="100103970"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="100103970"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 09:57:13 -0700
X-CSE-ConnectionGUID: VopLQFkBSMS6NKC4wa2RVA==
X-CSE-MsgGUID: OqDpg0l+QReQBEzdVK3fsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="273554214"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 09:57:13 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH 1/5] fs/resctrl: Drop support for different bandwidth delay mappings
Date: Thu,  3 Sep 2026 09:57:03 -0700
Message-ID: <9d39435847fb26fa7b467c563cf8bc45c314b917.1788452481.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788452481.git.reinette.chatre@intel.com>
References: <cover.1788452481.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The original Intel MBA support added by commit

05b93417ce5b ("x86/intel_rdt/mba: Add primary support for Memory Bandwidth Allocation (MBA)")

introduced but never used support for different bandwidth delay mappings.

Intel systems only support linear delay values for which there is a
direct map to the percentage based memory bandwidth control. There is no
need to support other bandwidth delay mappings.

Remove the unused resctrl_membw::mb_map and the unnecessary bandwidth delay
mapping function. Perform the direct map to percentage when writing the
control value to hardware.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC v1:
- Also drop separate delay_bw_map() and instead integrate the only
  mapping to when control value is written.

Changes since RFC v2:
- Rework changelog.
---
 arch/x86/kernel/cpu/resctrl/core.c | 23 +++++++----------------
 include/linux/resctrl.h            |  2 --
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 55214d6fdc49..65cfde0d6a9b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -323,29 +323,20 @@ static void mba_wrmsr_amd(struct msr_param *m)
 		wrmsrq(hw_res->msr_base + i, hw_dom->ctrl_val[i]);
 }
 
-/*
- * Map the memory b/w percentage value to delay values
- * that can be written to QOS_MSRs.
- * There are currently no SKUs which support non linear delay values.
- */
-static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
-{
-	if (r->membw.delay_linear)
-		return MAX_MBA_BW - bw;
-
-	pr_warn_once("Non Linear delay-bw map not supported but queried\n");
-	return MAX_MBA_BW;
-}
-
 static void mba_wrmsr_intel(struct msr_param *m)
 {
 	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(m->dom);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
 	unsigned int i;
 
-	/*  Write the delay values for mba. */
+	if (!m->res->membw.delay_linear) {
+		pr_warn_once("Non-linear bandwidth delay not supported\n");
+		return;
+	}
+
+	/* Program bandwidth percentage mapped to linear delay value. */
 	for (i = m->low; i < m->high; i++)
-		wrmsrq(hw_res->msr_base + i, delay_bw_map(hw_dom->ctrl_val[i], m->res));
+		wrmsrq(hw_res->msr_base + i, MAX_MBA_BW - hw_dom->ctrl_val[i]);
 }
 
 static void cat_wrmsr(struct msr_param *m)
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 10dfdca7f4bf..b63dc62690ca 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -253,7 +253,6 @@ enum membw_throttle_mode {
  * @throttle_mode:	Bandwidth throttling mode when threads request
  *			different memory bandwidths
  * @mba_sc:		True if MBA software controller(mba_sc) is enabled
- * @mb_map:		Mapping of memory B/W percentage to memory B/W delay
  */
 struct resctrl_membw {
 	u32				min_bw;
@@ -263,7 +262,6 @@ struct resctrl_membw {
 	bool				arch_needs_linear;
 	enum membw_throttle_mode	throttle_mode;
 	bool				mba_sc;
-	u32				*mb_map;
 };
 
 struct resctrl_schema;
-- 
2.55.0

