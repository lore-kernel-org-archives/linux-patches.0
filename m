Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EC221421A
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956592; cv=none; b=mLySZv06QS8v08jAH+wx5aGKRGwnQCsrC7w3O0/YPyuwaDNekTWM5OZQy9WFRt1QQJMNo5mDh0a2/yIGDVT7a8FukJ6/RPTVWyoIMdF7EnSqjGXpIAd6OYKJfmNIhbD/nfpUkCCh49Qdq2BrP3ga2IJJbfG4xdS9IqN543Od+70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956592; c=relaxed/simple;
	bh=ZRectOjIY4vdgYoK5HYofsQHVlNJmC+vj4S/Bt4aCq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P32xgFqnLCpNV2m8uwIWpHRxiJ6aYSeeMggHcmE/8TD1BWQeLQ8v4P8jw/Juj5LD9xcwlTHdSju2apVw7bPDIWOsvii/LQV6jDQIE8eYtr1GW6XQtcWYcJWvVPIvcMd1FOrkDejIyklrWEVHJy+B9bH0/BceYp44aldqN/k8jd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W06/Wqxn; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W06/Wqxn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956591; x=1782492591;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZRectOjIY4vdgYoK5HYofsQHVlNJmC+vj4S/Bt4aCq4=;
  b=W06/WqxnDCjVmcSm/ioMFh3ptFqeDAAy8fs84cCBceoXzPGOLy18Idi3
   BcTxMh6owSsWZ8dRKMxO6RcAdXtPEQbqDpX6Hju4Vbvd0rEGAy7eMxjB+
   MHFmUuF2D1OxZvnOesq8FMMKhi2IuIr5NhdqCK3W/4lsZwFrit6mdGmx7
   AwMZm2R+4S9NWmu4LZkOa2itlKg2lXfXEYh82P7hoXKlN3TBfic2qVShe
   ulVZvybP14EgihavkkMUI25wvU48EMbC1iksHvou+yt9ZlLMjueE/xNNQ
   3n9QXs19LsA0n/tu6TlBwd7/AiqNhZy2r0AKGdIeVODRCutXlt6emxOsR
   g==;
X-CSE-ConnectionGUID: x4oWIc4ET4ecLxCiIFx2uQ==
X-CSE-MsgGUID: 1cgggB0iShy/7klMS4QxkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136310"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136310"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:51 -0700
X-CSE-ConnectionGUID: ejeKlIPlR4uCUowqAU4D7Q==
X-CSE-MsgGUID: PVdFgdVsTXiMQf3YS/IBww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069133"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:49 -0700
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
Subject: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
Date: Thu, 26 Jun 2025 09:49:09 -0700
Message-ID: <20250626164941.106341-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These patches are based v6.16-rc3 plus David Box's V2 series for
"Intel VSEC/PMT: Introduce Discovery Driver" posted here:

Link: https://lore.kernel.org/all/20250617014041.2861032-1-david.e.box@linux.intel.com/

I've pushed "v6.16-rc3 + David's patches" to:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git davidboxv2

The total set (v6.16-rc3 + David's patches + this series) is here:

git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v6

The first four patches of this series are shared with Babu's ABMC
series. Perhaps if all issues in these four patches are resolved here
these patches could move to upstream?

Note that patches 0017 onwards of this V6 series depend on David's patches
so can't go upstream until that series is merged.

Changes since v5 was posted here:

Link: https://lore.kernel.org/all/20250521225049.132551-1-tony.luck@intel.com/

Change map indexed by patch numbers in v5. Some patches have been merged,
split, dropped, or re-ordered. The v6 patch numbers are referred to
by their 4-digit git format-patch numbers in an attempt to avoid
confusion.

 --- 1 ---
Fixed extra space in commit message

Changed to consistent use of "eventid" for variables/arguments
of type "enum resctrl_event_id" in routines touched by this
series.

Added resctrl_event_id::QOS_FIRST_EVENT and used it as lower bound
when looping over all events.

Added #define for_each_mon_event() to iterate over all events.

s/Description of a monitor event/Properties of a monitor event/

 --- 2 ---
Use QOS_FIRST_EVENT as lower bounds check in resctrl_is_mon_event_enabled().


 --- 3 ---
Replaced changelog with Reinette's improved version.

 --- 4 ---
Add for_each_mbm_event_id() helper to iterate over MBM events.

Peter: Use sizeof(*hw_dom->arch_mbm_states[0]) instead of sizeof(struct arch_mbm_state)
(ditto for "struct mbm_state" instance).

Replaced kerneldoc description of rdt_mon_domain::mbm_states with Reinette's
improved version. Ditto for rdt_hw_mon_domain::arch_mbm_state.

Fixed resctrl_arch_reset_rmid_all() to use same coding pattern of
looping on enabled events instead of checking if rdt_hw_mon_domain::arch_mbm_state
has been allocated.

In get_mbm_state() use local variable name "state" (singular) to match other
code patterns.

Drop duplicate @arch_mbm_states: in kerneldoc for struct rdt_hw_mon_domain.

Drop " or combined CLOSID, RMID on Arm" from @arch_mbm_states description.

Use sizeof(*hw_dom->arch_mbm_states[0]) in resctrl_arch_reset_rmid_all().

Add new macro for_each_mbm_idx() (suggested by Fenghua). Use
it in mon_domain_free() and domain_destroy_mon_state(). Also to
avoid landmines in "cleanup:" code in arch_domain_mbm_alloc() and
domain_setup_mon_state().

 --- 5 ---
Patch dropped. No need for fake definitions of OOBMSM access routines and
structures because the real patches have been posted by David Box. Version
2 of his series here:
https://lore.kernel.org/all/20250617014041.2861032-1-david.e.box@linux.intel.com/

 --- 6 ---
Now 0005 in V6 series.
Updated the domain_header_is_valid() check in rdtgroup_mondata_show() to
explicitly test for RDT_RESOURCE_L3 since at this point in the series only
the L3 resource is possible, or valid. Similar change in subsequent patches
where routines to process only struct rdt_mon_domain make consistency checks.


 --- 7 ---
Moved later to patch 0011 when it becomes a little clearer which renames
are useful, and which may be just noise. Functions that now take a
"struct rdt_l3_mon_domain" argument are obviously for L3 only and don't
need a rename to make that clear.


 --- 8 ---
Now patch 0006. No comments received on V5 version of this patch.


 --- 9 ---
Now patch 0007.
s/goto done/goto out_unlock/

Changes to make symmetric cleanups to domain_remove_cpu_ctrl()
to match the code flow changes that were made to domain_remove_cpu_mon()
split out into new patch 0008.


 --- 10 ---
Now patch 0009.
Anil reported that "d" was used uninitialized in domain_remove_cpu_ctrl().

Fenghua reported an error path that did not unlock the rdtgroup_mutex.

Reinette reported change unrelated to commit message. Moved this to
new patch 0008 (now with change log).

Several domain_header_is_valid() checks now check for RDT_RESOURCE_L3.

Updated kerneldoc comments for struct mon_data to says that @sum is only
used for RDT_RESOURCE_L3.

Updated kerneldoc for mon_get_kn_priv() @do_sum to say it is only
meaningful for L3 domain and added a WARN_ON_ONCE() if this some other
resource tried to set do_sum.

More functions changed to pass struct rdt_domain_hdr. Specifically the
call chain from rdtgroup_mondata_show() down to resctrl_arch_rmid_read()
(via the smp_call*()) so rmid_read::d has been replaced by rmid_read::hdr.


 --- 11 ---
Now patch 0010.Completing this patch before the function renaming
(was patch 7, now 0011) makes it clearer where renames are useful.


 --- 12 ---
No comments received for this patch (patch numbers now aligned as
this is 0012 in V6).

 --- 13 ---
Updated commit comment with better text from Reinette.

s/goto done/goto out_ctx_free/

Changed polarity and name of helper function from cpu_on_wrong_domain()
to cpu_on_correct_domain() to avoid double negatives.


 --- 14 ---
Add mon_evt::is_floating_point set by resctrl file system code to limit
which events architecture code can request be displayed in floating point.

Simplified the fixed-point to floating point algorithm. Reinette is
correct that the additional "lshift" and "rshift" operations are not
required. All that is needed is to multiply the fixed point fractional
part by 10**decimal_places, add a rounding amount equivalent to a "1"
in the binary place after those supplied. Finally divide by 2**binary_places
(with a right shift).

Explained in commit comment how I chose the number of decimal places to
use for each binary places value.

N.B. Dave Martin expressed an opinion that the kernel should not do
this conversion. Instead it should enumerate the scaling factor for
each event where hardware reported a fixed point value. This patch
could be dropped and replaced with one to enumerate scaling factors
per event if others agree with Dave.


 --- 15 ---
Initialize atomic in resctrl_arch_pre_mount() using ATOMIC_INIT(0).

 --- 16 ---
No comments received on this patch.


 --- 17 ---
Changed comment in struct event_group from " Data fields used by this code."
to "Data fields for additional structures to manage this group."

Removed line continuations for DEFINE_FREE(). Though checkpatch is still
not happy. My following line is a "if" statement. Checkpatch wants this
to both 1) Line vertically with the "(" on preceeding line, and 2) Not
use <TAB> followed by some <SPACE> characters to make that happen.

Refactored the interface between get_pmt_feature() and configure_event()
per-Reinette's suggestion to avoid both functions looping through the
p->count entries in the pmt_feature_group structure.

Kconfig changes here ensure that David's INTEL_PMT_TELEMETRY code is
built-in to the kernel so it can be used by resctrl.


 --- 18 ---
Define a macro XML_MMIO_SIZE() as a way to document the hard-coded numbers
used to calculate the expected size of the mmio region.

If the MMIO size reported by intel_pmt_get_regions_by_feature() is smaller
than expected, print that size as part of the warning message.


 --- 19 ---
Rename mmio_info::count to mmio_info::num_regions.

Fix typo s/[0]/[1]/g in ascii art commit message structure diagram.

Take better suggestions for kerneldoc descriptions of mmio_info
structure and the @num_regions and @addrs fields.

Add a period for event_group::pkginfo kerneldoc description.

Fix declaration of **pkginfo in configure_events()

Add "_once" for "Duplicate telemetry" warning.

 --- 20 ---
Shorten field names pmt_event::evtid -> pmt_event::id and pmt_event:evt_idx
becomes pmt_event::idx.

Fenghua: Align each of th struct event_group on the "=".

Anil: Use a macro to initialize entries in mon_event_all[]. This could
be done in patch 1, but with only three events at that point the visual
clutter wasn't too awful.


 --- 21 ---
Split into:
0021: Add mon_evt::arch_priv void pointer that can be set by architectural
code when enabling an event, and passed through to resctrl_arch_rmid_read()

0022: Code to set the arch_priv pointer and use it find the containing
struct event_group for the parameters to read counter from MMIO space.
Note that due to changes in part 0009 resctrl_arch_rmid_read() takes
a struct rdt_domain_hdr argument.


 --- 22 ---
Now 0023: Keep "default:" as last option in switch in domain_remove_cpu_mon().

Comments about "goto mkdir" (was "goto do_mkdir" covered by change in
patch 0009.

 --- 23 ---
Moved to patch 0027.

No comments received for this patch. But one small change. Now
sets r->mon_capable = true; in intel_aet_get_events() so this is
done before the calculation of the minimum of RMIDs supported
in part 0025.


 --- 24 ---
Changed to address Reinette's point that initial implementation
would not work in the same way as other boot choices. Specifically
if a quirk disables a feature because of an erratum, the user should
be able to override from the command line and use it anyway.
This patch provides the option for user to disable a telemetry
feature from the command line. The force enable option moved to
next patch where it is used.


 --- 25 ---
Improved commit comment per-Reinette suggestion.

s/Will be adjusted/Adjusted/ in kerneldoc for event_group::num_rmids

Improved text for comment on not configuring a telemetry feature that
has fewer RMIDs than supported by IA32_PQR_ASSOC.

Second part of command line implementation is here to allow user to
override the fewer RMIDs issue and use a resource anyway.

 --- 26 ---
Back in sync with patch 0026. No comments received for this patch.

 --- 27 ---
Changed from providing a mechanism for architecture code to create
a custom "info/{resource}" file to providing a debugfs directory
for use by a monitor resource. Discussion on the name of the directory
fizzled out. I've gone with:
	/sys/kernel/debug/resctrl/info/{resource}_MON/{utsname()->machine}

 --- 28 ---
No comments on this patch. Changed to create one debugfs file for each
value from each aggregator instance.


 --- 29 ---
No comments on this patch.



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

Tony Luck (30):
  x86,fs/resctrl: Consolidate monitor event descriptions
  x86,fs/resctrl: Replace architecture event enabled checks
  x86/resctrl: Remove 'rdt_mon_features' global variable
  x86,fs/resctrl: Prepare for more monitor events
  x86,fs/resctrl: Improve domain type checking
  x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
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
  x86,fs/resctrl: Add and initialize rdt_resource for package scope core
    monitor
  x86/resctrl: Discover hardware telemetry events
  x86/resctrl: Count valid telemetry aggregators per package
  x86/resctrl: Complete telemetry event enumeration
  x86,fs/resctrl: Fill in details of Clearwater Forest events
  x86,fs/resctrl: Add architectural event pointer
  x86/resctrl: Read core telemetry events
  x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
  x86/resctrl: Add energy/perf choices to rdt boot option
  x86/resctrl: Handle number of RMIDs supported by telemetry resources
  x86,fs/resctrl: Move RMID initialization to first mount
  x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
  fs/resctrl: Provide interface to create a debugfs info directory
  x86/resctrl: Add debug info/PERF_PKG_MON/status files
  x86,fs/resctrl: Update Documentation for package events

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         |  53 ++-
 include/linux/resctrl.h                       |  84 +++-
 include/linux/resctrl_types.h                 |  26 +-
 arch/x86/include/asm/resctrl.h                |  16 -
 arch/x86/kernel/cpu/resctrl/internal.h        |  31 +-
 fs/resctrl/internal.h                         |  56 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 333 ++++++++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 411 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  78 ++--
 fs/resctrl/ctrlmondata.c                      | 130 +++++-
 fs/resctrl/monitor.c                          | 267 +++++++-----
 fs/resctrl/rdtgroup.c                         | 253 +++++++----
 arch/x86/Kconfig                              |   5 +-
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 15 files changed, 1327 insertions(+), 419 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
base-branch: davidboxv2
base-commit: 4742bf1fab91403ca48efc45f7f7fd68a156a955
-- 
2.49.0

