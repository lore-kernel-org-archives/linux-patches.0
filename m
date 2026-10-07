Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AB838E126
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 21:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407221; cv=none; b=IkCXroeeegz/bpK7MSbdDMsb7CLCY2p90FRcloIVvPeQ2H0t8m4yAI5g6Yf4phT8YuCBC1IzgxIeDgeVlftvr1BnNLZ0iQs7y+OnVl0270gOWjnTAgio/08LDxMWyuvLrqejBTm65rNv/6U4NhEANBQ2R84Zhs28qCGpI8bCIV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407221; c=relaxed/simple;
	bh=6p2FfMDEwU0rhmwfCD+gHz05+um9TEuyv/mw9S/rHCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7JuOgGPfO6mu2NF8Npu4bZgo/0BIdJOD/Txw5glsp4cu6f09cu2f8nwFmkSZsTPuXkdNCF5J618A5S+bhvCn3dOy07dy2hDCx3B71L+dk9LSOtwB2TNzl8O/EvgXMFiQLmIVs5qk6zr1LnAVDJmymFfHKlE/bgZ3iTTMgQJu9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q0ox8yxF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0ox8yxF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791407221; x=1822943221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6p2FfMDEwU0rhmwfCD+gHz05+um9TEuyv/mw9S/rHCE=;
  b=Q0ox8yxFrXt2O/a+eRr7bSSdlHdXyydl4K+IqRFfXzG/h3fbj407iD7O
   NpTRsRIbljnWLPkv+QwNGiVZBw3vY1W/vFEfS2ZzWcfZKfl9Sqh7hUiwz
   Hv6a9Sv/rlF15ZRnL6Pbeg0gNUg0VFEieu180+iZ12Ur0LCW3U+9GmoBH
   Zz1LYkfHVy+LN5mBoL1gfpKuviGHAV45Z3WUnOxB8HB4kWSToxRIw1Xwv
   4Fpsei+1ErS79a3JUCeY/Rn7r1lIHRZKxLMab2F8AciL1Ohd87etcoDYn
   PD7xFCYQ/4x7D+Qa4w2Q+KfidLF5m51dAeJ/xcco/j69HV8uMmaoe9grg
   w==;
X-CSE-ConnectionGUID: Yy79OZzdQPiLnJjpt2wq7Q==
X-CSE-MsgGUID: W8i75aYfS1qdPMdLJG1Dbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="289420"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="289420"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:58 -0700
X-CSE-ConnectionGUID: JlFpePC4TXiR8WJ39tl6rQ==
X-CSE-MsgGUID: vLVTt5x7SgicntcdNH0Uuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="282359682"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:56 -0700
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
Subject: [PATCH v2 4/5] fs/resctrl: Drop unnecessary is_mba_linear() helper
Date: Wed,  7 Oct 2026 14:06:46 -0700
Message-ID: <816855328d87740b2cb720215d222702abba4b0f.1791406459.git.reinette.chatre@intel.com>
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

is_mba_linear() assumes it operates on the MBA resource and returns whether
the resource's delay values are linear. There is only one caller that
separately makes the same assumption.

Avoid duplicating the resource assumptions and let the only caller access
the needed property directly.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes from RFC v1:
- RFC v1 made bandwidth delay a resource property. That change was dropped
  and this cleanup is all that remained.

Changes since v1:
- Add Chenyu and Ben's Reviewed-by tags.
- Clarify "resource is linear" vs. "resource's delay values are linear".
---
 fs/resctrl/rdtgroup.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 68be9b903ac6..821c6e2b10f4 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2577,11 +2577,6 @@ mongroup_create_dir(struct kernfs_node *parent_kn, struct rdtgroup *prgrp,
 	return ret;
 }
 
-static inline bool is_mba_linear(void)
-{
-	return resctrl_arch_get_resource(RDT_RESOURCE_MBA)->membw.delay_linear;
-}
-
 static int mba_sc_domain_allocate(struct rdt_resource *r, struct rdt_ctrl_domain *d)
 {
 	u32 num_closid = resctrl_arch_get_num_closid(r);
@@ -2621,7 +2616,7 @@ static bool supports_mba_mbps(void)
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_MBA);
 
 	return (resctrl_is_mbm_enabled() &&
-		r->alloc_capable && is_mba_linear() &&
+		r->alloc_capable && r->membw.delay_linear &&
 		r->ctrl_scope == rmbm->mon_scope &&
 		!rmbm->mon.mbm_cntr_assignable);
 }
-- 
2.55.0

