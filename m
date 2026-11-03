Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740995;
	b=VJvCa0XVDT5IQjFY3Lhr5KwcXUm8qoQHDvCQhMoIygLJo4tygdM+JkBcl40b676ShQZa
	 0ZJnMYgW/SMhOqg58hmMr6aQ0B8kYL0B4dlRPF2aajTkkzIe7jMrdlhnOkfFT2EutXWCY
	 RsWLGVq20MVONcRzE8nbI2oEwa9eBA1aNU76P8PC65FJyjwvoXYx8YcnK2rewu+mEjnM3
	 nX7Br7MiZ//8QGJPAV8gR+/ZvYAlckU7+nIbyBrGWVJnJBlcfx1apHcA4Sh5HGWlgxHSz
	 bO5BXn+Pda3EViUEDJ5KPFJYL1CKpOLvQdKwqT/lYexzGbkzMjgaEMtbMivFnYOSoNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740995;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=B50Jt/cYyCUsUbYxbYjKwAXm6ulIX4rJxYjs5Njyqgg=;
	b=JfTiFY0FWrIZ+yd59IIbMu6ESXcO66zFRCEdtOMn4uHLQHxAO0GsuKTxkYeVoHDbGCou
	 Z+4n8YnGjAh2omI+fRmngqInZn++rMmZWQsUvHe4FOJsFZqll9fINF93fv8ZUHWp3oHRT
	 egI3r9Ge+yevzoxTRTCjyPvtlRtNj/EnYiYqR6j4xFHlWMizCEqP/haeLJDOrMIc++cJr
	 I/MqKfbm8dgeAE+LF/WXSbsyurmeGafiFjkrh9ryNGPMUIekap3uX7UOSbica0aubbniP
	 XEWdIxFZv1Ikw7OJHbBdDYNnqidlEvV8GA9T4NXRSYybEbvSopr1UiAv3ysRVTIMw/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LIToOpJz;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FDF606D801
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0FDF606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LIToOpJz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793740995; x=1825276995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cqXd4OJlpWZioZ2BGrFu3nNs3QMLDFpa1lSgaTSP2YA=;
  b=LIToOpJzrQqS4rmxV4Iu4U+scZG0mW8FhNCoj3C4ozEb6F6dDomOoBOG
   wAmhWrWyiZwc53MubckPp+zh3QJF6AP5HcI+YdJfuCbVjLBvRh92r5Rv3
   qXZgU7vtA6KxUIJgdaICRXUUBPn8j0JieSwplI+Iapkh8PjPxI6NHYl97
   48F+PUodK94cPi0IJr+JW4TgnmoiaNqY6ZMuMgj/vOXGHUiheZe7F3cyC
   4jHA/NiTH21qnK6slTZRNwY7Flzkuz9hTJAXAxrnp11MN1HK8/0YMx4xJ
   OPfiMuoVlU8h6YQTzcUhJJv3aTTGRwMUzLUx7b7qJ8qGrDyMruLCPmCZv
   A==;
X-CSE-ConnectionGUID: uQP7DnIfTKuMZmLycnfY5w==
X-CSE-MsgGUID: mc/jiyd5RZCoH7jxo8bV3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393512"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393512"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:11 -0800
X-CSE-ConnectionGUID: qJjEI5YhR66nUCseUqgaRA==
X-CSE-MsgGUID: 2OS6y/brR+mVshcnd6MpHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624579"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:09 -0800
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
Subject: [RFC PATCH v2 06/11] x86/resctrl: Pass the CPUID leaf to rdt_get_cache_alloc_cfg()
Date: Tue,  3 Nov 2026 13:22:49 -0800
Message-ID: <20261103212254.18314-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103212254.18314-1-tony.luck@intel.com>
References: <20261103212254.18314-1-tony.luck@intel.com>
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

Symmetric and asymmetric cache allocation parameters use the same CPUID
subleaf format but different leaves.

Pass the leaf number to rdt_get_cache_alloc_cfg() so callers can select the
enumeration leaf. This prepares the helper for asymmetric allocation without
changing current behavior.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6df8e3c03289..7981ddbde8c9 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -348,7 +348,7 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 	return true;
 }
 
-static struct resctrl_ctrl *rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
+static struct resctrl_ctrl *rdt_get_cache_alloc_cfg(int leaf, int idx, struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	struct resctrl_hw_ctrl *hw_ctrl;
@@ -357,7 +357,7 @@ static struct resctrl_ctrl *rdt_get_cache_alloc_cfg(int idx, struct rdt_resource
 	union cpuid_0x10_x_edx edx;
 	u32 ebx, default_ctrl;
 
-	cpuid_count(CPUID_LEAF_RDT_A, idx, &eax.full, &ebx, &ecx.full, &edx.full);
+	cpuid_count(leaf, idx, &eax.full, &ebx, &ecx.full, &edx.full);
 	hw_res->num_closid = edx.split.cos_max + 1;
 	hw_ctrl = kzalloc_obj(*hw_ctrl);
 	if (!hw_ctrl)
@@ -1065,7 +1065,7 @@ static __init bool get_rdt_alloc_resources(void)
 
 	if (rdt_cpu_has(X86_FEATURE_CAT_L3)) {
 		r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
-		ctrl = rdt_get_cache_alloc_cfg(1, r);
+		ctrl = rdt_get_cache_alloc_cfg(CPUID_LEAF_RDT_A, 1, r);
 		if (ctrl) {
 			if (rdt_cpu_has(X86_FEATURE_CDP_L3))
 				rdt_get_cdp_l3_config();
@@ -1079,7 +1079,7 @@ static __init bool get_rdt_alloc_resources(void)
 	if (rdt_cpu_has(X86_FEATURE_CAT_L2)) {
 		/* CPUID 0x10.2 fields are same format as 0x10.1 */
 		r = &rdt_resources_all[RDT_RESOURCE_L2].r_resctrl;
-		ctrl = rdt_get_cache_alloc_cfg(2, r);
+		ctrl = rdt_get_cache_alloc_cfg(CPUID_LEAF_RDT_A, 2, r);
 		if (ctrl) {
 			if (rdt_cpu_has(X86_FEATURE_CDP_L2))
 				rdt_get_cdp_l2_config();
-- 
2.56.0

