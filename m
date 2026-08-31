Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53A71FF7C7
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198274; cv=none; b=LPYts81cNirHTMT1YU/6h+am/trJi8CXp2MK1vn3eDmQOd603VyFzTFV6qIAy/vzcw4LKmTaa+RuHZAPqCKOxUyKUepMG1PDD2T16O2WfVV15puNPgrrQMZlZnZtjPz+N98QaLMH2D+yav8SGx6JtIhuWFvuTYS6LoQKMD0Y1Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198274; c=relaxed/simple;
	bh=+l/a+UB3qUaycrzGLXosMOwUslQcmOgRsf/S1fbGN+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vDbcQ3UL08mEF9FeBeqHZrzHW+87Ou5EspbCHkVJg4XJxVDHpLixjD0qpD3dH0+k2aRXL+ns3bVWfyeda+DD6Y3uHfQZAOCmjKd1MGCxnJWVRDrseAOs4SDB5tigsSfZzwR4hymeOhJCsVp9nLqFT+WurkR+DBEQVJ1pZ1S7bZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DQPTFI4N; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DQPTFI4N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198271; x=1819734271;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+l/a+UB3qUaycrzGLXosMOwUslQcmOgRsf/S1fbGN+0=;
  b=DQPTFI4NvyDGCeVabi++6sQmZIP30v+OlGHetq0yNT9mAEW+hMN/1Ogx
   bPtccUrbH+5xH56GnAD9x77W6oMy7g/liA5OGSKG8HhKtZHqRM8MywN3P
   EjOBdmij9/qidie7h7+m16FBXyJ8dRfYfSwOHfUm0hE1EqCLM4WpS6fF4
   3ZhYyrOrcskYZlL4yW938+6ijNOyTF4XpSdEODJ3r1uBsqhNTObxX+spc
   /Zjs9vwuewL09grdFA6/ofRq3XZ+C/kd0o0juleU1/1INkyU2vHZQ8S1y
   uoM37iEQEJI0wgmgZByEFjuxKV5IulhT/cIubOkTumNmfYiXrG0UZzFQK
   w==;
X-CSE-ConnectionGUID: Bqq++uzsQOqakgT4iNNZ4w==
X-CSE-MsgGUID: 5xrMx2vhSGaIgKu5umAnsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92479888"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92479888"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:31 -0700
X-CSE-ConnectionGUID: sR8u0EstT9qsh8WfQoheRg==
X-CSE-MsgGUID: ykbAgbwKTCSyKrOZH7lp7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906935"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:29 -0700
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
Subject: [PATCH v11 00/23] Allow AET to use PMT as loadable module
Date: Mon, 31 Aug 2026 10:43:58 -0700
Message-ID: <20260831174421.13921-1-tony.luck@intel.com>
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

Patch series based on v7.3-rc1

Signed-off-by: Tony Luck <tony.luck@intel.com>

Changes since v10:
Link: https://lore.kernel.org/all/20260729172752.11561-1-tony.luck@intel.com/

Several cleanups prepended to the series based on v10 discussion in
patches 1..8. See individual patches for changes to each part.

Tony Luck (23):
  x86/resctrl: Give better names to X86_FEATURE flags for monitoring
  x86/resctrl: Check if monitoring features are enabled
  x86/resctrl: Enumerate monitor features in rdt_get_l3_mon_config()
  x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
  x86/resctrl: Delete resctrl_cpu_detect()
  arm,x86,fs/resctrl: Replace architecture
    resctrl_arch_{alloc,mon}_capable()
  x86/resctrl: Add special case for Intel Haswell enumeration
  x86/resctrl: Delete rdt_alloc_capable and rdt_mon_capable
  fs/resctrl: Remove redundant calls to resctrl_mon_capable()
  x86/resctrl: Honor rdt=perf option to force enable AET perf events
  fs/resctrl: Add interface to disable a monitor event
  arm,x86,fs/resctrl: Handle change in number of RMIDs on each mount
  x86/resctrl: Handle systems when AET is the only resource
  x86/resctrl: Enforce system RMID limit on AET event groups
  x86/resctrl: Add PMT registration API for AET enumeration callbacks
  platform/x86/intel/pmt: Register enumeration functions with resctrl
  arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
  fs/resctrl: Call arch code for every mount
  x86/resctrl: Export interface to report telemetry unbind/remove
  platform/x86/intel/pmt: Inform resctrl when MMIO maps are being
    removed
  x86/resctrl: Require 64-bit x86 for resctrl support
  x86/resctrl: Simplify Kconfig options for resctrl
  x86/resctrl: Document telemetry mount timing caveat

 Documentation/arch/x86/cpuinfo.rst         |   2 +-
 Documentation/filesystems/resctrl.rst      |  60 +++++++-
 include/linux/arm_mpam.h                   |   3 -
 include/linux/intel_vsec.h                 |  14 ++
 include/linux/resctrl.h                    |  74 +++++++++-
 arch/x86/include/asm/cpufeatures.h         |   4 +-
 arch/x86/include/asm/processor.h           |   4 -
 arch/x86/include/asm/resctrl.h             |  24 +--
 arch/x86/kernel/cpu/resctrl/internal.h     |  24 +--
 tools/arch/x86/include/asm/cpufeatures.h   |   4 +-
 arch/x86/kernel/cpu/amd.c                  |   3 -
 arch/x86/kernel/cpu/cpuid-deps.c           |   8 +-
 arch/x86/kernel/cpu/hygon.c                |   3 -
 arch/x86/kernel/cpu/intel.c                |   7 -
 arch/x86/kernel/cpu/resctrl/core.c         | 162 +++++++++++----------
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 132 +++++++++++++++--
 arch/x86/kernel/cpu/resctrl/monitor.c      |  71 ++++++---
 arch/x86/kernel/cpu/scattered.c            |   2 +-
 drivers/platform/x86/intel/pmt/telemetry.c |  46 +++++-
 drivers/resctrl/mpam_resctrl.c             |  44 +++---
 fs/resctrl/monitor.c                       | 112 ++++++++++----
 fs/resctrl/pseudo_lock.c                   |   6 +-
 fs/resctrl/rdtgroup.c                      |  76 ++++++----
 arch/x86/Kconfig                           |  15 +-
 arch/x86/kernel/cpu/resctrl/Makefile       |   2 +-
 25 files changed, 620 insertions(+), 282 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.55.0

