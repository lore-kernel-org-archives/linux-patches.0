Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14ED2D543D
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010485; cv=none; b=m1SxgYvP05YeGorR9gzaB5KDPPkpBT03a0rywkeHcrbDKUXm4acHSxLfLAEpGabEEDrsn7gDoVV8Va9rsgUlBQcCWEDnRs9ohQwa+fdyZV5Qba785L0CqmKpyzfhkEpvLz/JrKey+vMcnZaGMT8K728HeqTY6sPM7egZRaDG3HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010485; c=relaxed/simple;
	bh=GBa9VzyRdPN9zfb9LyTjE9LCadSyxfXjsDkJ26c4VUI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A6IWv4s2eMzzsoJ50zuYG/bpONLOKLWO13++OeWg7KP+4zRTZqzQLMkG4dPUoZ7eyFJE8fZI4pMYseuTJWG9sXIBwHP7vDWcvVWrSPFCb93HwRmXrDU3GIh5JBfWCNTRE9/czYRaZXspIL/IlW+k59gMzLqGB//MOJyNshBkyrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F0/FkujE; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F0/FkujE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010484; x=1795546484;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GBa9VzyRdPN9zfb9LyTjE9LCadSyxfXjsDkJ26c4VUI=;
  b=F0/FkujEsB8QZl8iOSXKFOOyErEK01LAUJJuwlpnjzgzv3VOX+dL/xR5
   Jr2UK3lHjfWqV1Ytwfu19PERmSrAAImgMmh8qTDU1vyLfXfecWB3uuF5w
   Vyw5jocA2vwEkClLHeMxRaFEe08hkyaFzlPXdHhuqJqgokdydAdVddm/v
   jpimS0oddl4ZAdc6Sih/m8JE5AzNKk3M9xGeNnJHYsOqJvYCauDCQB5VF
   DQVDwAvCPAWm7HP1h8rg87R0DaL5n7uCnyesAPE6ampt39JWlTMW2M+iZ
   HOgWwp9gZSPx1bMyv9mE9neYUeYwsAGAt7/FdgrN0SB45R+e7LHwF+WvH
   A==;
X-CSE-ConnectionGUID: 2Aw3Rc/bRS6mQAy5FJnsSw==
X-CSE-MsgGUID: DibYPoRCQGma4qt+6QrPVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636430"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636430"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:21 -0800
X-CSE-ConnectionGUID: pR0VuWdJRRO9xMexXKylbQ==
X-CSE-MsgGUID: wUafHoBFQemURn9P4/rtfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224936"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:21 -0800
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
Subject: [PATCH v14 00/32] x86,fs/resctrl telemetry monitoring
Date: Mon, 24 Nov 2025 10:53:37 -0800
Message-ID: <20251124185412.24155-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patches based on tip/master. Snapshot Nov 23rd, 9am PST. Head at that
point was commit aecda73c2b25 ("Merge branch into tip/master: 'x86/sgx'").

Series available here:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v14

Changes since v13 was posted here:
Link: https://lore.kernel.org/all/20251029162118.40604-1-tony.luck@intel.com/

--- 00/35] x86,fs/resctrl telemetry monitoring
No changes to "Background" section of cover letter.

--- 01/35] x86,fs/resctrl: Improve domain type checking
No change

--- 02/35] x86/resctrl: Move L3 initialization into new helper
Reformat commit message for longer lines

--- 03/35] x86/resctrl: Refactor domain_remove_cpu_mon() ready for
No change

--- 04/35] x86/resctrl: Clean up domain_remove_cpu_ctrl()
No change

--- 05/35] x86,fs/resctrl: Refactor domain create/remove using
s/d->hdr.id/hdr->id/ where hdr is now available

--- 06/35] fs/resctrl: Split L3 dependent parts out of
Reformat commit message for longer lines

--- 07/35] x86,fs/resctrl: Use struct rdt_domain_hdr when reading
Split "sum" parts of __l3_mon_event_count() into separate function
and do the check for rr->hdr in __mon_event_count()

--- 08/35] x86,fs/resctrl: Rename struct rdt_mon_domain and
"are not tied" -> "is not tied"
"a new domain structures" -> "new domain structures"
Reformat commit message for longer lines
Fix kerneldoc for struct rdt_mon_domain and struct rdt_hw_mon_domain
to show they are only used for an L3 resource.

--- 09/35] x86,fs/resctrl: Rename some L3 specific functions
Reformat commit message for longer lines
Add Reinette RB tag

--- 10/35] fs/resctrl: Make event details accessible to functions
No change

--- 11/35] x86,fs/resctrl: Handle events that can be read from any
Reformat commit message for longer lines

--- 12/35] x86,fs/resctrl: Support binary fixed point event
Dave Martin:
	Declare decplaces[] as "const"
	Use ceil(binary_bits * log10(2)) for all binary places except 0
	Fix GENMASK_ULL argument to be binary_bits - 1
	Don't strip traling zeroes
	Drop buf[] (was only needed to strip trailing zeroes)
Reformat commit message for longer lines

--- 13/35] x86,fs/resctrl: Add an architectural hook called for
Reformat commit message for longer lines

--- 14/35] x86,fs/resctrl: Add and initialize rdt_resource for
Bump bit number for RFTYPE_RES_PERF_PKG from 11 to 12
Reformat commit message for longer lines

--- 15/35] fs/resctrl: Cleanup as L3 is no longer the only monitor
Change Subject to Emphasize that L3 monitoring resource is required for summing domains
Reformat commit message for longer lines
Add Reinette RB tag

--- 16/35] x86/resctrl: Discover hardware telemetry events
Massive surgery to commit comment. Dropped the example.
Defer definitions of energy_0x26696143 and perf_0x26557651 to patch 17
Replace kerneldoc description for struct event_group, better description
for @feature member, refer to @feature in @pfg description. @guid field
dropped here and moved to patch 17.
"Try to use every telemetry aggregator with a known guid." ->
  Save the pmt_feature_group for enabled events.

--- 17/35] x86,fs/resctrl: Fill in details of events for guid
Replace opening paragraph and provide working URL to the xml
files for each of the Clearwater Forest files.
"The counter offsets in MMIO space" ->
  "The event counter offsets in an aggregator's MMIO space"
"these events" -> "the events tracked by the aggregators"

--- 18/35] x86,fs/resctrl: Add architectural event pointer
Reformat commit message for longer lines

--- 19/35] x86/resctrl: Find and enable usable telemetry events
Replace all but last paragraph of commit message
Reformat commit message for longer lines
Change resctrl_enable_mon_event() return bool for success/fail
and count how many events from a feature cannot be enabled

--- 20/35] x86/resctrl: Read telemetry events
Drop unused eventid from intel_aet_read_event()
Reformat commit message for longer lines

--- 21/35] fs/resctrl: Refactor mkdir_mondata_subdir()
Add Reinette RB tag

--- 22/35] fs/resctrl: Refactor rmdir_mondata_subdir_allrdtgrp()
Add Reinette RB tag

--- 23/35] x86,fs/resctrl: Handle domain creation/deletion for
Reformat commit message for longer lines

--- 24/35] x86/resctrl: Add energy/perf choices to rdt boot option
Resolve conflicts on top of Babu sdciae patches
Rewritten to allow per-guid granularity when enabling/disabling
features. event_group::name addition brought forward to this patch
(was in patch 25)
Dropped Reinette RB tag because of this r-write.

--- 25/35] x86/resctrl: Handle number of RMIDs supported by
rdt_resource::num_rmid -> resctrl_mon::num_rmid
Dropped double spaces.
Reformat commit message for longer lines
Rename event_group::num_rmids as num_rmid (to match resctrlresctrl_mon::num_rmid)
Added console warning for features disabled due to insufficient RMIDs

--- 26/35] fs/resctrl: Move allocation/free of
Reformat commit message for longer lines
Add Reinette RB tag

--- 27/35] x86,fs/resctrl: Compute number of RMIDs as minimum
Reformat commit message for longer lines

--- 28/35] fs/resctrl: Move RMID initialization to first mount
Reformat commit message for longer lines

--- 29/35] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
Print guid as well as name in "enabled" message. Add note
if not all events were enabled.

--- 30/35] fs/resctrl: Provide interface to create architecture
Reformat commit message for longer lines

--- 31/35] x86/resctrl: Add debugfs files to show telemetry
Add the guid to the debugfs filenames.
Reformat commit message for longer lines

--- 32/35] x86,fs/resctrl: Update documentation for telemetry
"an" -> "a"
Compare trackable RMIDs with supported RMIDs instead of referring to
number of L3 monitor events.
"MON" -> "monitoring"
Dropped unnecessary line break.
Update names of debugfs files to include guid in the prefix of the file name

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
  fs/resctrl: Emphasize that L3 monitoring resource is required for
    summing domains
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

 .../admin-guide/kernel-parameters.txt         |   6 +-
 Documentation/filesystems/resctrl.rst         | 102 +++-
 include/linux/resctrl.h                       |  67 ++-
 include/linux/resctrl_types.h                 |  11 +
 arch/x86/kernel/cpu/resctrl/internal.h        |  52 +-
 fs/resctrl/internal.h                         |  68 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 230 ++++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 462 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  50 +-
 fs/resctrl/ctrlmondata.c                      | 113 ++++-
 fs/resctrl/monitor.c                          | 353 ++++++++-----
 fs/resctrl/rdtgroup.c                         | 293 +++++++----
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 14 files changed, 1422 insertions(+), 399 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: aecda73c2b25c14feb62e7eed13c4f722d35c1d6
-- 
2.51.1

