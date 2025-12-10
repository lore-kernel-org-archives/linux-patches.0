Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7380B2D94B5
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408473; cv=none; b=PRQFAh+GfhpdWFB+RVSAupZbhNlaFyvgLbC4PiPsPYc7PCXhfv/RiYXgHxKebzxNwrGZHLaMNkZSF0NRz+4u+RpXlmIxUTtgbnDf/ECJsX/ie0CzxcjSXCjsRE4Sc7KXC5SbuYCdbNMbzNcFYvYFBFZgsCCNtUCDVNsIGSpkhqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408473; c=relaxed/simple;
	bh=uG7+YqtEtzVlwaBgTbjM4zxMwbqEfXKjC407S1dGiWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObWqyC0yIQnOHhChbIuzDJafgQGiDTjn2nvmdWwqbcErnrLPIY+o1JodxEzdRT9YwhfAjXM/TsH9RwIKoNJ8qfIEfFUQa5BWX2VtjmIZ+8TdebwePy2H53mPl5nfEtuqUsQxUf4TLxsf9MUg+U1/kGLgpwZfrQU+oLZjJmqNJFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k4R7p8Bg; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k4R7p8Bg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408470; x=1796944470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uG7+YqtEtzVlwaBgTbjM4zxMwbqEfXKjC407S1dGiWg=;
  b=k4R7p8Bgsz/ge+79B1LJ3Vju8t2FGS51VjNVTqboTj5MyvVv1tqK833T
   dl589Sg50FSQvHguBJE+SvoK7Jt6zpfMh0xzDeZAMeytNV5kyJUoiqjmG
   P7+ss5IZ0WpGDs2x8zpiS/5DeKjyRXLHQipqqr9GpDisvwWf69xeTkz2M
   LVGEiz91vXTVJFthnQGjof96oBOgzTcGdvXpp/Q0WUhoZFzUMY0ZkwJvA
   hN3q51ToYew0rHubBYwPXOm7EjG01qKRrbM2xVMHvqtGqMBmX8TNQI2+U
   e3KDmJFsaNl+caSciIvrV2QXC3+RYYQFm9XN20drcFOGmEr6iA8WuXHh0
   w==;
X-CSE-ConnectionGUID: +U59RDyXTyatOyGxHH1nTw==
X-CSE-MsgGUID: PLC9lJrZQm+shE3b9cVYcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973480"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973480"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:23 -0800
X-CSE-ConnectionGUID: kjXcpGLaRz6MZ02Vh1I/sw==
X-CSE-MsgGUID: gm6axnEaTgikBHwJpe1IFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297023"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:23 -0800
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
Subject: [PATCH v16 01/32] x86,fs/resctrl: Improve domain type checking
Date: Wed, 10 Dec 2025 15:13:40 -0800
Message-ID: <20251210231413.59102-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every resctrl resource has a list of domain structures. struct rdt_ctrl_domain
and struct rdt_mon_domain both begin with struct rdt_domain_hdr with
rdt_domain_hdr::type used in validity checks before accessing the domain of a
particular type.

Add the resource id to struct rdt_domain_hdr in preparation for a new monitoring
domain structure that will be associated with a new monitoring resource. Improve
existing domain validity checks with a new helper domain_header_is_valid()
that checks both domain type and resource id.  domain_header_is_valid() should
be used before every call to container_of() that accesses a domain structure.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            |  9 +++++++++
 arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++----
 fs/resctrl/ctrlmondata.c           |  2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 54701668b3df..e7c218f8d4f7 100644
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
index 3792ab4819dc..0b8b7b8697a7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -464,7 +464,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->ctrl_domains, id, &add_pos);
 	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
+		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 			return;
 		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 
@@ -481,6 +481,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_CTRL_DOMAIN;
+	d->hdr.rid = r->rid;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
 	rdt_domain_reconfigure_cdp(r);
@@ -520,7 +521,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 
 	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
 	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 			return;
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
 
@@ -538,6 +539,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_MON_DOMAIN;
+	d->hdr.rid = r->rid;
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
@@ -598,7 +600,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
+	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
@@ -644,7 +646,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_mon_domain, hdr);
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index b2d178d3556e..905c310de573 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -653,7 +653,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 * the resource to find the domain with "domid".
 		 */
 		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
-		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+		if (!hdr || !domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, resid)) {
 			ret = -ENOENT;
 			goto out;
 		}
-- 
2.51.1

