Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A1B2B9D7
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044540; cv=none; b=puaL9R0yjyGvjA4ksrXjUgwgTSc7oVOreCfJ+SZsT7rGZs84cLdZqtl1B4GnWiGkltdzTg/3OTCRq3virgoMxBLB6fvRYOHdaTVxM4F4es1WO3XsgGbeHw0t3IlgDMIgtIhKC6pcLMXge9sC4uYtvd7sca1dBuc5qC9hvvGEDcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044540; c=relaxed/simple;
	bh=dJcTlWDkO2UoALFvL7D4Mxe/atJMB1RpgJHRiyQhQRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u/v54b2UfOHT6GD+K7R4YKyKyRum4OqNgmL7ILsMXHig7xVSV5GjWutsKOfTWnD7PBLYfqRac46ogMnvpINmFdgG0gTbIOB/FDOJW5ORrrpXkLzrWJ9xMVnGV7RZF2yB+IseeTh9Ub+dYlfDinJ9pkGBDsQd14gVay+wi++UNmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G00ZCdb6; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G00ZCdb6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044538; x=1749580538;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dJcTlWDkO2UoALFvL7D4Mxe/atJMB1RpgJHRiyQhQRU=;
  b=G00ZCdb6nOkZdBGYbv8bcnPVUu2ES/XYpfjLVeCjpZ9a94CoD9NG82Tq
   R4Z5hZh8NwmI/GUFdBjEbcekFxQ1CI454awdzU8IzYM/OWfLCePsrG4DV
   2h5Obkpv3QIgyPYUJ75lxmjlsIqiO5jCAf48gJ1fJogIURjzZyCOojuIf
   Y2T+z6pxbJPCjU8JzBZVKKkqftZJCQpEUhg0W2wLstT6G8bUjsYlxDhnu
   PUmXtMVXv00bJQ74weaKKlWfeRqAGfH1xEFfWM7c+TJpURBK7e/4jCPoT
   wOV6DGkfhUG7F74bb3kZeF2OU+wclXvyNjujl+8SIXHz5N2ygsObgWDLr
   g==;
X-CSE-ConnectionGUID: NKVUn1peRQ6NIXGVbEmPCg==
X-CSE-MsgGUID: AmQrB1SaQ5mHTjHMEoqOsA==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004767"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004767"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:37 -0700
X-CSE-ConnectionGUID: RsBqaON0QQGV4I6mzTTKFw==
X-CSE-MsgGUID: JBEkpbGsQceoUHGCOVYobQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576544"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:37 -0700
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
Subject: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
Date: Mon, 10 Jun 2024 11:35:10 -0700
Message-ID: <20240610183528.349198-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series based on top of tip x86/cache commit f385f0246394
("x86/resctrl: Replace open coded cacheinfo searches")

The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
that share an L3 cache into two or more sets. This plays havoc with the
Resource Director Technology (RDT) monitoring features.  Prior to this
patch Intel has advised that SNC and RDT are incompatible.

Some of these CPUs support an MSR that can partition the RMID counters
in the same way. This allows monitoring features to be used. Legacy
monitoring files provide the sum of counters from each SNC node for
backwards compatibility. Additional  files per SNC node provide details
per node.

Memory bandwidth allocation features continue to operate at
the scope of the L3 cache.

L3 cache occupancy and allocation operate on the portion of
L3 cache available for each SNC node.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Changes since v19: https://lore.kernel.org/all/20240528222006.58283-1-tony.luck@intel.com/

1-4:	Refactor on top of <linux/cacheinfo.h> change.
	Nothing functional.

5:	No change

6:	Updated commit message with note about RMID Sharing mode.
	Renamed __rmid_read() to __rmid_read_phys() and performed
	translation from logical RMID to physical RMID at callsites.
	Updated comment for __rmid_read_phys() with explanation of
	logical/physical RMIDs. Consistently use "SNC node" avoid
	SNC domain. Add specifics for non-SNC mode.
	Joined split line on __rmid_read() definition (even with the
	added "_phys" to its name still fits on one line.

7:	No change

8:	get_cpu_cacheinfo_level() moved to <linux/cacheinfo.h>
	currently in tip x86/cache
	no other changes

9:	Dropped the "sumdomains" field from struct rmid_read (a NULL
	domain field now indicates that summing is needed).
	Fix kerneldoc comments for struct rmid_read.
	Updated commit comments with more "why" than "what".

10:	No change

11:	Fix commit comments per suggestions
	1) Added some "why it is OK to take a bit from evtid"
	2) s/The stolen bit is given to/Give the bit to/
	3) Don't use "l3_cache_id" (which looks like a variable)

12:	Fix commit message.
	s/kernfs_find_and_get_ns()/kernfs_find_and_get()/
	Add kernfs_put() to drop hold from kernfs_find_and_get()
	Drop useless "/* create the directory */" comment.

13:	Add kernfs_put() to drop hold from kernfs_find_and_get() [two places]

14:	Add cpumask parameter to mon_event_read() so SNC decsions are
	all in rdtgroup_mondata_show() instead of spread between functions.
	Add comments in rdtgroup_mondata_show() to explain the sum vs. no-sum
	cases.
	Moved the mon_event_read() call into both arms of the if-else
	instead of "d = NULL; goto got_cacheinfo;"

15:	New (replaces 15-17). Make __mon_event_read() do the sum across
	domains (at filesystem level). Move the CPU/domain sanity check out
	of resctrl_arch_rmid_read() and into __mon_event_read()
	with separate scope tests for single domain vs. sum over
	domains.

16:	[Was 18] Update commit message with details about MSR 0xCA0, what changes
	when bit 0 is cleared, and why this is necessary.
	Dropped "Add an architecture specific hook" language from
	commit message.

17:	[Was 19] Drop "and enabling" from shortlog (enabling done by
	previous commit).
	Added checks that cpumask_weight() isn't returning zero (to keep
	static checkers from warning of possible divide by zero).

18:	[Was 20] Fix some "Sub-NUMA" references to say "Sub-NUMA Cluster"
	Added document section on effect of SNC mode on MBA and L3 CAT.

Tony Luck (18):
  x86/resctrl: Prepare for new domain scope
  x86/resctrl: Prepare to split rdt_domain structure
  x86/resctrl: Prepare for different scope for control/monitor
    operations
  x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
  x86/resctrl: Add node-scope to the options for feature scope
  x86/resctrl: Introduce snc_nodes_per_l3_cache
  x86/resctrl: Block use of mba_MBps mount option on Sub-NUMA Cluster
    (SNC) systems
  x86/resctrl: Prepare for new Sub-NUMA Cluster (SNC) monitor files
  x86/resctrl: Add a new field to struct rmid_read for summation of
    domains
  x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
  x86/resctrl: Allocate a new field in union mon_data_bits
  x86/resctrl: Create Sub-NUMA Cluster (SNC) monitor files
  x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC)
    mode
  x86/resctrl: Fill out rmid_read structure for smp_call*() to read a
    counter
  x86/resctrl: Make __mon_event_count() handle sum domains
  x86/resctrl: Enable RMID shared RMID mode on Sub-NUMA Cluster (SNC)
    systems
  x86/resctrl: Sub-NUMA Cluster (SNC) detection
  x86/resctrl: Update documentation with Sub-NUMA cluster changes

 Documentation/arch/x86/resctrl.rst        |  27 ++
 include/linux/resctrl.h                   |  87 ++++--
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h    |  93 +++++--
 arch/x86/kernel/cpu/resctrl/core.c        | 312 ++++++++++++++++------
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  85 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c     | 242 ++++++++++++++---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  27 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 272 ++++++++++++-------
 9 files changed, 835 insertions(+), 311 deletions(-)


base-commit: f385f024639431bec3e70c33cdbc9563894b3ee5
-- 
2.45.0

