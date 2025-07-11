Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910B9223DEF
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278032; cv=none; b=r2hDIaWkD9y+mMtFe3yUyPfAuJFsomTvCMlzY5B6U9+CcBvYZwopWR1n+uRVhtuLoV/opWYopwdkyWVJcak6SYTQJ/cLst3wKsW6T7Xip5KkLB8VbaNnkNbqFzN20yG4ts5wv/cpMgFZGBh3tNKkvvm9j4/LyOW+Xcd2zaa/lrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278032; c=relaxed/simple;
	bh=48/rEGql6LFt+wqIZk3fqRhCStQzUmOxGpoA0dXbdog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rSRtD26VV6g7BtOfza3ZkwJn7zn+oh2vsp/eIYdiSWP22cjVH9yeh98HEC4h3DkeFeMFWS4lNcjoCDQEGMl0R3XLHeq399GwAh7KhMRc552aeyup9f7prU2foNHjB32JV3wS7j6wMuMkf2MjJLet6PAL8lfzlruZ3LPFHjZAimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eSCQq6d4; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eSCQq6d4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278030; x=1783814030;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=48/rEGql6LFt+wqIZk3fqRhCStQzUmOxGpoA0dXbdog=;
  b=eSCQq6d4tKcM3z/5F06BXa3EmCWJXMWD5VYVnbcSkhHfsdy9jYOq5q0j
   sReP2rVZcR9UAUjCDy+66ovG2ZRhUj0gvPdmutu/TXMlbo2cmXyRC90m8
   +g3RVUlhEX7hbyXQlX0cHY+IFn3WkB0+ITJC88aaavpfU/iIb3JBPQiFJ
   gR4DgOixTQrECwxYH3/p8sKOxG1VxSYF+XowDaEyZV59CL/hguAC+20az
   RJ5G0OVwfUgnUer4/zGSlv4S7RljCLYm7GjeSrpvrlucvWcMpZg1hSJqk
   zl9HHd0FSgatIOrgEE0mCnwc8GvMltPNgbTfA8pTY5LN/su4W1C8D71oN
   g==;
X-CSE-ConnectionGUID: RirmZXCrRD2VXDE2BQOCeg==
X-CSE-MsgGUID: tApIn7nKSSOJ/zeVfKfACQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292569"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292569"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:49 -0700
X-CSE-ConnectionGUID: LjAetuRIQ7C7a5sBuKoKAw==
X-CSE-MsgGUID: m3Fi05cNS72J7LhYDJxf6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902086"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:50 -0700
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
Subject: [PATCH v7 00/31] x86,fs/resctrl telemetry monitoring
Date: Fri, 11 Jul 2025 16:53:07 -0700
Message-ID: <20250711235341.113933-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The prerequisite patch series to the Intel Telemetry code is
now in the Linux x86 platform drivers tree:
Link: https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/
queued for the v6.17 merge window.

That series is based on v6.16-rc1. One resctrl bugfix went into
Linus' tree after -rcl: commit 594902c986e2 ("x86,fs/resctrl: Remove
inappropriate references to cacheinfo in the resctrl subsystem")

These patches are based on the x86 platform drivers tree plus cherry
pick of that patch. For convenience I've pushed that base, and this
series to the rdt-aet-v7-base and rdt-aet-v7 branches of:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git

Changes since v6 was posted here:
Link: https://lore.kernel.org/all/20250626164941.106341-1-tony.luck@intel.com/


--- cover-letter ---
Rewritten - and then updated with comments from:
Link: https://lore.kernel.org/all/f3ba783a-6387-4997-9e8c-897109ee3559@intel.com/

--- 1 ---
Added review tag from Fenghua
Change kerneldoc for mon_evt::rid to "resource id for this event"


--- 2 ---
Added review tags from Fenghua & Reinette


--- 3 ---
Added review tag from Reinette


--- 4 ---
Added review tag from Reinette


--- 5 ---
Change kerneldoc for rdt_domain_hdr::rid to "resource id for this instance"
Fix domain_header_is_valid() check in rdtgroup_mondata_show() to use mon_data::rid


--- 6 ---
Fix Subject and commit comment to match the code changed.


--- 7 ---
Commit comment s/will still need to/needs to/
Fix for "d used before set" applied.


--- 8 ---
No comments.
Fix for "d used before set" applied.


--- 9 ---
Commit comment: s/it made sense to use/it made sense to use the L3 specific/
and s/to not/to note/.
Added details of why the change to pass the rdt_domain_hdr is needed and
what that entails.

rmdir_mondata_subdir_allrdtgrp() s/d->hdr.id/hdr->id/

mkdir_mondata_subdir() s/bool snc_mode = 0/bool snc_mode = false/

resctrl_online_mon_domain()  s/r->rid/RDT_RESOURCE_L3/

--- 10 ---
Commit comment: Add "of the L3 resource".
Fix alignment in kerneldoc for struct rdt_hw_l3_mon_domain.
Fix alignment for structure members in rdt_hw_l3_mon_domain.


--- 11 ---
Replace first two paragraphs of commit message.
s/mbm/MBM/


--- 12 ---
Update kerneldoc for mon_data::evt to match change to field.

--- 13 ---
Add comment before cpu_on_correct_domain() explaining when it is called
in preemptible vs. non-preemptible context.

Make just one call to cpu_on_correct_domain() at head of __mon_event_count()
to cover all subsequent code paths.

--- 14 ---
Fenghua: s/0.0. 0.25/0.0, 0.25/ in commit message.
Kerneldoc for mon_evt::is_floating_point s/may be displayed/are displayed/
Kerneldoc for mon_evt::binary_bits Add "only valid if @is_floating_point is true"
Use consistent "unsigned int" type for binary_bits.
print_event_value(): Use int_pow() instead of hard coding powers of 10.
With only one element left in struct fixed_params, drop it and just use
a simple array of "unsigned int" for number of decimal places.
Change "frac += 1 << (binary_bits - 1);" to "frac += 1ull << (binary_bits - 1);"
s/sprintf/snprintf/ to fill the buf[] with the fractional part of value.
If architecture did not supply a binary_bits value for an event that
filesystem designated as floating point, print as "val.0" for consistent
user interface.


--- 15 ---
No comments. Unchanged.

--- 16 ---
Replace commit comment with Reinette version.

--- 17 ---
Commit comment:
	s/published in the/published in/
	s/The XML files provide/The XML file provides/
Added paragraph tying "aggregators" to "regions":
  Each aggregator makes event counters available to Linux in
  a region of MMIO memory. Enumeration of these regions is
  done by the INTEL_PMT_DISCOVERY discovery driver.

Change name of configure_events() to discover_events()

Introduce a new Kconfig option X86_RESCTRL_CPU_INTEL_AET that is
only visible when INTEL_PMT_DISCOVERY=y so that x86 resctrl can
be configured without forcing inclusion of an Intel specific
driver.

--- 18 ---
Change MMIO size check to require equality with expected value.
s/Configure events/Discover events/ to match new function name
Update comment "Count how many per package" to say what is being
counted ("usable telemetry regions").
s/telemetry_regions/telemetry regions/ in comment.

Split known event group array into energy and perf lists.
Build a list of the enabled event groups.

--- 19 ---
Fix second paragraph to avoid redundancy. s/mmio/MMIO/
Clarify in ascii art that the first level structures refer
to package ID 0, package ID 1.

Rename struct mmio_info to struct pkg_mmio_info and
free_mmio_info() free_pkg_mmio_info() to match.

Change type of pkg_mmio_info::num_regions to unsigned int.

Update step 2 in header comment for discover_events().

Drop the test for duplicate telemetry information for a guid.
It can't happen because get_pmt_feature() stops scanning as
soon as discover_events() succeeds.

--- 20 ---
Change subject to say adding events for two specific GUIDs.

Added note that these two GUIDs are the ones used by Clearwater
Forest.

Changed the commit comment on MMIO counter layout to use
the "energy" guid=0x26696143 case as a specific example.

Changed type of pmt_event::idx and pmt_event::bin_bits to unsigned int
Ditto for event_group::num_events.

--- 21 ---
Add more detail for kerneldoc for resctrl_arch_rmid_read() arch_priv argument.

Provide the QOS_L3_OCCUP_EVENT_ID arch_priv value to resctrl_arch_rmid_read()
in the call from __check_limbo().

--- 22 ---
Drop confusing "core" from Subject.

--- 23 ---
Drop stale part of commit message about changing functions to
add/remove domains and bring them online or take them offline.
Those changes were incorporated into earlier patches in the
series.


--- 24 ---
Drop the "software_" part from rdt_is_software_feature_enabled().
Update comments to refer to hardware features instead of software
features. Expand "h/w" to "hardware. Drop use of "s/w".
Drop a stray "*" that appeared when reformatting block comment.


--- 25 ---
"as any time" -> "at any time"
drop "to ensure that all resctrl groups ..."
Fix rdt_num_rmids_show() to print r->num_rmid with "%u"

Dropped the rdt_is_software_feature_force_enabled() function.
Added a new rdt_set_feature_disabled().

Code flow now matches more closely that for the X86_FEATURE
enable/disable.
	1) Check at the start of discover_events() to see if there
	   are sufficient RMIDs. If there are not, then use
	   rdt_set_feature_disabled() to mark the feature disabled.
	2) Then call rdt_is_feature_enabled() which will override
	   the decision if the user specified rdt={feature} on the
	   kernel commend line.


--- 26 ---
Split into two:
Part 0027 cleans up the life cycle of closid_num_dirty_rmids and renames
some functions to add "_l3" components to their names.

Part 0028 Moves scan of resources and allocation of RMIDs to mount time
and renames dom_data_{init,exit{(). Dropped the "once" check from
rdt_get_tree()


--- 27 ---
No comments. Moved the "{name} monitoring detected" message to discover_events()


--- 28 ---
Fixed comment comment to match function name and path name with code.

Added a note that the {arch} component is "uname -m".

Added usage guidance in comment comment and block comment for
resctrl_debugfs_mon_info_arch_mkdir().

Added kerneldoc on life cycle (removed by resctrl_exit()) and
return value.

Clear debugfs_resctrl_info in resctrl_exit()

--- 29 ---
Fix Subject to refer to debugfs instead of info/ directory

s/arch/x86_64/ in pathname description

Use DEFINE_SIMPLE_ATTRIBUTE() to define file ops.

Exit create_debugfs_status_file early if debugfs directory cannot be created


--- 30 ---
Update details about core_energy and activity events to explain
they measure only "core" amounts.

Remove section about new status file uner info directory.

Add section about debugfs use.


Background
----------
On Intel systems that support per-RMID telemetry monitoring each logical
processor keeps a local count for various events. When the IA32_PQR_ASSOC.RMID
value for the logical processor changes (or when a two millisecond counter
expires) these event counts are transmitted to an event aggregator on
the same package as the processor together with the current RMID value. The
event counters are reset to zero to begin counting again.

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

For example there are two energy related telemetry events for the Clearwater
Forest family of processors and the MMIO space looks like this:

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

The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()
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
  x86,fs/resctrl: Add and initialize rdt_resource for package scope core
    monitor
  x86/resctrl: Discover hardware telemetry events
  x86/resctrl: Count valid telemetry aggregators per package
  x86/resctrl: Complete telemetry event enumeration
  x86,fs/resctrl: Fill in details of events for guid 0x26696143 and
    0x26557651
  x86,fs/resctrl: Add architectural event pointer
  x86/resctrl: Read telemetry events
  x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
  x86/resctrl: Add energy/perf choices to rdt boot option
  x86/resctrl: Handle number of RMIDs supported by telemetry resources
  fs/resctrl: Fix life-cycle of closid_num_dirty_rmid
  x86,fs/resctrl: Move RMID initialization to first mount
  x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
  fs/resctrl: Provide interface to create architecture specific debugfs
    area
  x86/resctrl: Add debugfs files to show telemetry aggregator status
  x86,fs/resctrl: Update Documentation for package events

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         |  85 +++-
 include/linux/resctrl.h                       |  89 +++-
 include/linux/resctrl_types.h                 |  26 +-
 arch/x86/include/asm/resctrl.h                |  16 -
 arch/x86/kernel/cpu/resctrl/internal.h        |  45 +-
 fs/resctrl/internal.h                         |  66 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 331 ++++++++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 426 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  78 ++--
 fs/resctrl/ctrlmondata.c                      | 127 +++++-
 fs/resctrl/monitor.c                          | 306 ++++++++-----
 fs/resctrl/rdtgroup.c                         | 266 +++++++----
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 15 files changed, 1439 insertions(+), 438 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
base-branch: rdt-aet-v7-base
base-commit: 882f32fbcc7ba5b46cf8889607fa677de1e222e0
-- 
2.50.0

