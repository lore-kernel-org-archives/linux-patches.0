Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7472E9EDF
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394841; cv=none; b=hKPPA0bKmwCobZPyIQ1ObRait4GQLU4pCPCnkXrFlPSVRn+MotduDXcbh2zDnicAJomBuz4J081a0f6NAJoBEn6P9ikHfGotvMZx0ZZ3/0AWMehrN37nJljjRv+2QgxnkwwkLJbvs8OIP+PF8LR3bHM5b9jZQmkylTdaLzNqMqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394841; c=relaxed/simple;
	bh=pTOR4ZC5OGrE7nL6f28w6TrKsRFrrqoXtXEi+oMUFgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SDdtxeez0rJuKbt0NyJZEN50E2EEfRm6UWOhr15r9SPsPtL7Jmzmzj19I2I888L8n3e6iMg49Vdlo6ECIPa7V5SpzzS8pYWg750NupOMuOZVuXqOVyHJaCXgqX/znNitT/QYs8aZAcVI76SkQKB8apElg1kHYreny60m7/iAZjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bla0wfTt; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bla0wfTt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394840; x=1791930840;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pTOR4ZC5OGrE7nL6f28w6TrKsRFrrqoXtXEi+oMUFgU=;
  b=bla0wfTtDRs0U5dTibenwuHOqxYWcRxOMMVZxIeKtll9HXl00it3DpAR
   FTc2XOuri641WX4D+PQxjUmGywS/ZKKbw0lRFFgcxUfMY/EbJQuYSjDfb
   PdO1sQLDilam0SVf5XRkiT+PTvq+sNRXr/LFvVnZBd/wHvvL59UnwUJAs
   mLdU3FbyI6F6kSfNmU4rR8IzbdX5fk+sRpNxTs2xoLJhbS328zS5cf45t
   FpLwi0L1XdIOu0OLsDf60T2JvubkKAMrXBNlXlrprYzfayskIASv38X6W
   aTd55EpZsjAAX1CHJG4jDBYsCZiUJxVx0+FmgZ2J5CCp1sc9YQeFYB47x
   A==;
X-CSE-ConnectionGUID: ECCqP08lSbeaH1A2pALjjQ==
X-CSE-MsgGUID: Fwzsh60RTvuTI64mOGW2Zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168739"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168739"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:33:59 -0700
X-CSE-ConnectionGUID: 4C9I9JcNSpOh9M2VMEbnEQ==
X-CSE-MsgGUID: 55RSFjEdRSWPOLnzaCtlHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145242"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:33:59 -0700
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
Subject: [PATCH v12 00/31] x86,fs/resctrl telemetry monitoring
Date: Mon, 13 Oct 2025 15:33:14 -0700
Message-ID: <20251013223348.103390-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patches based on tip tree x86/urgent branch

Top commit of x86/urgent at time of my snapshot was:
15292f1b4c55 ("x86/resctrl: Fix miscount of bandwidth event when reactivating
previously unavailable RMID")

Series available here:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v12

Changes since v11 was posted here:
Link: https://lore.kernel.org/all/20250925200328.64155-1-tony.luck@intel.com/

My usual convention, patches from v11 named "XX/28", patches in this
series when they have a different number as "00YY".

--- [PATCH v11 00/28] x86,fs/resctrl telemetry monitoring ---
"IA32_PQR_ASSOC.RMID" -> "MSR_IA32_PQR_ASSOC.RMID

--- [PATCH v11 01/28] x86,fs/resctrl: Improve domain type checking ---
Replace commit message with version suggested by Reinette

--- [PATCH v11 02/28] x86/resctrl: Move L3 initialization into new helper ---
Added Reinette RB tag

--- [PATCH v11 03/28] x86,fs/resctrl: Refactor domain_remove_cpu_mon() ---
Fix Subject. s/fs,x86/x86/
"L3 processing" -> "L3 domain processing"
"general actions" -> "general domain actions"
Move L3 specific local variable declarations into "case RDT_RESOURCE_L3:"

--- [PATCH v11 04/28] x86/resctrl: Clean up domain_remove_cpu_ctrl() ---
Reformat commit comment to use more page width.

--- [PATCH v11 05/28] x86,fs/resctrl: Refactor domain create/remove using ---
Replace commit message with version supplied by Reinette.
Fix mon_event_read(). If hdr is NULL, then "d" must be set to NULL.
Defer SNC related changes in mon_add_all_files() and mkdir_mondata_subdir()
to later patch.
Limit change in resctrl_offline_mon_domain() to check for valid
RDT_RESOURCE_L3 header (defer until adding RDT_RESOURCE_PERF_PKG).
Move  superfluous "err = 0" from resctrl_online_mon_domain() to
patch 0022 where it is needed after "goto mkdir;" is added.

--- [PATCH v11 06/28] x86,fs/resctrl: Use struct rdt_domain_hdr when ---
Handle "hdr == NULL" case in __mon_event_count(). Note that hdr is NULL
for the SNC "sum domains" case. That's orthogonal to both rr->is_mbm_cntr
and rr->first. Duplicated code will be cleaned up in later patch.

Update commit message with explanation of use of rmid_read structure.

--- [PATCH v11 07/28] x86,fs/resctrl: Rename struct rdt_mon_domain and ---
Added Reinette RB tag

--- [PATCH v11 08/28] x86,fs/resctrl: Rename some L3 specific functions ---
Pulled in kerneldoc changes that fix Return: for two of the renamed
functions from patch 31.
Added Reinette RB tag

--- [PATCH v11 09/28] fs/resctrl: Make event details accessible to ---
"more context" -> "more context than the event id"
"mon_evt" -> "struct mon_evt"
Added Reinette RB tag

--- [PATCH v11 10/28] x86,fs/resctrl: Handle events that can be read from ---
Replace 2nd paragraph of commit message with Reinette re-write.
Drop 3rd paragraph (just describes code change).
Replace 4th paragraph of commit message with Reinette re-write.

--- [PATCH v11 11/28] x86,fs/resctrl: Support binary fixed point event ---
Unchanged.

--- [PATCH v11 12/28] x86,fs/resctrl: Add an architectural hook called ---
Unchanged.

--- [PATCH v11 13/28] x86,fs/resctrl: Add and initialize rdt_resource for ---
Merged in the kerneldoc changes for mon_get_kn_priv(...do_sum) and mon_data::sum
from v11 patch 31
Added some WARN calls to confirm implicitly operating on RDT_RESOURCE_L3.

--- [PATCH v11 14/28] x86/resctrl: Discover hardware telemetry events ---
Modify get_pmt_feature() to handle the case where intel_pmt_get_regions_by_feature()
returns a list of telemetry regions with more than one guid known to resctrl
by getting a separate copy for each guid.
"IA32_PQR_ASSOC.RMID" -> "MSR_IA32_PQR_ASSOC.RMID"

--- [PATCH v11 15/28] x86,fs/resctrl: Fill in details of events for guid ---
Unchanged.

--- [PATCH v11 16/28] x86,fs/resctrl: Add architectural event pointer ---
Replace commit message with suggested text by Reinette.

--- [PATCH v11 17/28] x86/resctrl: Find and enable usable telemetry ---
Merge in mark_telem_region_unusable() function from patch 19.

--- PATCH v11 18/31] fs/resctrl: Refactor L3 specific parts of __mon_event_count() ---
Updated Subject.
Add checks for !rr->hdr before using in container_of().
Split out the L3 dependent code into a helper function.
Added Suggested-by; Reinette tag.

--- PATCH v11 19/31] x86/resctrl: Read telemetry events ---
Changes based on earlier updates to this series:
1) intel_aet_read_event() now checks for correct guid since more than one
   might be enabled because of changes in patch 11.
2) Add RDT_RESOURCE_PERF_PKG case to __mon_event_count()


--- PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in ---
NEW: 0020: Split mkdir_mondata_subdir() into SNC/non-SNC helpers
NEW: 0021: Split rmdir_mondata_subdir_allrdtgrp() into SNC/non-SNC helpers


--- PATCH v11 21/31] x86/resctrl: Handle domain creation/deletion for ---
Now 0022:
Move declaration of struct rdt_perf_pkg_mon_domain *pkgd inside case
RDT_RESOURCE_PERF_PKG in domain_remove_cpu_mon()
Initialize rdt_domain_hdr::rid using RDT_RESOURCE_PERF_PKG
Drop the L3 checks in rdtgroup_mondata_show() and mon_get_kn_priv() that
are unrelated to the subject of this patch.

--- PATCH v11 22/31] x86/resctrl: Add energy/perf choices to rdt boot ---
Now 0023: No change.

--- PATCH v11 23/31] x86/resctrl: Handle number of RMIDs supported by ---
Now 0024
Subject: "telemetry resources" -> "RDT_RESOURCE_PERF_PKG"
"the IA32_PQR_ASSOC MSR" -> "MSR_IA32_PQR_ASSOC"
Clarify under-resources event groups by adding "for any of the event group's
telemetry regions"
Replace text from "The request to disable..." with Reinette suggested
version.
Don't run skip_telem_region() tests multiple times. Just mark regions
unusable once.
Update comment about adjustment of e->num_rmids.

--- PATCH v11 24/31] fs/resctrl: Move allocation/free of ---
0025: Replace commit comment with Reinette version.

--- PATCH v11 25/31] fs,x86/resctrl: Compute number of RMIDs as minimum ---
0026: s/fs,x86/x86,fs/ in Subject:
Added Reinette RB tag

--- PATCH v11 26/31] fs/resctrl: Move RMID initialization to first mount ---
0027:
Move initialization of idx_limit in setup_rmid_lru_list() after checks
for resctrl_arch_mon_capable() and rmid_ptrs.
Added comment that rmid_ptrs[] may still be accessed by the limbo
handler after resctrl is unmounted.

--- PATCH v11 27/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG ---
0028:
Move setting of r->mon_capable and rdt_mon_capable from enable_events()
to resctrl_arch_pre_mount() inside cpus_read_lock() to avoid double
add of CPUs if a hot add event happens during telemetry enumeration.
Drop the test for r->mon_capable in resctrl_arch_pre_mount()
Replace commit message with Reinette version.

--- PATCH v11 28/31] fs/resctrl: Provide interface to create ---
0029: No change

--- PATCH v11 29/31] x86/resctrl: Add debugfs files to show telemetry ---
0030: Move initialization of debugs to resctrl_arch_pre_mount() [after
the resource is marked mon_capable because of change in 0028
Change type of pkg argument to make_status_files() to u8 and sprintf() with %u

--- PATCH v11 30/31] x86,fs/resctrl: Update Documentation for package ---
0031:
Subject: "Documentation" -> "documentation" and "package events" -> "telemetry events"

Added details of how the "num_rmids" file for telemetry events is based on
supported counters in each type of telemetry event. Tied it to the "rdt="
boot option.

Replaced "set" terminology with separate descriptions of mon_L3 and mon_PERF_PKG
directories.

"these two counters" -> ""core energy" and "activity""

Increased line length of added lines to match rest of file.

--- PATCH v11 31/31] fs/resctrl: Some kerneldoc updates ---
Dropped. Kerneldoc changes merged into patches 0008 and 0013

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

Tony Luck (31):
  x86,fs/resctrl: Improve domain type checking
  x86/resctrl: Move L3 initialization into new helper function
  x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Clean up domain_remove_cpu_ctrl()
  x86,fs/resctrl: Refactor domain create/remove using struct
    rdt_domain_hdr
  x86,fs/resctrl: Use struct rdt_domain_hdr when reading counters
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
  x86,fs/resctrl: Fill in details of events for guid 0x26696143 and
    0x26557651
  x86,fs/resctrl: Add architectural event pointer
  x86/resctrl: Find and enable usable telemetry events
  fs/resctrl: Split L3 dependent parts out of __mon_event_count()
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

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         | 102 ++++-
 include/linux/resctrl.h                       |  69 ++-
 include/linux/resctrl_types.h                 |  11 +
 arch/x86/kernel/cpu/resctrl/internal.h        |  52 ++-
 fs/resctrl/internal.h                         |  68 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 275 +++++++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 423 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  55 ++-
 fs/resctrl/ctrlmondata.c                      | 121 ++++-
 fs/resctrl/monitor.c                          | 356 +++++++++------
 fs/resctrl/rdtgroup.c                         | 261 ++++++++---
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 14 files changed, 1433 insertions(+), 376 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: 15292f1b4c55a3a7c940dbcb6cb8793871ed3d92
-- 
2.51.0

