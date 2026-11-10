Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284359;
	b=2vuSt19CFwH4ZQpj+Ng1erV91zVFL5d5rWI11v7iUiRgwDxAF0FEIESgBKRuSWNHG7+G
	 G1RQI9gznVWWmtOimXLu8T7ORBOFZzADuANMw572qzIbj+z3pzhqTUCGkC+j+eoEeBtRe
	 f1VE4qMCO1VxC2KHQeC4Mzl0Vrt6FE/NgF0D5ygkzwR9wHof3nA2ydzN71+qdqRG9HMau
	 ekhNSldUIXJwnfAjHvA0miPHJIPOO1oBRDz9ItHSIs9dY2RPcIYfalUdNq3c2kN8Blf0c
	 BcGekOOvd25i1A7/50fzE9M6kGRaUtwZO6lhl886XkAs45Ssx3GyxRrjYZwJYyxJYoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284359;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yVhAqM6znopF8DCUrXTkTPQPEoRWRqaKrGCzI/y/X/I=;
	b=Lkc3QfvREowDw6RxXV9cvdMJZ0NnaUmPP3NVhLk3dV0YSjw6WKlNqd+WIJ3gS+MOXgwt
	 RYn2GnigcvFATJBtYKtOzJ1jOztb7TuGZ/O3vysqB1qFIVP4kuuqas1FmlobPQ1Vrm6vA
	 WZOzb53U+lLXldmCa5jCElN/EdQNxJT62m1Lcg8jpEMKTJmVJ7dqH4jyC+2j3Amci7CiI
	 jRkt6CDudCID76njZy3E8RUKBKONTzZ9WDu1NE//uflkoNAS4IwSH7YJmB6w2mgBprgnM
	 wbbAxGPsI0Rxxyjloof21Y/hVHa1VZXLKO7X4s+FvczAaweHPhYSdNAN/bx4innZJ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dZwro06L;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057D9606A334
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 057D9606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dZwro06L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284359; x=1825820359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JcvLWyniSyOFOOX7XlUH66SXY27TBGk1e1/SsTfDZCw=;
  b=dZwro06Lz8w3t1okh019mA0gm/1OoJug0mcel5lBmtsjDN0I0bsZfCW0
   v13Cs4MzwFOx9A6QBLUp5nMrpch5giPM5erkzBmVZ4/hDInBdPRidhZ/M
   UShBiNpjJe28AKawJ6MqJ2u57Fu1SwYkKvun9HlolIBcYXRxlch0dcAMS
   e3wqtiaCI+wmocyQsBtS5cqVTvNAFvXQ2g2Gsv19iXrOGmDDF6qddB6AQ
   BvPLM2YrEdYRc2S20u9qjQij0vA9FgjXHZEvoePa0V8QvTwj8h4NzLiZJ
   owLDaoO3nfwcdC7dEXq1cyOMROHozb4GqLBf9OnZmX9/F/MKevTiOaj4y
   g==;
X-CSE-ConnectionGUID: VOjhb6g/RNCU3brtb14lAw==
X-CSE-MsgGUID: ODyUL7ZSSNuwGhr+1yQhfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901310"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901310"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
X-CSE-ConnectionGUID: D7wP2FsWRtail10jcRH+rA==
X-CSE-MsgGUID: rOZcpoX/SVmASyJ/22+8ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856915"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com,
	ruanjinjie@huawei.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	tan.shaopeng@fujitsu.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 3/8] arm_mpam: resctrl: Rename ctrl_comp in mpam_resctrl_alloc_domain()
Date: Mon,  9 Nov 2026 20:19:03 -0800
Message-ID: <622cee43d7d1ef89f1d28ad7cfc948efa9cd618d.1794283825.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794283825.git.reinette.chatre@intel.com>
References: <cover.1794283825.git.reinette.chatre@intel.com>
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

mpam_resctrl_alloc_domain() looks up the component of the resource's
class that contains the CPU and fails the domain allocation if there is
none. The component is held in a local variable named ctrl_comp and, when
the resource supports allocation, it also backs the control domain.

The lookup and its check apply to every resource, including one that
supports only monitoring. For such a resource the component does not
back a control domain, so the name ctrl_comp is misleading. The name also
makes a comment in the same function ambiguous. The comment notes that
there may be no ctrl_comp for the L3, which is true of the control
domain's component but contradicts the local variable, which always
refers to a component once the lookup succeeds.

Rename the local variable to comp. Keep the ctrl_comp name for the
control domain's reference to its component because it only ever refers
to the component that backs the control domain. Leave the comment
unchanged since it now unambiguously refers to that component.

No functional change.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since RFC v2:
- Add Reviewed-by tags from Jinjie and Ben.
- Add Jinjie's Tested-by tag.
---
 drivers/resctrl/mpam_resctrl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index a75f653031fd..d0c7c741ce90 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1648,14 +1648,14 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	struct rdt_l3_mon_domain *mon_d;
 	struct rdt_ctrl_domain *ctrl_d;
 	struct mpam_class *class = res->class;
-	struct mpam_component *ctrl_comp;
+	struct mpam_component *comp;
 	struct rdt_resource *r = &res->resctrl_res;
 
 	lockdep_assert_held(&domain_list_lock);
 
-	ctrl_comp = find_component(class, cpu);
+	comp = find_component(class, cpu);
 	/* class has no component for this CPU */
-	if (WARN_ON_ONCE(!ctrl_comp))
+	if (WARN_ON_ONCE(!comp))
 		return ERR_PTR(-EINVAL);
 
 	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
@@ -1663,10 +1663,10 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		return ERR_PTR(-ENOMEM);
 
 	if (r->alloc_capable) {
-		dom->ctrl_comp = ctrl_comp;
+		dom->ctrl_comp = comp;
 
 		ctrl_d = &dom->resctrl_ctrl_dom;
-		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
+		mpam_resctrl_domain_hdr_init(cpu, comp, r->rid, &ctrl_d->hdr);
 		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
 		err = resctrl_online_ctrl_domain(r, ctrl_d);
 		if (err)
-- 
2.56.0

