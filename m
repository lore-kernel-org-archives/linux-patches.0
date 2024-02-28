Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5CA146015
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149041; cv=none; b=b0bW1yyDYOVGjF/gIajmXheQPHO31oJwgV+kuZK7mYgAdHgz/f/cgACg23B15SdsvHF/y0VY/0ovN0z6w9RRAIM6hkMem0jzmNQuyg27gAKJP9ZoHBA4basxm4MrxKb90VZtSfsRj0XwlH14wGL9enk7uMRtSnWgXxE+wmER3Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149041; c=relaxed/simple;
	bh=IpW0X4RYxdNJ8NDI269lPfQbd/KpxHNtVps3C8A59AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ao/5NsN96fWVzjL3I0LI97VUkG1fAgLsq2Kdz1XdY6ZPRD1IyMoe7s5jsfUKkHah4D623OMKHkewErx+qXacDfiCxWGWTUPznfqp6qs1rf2e8l8mcPIbk0/HcxUfFrKhEPkVWU+MLKsQShBTmdV40Y9Kfi/Q8XvO/7fhsXuhtmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IUKaFtqB; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IUKaFtqB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709149040; x=1740685040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IpW0X4RYxdNJ8NDI269lPfQbd/KpxHNtVps3C8A59AA=;
  b=IUKaFtqBNBVzR0cFDzfMncWvDq01knk8PiCehbwUfVuGdUX/mKtvoQVj
   nLA7yKBOnAcZDo1FLW54Mnm7weHW+s/XYjPInrBXNtSU+wiwHJRQPTNJx
   4mRpZRXzFFu1/ppCFH2uSf2v/KvD7bQQ3f3O7kUYRMpVnI9e91wHwPflt
   Vh5+wdeIjDTtlXz3tkj9NWVSxnVzCqxXhecSVg5ZhXmO+36whGBqPJ1qx
   XxAyRUcSATXp8s2Ls6s3rC3p2FYPExgm7DC6EZN9sJAl7s05hHkJAI3Qz
   FD8I/6gmQooEkGX0gmKGbl+Txb1oFfbcZ8/4gPqOGns2uH3Lfpdl1jAfL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3495471"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="3495471"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 11:37:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="7485372"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 11:37:17 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Drew Fustini <dfustini@baylibre.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 2/2] x86/resctrl: Simplify call convention for MSR update functions
Date: Wed, 28 Feb 2024 11:36:54 -0800
Message-ID: <20240228193717.8170-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240228112952.8090-tony.luck@intel.com>
References: <20240228112215.8044-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The per-resource MSR update functions cat_wrmsr(), mba_wrmsr_intel(),
and mba_wrmsr_amd() all take three arguments:

  (struct rdt_domain *d, struct msr_param *m, struct rdt_resource *r)

struct msr_param contains pointers to both struct rdt_resource and struct
rdt_domain, thus only struct msr_param is necessary.

Pass struct msr_param as a single parameter. Clean up formatting and
fix some fir tree declaration ordering.

No functional change.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    |  3 +-
 arch/x86/kernel/cpu/resctrl/core.c        | 40 +++++++++--------------
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  2 +-
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index bc999471f072..8f40fb35db78 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -444,8 +444,7 @@ struct rdt_hw_resource {
 	struct rdt_resource	r_resctrl;
 	u32			num_closid;
 	unsigned int		msr_base;
-	void (*msr_update)	(struct rdt_domain *d, struct msr_param *m,
-				 struct rdt_resource *r);
+	void			(*msr_update)(struct msr_param *m);
 	unsigned int		mon_scale;
 	unsigned int		mbm_width;
 	unsigned int		mbm_cfg_mask;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index acf52aa185e0..7751eea19fd2 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -56,14 +56,9 @@ int max_name_width, max_data_width;
  */
 bool rdt_alloc_capable;
 
-static void
-mba_wrmsr_intel(struct rdt_domain *d, struct msr_param *m,
-		struct rdt_resource *r);
-static void
-cat_wrmsr(struct rdt_domain *d, struct msr_param *m, struct rdt_resource *r);
-static void
-mba_wrmsr_amd(struct rdt_domain *d, struct msr_param *m,
-	      struct rdt_resource *r);
+static void mba_wrmsr_intel(struct msr_param *m);
+static void cat_wrmsr(struct msr_param *m);
+static void mba_wrmsr_amd(struct msr_param *m);
 
 #define domain_init(id) LIST_HEAD_INIT(rdt_resources_all[id].r_resctrl.domains)
 
@@ -309,12 +304,11 @@ static void rdt_get_cdp_l2_config(void)
 	rdt_get_cdp_config(RDT_RESOURCE_L2);
 }
 
-static void
-mba_wrmsr_amd(struct rdt_domain *d, struct msr_param *m, struct rdt_resource *r)
+static void mba_wrmsr_amd(struct msr_param *m)
 {
+	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
+	struct rdt_hw_domain *hw_dom = resctrl_to_arch_dom(m->dom);
 	unsigned int i;
-	struct rdt_hw_domain *hw_dom = resctrl_to_arch_dom(d);
-	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 
 	for (i = m->low; i < m->high; i++)
 		wrmsrl(hw_res->msr_base + i, hw_dom->ctrl_val[i]);
@@ -334,25 +328,22 @@ static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
 	return r->default_ctrl;
 }
 
-static void
-mba_wrmsr_intel(struct rdt_domain *d, struct msr_param *m,
-		struct rdt_resource *r)
+static void mba_wrmsr_intel(struct msr_param *m)
 {
+	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
+	struct rdt_hw_domain *hw_dom = resctrl_to_arch_dom(m->dom);
 	unsigned int i;
-	struct rdt_hw_domain *hw_dom = resctrl_to_arch_dom(d);
-	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 
 	/*  Write the delay values for mba. */
 	for (i = m->low; i < m->high; i++)
-		wrmsrl(hw_res->msr_base + i, delay_bw_map(hw_dom->ctrl_val[i], r));
+		wrmsrl(hw_res->msr_base + i, delay_bw_map(hw_dom->ctrl_val[i], m->res));
 }
 
-static void
-cat_wrmsr(struct rdt_domain *d, struct msr_param *m, struct rdt_resource *r)
+static void cat_wrmsr(struct msr_param *m)
 {
+	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
+	struct rdt_hw_domain *hw_dom = resctrl_to_arch_dom(m->dom);
 	unsigned int i;
-	struct rdt_hw_domain *hw_dom = resctrl_to_arch_dom(d);
-	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 
 	for (i = m->low; i < m->high; i++)
 		wrmsrl(hw_res->msr_base + i, hw_dom->ctrl_val[i]);
@@ -384,7 +375,7 @@ void rdt_ctrl_update(void *arg)
 	struct msr_param *m = arg;
 
 	hw_res = resctrl_to_arch_res(m->res);
-	hw_res->msr_update(m->dom, m, m->res);
+	hw_res->msr_update(m);
 }
 
 /*
@@ -457,10 +448,11 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_domain *d)
 	hw_dom->ctrl_val = dc;
 	setup_default_ctrlval(r, dc);
 
+	m.res = r;
 	m.dom = d;
 	m.low = 0;
 	m.high = hw_res->num_closid;
-	hw_res->msr_update(d, &m, r);
+	hw_res->msr_update(&m);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index a3a0fd80daa8..7471f6b747b6 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -289,7 +289,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_domain *d,
 	msr_param.dom = d;
 	msr_param.low = idx;
 	msr_param.high = idx + 1;
-	hw_res->msr_update(d, &msr_param, r);
+	hw_res->msr_update(&msr_param);
 
 	return 0;
 }
-- 
2.43.0

