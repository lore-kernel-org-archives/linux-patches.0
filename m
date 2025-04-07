Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DF522A7E9
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069251; cv=none; b=VR+k+xQOBF2SRWgpDo2pCZ6XMGcmhZODxWNwR9LvKRS+9R++3U4//SvCgpdfu6uF71Z+rbhf8Afxk4NUWwL9rYPsS2B9KljJeCG/ZUpuK8/o+I0rgZ0pAMRQIbDmfbvQyFJ5KZLM1ptEbXYkawRAF5QAiVdkHdd4+Fxv2ZWnWsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069251; c=relaxed/simple;
	bh=9Eix2ValT27A1sxLMvdv+oBSpYPg9OIS6s825S3H1aE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BNqxSNl3i/osEad2bxqE1LoVSfuV7ke7OTTY1QHayi/MDjjC57Q0D0TqvRMXKLgoOn8xUKSyKmeY3qv3KbkQ+8v7AVRlxvT3j2DLBpXME+dJPJ6G7PaLcN5vQRWW6MPmiQefljYvLy/+W6yjWK4gzPD6p+cX5wREkMYcZKRXHpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dmFqOt45; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dmFqOt45"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069250; x=1775605250;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9Eix2ValT27A1sxLMvdv+oBSpYPg9OIS6s825S3H1aE=;
  b=dmFqOt45fW5Gchn8AYkNRtBqaH14JcHIj7MZRD4tqg7dIhhgB5x8qF0g
   mXGPmKZFvYOWSbfin5mtSxKPNFcjXOHBResVMO829Np5LdbxJZIRzUMmT
   Lt0U8wSnAN4LjJtKvI6Bm+bQT9ux0WyiiKGzin13IZEzKdt3tTu8jVE9i
   c5pThos2T/dv1aNoAVh5V58WC9XsycpnjfQ/DNlv+yuxbvutH8EQxLuPQ
   WyQpwTWTCTMH9uJEsZy++7zBxhxcMB0c9E4+hPA6RVN9U4vTKuHIRGYie
   yYtE9dXu65O9D/mJ2gjxpNG+NxW7xooNSuxQgcEXG9H3RApKFcueystwj
   w==;
X-CSE-ConnectionGUID: EI4cVwOlSTexEPNn+ExrNQ==
X-CSE-MsgGUID: lRTnANX7T3Gmdb7DZHCkMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193108"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193108"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:44 -0700
X-CSE-ConnectionGUID: HVlj/NvLQOaYzdBhk7qndw==
X-CSE-MsgGUID: JwUJdzclQWKUSHdzbMSnkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315440"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:43 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 00/26] x86/resctrl telemetry monitoring
Date: Mon,  7 Apr 2025 16:40:02 -0700
Message-ID: <20250407234032.241215-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Previous version here:
https://lore.kernel.org/all/20250321231609.57418-1-tony.luck@intel.com/

This series is based on James Morse's "fs/resctrl/" snapshot.

General changes since v2:
------------------------

Fixed several violations of the FS/ARCH interface. As far as
possible the patches are now divided into patches for ARCH
code v.s. patches for FS code.

All event names/numbers are defined by FS code.

Changed the names of new bits in FS code to PERF_PKG.

Changed names of detailed event descriptions from using "CWF"
(short for Clearwater Forest) to names using the guid value.
E.g. NUM_RMIDS_CWF -> NUM_RMIDS_0x26696143

Fixed typos from v2, and improved many commit messages
and code comments.

Roadmap to patches in the series:
--------------------------------

First patch provides a simpler implementation of James' "Expand
the width of dom_id by replacing mon_data_bits" patch. James will
merge this into the next version of his resctrl fs series. So
this patch will be dropped.

Second patch is a cleaned up version of something I posted before
to improve handling multiple MBM events.
https://lore.kernel.org/all/20250314202609.5753-1-tony.luck@intel.com/
It turns out to be a useful base to add other monitor events.

Third patch is preparation for more monitor events changing how
and when they are initialized. The "when" moves the initialization
to first mount of resctrl ready for adding perf events (which
are enumerated much later than normal resctrl initialization).

Fourth sets up the Kconfig elements for PERF events.

Fifth patch is the fake OOBMSM interface, providing the
intel_pmt_get_regions_by_feature() and intel_pmt_put_feature_group()
that will eventually be supplied directly by OOBMSM code.

Sixth patch is in response to Reinette's review of the V2 series
where I had deleted some rdt_mon_domain type checking which
could lead to problems with the additional domain type. I
extended the type checking from simple "ctrl" vs. "mon" to
also check the resource type.

7-9 refactor some x86 code to make adding a new rdt_resource easier

10 Implemented a suggestion from James on coding so that events
that can be read from any CPU avoid a cross-processor interrupt
while keeping the same calling sequence between FS and ARCH code.
The attribute is available independently for each event.

11 Adds support for ARCH code to describe which format to display
monitor values from choices listed in an FS enum. Two choices
implemented: 64-bit unsigned decimal number, and fixed-point
with 18 binary digits displayed as floating point.

12 Add FS hook for ARCH code to set event counter attributes.

13 Add ARCH hook called by FS on each mount.

14-16 X86 enumeration of perf events using calls to OOBMSM

17 Add lookup table from FS event numbers to ARCH structures
needed to process event read requests

18 Hook into resctrl_arch_rmid_read() for RDT_RESOURCE_PERF_PKG
to read counters for its events. Code to read the events sums
over all aggregators in a package.

19 Cross check three enumerated sources of number of RMIDS for
perf events. This part needs further discussion on how to pass
information to users. Existing FS/ARCH interfaces doesn't have
obvious way to add additional info/ files.

20 Add new RDT_RESOURCE_PERF_PKG resource and package scope define

21 Domain creation/deletion for RDT_RESOURCE_PERF_PKG

22 Type define for resctrl files for RDT_RESOURCE_PERF_PKG

23 Add new events to typedef resctrl_event_id and all_events[].

24 Enable all enumerated telemetry events and the RDT_RESOURCE_PERF_PKG resource.

25 Add details for the telemetry events on Clearwater Forest systems.

26 Documentation.

Background

Telemetry features are being implemented in conjunction with the
IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
counts for various events to a collector in a nearby OOMMSM device to be
accumulated with counts for each <RMID, event> pair received from other
CPUs. Cores send event counts when the RMID value changes, or after each
2ms elapsed time.

Each OOBMSM device may implement multiple event collectors with each
servicing a subset of the logical CPUs on a package.  In the initial
hardware implementation, there are two categories of events:

The counters are arranged in groups in MMIO space of the OOBMSM device.
E.g. for the energy counters the layout is:

Offset: Counter
0x00	core energy for RMID 0
0x08	core activity for RMID 0
0x10	core energy for RMID 1
0x18	core activity for RMID 1

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
but collected in a way with mush lower overhead (no need to collect data
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

Enumeration

The only CPUID based enumeration for this feature is the legacy
CPUID(eax=7,ecx=0).ebx{12} that indicates the presence of the
IA32_PQR_ASSOC MSR and the RMID field within it.

The OOBMSM driver discovers which features are present via
PCIe VSEC capabilities. Each feature is tagged with a unique
identifier. These identifiers indicate which XML description file from
https://github.com/intel/Intel-PMT describes which event counters are
available and their layout within the MMIO BAR space of the OOBMSM device.

Resctrl User Interface

Because there may be multiple OOBMSM collection agents per processor
package, resctrl accumulates event counts from all agents on a package
and presents a single value to users. This will provide a consistent
user interface on future platforms that vary the number of collectors,
or the mappings from logical CPUs to collectors.

Users will see the legacy monitoring files in the "L3" directories
and the telemetry files in "PKG" directories (with each file
providing the aggregated value from all OOBMSM collectors on that
package).

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
├── mon_PKG_00
│   ├── activity
│   ├── c1_res
│   ├── c6_res
│   ├── core_energy
│   ├── stalls_llc_hit
│   ├── stalls_llc_miss
│   ├── unhalted_core_cycles
│   ├── unhalted_ref_cycles
│   └── uops_retired
└── mon_PKG_01
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

The OOBMSM driver exposes a function "intel_pmt_get_regions_by_feature()"
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
2) New struct rdt_resource RDT_RESOURCE_INTEL_PMT
3) Refactor monitor code paths to split existing L3 paths from new ones. In some cases this ends up with:
        switch (r->rid) {
        case RDT_RESOURCE_L3:
                helper for L3
                break;
        case RDT_RESOURCE_INTEL_PMT:
                helper for PKG
                break;
        }
4) New source code file "intel_pmt.c" for the code to enumerate, configure, and report event counts.

With only one platform providing this feature, it's tricky to tell
exactly where it is going to go. I've made the event definitions
platform specific (based on the unique ID from the VSEC enumeration). It
seems possible/likely that the list of events may change from generation
to generation.

I've picked names for events based on the descriptions in the XML file.

Signed-off-by: Tony Luck <tony.luck@intel.com>

Tony Luck (26):
  fs/resctrl: Simplify allocation of mon_data structures
  fs-x86/resctrl: Prepare for more monitor events
  fs/resctrl: Change how events are initialized
  fs/resctrl: Set up Kconfig options for telemetry events
  x86/rectrl: Fake OOBMSM interface
  fs-x86/rectrl: Improve domain type checking
  x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
  x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Change generic monitor functions to use struct
    rdt_domain_hdr
  fs/resctrl: Improve handling for events that can be read from any CPU
  fs/resctrl: Add support for additional monitor event display formats
  fs/resctrl: Add hook for architecture code to set monitor event
    attributes
  fs/resctrl: Add an architectural hook called for each mount
  x86/resctrl: Add first part of telemetry event enumeration
  x86/resctrl: Second stage of telemetry event enumeration
  x86/resctrl: Third phase of telemetry event enumeration
  x86/resctrl: Build a lookup table for each resctrl event id
  x86/resctrl: Add code to read core telemetry events
  x86/resctrl: Sanity check telemetry RMID values
  x86/resctrl: Add and initialize rdt_resource for package scope core
    monitor
  fs-x86/resctrl: Handle RDT_RESOURCE_PERF_PKG in domain create/delete
  fs/resctrl: Add type define for PERF_PKG files
  fs/resctrl: Add new telemetry event id and structures
  x86/resctrl: Final steps to enable RDT_RESOURCE_PERF_PKG
  fs-x86/resctrl: Add detailed descriptions for Clearwater Forest events
  x86/resctrl: Update Documentation for package events

 Documentation/filesystems/resctrl.rst         |  38 +-
 include/linux/resctrl.h                       |  42 +-
 include/linux/resctrl_types.h                 |  36 +-
 arch/x86/include/asm/resctrl.h                |   8 +-
 .../cpu/resctrl/fake_intel_aet_features.h     |  73 ++++
 arch/x86/kernel/cpu/resctrl/internal.h        |  19 +-
 fs/resctrl/internal.h                         |  23 +-
 arch/x86/kernel/cpu/resctrl/core.c            | 199 ++++++---
 .../cpu/resctrl/fake_intel_aet_features.c     |  87 ++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 377 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  39 +-
 fs/resctrl/ctrlmondata.c                      |  76 ++--
 fs/resctrl/monitor.c                          | 164 ++++++--
 fs/resctrl/rdtgroup.c                         | 266 ++++++------
 arch/x86/Kconfig                              |   1 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   2 +
 drivers/platform/x86/intel/pmt/Kconfig        |   6 +
 17 files changed, 1125 insertions(+), 331 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: 89679ca4122a5a6622530490ef4855dd39baa54e
-- 
2.48.1

