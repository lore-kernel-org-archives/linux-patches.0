Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284363;
	b=1Cy4UD1CHf9rXKapSxHF3bNAFWiwCepOdMrVboD0jeGYDWlERdGOX+L/LLr55OYgzNzS
	 dWc3qZgZlEURi68k01apf5R2LQ5MaBJ8sdfngE3aTffWLigrSePwitlsaBsniiAFkGr4e
	 U65sk3nx2yez9YqjkVHAGgE6IuRfz/oHdXm3icN3FZhuLcp4d5bFxh+nUEmPf9R5g7V3d
	 IGz+LY7uoJRmBNLTE+bEww8UxwL/NWF1pEPfJERnqNdKh7InHx/eNYPnMnLpYT0p8/L8u
	 P62JFO5AkKuyh4Hc81xibxioSYsZsSXOVgvapQU697kCwcoi8g1N6NcQkR8LwdDevsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284363;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cRsKOafKqI8dLGqnlRQ4af7ukN3KKmKLy6whAXKDynM=;
	b=qJshY7yRrZgDDuslcoxRK7QX1GGPi7UQEsUsClQ5UBF417WHps3vFDT6wKrQt3DotNoo
	 juh/7MqkVMJxNpJrdo2Vfu0Q+32b+GAVtx6t4MyYYR92IznAklKKxZGgQRB7ejK3Jgmfm
	 tmWWQLu2hriwO2HYjNHZyaEkhuaD5KvoykBv2E54FCF8Zf8ZePtt0nrDADPgYdYL8b2L8
	 Cv2f8qLM2KqFtj892YMmCnZhoM9bc4m288O3Da3lK0Xyh028bNQAjpe5PF7bcK8R0qLhV
	 5lLbcMeIvYH5SxAz7Wi/DkYQAkSBkL5O8D4IFV3pJgvz6BNB3K07UBPvc1M+/+g6yuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gbYv9R3P;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A20560A2622
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A20560A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gbYv9R3P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284361; x=1825820361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BVep7Qz8JJqudKzCF6G/P+rgdoPynynQFiyMuZ5kOMU=;
  b=gbYv9R3PJb0qQvFThTp0azK8LEhxGtwh6+zXCLseqSKeW9NnjMOQ39I0
   uOYOS40Twf0tRQZvc4uwzyZu15aq3tVBlt24pEveb9wvj8DGIzBJ90TEF
   EOEF/kA53/DFU4ZYOWqYOle0Mc61n1wnVh+5fwDT3bZc6xUQo0e7Mtdxq
   9imyu384f3GzGGwm6C13ptNchmtfVo82tdWA5XD6RyvlK/rMMsc35nphO
   H9GMzOFNO3iJddd+40GHj5HUvdjMJVyqtuKFXvKB58NLPz38ktSnkWDdM
   MWfDUg+WVXa3nfOvQYmvWkn5fmVn4GzSw7QLew8hL3xiwi1LVNU91yhI7
   Q==;
X-CSE-ConnectionGUID: 1CIY3/rNTi2zZHZxI/2KGQ==
X-CSE-MsgGUID: nySFO6spTkyAB4yuX8sbbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901355"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901355"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
X-CSE-ConnectionGUID: Czvc6wcTSdOl6TcV+kkw/A==
X-CSE-MsgGUID: ygcaiT8hS7mFc7xI3EOeDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856929"
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
Subject: [PATCH v3 8/8] arm_mpam: resctrl: Rename struct mpam_resctrl_dom to mpam_resctrl_ctrl_dom
Date: Mon,  9 Nov 2026 20:19:08 -0800
Message-ID: <7a44ffd1fc83e74192fa8363d560c1f90e843da1.1794283825.git.reinette.chatre@intel.com>
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

struct mpam_resctrl_dom holds the control domain of a resource, while
its monitoring domain is held by struct mpam_resctrl_mon_dom. Unlike the
name of the monitoring structure, the name struct mpam_resctrl_dom does
not say which kind of domain the structure holds.

Rename it to struct mpam_resctrl_ctrl_dom to match its monitoring
counterpart.

No functional change.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
Changes since RFC v2:
- Add Jinjie's Reviewed-by tag.
- Add Jinjie's Tested-by tag.
---
 drivers/resctrl/mpam_internal.h |  2 +-
 drivers/resctrl/mpam_resctrl.c  | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 1df439ecb055..dc304e4e0dc0 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -432,7 +432,7 @@ struct mpam_msc_ris {
 	struct mpam_garbage	garbage;
 };
 
-struct mpam_resctrl_dom {
+struct mpam_resctrl_ctrl_dom {
 	struct mpam_component		*ctrl_comp;
 	struct rdt_ctrl_domain		resctrl_ctrl_dom;
 };
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 263bbbc27dac..8894d0d19468 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1400,7 +1400,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	struct mpam_config *cfg;
 	struct mpam_props *cprops;
 	struct mpam_resctrl_res *res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 	enum mpam_device_features configured_by;
 
 	lockdep_assert_cpus_held();
@@ -1409,7 +1409,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 		return resctrl_get_default_ctrl(r);
 
 	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
-	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
+	dom = container_of(d, struct mpam_resctrl_ctrl_dom, resctrl_ctrl_dom);
 	cprops = &res->class->props;
 
 	/*
@@ -1460,7 +1460,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	struct mpam_config cfg;
 	struct mpam_props *cprops;
 	struct mpam_resctrl_res *res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 
 	lockdep_assert_cpus_held();
 	lockdep_assert_irqs_enabled();
@@ -1473,7 +1473,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	 * resctrl_arch_update_domains() relies on this.
 	 */
 	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
-	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
+	dom = container_of(d, struct mpam_resctrl_ctrl_dom, resctrl_ctrl_dom);
 	cprops = &res->class->props;
 
 	if (mpam_resctrl_hide_cdp(r->rid))
@@ -1643,7 +1643,7 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
 static int mpam_resctrl_setup_ctrl_domain(unsigned int cpu,
 					  struct rdt_resource *r,
 					  struct mpam_component *comp,
-					  struct mpam_resctrl_dom *dom)
+					  struct mpam_resctrl_ctrl_dom *dom)
 {
 	struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
 	int err;
@@ -1741,10 +1741,10 @@ static struct mpam_resctrl_mon_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu
 	return NULL;
 }
 
-static struct mpam_resctrl_dom *
+static struct mpam_resctrl_ctrl_dom *
 mpam_resctrl_get_ctrl_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 {
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 	struct rdt_resource *r = &res->resctrl_res;
 
 	lockdep_assert_cpus_held();
@@ -1761,7 +1761,7 @@ static void mpam_resctrl_add_cpu_ctrl_domain(unsigned int cpu,
 					     struct mpam_resctrl_res *res)
 {
 	struct rdt_resource *r = &res->resctrl_res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 	struct mpam_component *comp;
 
 	lockdep_assert_held(&domain_list_lock);
@@ -1811,7 +1811,7 @@ static void mpam_resctrl_remove_cpu_ctrl_domain(unsigned int cpu,
 						struct mpam_resctrl_res *res)
 {
 	struct rdt_resource *r = &res->resctrl_res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 
 	lockdep_assert_held(&domain_list_lock);
 
-- 
2.56.0

