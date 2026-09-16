Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2365D2772D
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600412; cv=none; b=qf/dUsVutAsfqD4TMZr9l9BmO1CosmpPQ15xJpuoveO8qc9jI0FphFWlSdfVtfnToWwyAUgJy8NLgLPTyQ0s5b1s1Sq5vWw5MbrM5lpxvj2ivzpvcqoni0T2SXpxh4IR1rKIkS5X6hLAEtvK93obYAlDrMZmHnnqGJ2tf+47lSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600412; c=relaxed/simple;
	bh=cqkJFNFPmKzPtSBoOm5R1dM0JXaMxgSw2Kc8SB3L7dM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IRkA0OJehe5wV92+gCcadUp7XCjKxVWX4dhZcSShVqIDYIUO2OtyHiqSSeC3te8p4rFX+kBM+tG7nJ27wCOPgpZX4ve/TUPiCuTu1J3ViwNhxYo5z2nPGz8LE1OY9uRAsv80FhouUIzJwvVrsMMFonVgfHPM2gnn3bEJ6nCVdZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rju2ml2N; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rju2ml2N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600410; x=1821136410;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cqkJFNFPmKzPtSBoOm5R1dM0JXaMxgSw2Kc8SB3L7dM=;
  b=Rju2ml2NcuV6BMmiUkB6vXa4+Ft5OfGFBt0PgR/3NddSPm3uOM+96Leq
   Gxf0m60w4+a33LjyHAV6ytCc/dIgosa/Xbi1GviEmtcUuqUbYavCMFcGJ
   HD75SKM5vi+rO+LmauN8ntaIRh6qNgJ9rVqDvTacNXiSOP2jVLLGt9k3Q
   DllDAkDz1om2gz//gMYYDdLrtUMGCqXznnaURFTbzQTYYfLtPzTpmZ9KL
   iWTyyBgCHpVC6E7sCvJWOtvfgCeSutatn4vHIAFRTWdFEdT6bOAu1mPU5
   Y6+/ilMm/i9K5ymCfdzXx2Rfv/YoqQwcM00etCnXhOzLarbbLRyfgh0tC
   w==;
X-CSE-ConnectionGUID: k9RAEjwGSgamRa9XeX3h3g==
X-CSE-MsgGUID: ZLPy+0IQTPiF0K6BgJpihg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861311"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861311"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:30 -0700
X-CSE-ConnectionGUID: I9G8xBqzTtaRX3D2cafWyg==
X-CSE-MsgGUID: guv2WdsvSdisAJiJMRk7Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231416"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:30 -0700
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
Subject: [PATCH v12 00/25] Allow AET to use PMT as loadable module
Date: Wed, 16 Sep 2026 16:12:55 -0700
Message-ID: <20260916231320.14502-1-tony.luck@intel.com>
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

Patch series based on v7.3-rc3

Signed-off-by: Tony Luck <tony.luck@intel.com>

Changes since v11:
Link: https://lore.kernel.org/all/20260831174421.13921-1-tony.luck@intel.com/

Patch 12 "Handle change in number of RMIDs on each mount"
	split into three parts (12, 13, 14 in this series)
Patch 14 "Enforce system RMID limit on AET event groups"
	massively simplified, and moved later (now patch 20).

See individual patches for changes to each part.

Tony Luck (25):
  x86/cpufeatures: Add missing CQM feature dependency
  x86/resctrl: Check if monitoring features are supported
  x86/resctrl: Enumerate monitor features in rdt_get_l3_mon_config()
  x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
  x86/resctrl: Delete resctrl_cpu_detect()
  arm,x86,fs/resctrl: Replace architecture
    resctrl_arch_{alloc,mon}_capable()
  x86/resctrl: Update special case for Intel Haswell enumeration
  x86/resctrl: Delete rdt_alloc_capable and rdt_mon_capable
  fs/resctrl: Remove redundant calls to resctrl_{alloc,mon}_capable()
  x86/resctrl: Honor rdt=perf option to force enable AET perf events
  fs/resctrl: Add interface to disable a monitor event
  arm,x86,fs/resctrl: Allocate maximum needed rmid_ptrs[]
  arm,x86,fs/resctrl: Allocate right size for L3 monitor arrays
  fs/resctrl: Rebuild free RMID list on each mount
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

 Documentation/filesystems/resctrl.rst      |  18 ++-
 include/linux/arm_mpam.h                   |   3 -
 include/linux/intel_vsec.h                 |  14 ++
 include/linux/resctrl.h                    |  82 ++++++++++-
 arch/x86/include/asm/processor.h           |   4 -
 arch/x86/include/asm/resctrl.h             |  24 +---
 arch/x86/kernel/cpu/resctrl/internal.h     |  23 +---
 arch/x86/kernel/cpu/amd.c                  |   3 -
 arch/x86/kernel/cpu/cpuid-deps.c           |   1 +
 arch/x86/kernel/cpu/hygon.c                |   3 -
 arch/x86/kernel/cpu/intel.c                |   7 -
 arch/x86/kernel/cpu/resctrl/core.c         | 150 ++++++++++++---------
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 114 ++++++++++++++--
 arch/x86/kernel/cpu/resctrl/monitor.c      |  71 ++++++----
 drivers/platform/x86/intel/pmt/telemetry.c |  47 ++++++-
 drivers/resctrl/mpam_resctrl.c             |  44 +++---
 fs/resctrl/monitor.c                       | 119 +++++++++++-----
 fs/resctrl/pseudo_lock.c                   |   6 +-
 fs/resctrl/rdtgroup.c                      |  79 +++++++----
 arch/x86/Kconfig                           |  15 +--
 arch/x86/kernel/cpu/resctrl/Makefile       |   3 +-
 21 files changed, 562 insertions(+), 268 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.55.0

