Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA972DCC13
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881654; cv=none; b=N9ePv4E5UYa6JECTtLXT4QYIutJPdwf8fRJxw7LNezDWpFm/V0+M1xjWM1Nta8Wp6aRiQljNgnJCKAC4boSF3sv+6eLSaVdjrcg4m0M66GbGxj5NilTYQG6oywxFha0QuNbnyVFsrJqENznDTvjBX4RU4w4+oF/AQM1AHfbCoQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881654; c=relaxed/simple;
	bh=pPU0OhrTCDSGssCF1y5u0q+FgRA4eOc5McbphCbq01U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ul3bPv+BQ9WfP20jo7sB8gijpI20Hmtq6oVgiZ/VVrfB091KGuoc4d3px1lA7b9gzR4karTly4km6pwBtFhCHYLK6vSauCzydTLZ7GWP9C0IgZXCxUWEjVj9WuuH3JPCvYN+vfiEG+XoWLCoiTIVZ9zoliYKpt4uHdY5pGlqVgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZQ/kgmjH; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZQ/kgmjH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881653; x=1796417653;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pPU0OhrTCDSGssCF1y5u0q+FgRA4eOc5McbphCbq01U=;
  b=ZQ/kgmjHAqXqzLz+AcKDu9FAJmiybOLj67kz0X090f4PkZCSJGPqzJ27
   pOaXTho9uEQ9mgjHd2cgRuxXbyCSXpTPwO9FpV3VfhGA4HE5R3rNdUTOn
   aAHTjDYwcAIDm6mVb7PWjTLhRSyxNQjYCxuTnGgmcLJtVXpac9kw/7tnb
   baHWLSF8ZQ2dA8fnhDpsTDPUBFNITX1Kzr7sHDquC7hrKGO0oUESP6vlL
   lhGU3r+Jld4B1U2KnCtnLe+bML5I6B1R+t2VnbTD8Ebo2iy73BjwlPUOd
   ksORF5+yPSAVP4Uy/8V5n3+SAUeGO+9BS8/U+7/kC9V0FfES/r8DhI7gQ
   w==;
X-CSE-ConnectionGUID: oA/x+E1gQO6J8IEjaHEjzQ==
X-CSE-MsgGUID: YrGbOf/bRJKOdqzWGwRkVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69510829"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69510829"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:12 -0800
X-CSE-ConnectionGUID: yIokpgXVQ967UTkB8iR7mg==
X-CSE-MsgGUID: uVdfhauhTDiLAei1nh63Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752697"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:11 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v15 00/32] x86,fs/resctrl telemetry monitoring
Date: Thu,  4 Dec 2025 12:53:30 -0800
Message-ID: <20251204205404.12763-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patches based on Linus/master (after TIP changes for v6.19 merge window
were pulled). Snapshot Dec 3rd. Head at that point was commit a619fe35ab41
("Merge tag 'v6.19-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6")

Series available here:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v15

Changes since v14 was posted here:
https://lore.kernel.org/all/20251124185412.24155-1-tony.luck@intel.com/

--- 00/32 x86,fs/resctrl telemetry monitoring
Updated base and change log. Background section unchanged.

--- 01/32 x86,fs/resctrl: Improve domain type checking ---
No changes

--- 02/32 x86/resctrl: Move L3 initialization into new helper ---
No changes

--- 03/32 x86/resctrl: Refactor domain_remove_cpu_mon() ready for ---
"new domain structures" -> "a new domain structure"
"general domain actions" -> "the general domain action"

--- 04/32 x86/resctrl: Clean up domain_remove_cpu_ctrl() ---
No changes

--- 05/32 x86,fs/resctrl: Refactor domain create/remove using ---
Added Reinette RB tag

--- 06/32 fs/resctrl: Split L3 dependent parts out of ---
Deleted unnecessary empty line in __mon_event_count()
Added Reinette RB tag

--- 07/32 x86,fs/resctrl: Use struct rdt_domain_hdr when reading ---
Warn if assignable counter found on SNC system in __l3_mon_event_count_sum()

--- 08/32 x86,fs/resctrl: Rename struct rdt_mon_domain and ---
"new domain structures" -> "a new domain structure"

Fix kernel doc change mistakenly applied to rdt_hw_ctrl_domain, move it
to the definition of rdt_hw_l3_mon_domain

--- 09/32 x86,fs/resctrl: Rename some L3 specific functions ---
No changes

--- 10/32 fs/resctrl: Make event details accessible to functions ---
No changes

--- 11/32 x86,fs/resctrl: Handle events that can be read from any ---
Add WARN_ON_ONCE(rr->evt->any_cpu) before call to __l3_mon_event_count()

--- 12/32 x86,fs/resctrl: Support binary fixed point event ---
Move last paragraph of commit back to where it was in v13. Add extra
clarifying text "which reflects the contract with user space on how the
event values are displayed."

--- 13/32 x86,fs/resctrl: Add an architectural hook called for ---
No changes

--- 14/32 x86,fs/resctrl: Add and initialize rdt_resource for ---
In Subject: s/rdt_resource/a resource/

--- 15/32 fs/resctrl: Emphasize that L3 monitoring resource is ---
No changes

--- 16/32 x86/resctrl: Discover hardware telemetry events ---
Trimmed files included by intel_aet.c
Merged event_group::feature and event_group::name into a single
event_group::pfname field used to lookup the pmt_feature_id, for
console messages, and later for the rdt= boot parameter.
"the event group. NULL otherwise." -> "the event group, NULL otherwise."
Replace block comment above intel_aet_get_events()

--- 17/32 x86,fs/resctrl: Fill in details of events for guid ---
Fix line length in commit comment.
" these events " -> "these aggregator types"
Fix "Links:" for XML files to point to the specific blobs in github

--- 18/32 x86,fs/resctrl: Add architectural event pointer ---
No changes

--- 19/32 x86/resctrl: Find and enable usable telemetry events ---
Update changelog to mention that enabling events can fail and
what happens if none of the events in an event group can be enabled.
Pull addition of event_group::name from patch 24 to here. But call it
event_group::type instead.
Pull check for all events skipped here from patch 25.

--- 20/32 x86/resctrl: Read telemetry events ---
Reformat comment for intel_aet_read_event() with longer lines.
Added Reinette RB tag

--- 21/32 fs/resctrl: Refactor mkdir_mondata_subdir() ---
No changes

--- 22/32 fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp() ---
No changes

--- 23/32 x86,fs/resctrl: Handle domain creation/deletion for ---
No changes

--- 24/32 x86/resctrl: Add energy/perf choices to rdt boot option ---
Rewrote commit comment to match new implmenentation.
Documentation:
"all energy features" -> "all energy telemetry monitoring"
"the 0x12345 perf feature" -> "perf telemetry monitoring associated with guid 0x12345"
Defer mention of "insufficient RMID" to patch 25.

--- 25/32 x86/resctrl: Handle number of RMIDs supported by ---
Fix line lengths in commit message.
"from the call to" -> "by"
Add details of disable/force-enable of event groups with insufficient
RMIDs to commit message.
Set event_group::force_off for event groups with insufficient RMIDs
Make use of longer lines in comment about insufficient RMIDs
"Feature %s:0x%x not enabled" -> "%s %s:0x%x monitoring not enabled"
"No events enabled" check/message moved to patch 19

--- 26/32 fs/resctrl: Move allocation/free of ---
No changes

--- 27/32 x86,fs/resctrl: Compute number of RMIDs as minimum ---
No changes

--- 28/32 fs/resctrl: Move RMID initialization to first mount ---
No changes

--- 29/32 x86/resctrl: Enable RDT_RESOURCE_PERF_PKG ---
No changes

--- 30/32 fs/resctrl: Provide interface to create architecture ---
No changes

--- 31/32 x86/resctrl: Add debugfs files to show telemetry ---
No changes

--- 32/32 x86,fs/resctrl: Update documentation for telemetry ---
Add that user may enable at the individual guid granularity within energy/perf type.


Background
----------
On Intel systems that support per-RMID telemetry monitoring each logical
processor keeps a local count for various events. When the
MSR_IA32_PQR_ASSOC.RMID value for the logical processor changes (or when a
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

The INTEL_PMT_TELEMETRY driver provides intel_pmt_get_regions_by_feature()
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
  x86,fs/resctrl: Improve domain type checking
  x86/resctrl: Move L3 initialization into new helper function
  x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Clean up domain_remove_cpu_ctrl()
  x86,fs/resctrl: Refactor domain create/remove using struct
    rdt_domain_hdr
  fs/resctrl: Split L3 dependent parts out of __mon_event_count()
  x86,fs/resctrl: Use struct rdt_domain_hdr when reading counters
  x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain
  x86,fs/resctrl: Rename some L3 specific functions
  fs/resctrl: Make event details accessible to functions when reading
    events
  x86,fs/resctrl: Handle events that can be read from any CPU
  x86,fs/resctrl: Support binary fixed point event counters
  x86,fs/resctrl: Add an architectural hook called for each mount
  x86,fs/resctrl: Add and initialize a resource for package scope
    monitoring
  fs/resctrl: Emphasize that L3 monitoring resource is required for
    summing domains
  x86/resctrl: Discover hardware telemetry events
  x86,fs/resctrl: Fill in details of events for guid 0x26696143 and
    0x26557651
  x86,fs/resctrl: Add architectural event pointer
  x86/resctrl: Find and enable usable telemetry events
  x86/resctrl: Read telemetry events
  fs/resctrl: Refactor mkdir_mondata_subdir()
  fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp()
  x86,fs/resctrl: Handle domain creation/deletion for
    RDT_RESOURCE_PERF_PKG
  x86/resctrl: Add energy/perf choices to rdt boot option
  x86/resctrl: Handle number of RMIDs supported by RDT_RESOURCE_PERF_PKG
  fs/resctrl: Move allocation/free of closid_num_dirty_rmid[]
  x86,fs/resctrl: Compute number of RMIDs as minimum across resources
  fs/resctrl: Move RMID initialization to first mount
  x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
  fs/resctrl: Provide interface to create architecture specific debugfs
    area
  x86/resctrl: Add debugfs files to show telemetry aggregator status
  x86,fs/resctrl: Update documentation for telemetry events

 .../admin-guide/kernel-parameters.txt         |   7 +-
 Documentation/filesystems/resctrl.rst         | 102 +++-
 include/linux/resctrl.h                       |  67 ++-
 include/linux/resctrl_types.h                 |  11 +
 arch/x86/kernel/cpu/resctrl/internal.h        |  48 +-
 fs/resctrl/internal.h                         |  68 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 230 ++++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 472 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  50 +-
 fs/resctrl/ctrlmondata.c                      | 113 ++++-
 fs/resctrl/monitor.c                          | 365 +++++++++-----
 fs/resctrl/rdtgroup.c                         | 293 +++++++----
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 14 files changed, 1441 insertions(+), 399 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: a619fe35ab41fded440d3762d4fbad84ff86a4d4
-- 
2.51.1

