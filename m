Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FEF134AC
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867859; cv=none; b=KuqwHzsy/2EzeFPqc1cJPfBtR86dtbO59k1aT3XtPdLGJx1u1MzzR+kd/M9psvttavidZiPO7OIka4dyU6/wsw1/1XacglGfcqShDjn5GIXTaTQBQh9nbz7/vqD/W7Le3j9tHIUqKpphMDen4dtobSEoxvK4/7PW+QFh+O4XU5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867859; c=relaxed/simple;
	bh=GofgvyX60XxoSkJ8fcuxSQPAk54e9Txv076yRRrF2nU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GWtNQOkfyBtYkPGRhPD8kdq/i5lvGHyW8AyUUc2txcZQWUkFRuPEVRgJEPFDb8ne5AQutI2x/2OYMTNBmfGO2DP8Q+PMrYt3Ep4VwCjv0XjHjyCrEJlti+pIjp+HCEAPSjv0I1z5TRGCZY6GhMquLEHnPsLn+UgLcFozA9mNXMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=enupnSMB; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="enupnSMB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867857; x=1779403857;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GofgvyX60XxoSkJ8fcuxSQPAk54e9Txv076yRRrF2nU=;
  b=enupnSMBmxrhXetcGS+F2a3UndYfKsk32TnQs1fMndelISGJkvCwcM8m
   F1XFNphZf7skKZR/d4j3Ha2SYYXcYI/9KE1xkKfjKXkATgF5B57aQd++X
   lf/0RXH6qEhSWWN4dOmYu6+uI6awqZsuSkt3EOZ3r24pUSeW7Ht4VX2Co
   bNz4OxSwJKtDlDX0GMVNngCGqxjPz2zvhs9lx+f/Fx14ecALjDmjUFrLR
   FxnFVpPr/XwRSMpUwlCry0I4DB3aaIDccf1xo9HBdbDPgF34GMhb2zdeo
   tCHetcXguUgGFF2L+JeMGw9mSChpbeo5lsqoqSQ2GXXlTHUekk53w+xsM
   g==;
X-CSE-ConnectionGUID: VzB+b4v3TI+G8Jiq1/z40g==
X-CSE-MsgGUID: aS7zR8zeSOW4WOf8WP+CXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677605"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677605"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:56 -0700
X-CSE-ConnectionGUID: eJgeUURmRH6Dk7hAG4jqnA==
X-CSE-MsgGUID: 66JEUjf5SMOtpB8GMZdfdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352120"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:56 -0700
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
Subject: [PATCH v5 00/29] x86/resctrl telemetry monitoring
Date: Wed, 21 May 2025 15:50:18 -0700
Message-ID: <20250521225049.132551-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These patches are based on tip x86/cache branch. HEAD at time of
snapshot is:

54d14f25664b ("MAINTAINERS: Add reviewers for fs/resctrl")

These patches are also available in the rdt-aet-v5 branch at:

Link: git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git

Changes (based on feedback from Reinette and a bug report from Chen Yu)
since v4 was posted here:

Link: https://lore.kernel.org/all/20250429003359.375508-1-tony.luck@intel.com/

Change map indexed by patch numbers in v4. Some patches have been merged,
split, dropped, or re-ordered. The v5 patch numbers are referred to
by their 4-digit git format-patch numbers in an attempt to avoid
confusion.

=== 1 ===

v4 patch was focussed on removing rdt_mon_features bitmap
which included moving all the mon_evt structure definitions
into an array. Reinette noted that this array would mean the
rdt_resource::evt_list is no longer needed.

v5 splits up the changes into three parts:
0001:	Moves mon_evt structures into an array (now named
	mon_event_all[]) and replaces use of rdt_resource::evt_list
	with iteration of enabled events in the array.
0002:	Replace resctrl_arch_is_llc_occupancy_enabled() with
	resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)
	(ditto for the mbm*enabled() inline functions)
0003:	Remove remaining use of rdt_mon_features.

=== 2 ===

0004:	Fix typos. Change parameter of resctrl_is_mbm_event() to enum.
	s/QOS_NUM_MBM_EVENTS/QOS_NUM_L3_MBM_EVENTS/.
	s/MBM_EVENT_IDX/MBM_STATE_IDX/. Rewrite get_arch_mbm_state()
	in same simple style as get_mbm_state()

=== 3 ===

Dropped this patch. No immediate plans for other mbm monitor events
that could be used as input to the "mba_MBps" feedback control.

=== 4 ===

Also dropped. The rdt_resource::evt_list no longer exists, so no need
to rearrange code to build it at mount time.

=== 5 ===

Dropped the Kconfig changes for now. This means that intel_aet.c is
always built with CONFIG_X86_CPU_RESCTRL=y. Will need to revisit when
the CONFIG_INTEL_PMT_DISCOVERY driver is upstream.

=== 6 ===

0005:	Added comments that fake interface is deliberately crafted
	with parameters to exercise multiple aggregators per package
	and insufficient RMIDs supported.

=== 7 ===

0006:	Rename check_domain_header() to domain_header_is_valid()

=== 8 ===

Split into two parts:
0007:	Better names for functions. Use "()" consistently in
	commit message when naming functions.
0008:	Better description that this change is just for domain add.

=== 9 ===

0009:	New commit message with background and rationale for change.

=== 10 ===

0010:	More context in commit message. Dropped an unnecessary container_of()
	Made domain_add_cpu_ctrl() match domain_add_cpu_mon() with simple
	path when adding a CPU to existing domain.

=== 11 ===

0011:	Added rational for rename of rdt_mon_domain and rdt_hw_mon_domain
	structures. Fixed alignment in structure definitions. Fixed broken
	fir tree ordering.

=== 12 ===

Split into two parts:
0012:	Make mon_data and rmid_read structures point to mon_evt instead of
	just holding the event enum.
0013:	The "read from any cpu" part.
	Fixed bug reported by Chen Yu for use of smp_processor_id()
	New shortlog description. Fixed "cpumast" typo. Separated
	problem description from solution.
	Fixed reverse fir tree.
	Avoid "usually" comment (new comments in the helper function
	that moved out of __mon_event_count().

=== 13 ===

0014:	New direction. Don't bind specific value display formats
	to specific events, limiting other architectures to follow in
	the footsteps for the first to implement an event. Instead
	allow architecture to specify how many binary fixed-point bits
	are used for each event.

=== 14 ===

0015:	Add period to end of sentence in comment for resctrl_arch_pre_mount().
	Use atomic_try_cmpxchg() instead of atomic_cmpxchg().

=== 15 ===

0016:	Updated commit comment to avoid "with code".
	Dropped initialization of rdt_hw_resource::rid.


=== 16 ===
=== 17 ===
=== 18 ===
=== 20 ===
=== 21 ===
	These were "first part", "second part" ... of enumeration and
	the sanity check for adequate MMIO space to match expectations
	from the XML file layout description.

0017:
0018:
0019:
	Now describe what actions each part is doing. Building the
	struct event_group fields as needed for each patch.
	Split the fields into sets that are initialized from XML
	files, and fields used by resctrl code to manage groups.
	Fixed Link: lines with real URL to the Intel-PMT git repo.
	Changed type of guid from int to u32.
	Changed configure_events() return value from bool to standard
	integer error code (and use -ENOMEM, -EINVAL where appropriate).
	Document mmio_info structure and add an ascii art picture to the
	commit comment showing how it is used.
	Use kzalloc() instead of kmalloc()
	Add a helper function skip_this_region() so that counting
	regions and allocation for regions will do the same thing.


=== 19 ===

0020:	Add description of layout of MMIO counters to commit comment.

=== 22 ===

0021:	Fixed mmio address range check in intel_aet_read_event()
	Changed return code from -EINVAL to -EIO to meet expectations
	of rdtgroup_mondata_show().
	Changed name of VALID_BIT define to DATA_VALID to indicate that
	it shows that the value in a counter is valid (as opposed to the
	counter itself).
	Added check in resctrl_arch_rmid_read() that remainder of the
	function after the check for RDT_RESOURCE_PERF_PKG has been
	passed a RDT_RESOURCE_L3 resource.

=== 23 ===

0022:	Fix typo s/domsins/domains/
	Kept definition of struct rdt_perf_pkg_mon_domain in architecture
	code. Reinette comment "This may thus be ok like this for now".
	Since this only contains the rdt_domain_hdr, there isn't anything
	extra that file system code could look at even if it somehow
	wanted to.
	Things may be different for a more complex resource that has
	to maintain additional per-domain state that file system code
	may need to be aware of.

=== 24 ===

	I merged old patch 24 into new 0016

=== 25 ===

0023:	Unchanged

=== 26 ===

0024:	Split the hard-to-read rdt_check_option() function into two that
	have names that convey what they do: rdt_is_option_force_enabled()
	and rdt_is_option_force_disabled().

=== 27 ===

0025:	Updated commit comment and kerneldoc comment to note that
	pmt_event:num_rmids field is initialized from data in the
	XML file, but may be overwritten.
	Added min() operation to make sure num_rmids cannot be increased
	when processing additional event groups.

=== 28 ===

0026:	In V4 this added to the mount time initialization of the per-resource
	event lists. But that code has been dropped from this series. Added
	new one-time call in rdt_get_tree() (inside code where resctrl_mutex
	is held). Same basic function to compute the number of RMIDs as the
	minimum across all enabled monitor resources.

=== 29 ===
=== 30 ===

0027:
0028:	V4 presented these as RFC to add a debug info file for a resource. But
	after some thought I changed strategy so that the per-resource function
	can choose the name. Also avoids it showing up as an empty file in
	the info directory for other resources.

=== 31 ===

0029:	No changes.



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

Tony Luck (29):
  x86,fs/resctrl: Consolidate monitor event descriptions
  x86,fs/resctrl: Replace architecture event enabled checks
  x86/resctrl: Remove 'rdt_mon_features' global variable
  x86,fs/resctrl: Prepare for more monitor events
  x86/rectrl: Fake OOBMSM interface
  x86,fs/resctrl: Improve domain type checking
  x86,fs/resctrl: Rename some L3 specific functions
  x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
  x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Change generic domain functions to use struct
    rdt_domain_hdr
  x86,fs/resctrl: Rename struct rdt_mon_domain and rdt_hw_mon_domain
  fs/resctrl: Make event details accessible to functions when reading
    events
  x86,fs/resctrl: Handle events that can be read from any CPU
  x86,fs/resctrl: Support binary fixed point event counters
  fs/resctrl: Add an architectural hook called for each mount
  x86/resctrl: Add and initialize rdt_resource for package scope core
    monitor
  x86/resctrl: Discover hardware telemetry events
  x86/resctrl: Count valid telemetry aggregators per package
  x86/resctrl: Complete telemetry event enumeration
  x86,fs/resctrl: Fill in details of Clearwater Forest events
  x86/resctrl: x86/resctrl: Read core telemetry events
  x86,fs/resctrl: Handle domain creation/deletion for
    RDT_RESOURCE_PERF_PKG
  x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
  x86/resctrl: Add energy/perf choices to rdt boot option
  x86/resctrl: Handle number of RMIDs supported by telemetry resources
  x86,fs/resctrl: Move RMID initialization to first mount
  fs/resctrl: Add file system mechanism for architecture info file
  x86/resctrl: Add info/PERF_PKG_MON/status file
  x86/resctrl: Update Documentation for package events

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         |  53 ++-
 include/linux/resctrl.h                       |  97 ++++-
 include/linux/resctrl_types.h                 |  14 +
 arch/x86/include/asm/resctrl.h                |  16 -
 .../cpu/resctrl/fake_intel_aet_features.h     |  73 ++++
 arch/x86/kernel/cpu/resctrl/internal.h        |  30 +-
 fs/resctrl/internal.h                         |  87 ++--
 arch/x86/kernel/cpu/resctrl/core.c            | 314 ++++++++++----
 .../cpu/resctrl/fake_intel_aet_features.c     |  97 +++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 388 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  67 +--
 fs/resctrl/ctrlmondata.c                      | 108 ++++-
 fs/resctrl/monitor.c                          | 262 +++++++-----
 fs/resctrl/rdtgroup.c                         | 259 ++++++++----
 arch/x86/Kconfig                              |   2 +-
 arch/x86/kernel/cpu/resctrl/Makefile          |   2 +
 17 files changed, 1439 insertions(+), 432 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
 create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
base-branch: x86/cache
base-commit: 54d14f25664bbb75c2928dd0d64a095c0f488176
-- 
2.49.0

