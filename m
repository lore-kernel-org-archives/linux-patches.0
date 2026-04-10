Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DD8382F27
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 20:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851541; cv=none; b=sWq8sMxilUVQwOBz6SB8sLYm+xnKduduso2pPIYoS6DpGYMq5bR+vu+KWlWrRHXLu1iXLbXuD8pkRu9zmDPZ5RlBPvPXpS23MhjYMqEPr85f9mQmjmfo0/Fzh0mki0vjWVpn5oJXH19UywcF/SyFNoWjNgaJqIuDiMuOQSAs1Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851541; c=relaxed/simple;
	bh=5cU9F5tKGmBMI3FGLw/JyEKm55TBNhUi/V3YRuRIX70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GHeW5Kg+7e7YI4+Ts3oEAOWkDpiwVvlrgDG2buRrlIUFnC67yD06BJScjLW99Rm/gI54fjR2Huhtvod1B+eTQaej89M4lDNDEgE3EDeK5sIBm40YstxdRG6GzForjFCZna3nLifOD4JGsYxS+aG77OWc1qGSgnBSqf/920f4lIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OIiF1baA; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OIiF1baA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775851540; x=1807387540;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5cU9F5tKGmBMI3FGLw/JyEKm55TBNhUi/V3YRuRIX70=;
  b=OIiF1baAgKoi7mPg5PdlhDUzoAqmnEF5rM0aMwPk32Sq+ZWjpJCAANDh
   OW+6aTPWe0zIDVI8hry8t8v4Ws+9F4DB3zN/qO/JZ2FmpPnzmQx2LArcP
   L+LbFyB3Q95T7OB5o44YQhq/5ZKSWO00ZDmmHBQXNzwG0TIPScPqf1YjU
   7odrgUbZDZJ2FYupQdq+xust2H0752HsDCJtamMz7qFv07KPIM1s9NtHA
   MjirXV8sF7dzQ+Vnmcn+yu7OTXbVdnJdJffK4tdbbzBpravkb/95j4qLx
   HLShuEjLY7Uvxq+wcQFU8FuzhLocoOEdW6aj/bOKbAkacVrVpGF9bvkep
   w==;
X-CSE-ConnectionGUID: GHd6eE+0SESlTvTWYIN8KA==
X-CSE-MsgGUID: hTr3fcK6SVa0jUFBzdVQpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76898053"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76898053"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:39 -0700
X-CSE-ConnectionGUID: o/H/YTFSQtOjjvOEHiAPXw==
X-CSE-MsgGUID: 8gVGsrgPT4GFXtREh+jZ0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="228154995"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:38 -0700
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
Subject: [RFC PATCH v5 0/7] Allow AET to use PMT/TPMI as loadable modules
Date: Fri, 10 Apr 2026 13:05:25 -0700
Message-ID: <20260410200532.58602-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Requiring INTEL_PMT_TELEMETRY=y to enable AET is a functional
workaround to enable enumeration of Application Energy Telemetry
(AET) events, but unacceptable to many users. It results in increased
kernel memory footprint and inability to patch problems by unloading
a module and loading an updated version.

Add a registration function to the AET code that can be used by
INTEL_PMT_TELEMETRY to provide the enumeration functions.

INTEL_PMT_TELEMETRY can be loaded/unloaded independently of
resctrl file system mount/unmount. Perform enumeration on
every mount and cleanup on every unmount.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Changes since v4:

Abandon use of symbol_request() - new uses are deprecated.
Implement the registration mechanism suggested by Christoph.
Re-order patches to avoid breaking AET enumeration.
Kerneldoc comments on limits to enable/disable events.
Add resctrl_mount_lock inline in rdt_get_tree() instead of adding a
wrapper.

Tony Luck (7):
  x86/resctrl: Stop setting event_group::force_off on RMID shortage
  fs/resctrl: Add interface to disable a monitor event
  x86/resctrl: x86/resctrl: Add PMT registration API for AET enumeration
    callbacks
  platform/x86/intel/pmt: Register enumeration functions with resctrl
  x86/resctrl: Resolve INTEL_PMT_TELEMETRY symbols at runtime
  fs/resctrl: Call architecture hooks for every mount/unmount
  x86/resctrl: Relax Kconfig dependency on INTEL_PMT_TELEMETRY

 include/linux/resctrl.h                    | 44 +++++++++++++-
 arch/x86/include/asm/resctrl.h             | 19 ++++++
 arch/x86/kernel/cpu/resctrl/internal.h     |  8 +--
 arch/x86/kernel/cpu/resctrl/core.c         | 23 +++++++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 67 ++++++++++++++++++----
 drivers/platform/x86/intel/pmt/telemetry.c | 10 ++++
 fs/resctrl/monitor.c                       | 12 ++++
 fs/resctrl/rdtgroup.c                      | 35 ++++++++---
 arch/x86/Kconfig                           |  2 +-
 9 files changed, 193 insertions(+), 27 deletions(-)


base-commit: 591cd656a1bf5ea94a222af5ef2ee76df029c1d2
-- 
2.53.0

