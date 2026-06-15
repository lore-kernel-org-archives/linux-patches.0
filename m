Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6094D31327F
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547908; cv=none; b=heFbrCNN6J1VY4YJzlU/utk5c25Zdnax7eHoLe2bRjsVO/eBMcCEW6z7Zt64ty1ZFnSEGJuhMQrHrB9Q8hGIWVY/M5LyLx16n6Jhy5qu/mJBvtHnCX0hdUgWhlWNcEPBJ3tzzydhcSomC8UYgvYgLGnWHY9tQr6eHSbFVIEKYoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547908; c=relaxed/simple;
	bh=3vHxne4NIxTNOcsc4bDpun1DKziAdTnkQYxLrh6xKsA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fmsi5nNr53DVYFMnYJgYib2E1U+3QHrDMTrJTJiiUcRw4oGt/X8WDChd0QaN2iOUfy8rbbxxvNrQV+nz5DWZA+xUrSBEfrvn4bMbzWG5tEnbhKnXIhlzAkkb6qFFxwYKsnTqe3yqm2HCp1Nubkxs7fVCgjfx6TbZbOTc6rUPAIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VoE3ShAM; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VoE3ShAM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547906; x=1813083906;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3vHxne4NIxTNOcsc4bDpun1DKziAdTnkQYxLrh6xKsA=;
  b=VoE3ShAMklqgRevSJMfjEBUm2j3ihaZxylQGFDV3YdaL62np7yKIpMEy
   QDM/6VpkEqwEMMIev4xAFUtf17/Of//MtFngODv0iMRk3FUMhNvdmzLL7
   hOrRg3gmARRwxAmUhz2KTSJ+qL4C4OWVOjHMK+hYDJNpSHHy7UqFf0wAM
   BbfxUXFT8o1WB9nkYcVoEFEPQ9N94176pJTdDIpwc7QWc2KmNcKWuN4Lr
   EtzkBiuw1hrs+/SwDYWE4lRB4BdCnngpvO9H7bqadqpm5ndzfP4nXbySn
   mm4iv4+Y19mfTZEk7CaMnNUjRCfl4AhMcd38kNQ14D/5R1BzSLKsnNyaG
   w==;
X-CSE-ConnectionGUID: IcqP5Fx1SFuyBsBQI9yAew==
X-CSE-MsgGUID: 8u2Ir54sQX210ono4S1yJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789907"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789907"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:05 -0700
X-CSE-ConnectionGUID: JRkjs3WYQPOBLJ02avnHlg==
X-CSE-MsgGUID: UbuCqcU+RWa+45bPjt5YnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620573"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:05 -0700
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
Subject: [PATCH v8 00/16] Allow AET to use PMT as loadable module
Date: Mon, 15 Jun 2026 11:24:41 -0700
Message-ID: <20260615182457.14725-1-tony.luck@intel.com>
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

Changes since v7:
Link: https://lore.kernel.org/all/20260601195632.15876-1-tony.luck@intel.com/

Rebased to v7.1

Patches 1-4 updated from latest (v5) series from Reinette:
Link: https://lore.kernel.org/all/cover.1781029125.git.reinette.chatre@intel.co
Those four patches had their own review and (hopefully) will be included
in TIP tree during this v7.2-rc* cycle.

Patch 5 is new to resolve the issue that the PMT driver could be unbound
from the pmt_telemtry module which would unmap all the MMIO register
space. Discussed offline with David Box, but needs his Ack/Review tag
here.

Patches 6-14 and 16 all have updates based on review comments see the
individual patches for change log after the "---"

Reinette Chatre (1):
  fs/resctrl: Fix deadlock on errors during mount

Tony Luck (15):
  fs/resctrl: Move functions to avoid forward references in subsequent
    fixes
  fs/resctrl: Free mon_data structures on rdt_get_tree() failure
  fs/resctrl: Fix use-after-free during unmount
  platform/x86/intel/pmt: Prevent unbind of PMT telemetry driver
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
  Documentation/filesystems/resctrl: Add footnote for telemetry fstab
    mount caveat

 Documentation/filesystems/resctrl.rst      |   7 +-
 include/linux/resctrl.h                    |  47 ++-
 arch/x86/include/asm/resctrl.h             |  21 +-
 arch/x86/kernel/cpu/resctrl/internal.h     |  24 +-
 arch/x86/kernel/cpu/resctrl/core.c         |  69 ++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c    |  91 +++-
 arch/x86/kernel/cpu/resctrl/monitor.c      |   6 -
 drivers/platform/x86/intel/pmt/telemetry.c |   9 +
 drivers/resctrl/mpam_resctrl.c             |   9 +
 fs/resctrl/monitor.c                       |  93 +++--
 fs/resctrl/rdtgroup.c                      | 464 ++++++++++++---------
 arch/x86/Kconfig                           |  15 +-
 arch/x86/kernel/cpu/resctrl/Makefile       |   2 +-
 13 files changed, 565 insertions(+), 292 deletions(-)


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
2.54.0

