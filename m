Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC059492E4B
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633737; cv=none; b=mIdYQ6QtQf7cQ21nzOOhDnFrPMmF5YGHEzDXOCZeVrFY+Y/3E47ydiHtgvthGwxL+QasAr+j2nZgHLYa2rvpQCED6mWbG7Kd4BSATuCXv1UqLECN3Ut76e7zKqXXWaYHnZljo1PhCwWW1rVm/s3CVJEcYBmPghwh04fjEQbJCcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633737; c=relaxed/simple;
	bh=UFKRGbm2wutbzcWRRny6qGAFP44s+hlNWEkSJB6ytB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwXEhqR/WoH/x2A4599+mjLeTBiE70lEa/FC3XuNh98CbSgkNXm83gakQhvY4dWPQeKn2fayztP1GqTZ4EqGXzqmmE8TEMr2LCYiq8DzSPvgiOrUhHG/hT0tBCX2D911UHL4iii05oJE8RFlGfB2IU+n96A/W+V+ogwdm58sUmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CHpJnwAT; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CHpJnwAT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633728; x=1822169728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UFKRGbm2wutbzcWRRny6qGAFP44s+hlNWEkSJB6ytB0=;
  b=CHpJnwATnunv5MMGwrbWEHh2VUidRulco9JbqhkNeZ6JZoWEUYD2+J4Y
   PYBQHYQvTgf0TVTvb4PY5XnAEfmycP3Us81fv2JJZe4JvVuWrLyxB+KzU
   SDdFAzRv5YKw2SOSTWhbkgM8pOZrvrchQ02pEfIZz9ghDvkfKvOeISbYc
   luRLTzgdE+6X+e/8pzX32hhVm1Q2FTlIOTcyBbS62b3M0bP9wKSB4b36m
   2gtW0qnT+0DEhHoxwq/uYHigmhnsutk/jAQbPO8EFcqI4pGUbmglMtirR
   qFuyl4lWzw6Kajb4y8sIBFv1fxpbF0p5GEvx0Yj/0k3LUCpGUiR0wMJus
   Q==;
X-CSE-ConnectionGUID: dmhSRwmKRGSH5R1oknkz/Q==
X-CSE-MsgGUID: 44w2S8OYS1GazZx5eKJNGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387218"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387218"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:18 -0700
X-CSE-ConnectionGUID: H99vCRjuSkmDE0Vl5xxGig==
X-CSE-MsgGUID: t6gzEFj+Q0mvpWc7XGzj8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685487"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:17 -0700
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
Subject: [PATCH v13 08/25] x86/resctrl: Update special case for Intel Haswell enumeration
Date: Mon, 28 Sep 2026 15:14:52 -0700
Message-ID: <20260928221509.68002-9-tony.luck@intel.com>
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

Certain Intel Haswell CPUs support resctrl L3 cache allocation but do not
enumerate the feature. A quirk probes for support and provides hard-coded
parameters. The quirk sets both the global rdt_alloc_capable and the resource
specific rdt_resource::alloc_capable, only the global is used to signal that
normal enumeration can be skipped.

The global rdt_alloc_capable is redundant since rdt_resource::alloc_capable
already carries the same information.

Stop setting rdt_alloc_capable in the quirk and rely on the resource specific
flag to prepare for removal of this global variable.

No functional change intended.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Replaced commit comment with Reinette's improved version.
---
 arch/x86/kernel/cpu/resctrl/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f0cfb37482d3..f2bf160d01c1 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -177,8 +177,6 @@ static inline void cache_alloc_hsw_probe(void)
 	r->cache.min_cbm_bits = 2;
 	r->cache.arch_has_sparse_bitmasks = false;
 	r->alloc_capable = true;
-
-	rdt_alloc_capable = true;
 }
 
 /*
@@ -930,7 +928,11 @@ static __init bool get_rdt_alloc_resources(void)
 	struct rdt_resource *r;
 	bool ret = false;
 
-	if (rdt_alloc_capable)
+	/*
+	 * On Haswell systems cache_alloc_hsw_probe() already marked
+	 * RDT_RESOURCE_L3 as alloc_capable. No further enumeration is needed.
+	 */
+	if (resctrl_alloc_capable())
 		return true;
 
 	if (!boot_cpu_has(X86_FEATURE_RDT_A))
-- 
2.55.0

