Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C745E50254F
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633723; cv=none; b=Sx7f91FSQAT0bfThynNbEsUlEAoUvy/TeMTG0mxJF6dgvU3xpVnp2YMuoS3cYKZs0dJahtFOxjkXwVmDj7deMmTxIkkD06am69oJKcesaBPXKpKlZS6JHr2N4ClFWnCnyvGEyEi1i/uLi8HdOgOItuKNW9wR6mBnPpNTga89POY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633723; c=relaxed/simple;
	bh=rTa2SvyhH5DLILFCOmipUCryw4fvrewmKM4sbuE1Hes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VH3RZscA+f+rNNoRVD6pJ/A1xmzf75+dOWWr0SROLglAnb2sju18S+Lqpac2UK/wmnx0xy1e5W4wtsiUcRKIzhFtyzvKr5kTppJs/LA4XPdAAW9AgOe4ZrzHpejtnIbAOkjB/zuCHN0CrZvsgthQSQgL0GoPfe6WzcFODxaf5OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQ0md9Z9; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQ0md9Z9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633719; x=1822169719;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rTa2SvyhH5DLILFCOmipUCryw4fvrewmKM4sbuE1Hes=;
  b=NQ0md9Z9VAFH2IQ5mKhp1Ys/2I+YOZgsNYD84io/FMBYjCtdl3u4rSot
   GE2fswWDNI11ZzoJ3UlANf3r4NPp4K+snOl1QY9buaNeXts7OKopQFjxa
   DopuKQfSnXHzuR0W/yfSZALetLBB7bzQcfUbtdIIYiPkDsUeWWbZoPlqq
   FE/cbMbUY6jZ99s1A7aiRA6VWSaWJxOGkfudbylZmYLzVAAtHeonHyaIY
   33U1yYtGGCgaVZlR4OJgh86h6IyWdeN/vDsOCnkX5lUmpJgYFezu6SDeg
   hSlrnh+NL2AGZfSqJT9F6PUYd4EWffSD13hM6mj8ZQ5gq50qQ9bfLnJlT
   Q==;
X-CSE-ConnectionGUID: 4xV97NyaQBqTNxjxJSZh3w==
X-CSE-MsgGUID: 5kSxqEvXRnylfsoPqEefHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387144"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387144"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:17 -0700
X-CSE-ConnectionGUID: b5Wx593dS3KBTYp95gIP7w==
X-CSE-MsgGUID: +VXPVM+QR8+Kl3cS16yMXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685454"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v13 00/25] Allow AET to use PMT as loadable module
Date: Mon, 28 Sep 2026 15:14:44 -0700
Message-ID: <20260928221509.68002-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Requiring INTEL_PMT_TELEMETRY=y to enable AET is a functional workaround
to enable enumeration of Application Energy Telemetry (AET) events, but
unacceptable to many users. It results in increased configuration complexity,
increased kernel memory footprint and inability to patch problems by unloading
a module and loading an updated version.

Add a registration function to the AET code that can be used by
INTEL_PMT_TELEMETRY to provide the enumeration functions.

INTEL_PMT_TELEMETRY can be loaded/unloaded independently of
resctrl file system mount/unmount. Perform enumeration on
every mount and cleanup on every unmount.

Patch series based on TIP tree x86/cache branch current HEAD is:
  a17d099481bd ("x86/resctrl: Update documented unit for the "activity" event")

Signed-off-by: Tony Luck <tony.luck@intel.com>

Previous version (v12) here:
Link: https://lore.kernel.org/all/20260916231320.14502-1-tony.luck@intel.com/

Changes since v12:

[PATCH v13 01/25] fs/resctrl: Ensure default group reports tasks on monitor-only systems
	New patch (split from patch 9)

[PATCH v13 02/25] x86/cpufeatures: Add missing CQM feature dependency
	Added Reinette RB tag

[PATCH v13 03/25] x86/resctrl: Check if monitoring features are supported
	Dropped (Linux: X86_FEATURE_*) from commit comment
	s/specific features/resource specific features/
	s/L3-based monitoring features/L3 monitoring features/
	Added maintainer note about not back porting.

[PATCH v13 04/25] x86/resctrl: Centralize monitoring feature enumeration
	Update commit subject and comment as suggested.

[PATCH v13 05/25] x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
	Babu:
	s/intel_rdt_mbm_apply_quirk(r->mon.num_rmid)/intel_rdt_mbm_apply_quirk(num_rmid)/

	Reinette:
	Add comment to code describing model specific details of quirk.

[PATCH v13 06/25] x86/resctrl: Delete resctrl_cpu_detect()
	Replaced commit comment with Reinette improved version.

[PATCH v13 07/25] arm,x86,fs/resctrl: Replace architecture resctrl_arch_{alloc,mon}_capable()
	s/is alloc, or mon, capable/is capable of allocation or monitoring/

[PATCH v13 08/25] x86/resctrl: Update special case for Intel Haswell enumeration
	Replaced commit comment with Reinette's improved version.

[PATCH v13 09/25] x86/resctrl: Delete rdt_alloc_capable and rdt_mon_capable
	Expand commit message.

[PATCH v13 10/25] fs/resctrl: Remove redundant calls to resctrl_mon_capable()
	Moved change to is_closid_match() to its own patch.

[PATCH v13 11/25] x86/resctrl: Honor rdt={perf|energy} options to force enable AET events
	Update subject and commit comment to reflect that this change
	applies equally to rdt=energy.

[PATCH v13 12/25] fs/resctrl: Add interface to disable a monitor event
	Add back the comment that events must not be disabled while
	the file system is mounted.

[PATCH v13 13/25] arm,x86,fs/resctrl: Allocate maximum needed rmid_ptrs[]
	Updated commit message using Reinette suggestion.
	Merged patch 14 "Rebuild free RMID list on each mount" into
	this patch as the split into separate patches didn't work
	as well as I hoped.

[PATCH v13 14/25] arm,x86,fs/resctrl: Use right size for L3 monitor data structures
	Drop rename of local "idx_limit" to "l3_idx_limit"
	Re-wrote commit message.

[PATCH v13 15/25] x86,fs/resctrl: Handle systems where AET is the only resource
	Add a pr_info() if no L3 features are enabled on a
	"X86_FEATURE_CQM_LLC" system.

	Add a comment for the "return true" from get_rdt_mon_resources()

	Rewrite commit message with context for the change.

[PATCH v13 16/25] x86/resctrl: Add PMT registration API for AET enumeration callbacks
	Rewrote commit message using correct context at this point in the series.
	Use "pmt_telemetry" throughout.

[PATCH v13 17/25] platform/x86/intel/pmt: Register enumeration functions with resctrl
	Dropped empty line in pmt_telem_init()
	Rewrote commit message with accurate context.

[PATCH v13 18/25] x86/resctrl: Use registered function pointers for AET enumeration
	Replace intel_pmt_put_feature_group() call in intel_aet_exit()
	with call via registered function pointer.

	Explain in commit comment that pmt_telemetry is built-in so the
	try_module_get() is a no-op.

[PATCH v13 19/25] arm,x86,fs/resctrl: Enumerate AET on every resctrl mount
	Replace comment about holding resctrl_mount_lock for
	resctrl_arch_pre_mount() and resctrl_arch_unmount()
	with "Serialized against other mount and unmount attempts."

	Dropped stray blank line addition to rdt_get_tree()

	Rewrote commit message. Note that previous iterations of this
	patch series attempted to split into separate parts. But these
	were hard to explain separately.

[PATCH v13 20/25] x86/resctrl: Enforce system RMID limit on AET
	Drop sentence about SNC reducing number of RMIDs as it isn't
	relevant.

	s/lower/higher/ in commit message.

	s/IA32_PQR_ASSOC.RMID/MSR_IA32_PQR_ASSOC.RMID/

	Changed pqr_assoc_num_rmid from static to global.

	Move clamp from arch/x86/kernel/cpu/resctrl/core.c to
	arch/x86/kernel/cpu/resctrl/intel_aet.c

[PATCH v13 21/25] x86/resctrl: Export interface to report telemetry unbind/remove
	Dropped telemetry_region::addr from list of things protected
	by aet_register_lock.

	Declare and use aet_mmio_lock in this patch instead of next one.

	Explain the reason for the new lock.

[PATCH v13 22/25] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
	Context paragraph added describing the problem.

	New aet_mmio_lock moved to previous patch to avoid
	churn here changing lines that were just changed there.

	Add a comment in code that all entries for a removed device
	are on the same package.

[PATCH v13 23/25] x86/resctrl: Require 64-bit x86 for resctrl support
	Re-order tags
	s/This in line/This is in line/
	s/the state of/reduced/

[PATCH v13 24/25] x86/resctrl: Simplify Kconfig options for resctrl
	Re-order tags.
	Swap "intel_" prefix to "rdt_".

[PATCH v13 25/25] x86,fs/resctrl: Document telemetry mount timing caveat
	Drop the "Mounting resctrl with telemetry" section. Include the
	solution in the footnote.

Tony Luck (25):
  fs/resctrl: Ensure default group reports tasks on monitor-only systems
  x86/cpufeatures: Add missing CQM feature dependency
  x86/resctrl: Check if monitoring features are supported
  x86/resctrl: Centralize monitoring feature enumeration
  x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
  x86/resctrl: Delete resctrl_cpu_detect()
  arm,x86,fs/resctrl: Replace architecture
    resctrl_arch_{alloc,mon}_capable()
  x86/resctrl: Update special case for Intel Haswell enumeration
  x86/resctrl: Delete rdt_alloc_capable and rdt_mon_capable
  fs/resctrl: Remove redundant calls to resctrl_mon_capable()
  x86/resctrl: Honor rdt={perf|energy} options to force enable AET
    events
  fs/resctrl: Add interface to disable a monitor event
  arm,x86,fs/resctrl: Allocate maximum needed rmid_ptrs[]
  arm,x86,fs/resctrl: Use right size for L3 monitor data structures
  x86,fs/resctrl: Handle systems where AET is the only resource
  x86/resctrl: Add PMT registration API for AET enumeration callbacks
  platform/x86/intel/pmt: Register enumeration functions with resctrl
  x86/resctrl: Use registered function pointers for AET enumeration
  arm,x86,fs/resctrl: Enumerate AET on every resctrl mount
  x86/resctrl: Enforce system RMID limit on AET
  x86/resctrl: Export interface to report telemetry unbind/remove
  platform/x86/intel/pmt: Inform resctrl when MMIO maps are being
    removed
  x86/resctrl: Require 64-bit x86 for resctrl support
  x86/resctrl: Simplify Kconfig options for resctrl
  x86,fs/resctrl: Document telemetry mount timing caveat

 Documentation/filesystems/resctrl.rst      |   7 +-
 include/linux/arm_mpam.h                   |   3 -
 include/linux/intel_vsec.h                 |  14 ++
 include/linux/resctrl.h                    |  84 +++++++++++-
 arch/x86/include/asm/processor.h           |   4 -
 arch/x86/include/asm/resctrl.h             |  24 +---
 arch/x86/kernel/cpu/resctrl/internal.h     |  31 ++---
 arch/x86/kernel/cpu/amd.c                  |   3 -
 arch/x86/kernel/cpu/cpuid-deps.c           |   1 +
 arch/x86/kernel/cpu/hygon.c                |   3 -
 arch/x86/kernel/cpu/intel.c                |   7 -
 arch/x86/kernel/cpu/resctrl/core.c         | 150 +++++++++++----------
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 132 ++++++++++++++++--
 arch/x86/kernel/cpu/resctrl/monitor.c      |  78 +++++++----
 drivers/platform/x86/intel/pmt/telemetry.c |  45 ++++++-
 drivers/resctrl/mpam_resctrl.c             |  44 +++---
 fs/resctrl/monitor.c                       | 111 ++++++++++-----
 fs/resctrl/pseudo_lock.c                   |   6 +-
 fs/resctrl/rdtgroup.c                      |  74 ++++++----
 arch/x86/Kconfig                           |  15 +--
 arch/x86/kernel/cpu/resctrl/Makefile       |   3 +-
 21 files changed, 567 insertions(+), 272 deletions(-)


base-commit: a17d099481bd11f0911993a8e69992269f92ad12
-- 
2.55.0

