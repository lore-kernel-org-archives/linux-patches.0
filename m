Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4B2469843
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346083; cv=none; b=sgDoHEzjR20wPdXqC1+lDo7bGrONZMyjy8VyUqrqQrlr2YkARukNLjVK1AQQFassPpct+QtWJlF+FFVfkONnvkAKapGBfDvCgPYFRpBimYg9pHbnCKCbDza7YYura/7jemS7BrftCaRdbmfELitWAvIkrAgD9ICEm/z5eYdC6so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346083; c=relaxed/simple;
	bh=WcPgE1DJLY7e8F5Lz0+pqsvQduengKJ6Gliu/YMdQ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tde63whReDEn4TdwYBEdcipxOF7SPFTt4LOLUkEdU2Jzykhi/BvqKAgNAvdvydoLmlrYJqx0rVRH+24K/ZhqgnuW9b8zxAY9FHqxt9NnRFN7lh10ogmYCX8R1GMNckdZdQ264oX6npa0TFhpCv0EnMMQo1jphEFxpEmQ4JuwD0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AJnjVs5P; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AJnjVs5P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346081; x=1816882081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WcPgE1DJLY7e8F5Lz0+pqsvQduengKJ6Gliu/YMdQ4k=;
  b=AJnjVs5PRys+7u5wGTPKcBU9YZxsZ/FzaJBlCL+CXifxFMh3wrOSW5zt
   Mh+y99FcooofdxYHbl8m6i59H2SGo1tGM5XbaJmJhJc0zZFx/HO1PQuLA
   sQM4Wwn6L9TqI9v+dN/RFFbMjdASBIBsB6SpGy+c7CQ9aihHOVzV7iZm9
   efW7qYikT8OkXuneMryfcdiVaxoTOmjCL52Y952s0gr/iQLBu0uZZyRQz
   LeT2vOkCFiBBSdsrV7dlQUg7O8biQU+k/jBpluCg3uRyAo3Yn0bBZ6dRk
   JVMpSf5d6MXeWt6oxMvc51q9q+LIgpTORAgfqao+cdba8gfi/95izNQth
   g==;
X-CSE-ConnectionGUID: TSoKQLdSSjmh66doYmbfww==
X-CSE-MsgGUID: R77gVX6jSEieD14n75mASQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473556"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473556"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:00 -0700
X-CSE-ConnectionGUID: URrAjOEFQK6z0d6vKDSVjg==
X-CSE-MsgGUID: jaxe6E/LTdK4AP4vUWJs8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024545"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:00 -0700
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
Subject: [PATCH v10 01/17] x86/resctrl: Fix enumeration of number of supported RMIDs
Date: Wed, 29 Jul 2026 10:27:36 -0700
Message-ID: <20260729172752.11561-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a multi-step decision tree for enumeration on X86 of Intel Resource
Director Technology (RDT) also known as AMD Platform Quality of Service (PQOS)

First check CPUID(0x7,0x0).EBX{12} (Linux feature flag X86_FEATURE_CQM).
If this is "0" no monitoring features are supported. If it is "1" then
monitoring is supported, the IA32_PQR_ASSOC MSR exists, and the RMID field can
be written with values from zero to the value enumerated in CPUID(0xF,0x0).EBX.

Second check CPUID(0xF,0x0).EDX{1} (Linux feature flag X86_FEATURE_CQM_LLC).
If this is "1" then one or more L3 cache monitoring features exist and
further enumeration from CPUID(0xF,0x1) provides information about L3
monitoring features.

Linux skips the check for X86_FEATURE_CQM and begins with step two checking
X86_FEATURE_CQM_LLC.

This is a problem for systems that do not support any L3 monitoring features
(or have disabled them with the kernel boot parameter "clearcpuid=cqm_llc")
but do support other features such as Application Energy Telemetry. On
such a system cpuinfo_x86::x86_cache_max_rmid is incorrectly set to "-1".

Correct the checks to follow guidance from the Intel Software
Developer's manual and AMD Architecture Programmer's Manual.

Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	New patch so that boot_cpu_data.x86_cache_max_rmid is useful
	even on systems that don't have cache monitoring.

	Perhaps only worthy of backport to older kernels if taking the
	rest of this series.

 arch/x86/kernel/cpu/resctrl/core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 9b9495174041..e3544c99cff1 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1075,20 +1075,17 @@ static enum cpuhp_state rdt_online;
 /* Runs once on the BSP during boot. */
 void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 {
-	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
+	if (!cpu_has(c, X86_FEATURE_CQM)) {
 		c->x86_cache_max_rmid  = -1;
 		c->x86_cache_occ_scale = -1;
 		c->x86_cache_mbm_width_offset = -1;
 		return;
 	}
 
-	/* will be overridden if occupancy monitoring exists */
+	/* May be overridden if L3 monitoring exists and supports fewer RMIDs. */
 	c->x86_cache_max_rmid = cpuid_ebx(0xf);
 
-	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
-	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
-	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL) ||
-	    cpu_has(c, X86_FEATURE_ABMC)) {
+	if (cpu_has(c, X86_FEATURE_CQM_LLC) || cpu_has(c, X86_FEATURE_ABMC)) {
 		u32 eax, ebx, ecx, edx;
 
 		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
-- 
2.55.0

