Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4427C348C77
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346085; cv=none; b=KQUx90eXHQewZi0hl3SnoBdM1oMLwykgmQMK1AIMCCOmXnsniw6WcWDvE/WrkV+pzxDBATqBNsc+NQdiDBQy7LZCGKhX5XgxCoLAuBnwJphwPUjIEZFHDcJ/8CL6TB/z2YtH8Ycb0ptk0XeUJJP7ZKdCFvk7pMPis2SinBHl/7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346085; c=relaxed/simple;
	bh=JLz9I2lxKSUs1M8gizAwWUQHNzNsxy2vmPxoYlslL6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E27DMmU52RhzfbHSeQzDKzruz7FMIGjOF+42Ug0vajGiCpgEP7WGnmZ8oCVB67BOqsGxGjmFPj4NaGRoz+8hIvJ7pnXxTLFvhzht+h89zVpsgeaOQkiQDfE2CYpI26Fs/MbRzBZ8dba2M9C/mfwGAYk13L8Bz3dgRvmObEDC5cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=go9qbPrb; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="go9qbPrb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346082; x=1816882082;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JLz9I2lxKSUs1M8gizAwWUQHNzNsxy2vmPxoYlslL6g=;
  b=go9qbPrb4mHY9syq1CoPF9L6e/yedE1+QAwfvwJ80jVP2j2uxjJm6tws
   k0KwVyr8NSVADMlHcYfU9m53FEDOBnBAzr6S7+yFvXlzsS1nTHtEnWbet
   N0w86Rzx+rFNt4LkZc3UJVR8HKWyWUF++0rBd4MOgEmT+UdJGGnmMKle6
   Y77lnkd9vgmsu0E8koJPnVpFOnqmH1bUaC6nZ91vigtxidr93IpWt+LZl
   UPD1eG33WwArDVZ1Pi7zn+b2df9HV2mTrBS6NFgIBNuDyeJ4DUYf+fPYe
   wt8BR2VjOBqnK+bh9VUf8izautQnrR6evpws9UiU/pHZLRCMIRYAX0NvJ
   w==;
X-CSE-ConnectionGUID: k+SmAzLPRHeX/SdTIAfa0A==
X-CSE-MsgGUID: 488F7gxkQJyWtyjmU+lamA==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473548"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473548"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:00 -0700
X-CSE-ConnectionGUID: X+jg5i5RSz6gX5YvnXzryA==
X-CSE-MsgGUID: dAzvuQAFRJOO3G7AV7VsNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024542"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:00 -0700
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
Subject: [PATCH v10 00/17] Allow AET to use PMT as loadable module
Date: Wed, 29 Jul 2026 10:27:35 -0700
Message-ID: <20260729172752.11561-1-tony.luck@intel.com>
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

Patch series based on tip[1] git repo x86/cache branch. Top commit at time
of snapshot:
854db793d407 ("fs/resctrl: Inform user space when status buffer overflowed")

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Changes since v9[2]:

A few new patches:

0001 Fix CPUID enumeration to conform to Intel/AMD manuals.
0002 Split X86_64 Kconfig dependency into its own patch.
0008 Adjust all event_group::num_rmid values to not exceed system maximum.
0012 Add locking to resctrl_arch_pre_mount() and resctrl_arch_unmount().
0015 Add notification to AET when devices are unbound or removed.

Other patches updated based on comments and dicussion of the v9 series.
See indivdual patches for details.

Link: git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git [1]
Link: https://lore.kernel.org/all/20260701213553.15222-1-tony.luck@intel.com/ [2]

Chen Yu (1):
  x86/resctrl: Require 64-bit x86 for resctrl support

Tony Luck (16):
  x86/resctrl: Fix enumeration of number of supported RMIDs
  fs/resctrl: Remove redundant calls to resctrl_arch_mon_capable()
  x86/resctrl: Honor rdt=perf option to force enable AET perf events
  fs/resctrl: Add interface to disable a monitor event
  x86/resctrl: Drop global 'rdt_mon_capable' flag
  arm,x86,fs/resctrl: Handle change in number of RMIDs on each mount
  x86/resctrl: Enforce system RMID limit on AET event groups
  x86/resctrl: Add PMT registration API for AET enumeration callbacks
  platform/x86/intel/pmt: Register enumeration functions with resctrl
  arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
  x86/resctrl: Prepare to handle nested mount requests
  fs/resctrl: Call architecture hooks for every mount/unmount
  x86/resctrl: Export interface to report telemetry unbind/remove
  platform/x86/intel/pmt: Inform resctrl when MMIO maps are being
    removed
  x86/resctrl: Simplify Kconfig options for resctrl
  Documentation/filesystems/resctrl: Document telemetry mount timing
    caveat

 Documentation/filesystems/resctrl.rst      |  60 ++++++++-
 include/linux/arm_mpam.h                   |   1 -
 include/linux/intel_vsec.h                 |  14 +++
 include/linux/resctrl.h                    |  66 +++++++++-
 arch/x86/include/asm/resctrl.h             |   6 -
 arch/x86/kernel/cpu/resctrl/internal.h     |  14 ++-
 arch/x86/kernel/cpu/resctrl/core.c         | 118 +++++++++++++++---
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 138 +++++++++++++++++++--
 arch/x86/kernel/cpu/resctrl/monitor.c      |  10 +-
 drivers/platform/x86/intel/pmt/telemetry.c |  44 ++++++-
 drivers/resctrl/mpam_resctrl.c             |  12 +-
 fs/resctrl/monitor.c                       |  99 ++++++++++-----
 fs/resctrl/rdtgroup.c                      |  20 ++-
 arch/x86/Kconfig                           |  15 +--
 arch/x86/kernel/cpu/resctrl/Makefile       |   2 +-
 15 files changed, 511 insertions(+), 108 deletions(-)


base-commit: 854db793d4073087fa799d886ed84a342e3f484a
-- 
2.55.0

