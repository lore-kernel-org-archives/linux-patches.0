Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E7F221543
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496036; cv=none; b=CQP7rhDXs8pSZ5JdSSc0DMBYeYcoZyujBL4fhDczuxiZGm1BcBiNX7SkcA/WiHWXcDvkBceHr6Upw9QeVIPo9QExeKzup7Zh3wb4Bg8BAZTVRbvKAMv445pNzBOGu+orys6EIHuBdNJeCqzZwiGxgB78+5yYZLok28TQ/LwlATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496036; c=relaxed/simple;
	bh=ekupCWVmCs3phtAeh8G14Opz9yviCjMgv1k2WRHxsNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KIHAdETp9xEfIh7vuC6yqcsd58fOW0RvoBRH6oTbF6QkzU+2SA85FKy1F3q5ikPZVWvHW9rsOAHbmRmogEpVv9xXUPm/CQmkx5wbmODjcHQHGJxAhCPM1fof/4evnUgNRNu5VyWP4E6VfdLMpFX/3r8OkUmWZ7Cq4sAXMOdEfhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PhWiSo81; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PhWiSo81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496033; x=1788032033;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ekupCWVmCs3phtAeh8G14Opz9yviCjMgv1k2WRHxsNE=;
  b=PhWiSo81fjYOAkBNzhpV45UGxACl0JnkBVJUXd8Po3EcDxJpZ4WXBLkZ
   KxC3AFoSwm++7Z+13SE+WBN5nYzOnaHg5nGjbGisqdmCSUfV+MpwXkf5T
   FJI/cqAv4enOezgDsCQU521nOR0iG8wdvFMpVQRiuUaVyel44B4wd8gaO
   wR4UIWz1p23ho5JZcFgctxHYmBT3oo30jcfGIuyHIJaKf7LXD0EESZ005
   2d+uxZkVT8HNg5CT9S5wb/nyGmdm17fv9Qd6ctSA/eqVGgC2zDPsA30n/
   2j3TF633tYINY3Jiniz3kFb/Z+o+cnhsoi0+X4KMknUf8qDjcQ+Ark4EP
   g==;
X-CSE-ConnectionGUID: +v+KN9wZRU2a4kqk5ng1fg==
X-CSE-MsgGUID: qbduhq+PQoeQziLpQE8rNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625138"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625138"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:52 -0700
X-CSE-ConnectionGUID: VTGTdSJBTdu+bT2kdzRSPQ==
X-CSE-MsgGUID: txE9HPjmSMmVNxs6p8NJJQ==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:52 -0700
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
Subject: [PATCH v9 00/31] x86,fs/resctrl telemetry monitoring
Date: Fri, 29 Aug 2025 12:33:12 -0700
Message-ID: <20250829193346.31565-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series also available from the rdt-aet-v9 of:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git

Changes since v8 was posted here:
Link: https://lore.kernel.org/all/20250811181709.6241-1-tony.luck@intel.com/


--- cover ---
"INTEL_PMT_DISCOVERY" -> "INTEL_PMT_TELEMETRY"

--- 1 ---
No change

--- 2 ---
No change

--- 3 ---
No change

--- 4 ---
No change

--- 5 ---
"The "type" field provides" -> "rdt_domain_hdr::type provides"
Update final paragraph of commit message as suggested.

--- 6 ---
Code: in domain_add_cpu_mon() change WARN_ON_ONCE(1); in default case to
pr_warn_once("Unknown resource rid=%d\n", r->rid);


--- 7 ---
Code: in domain_remove_cpu_mon() move domain_header_is_valid()to
immediately before container_of() and switch check from r->rid to
hard-coded RDT_RESOURCE_L3.
s/list_del_rcu(&d->hdr.list);/list_del_rcu(&hdr->list);/

"separated" -> "separate"
"can skip" -> "skips"

--- 8 ---
Code: in domain_remove_cpu_ctrl()  move domain_header_is_valid()
to immediately before container_of().
s/list_del_rcu(&d->hdr.list);/list_del_rcu(&hdr->list);/
(moved here from patch 9)

"refactor" -> "refactor domain_remove_cpu_ctrl()"


--- 9 ---
Change second paragraph of commit comment as suggested.

"so the rmid_read::d field is replaced" -> "so replace the L3 specific domain
pointer rmid_read::d with rmid_read::hdr that points to the generic domain
header"

Use imperative tone for last paragraph "Update kerneldoc for mon_data::sum ..."

--- 10 ---
Change rdt_mon_domain to rdt_l3_mon_domain in comment above logical_rmid_to_physical_rmid()

Replace entire commit comment with improved version.

--- 11 ---
"different resources" -> "a different resource"
"these functions" -> "the L3 resource specific functions"
"Two groups of functions renamed here:" -> "Rename three groups of functions:"
Added rdt_get_mon_l3_config() to list of renamed functions to put the "l3"
before the "mon" for consistency.

When changing names for resctrl_mon_resource_{init,exit} add the "l3_" before
"mon" for consistency with other *l3_mon*" naming.

--- 12 ---
"to lower levels" -> "via the mon_data and rmid_read structures to
the functions finally reading the monitoring data."

Replace 3rd paragraph of commit comment with supplied better version.

--- 13 ---
Code: In cpu_on_correct_domain() s/return -EINVAL;/return false;/

--- 14 ---
Code: Move definition of MAX_BINARY_BITS from <linux/resctrl.h> to
fs/resctrl/internal.h.

Be explicit in commit comment that the file system makes the determination
on which events can be displayed in floating point format.

--- 15 ---
"asyncronnous" -> "asynchronous"
"for these drivers" -> "of these drivers"
"are called" -> "completes"
"But expectations" -> "Expectations"
"The call is made with no locks held." -> "resctrl filesystem calls the
hook with no locks held."

--- 16 ---
s/CPU hotplug/CPU hot plug/
Add Reinette's RB tag.

--- 17 ---
Code:
"OOBMSM" -> "INTEL_PMT_TELEMETRY"
"INTEL_PMT_DISCOVERY" -> "INTEL_PMT_TELEMETRY"
re-wrap comment for get_pmt_feature() to use 80 columns.
"OOBMSM discovery" -> "INTEL_PMT_TELEMETRY"
Add the intel_pmt_put_feature_group() calls to intel_aet_exit()
to match the intel_pmt_get_regions_by_feature() calls in get_pmt_feature()
using a new macro for_each_enabled_event_group().
Rename discover_events() to enable_events()

Add period at end of help text in arch/x86/Kconfig.

"Data for telemetry events is collected by each CPU and sent" ->
"Each CPU collects data for telemetry events that it sends"
"is changed" -> "changes"
"or when two milliseconds have elapsed" -> "or when a two millisecond timer expires"
"mad" -> "made"
"Enumeration of support for telemetry events is done" ->
"The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events."
Drop references to INTEL_PMT_DISCOVERY driver.

Merge last two paragraphs of commit message.

Reformat commit to use more of page width.

Add maintainer note about checkpatch complaints for DEFINE_FREE()

--- 18 ---
Dropped. See new patch 0019

--- 19 ---
Dropped. See new patch 0019

--- 20 ---
Now 0018
Rewrite opening paragraph to avoid "continuation of the subject"

Add note/link on the source of the XML files that describe events.

--- 21 ---
Now 0019
Drop "vague first sentence" of second paragraph.

--- NEW 0020 ---
Replaces most of parts 18/32 and 19/32.
Contains skip_this_region() from patch 18/32, but skips all the
code to count regions and allocat pkg_mmio_info[].
The active_event_groups list is also removed in this refactor.

Also includes event enabling code from 22/32

--- 22 ---
Now 0021
Modify intel_aet_read_event() to dig into pmt_event::pfg to
find the MMIO base addresses that v8 patch stored in the pkg_mmio_info[]
structures.

--- 23 ---
Now 0022
Add domain_header_is_valid() check in domain_remove_cpu_mon()
before using container_of().

"There are structures" -> "There are per domain structures ..."

Replace my commit fix description with better version from Reinette.

--- 24 ---
Now 0023
Unparseable last sentence of commit message replaced with details
and examples.

--- 25 ---
Now 0024
RMIDS -> RMIDs
"Adjusted downwards ..." -> "May be adjusted downwards ..."
check_rmid_count() -> all_regions_have_sufficient_rmid()
"Potentially disable" -> "Disable"
Add comment:
/* e->num_rmids only adjusted lower if user forces an unusable region to be usable */

--- 26 ---
Now 0025
Add "during resctrl initialization" and "during resctrl exit" to commit
background statement.

Add "closid_num_dirty_rmid[]" to be specific about what is being allocated/freed.

--- 27 ---
Now 0026
"mon capable" -> "mon_capable" (three times)
"alloc capable" -> "alloc_capable"
"rdt_l3_mon_domain::states[]" -> "rdt_l3_mon_domain::mbm_states[] and
+rdt_l3_mon_domain::rmid_busy_llc"

"the number of RMIDs" -> "the system's number of RMIDs"

--- 28 ---
Now 0027
Add comment to setup_rmid_lru_list() to note that rmid_ptrs[]
is allocated of first mount and is reused on subsequent mounts.
It is freed in resctrl_exit().

Lock/unlock rdtgroup_mutex around body of free_rmid_lru_list()

Rewrite commit based on suggestions with some modifications to explain
why error paths in rdt_get_tree() do not call free_rmid_lru_list().

--- 29 ---
Now 0028
TODO: recheck for use of "CPU hot plug notifiers" may have been called "hooks", "callbacks", and
"handlers" through this series.

--- 30 ---
Now 0029
"a resource" -> "a monitoring resource"

--- 31 ---
Now 0030
"last_update_timestamp" -> "agg_last_update_timestamp" in commit comment

Move creation of debugfs files to the end of enable_events().

Rewrite to work based on event_group::pfg since event_group::pkginfo[] is gone.

--- 32 ---
Now 0031
Describe "num_rmids" file values independently for L3 and telemetry.
Move the note about upper bound on directory creation to its own
paragraph to say it is the smaller of reported "num_rmids" values.

"or of a processor package" -> "another for each processor package"

Change paragraph about contents of subdirectories of mon_data to
give example file names instead of hard coding specifics.

Improve documentation for "core_energy" to make it clear that is
is collected per logical CPU and the "core" in the name refers
to the scope of the energy collection.

Fix debugfs documentation to match implementation.

prescence -> presence
will vary -> may vary
last_update_timestamp -> agg_last_update_timestamp

Simplify commit comment as suggested.



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

Tony Luck (31):
  x86,fs/resctrl: Consolidate monitor event descriptions
  x86,fs/resctrl: Replace architecture event enabled checks
  x86/resctrl: Remove 'rdt_mon_features' global variable
  x86,fs/resctrl: Prepare for more monitor events
  x86,fs/resctrl: Improve domain type checking
  x86/resctrl: Move L3 initialization into new helper function
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
  fs/resctrl: Move allocation/free of closid_num_dirty_rmid
  fs,x86/resctrl: Compute number of RMIDs as minimum across resources
  fs/resctrl: Move RMID initialization to first mount
  x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
  fs/resctrl: Provide interface to create architecture specific debugfs
    area
  x86/resctrl: Add debugfs files to show telemetry aggregator status
  x86,fs/resctrl: Update Documentation for package events

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         |  99 ++++-
 include/linux/resctrl.h                       |  87 +++-
 include/linux/resctrl_types.h                 |  26 +-
 arch/x86/include/asm/resctrl.h                |  16 -
 arch/x86/kernel/cpu/resctrl/internal.h        |  58 ++-
 fs/resctrl/internal.h                         |  71 +++-
 arch/x86/kernel/cpu/resctrl/core.c            | 315 +++++++++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 381 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  80 ++--
 fs/resctrl/ctrlmondata.c                      | 123 +++++-
 fs/resctrl/monitor.c                          | 315 ++++++++-------
 fs/resctrl/rdtgroup.c                         | 272 ++++++++-----
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 15 files changed, 1400 insertions(+), 459 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.50.1

