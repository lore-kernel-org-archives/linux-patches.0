Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447682;
	b=t7tnc6PMgRtYnSTEaDWOcRZk2XRMAYurH29PxF+nuGA+lGCQrC2K4Cg7ZdDqf3YvUGwN
	 0uqM3yqRfXISXPeDSHxfgiLJggljqO/E+Mo6Mqm5TW5raOM+Rv4VDQd0YtsPht277uyPY
	 Tk+qvWmPCPibmAY/73O0dmK42Dw3XsSn9yG3ZoSDFpJbeCEqubiMh/ORYd3xU5X96/rTV
	 hTBo17eKrQyZS2bwXZ4K7k6KZMfC1M0yQfOlW9xoo3TXJ0/edf8He7qlYTiNEfiZXKhTa
	 9N3Jx+MUftnifYzcWFclFGF2LNsDLm44prtXzHRd/jExZlFAjlEgGmmnnafaSSKpdvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447682;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LmvPvy7wScLRYtqMkY4+Tm3OePeY/cW3tPHkEV2hUgo=;
	b=LSuJfjdwWK0YPTrAmQRouLOWrC4AK1LsyqdEzHBCfHuZ/pbPQjV+HIzsEY8nedXUztVH
	 ojGdL/IzC0k/IvDiZ0L2MNy0zqHLcbN+ga6lHczHz0kPcLhOh1yFB5SKkqunFUwQJTEJV
	 Uyh8FQqssaZNFXV0RMbJJsTF+yWXihzfRE4jRjJq1CK1SzIzcxQJPU1Ix0Xyi5pahAE/v
	 loIiXaOKa/507nq51NZyn+7m3DxHcbmZfuQX7wkgRWMx82UktD+KA0MZtqrIvr9sfb6gJ
	 GLhhS9rjlkw1aByPsE39UR/hVIOKTVF4YRzh6NZl5F9gE2jf0kCw+YXzAmukQgHXfnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YttKK3Bj;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B8606A334
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:08:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C52B8606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YttKK3Bj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447681; x=1823983681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5RfTFi+N71Ke05IbYs3L+ISDh0WG5qWpJ+Iq5wDoW0g=;
  b=YttKK3BjfDgko9V1oKbz7Rd+loqzJP29rKN5icDejM8e8VDILYtBCp8n
   fdsSR+yyKUSpQmO824XUiQrNFcHTI1PxjXWG0rDWbtPDRDxBYi/6wSN8V
   N35cKGFyEsp21uv57u5np82WcanBCMwlnKumfHklA5mXyiQV6taXZVPhq
   dfb7rsou+sJafWlcSVxM3RZLJbObw4ajUVTFUg7m8soFmi3CearaoDYJe
   q3G3GJQdwK6IlMJ53vd8qUdi0H66XoG5qqGNMuJlPnBSXqmiBZFf8uuzX
   RrIGeNhUAiVaFA8rE/sh1WVTypT89Z2V/gO5BvDHUF0jN7Dlahi/36XaE
   A==;
X-CSE-ConnectionGUID: zo7uoU8DSyuLjkXd183XjQ==
X-CSE-MsgGUID: w9XZuaRaQz+sHwvPPfDHEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144211"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144211"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:59 -0700
X-CSE-ConnectionGUID: fTzmgTSwQzStEjjpFfExRA==
X-CSE-MsgGUID: R4UYyVRER3yORRGpqCs4PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708343"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:59 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH v2 06/10] arm_mpam: resctrl: Rename struct mpam_resctrl_dom to mpam_resctrl_ctrl_dom
Date: Mon, 19 Oct 2026 15:07:40 -0700
Message-ID: <fe38eaea025896ace1baa536fa8e73b409f22b9a.1792443633.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1792443633.git.reinette.chatre@intel.com>
References: <cover.1792443633.git.reinette.chatre@intel.com>
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
index ce5519635c51..022920be1862 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1375,7 +1375,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	struct mpam_config *cfg;
 	struct mpam_props *cprops;
 	struct mpam_resctrl_res *res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 	enum mpam_device_features configured_by;
 
 	lockdep_assert_cpus_held();
@@ -1384,7 +1384,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 		return resctrl_get_default_ctrl(r);
 
 	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
-	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
+	dom = container_of(d, struct mpam_resctrl_ctrl_dom, resctrl_ctrl_dom);
 	cprops = &res->class->props;
 
 	/*
@@ -1435,7 +1435,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	struct mpam_config cfg;
 	struct mpam_props *cprops;
 	struct mpam_resctrl_res *res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 
 	lockdep_assert_cpus_held();
 	lockdep_assert_irqs_enabled();
@@ -1448,7 +1448,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 	 * resctrl_arch_update_domains() relies on this.
 	 */
 	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
-	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
+	dom = container_of(d, struct mpam_resctrl_ctrl_dom, resctrl_ctrl_dom);
 	cprops = &res->class->props;
 
 	if (mpam_resctrl_hide_cdp(r->rid))
@@ -1618,7 +1618,7 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
 static int mpam_resctrl_setup_ctrl_domain(unsigned int cpu,
 					  struct rdt_resource *r,
 					  struct mpam_component *comp,
-					  struct mpam_resctrl_dom *dom)
+					  struct mpam_resctrl_ctrl_dom *dom)
 {
 	struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
 	int err;
@@ -1710,10 +1710,10 @@ static struct mpam_resctrl_mon_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu
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
@@ -1730,7 +1730,7 @@ static void mpam_resctrl_add_cpu_ctrl_domain(unsigned int cpu,
 					     struct mpam_resctrl_res *res)
 {
 	struct rdt_resource *r = &res->resctrl_res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 	struct mpam_component *comp;
 
 	lockdep_assert_held(&domain_list_lock);
@@ -1780,7 +1780,7 @@ static void mpam_resctrl_remove_cpu_ctrl_domain(unsigned int cpu,
 						struct mpam_resctrl_res *res)
 {
 	struct rdt_resource *r = &res->resctrl_res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 
 	lockdep_assert_held(&domain_list_lock);
 
-- 
2.55.0

