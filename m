Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B400F2F7F03
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343801; cv=none; b=IJXO1gI3Ruc2BT7b/Py7vhX1hK4XIYwGF+zDMXtQ3zYrh4+zKrJrN42Ji/3vhnEuu4/dVEpd0Ozz0n+0x5UHmrY5CrWSahJU4NGvLqwWYwe52rUHTDOyowYEax92uvkCHHORJajoSWi9c0h3fRe+vxmiq6VYP55y89s3qqvqSuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343801; c=relaxed/simple;
	bh=56ih7yuJBuK4VOcCh+OVUVolPbNFOGOfnLujZbotXQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TjNvDxgfYGpMF5CMiKCoGQK4zz9snwjFZZLK0Exl9Aibp1X92GXs5QDyTEg5/mWTSQil3lOnclKBhhLF819FvC/6akFzGToGwqv2NQSotvIqTck6zNHVKIdx94M3n0/aOYqyiMGjvOM+oIIC29Ef/AdaMjFCiqeyzuvhrKPX8hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kZQxf3rP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kZQxf3rP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343800; x=1811879800;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=56ih7yuJBuK4VOcCh+OVUVolPbNFOGOfnLujZbotXQE=;
  b=kZQxf3rP4leXJDk3Xg9fDvC7BSBxJXttozUQJ19Ka26uCA4MabeT66ud
   sv3gfNKtE+YWxfd3vWpV/lUlcG6LHbQKaq59fd1kt+YtbuHULVS6tjonF
   y8oU9Zt6eNO4Q1AWzLJTVdDhcdyySH1ARXs7tigLtTwCtKJ+KjN4hymTx
   /d9JIK0OX/Jy30os2nN3CUzs1h/iLYEg4QhjJqqJJLWuYpFVWMdhi91mq
   hPH6cUalMFkhz5/ABLmDM8DBfF6Feh6Iu3cm29oAHSM/mhbWAbL2bZQEO
   n6MzgrR1LBVpUoQTYiQTchZ+d6w0ioxClhK9xkUDYmvxwt4G7yMARrjYZ
   A==;
X-CSE-ConnectionGUID: lwC7xqqPR3eV5xMIQ3wgSw==
X-CSE-MsgGUID: nTOdLns/SbyJbOc7wElyCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011550"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011550"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:40 -0700
X-CSE-ConnectionGUID: qadHUfEsRMqX2wr6wAnoTA==
X-CSE-MsgGUID: GsOMW7jLSHe8/xGyZi1q7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946485"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:38 -0700
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
Subject: [PATCH v7 00/14] Allow AET to use PMT as loadable module
Date: Mon,  1 Jun 2026 12:56:18 -0700
Message-ID: <20260601195632.15876-1-tony.luck@intel.com>
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

Changes since v6:
Link: https://lore.kernel.org/all/20260429184858.36423-1-tony.luck@intel.com/

Sashiko found some unrelated issues during review of v6 which have
been resolved here:
Link: https://lore.kernel.org/all/cover.1779476724.git.reinette.chatre@intel.com/

The first four patches from that series are included as patches 1-4 here
because I need the re-worked file system mount/unmount code as a base.

Patches 5-14 are the real meat of this series. Changes since v6:

1) Now pass a pointer to THIS_MODULE from pmt_telemetry via the
registration call so that AET can add/remove references instead
of this being done inside the pmt_module.

2) Limit exposure of the registration functions using EXPORT_SYMBOL_NS_GPL()

3) Fix a bug that could leak holds on the pmt_module

4) Drop the call to request_module("pmt_telemetry"). Platforms that
support AET will auto-load this based on the PCIe ID of the OOBMSM
device. Forcing a load on other platforms is a waste of time.

5) Move the unregistration to the start of pmt_telem_exit()

6) Add resctrl_arch_unmount() stub to MPAM code.

7) Use resctrl_arch_rmid_idx_encode() in limbo_release_entry() when
deciding whether to add an RMID to the free list.

8) Kconfig: drop dependency on INTEL_PMT_TELEMETRY. If a kernel is being
built for a system that supports Intel telemetry, then the user will
select it themself. Including the dependency may hide the option to
select X86_CPU_RESCTRL.

Reinette Chatre (1):
  fs/resctrl: Fix deadlock for errors during mount

Tony Luck (13):
  fs/resctrl: Move functions to avoid forward references in subsequent
    fixes
  fs/resctrl: Free mon_data structures on rdt_get_tree() failure
  fs/resctrl: Fix use-after-free during unmount
  x86/resctrl: Stop setting event_group::force_off on RMID shortage
  fs/resctrl: Add interface to disable a monitor event
  x86/resctrl: Maintain a count of enabled monitor features
  fs,x86,mpam/resctrl: Handle change in number of RMIDs on each mount
  x86/resctrl: Add PMT registration API for AET enumeration callbacks
  platform/x86/intel/pmt: Register enumeration functions with resctrl
  mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
  fs/resctrl: Call architecture hooks for every mount/unmount
  x86/resctrl: Simplify Kconfig options for resctrl
  Documentation/filesystems/resctrl: Add footnote for telemetry fstab
    mount caveat

 Documentation/filesystems/resctrl.rst      |   7 +-
 include/linux/resctrl.h                    |  43 +-
 arch/x86/include/asm/resctrl.h             |  19 +-
 arch/x86/kernel/cpu/resctrl/internal.h     |  19 +-
 arch/x86/kernel/cpu/resctrl/core.c         |  77 +++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c    |  88 +++-
 arch/x86/kernel/cpu/resctrl/monitor.c      |  11 +-
 drivers/platform/x86/intel/pmt/telemetry.c |  13 +-
 drivers/resctrl/mpam_resctrl.c             |   9 +
 fs/resctrl/monitor.c                       |  59 ++-
 fs/resctrl/rdtgroup.c                      | 458 ++++++++++++---------
 arch/x86/Kconfig                           |  15 +-
 arch/x86/kernel/cpu/resctrl/Makefile       |   2 +-
 13 files changed, 531 insertions(+), 289 deletions(-)


base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
-- 
2.54.0

