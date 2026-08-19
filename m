Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59A1480954
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 16:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787156015; cv=none; b=Glh9xauj4mCP6hLDlIPUpBHJs5R3Swu0WM64DNvKsVw2Umyeksk8J/DscGtuCtsIzYhj8iKt4u2OsmJ6H5n2x+adHX3o/OYFRqhWsde8UczgE1wZK+Au4iQ7uTHCQY3Y+KBJUALW6/CpcHHf0oqc7vg1VDCc50jtXo1rNdMYFLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787156015; c=relaxed/simple;
	bh=l4+S1C/JpJppicRbegf1+szukTLOQgWyvNn7XZkUu8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SlomSzvWOVXa2OL6i8iayW6fVv4OzqbFRiL/h5qjMkCKGGNLEfP1bZBBvW3uLcX6576fX/XC50oipqNNyaDSc5OC+gliNWqIlxPPHJNKO5xFn278/RZIuSju23h97AGfAQh2UmkjJqi6aPmzBH9v48Mhbv+1BTnDUCk3MI+Virw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HoGzkK1j; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HoGzkK1j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787156013; x=1818692013;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l4+S1C/JpJppicRbegf1+szukTLOQgWyvNn7XZkUu8U=;
  b=HoGzkK1j0vZE8jgNrzez+Ac4vErNIHNgEyzS4sWkLPMSntw/DeAT5zlc
   0HS+6w/hAdIJRqePMhd2+aqu3nO7sQfNVuWXinRykaWPkTzlCLg6R62Ua
   5FutH23oDNLD+csngDo/j6HYR7jNqkdL9RtJ9Vstl+M850ds/nzr4FV44
   YnMEM6NGzZ1KA18RaOeXysjrHXfmcUmsbRbFSau4bJ3/US8IUPQ4DLHzZ
   AMLtxFsXucnw7idLyvdfIpj+GSEeeu2Ws/sJiBlBkl88xbbpkY+KGHdkC
   xX4D1XlBTRt3P8e/k2ovOOh8vORwcEm5g4Gm4g/Xt46AAnuEbPNXUJ1sU
   g==;
X-CSE-ConnectionGUID: wppKqowNQHePa/THFkAvoQ==
X-CSE-MsgGUID: FU3VqStUR4uuOSuxxEhvRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="87598040"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="87598040"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
X-CSE-ConnectionGUID: bvOe0F+KROeCwaSIXpH2yw==
X-CSE-MsgGUID: BhO3oQV6TOa9qMA+EI6s9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="290391837"
Received: from rodrigoa-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
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
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 0/4] x86/resctrl: Refactor resctrl enumeration
Date: Wed, 19 Aug 2026 09:13:18 -0700
Message-ID: <20260819161323.11587-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is posted as RFC to get some feedback before I incorporate
it into the next version of my patches to fix Kconfig issues[1]. It was
prompted by Reinette's comment[2]:

   "It looks to me that moving monitoring enumeration done in resctrl_cpu_detect()
    into resctrl proper where the RMID range checks can be centralized on features
    gated by rdt_cpu_has() would be simpler and accurate?"

Patch 1 adds a missing test that RDT monitoring is enabled in any form.
This test has been missing from the very start of Linux implementation.
I added a Fixes: tag abd it could be backported to stable and long term
kernels, but there might not be much value in doing so.

The remaining patches just relocate the enumeration from an early call on
the BSP, to the appropriate point in the normal "late_init" initialization
of resctrl. No functional changes intended in these patches.

Signed-off-by: Tony Luck <tony.luck@intel.com>

Link: https://lore.kernel.org/all/20260729172752.11561-1-tony.luck@intel.com/ [1]
Link: https://lore.kernel.org/all/f06e6b33-4d31-4174-80ab-8ebc51132fa4@intel.com/ [2]

Tony Luck (4):
  x86/resctrl: Check if monitoring features are enabled
  x86/resctrl: Enumerate monitor features in rdt_get_l3_mon_config()
  x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
  x86/resctrl: Delete resctrl_cpu_detect()

 arch/x86/include/asm/processor.h       |  4 --
 arch/x86/include/asm/resctrl.h         | 12 ++---
 arch/x86/kernel/cpu/resctrl/internal.h |  4 +-
 arch/x86/kernel/cpu/amd.c              |  3 --
 arch/x86/kernel/cpu/hygon.c            |  3 --
 arch/x86/kernel/cpu/intel.c            |  7 ---
 arch/x86/kernel/cpu/resctrl/core.c     | 47 ++----------------
 arch/x86/kernel/cpu/resctrl/monitor.c  | 67 +++++++++++++++++++-------
 8 files changed, 59 insertions(+), 88 deletions(-)


base-commit: bd5f485f3f026225b86573e559af0b7254ef4184
-- 
2.55.0

