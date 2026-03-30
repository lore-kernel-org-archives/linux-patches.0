Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68625313552
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907013; cv=none; b=CIeSRZE9HJGGlXMxgvzk7h/JeXBya0mZ3h/MrItKQYjRNIoBpLSPn1Ly+mOzUW0alUucoG7gC0uIg7pt4CoS5KbgkKFvXN+W0fWm4/n4odYHshVExgZjX8PhPSef4JdxLAlm1vgvqjukRWVsFS9L4vg3Ja+0d6h7Gth+thaDYtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907013; c=relaxed/simple;
	bh=s/yUdR/H5lI7XTDLFgcToJiS8o1SI0Whc5QUjSzcBBg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i1J/CUeT35lne0PXMHLCuYsSBgLwvtG0APIs0OtkNLjTWeyZthp0guz0puugP5EcuBLonl8fREpCEpcfpYB586kV5RABoErNTVZFHMRXDhrNsCLP1xz7xrQsRpDvh/OlmtArxZNARiY+mU1KmpQLGv1ylPKB7AYHVZK2BBUGEZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y+ysm/Mr; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y+ysm/Mr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774907012; x=1806443012;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s/yUdR/H5lI7XTDLFgcToJiS8o1SI0Whc5QUjSzcBBg=;
  b=Y+ysm/MrLYYgCa+u6EbMTJp4ECHYlF36466x5wu1kN+G7G1CzSH0aOM+
   2nE5GxYJoU51jT6DC8Y72VLkbYPRMOnk9S9bm9wYAkIXh+dPEvTxnlFGa
   j6HPpOklAixX8zdD7R4gnVKsYPYvd6FhybD+0YIxbL0TpplwchAGdNVC2
   Z9SFX3jG62c/zPQQN/wplpLTVkga1n4YiQRyCr30+RFVOE4pya6i2se/5
   z8HYtnZ5Puzu3FWr8ZxfUU8D5tMBn8dNn96JJmhag4tjDr2HxhQLLe6Le
   WzSG0LV4EKn4Km8F3AmRitlQjWhBjvN5jDPVvcTOlGyD78GZ4oQKNZ8UY
   Q==;
X-CSE-ConnectionGUID: 1yzmpaj5S+23N3r1dYaDBg==
X-CSE-MsgGUID: pMeLHIujRXeZg3cEXq//WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79772118"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79772118"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:31 -0700
X-CSE-ConnectionGUID: 6nAMTVmxRjyaj8kRIyASLQ==
X-CSE-MsgGUID: N4h0n7Z6SYGDf9/y69h1zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225185931"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:31 -0700
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
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 0/7] Allow AET to use PMT/TPMI as loadable modules
Date: Mon, 30 Mar 2026 14:43:15 -0700
Message-ID: <20260330214322.96686-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using symbol_request() eliminates the AET (Application Energy Telemetry)
requirement that INTEL_TELEMETY_PMT and INTEL_TPMI be configured as built-in
to the base kernel.

To make this work cleanly, refactor resctrl code so that architecture
code is made aware of every mount/unmount operation so that state can
be cleaned up on each unmount (instead of the notianal call from
resctrl_arch_exit()).

Signed-off-by: Tony Luck <tony.luck@intel.com>
AI-review-of-v3: https://sashiko.dev/#/patchset/20260327230208.18094-1-tony.luck%40intel.com

Changes since v3[1]
Link: [1] https://lore.kernel.org/all/20260327230208.18094-1-tony.luck@intel.com/

1) Switched from symbol_get() to symbol_request() so that required
modules will be auto-loaded when needed instead of mounting the resctrl
file system without AET events.

2) Add warnings to resctrl_{en,dis}able_mon_event() to ensure they are
only used when the resctrl file system is not mounted.

3) Move the newly adding locking around mount/unmount from architecture
to file system code. This makes it much simpler, avoiding obtaining a
mutex in one function and releasing in another.

4) Reset rdt_resource::mon_capable to false as part of cleanup on
unmount or for other mount failures. I have not updated rdt_mon_capable
which technically needs to be an integer, incremented on mount,
decremented on unmount to keep track of how many monitoring resources
are enabled in the current mount cycle.

Tony Luck (7):
  platform/x86/intel/pmt: Export PMT enumeration functions as GPL
  x86/resctrl: Drop setting of event_group::force_off when insufficient
    RMIDs
  fs/resctrl: Add interface to disable a monitor event
  fs,x86/resctrl: Add architecture hooks for every mount/unmount
  x86/resctrl: Resolve PMT and TPMI symbols at runtime
  x86/resctrl: Delete intel_aet_exit()
  x86/resctrl: Downgrade dependency of AET on INTEL_PMT

 include/linux/resctrl.h                    |  13 ++-
 arch/x86/kernel/cpu/resctrl/internal.h     |  10 +-
 arch/x86/kernel/cpu/resctrl/core.c         |  16 +++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 102 ++++++++++++++++++---
 drivers/platform/x86/intel/pmt/telemetry.c |   4 +-
 fs/resctrl/monitor.c                       |  16 ++++
 fs/resctrl/rdtgroup.c                      |  43 ++++++---
 arch/x86/Kconfig                           |   2 +-
 8 files changed, 172 insertions(+), 34 deletions(-)


base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
-- 
2.53.0

