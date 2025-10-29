Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF5A2EE5F4
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754887; cv=none; b=CReIHiTq5EV81pPUrGqzBx8qmwvaSpzEEV/FkB5DGC3y7GvmfVryly2uXPzBsy6NyaC/HNlkOPduFqLuI823C69BBSfDokMKBi/mwL/oPmc9tODSaDrkeMJlFA0Onvk3J4jW4bsIFFExjqGTxqOINdFgmeHN5PhhQl0Aaux59+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754887; c=relaxed/simple;
	bh=TZA+ASqFafPwsHbuwvDsSj+m3P33C7zclkGD+PlldT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pO9D45pXKNa4JjtCSsSlFo/U3IhmxCGWI/Q6FsCIGvD9SKX866NnIgGE+4XEBKj3ud512d4SPZCgVOYWyBoQ2SRITIRYxQvwPKUDmatltAcwoO+nXIk4K0IqU8YSg/i14eprQpXWZELuNImazfTrRFKvW33HZ/E/AQWWWPwjkgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hh/F7ehB; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hh/F7ehB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754885; x=1793290885;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TZA+ASqFafPwsHbuwvDsSj+m3P33C7zclkGD+PlldT4=;
  b=Hh/F7ehBj97RDV0vptcCs5+u5IueAWf/nHXeRc4SpSY/TwS7/hniq0JR
   h/pWFsJMVIqQw3qyZ24wpSS2rVjBa5ZXXOOMpxq25qCLr/r/0o0zs9rtJ
   Dli+BGrkL9XnoawMT6kb6KoLCw8SebuB3QkVaSfOQu6XDxh60RIY/pnsm
   uD04j9PUx6cEAEmeYwFrePwTng7DfInRZ02lQUSyAo6Or8U7n1+EXgw8D
   THExRyCJJ154wvLQVPuB08fxIb0GwYrD/9UH9Pq0Np2nd0EReqds/szY8
   XtktxlCioxeNeuLUfheGIVkhDfM3gArwXPWlDTBCftzN8sEwRbcaNqd1G
   A==;
X-CSE-ConnectionGUID: xYA7mO/BTCys677b0p9pYg==
X-CSE-MsgGUID: dVOSYhcDQIOs4DHx2j/BRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481305"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481305"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:25 -0700
X-CSE-ConnectionGUID: 3lWbF+sDQ6eBTmCXiE4uAA==
X-CSE-MsgGUID: faeO4BcBTcqsCp6oNThHYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901279"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:24 -0700
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
Subject: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Date: Wed, 29 Oct 2025 09:20:43 -0700
Message-ID: <20251029162118.40604-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patches based on v6.18-rc3

Series available here:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v13

Changes since v12 was posted here:
Link: https://lore.kernel.org/all/20251013223348.103390-1-tony.luck@intel.com/

My usual convention, patches from v11 named "XX/28", patches in this
series when they have a different number as "00YY".

--- v12 00/31 x86,fs/resctrl telemetry monitoring ---
No changes to "Background" section of cover letter.

--- v12 01/31 x86,fs/resctrl: Improve domain type checking ---
Added Reinette RB tag

--- v12 02/31 x86/resctrl: Move L3 initialization into new helper ---
No change

--- v12 03/31 x86/resctrl: Refactor domain_remove_cpu_mon() ready ---
Added Reinette RB tag

--- v12 04/31 x86/resctrl: Clean up domain_remove_cpu_ctrl() ---
No change

--- v12 05/31 x86,fs/resctrl: Refactor domain create/remove using ---
Move (keep) lockdep_assert_cpus_held() at start of mon_event_read()
Defer SNC change (summing cache-sharing domains) in rdtgroup_mondata_show()
to later patch.

--- v12 06/31 x86,fs/resctrl: Use struct rdt_domain_hdr when ---
New 0006 (pulled in __mon_event_count() refactor from old 18/31)
Set rr->err when returning an error from __mon_event_count() for bad r->rid.

0007 (was 06/31)
Rewrite commit message including "telemetry events" -> "monitoring events"
Drop change to resctrl_arch_cntr_read()
Set rr->err when returning an error from __mon_event_count() for invalid
domain header.

--- v12 07/31 x86,fs/resctrl: Rename struct rdt_mon_domain and ---
0008	Drop RB tag because of fir order issues introduced in v11
	Fix fir order issues.

--- v12 08/31 x86,fs/resctrl: Rename some L3 specific functions ---
0009	Update kerneldoc "Return" fixes to match existing style.
	Use imperative in commit message note about kerneldoc changes.


--- v12 09/31 fs/resctrl: Make event details accessible to ---
0010	No change

--- v12 10/31 x86,fs/resctrl: Handle events that can be read from ---
0011	Dropped cpu_on_correct_domain(). The refactor of __mon_event_count()
	in patch 0006 means it is no longer needed. The cpu checks in
	__l3_mon_event_count() continue to work without change.

--- v12 11/31 x86,fs/resctrl: Support binary fixed point event ---
0012	No change

--- v12 12/31 x86,fs/resctrl: Add an architectural hook called ---
0013	No change

--- v12 13/31 x86,fs/resctrl: Add and initialize rdt_resource for ---
Split
0014	Parts of 13/31 related to new resource. Dropped Reinette RB tag.
0015	SNC L3 checks and kerneldoc changes.

--- v12 14/31 x86/resctrl: Discover hardware telemetry events ---
0016	Major rewrite on the commit messge.
	Simplified the code to keep just one array of known event groups.
	Don't "return false" for failed intel_pmt_get_regions_by_feature()
	just continue to check other event_groups.

--- v12 15/31 x86,fs/resctrl: Fill in details of events for guid ---
0017	Clarify pmt_feature_group and event_group in commit message.

--- v12 16/31 x86,fs/resctrl: Add architectural event pointer ---
0018 Rebased and added Reinette RB tag.

--- v12 17/31 x86/resctrl: Find and enable usable telemetry ---
0019	Re-write commit to match current design.
	Move open coded check for usable regions to
	group_has_usable_regions() helper.

--- v12 18/31 fs/resctrl: Split L3 dependent parts out of ---
Pulled forward in series. Is now patch 0006.

--- v12 19/31 x86/resctrl: Read telemetry events ---
0020	Declare "tval" inside "case RDT_RESOURCE_PERF_PKG".
	Make intel_aet_read_event() sum to a local variable and
	assign to *val on success.
	Delete irrelevant paragraphs from commit comment.
	Update to say that when none of the aggregators have valid data
	the use will see "Unavailable".

--- v12 20/31 fs/resctrl: Refactor mkdir_mondata_subdir() ---
0021	Drop do_sum argument from mon_add_all_files(). Can infer from
	whether hdr argument is NULL.
	Rename mon_add_all_files() to _mkdir_mondata_subdir() and have
	it make the directory and fix user/group id to avoid code
	duplication at each call site.
	Pass explicit NULL for hdr argument to _mkdir_mondata_subdir()
	when creating files in top-level mon_L3_XX directory.
	Add check for r->rid == RDT_RESOURCE_L3 to mkdir_mondata_subdir()
	Fix commit comment to avoid code reference and just describe the
	problem.

--- v12 21/31 fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp() ---
0022:	Move and reword comment about SNC sum directories to the new
	refactored function.
	Add check for r->rid == RDT_RESOURCE_L3 to rmdir_mondata_subdir_allrdtgrp()
	Fix commit comment as suggested.

--- v12 22/31 x86,fs/resctrl: Handle domain creation/deletion for ---
0023:	Added Reinette RB tag

--- v12 23/31 x86/resctrl: Add energy/perf choices to rdt boot ---
0024:	Added Reinette RB tag

--- v12 24/31 x86/resctrl: Handle number of RMIDs supported by ---
0025:	Replace "Limit an event group's number ..." paragraph in commit
	message with suggested alternative.
	Drop description of code ("Print r->num_rmid ...")
	New all_regions_have_sufficient_rmid() that builds on
	assumption that groups with no regions were weeded out in
	changes to patch 17/31 (now 0019).

--- v12 25/31 fs/resctrl: Move allocation/free of ---
0026:	Drop rdtgroup_mutex before error return in closid_num_dirty_rmid_alloc()

--- v12 26/31 x86,fs/resctrl: Compute number of RMIDs as minimum ---
0027:	No change

--- v12 27/31 fs/resctrl: Move RMID initialization to first mount ---
0028:	"may likely need" -> "needs"
	Added Reinette RB tag.

--- v12 28/31 x86/resctrl: Enable RDT_RESOURCE_PERF_PKG ---
0029:	Add to commit message that a console log is added.

--- v12 29/31 fs/resctrl: Provide interface to create ---
0030:	Added Reinette RB tag.

--- v12 30/31 x86/resctrl: Add debugfs files to show telemetry ---
0031:	Dropped spurious blank line from intel_aet_add_debugfs()
	Update to use new for_each_event_group() macro.
	Added Reinette RB tag.

--- v12 31/31 x86,fs/resctrl: Update documentation for telemetry ---
0032:	"if the number of RMIDs supported is lower than the number of RMIDs
	supported by the system" -> "if the number of RMIDs supported for that
	type is lower than the number of RMIDs supported by hardware for L3
	monitoring events"
	"this will reduce" -> "this may reduce"
	"the current RMID" -> "for the current monitoring group"

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
  x86,fs/resctrl: Add and initialize rdt_resource for package scope
    monitor
  fs/resctrl: Cleanup as L3 is no longer the only monitor resource
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

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         | 102 ++++-
 include/linux/resctrl.h                       |  67 ++-
 include/linux/resctrl_types.h                 |  11 +
 arch/x86/kernel/cpu/resctrl/internal.h        |  52 ++-
 fs/resctrl/internal.h                         |  68 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 275 ++++++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 417 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  50 ++-
 fs/resctrl/ctrlmondata.c                      | 123 +++++-
 fs/resctrl/monitor.c                          | 321 +++++++++-----
 fs/resctrl/rdtgroup.c                         | 293 ++++++++----
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 14 files changed, 1409 insertions(+), 386 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.51.0

