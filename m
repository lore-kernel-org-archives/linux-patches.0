Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF54019EEA4
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520749; cv=none; b=JotSkFUunep1PTUmKrh7j64d3ZhVDDd8mq7HAC/B/n7svgo3RpYvk5zF4aakDFELSlGs+TzQpBbhiVyUc9kzM4p0oBvCAEwgf4fM2joZCMN6zOA4M2dEFyWChmC0q2m2FmTCEpne2gmozBrCje/xDsYsYXcXKRBnB8Uoeo3O0WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520749; c=relaxed/simple;
	bh=Fpi8dKpc/aSIGObd8djhbtVHnDpvRY2Lj3a9IGqpQO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Mf5SDYNsMP29o+y5C7JNODUOe0kxjPC23GBA3zA63Bn+TpmuxzdJBJvkFUfFT8EkzsUOP4FLe95mwRU6VQ5RUtnTFuPveSZKG4kgWZuYX13oHKXyxvySSBMZzTvSMSeUNl5IZ4s1sbAOAUmL6mf2YnthgLGrl94qaBj/o8XYIUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JOtXMdKG; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JOtXMdKG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719520747; x=1751056747;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Fpi8dKpc/aSIGObd8djhbtVHnDpvRY2Lj3a9IGqpQO4=;
  b=JOtXMdKGt+iV6fNahoHL+qbBXq+F3dNFSyzUxGhDLKXqkYUrkHa960/R
   kvlx8I59BVuNg9hnH/XfGsLP+ufczOOROFm8vb8uNqElpDk/SNq5t5a/v
   gwoTzSFKtNoer902QlFcrlYeRP+jeP5Nn0FmMPCUpinp79JmTHp81Ntbc
   +0tA8zPD7eQ55Xdibf9hQOU7s505HfK7dOljzZ4X8G02Exb/6g5owI2Is
   M692E/VQA7CuZwmeFmvLUmCSzrHwleG82kLB8PkRqO5uyJ0zQGQEPsjSd
   TFCRVB+pp6jKlbyJxi9aeY/eEE80gtWXWZczNLJYBEul4Z31/9BFpbwIi
   g==;
X-CSE-ConnectionGUID: JExV4pbBSJyizo8wPxF+/w==
X-CSE-MsgGUID: WMUwLd5STqKIT2mYdBwU5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16809739"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16809739"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:07 -0700
X-CSE-ConnectionGUID: UGRXpHaHQk2ReUOOeQKoAw==
X-CSE-MsgGUID: 6zK+IIfMQbCWeztBH2dGUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="82052876"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:06 -0700
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
Subject: [PATCH v22 00/18] Add support for Sub-NUMA cluster (SNC) systems
Date: Thu, 27 Jun 2024 13:38:38 -0700
Message-ID: <20240627203856.66628-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
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
Changes since v21: https://lore.kernel.org/all/20240621223859.43471-1-tony.luck@intel.com/

1-6	No change
7-8	Added Reinette reviewed-by tag
9	s/contains the sum/includes the sum/ in struct rmid_read kerneldoc
	Add initializer = {0} to all on-stack declarations of struct
	rmid_read (Reinette comment against patch 14, but applied here
	when new field added that causes the ambguity about which fields
	will be consumed). Drop redundant assignmnets of 0/NULL/false
	to members of the structure.
10	Trivial refactor casued by addition of "= {0}" in part 9.
11	No change
12	Added Reinette reviewed-by tag
13	Replaced comment referencing SNC mode with more generic text
	suggested by Reinette.
	Added Reinette reviewed-by tag.
14	s/across all SNC domains/across all SNC domains/ in comment
	in rdtgroup_mondata_show()
	Dropped "rr.ci = NULL;". Not needed as struct is cleared by compiler.
15	Fix comment on return value from __mon_event_count()
16	Added Reinette reviewed-by tag
17-18	No change

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
  x86/resctrl: Enable shared RMID mode on Sub-NUMA Cluster (SNC) systems
  x86/resctrl: Sub-NUMA Cluster (SNC) detection
  x86/resctrl: Update documentation with Sub-NUMA cluster changes

 Documentation/arch/x86/resctrl.rst        |  27 ++
 include/linux/resctrl.h                   |  88 ++++--
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h    | 108 +++++---
 arch/x86/kernel/cpu/resctrl/core.c        | 312 ++++++++++++++++------
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  89 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c     | 256 +++++++++++++++---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  27 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 281 ++++++++++++-------
 9 files changed, 865 insertions(+), 324 deletions(-)


base-commit: f385f024639431bec3e70c33cdbc9563894b3ee5
-- 
2.45.2

