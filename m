Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3F52512DE
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830646; cv=none; b=JQa4uHMV0+HemN+boJqsDEWx8kKxVkTvNXKahgOlEIMUC0qY9RQxXLwZjjvJRMhszx8Sf7NT6/cqW3QPb8vie86etezvwMAcWplhd8J5enAHp6M4X8A+WHI2EKUueaSjXyVuRUVoi2bTX97WY0KzaOcC6BZ7noQy8fehKIIV9JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830646; c=relaxed/simple;
	bh=vb3ABJ6ePLADnuyUM820IFDXZcfejNac6dxDqkJMGdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gzuHxkORZUWZf80v4Fkk6QldZMir9qA+U2yvEPOpfXv86kBMsDxCNUdW39Zh0/QUdKuqeEIlt28d+mCRAM5ymU+7ZDhXXAEYc/1SrTb8lPCONeg6oBXTtOlQNtdjEcHRRU6IwCc2rhAe6jwIq4aPCCif4h8lt0D+cpn4AlTjwKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OiNxq/ee; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OiNxq/ee"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830645; x=1790366645;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vb3ABJ6ePLADnuyUM820IFDXZcfejNac6dxDqkJMGdA=;
  b=OiNxq/ee3+Wdq8eBKvANweY5bWneVj/dxtRCxwo8+x1TmhhTQchoXxBy
   koMMO1ERDFVFBt41LskBcm79HBYnvjOe7a1nGKcEHaBJKWKYJ+Izv9ZhL
   xVHJ+fgqv2TTKfvIoR/JMQ16JkISHyqw/1Zt029u+8pUeU6qn10FOuLgm
   6HtgpXOK5iZsw0Fve7i99pfoU0k/9IqLEEE+Zm+Uz02TlkyXUMSzK0l8n
   lC/Sn8xSahCdrm10zxepdVNR97cXyoSHiNxGI6sYnVyIAGxX2mQJYOwMs
   HZGAj3a/1FEaU9pGkCi048EGYBu7zK3f8+14YPqVeag9aNdJs1eLCpy0z
   w==;
X-CSE-ConnectionGUID: EpQsucnbTJ6c0VtIZVnhgA==
X-CSE-MsgGUID: DSuDJvyTQCSg75fGSnfdhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074132"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074132"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:04 -0700
X-CSE-ConnectionGUID: 7Y4mUa+gQOit0JrSfdvjFA==
X-CSE-MsgGUID: +ydraTreRveh/TFb7Hyx9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003592"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:03 -0700
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
Subject: [PATCH v11 00/31] x86,fs/resctrl telemetry monitoring
Date: Thu, 25 Sep 2025 13:02:54 -0700
Message-ID: <20250925200328.64155-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patches based on tip tree x86/cache branch

Top commit of x86/cache at time of my snapshot was:
dd86b69d20fb ("fs/resctrl: Fix counter auto-assignment on mkdir with mbm_event enabled")

The combination of above components plus this series is here:
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v11

Top commit:
74134daf5662 ("fs/resctrl: Some kerneldoc updates")

Changes since v10 was posted here:
Link: https://lore.kernel.org/all/20250912221053.11349-1-tony.luck@intel.com/


Global: Rewrote several commit messages based on suggestions and guidance
from Boris[1]. Dropped RB tags where commit message rewritten.

Link: https://lore.kernel.org/all/20250923100956.GAaNJx9BYhXKkfNJ71@fat_crate.local/ # [1]

V10 patch references in form "xx/28 {subject}. V11 numbering changes
after patch 18. V11 patch numbers as 4 digits (e.g. 0019).

=== 00/28 x86,fs/resctrl:	telemetry monitoring ===
Background section in cover letter unchanged.

=== 01/28 x86,fs/resctrl:	Improve domain type checking ===
New commit message, no code changes.

=== 02/28 x86/resctrl:	Move L3 initialization into new helper function ===
New commit message (suggested by Boris).

Put the call to resctrl_arch_mbm_cntr_assign_set_one() that was lost in a merge
error back ... do it inside "case RDT_RESOURCE_L3:" as it needs to be done on
every CPU that comes online.

=== 03/28 x86,fs/resctrl:	Refactor domain_remove_cpu_mon() ready for new domain types ===
Commit message had stale descriptions of code changes that have been moved
to later patches in the series. Drop spurious pieces.

=== 04/28 x86/resctrl:	Clean up domain_remove_cpu_ctrl() ===
RB tag from Reinette applied from earlier review. No changes.

=== 05/28 x86,fs/resctrl:	Use struct rdt_domain_hdr instead of struct rdt_mon_domain ===
Strip out all changes unrelated to rdt_domain_hdr.
Rewrite commit message based on Boris suggestion.
Fix "Subject" to match change since change split into two patches.
Fix unbalanced domain_header_is_valid() / container_of() call.

=== 06/28 x86,fs/resctrl:	Use struct rdt_domain_hdr when reading counters ===
Strip out all changes unrelated to rdt_domain_hdr.
Rewrite commit message using Boris suggested text.

=== 07/28 x86,fs/resctrl:	Rename struct rdt_mon_domain and rdt_hw_mon_domain ===
Simplify the commit message.

=== 08/28 x86,fs/resctrl:	Rename some L3 specific functions ===
No change

=== 09/28 fs/resctrl:	Make event details accessible to functions when reading events ===
Simplify commit comment.

=== 10/28 x86,fs/resctrl:	Handle events that can be read from any CPU ===
v10 had moved part of this patch earlier, but that jumbled extra
changes into the rdt_domain_hdr refactoring. Brought those parts
back into this patch.
Simplify commit comment.

=== 11/28 x86,fs/resctrl:	Support binary fixed point event counters ===
Applied conditionsal RB tag from Reinette (after fixing "nit: "0.5." ->
"0.5") in v10 from v9 review. No other changes.

=== 12/28 x86,fs/resctrl:	Add an architectural hook called for each mount ===
RB tag from Reinette applied from earlier review. No changes.

=== 13/28 x86,fs/resctrl:	Add and initialize rdt_resource for package scope monitor ===
RB tag from Reinette applied from earlier review. No changes.

=== 14/28 x86/resctrl:	Discover hardware telemetry events ===
No change

=== 15/28 x86,fs/resctrl:	Fill in details of events for guid 0x26696143 and 0x26557651 ===
No change

=== 16/28 x86,fs/resctrl:	Add architectural event pointer ===
No change

=== 17/28 x86/resctrl:	Find and enable usable telemetry events ===
No change

=== 18/28 x86/resctrl:	Read telemetry events ===
0018	Add new patch "fs/resctrl: Refactor L3 specific parts of __mon_event_count() with
	changes deferred from rdt_domain_hdr patch.
0019	No changes from v10 patch 18

=== 19/28 x86/resctrl:	Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG ===
0020	Add new patch "fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in mkdir/rmdir code flow"
	with changes deferred from rdt_domain_hdr patch.
0021	Simplfy commit message. No code change from v10 patch 19

=== 20/28 x86/resctrl:	Add energy/perf choices to rdt boot option ===
0022	No change from v10 patch 20

=== 21/28 x86/resctrl:	Handle number of RMIDs supported by telemetry resources ===
0023	No change from v10 patch 21

=== 22/28 fs/resctrl:	Move allocation/free of closid_num_dirty_rmid[] ===
0024	No change from v10 patch 22

=== 23/28 fs,x86/resctrl:	Compute number of RMIDs as minimum across resources ===
0025	No change from v10 patch 23

=== 24/28 fs/resctrl:	Move RMID initialization to first mount ===
0026	No change from v10 patch 24

=== 25/28 x86/resctrl:	Enable RDT_RESOURCE_PERF_PKG ===
0027	No change from v10 patch 25

=== 26/28 fs/resctrl:	Provide interface to create architecture specific debugfs area ===
0028	No change from v10 patch 26

=== 27/28 x86/resctrl:	Add debugfs files to show telemetry aggregator status ===
0029	No change from v10 patch 27

=== 28/28 x86,fs/resctrl:	Update Documentation for package events ===
0030	No change from v10 patch 28 

0031	Add new patch "fs/resctrl: Update kerneldoc for rmid_read::sum and mon_get_kn_priv()
	(suggested by Reinette in v7, but bundled in with other changes).
	Plus fix "Return:" for functions touched in this series.

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
  x86,fs/resctrl: Improve domain type checking
  x86/resctrl: Move L3 initialization into new helper function
  x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain
    types
  x86/resctrl: Clean up domain_remove_cpu_ctrl()
  x86,fs/resctrl: Refactor domain create/remove using struct
    rdt_domain_hdr
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
  fs/resctrl: Refactor L3 specific parts of __mon_event_count()
  x86/resctrl: Read telemetry events
  fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in mkdir/rmdir code flow
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
  fs/resctrl: Some kerneldoc updates

 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/filesystems/resctrl.rst         | 100 ++++-
 include/linux/resctrl.h                       |  69 ++-
 include/linux/resctrl_types.h                 |  11 +
 arch/x86/kernel/cpu/resctrl/internal.h        |  50 ++-
 fs/resctrl/internal.h                         |  68 ++-
 arch/x86/kernel/cpu/resctrl/core.c            | 270 ++++++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c       | 417 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c         |  52 ++-
 fs/resctrl/ctrlmondata.c                      | 123 +++++-
 fs/resctrl/monitor.c                          | 343 ++++++++------
 fs/resctrl/rdtgroup.c                         | 200 ++++++---
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/resctrl/Makefile          |   1 +
 14 files changed, 1352 insertions(+), 367 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c


base-commit: dd86b69d20fb9fa7e941ed01ff05f1e662fcc3ff
-- 
2.51.0

