Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15038349CC1
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941763; cv=none; b=Pn9eMXnzXir7uJCPiB+rl+qiv3CFu0sktjnt5BNabYRaaQ0s8bU1nGJO28rWx/0nEQs7lFv3pQOSFD3LxRobCu9oL7jy4aZ/bVDSY5nnS6pZBO+aAFvMGnbOLra1P/UK1SDDzdgISlay9K+l0slglezyOsSzAlRs7KQvlem0f+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941763; c=relaxed/simple;
	bh=gAwuQJoipB5FdKd778/4xpiEZtaUWcbhs3BHpxOyf1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QMxLyuQCBQiWT4IEfZ6CSWmd2xCkZ+PwltK92yQu8khw0qvoFTSqtDsTtJ2Rk2OBdHPZ/z45t3z4v8w2fkAQRllRmzGAA000LDtOM9AIqilql3emZef+OCRKxq0u8NeXRk1WmbAIm88N+Vwry+G5gDZN1KAvcKtKcdMuSueVdBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T0gN7rZ6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T0gN7rZ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941762; x=1814477762;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gAwuQJoipB5FdKd778/4xpiEZtaUWcbhs3BHpxOyf1Q=;
  b=T0gN7rZ6KiUoS6HaJNVoExE3ofu4tjC255mLK1FXoMlRvqqOMhXx72SI
   Krq1e5jpJpJTK8bFVo/r+qWwt40Tx5BXLFOsy7ID/8LeIxqcgwxStOnmE
   /E+27v3tU/G4rErm6CQeZsDE+OM9XQHp6xMCodX1DlAw2qwB41zgeIApm
   OZblZLD5gfemV/aQoWkNSEUIV1P7E5gQzzK19fRDSZ/wGhMZEA68PUZr5
   OKQXyxpX9rBwkxID6tyjRalDUxgH8Eer/y2l4pZtknyXKmofEcxYbYFZ4
   /ioOrcJggusYzjNAB4iWp7EHMCxOOf6iB9+vcY1jqmLApAs1L+LZV/1Ra
   g==;
X-CSE-ConnectionGUID: E59kaglaTSeZST2OcQ/tpA==
X-CSE-MsgGUID: rfDOe5kFRqquhjXH/aQfVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285741"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285741"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:01 -0700
X-CSE-ConnectionGUID: 6GddB9DITTWXZ1KYtzRbdA==
X-CSE-MsgGUID: lScr9YfCQfepA6OgM83CoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242514"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:01 -0700
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
Subject: [PATCH v9 00/12] Allow AET to use PMT as loadable module
Date: Wed,  1 Jul 2026 14:35:41 -0700
Message-ID: <20260701213553.15222-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
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

Patch series based on v7.2-rc1 plus Reinette's "Fix long-standing issues"[1]
and "Improve resctrl quality and consistency"[2] series.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Changes since v8[3]:

0001:	Suppress_bind_attrs for intel_vsec as well as intel_telemetry
0008:	PROBE_FORCE_SYNCHRONOUS and register/unregister in init/exit
0009:	Remove broken atomic ops introduced in v8. Handle repeat mount
	attempts in intel_aet.c - See Sashiko v8 review[4].
0012:	Add example udev and systemd config files to mount resctrl

Link: https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/ [1]
Link: https://lore.kernel.org/all/cover.1782857711.git.reinette.chatre@intel.com/ [2]
Link: https://lore.kernel.org/lkml/20260615182457.14725-1-tony.luck@intel.com/ [3]
Link: https://sashiko.dev/#/patchset/20260615182457.14725-1-tony.luck%40intel.com [4]

Tony Luck (12):
  platform/x86/intel/{pmt,vsec}: Prevent unbind via sysfs
  fs/resctrl: Remove redundant calls to resctrl_arch_mon_capable()
  x86/resctrl: Honor rdt=perf option to force enable AET perf events
  fs/resctrl: Add interface to disable a monitor event
  x86/resctrl: Drop global 'rdt_mon_capable' flag
  arm,x86,fs/resctrl: Handle change in number of RMIDs on each mount
  x86/resctrl: Add PMT registration API for AET enumeration callbacks
  platform/x86/intel/pmt: Register enumeration functions with resctrl
  arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
  fs/resctrl: Call architecture hooks for every mount/unmount
  x86/resctrl: Simplify Kconfig options for resctrl
  Documentation/filesystems/resctrl: Document telemetry mount timing
    caveat

 Documentation/filesystems/resctrl.rst      | 60 +++++++++++++-
 include/linux/resctrl.h                    | 47 ++++++++++-
 arch/x86/include/asm/resctrl.h             | 21 +++--
 arch/x86/kernel/cpu/resctrl/internal.h     | 24 +++---
 arch/x86/kernel/cpu/resctrl/core.c         | 57 +++++++++++--
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 96 +++++++++++++++++++---
 arch/x86/kernel/cpu/resctrl/monitor.c      |  6 --
 drivers/platform/x86/intel/pmt/telemetry.c | 13 ++-
 drivers/platform/x86/intel/vsec.c          |  3 +
 drivers/resctrl/mpam_resctrl.c             |  9 ++
 fs/resctrl/monitor.c                       | 93 ++++++++++++++-------
 fs/resctrl/rdtgroup.c                      | 16 ++--
 arch/x86/Kconfig                           | 15 +---
 arch/x86/kernel/cpu/resctrl/Makefile       |  2 +-
 14 files changed, 371 insertions(+), 91 deletions(-)

-- 
2.54.0

