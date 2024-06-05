Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A84215351A
	for <patches@lists.linux.dev>; Wed,  5 Jun 2024 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604079; cv=none; b=ld02Jd7KQ12Ga2asXp5AUSir0ojEP87iOfsOug7U7sF3hHSplV7aOgca/JyNGiXgly0DyE+58sQSzrfqI3QAKtuIK1tWg1V6kgp0R8QAtideBUFwj/eYCanAiw7t3kHptYkQlfySyHqR+SAZAlUkTiHrQZ2V3hUeIeSKq08RqIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604079; c=relaxed/simple;
	bh=dYRxACWS2D/qY2OE5vaGsvS2+7L87gFzA2dBpDDdBzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g+qVwfoCPMxu+Fpd+H1b/G/f/PCfvw1xXWfmveB0mnDHBiFfrl/GQ7PjK5YXINYcJHsZQbpuriH0eshID8x8yPLpcbGQboJFKLnQ46WnBza5Yak7300Hi8bZWmJK/HpCvi+aj2HRPlouAnlbfp2DsZilIO5HwLT4fB1ke8V8QFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ccCWP6S1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ccCWP6S1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717604078; x=1749140078;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dYRxACWS2D/qY2OE5vaGsvS2+7L87gFzA2dBpDDdBzU=;
  b=ccCWP6S1R/VqT+GiG0hnLNqXUbOsmd4CW8zieAd3bRI9qmzfpCnQZBrr
   8ETZa7OPi3Fait4KGoA+RZv+vcE4+z5HB2iLNMEVlCPVv8EqP9UR+Ioon
   GTrsnAi/+uJHwFrVMMhrqll8xoRnU11jhJS7meP4h6KmVxnQDi23Qkyj2
   C7t055bpT2HmHseLdD8xeMUn1O/KZKMF4oToYxHdBSGzV29PdQ3zoz6ZW
   LqTlVFOVsJRj/WFX3ArVc/JpaMU7oWZV7YLhu19uM7Mj0gWB1gCRiULzE
   bysPXCpE/DXWUt8pD3cBVxFwhB2QuYlE5ji3eBC8UYMCsEmcGdE4Ce4Ku
   w==;
X-CSE-ConnectionGUID: Dl8RtWIYQmuW5yPgEJY91A==
X-CSE-MsgGUID: vFvowZLvSCGekExLBL2Xew==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="31772281"
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="31772281"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 09:14:37 -0700
X-CSE-ConnectionGUID: sk8BrQSVQNSDq1bvbPLcWA==
X-CSE-MsgGUID: tqRHwGzOROaEp7oFlw07Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="42581895"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 09:14:36 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 0/3] Add and use get_cpu_cacheinfo_level()
Date: Wed,  5 Jun 2024 09:14:24 -0700
Message-ID: <20240605161427.312994-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This helper function came up in discussion of the resctrl patches
for Sub-NUMA Cluster (SNC) support. Reinette pointed out[1] that there
are already two places where it would clean things up by avoiding
open coding. The SNC patches will add two additional call sites.

So rather than have this jammed up as part of the SNC series, I'm
posting it as a simple standalone cleanup.

Signed-off-by: Tony Luck <tony.luck@intel.com>

[1] https://lore.kernel.org/all/050c64b3-20b3-4db6-b782-f5124ebaab31@intel.com/

---
Changes since v1:

1: s/for cache/for the cache/ in comment for get_cpu_cacheinfo_level()
2: No change
3: Fixed broken firtree declaration order in rdtgroup_cbm_to_size()

Added Reinette's "Reviewed-by:" tag to all three.

Tony Luck (3):
  cacheinfo: Add function to get cacheinfo for a given (cpu, cachelevel)
  x86/resctrl: Replace open code cacheinfo search in
    pseudo_lock_region_init()
  x86/resctrl: Replace open code cacheinfo search in
    rdtgroup_cbm_to_size()

 include/linux/cacheinfo.h                 | 22 +++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 17 ++++++-----------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 14 +++++---------
 3 files changed, 28 insertions(+), 25 deletions(-)


base-commit: c3f38fa61af77b49866b006939479069cd451173
-- 
2.45.0

