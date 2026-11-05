Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793837632;
	b=uU52Dh4SRkyp3p/FOi+A0OrHLNlwH0v0S47QMviztzQusSBKMnn3BwWuWcmidM51rwoh
	 10VwjP/CvDG7ld0M4H079dq+tYlwoKBiUvOm68XqXrp9PhpscFB04hpf6ScNdv+C1444i
	 p/tH6AQYUvSJzkfEa3UPMdY43Y8u6UqVFIfv/45FosNSjTwIT8Z2qcKmcxl/Jv47/JN22
	 jKJIsvOIy3WDv5v7QOFTRvE/m++6WDFXoPI376sP5dD2nGKZVBwEaXIAoMbienHvYzC9A
	 lgQIG9xSks3QEhA9LhlOvXCy/tWZlwpBuMAcWz0DPyMOEjziLBy5oxTh+OqTXtmtV0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793837632;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=90PPqsr+k4+a2BpRdh0xLWx3tsnBD2y9imQzmY72Gcs=;
	b=5MXTPnNen3HF12TqKJXZqLRFIZ96wsSSEo/Ugrj7igBreFJ9oE6XnPX+lJVz/tPmsvlD
	 evalmNCs+IxepeRw4ztWsUijOLWI6tmFlR7DnIEzy8kp4bWTGUtwsDvutHZtMKnB+mKba
	 N4Jj77ojlsKNHsaQfFshKDKvovcfjRUKoZ/OUGIQwPE+iBYhFDT8VR5c+Q+qn7XP1rI+k
	 KprAv0nR9lH2RMJIYw6c0/OAP23nCiix+r5LNsNt9hrdzWL5h/Ud7O2JBU8gPylAQIMJf
	 bV5ffEUNQXoPn+9ryrabVufkwCQ7d2mbj8IfREDzB75lpuV7Gwc9NP+U7XdIKST7V8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cUsJCK7H;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29269606A33C
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 00:13:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29269606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cUsJCK7H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793837631; x=1825373631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rNuxYeqweMEVasKWpR31fBLqGNsKb42fVyw4F2qMYMo=;
  b=cUsJCK7HL5ceNV+rXZav+rfWBDMIcCRUgZVJdxq3bZm8Q08WrSLf3KO7
   TZ9yxiLMei6QMO0KXf+GPeKqWvvNgqQm/zuy/rREW+ZoxDvY6Mrw5XNKt
   cKeXotrxrbsi2D1VE2s4sMcIrAVq5Y/8ZYm8t5+S46uQwgHR62PcMkCj3
   UOspkIxALBuzw8HwTBs/sY8H657wujmLCVrbKT0RVsyaXk3BYcp/PnSqi
   KA9IVdvUgZe/mbA6uZi1KT/UchSKFXC2oTkB3FdY/kE+WbnDgDswBnSXv
   uq6Uifqa10sXjGt2ql4d9MMbM3xoW/iz/EON1SHCLQ7U2SrQWwC16hGrq
   A==;
X-CSE-ConnectionGUID: YGXC/DTmRMqftAmEycRIEg==
X-CSE-MsgGUID: W/dzzbBGS2i0oHIfUQ5HSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2512777"
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="2512777"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:13:49 -0800
X-CSE-ConnectionGUID: ADjdwLfNQX2f9GymwlZVcQ==
X-CSE-MsgGUID: 2mbABhoIQOuiWIfZ2C4rSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="7168850"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:13:48 -0800
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
Subject: [PATCH v3 4/5] fs/resctrl: Drop unnecessary is_mba_linear() helper
Date: Wed,  4 Nov 2026 16:13:32 -0800
Message-ID: <493995284247554d05dc3813722168fb053d5d10.1793834224.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793834224.git.reinette.chatre@intel.com>
References: <cover.1793834224.git.reinette.chatre@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
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
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes from RFC v1:
- RFC v1 made bandwidth delay a resource property. That change was dropped
  and this cleanup is all that remained.

Changes since v1:
- Add Chenyu and Ben's Reviewed-by tags.
- Clarify "resource is linear" vs. "resource's delay values are linear".

Changes since v2:
- Add Jinjie and Tony's Reviewed-by tags.
---
 fs/resctrl/rdtgroup.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 57ab090072c2..443b41a4d467 100644
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
2.56.0

