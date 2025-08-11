Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C65A2E0B58
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936253; cv=none; b=qu+EpSGEldHlIiUhCdTodhvNSrYqu5201guKdkq1aXAwM5Tum7ZJXl8qu7LVR1YVORM71Gs7hiAri65QYmeLjLlvO3aRcaAh4AbO0/gUt3mxkM5dHQZxPiPZXh0H0F/PwRdmUUDkpw9Sflgh2N/PpWgkMG2nTq1frdsA8DuNxPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936253; c=relaxed/simple;
	bh=ii79c4ISWb/lNs5MQ5mEkn92GMWBsG3qt8NnwCuimjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AiYzLJ5oDF2DYw1vBsfbIdc4UKEXi2bimdutiJW4L1KgkxyODTPKjq0I63GnYjaf1V3ghrYgk+yayfKLjq4W/ay2H1u1pNKRjmfSL8qH30zwrzeRoMM5sdS44MBoP0Zx4UDKFsRkFUVx0WLIjRAjsdIiz9qq6yqYLz0espkwP2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SYiYowos; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SYiYowos"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936252; x=1786472252;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ii79c4ISWb/lNs5MQ5mEkn92GMWBsG3qt8NnwCuimjI=;
  b=SYiYowosi44HbRF7gY6YlCDzgIn0BCSKMck4VRMdMROso3Ey1vZ1Ide1
   1FL98jAx52PqxnlKHHXFsQzY+Nv1UnOgKKnOyTTHGCq9E6lacyLfuwzXz
   U/Md2np7dhCu/nngA+qGF3Zqp4TgdT9d/rY0nNNAEUKc8Ow4SFTws9UMx
   tBExsgqz8OkAp9HaMs7LpJq28GJNzH8jKj1kYSMf5ePcaAA2igxhU8mjW
   G8PGdHvGFiX25lJvEs6EVmiaWOWqy+M/aMz3eZnW6fmKtFvC1LFEtSXmf
   rkXuu+IrPNvxATxpmAycDS3eUjFdR6P88ZYEVMq0mt6v/Ytao7DWc2RqI
   g==;
X-CSE-ConnectionGUID: c+wKgvkPQlWZeOEIx2UBEw==
X-CSE-MsgGUID: oBGofw18Q0OfWDlVhDmNQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277330"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277330"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
X-CSE-ConnectionGUID: CCliOEhiRhquDDoQh5E10g==
X-CSE-MsgGUID: VmPL7tZKT6GMqmnBHqZPog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825609"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Date: Mon, 11 Aug 2025 11:16:34 -0700
Message-ID: <20250811181709.6241-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The prerequisite patch series to the Intel Telemetry code is
now in upstream v6.17-rc1. So that's the basis for this series
with no extra dependencies.

This patch series also available from the rdt-aet-v8 of:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git

Changes since v7 was posted here:
Link: https://lore.kernel.org/all/20250711235341.113933-1-tony.luck@intel.com/

--- cover ---
Removed references to dependencies, there are none.
Updated change log.

--- 1 ---
Added Reinette RB tag

--- 2 ---
No change

--- 3 ---
No change

--- 4 ---
No change

--- 5 ---
Improved problem/solution descriptions in commit comment.

--- 6 ---
Added "break" to default case in domain_add_cpu_mon()

Improved commit problem description. Dropped "function"
when referring to name with "()".

--- 7 ---
Improve context statement in commit comment.
Add a problem statement.
Apply suggestions to fix portion of commit comment.

--- 8 ---
In domain_remove_cpu_ctrl() s/&d->hdr.list/&hdr->list/

--- 9 ---
Avoid double WARN_ON_ONCE() in __mon_event_count() and mbm_bw_count().
Move domain_header_is_valid() in mkdir_mondata_subdir() to where
it is needed before container_of().

Fix commit comment to use present tense for background information
and imperative for the changes. Separate problem statement into
its own paragraph.

--- 10 ---
Fix commit comment to use present tense for background information.
Separate problem statement into own paragraph.

--- 11 ---
Move these renames here from patch 26:
resctrl_mon_resource_init -> resctrl_mon_l3_resource_init()
resctrl_mon_resource_exit() -> resctrl_mon_l3_resource_exit()

--- 12 ---
Clean up commit comment with problem statement in its own
paragraph, and with better description.
Keep original kerneldoc for rmid_read::evt

--- 13 ---
Changed comment for cpu_on_correct_domain() as suggested.
Move WARN_ON_ONCE() check for L3 resource from __mon_event_count
to cpu_on_correct_domain().
Fix commit comments as suggested.

--- 14 ---
Break long line in declaration of resctrl_enable_mon_event()
Reformat comments in print_event_value() use more horizontal space.
s/binary_bit/binary_bits/. s/chosemn/chosen/
Commit comment cleanups to use present tense for background and
imperative for solution.

--- 15 ---
Enumeration of telemetry features is performed by sub-drivers
of the OOBMSM driver. These are loaded during device_init() time,
but the probe functions are triggered by deferred_probe_work_func()
which can happen after resctrl_init().
Tracing this procedure shows that it completes several seconds before
the earliest possible mount of the resctrl file system.

Updated Kconfig dependencies to require INTEL_TPMI=y so that all
drivers needed for enumeration are built in.

Fix commit to use imperative tone.

--- 16 ---
Drop "core" from Subject line.
s/these events/telemetry events/
Merge two solution paragraphs into one.

--- 17 ---
s/CONFIG_X86_RESCTRL_CPU_INTEL_AET/CONFIG_X86_CPU_RESCTRL_INTEL_AET/
Make it depend on INTEL_PMT_TELEMETRY instead of INTEL_PMT_DISCOVERY.
Defer addition of active_event_groups list until patch 19.
Drop NUM_KNOWN_* macros and open code ARRAY_SIZE() at point of use.
s/Try to use any with a known matching guid/
Try to use every telemetry aggregator with a known guid/
Change type of "ret" in get_pmt_feature() from bool to int.
Rewrote commit changelog to provide more details on how telemetry
aggregators are connected to MMIO regions and to event groups.

--- 18 ---
Move the "Sanity check" description in the commit message to before the
"Scan the array" and rewrite to describe which regions are usable by
Linux. s/package_id/package id/
Pull extra blank line in discover_events() into this patch from patch 19.

--- 19 ---
s/addresses of the telemetry regions used by each aggregator/
addresses of the telemetry regions/
Drop unneeded call to free_pkg_mmio_info((*peg)->pkginfo);
s/for each aggregator/for each region/
s/struct mmio_info/struct pkg_mmio_info/
Change ascii art to note that we can support "M" aggregators in
one package and "N" in another (which the code can support, but
likely will not happen in practice).
Implement active_event_groups list (previously scattered between
patches 16-20)


--- 20 ---
Moved stray list_add(&e->list, &active_event_groups); into patch 19
where it belongs.
Fixed kerneldoc comment for pmt_event::bin_bits to say this is number
of bits in the fraction part of fixed-point.
Add closing quote around "energy" in commit comment.

--- 21 ---
s/passed/passes/ s/rmid/RMID/
Point out the explicit problem being solved with example of telemetry
counters needing the offset in MMIO space.

--- 22 ---
Drop local "eventid" in discover_events(). Use e->evts[i].id directly.
Change intel_aet_read_event() to return success if ANY aggregator has
valid data instead on only when ALL are valid. This matches existing
resctrl behaviour for providing a summed value for a CTRL_MON group
together with all child MON groups.
Restructure commit message to include details of how events are enabled
with an arch_priv pointer to the pmt_event.

--- 23 ---
Move setup_intel_aet_mon_domain() from arch/x86/kernel/cpu/resctrl/core.c
to arch/x86/kernel/cpu/resctrl/intel_aet.c. Rename to
intel_aet_setup_mon_domain() to match pattern of other functions. Add
a stub to arch/x86/kernel/cpu/resctrl/internal.h for when
CONFIG_X86_CPU_RESCTRL_INTEL_AET is not set.
s/Intel-PMT-scoped/package scoped/

--- 24 ---
"that support is present" -> "that hardware support is present"
s/option/feature/

--- 25 ---
In check_rmid_count() change test to "if (tr->num_rmids < e->num_rmids)"
(i.e. if the number of hardware counters in the aggregator is fewer
than the number of counter locations in the MMIO region).
Eliminate the rdt_num_system_rmids variable.
"features" -> "feature's" (in comment for rdt_set_feature_disabled())
"h/w" -> "hardware" (three places in commit comment).

--- 26 ---
Function renames pulled into patch 11.
Drop the helper functions, just move the code to alloc/free
closid_num_dirty_rmid[] inline intoresctrl_mon_l3_resource_init()
and resctrl_mon_l3_resource_exit().
Fix leak of closid_num_dirty_rmid[] in resctrl_mon_l3_resource_init()
when dom_data_init() fails.
Note in commit comment that this change is prep for moving
the allocation rmid_ptrs[] to mount time.

--- 27 ---
Split into two parts:
0027:
	Update resctrl_arch_system_num_rmid_idx() to compute minimum
	RMID across resources.
0028: 
	Better function names.
	Rename: dom_data_init() -> setup_rmid_lru_list()
	Rename: dom_data_exit() -> free_rmid_lru_list()
	Move calls out of resctrl_mon_l3_resource_{init,exit}() and into
	rdt_get_tree(), resctrl_exit()
	Fix comment in setup_rmid_lru_list() about setup of rdtgroup_default.

--- 28 ---
Add check that RDT_RESOURCE_PERF_PKG resource is mon_capable. Also
set global rdt_mon_capable (to cover the case where there are no
enabled L3 monitor events).

--- 29 ---
Move declaration of debugfs_resctrl_info next to debugfs_resctrl.
s/debugs/debugfs/
Separate problem from context in commit comment.

--- 30 ---
Unchanged

--- 31 ---
Unchanged

Background
----------
On Intel systems that support per-RMID telemetry monitoring each logical
processor keeps a local count for various events. When the
IA32_PQR_ASSOC.RMID value for the logical processor changes (or when a
two millisecond counter expires) these event counts are transmitted to
an event aggregator on the same package as the processor together with
the current RMID value. The event counters are reset to zero to begin
counting again.

Each aggregator takes the incoming event counts and adds them to
cumulative counts for each event for each RMID. Note that there can be
multiple aggregators on each package with no architectural association
between logical processors and an aggregator.

All of these aggregated counters can be read by an operating system from
the MMIO space of the Out Of Band Management Service Module (OOBMSM)
device(s) on a system. Any counter can be read from any logical processor.

Intel publishes details for each processor generation showing which
events are counted by each logical processor and the offsets for each
accumulated counter value within the MMIO space in XML files here:
https://github.com/intel/Intel-PMT.

For example there are two energy related telemetry events for the
Clearwater Forest family of processors and the MMIO space looks like this:

Offset  RMID    Event
------  ----    -----
0x0000  0       core_energy
0x0008  0       activity
0x0010  1       core_energy
0x0018  1       activity
...
0x23F0  575     core_energy
0x23F8  575     activity

In addition the XML file provides the units (Joules for core_energy,
Farads for activity) and the type of data (fixed-point binary with
bit 63 used to indicate the data is valid, and the low 18 bits as a
binary fraction).

Finally, each XML file provides a 32-bit unique id (or guid) that is
used as an index to find the correct XML description file for each
telemetry implementation.

The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()
to enumerate the aggregator instances (also referred to as "telemetry
regions" in this series) on a platform. It provides:

1) guid  - so resctrl can determine which events are supported
2) MMIO base address of counters
3) package id

Resctrl accumulates counts from all aggregators on a package in order
to provide a consistent user interface across processor generations.

Directory structure for the telemetry events looks like this:

$ tree /sys/fs/resctrl/mon_data/
/sys/fs/resctrl/mon_data/
mon_data
├── mon_PERF_PKG_00
│   ├── activity
│   └── core_energy
└── mon_PERF_PKG_01
    ├── activity
    └── core_energy

Reading the "core_energy" file from some resctrl mon_data directory shows
the cumulative energy (in Joules) used by all tasks that ran with the RMID
associated with that directory on a given package. Note that "core_energy"
reports only energy consumed by CPU cores (data processing units,
L1/L2 caches, etc.). It does not include energy used in the "uncore"
(L3 cache, on package devices, etc.), or used by memory or I/O devices.


Signed-off-by: Tony Luck <tony.luck@intel.com>


Tony Luck (32):
  x86,fs/resctrl: Consolidate monitor event descriptions
  x86,fs/resctrl: Replace architecture event enabled checks
  x86/resctrl: Remove 'rdt_mon_features' global variable
  x86,fs/resctrl: Prepare for more monitor events
  x86,fs/resctrl: Improve domain type checking
  x86/resctrl: Move L3 initialization into new helper function
  x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Clean up domain_remove_cpu_ctrl()
  x86,fs/resctrl: Use struct rdt_domain_hdr instead of struct
    rdt_mon_domain
  x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain
  x86,fs/resctrl: Rename some L3 specific functions
  fs/resctrl: Make event details accessible to functions when reading
    events
  x86,fs/resctrl: Handle events that can be read from any CPU
  x86,fs/resctrl: Support binary fixed point event counters
  x86,fs/resctrl: Add an architectural hook called for each mount
  x86,fs/resctrl: Add and initialize rdt_resource for package scope
    monitor
  x86/resctrl: Discover hardware telemetry events
  x86/resctrl: Count valid telemetry aggregators per package
  x86/resctrl: Complete telemetry event enumeration
  x86,fs/resctrl: Fill in details of events for guid 0x26696143 and
    0x26557651
  x86,fs/resctrl: Add architectural event pointer
  x86/resctrl: Read telemetry events
  x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
  x86/resctrl: Add energy/perf choices to rdt boot option
  x86/resctrl: Handle number of RMIDs supported by telemetry resources
  fs/resctrl: Move allocation/free of closid_num_dirty_rmid
  fs,x86/resctrl: Compute number of RMIDs as minimum across resources
  fs/resctrl: Move RMID initialization to first mount
  x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
  fs/resctrl: Provide interface to create architecture specific debugfs
    area
  x86/resctrl: Add debugfs files to show telemetry aggregator status
  x86,fs/resctrl: Update Documentation for package events

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         |  85 +++-
 include/linux/resctrl.h                       |  89 +++-
 include/linux/resctrl_types.h                 |  26 +-
 arch/x86/include/asm/resctrl.h                |  16 -
 arch/x86/kernel/cpu/resctrl/internal.h        |  56 ++-
 fs/resctrl/internal.h                         |  68 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 310 ++++++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 448 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  76 +--
 fs/resctrl/ctrlmondata.c                      | 123 ++++-
 fs/resctrl/monitor.c                          | 310 ++++++------
 fs/resctrl/rdtgroup.c                         | 272 +++++++----
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 15 files changed, 1442 insertions(+), 453 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.50.1

