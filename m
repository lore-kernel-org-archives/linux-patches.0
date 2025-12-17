Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466712E0407
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992104; cv=none; b=jt2120vZV4y8pmcj/IdyyVw+Mhux5ELljHQfAxqlm2OEPlbyGmU142+P8GSLM586vQJ4GVq8UdUYkSiYdaVUg/G0+fBHdYQtLfYEek/of3ssrSHP3u93Dth57I1gAbavw7qxxwvJZCecyZrvz5dvSVhYWYLP9W8qfT9cTTmZX0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992104; c=relaxed/simple;
	bh=vNxMPgiTI8YNCp3be4D1fR48JGHY9T9wYRjzb6U08GY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SjLEXo4SiVDTZkdOH2VSFV0I9ESVOfnQUyAKqYW1rupbo4uYFyHfaQGbYQHRUnRQrRGUhkZnjcnctBVUulrnJkhlY8fon1hnowhzYDOrsodqendGV2hIErJ9UIFGa/z8O+/Q/I7v8kWLWQqYx4dP2C5QI10d49FaPDFDAbGViLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ISinnwzo; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ISinnwzo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992098; x=1797528098;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vNxMPgiTI8YNCp3be4D1fR48JGHY9T9wYRjzb6U08GY=;
  b=ISinnwzozz3tOdhawK3zeho/Y2LrdgjdNU26xwzHLaAHwAG6dKpPpqRE
   viLyEU5K109oFOhgchHN16qGamPX7P8F6zIJ0yIpDF3loLN8lg0cJgjCE
   UXLalf28uwilyYpYYpbQzj70XtQcCAy/L5djQWTMqa0itoGwzOXFFsjo9
   2MXk8kDLRhGiPVHxZSjFXUuACpxX97RFVJuZbFyQOH7Ld6jcM42gGhkEY
   Eg4WBxHZXa8EZ7sWLokX1rvZEi2n49mmxl+IUIYnnOnpj3OKytY2azOJT
   IUGCTGCcT5Z24cy1C07QTDn+8zzdZ2mKh60jTC09lVuh7YA6k+dllYNum
   w==;
X-CSE-ConnectionGUID: QZI0pOqXSe6250/EHjsP6Q==
X-CSE-MsgGUID: LUApqItmSge6ktrVJZvGGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594611"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594611"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:32 -0800
X-CSE-ConnectionGUID: FHYFNM8hRKavAEyKwQ2pPg==
X-CSE-MsgGUID: ieWjnI0wRg2MWmd5c/X6HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748142"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:31 -0800
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
Subject: [PATCH v17 00/32] x86,fs/resctrl telemetry monitoring
Date: Wed, 17 Dec 2025 09:20:47 -0800
Message-ID: <20251217172121.12030-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patches based on Linus v6.19-rc1

Series available here:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v17

Changes since v16 was posted here:
https://lore.kernel.org/all/20251210231413.59102-1-tony.luck@intel.com/

Cover letter
Added some examples for Babu

part 11
Added Reinette RB tag

part 19
Update commit message to explain why it is safe to enable just some events
within an event group.
Added Reinette RB tag

part 24
Added Reinette RB tag

part 25
Drop unneeded local variable "ret" from all_regions_have_sufficient_rmid()
Added Reinette RB tag

part 32
Added Reinette RB tag

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

Examples:
--------

As with other resctrl monitoring features first create CTRL_MON or MON
directories and assign the tasks of interest to the group.

# mkdir /sys/fs/resctrl/aet_example
# echo {list of PIDs} > /sys/fs/resctrl/aet_example/tasks

For simplicity in this example, assume that these tasks have their
affinity set to CPUs in the first socket. Set a shell variable to
point to the mon_data directory for socket 0:

$ dir=/sys/fs/resctrl/aet_example/mon_data/mon_PERF_PKG_00

Energy events:
-------------

There are two events associated with energy consumption in the core.
The "core_energy" event reports out directly in Joules. To compute
power just take the difference between two samples and divide by the
time between them. E.g.

$ cat $dir/core_energy; sleep 10; cat $dir/core_energy
94499439.510380
94499607.019680
$ bc -q
scale=3
(94499607.019680 - 94499439.510380) / 10
16.750

So 16.75 Watts in this example.

Note that different runs of the same workload may report different
energy consumption. This happens when cores shift to different
voltage/frequency profiles due to overall system load.

The "activity" event reports energy usage in a manner independent
of voltage and frequency. This may be useful for developers to
assess how modifications to a program (e.g. attaching to a library
optimized to use AVX instructions) affect energy consumption. So
read the "activity" at the start and end of program execution and
compute the difference.

Perf events:
-----------

The other telemetry events largely duplicate events available using
"perf", but avoid reading the perf counters on every context switch.
This may be a significant improvement when monitoring highly multi-threaded
applications. E.g. to find the ratio of core cycles to reference cycles:

$ cat $dir/unhalted_core_cycles $dir/unhalted_ref_cycles
1312249223146571
1660157011698276
$ { run application here }
$ cat $dir/unhalted_core_cycles $dir/unhalted_ref_cycles
1313573565617233
1661511224019444
$ bc -q
scale = 3
(1661511224019444 - 1660157011698276) / (1313573565617233 - 1312249223146571)
1.022

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
  x86,fs/resctrl: Add and initialize a resource for package scope
    monitoring
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

 .../admin-guide/kernel-parameters.txt         |   7 +-
 Documentation/filesystems/resctrl.rst         | 101 +++-
 include/linux/resctrl.h                       |  67 ++-
 include/linux/resctrl_types.h                 |  11 +
 arch/x86/kernel/cpu/resctrl/internal.h        |  48 +-
 fs/resctrl/internal.h                         |  68 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 230 ++++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 473 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  50 +-
 fs/resctrl/ctrlmondata.c                      | 113 ++++-
 fs/resctrl/monitor.c                          | 364 +++++++++-----
 fs/resctrl/rdtgroup.c                         | 293 +++++++----
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 14 files changed, 1440 insertions(+), 399 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0

