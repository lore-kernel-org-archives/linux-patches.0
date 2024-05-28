Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B9213DDAC
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934816; cv=none; b=IXR9ih3Zql/LtYV/og09SdcxK52wd0lTAYXi6/iZTJbWGS83fPm369OaM9A/dCdEmLZyBnhlmDDH0d3UgUV7xgAE8bxrh6ToGF+wJjY9E4zfZlx7DmvcxQQJGfIiWNxSmPS8Pqqx5TfJb+5PYUwOo2Dv1eeJB2W7Lc+mx5GQNjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934816; c=relaxed/simple;
	bh=1I4ob/028vRfyCLxoiKt+1CBaFw3ZVv+FUPY8ulR6hA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VrOugXvZGZKkkvF+JsKxpMpX0TqbTLnbnpEJQLqU/0f2vPVIiN21Zz1PVK9JlviClNqYVpxL5iVmmUmfHZbooXk/2H3pU2JarY1mk7vjp/539EUd6biivfL/IhyrX6TEIO+23d8NUcCiAPfQtWszKkTnz/RfMdeFm37fwGUXetM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UIzTFzvd; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UIzTFzvd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934815; x=1748470815;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1I4ob/028vRfyCLxoiKt+1CBaFw3ZVv+FUPY8ulR6hA=;
  b=UIzTFzvdT/ThRKMYhLTc9nOvB8LydI4+PMKqI2hfuk9/Twz94S1oC5j6
   c342g34YFlhuqOH04APf0tziIuYVhY/S/bwg298SF5GAj287jKon2xfZa
   2YL89UODMbBNpUc6gSSM2B8NH4eWdVFzu+YE/ZFUXpG23QmFWqpBhQMK1
   t9ASITEY1SGKC3jzrJvUGfG1djm7jSfD10hSCMYZljo8OuWBGZwX8osLS
   GkeehW0a3HASSaHdbBHjWnhDqLf4aj3J8KeVsWwf6RBPawF1iWdpzlodM
   y/cVd2Xt9PMGZAAuIiInFqsD75Y/EJkoI5wOunamveUlWkwV2WwspftWT
   A==;
X-CSE-ConnectionGUID: GJIwqPuJSJWrFuUkFZraVQ==
X-CSE-MsgGUID: y+dmpG/QS320qH6dQdtwLg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812132"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812132"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:15 -0700
X-CSE-ConnectionGUID: 9x+SBnQwSom7pveZtmbuIg==
X-CSE-MsgGUID: x18OglZGRpW/1+FNvvFvwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090709"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:14 -0700
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
Subject: [PATCH v19 00/20] Add support for Sub-NUMA cluster (SNC) systems
Date: Tue, 28 May 2024 15:19:45 -0700
Message-ID: <20240528222006.58283-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series based on top of Linus upstream commit 33e02dc69afb ("Merge
tag 'sound-6.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound")

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
Changes since v18: https://lore.kernel.org/all/20240515222326.74166-1-tony.luck@intel.com/

Global: Consistent use of "Sub-NUMA Cluster (SNC)"

1-4:	No change

5:	Rename RESCTRL_NODE as RESCTRL_L3_NODE to make it clear that
	these "nodes" are each subsets of L3 cache instances.

6:	Changes for snc_nodes_per_l3_cache are localized to monitor.c
	Don't use it in decision block use of mba_MBps option.
	Moved the old get_node_rmid() function here, but renamed it to
	logical_rmid_to_physical_rmid() with a block comment explaining
	how RMIDs are distributed when SNC is enabled. Function now
	checks if snc_nodes_per_l3_cache == 1 for fast return.

7:	New patch. Only allow mba_MBps option if scope of MBM matches MBA

8:	Replaces old patch 8. "display_id" field is no more. Add and
	initialize the @ci (struct cachinfo *) to rdt_mon_domain.
	Note that the new get_cpu_cacheinfo_level() helper function is
	added to internal.h as it will also be needed by patch 19.

9:	Instead of display_id, add pointer to cacheinfo structure to
	struct rmid_read. Add kerneldoc description of existing and
	new fields.

10:	Added to commit comment describing why mkdir_mondata_subdir()
	needs to be refactored.

11:	Dropped Intel specific description of fields in the mon_evt
	structure. Say that choice of bit to steal was arbitrary, but
	can be changed in the future.

12:	Fixed typo s/and file/and files/ in commit message. Now using
	the cacheinfo structure (specifically "id" field) instead of
	display_id.

13:	Wordsmith commit into imperative.
	I looked at using kobject_has_children() to check for empty
	directory, but it needs a "struct kobject *" and all I have
	is "struct kernfs_node *". I'm now checking how many CPUs
	remain in ci->shared_cpu_map to detect whether this is the
	last SNC node.
	s/kernfs_find_and_get_ns/kernfs_find_and_get/ in all places.
	Fix copy/paste error which used "pgrp" instead of "cgrp".
	Dropped the firtree fix for a function I hadn't touched.

	Old patch 14 split into 14, 15, 16
	The "wedging things until it works" path is gone. Instead
	of passing in a random SNC domain that has the right display_id
	code now makes use of cacheinfo both to get the L3 id, and to
	pick the cpu mask for the smp_call*(). rr.d is now NULL in the
	sum case as suggested.

14:	New patch. Does the "top half" work of filling out the rmid_read
	structure prior to the smp_call*().

15:	Need to pass the cachinfo struct to resctrl_arch_rmid_read()

16:	When "sum", resctrl_arch_rmid_read() loops across domains sharing
	L3 cache.

17:	(was 15) sanity
	Removed "Fix" from the shortlog description. Use ci->shared_cpu_map
	in the sanity check for sum case.

18:	(new - split out from old 16) Try to do one thing at a time. Split
	the MSR 0xCA0 update code from the SNC detection code.

19:	(was 16) Fix typo s/couning/counting/
	Use upper case for first letter of messages.
	Use cpumask_weight() instead of bitmap_weight.

20:	(was 17) Dropped the "This patch needs updating" part of commit

Tony Luck (20):
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
  x86/resctrl: Add new fields to struct rmid_read for summation of
    domains
  x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
  x86/resctrl: Allocate a new bit in union mon_data_bits
  x86/resctrl: Create Sub-NUMA Cluster (SNC) monitor files
  x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC)
    mode
  x86/resctrl: Fill out rmid_read structure for smp_call*() to read a
    counter
  x86/resctrl: Pass two extra arguments to resctrl_arch_rmid_read()
  x86/resctrl: Make resctrl_arch_rmid_read() handle sum over domains
  x86/resctrl: Update CPU sanity checks when reading RMID counters
  x86/resctrl: Enable RMID shared RMID mode on Sub-NUMA Cluster (SNC)
    systems
  x86/resctrl: Sub-NUMA Cluster (SNC) detection and enabling
  x86/resctrl: Update documentation with Sub-NUMA cluster changes

 Documentation/arch/x86/resctrl.rst        |  17 ++
 include/linux/resctrl.h                   |  91 +++++--
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h    | 114 ++++++--
 arch/x86/kernel/cpu/resctrl/core.c        | 312 ++++++++++++++++------
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  74 +++--
 arch/x86/kernel/cpu/resctrl/monitor.c     | 220 ++++++++++++---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  27 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 265 +++++++++++-------
 9 files changed, 813 insertions(+), 308 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.0

