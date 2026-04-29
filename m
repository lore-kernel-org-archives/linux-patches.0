Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5C4421EF5
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 18:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488551; cv=none; b=HWAF57ArJI+krHSJPtYPfvtL3xkMSIIoC+JQXD9w81UyjJDA0wMGTdkDkYTP8+cDIcZwblPvh5VwSWUfDLp++dKIur0C5TRZWK5Y9ot6dqMp4eQ0Q9qtRYbhiR/ifCkXiKdw5YlK3qayDHFKnXdej3PYh2fa21n1Ds0N5m1mikg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488551; c=relaxed/simple;
	bh=W2c9Hu+pqWRrHN7USQaMAcmpQJ6J+2cXLxOZi6sXM8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CnmqsDM32La6C93tClFZ3V/66Qj6TZ2wmx+7p10dXh1Q3FWM0X8LlZZ2vOhSAhGRlJ/1sOgO5Qd4lIkMKT6EayyKVAa8z1AoJOTGnjRZELaks7tjj8vwRjt2g1C+oOgeZvhLQ+WFNF7p5asT0goFAi1v12LmGR+b8P0RFo0JEgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O1iyGWF3; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O1iyGWF3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777488547; x=1809024547;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=W2c9Hu+pqWRrHN7USQaMAcmpQJ6J+2cXLxOZi6sXM8c=;
  b=O1iyGWF3qhKuz1Q09Ls2HzVtHPoYV03c8C0fOUnAlF5ilr5TaodyxhQe
   A5P3MoUbw4G2BkvxyE/b1lQCaPnEyu/5VChuk0+JUzjMjxTjXiGEpSy2K
   SRKvPjB+KZOtVIfMKG9kYtTM8X+MRcWUsdZpj7rWkK/AliDTi9uh+uKnO
   aksBx28C/AFoVFxgLiDPRxXoX0gI1gJS+iHPMc1S1QXHZUOMt/m6e8uhS
   /zE+Pe/Qzk+83t2QhzgAVBOmj0pRWsVt4dkeE+ZlOpriQCfQzGCKWMHlG
   2FgPNXpesi3onrCdd+adUEHCbljdPUCl82pIiB3F1X79x3MmhqXXM5ryL
   w==;
X-CSE-ConnectionGUID: DytwEsQFQWOrHsRmuqaBvA==
X-CSE-MsgGUID: LokMF7lxQ72neZAovmD5gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89890670"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89890670"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:05 -0700
X-CSE-ConnectionGUID: gOFSaHfKTwahBFxpPSvbcQ==
X-CSE-MsgGUID: bjBPzikVSIy16wyKec6veA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="238322979"
Received: from mjruhl-desk.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.13])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:05 -0700
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
Subject: [PATCH v6 00/10] Allow AET to use PMT as loadable module
Date: Wed, 29 Apr 2026 11:48:48 -0700
Message-ID: <20260429184858.36423-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Requiring INTEL_PMT_TELEMETRY=y to enable AET is a functional workaround
to enable enumeration of Application Energy Telemetry (AET) events, but
unacceptable to many users. It results in increased configration complexity,
increased kernel memory footprint and inability to patch problems by unloading
a module and loading an updated version.

Add a registration function to the AET code that can be used by
INTEL_PMT_TELEMETRY to provide the enumeration functions.

INTEL_PMT_TELEMETRY can be loaded/unloaded independently of
resctrl file system mount/unmount. Perform enumeration on
every mount and cleanup on every unmount.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Changes since v5:
Link: https://lore.kernel.org/all/20260410200532.58602-1-tony.luck@intel.com/

Moved locking around mount/unmount out of file system layer and into
x86 architecture code.

Fixed unmount cleanup to avoid empty mon_data directories if there is
no L3 monitoring and AET is enabled, then disabled on a subsequent
mount.

Fixed RMID allocation to cope with changed number of RMIDs from mount to
mount.

Added footnote to resctrl documentation warning user that AET may not be
enabled if the file system is mounted before enumeration completes.

Drop X86_CPU_RESCTRL_INTEL_AET from Kconfig.

FYI: Seems like no conflicts with Reinette's resctrl cleanup series:
Link: https://lore.kernel.org/all/cover.1777419024.git.reinette.chatre@intel.com/
This series applies cleanly on top of Reinette's patches, builds cleanly,
and passes resctrl selftests.

Tony Luck (10):
  x86/resctrl: Stop setting event_group::force_off on RMID shortage
  fs/resctrl: Add interface to disable a monitor event
  x86/resctrl: Maintain a count of enabled monitor features
  fs,x86,mpam/resctrl: Handle change in number of RMIDs on each mount
  x86/resctrl: x86/resctrl: Add PMT registration API for AET enumeration
    callbacks
  platform/x86/intel/pmt: Register enumeration functions with resctrl
  x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
  fs/resctrl: Call architecture hooks for every mount/unmount
  x86/resctrl: Simplify Kconfig options for resctrl
  Documentation/filesystems/resctrl: Add footnote for telemetry fstab
    mount caveat

 Documentation/filesystems/resctrl.rst      |  7 +-
 include/linux/resctrl.h                    | 43 +++++++++++-
 arch/x86/include/asm/resctrl.h             | 17 ++++-
 arch/x86/kernel/cpu/resctrl/internal.h     | 19 +-----
 arch/x86/kernel/cpu/resctrl/core.c         | 77 ++++++++++++++++++----
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 67 ++++++++++++++++---
 arch/x86/kernel/cpu/resctrl/monitor.c      | 11 +---
 drivers/platform/x86/intel/pmt/telemetry.c | 17 ++++-
 drivers/resctrl/mpam_resctrl.c             |  5 ++
 fs/resctrl/monitor.c                       | 59 ++++++++++++-----
 fs/resctrl/rdtgroup.c                      | 11 +++-
 arch/x86/Kconfig                           | 16 +----
 arch/x86/kernel/cpu/resctrl/Makefile       |  2 +-
 13 files changed, 264 insertions(+), 87 deletions(-)


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.53.0

