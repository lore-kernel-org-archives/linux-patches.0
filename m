Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5571C68C
	for <patches@lists.linux.dev>; Fri,  3 May 2024 20:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714768417; cv=none; b=B9+R4N2mXmvgKykIyn1ELpVi3W5id13mRtrLFdT+aWZ5uMREY/J/EZXBlityLWWMG9W+2iZZnb4scKbDwl+aRHOB8vn1O9/lSedyCFb5HmRnAXX3hJfqEbnCg3b7T7fZ7XHwkDtsINkbNnadQMXWaEyeOb0OuSryMwoyhFUs/qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714768417; c=relaxed/simple;
	bh=x7J7+Si7urvufF5defI0vXD0kMYbVO9TjNHY3GjSqaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U79Wi6dSMYqyUNGJK2sry7RqUHTcY65jY0+ucTPRDvj9rPKmx1581yIltsXLOdqxFbvnT3XC2e8zB9oqEsFDpA8ifvdRQCZZK4vsUY8zdfUPpPOatESm3UJjHcjnfgxkHx+3wk9g1v+Q0iDUohoHC94kYOxv3Nlw2JyKh9nV4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ihyPWmFH; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ihyPWmFH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714768416; x=1746304416;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x7J7+Si7urvufF5defI0vXD0kMYbVO9TjNHY3GjSqaU=;
  b=ihyPWmFHLj2zSABSpX6uOJRlLtpmRLGF38JKti9HW0BxHAgFHBWJrpzw
   SJ+yqomfVoqMIRyc9XpxQ6CT6kn+oy1nLkiU+lY9BQxS//+CSUyL9xoX5
   uIqfnfiYXFin/KJdBGlAU4diTkLMu9ZANBAXw2az0eWy6QL5f1399xr8a
   DaqMFrAb1KR/d7hqrUn7R7LsiEpWCTCQc9+YUB0PPX9jL+2KAgkOyiBxD
   9kLUkEPVEKhm8bn+cUaoqEOeWabo1TAAAucovqXcVPhXtEY50Zx50uZR/
   mVBnvYu4AvOM/DuxV8/E8b6yi6ri/CahcRQcZawnmexvJ0U3kXi7eIS6B
   g==;
X-CSE-ConnectionGUID: hbj2WyGbT6SVaKFpVZKGNQ==
X-CSE-MsgGUID: TyweqvphSLilTws36QmEMg==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="21274255"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="21274255"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 13:33:34 -0700
X-CSE-ConnectionGUID: GyQU4HuIRI6wsB3C0DY4sA==
X-CSE-MsgGUID: 4gCsHo6jRy6S4rMK1Z78dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="27431799"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 13:33:34 -0700
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
Subject: [PATCH v17 0/9] Add support for Sub-NUMA cluster (SNC) systems
Date: Fri,  3 May 2024 13:33:16 -0700
Message-ID: <20240503203325.21512-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note: Jump straight to patch 7 for the new stuff. Just minor tweaks in
other patches.

This series based on top of TIP x86/cache branch:
 931be446c6cb ("x86/resctrl: Add tracepoint for llc_occupancy tracking")

The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
that share an L3 cache into two or more sets. This plays havoc with the
Resource Director Technology (RDT) monitoring features.  Prior to this
patch Intel has advised that SNC and RDT are incompatible.

Some of these CPUs support an MSR that can partition the RMID counters
in the same way. This allows monitoring features to be used. Legacy
monitoring files provide the sum of counters from each SNC node for
backwards compatibility. Additional  files per SNC node provide details
per node.

Cache and memory bandwidth allocation features continue to operate at
the scope of the L3 cache.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Changes since v16: https://lore.kernel.org/all/20240312214247.91772-1-tony.luck@intel.com/

Patch 1: Reinette pointed out that rdt_find_domain() no longer returns ERR_PTR()
but one of the callers was still checking return with IS_ERR().

Patch 2: Tip tree added a tracing patch. That needed s/d->id/d->hdr.id/

Patch 3: Reinette: Keep the "RCU" in the kerneldoc description of the
domain list fields after the split into separate ctrl/mon lists.

Patch 4: No change

Patch 5: No change

Patch 6: Drop the change that divided output of the resctrl "size" file
by the number of SNC domains per L3 cache. Now that this series
preserves the contents of the legacy llc_occupancy files this isn't
useful.

Patch 7: NEW in this series. Add per-SNC domain monitor files while
making the original files sum across SNC nodes.

Patch 8: (formerly 7) No change

Patch 9: (formerly 8) Add documentation for new per-SNC directories and files

Tony Luck (9):
  x86/resctrl: Prepare for new domain scope
  x86/resctrl: Prepare to split rdt_domain structure
  x86/resctrl: Prepare for different scope for control/monitor
    operations
  x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
  x86/resctrl: Add node-scope to the options for feature scope
  x86/resctrl: Introduce snc_nodes_per_l3_cache
  x86/resctrl: Add new monitor files for Sub-NUMA cluster (SNC)
    monitoring
  x86/resctrl: Sub NUMA Cluster detection and enable
  x86/resctrl: Update documentation with Sub-NUMA cluster changes

 Documentation/arch/x86/resctrl.rst        |  17 +
 include/linux/resctrl.h                   |  89 +++--
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h    |  72 ++--
 arch/x86/kernel/cpu/resctrl/core.c        | 430 ++++++++++++++++++----
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  57 +--
 arch/x86/kernel/cpu/resctrl/monitor.c     |  98 +++--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  26 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 263 ++++++++-----
 9 files changed, 759 insertions(+), 294 deletions(-)


base-commit: 931be446c6cbc15691dd499957e961f4e1d56afb
-- 
2.44.0

