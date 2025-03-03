Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9B51F4735
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044888; cv=none; b=QMA1FFh2h3zfX+rXrVM4Ur/+lxG4T35wvvtfOcaFbsczLQlI+AFeg3tPFAtE//VFhv5gxkK3Iz1LtmsJI/W1cF9Z8Q6tCWzRxJbe9VtItzALKCZgzHdzZOdhBfsUBu/E4L7UTkLk/dvT0GVPLK2pXnCslTt1lCDMNe0oAyINV2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044888; c=relaxed/simple;
	bh=/pBvxkD9iITx8Y9QNqYcKLk7D69TTbTyvC7IUFhMawk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NESOMOd5jfL7tszyGz1i/3qRkFXDAbtWsF15J66mraPfDqAX77ixNyK/tK5sSYW8wbt30I4snXtIu4KJ9I7QZhs5uCMIiZvoYsGUoZL6kAEBf1G1eEfYbgz1HFU2wgJ3sl+jw6/NhTB1fz5HGNr0CgksNZblRkmfS1POp4RE3ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ThU21PSG; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ThU21PSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044887; x=1772580887;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/pBvxkD9iITx8Y9QNqYcKLk7D69TTbTyvC7IUFhMawk=;
  b=ThU21PSGSU35wjo+fYrLqUsNH/woT3xR0/rufaVmOXgFp9eD9QRhH88+
   TT1VmmHJVbKjtofkBFxqi6WXwGKJMfxk7AfEsmzsZXrU1Fq337e0DLMju
   QEqLSRtvF+HAGbsvD0HSAn7un6W+CgKgdwDSSLN/r3jkZe2JS/LQLY1pk
   kKa9GMDq6+Cf1lAwDODi+UGcW+7pZTJ3tJclDoMnCeVvEDE1WONHZv3e0
   MliTd8UJ+AAgZPtYsuqMRRrsOhZYY6cZV0R8V4yk1yPmuQB2QSndo0wh5
   OYcIZ2JeFiHOp+UllPfWibQg+n7MfrCnc+N2r91Hehb6r0E42b/BE/z4P
   g==;
X-CSE-ConnectionGUID: 8CuoGY9XQZiFg2Rynpgk7w==
X-CSE-MsgGUID: +MbgGAe3R+mnQm9C7OL6jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835897"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835897"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:46 -0800
X-CSE-ConnectionGUID: 9JBHAOVNRRq7QPF6h0vFRw==
X-CSE-MsgGUID: zcQdZxHdTBa2LDL5WVv4rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982276"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:50 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 00/17] x86/resctrl telemetry monitoring
Date: Mon,  3 Mar 2025 15:33:20 -0800
Message-ID: <20250303233340.333743-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Preamble

I'm trying here to provide a picture of the capabilities of telemetry
monitoring with a possible resctrl implementation. I'm looking for
high level comments on my general approach (especially as it may
interact with monitoring features that other architectures may want
to add in the future.

The first patch in the series just provides a fake copy of the
enumeration interface that should show up in the OOBMSM driver in
the near future. It allows building, and running, of this series
on Intel (and perhaps AMD) systems that don't have h/w support.

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


Tony Luck (17):
  x86/rectrl: Fake OOBMSM interface
  x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
  x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Split L3 specific code out of rdtgroup_mondata_show()
  x86/resctrl: Change generic monitor functions to use struct
    rdt_domain_hdr
  x86/resctrl: Add and initialize rdt_resource for package scope core
    monitor
  x86/resctrl: Prepare for resource specific event ids
  x86/resctrl: Add initialization hook for Intel PMT events
  x86/resctrl: Add Intel PMT domain specific code
  x86/resctrl: Add detailed descriptions for Clearwater Forest events
  x86/resctrl: Allocate per-package structures for known events
  x86/resctrl: Add list of known events to RDT_RESOURCE_INTEL_PMT
  x86/resctrl: Build lookup table for package events
  x86/resctrl: Add code in rdtgroup_mondata_show() for core monitor
    events
  x86/resctrl: Add status files to info/PKG_MON
  x86/resctrl: Enable package event monitoring
  x86/resctrl: Update Documentation for package events

 Documentation/arch/x86/resctrl.rst            |  25 +-
 include/linux/resctrl.h                       |  11 +-
 .../cpu/resctrl/fake_intel_pmt_features.h     |  72 +++
 arch/x86/kernel/cpu/resctrl/internal.h        |  51 +-
 arch/x86/kernel/cpu/resctrl/core.c            | 105 ++--
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c     |  82 +--
 .../cpu/resctrl/fake_intel_pmt_features.c     |  64 +++
 arch/x86/kernel/cpu/resctrl/intel_pmt.c       | 486 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        |  87 +++-
 arch/x86/Kconfig                              |   1 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   2 +
 drivers/platform/x86/intel/pmt/Kconfig        |   3 +
 12 files changed, 882 insertions(+), 107 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.h
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_pmt_features.c
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_pmt.c


base-commit: 7eb172143d5508b4da468ed59ee857c6e5e01da6
-- 
2.48.1

