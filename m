Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE49509EE4
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633757; cv=none; b=aw91mfWak7HnPNxU5DFHKxF+SimTVrw56js0oOEKZSip5Kzj/G0oJfZFoIvHYyRXLbJaKuWgQBoegIzFEailg30ZHxss/Ai+W7409Cg24+ykEviZfeS41ihnJP0CHPv4phZcUQKJFdVdkVIyHYHKNU3r3VdP0vey4g7BmYUStwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633757; c=relaxed/simple;
	bh=DT3DfvF3f0sbQAD5c8abiTRdsPBJ8FNfyz4tDtt/JK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6GEb6oGJ/c0TCTdam4m4vwtjrQlVyH8v8Wv5dgwnOZ9v+N9NS4wTUF6OM4MfZi4RukfGmWcQ9eP430lh5szLW+ArhVPeEeJanZYK9jykxHqbrxWgnqj80hL+59a5rA7xkeI/t9pCmHClP0q8KNpny9Z+p3TdeKWXWfP+Rb9O1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iEU5fq4q; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iEU5fq4q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633754; x=1822169754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DT3DfvF3f0sbQAD5c8abiTRdsPBJ8FNfyz4tDtt/JK4=;
  b=iEU5fq4qLt97z2oTYN7QGMbhGK5YtE1Cluzgk2V7eNIteywcm8zGhV59
   7P/eXUHli4ArAGJO+3pjwnCCQihmSYAMnSJpAtuWKw/7bO4ONVSbDAofU
   4T37ZRzu89xAci/tdSwhUushpXBKDVA22o2+7LjFeFwBzutwGjM3hM2+K
   eRhhjndyi8Q+xLjSl/Po359dnOw+6HMxMjM3/7Kmt6QNLVEP/Rf7t9l/D
   syU38Z1iKYTl/7By4Vxo3PN2Wp8rKD/mTof8Xjv0aLvHc1bLdEhqqDLnS
   Wjwl5u8PwJ6P52eJDfpexCIzqo6NtSF61CZKHyoJMQtn8RNaau/xvKsno
   w==;
X-CSE-ConnectionGUID: he5MAtOYSB+3Ru9iio1M7w==
X-CSE-MsgGUID: yCZMxZhHTk6DI+StnujLSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387346"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387346"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:21 -0700
X-CSE-ConnectionGUID: J6cIuh6OQXOpygcPKy+NsQ==
X-CSE-MsgGUID: pb/yh1xhSW6j0yGVXt+bkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685533"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v13 20/25] x86/resctrl: Enforce system RMID limit on AET
Date: Mon, 28 Sep 2026 15:15:04 -0700
Message-ID: <20260928221509.68002-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AET (Application Energy Telemetry) event groups each support a specific
number of RMIDs. But that number may be higher than the number supported
by the system.

Ensure that info/PERF_PKG_MON/num_rmids does not display an unachievable
value to users by capping the maximum supported RMIDs in the resource to
the system maximum.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Drop sentence about SNC reducing number of RMIDs as it isn't
	relevant.

	s/lower/higher/ in commit message.

	s/IA32_PQR_ASSOC.RMID/MSR_IA32_PQR_ASSOC.RMID/

	Changed pqr_assoc_num_rmid from static to global.

	Move clamp from arch/x86/kernel/cpu/resctrl/core.c to
	arch/x86/kernel/cpu/resctrl/intel_aet.c
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 2 ++
 arch/x86/kernel/cpu/resctrl/core.c      | 2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 7 +++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index c66954bc01e7..1f080aad1b67 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -153,6 +153,8 @@ extern struct rdt_hw_resource rdt_resources_all[];
 
 extern bool intel_rdt_mbm_need_quirk;
 
+extern u32 pqr_assoc_num_rmid;
+
 void arch_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 40466f29e48e..689b9e31fe7a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -46,7 +46,7 @@ static DEFINE_MUTEX(domain_list_lock);
 DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 /* Number of unique RMID values that can be written to MSR_IA32_PQR_ASSOC.RMID */
-static u32 pqr_assoc_num_rmid;
+u32 pqr_assoc_num_rmid;
 
 static void mba_wrmsr_intel(struct msr_param *m);
 static void cat_wrmsr(struct msr_param *m);
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 8aa2e18a6bbb..e64e5a44511f 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -274,6 +274,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	else
 		r->mon.num_rmid = e->num_rmid;
 
+	/*
+	 * AET may claim to support more RMIDs than are permitted to be
+	 * assigned to MSR_IA32_PQR_ASSOC.RMID. Enforce this limit.
+	 */
+	r->mon.num_rmid = min(r->mon.num_rmid, pqr_assoc_num_rmid);
+
 	if (skipped_events)
 		pr_info("%s %s:0x%x monitoring detected (skipped %d events)\n", r->name,
 			e->pfname, e->guid, skipped_events);
@@ -391,6 +397,7 @@ void intel_aet_unmount(void)
 	struct event_group **peg;
 
 	guard(mutex)(&aet_register_lock);
+
 	if (!pmt_in_use)
 		return;
 
-- 
2.55.0

