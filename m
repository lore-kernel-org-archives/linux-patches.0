Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533A830CDBA
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830646; cv=none; b=YIj0g7oYzrpKz2zRPoIxYZMXjyxeUCaPRD0sJdPm9xKQYPDgmmXaxPJQ+OB3TfMqbsAuYXze6anW6myHm5IhNFCM6EGuvesHABMrZtDnnX3Z6nU/KDufjOALG1V044qLFENbSzqUcW0aNWLXu8bDo+U/HjWVavIx4Uh9UnfeGfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830646; c=relaxed/simple;
	bh=t2a7NQveQZuHMPbd6nZpCNV7ek2x4qLHPLpr7+DlI2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lki7cNycl5K2oXEDShdp1wx4wTnzOWhcoViEbC1lXCAjXk+YCMFv9nc7vgwhXl2TjXWIZzmPqXJzRY8X2MAho3ds3EaQRilKCSvCLJ199cWAbzY/z9rkD/uLKIypZr4vgA3byNtnzIWiIHqjTw9mHcoozGTxR0CfLVVzRZD/aDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LIiLtdYC; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LIiLtdYC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830646; x=1790366646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t2a7NQveQZuHMPbd6nZpCNV7ek2x4qLHPLpr7+DlI2Q=;
  b=LIiLtdYCQ2N3wtxdehNMY08H0EfbKtHd6ntMv+Evt/WmtaCqdx6rJuoc
   h5Zj24fxHZDMJCXNKt2MiebsxlGTN2h3wuqsczuOlCWo9JNsaVjkMdDJR
   l2jlsfnk6uhrMiEXSfI7nMeZuorJwHXaWOgeRgE6D5lRFMVuxuG4FOFbz
   8Ll/6bBQRayv09O/k8TU+PDy7/I9Qk4C/+0x5JDmr+rCMm+eovkN4UGa+
   ziAkmS7mG7wr8YOabhko2auTF54gXNr9Z64nYMUubLdoxZNU25YpLla8s
   8NE6TxK/aE9c8jU4YZ9ySsPimnAYmrq+5FzsHVGcDeVofRi5qmaRKrAv1
   A==;
X-CSE-ConnectionGUID: RPKsm5c1Tmi/wpGpASuQ0g==
X-CSE-MsgGUID: H+jO3gbYTbKw/Rin3Tr3kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074137"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074137"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:04 -0700
X-CSE-ConnectionGUID: WLwk7WxeRv6ifvATkIsrpw==
X-CSE-MsgGUID: zasdtukFQ1WpT5ih48gXUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003596"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:04 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 01/31] x86,fs/resctrl: Improve domain type checking
Date: Thu, 25 Sep 2025 13:02:55 -0700
Message-ID: <20250925200328.64155-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each resctrl resource has a list of domain structures. These all begin
with a common rdt_domain_hdr.

Improve type checking of these headers by adding the resource id. Add
domain_header_is_valid() before each call to container_of() to ensure
the domain is the expected type.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  9 +++++++++
 arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++----
 fs/resctrl/ctrlmondata.c           |  2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index a7d92718b653..dfc91c5e8483 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -131,15 +131,24 @@ enum resctrl_domain_type {
  * @list:		all instances of this resource
  * @id:			unique id for this instance
  * @type:		type of this instance
+ * @rid:		resource id for this instance
  * @cpu_mask:		which CPUs share this resource
  */
 struct rdt_domain_hdr {
 	struct list_head		list;
 	int				id;
 	enum resctrl_domain_type	type;
+	enum resctrl_res_level		rid;
 	struct cpumask			cpu_mask;
 };
 
+static inline bool domain_header_is_valid(struct rdt_domain_hdr *hdr,
+					  enum resctrl_domain_type type,
+					  enum resctrl_res_level rid)
+{
+	return !WARN_ON_ONCE(hdr->type != type || hdr->rid != rid);
+}
+
 /**
  * struct rdt_ctrl_domain - group of CPUs sharing a resctrl control resource
  * @hdr:		common header for different domain types
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 06ca5a30140c..8be2619db2e7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -459,7 +459,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->ctrl_domains, id, &add_pos);
 	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
+		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 			return;
 		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 
@@ -476,6 +476,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_CTRL_DOMAIN;
+	d->hdr.rid = r->rid;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
 	rdt_domain_reconfigure_cdp(r);
@@ -515,7 +516,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
 	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 			return;
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 
@@ -533,6 +534,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_MON_DOMAIN;
+	d->hdr.rid = r->rid;
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
@@ -593,7 +595,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
+	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
@@ -639,7 +641,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_mon_domain, hdr);
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 0d0ef54fc4de..f248eaf50d3c 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -649,7 +649,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 * the resource to find the domain with "domid".
 		 */
 		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
-		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+		if (!hdr || !domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, resid)) {
 			ret = -ENOENT;
 			goto out;
 		}
-- 
2.51.0

