Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2211E2852
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598982; cv=none; b=qv/jcJZj6EBsDYSXVhjm85u42VioI5xfkOOP7agaOPhG8BZoGtwIVkuBOpMvs++5YEF8gi1Ejvf3czgZ2gEakImz38U9SnRSh6MSLDz6nTC2P632A4IoaEB2ey+ZPnexJP/U2fS2cAdO4lig40qHvDJthOulL5x5htdUF0qwL7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598982; c=relaxed/simple;
	bh=AP6py+8S4tbwuGd9mcSoB89Pl+xcgtiAcEFzV1nLXns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zh2SOa+byHna2Q1mFSAv+hpmcRLW6TrJx4TtSCv0ri2xBH/h8jKsE1hani/6cjOrcK7t/1xnq0ODRdWyka6rrSrNkXJL4wIOh6xeDr36XtXxTS3WVArVFDWCnY7zh+HcMWkKj2/GY52aitKq2PgWbU1/7+6/7FihD+1CNUo7uZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RH6yx3nJ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RH6yx3nJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598981; x=1774134981;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AP6py+8S4tbwuGd9mcSoB89Pl+xcgtiAcEFzV1nLXns=;
  b=RH6yx3nJkn4K66W5lAqFFWQ9b896pCYDy+UlXwOijqgSvGL9YfbBzc0T
   W/yCyhuqZvgoUQ2VUgLCIdIltIxNNwJYz+gZpBmBVuBgLCHK04ExTdm25
   f9kKmqbNDHd49eD82a9E9CRDHx1/9mkmaggTn6kUoNPIT9DfwiV9j27/P
   Iq9nTGbnhuN+ggH68+wtNd6nmzwg/q5DZpjnpa9/pE+gQAT6p/d4pk+Rh
   XabYWfT9D+cR3qDcQiyYAulATiuqxvzVU8eTVjf29DjnBhdrD4GmHiiqV
   Mq3o33JSOnayAwzQ6++ec6f30tWrnlRGYO7ImD9+2ecrOGuDICmYaxTfL
   g==;
X-CSE-ConnectionGUID: bfGI5heZS26PmIs/OKo0/w==
X-CSE-MsgGUID: QVdZWvJ/TAiJ9wpOkQruBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604538"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604538"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:19 -0700
X-CSE-ConnectionGUID: MFrosvWzQkOKCzYC7m/rhw==
X-CSE-MsgGUID: cTql6A1TS/Ozizb+pHlPcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354285"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:19 -0700
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
Subject: [PATCH v2 00/16] x86/resctrl telemetry monitoring
Date: Fri, 21 Mar 2025 16:15:50 -0700
Message-ID: <20250321231609.57418-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

First version posted as RFC here:
Link: https://lore.kernel.org/all/20250303233340.333743-1-tony.luck@intel.com/

This series is based on James Morse's "fs/resctrl/" snapshot.

With Boris applying 30 patches from the monster series to tip x86/cache
we are now close to the finish line of the BIG MOVE. So I moved this
series to be on top of:

git://git.kernel.org/pub/scm/linux/kernel/git/morse/linux.git mpam/move_to_fs/v7

My main goal in doing so is to shine a light on the FS / ARCH boundary
as new things that aren't an easy match for existing things in order
to figure out which new interfaces are needed. Also I expect the
remainder of the big move to complete before this series is ready, so
I might as well get it in shape to apply post-move.

A couple of items I noted:

1) These counters are 63-bits, so wraparound isn't an issue. But
space to save wider copies of counts is built into the filesystem
layer with space allocated in the domains, and periodic polling.

2) I have alloc/free of my domains in the filesystem layer. But this
only works because I don't need any arch specific bits (see above).

3) Some of my counters report fixed-point fractional values. So we
need a way to communicate a "type" from arch code back up to
rdtgroup_mondata_show(). My solution in this series doesn't feel
very elegant.

Other changes since the RFC:

1) Names changed. This feature is officially:
	"Intel(R) Application Energy Telemetry"

2) Many comments added to code

3) James suggested resolving the "these counters can be read from any
CPU" by providing "cpu_online_mask" and relying on smp_call*() functions
to just pick the current CPU. So I did that.

Remainder of this cover letter pasted from the V1/RFC
===
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

Tony Luck (16):
  x86/rectrl: Fake OOBMSM interface
  x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
  x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Change generic monitor functions to use struct
    rdt_domain_hdr
  x86/resctrl: Add and initialize rdt_resource for package scope core
    monitor
  x86/resctrl: Prepare for resource specific event ids
  x86/resctrl: Add initialization hook for Intel PMT events
  x86/resctrl: Add Intel PMT domain specific code
  x86/resctrl: Add detailed descriptions for Clearwater Forest events
  x86/resctrl: Allocate per-package structures for known events
  x86/resctrl: Link known events onto RDT_RESOURCE_INTEL_AET.evt_list
  x86/resctrl: Build lookup table for package events
  x86/resctrl: Add code to display core telemetry events
  x86/resctrl: Add status files to info/PKG_MON
  x86/resctrl: Enable package event monitoring
  x86/resctrl: Update Documentation for package events

 Documentation/filesystems/resctrl.rst         |  25 +-
 include/linux/resctrl.h                       |  32 +-
 include/linux/resctrl_types.h                 |  15 +
 .../cpu/resctrl/fake_intel_aet_features.h     |  73 +++
 arch/x86/kernel/cpu/resctrl/internal.h        |   8 +
 fs/resctrl/internal.h                         |  28 +-
 arch/x86/kernel/cpu/resctrl/core.c            | 123 +++--
 .../cpu/resctrl/fake_intel_aet_features.c     |  65 +++
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 488 ++++++++++++++++++
 fs/resctrl/ctrlmondata.c                      |  23 +-
 fs/resctrl/monitor.c                          |  23 +-
 fs/resctrl/rdtgroup.c                         |  94 +++-
 arch/x86/Kconfig                              |   1 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   2 +
 drivers/platform/x86/intel/pmt/Kconfig        |   3 +
 15 files changed, 915 insertions(+), 88 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

-- 
2.48.1

