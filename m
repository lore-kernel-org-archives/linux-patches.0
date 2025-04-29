Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53FE23C9
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886849; cv=none; b=I/m9kMKu3X81Bl9nMRWizG/e24LKjctHver01zVO3b+pHstAVtF7t8cfJi2OGigVHwdoJ7rYnI066pqNtg1s9f+Vz+SNJskkmhi339AXelWqqnV++MfTOGg0Apli0BvO6hUs/Hk4CbBup0J/vKNjjyFQCntuPbRBzBi2E5PIcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886849; c=relaxed/simple;
	bh=/uD6TXq0hfRNrcKx7TLvBkas8jHMpXBFd92jJOW7sSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DqUNMDF6f9jXtK6olLtwJBQS4AKGcaGM6+XRAQL+k5qLc/pxVHS2UpjX0Fw2V6/LZQsAcJG2xHug5L9oGbuJO/cSXZaEVGI2Bp0r9sT/lNoE8zAvoH6TCvill59pFCRzdJOXCIuP2icH/fZFhp6KVkvy0kFABX7Q4C7UjEVMFFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBA6URsp; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBA6URsp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886847; x=1777422847;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/uD6TXq0hfRNrcKx7TLvBkas8jHMpXBFd92jJOW7sSQ=;
  b=WBA6URspDK/xhSE5Q/c2GC9/h/dDeZ34a2d1Fc1//zddvwAFZ0pwc7Mm
   hDANvBQFspCWborDSjm2jJFLsecpjNCNZ5FuPbJ+ywJEFMOIlAAY9zFbf
   viUnrtM7yakcJktqyLFeCFgpR+PU/m3D4CIO6yOyWgeAymprv8pY/RIPQ
   gQQNSaLlCbVAgiDnhOnPUp7SHgCfa0L3zIwrBkzzMOYxgmrDQrWECvYB2
   GT/+c4nis6ET5U5VrmD86wiv7BG1HFxbtEKziwSSp7/5CgbB3tod7mPWq
   RCyCXCDrDY7abPkzOBO5+khfuFvg0bpMucVGvYBQCbkjXlo1NJMzAmoiP
   w==;
X-CSE-ConnectionGUID: j+sPhNCnTZaDc3Jp09wH5w==
X-CSE-MsgGUID: wv/uoz5URza06YbkHMNo8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148027"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148027"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:07 -0700
X-CSE-ConnectionGUID: LxnZraZNSwS5RE08HBOl1Q==
X-CSE-MsgGUID: GyLcNUKyREOwEUEWP5/Uuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133393944"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:06 -0700
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
Subject: [PATCH v4 00/31] x86/resctrl telemetry monitoring
Date: Mon, 28 Apr 2025 17:33:26 -0700
Message-ID: <20250429003359.375508-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These patches are based on James Morse's latest patch set to:

  "Move the resctrl filesystem code to /fs/resctrl"

posted here:

Link: https://lore.kernel.org/all/20250425173809.5529-1-james.morse@arm.com/

Also available in the "mpam/move_to_fs/v9_final" branch of:
Link: git://git.kernel.org/pub/scm/linux/kernel/git/morse/linux.git

I've pushed combination of James' series plus these patches to the
rdt-aet-v4 branch at:

Link: git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git

Extensive changes (based on feedback from Reinette) since v3 was posted here:

Link: https://lore.kernel.org/all/20250407234032.241215-1-tony.luck@intel.com/

Major changes:

1) Instead of using bits in the architecture local "rdt_mon_features"
variable to keep track of enabled monitor events, use mon_evt::enabled
to track at the file system layer. Architecture informs file system
which events are enabled. This means that file system no longer needs
any of the resctrl_arch_is_*_enabled() calls to architecture as it now
has the array of mon_evt structures to check. This is one step in making
the mon_evt structure the source of all information about each event.

2) Split the v3 "Prepare for more monitor events" patch into three
easier to digest pieces.

3) Simplified the "Improve domain type checking" patch by making
the rdt_resource type its own field in the rdt_domain_hdr structure
instead of encoding it in a bit field combined with the CTRL/MON type.

4) Added "l3" to a bunch of function and structure names to indicate
that they are now specific to L3 events instead of generic monitoring.

5) Struct mon_evt is also the source of truth for "can this event be
read from any CPU?". Other structures (mon_data and rmid_read) now
have pointers to mon_evt instead of their own field copied from
mon_evt.

6) Events that can be read on any CPU now bypass the
cpumask_any_housekeeping() path that would have resulted in an
IPI to the first CPU on a domain. mon_event_read() now directly
calls mon_event_count() for these events.

7) Renamed the per-mount hook and commented on (lack of) locking
by the caller.

8) Split the enumeration of telemetry events into easier to
review chunks with more comments in the code at each stage.

9) Simplified the intel_aet_read_event() code. No funky macros
to pick up parameters for the MMIO address calculation. Added
a sanity check that the computed MMIO register address is in
the range provided by the aggregator.

10) File system now owns the output format. Architecture cannot
make choices. Every event is hard-coded to be displayed as
integer or floating point.

11) Added additional options to the rdt= boot option for the user
to force opt-in or opt-out of telemetry events. Use these options
to solve the "how many RMIDs can be used?" issue.

12) Moved final calculation of available number of RMIDs to first
mount of resctrl file system and make it determine smallest value
across all mon_capable resources.

13) Version 2 of the patch series included extra files in the info/
directory to report some internal status values. V3 dropped that
entirely because I couldn't see a good way to cross the fs<->arch
boundary with extra architecture specific info files. Patches
29-30 are an RFC way to bring this back when the file system is
mounted with the "debug" option.

Background
----------

Telemetry features are being implemented in conjunction with the
IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
counts for various events to a collector in a nearby OOBMSM device to be
accumulated with counts for each <RMID, event> pair received from other
CPUs. Cores send event counts when the RMID value changes, or after each
2ms elapsed time.

Each OOBMSM device may implement multiple event collectors with each
servicing a subset of the logical CPUs on a package.  In the initial
hardware implementation, there are two categories of events: energy
and perf.

1) Energy - Two counters
core_energy: This is an estimate of Joules consumed by each core. It is
calculated based on the types of instructions executed, not from a power
meter. This counter is useful to understand how much energy a workload
is consuming.

activity: This measures "accumulated dynamic capacitance". Users who
want to optimize energy consumption for a workload may use this rather
than core_energy because it provides consistent results independent of
any frequency or voltage changes that may occur during the runtime of
the application (e.g. entry/exit from turbo mode).

2) Performance - Seven counters
These are similar events to those available via the Linux "perf" tool,
but collected in a way with much lower overhead (no need to collect data
on every context switch).

stalls_llc_hit - Counts the total number of unhalted core clock cycles
when the core is stalled due to a demand load miss which hit in the LLC

c1_res - Counts the total C1 residency across all cores. The underlying
counter increments on 100MHz clock ticks

unhalted_core_cycles - Counts the total number of unhalted core clock
cycles

stalls_llc_miss - Counts the total number of unhalted core clock cycles
when the core is stalled due to a demand load miss which missed all the
local caches

c6_res - Counts the total C6 residency. The underlying counter increments
on crystal clock (25MHz) ticks

unhalted_ref_cycles - Counts the total number of unhalted reference clock
(TSC) cycles

uops_retired - Counts the total number of uops retired

The counters are arranged in groups in MMIO space of the OOBMSM device.
E.g. for the energy counters the layout is:

Offset: Counter
0x00	core energy for RMID 0
0x08	core activity for RMID 0
0x10	core energy for RMID 1
0x18	core activity for RMID 1
...

Enumeration
-----------

The only CPUID based enumeration for this feature is the legacy
CPUID(eax=7,ecx=0).ebx{12} that indicates the presence of the
IA32_PQR_ASSOC MSR and the RMID field within it.

The OOBMSM driver discovers which features are present via
PCIe VSEC capabilities. Each feature is tagged with a unique
identifier. These identifiers indicate which XML description file from
https://github.com/intel/Intel-PMT describes which event counters are
available and their layout within the MMIO BAR space of the OOBMSM device.

Resctrl User Interface
----------------------

Because there may be multiple OOBMSM collection agents per processor
package, resctrl accumulates event counts from all agents on a package
and presents a single value to users. This will provide a consistent
user interface on future platforms that vary the number of collectors,
or the mappings from logical CPUs to collectors.

Users will continue to see the legacy monitoring files in the "L3"
directories and the telemetry files in the new "PERF_PKG" directories
(with each file providing the aggregated value from all OOBMSM collectors
on that package).

$ tree /sys/fs/resctrl/mon_data/
/sys/fs/resctrl/mon_data/
├── mon_L3_00
│   ├── llc_occupancy
│   ├── mbm_local_bytes
│   └── mbm_total_bytes
├── mon_L3_01
│   ├── llc_occupancy
│   ├── mbm_local_bytes
│   └── mbm_total_bytes
├── mon_PERF_PKG_00
│   ├── activity
│   ├── c1_res
│   ├── c6_res
│   ├── core_energy
│   ├── stalls_llc_hit
│   ├── stalls_llc_miss
│   ├── unhalted_core_cycles
│   ├── unhalted_ref_cycles
│   └── uops_retired
└── mon_PERF_PKG_01
    ├── activity
    ├── c1_res
    ├── c6_res
    ├── core_energy
    ├── stalls_llc_hit
    ├── stalls_llc_miss
    ├── unhalted_core_cycles
    ├── unhalted_ref_cycles
    └── uops_retired

Resctrl Implementation
----------------------

The OOBMSM driver exposes "intel_pmt_get_regions_by_feature()"
that returns an array of structures describing the per-RMID groups it
found from the VSEC enumeration. Linux looks at the unique identifiers
for each group and enables resctrl for all groups with known unique
identifiers.

The memory map for the counters for each <RMID, event> pair is described
by the XML file. This is too unwieldy to use in the Linux kernel, so a
simplified representation is built into the resctrl code. Note that the
counters are in MMIO space instead of accessed using the IA32_QM_EVTSEL
and IA32_QM_CTR MSRs. This means there is no need for cross-processor
calls to read counters from a CPU in a specific domain. The counters
can be read from any CPU.

High level description of code changes:

1) New scope RESCTRL_PACKAGE
2) New struct rdt_resource RDT_RESOURCE_PERF_PKG
3) Refactor monitor code paths to split existing L3 paths from new ones. In some cases this ends up with:
        switch (r->rid) {
        case RDT_RESOURCE_L3:
                helper for L3
                break;
        case RDT_RESOURCE_PERF_PKG:
                helper for PKG
                break;
        }
4) New source code file "intel_aet.c" for the code to enumerate, configure, and report event counts.

With only one platform providing this feature, it's tricky to tell
exactly where it is going to go. I've made the event definitions
platform specific (based on the unique ID from the VSEC enumeration). It
seems possible/likely that the list of events may change from generation
to generation.

I've picked names for events based on the descriptions in the XML file.

Signed-off-by: Tony Luck <tony.luck@intel.com>

Tony Luck (31):
  x86,fs/resctrl: Drop rdt_mon_features variable
  x86,fs/resctrl: Prepare for more monitor events
  fs/resctrl: Clean up rdtgroup_mba_mbps_event_{show,write}()
  fs/resctrl: Change how and when events are initialized
  fs/resctrl: Set up Kconfig options for telemetry events
  x86/rectrl: Fake OOBMSM interface
  x86,fs/resctrl: Improve domain type checking
  x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
  x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Change generic monitor functions to use struct
    rdt_domain_hdr
  x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain
  fs/resctrl: Improve handling for events that can be read from any CPU
  fs/resctrl: Add support for additional monitor event display formats
  fs/resctrl: Add an architectural hook called for each mount
  x86/resctrl: Add and initialize rdt_resource for package scope core
    monitor
  x86/resctrl: Add first part of telemetry event enumeration
  x86/resctrl: Add second part of telemetry event enumeration
  x86/resctrl: Add third part of telemetry event enumeration
  x86,fs/resctrl: Fill in details of Clearwater Forest events
  x86/resctrl: Check for adequate MMIO space
  x86/resctrl: Add fourth part of telemetry event enumeration
  x86/resctrl: Read core telemetry events
  x86,fs/resctrl: Handle domain creation/deletion for
    RDT_RESOURCE_PERF_PKG
  fs/resctrl: Add type define for PERF_PKG files
  x86/resctrl: Final steps to enable RDT_RESOURCE_PERF_PKG
  x86/resctrl: Add energy/perf choices to rdt boot option
  x86/resctrl: Handle number of RMIDs supported by telemetry resources
  x86,fs/resctrl: Fix RMID allocation for multiple monitor resources
  fs/resctrl: Add interface for per-resource debug info files
  x86/resctrl: Add info/PERF_PKG_MON/status file
  x86/resctrl: Update Documentation for package events

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         |  53 ++-
 include/linux/resctrl.h                       |  51 ++-
 include/linux/resctrl_types.h                 |  19 +
 arch/x86/include/asm/resctrl.h                |  16 -
 .../cpu/resctrl/fake_intel_aet_features.h     |  73 ++++
 arch/x86/kernel/cpu/resctrl/internal.h        |  35 +-
 fs/resctrl/internal.h                         |  42 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 273 ++++++++++----
 .../cpu/resctrl/fake_intel_aet_features.c     |  95 +++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 343 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  61 ++--
 fs/resctrl/ctrlmondata.c                      |  93 ++---
 fs/resctrl/monitor.c                          | 269 +++++++++-----
 fs/resctrl/rdtgroup.c                         | 221 +++++++----
 arch/x86/Kconfig                              |   1 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   2 +
 drivers/platform/x86/intel/pmt/Kconfig        |   7 +
 18 files changed, 1283 insertions(+), 373 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-repository: git://git.kernel.org/pub/scm/linux/kernel/git/morse/linux.git
base-branch: mpam/move_to_fs/v9_final
base-commit: dc979ecda2982f7c09de81cde1ec902fdc8e202f
-- 
2.48.1

