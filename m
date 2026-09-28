Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5231B5038FF
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633753; cv=none; b=DYEV1QOecWy4PrL0Auyb3quMub1LXergj41P2bj+wKv7o5qdFtj3pWnDd6dUd8WjZ+c6Vc8oDfeaMC23ggKy/MfiVDc65RAGJf0nq20Lhw1TUIZjrlAR30vNpMASZDzA7CQmIVuj1MSUeZN6a3y5GWABIegM40wlnIVqGedZdas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633753; c=relaxed/simple;
	bh=kp93+gtgHXSwp+aL8jHFZV67+uto69B5Gs1/WccKhuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4ONeqYUS8rIclotnmHBwm7SUfzQ2MQ/SHHByx4U7PykzM6VJZ/m7PMXnk78z7AaYQjDzxM6OHhXVPxlnaKAp7MsC8rcjwd+pW/gmmth4rtGPwddTY8SwkMZtp/AhV3xGwSYc0gsnWqheJbQk67Sn0pTju8wWP0Sia19p1eYyUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GGEFGOXa; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GGEFGOXa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633751; x=1822169751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kp93+gtgHXSwp+aL8jHFZV67+uto69B5Gs1/WccKhuc=;
  b=GGEFGOXafs4T2+hBjt6KMedZNxaV3p2098F3YgQazUd3m4UkduwxPB4d
   SNcRiHOETPesqmHeEqQRA7q16B7o3bk28WqeSWO5OK5FsJC7Ih7qFlQmc
   B565nWYqySZXEkCTwzrhaD/XP2uVDxgSHlEWjxCh///sqa3YA8+JFCHCI
   Qj1VPKKLwqUDc4v+czGxAFH4iV0prrk+ASvk1F93OWkP8nS0KuvHUkARZ
   L7ZvJ5uzXt4RJvvHSmpQ2o5sajARKMhJE3F/OPZDXPXReg7L8xRjwwOPx
   rwdgGbqQo1eXrT1eUNI04HGheGVEnJYmsoQwNw9DKC0eM/RMQzM34sIa+
   w==;
X-CSE-ConnectionGUID: ckeWUKp1QGC8cT79Y6aYnA==
X-CSE-MsgGUID: pn9V2BqYQMeZ3gc/Uh+u5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387355"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387355"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:21 -0700
X-CSE-ConnectionGUID: FQK3k0jXQ7meZ2dsilGjAg==
X-CSE-MsgGUID: MntacW2+SIGUGFhbaJiv/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685547"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:20 -0700
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
Subject: [PATCH v13 23/25] x86/resctrl: Require 64-bit x86 for resctrl support
Date: Mon, 28 Sep 2026 15:15:07 -0700
Message-ID: <20260928221509.68002-24-tony.luck@intel.com>
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

Intel Application Energy Telemetry (AET) provides event counts in 64-bit
registers in MMIO space. For accurate results these should be read with a
single 64-bit load operation from the CPU.

In preparation for the removal of the separate CONFIG_X86_CPU_RESCTRL_INTEL_AET
configuration option, move the X86_64 dependency to X86_CPU_RESCTRL.

This is in line with Dave Hansen's proposal[1] for an addition to Linux
documentation that details reduced 32-bit x86 support.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/c6ab0c24-8931-4f0d-9be6-23498ab4c38b@intel.com/ # [1]
---
v13:
	Re-order tags
	s/This in line/This is in line/
	s/the state of/reduced/
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..06b5d0c4633e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -518,7 +518,7 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
@@ -541,7 +541,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.55.0

