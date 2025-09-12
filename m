Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94E727280C
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715062; cv=none; b=NyeK6S7ZRzfniwA5aeODSixthCKXZo3JBAFgs0yfKfO5kYEETCoNfrojQ5Bm7mjYCbDT942/Cvb0zea9N+r4iVaXOwX0mpZ5yv3HEOvKvjwY2a4x97nRoD1X6i80nsMlvgZ4RG+TCfE3VevECUkfG5Wra90GnlfSlMgeR7IczmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715062; c=relaxed/simple;
	bh=DiBayef41YfWpvy6DdcmqZMIJ4XtHN3uU/lcxUybCWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TKP2RyXgt7PurjjzCNb0aI0nST2sdUBKlezVqm38BjrevN9rizOWNaPC6yKQbPj7BrgX4j83EceQDXfDJLfa0Se94ZARufVbfx4iw9880p5kZ+UamRPtKH0az9JDSG+lhH2DzPyLUgklcpSIgXLgEl8vaO7la7iwAK2D4nB8gHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=awafzqBR; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="awafzqBR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715061; x=1789251061;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DiBayef41YfWpvy6DdcmqZMIJ4XtHN3uU/lcxUybCWw=;
  b=awafzqBRFEGMbo2DvCOfMw3NlRSQcrXi6ukmDSDEn+SNRwFC3POSAHpK
   hwhiVKcn0+f0UJioTEIiOClNKKuKk32PkUhO3G/4OAQD1MPn0aJN6GnaY
   dH7m1FHjMIIlbq58vEnNc1E0k8bLrAdoiqylnIZUsgvqfdVowxNbyoln0
   N29vRgxsBI/M8lvTKhsRhYNyotzl14gTwHlSQGwetZnM/C/tQcdMDfbC2
   6Gv6juzdughHqx4aBrEM3rNtDPSZqHFsBMwxmNFavde903Q9hQgxHCqab
   YbphU+AStI/mO0ZptebZG7MXzMxcsrRSCoz9iZb50Nkshhy5RqRSAp+PD
   Q==;
X-CSE-ConnectionGUID: MYx3AVvqQmiAWhV5ZtRpaQ==
X-CSE-MsgGUID: jui/QKlRSnGp+6SCcdWnsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002608"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002608"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:00 -0700
X-CSE-ConnectionGUID: sQHLil0lTJyl55U5+JvYUw==
X-CSE-MsgGUID: KWYvAMZ6RA+STpukn6aC6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265110"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:00 -0700
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
Subject: [PATCH v10 00/28] x86,fs/resctrl telemetry monitoring
Date: Fri, 12 Sep 2025 15:10:21 -0700
Message-ID: <20250912221053.11349-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patches based on tip tree x86/urgent branch plus Babu's v18 ABMC series.

Top commit of x86/urgent at time of my snapshot was:
d2e1b84c5141 ("fs/resctrl: Eliminate false positive lockdep warning when reading SNC counters")

Babu's ABMC series here:
Link: https://lore.kernel.org/all/cover.1757108044.git.babu.moger@amd.com/

The combination of above components plus this series is here:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v10

Top commit:
89f7ddfa06e1 ("x86,fs/resctrl: Update Documentation for package events")

This series is the most recent 28 patches in that branch.

Changes since v9 was posted here:
Link: https://lore.kernel.org/all/20250829193346.31565-1-tony.luck@intel.com/

(v9 patch numbers in "--- # ---" format. V10 references in "00##" format.)

--- 1 ---
--- 2 ---
--- 3 ---
--- 4 ---
First four patches are included in Babu's ABMC seriess so dropped
from here.

--- 5 ---
Now 0001
Added Reinette RB tag

--- 6 ---
Now 0002
Drop domain_header_is_valid() from domain_add_cpu_mon()
cpu_on_correct_domain() mostly pulled from patch 13 back to here as part
of refactor on top of Babu ABMC code

--- 7 ---
Now 0003
Drop changes to resctrl_offline_mon_domain() from this patch
and apply later in series when adding support for PERF_PKG
resource.

--- 8 ---
Now 0004
Added Reinette RB tag

--- 9 ---
Old patch 9 split into two parts:

New 0005 patch handles domain addition/deletion and puts temporary
"d = container_of(hdr, struct rdt_mon_domain, hdr);: into mon_event_read()
TODO: Add a post "---" commit comment explaining the mon_event_read() bit.

New 0006 patch covers to call chain from mon_event_read() through
to resctrl_arch_{cntr,rmid}_read() 

Drop check for "if (r->rid != RDT_RESOURCE_L3)" from resctrl_arch_rmid_read()
this "can never happen" case is handled by following domain_header_is_valid()

Drop call to domain_header_is_valid() in single domain branch of
rdtgroup_mondata_show() that has no following contain_of() that needs
to be checked.

Drop SNC related checks for RDT_RESOURCE_L3 from this patch. Defer until
addition of PERF_PKG resource.

--- 10 ---
Now 0007
Added Reinette RB tag

--- 11 ---
Now 0008
Added Reinette RB tag

--- 12 ---
Now 0009
Added Reinette RB tag

--- 13 ---
Now 0010
cpu_on_correct_domain() was added earlier in patch 6. Just add the
test for rr->evt->any_cpu.

--- 14 ---
Now 0011
"0.5." -> "0.5" nit in commit message
Added Reinette RB tag

--- 15 ---
Now 0012
Added Reinette RB tag

--- 16 ---
Now 0013
No change

--- 17 ---
Now 0014
Ilpo:
Add includes for <linux/array_size.h>, <linux/err.h> <linux/types.h>
Add "()" around use of _grp argument in macro for_each_enabled_event_group()
"If there is one the returned structure" -> "If there is one, the returned structure"
Change type of "ret" in get_pmt_feature() from int to bool.
Commit comment: Dropped extra space "run time.  Those" -> "run time. Those"

Reinette:
Update keneldoc for event_group::pfg
"driver for the pmt_feature_group" -> "for a copy of the pmt_feature_group"
Kconfig: Just use "depends" not a mix with "if"
"changed" -> "changes"
Clarified that all aggregators ccount the same set of events.
Provide URL to Intel-PMT GitHub repository as footnoted Link: tag.
"this aggregator" -> "an aggregator"
"where the CPUs that report" -> "where the all the CPUs that report"
"for each pmt_feature_id that indicates per-RMID telemetry" -> "for each
per-RMID telemetry feature ID/id"
Take suggested final commit paragraph suggestion.

Tony:
Add <linux/init.h> for __exit
Add <linux/intel_pmt_features.h> for FEATURE_PER_RMID_PERF_TELEM and
    FEATURE_PER_RMID_ENERGY_TELEM
Add <linux/overflow.h> for array_size()
Add <linux/stddef.h> for NULL

--- 18 ---
Now 0015
Ilpo: Add <linux/types.h> (applied to patch 17 as suggested)

Reinette:
"pmt" -> "PMT"
Link to GIT repository as foot note Link tag.
"The offsets" -> "The event counter offsets"
Add details of three status registers at end of MMIO region.

Tony:
Add <linux/compiler_types.h> for __counted_by()
Add <linux/resctrl_types.h> for resctrl_event_id

--- 19 ---
Now 0016
Added Reinette RB tag

--- 20 ---
Now 0017
Ilpo:
skip_this_region() rename to skip_telem_region()
s/pr_warn_once()/pr_warn()/ both places in skip_telem_region()
Add <linux/printk.h> for pr_warn()

Reinette:
Print package ID as unsigned in skip_telem_region()
"INTEL_PMT" -> "INTEL_PMT_TELEMETRY"

Tony:
Add <linux/topology.h> for topology_max_packages()

--- 21 ---
Now 0018
Ilpo:
Add <linux/bits.h> for BIT_ULL() && GENMASK_ULL()
Add <linux/container_of.h> for container_of() (done earlier)
Moved p->regions[i].addr = NULL; into its own helper.
Moved comment on why this is safe from commit message
into the code.

Reinette:
Change type of rmid parameter to intel_aet_read_event() to u32
Also local variable idx change to u32 and print using %u
Simplfy the commit comment with fewer details of the code.

Tony:
Add <linux/errno.h> for EINVAL

--- 22 ---
Now 0019
rdtgroup_mondata_show(), mon_get_kn_priv()
s/<SPACE>*/><TAB>/ in definiton of rdt_perf_pkg_mon_domain::hdr
intel_aet_setup_mon_domain() -> intel_aet_mon_domain_setup()
Deferred checks from patches 7-10 that SNC domain summing code
is only used for RDT_RESOURCE_L3 now included here.

Tony:
Add <linux/cpumask.h> for cpumask_set_cpu()
Add <linux/rculist.h> for list_add_tail_rcu(), list_del_rcu()
Add <linux/rcupdate.h> for synchronize_rcu()
Add <linux/slab.h> for kzalloc_node(), kfree()

--- 23 ---
Now 0020
Reformat comment above rdt_is_feature_enabled() to use more of
page width.
Merge pairs of sentences in commit into fewer paragraphs.
Delete garbage from end of commit comment.

--- 24 ---
Now 0021
In kerneldoc for struct event_group "djusted" -> "adjusted". Fix
code width to stay within 80 columns.
Applied comments I mssed from v8.
Use -> Introduce
Added comment how user force enabling a resource will affect
number of moniitoring resource groups.

--- 25 ---
Now 0022
Add "[]" to closid_num_dirty_rmid in Subject: line.
Add test "if (!r->mon_capable)" for early return from
resctrl_l3_mon_resource_exit()
Add commit comment that it isn't necessary to hold rdtgroup_mutex
while allocating/freeing closid_num_dirty_rmid[].

--- 26 ---
Now 0023
Applied missed v8 comments states[] -> mmb_states[] and
"rdt_l3_mon_domain::rmid_busy_llc created during resctrl initialization".
Fix comment above domain_setup_l3_mon_state() to note that it is
called when the CPU online callbacks are executed.

--- 27 ---
Now 0024
Move test for resctrl_arch_mon_capable() from rdt_get_tree() inside
setup_rmid_lru_list() and add a symmetrical check to free_rmid_lru_list()
Add note to commit comment that rmid_ptrs[] may be accessed after unmount
by the limbo handler.

--- 28 ---
Now 0025
Fix commit comment to be high level description rather than just
what can be seen in the patch.

--- 29 ---
Now 0026
Fix kerneldoc for return value from resctrl_debugfs_mon_info_arch_mkdir()

--- 30 ---
Now 0027
Check return from resctrl_debugfs_mon_info_arch_mkdir() using IS_ERR_OR_NULL()
Describe the "instance number" in commit comment as an opaque value to
provide unique file names.
Tony:
<linux/fs.h> for DEFINE_SIMPLE_ATTRIBUTE()
<linux/sprintf.h> for sprintf()

--- 31 ---
Now 0028
"smaller of the "num_rmids" values" ->
"smaller of the L3_MON and PERF_PKG_MON "num_rmids" values"

"        This contains a set of directories, one for each instance
        of an L3 cache, another for each processor package." ->
"        This contains directories for each monitor domain. One set for each instance
        of an L3 cache, another set for each processor package."
Added note that the info/*/mon_features files enumerate all events.
prescence -> presence
will vary -> may vary
Drop "when and how often the hardware has failed" since only two
of the files deal with problems.

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
Tony Luck (28):
  x86,fs/resctrl: Improve domain type checking
  x86/resctrl: Move L3 initialization into new helper function
  x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Clean up domain_remove_cpu_ctrl()
  x86,fs/resctrl: Use struct rdt_domain_hdr instead of struct
    rdt_mon_domain
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
  x86/resctrl: Read telemetry events
  x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
  x86/resctrl: Add energy/perf choices to rdt boot option
  x86/resctrl: Handle number of RMIDs supported by telemetry resources
  fs/resctrl: Move allocation/free of closid_num_dirty_rmid[]
  fs,x86/resctrl: Compute number of RMIDs as minimum across resources
  fs/resctrl: Move RMID initialization to first mount
  x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
  fs/resctrl: Provide interface to create architecture specific debugfs
    area
  x86/resctrl: Add debugfs files to show telemetry aggregator status
  x86,fs/resctrl: Update Documentation for package events

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         | 100 ++++-
 include/linux/resctrl.h                       |  69 ++-
 include/linux/resctrl_types.h                 |  11 +
 arch/x86/kernel/cpu/resctrl/internal.h        |  50 ++-
 fs/resctrl/internal.h                         |  58 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 260 ++++++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 417 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  52 ++-
 fs/resctrl/ctrlmondata.c                      | 123 +++++-
 fs/resctrl/monitor.c                          | 343 ++++++++------
 fs/resctrl/rdtgroup.c                         | 196 +++++---
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 14 files changed, 1338 insertions(+), 357 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

-- 
2.51.0

