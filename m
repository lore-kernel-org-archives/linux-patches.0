Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912A12E6CC2
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408473; cv=none; b=PNgpsk7cIBOJFY/RjW02GqivVTxWZXQpYPzMJtTDnWjhgyDcAcAznliPYe1MuRR/ZotIDVEkJhBjjBqlSogm3Lt7PqGETUBduCLY21AauJ6R7qa6J5u10hbIY8p1QGZuBzJW3guvKvjC6qn5485GsKURsv66pg7Fa8hAgzDaO6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408473; c=relaxed/simple;
	bh=lI8otYYDh9FWyOsQZBV92IsLwwCvBenkM3hHOioZCXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RTReZwaxTfFLyOav1xNcGIepN84B49BgEeWhAn7lO6tzdp1AsY56yZwzHjCq3rG9QG0RMSnMMynlCfp1VeYp8F+UFAjruGhr81fpXaBq9Z9QPUi9x2uBaazWIg4ljaS7+9ntTTvZqRwoCV8GbfJQAr+PeD09lC8elEtBcNqH0cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nn+u8yFo; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nn+u8yFo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408468; x=1796944468;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lI8otYYDh9FWyOsQZBV92IsLwwCvBenkM3hHOioZCXI=;
  b=Nn+u8yFoVJxjZKWo7pESqRXD6ENNijSekMEZfdCY5O6Whxg0v7ieO61n
   G5x6CdnCOU2zyAq8LxsJZnpRq/S5lwcrvWZtOIK2n4v1VXFs+w/UGTYti
   gr0iYVVQQlScZOTyCIrdfcqHn+3geleM2JVqc+K0SOpoy5DlynLHW6MnJ
   RtRwejLQS70eZ7saCpYWy599WAzNAsm0d06DIhpxEgGiN8rchfUsP3l0x
   FVPZoPS9Ja4eR3jejLrpfABa9IefBfoU2FCmaVXoCZ5E+aZX/r312uY1A
   pdThFUuFc6YwIKGhup9tRD9k8uL8yPZNOgcilsRP8Dho8GxEsm7xLOenb
   w==;
X-CSE-ConnectionGUID: mxQUJ9tQReKgyQmpSELFlA==
X-CSE-MsgGUID: 6hi9Rf4tTIijtnUtLm3BXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973472"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973472"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:23 -0800
X-CSE-ConnectionGUID: XK++LM1QSFOccdr7AZ2l+w==
X-CSE-MsgGUID: GqlXRH5NT1GHC/XebkDsQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297020"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:22 -0800
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
Subject: [PATCH v16 00/32] x86,fs/resctrl telemetry monitoring
Date: Wed, 10 Dec 2025 15:13:39 -0800
Message-ID: <20251210231413.59102-1-tony.luck@intel.com>
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
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v16

Changes since v15 was posted here:
https://lore.kernel.org/all/20251204205404.12763-1-tony.luck@intel.com/

No patches split, merged, or reordered since v15. 22 patches unchanged.
This is just the list of changed patches.

--- 07/32 x86,fs/resctrl: Use struct rdt_domain_hdr when reading ---
Added suggested paragraph on motivation for split of event counting.
Added Reinette RB tag.

--- 08/32 x86,fs/resctrl: Rename struct rdt_mon_domain and ---
Added Reinette RB tag.

--- 11/32 x86,fs/resctrl: Handle events that can be read from any ---
Move WARN_ON_ONCE(rr->evt->any_cpu) so it applies to all RDT_RESOURCE_L3
Add commit comment that L3 events don't support any_cpu.

--- 14/32 x86,fs/resctrl: Add and initialize a resource for ---
Added Reinette RB tag.

--- 16/32 x86/resctrl: Discover hardware telemetry events ---
In event_group::pfname kerneldoc: Add quotes around "energy" and "perf".
Defer "used by boot rdt= option" to patch 24.

Improve commit message around event_group::pfname.

Added Reinette RB tag.

--- 17/32 x86,fs/resctrl: Fill in details of events for guid ---
Added Reinette RB tag.

--- 19/32 x86/resctrl: Find and enable usable telemetry events ---
Make enable_events() "return true;"
Drop "Warn the user" from commit message as it is obvious from the code.
Add note that event groups are independent of each other.

--- 24/32 x86/resctrl: Add energy/perf choices to rdt boot option ---
event_group::pfname "Used by boot rdt= option" moved from patch 16.
s/@guid/event group/ in kerneldoc for event_group::force_{on,off}.
Avoid repetition of "disables".
Added check in intel_aet_option() for tok == NULL.

Replace last paragraph of commit message.

--- 25/32 x86/resctrl: Handle number of RMIDs supported by ---
Patch 19 made enable_events() return true, so change dropped here.
Early return from all_regions_have_sufficient_rmid() on first region
seen with insufficient RMIDs.
"Only enable feature with" -> "Only enable event group with"

Imperative "Disable such event groups by default." in commit message.

--- 32/32 x86,fs/resctrl: Update documentation for telemetry ---
Split the telemetry "num_rmids" description as suggested.


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
 Documentation/filesystems/resctrl.rst         | 101 +++-
 include/linux/resctrl.h                       |  67 ++-
 include/linux/resctrl_types.h                 |  11 +
 arch/x86/kernel/cpu/resctrl/internal.h        |  48 +-
 fs/resctrl/internal.h                         |  68 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 230 ++++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 474 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  50 +-
 fs/resctrl/ctrlmondata.c                      | 113 ++++-
 fs/resctrl/monitor.c                          | 364 +++++++++-----
 fs/resctrl/rdtgroup.c                         | 293 +++++++----
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 14 files changed, 1441 insertions(+), 399 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: a619fe35ab41fded440d3762d4fbad84ff86a4d4
-- 
2.51.1

