Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284361;
	b=Yaz7gEgcIxSOGkfFQ4wAzr2T4RChfCdQXK2YPwVfNI7ahjyK/c6WdK09/Ho4O3NqTXri
	 35zzltU4MPPsCUIXGJHHiCwWKXEohZ75xf7QyRos5shpKG42CSTFyK/sE+JD1xYBZy7GP
	 xF2WL1lHoRr7zpMVGxsTSTeV1TexJm+zVjgSHOFUiqY1lM+tbrdGytS+ep72DLOER0Kjx
	 9IbY9cEVh2S7UyQzKVN2I+/qm6AIkr5S06fK5vRAlS3U7rY8GZkcQbZsQ2soJn+b01VOg
	 Hi9ceWM4+RRKVWTqlc/bOvYbdHWnclqtKwTWdwTj2+W2uv+BDujl5tfb/br3TgSFkzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284361;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gG0BIsp3F32RveUGW6ul6/4p/lJVSGAIllfHJfCYFVQ=;
	b=PsOcOFNvX3HFSHoohSHj8yBLAKXc7/snVWUUdI4ygG08xx1jfYW12wAvnPy/jJDo64Cu
	 kW7gZesK4LgvKTmpXDYnAmiO1IkhiAPZ425hK/r2q26exdjra8NIuv3COCfMAZ1pHr8pY
	 fmCdftgB+sf2N+SsEaG9+sy5NskSYdYzmo8OF5b2BADByg02B0hkUX3MMyVwAFYBcoWuH
	 BAoG79WiIB8j7G/CRv2cmCd9SO3fThzbdQP6taqWfqs0yLIe0LrMuBMFjE4U/TSAbwML1
	 pGs8R8NeNYMJLsAPYOUbcSHIWN6vUakZpZj0mTHevkKQTmZ/AghX3TfkalB1Q7dDjbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iZLBG6C2;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF0460A2607
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DF0460A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iZLBG6C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284358; x=1825820358;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OtdIqlJCzePoc/YWZ7W8qi5SoWYQ8adAJ9eFkSM+jz0=;
  b=iZLBG6C25sfC+dbKWv3xZJFXxsMsRxzPTxEbptKecap9KFlWpUNfa9AV
   ZP5CPrtXLAdI6IvVFo8EFZCuxTeJ8omU0RiHW4fNXjorV1nnsPimbZXme
   sRcsfLlN6mkVWuwLrV/dwH1RABkNqhsdFSrDpudjpv4e9IhY0BXY5NfPT
   /r2Q3Q1o7GlSdwU3lIxOirV1VeHh7eeVCHrtiUJLhMfAf5p+U+WE63Zgl
   y4/yX69f6xUcqAWXfWzQRJCS9ShthgJy+pvgGbvfmuw1GRY6a9MK0vhs7
   v7Q2PDTsMrcI4+atnCJ/5gun2VHM+IZhk5BvU2rgQbRU+5dZyP5QsBh8W
   A==;
X-CSE-ConnectionGUID: /IbMWo9sSrC7hy5jYGa9OA==
X-CSE-MsgGUID: NmI6T8UjSieG9763BPpccQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901301"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901301"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
X-CSE-ConnectionGUID: bSY4sNg1QIyG4blghiHrWg==
X-CSE-MsgGUID: jk+useGmQSm7G6c8Wi35wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856912"
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
Subject: [PATCH v3 2/8] arm_mpam: resctrl: Use find_component() when allocating a domain
Date: Mon,  9 Nov 2026 20:19:02 -0800
Message-ID: <c79ae06f66ab31db3425c537e765813711f3ceaa.1794283825.git.reinette.chatre@intel.com>
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

mpam_resctrl_alloc_domain() starts by checking that the resource's
class has a component whose CPU affinity includes the CPU, and fails the
domain allocation otherwise. When the resource supports allocation, that
component also backs the control domain. The check uses an open-coded
walk of the class's component list, while the same function uses
find_component() to find the component backing each monitoring event.

The open-coded walk duplicates find_component(). It also holds the SRCU
read lock until mpam_resctrl_alloc_domain() returns. However, the SRCU
read lock is only needed while walking the component list, and
find_component() holds it for that walk.

Replace the open-coded walk with find_component().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
Changes since RFC v2:
- Add Jinjie's Reviewed-by tag.
- Add Jinjie's Tested-by tag.
- Shorten changelog. (Ben)
---
 drivers/resctrl/mpam_resctrl.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 1b1e724ae040..a75f653031fd 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1648,21 +1648,12 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	struct rdt_l3_mon_domain *mon_d;
 	struct rdt_ctrl_domain *ctrl_d;
 	struct mpam_class *class = res->class;
-	struct mpam_component *comp_iter, *ctrl_comp;
+	struct mpam_component *ctrl_comp;
 	struct rdt_resource *r = &res->resctrl_res;
 
 	lockdep_assert_held(&domain_list_lock);
 
-	ctrl_comp = NULL;
-	guard(srcu)(&mpam_srcu);
-	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
-				 srcu_read_lock_held(&mpam_srcu)) {
-		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
-			ctrl_comp = comp_iter;
-			break;
-		}
-	}
-
+	ctrl_comp = find_component(class, cpu);
 	/* class has no component for this CPU */
 	if (WARN_ON_ONCE(!ctrl_comp))
 		return ERR_PTR(-EINVAL);
-- 
2.56.0

