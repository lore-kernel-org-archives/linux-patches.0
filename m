Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD324D9F75
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600417; cv=none; b=rg5MV/WRuMf8nKYb4bOozl/d52y02oNGr2YK8RmxRjeichRwuN0/YHTq0Dnk3rkRURCdA3SpqCrJSV5XhzmyVCXBFrIQinEFlsL2aQx2UKALnBP0H000qoS8xwhQ61b9htgPQd2gWNCsxLTUpU/A9CqIlqAPo95hTMFcCGQUnp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600417; c=relaxed/simple;
	bh=mQ1zUO7cuhKE1nxW6bs53CfGHgz37yQzw7l8uP4F3Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIPut8o51MpHGN3BcWLbo3BXN1WFmzgAoEA10gNHgWxhFKI3hL7hjiOcgVZTNykk3rQgf/Ex0g01RLNYXz3OibUOZyi8QT3imzQRcqgh1hl89NS+Tm4kKyvY4HuReKk/NxWg2cif1A3XW2cfs3ebPt/gt8nWlrCpJ3GTZdalZys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VEZz5J5W; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VEZz5J5W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600416; x=1821136416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mQ1zUO7cuhKE1nxW6bs53CfGHgz37yQzw7l8uP4F3Q8=;
  b=VEZz5J5Wuc6iTZ3lri8xJOrfW82Sp9+VI95aR6LamRjTubs6cfONKFE+
   nsOwMhZZZf97S19bd6gd9qfxkJ1kF9aUGRjgose0oYdivlOa2Fgp/V6V3
   uoKc7qRhMTbVgb/L8KT79qNxmsheXIi/BlHymf8DE0XW+X82un7ya8AoG
   SsFu0mYb1EAehYwJGif+s5OpCbsJM582f+BUhBNJEw3ZDWdg5LqsvHNfe
   ZnDXE50QDBF+QHvBWKeeFz9wnKxtwFd5gbLHT6I/Brm3ykgcCPkow9sO9
   VVDv8jytRE1ataLhpKagViUQTLKA5Wd00WG594GO/pX8awVOAAXBrkmLM
   Q==;
X-CSE-ConnectionGUID: 8Fu+BRNSQG+7Vc8VWEnBkg==
X-CSE-MsgGUID: wxYthoUfSJOV7M67cT4IDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861373"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861373"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:33 -0700
X-CSE-ConnectionGUID: HzjHhHkkQPifTRhKz9ZJkw==
X-CSE-MsgGUID: 3u4kX2keR/6YkA0Q3mj+Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231446"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:33 -0700
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
Subject: [PATCH v12 07/25] x86/resctrl: Update special case for Intel Haswell enumeration
Date: Wed, 16 Sep 2026 16:13:02 -0700
Message-ID: <20260916231320.14502-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Certain Intel Haswell CPUs have support for resctrl L3 cache allocation
but do not enumerate the feature. There is a quirk to check for support
and provide hard-coded parameters. This quirk sets rdt_alloc_capable
to indicate to get_rdt_alloc_resources() that normal enumeration is
not needed.

Drop setting of rdt_alloc_capable in cache_alloc_hsw_probe() in
preparation for removal of this global variable.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Remove the new hsw_alloc_capable variable.
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

