Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C1D38C2D0
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 21:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407219; cv=none; b=G/fgxXpcPS4Ml+qkokiqvMMRpxI7kRhBU7aHCBGvfOpBvLWijgFufT8P3wtL6MfaslyCri/nQiBodgvywi3CFGdOvaYDpZedOcvxJ019wxTTvjhWbM1FkDTbPFb2gQEVbNuLc1qz+wPfZkAIvm5EEYQ5rLSXF0EuvQcv/Xf1WKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407219; c=relaxed/simple;
	bh=3/WBJTTo/84OH/YkYIlDG9G3MWJ0lnBALIq07U9D3lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THPynsAdp52Oe9SpQeggqVSAURojoVomm9z+NFdUT3W5xREtpX164QnmoX4pVbxFqyDx/oTy1dvyyy23Cp0ONv16aYprmznlvfiQPiYPKel1aAHg648FrzLl8XJTiuy/haR/cOiQqataTKthg1kYAvfltmJ4DlnrMQ35C1PTEIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iz7o+t+V; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iz7o+t+V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791407218; x=1822943218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3/WBJTTo/84OH/YkYIlDG9G3MWJ0lnBALIq07U9D3lQ=;
  b=iz7o+t+Vf22/uTtZu7iew3FKguk1yhrPZKqkz7znoRe5EPjc7TrdIpTU
   ZmRb7JndBpcOIJcXZyp0HCzSI+/uEFg+Ud9ijeKDDLmbK/+dm+Zi4VmhY
   lTpz29LjdVW35L01GgIPRQHMu0DDHEK9vvCRs+Njx9RKTyw4T1Ihvhe+/
   6AEyHM8KLAJ4vutYnLixsuVztrW0WlJrAiqm430NwxCojdaQjHIOcu8l2
   Okx8WwmpFM0ya0XdkEmXLpGkcHkeRBa4TxxgToycvUJxGKIP/o75uAbm6
   8hgSxjVVCKQ3Fvrr0Gwt01Syq9Z6qKmVlmlrG2AQSEBD1C7gbm1eUxPmz
   Q==;
X-CSE-ConnectionGUID: Zz/WMBZUQTyMrpydpO/+yw==
X-CSE-MsgGUID: E24KMeYHRZyjnUsQc6L+gQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="289389"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="289389"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:57 -0700
X-CSE-ConnectionGUID: lHvg2K2UQpCQvFQ0+zXETw==
X-CSE-MsgGUID: Q8udNuNdSYCfkvkVCs4UwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="282359615"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:55 -0700
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
Subject: [PATCH v2 1/5] x86,fs/resctrl: Remove unused non-linear bandwidth delay mapping
Date: Wed,  7 Oct 2026 14:06:43 -0700
Message-ID: <103c954ead8905b3582b6ade76e2082dffb01fc6.1791406459.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791406459.git.reinette.chatre@intel.com>
References: <cover.1791406459.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel MBA throttles memory bandwidth with delay values, while resctrl
exposes memory bandwidth to user space as a percentage. When delay values
are linear there is a direct mapping between the two. Support for
non-linear delay values would need a pre-calibrated table mapping
percentages to delay values.

Commit

  05b93417ce5b ("x86/intel_rdt/mba: Add primary support for Memory Bandwidth Allocation (MBA)")

added a placeholder for such a table to the resctrl_membw structure, but
the table was never populated and never read. rdt_get_mb_table(), which
would provide it, always fails. As a result, an Intel MBA resource with
non-linear delay values is never marked as capable of allocation, and its
control values are never written to hardware.

Remove the unused mapping table and fold the linear percentage-to-delay
conversion into the function that writes the control values to hardware.

Keep the check that delay values are linear as a defensive measure in
preparation for supporting multiple controls, which turns the memory
bandwidth control into a generic scalar control that indicates whether it
requires linear values.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
---
Changes since RFC v1:
- Also drop separate delay_bw_map() and instead integrate the only
  mapping to when control value is written.

Changes since RFC v2:
- Rework changelog.

Changes since v1:
- Rewrite changelog, fix subject prefix.
- Match error message about linear support with similar message during
  enumeration added in next patch.
- Add Chenyu's Reviewed-by tag
---
 arch/x86/kernel/cpu/resctrl/core.c | 23 +++++++----------------
 include/linux/resctrl.h            |  2 --
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 55214d6fdc49..f9677e52790e 100644
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
+		pr_warn_once("Non-linear MBA delay values not supported\n");
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

