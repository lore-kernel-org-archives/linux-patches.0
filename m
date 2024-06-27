Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35B019EEA4
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 20:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520756; cv=none; b=TvVknSOMcX7UdUczDHocHDMcqrzu/y1aWHn5/m2FtcCE85gxPAfGEdDHwzfuIIziREnpOp0X7vdWuLuKyqaTEMIO1sjSvp5qiZbEsRJpz1NjmttLff4pjHnkW85eTxsljfjpga0m66zQAan2rWq+B1DDgNP6VfX7x4qYpJSuAKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520756; c=relaxed/simple;
	bh=E1OjYH+VizyHNJwzEabDMPXh9xsy+KGJwiXkqbLxewI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poMJtASZGhIhXwqA6SblRRZJR21Hpm74XT+nYdFUo810ptYyPLQms4uBqxDkPIjB8lPezN3zkwfC85wZ3aKYYavj/jGu43CUwzSt9ncL0UJ915eOP3oLtVQpHlWOSlfPdBRESkCTWP0pqMt6NDhRF8vboGY5eapZyCEeOlwXblY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bcueBF2q; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bcueBF2q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719520755; x=1751056755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E1OjYH+VizyHNJwzEabDMPXh9xsy+KGJwiXkqbLxewI=;
  b=bcueBF2qaPQB6Rto6F3lmY1R38WN6D0u61BoCnT4d4cSkgJzBHEtMISK
   WYelBHog0EU07h/Wd+lYtsJYUFTXUOYihI5LKRCiBZaatY5M/yym+lqM+
   4xsws4pgkqOuvpvE/p0aIVjHTjD2Z0NakW/TNiqdtFxHURn9A5ljdep/h
   8l29mNkPBuT+4REoYqyZWEAVf60DDMxinA0OnBqK+DOdUNqBpyUMNZ/Kt
   wQCNSBQykjT1BzqZrNk/d1pvJYRnCiXx01URLOzMeVF5CBagU8EucRmB+
   SrA/HdVDd92n+UBz9BMzgEA2P4GZNcw0xp8wyxA4LKyZTDZs4lTN3pkvx
   A==;
X-CSE-ConnectionGUID: E62q4doQQnWChCT1iwB6/w==
X-CSE-MsgGUID: ki0eLJlvS0unT4ppm2M+xQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16809800"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16809800"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:09 -0700
X-CSE-ConnectionGUID: WmsZMNx3R/e6qo1fMUCE+g==
X-CSE-MsgGUID: fMl+pyJ8RHGYAvKokkMCIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="82052903"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v22 09/18] x86/resctrl: Add a new field to struct rmid_read for summation of domains
Date: Thu, 27 Jun 2024 13:38:47 -0700
Message-ID: <20240627203856.66628-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627203856.66628-1-tony.luck@intel.com>
References: <20240627203856.66628-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a user reads a monitor file rdtgroup_mondata_show() calls
mon_event_read() to package up all the required details into an rmid_read
structure which is passed across the smp_call*() infrastructure to code
that will read data from hardware and return the value (or error status)
in the rmid_read structure.

Sub-NUMA Cluster (SNC) mode adds files with new semantics. These require
the smp_call-ed code to sum event data from all domains that share an
L3 cache.

Add a pointer to the L3 "cacheinfo" structure to struct rmid_read
for the data collection routines to use to pick the domains to be
summed.

Initialize all on-stack declarations of struct rmid_read:
	rdtgroup_mondata_show()
	mbm_update()
	mkdir_mondata_subdir()
to ensure that garbage values from the stack are not passed down
to other functions.

Remove redundant rr->val = 0; from mon_event_read() and rr.first = false;
from mbm_update() since the rmid_read structure is cleared by compiler.

Reinette suggested that the rmid_read structure has become complex enough
to warrant documentation of each of its fields and provided the kerneldoc
documentation for struct rmid_read.

Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    | 19 +++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  3 +--
 arch/x86/kernel/cpu/resctrl/monitor.c     |  3 +--
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  2 +-
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 135190e0711c..681b5bdcd2f9 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -144,12 +144,31 @@ union mon_data_bits {
 	} u;
 };
 
+/**
+ * struct rmid_read - Data passed across smp_call*() to read event count.
+ * @rgrp:  Resource group for which the counter is being read. If it is a parent
+ *	   resource group then its event count is summed with the count from all
+ *	   its child resource groups.
+ * @r:	   Resource describing the properties of the event being read.
+ * @d:	   Domain that the counter should be read from. If NULL then sum all
+ *	   domains in @r sharing L3 @ci.id
+ * @evtid: Which monitor event to read.
+ * @first: Initialize MBM counter when true.
+ * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
+ * @err:   Error encountered when reading counter.
+ * @val:   Returned value of event counter. If @rgrp is a parent resource group,
+ *	   @val includes the sum of event counts from its child resource groups.
+ *	   If @d is NULL, @val includes the sum of all domains in @r sharing @ci.id,
+ *	   (summed across child resource groups if @rgrp is a parent resource group).
+ * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only).
+ */
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_mon_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
+	struct cacheinfo	*ci;
 	int			err;
 	u64			val;
 	void			*arch_mon_ctx;
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 3b9383612c35..4d76ff31a9e0 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -529,7 +529,6 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	rr->evtid = evtid;
 	rr->r = r;
 	rr->d = d;
-	rr->val = 0;
 	rr->first = first;
 	rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
 	if (IS_ERR(rr->arch_mon_ctx)) {
@@ -557,12 +556,12 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
 	struct rdt_domain_hdr *hdr;
+	struct rmid_read rr = {0};
 	struct rdt_mon_domain *d;
 	u32 resid, evtid, domid;
 	struct rdtgroup *rdtgrp;
 	struct rdt_resource *r;
 	union mon_data_bits md;
-	struct rmid_read rr;
 	int ret = 0;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index ff4e74594a19..ca309c93a56b 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -780,9 +780,8 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
 		       u32 closid, u32 rmid)
 {
-	struct rmid_read rr;
+	struct rmid_read rr = {0};
 
-	rr.first = false;
 	rr.r = r;
 	rr.d = d;
 
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 70d41a8fd788..d0443589cd86 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3029,10 +3029,10 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 				struct rdt_mon_domain *d,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
+	struct rmid_read rr = {0};
 	union mon_data_bits priv;
 	struct kernfs_node *kn;
 	struct mon_evt *mevt;
-	struct rmid_read rr;
 	char name[32];
 	int ret;
 
-- 
2.45.2

