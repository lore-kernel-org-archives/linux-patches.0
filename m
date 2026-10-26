Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051852;
	b=vEZ50VQdj8qeH6j1h7NXN0it50/wrX7LTKiSj+QgduvaBy4VhOvcDfQ029eE9k+Rx3xl
	 GElMG+e+v08ejbwclqdu9BdqpEBa69Rtp2W7IyC0ytBTiPD1YQ17/DvFmXmQqJBPLTh/u
	 hxHHCgQDGne0uAoMxfLJCnOFx8IYOoncvjw6iq+pOW6crRqFOcYE+a3xGPVq2tuSI5x/s
	 DYYyAy0ztKbJSNW5O0OB0KvUZDlIhqhZt14s47faGysmqpH3cQP4bb2bMmywFl9Yrqvjl
	 Tud84smE+3odKNAR/H7fvVVXS/LYBOGGu7ABeFy/HpwJ47YvKjbS4t/Py6QBF4e6fzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051852;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qRjmD4BRkpwfDYL29pCsSwJ5mL8xLjyE3ypx18q7Ku4=;
	b=Z7lrHiJxfRLkKZ6btjKsJpGpZ1AJ7T9qwp2J7uCuxWJ85gqbsHtu5fYMOVoghrwS7bWX
	 9JVP7o+d3BgQhZ66UrTFuGYxS30qi0lFL4fb+0Mox90hBQbuVD2rnu8Ow/9xRk9k8U7JH
	 8eC3dn6oPAtmIxNePkzyDudho1+/DMQoGJNU6rMNgePBbdQdHmNt0dP093lLx77FSoh3r
	 lImS3tchEMn8cz1yQNlLHH/3VKPz/odhY8pgHZXqRp7BIRd0vnLLTSbKxS/ZnYENWasGl
	 NmUAxpVdTvBmd9EWh65el04aoyaVVFfh7NfxrMZUHSiAFYpU3FRM9cIQnbUTjSMTbsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="Vj/wPXWq";
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E073606A323
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 21:57:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E073606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Vj/wPXWq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793051851; x=1824587851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5c4mUlvT6khRMoGm4YgKhspKqGQJyiiO2cfKwAV+9NI=;
  b=Vj/wPXWq/BpOmCOIqijpIxQ0RmZAEM0S0toCgsSfCwvlvdrP7XFtROFw
   cmX+8LEYwIVrwhMAeWsN2bguXRsu8d7mWENVAKrg8jFQ9Oni/jOXWotqK
   djijmavm2dDWv39eRVikoCNsEqGf/jnue+ZjilgwyY7X8Bv7KoYTqGsZV
   IRHuguOaOORmnnyZ8eb9lJDgJ1mOanzXdhpX2Cz/lfzY5q9LVd8sgiWzX
   ZFOwFNzIsdOzWnWdpKXjfDymH1zsYhpVBxogWPOKdbKGXzC9H+ZRhf6gU
   Irl4g6IB4WO2Co7NFdBuVg84tV6BFYq2IG6lmzblJDBCC16gyGQIomjh3
   w==;
X-CSE-ConnectionGUID: uXKELywYTLiwd8AgSFL7ZQ==
X-CSE-MsgGUID: 6QtPN3t6RiSkAWcuMOm9PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1766408"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1766408"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:29 -0700
X-CSE-ConnectionGUID: sMveULaCTL2EnSzhjrY56A==
X-CSE-MsgGUID: 3FgCptCsSfuJUzCNmfAkig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4240274"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.204])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:28 -0700
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
Subject: [RFC PATCH 5/8] x86/resctrl: Refactor rdt_get_cache_alloc_cfg()
Date: Mon, 26 Oct 2026 14:57:15 -0700
Message-ID: <20261026215718.16810-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026215718.16810-1-tony.luck@intel.com>
References: <20261026215718.16810-1-tony.luck@intel.com>
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

Enumeration of the parameters for L2 and L3 cache allocation is in
a common format in separate sub-leaves of CPUID leaf 0x10. A helper
function is used to process both L2 and L3.

Asymmetric enumeration is in leaf 0x28 in the same format as leaf 0x10.

In preparation to support asymmetric L2 configurations make the leaf
a parameter to rdt_get_cache_alloc_cfg().

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c66ff4cdd84b..c26fc75ccc07 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -348,7 +348,7 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 	return true;
 }
 
-static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
+static void rdt_get_cache_alloc_cfg(int leaf, int idx, struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	struct resctrl_hw_ctrl *hw_ctrl;
@@ -357,7 +357,7 @@ static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
 	union cpuid_0x10_x_edx edx;
 	u32 ebx, default_ctrl;
 
-	cpuid_count(CPUID_LEAF_RDT_A, idx, &eax.full, &ebx, &ecx.full, &edx.full);
+	cpuid_count(leaf, idx, &eax.full, &ebx, &ecx.full, &edx.full);
 	hw_res->num_closid = edx.split.cos_max + 1;
 	hw_ctrl = kzalloc_obj(*hw_ctrl);
 	if (!hw_ctrl)
@@ -1061,7 +1061,7 @@ static __init bool get_rdt_alloc_resources(void)
 
 	if (rdt_cpu_has(X86_FEATURE_CAT_L3)) {
 		r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
-		rdt_get_cache_alloc_cfg(1, r);
+		rdt_get_cache_alloc_cfg(CPUID_LEAF_RDT_A, 1, r);
 		if (rdt_cpu_has(X86_FEATURE_CDP_L3))
 			rdt_get_cdp_l3_config();
 		if (rdt_cpu_has(X86_FEATURE_SDCIAE))
@@ -1071,7 +1071,7 @@ static __init bool get_rdt_alloc_resources(void)
 	if (rdt_cpu_has(X86_FEATURE_CAT_L2)) {
 		/* CPUID 0x10.2 fields are same format at 0x10.1 */
 		r = &rdt_resources_all[RDT_RESOURCE_L2].r_resctrl;
-		rdt_get_cache_alloc_cfg(2, r);
+		rdt_get_cache_alloc_cfg(CPUID_LEAF_RDT_A, 2, r);
 		if (rdt_cpu_has(X86_FEATURE_CDP_L2))
 			rdt_get_cdp_l2_config();
 		ret = true;
-- 
2.56.0

