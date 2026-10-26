Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051849;
	b=rKPgPWOJBlBDkSbggz2trMvwBi/8KvMU0ksGOHRnzgojRGkNTdkW5D9czu/+AP8YOgHq
	 qOOSvB6/K+zEw/ZrvYhNWSbmcm/D0I85coVWA2zTW3YpcdisL4YmNofdrC0AnMODM7iNC
	 Ejn3xLIGumB8CdI5Yfqj5neR57RUAjZ0be1FGlMvwtDV41KeKrmCd9FmXC8oqJAaC3xYu
	 /sE834eYDzpTuBSIe0zJsR4Gj6KF0KhoMTVs5nlVCycFouu4UClA7cUYRLnZF/NsZUeNB
	 2CtXCH+jNvMFMxn/rhejItDDepmRVgN55+SsH8FjM9HFSlV054tSfe2fXZdqpJv3JTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051849;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Qhp/nkpQ1Q3HJSdVCGfGyekUyvb9X60zla/5aSM/RFs=;
	b=LWT8HUHW9saTuG0aB9lv1n9eV0oXb2VxKL3D+C5Tud3XBra2MdvmYoDwh+Tr85s4VoTe
	 oFWNPRA+P9XgA4NEuE3UOfDsGRtzTh+5evIYrxkbRoHfpiKS+H9/GRihqqyY4d/6FJSIR
	 yeoz7tGqj6y8R/Hzo3QxNC4xEl6xQ6sALZ2aAs4nWRTGJHK0caGKp3poMGBmNOZSj30v+
	 rficjOLxKQ30YaCgpe+SDpMqeia4fQtRScaL8sxYX9UXHW9F0w/pSp3ntags7uEH4e2GJ
	 Zf0EhN8j6yKQik1yrPI2HUc547JqItGGDO58LkAqyjC565gdm3lv4Y9gntB9c91Mxww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hzxGvY8e;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C8C606A31A
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 21:57:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1C8C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hzxGvY8e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793051848; x=1824587848;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2qwtJaiiI84xJ/KSWgXPR7UL6dofZdZ3+rk8+2JOi00=;
  b=hzxGvY8eZBQaAIl8xlwA6iUHUpuoK5qVGwclasBUCPwF9bVzLvo4JZ8Q
   REVlyniNyzQPFJrdMr7Cpcf3p7CTmK9pjsiemgxb9UG8/jYcjEnqJCvy1
   /VDRHpoUb5wsGgGQjat5BgN1zus1dp3BKhb4OtuM7EcImCq1mSpGYka6x
   LJI685kxAaagjOmxq/r4iHxqAHKmAp3SujGKVSvn/YDL+u5gNL3YAjE5G
   Ep9GnnKigSG484P/zX5wE5m+SLVURt5dPgR/++PRFdFEnxvjDqcqHyzxr
   snyhTCpRIHqpv6imJKz7KySA/ReNEVawBryGDlWSIJ+MdJs5q+W4Vi3zM
   Q==;
X-CSE-ConnectionGUID: Kgbse02HT0udk7eJRZ92tQ==
X-CSE-MsgGUID: nHT9bAeySXKMScy8tuGIDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1766367"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1766367"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:27 -0700
X-CSE-ConnectionGUID: jSyw9k44RwWcxdBF7UH5KA==
X-CSE-MsgGUID: Fl9ujGVDQoCDaIFTh0intw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4240248"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.204])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 0/8] arm,x86,fs/resctrl: Support asymmetric L2 cache allocation
Date: Mon, 26 Oct 2026 14:57:10 -0700
Message-ID: <20261026215718.16810-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RFC patch series built on top of Reinette's multiple control series[1]

The goal is to support L2 cache allocation on hybrid Intel CPUs such as
Panther Lake[2] where the P-core and E-core CPUs have different number
of supported bits for L2 cache bit mask controls. N.B. it is assumned
that the only point of asymmetry is the cache bit mask length. Other
parameters must be the same (but code doesn't check).

Overall approach is to add the per-L2 cache bitmask length to the domain
and use that everywhere instead of using a single value from the control.

Patch 1 changes the format of the per-control "max" file and should be
merged back into Reinette's multi-control series so this file can have
a consistent format from first upstream introduction.

Patches 2-5 are enumeration and preperation.

Patch 6 introduces, initializes, and uses the per-domain cache bit mask
length field (arm/MPAM change needs careful scrutiny).

Patch 7 enables asymmetric L2 for x86 CPUs that enumerate it. N.B. it
renammes the resource from "L2" to "L2A" to avoid user interface issues
with tools that expect L2 cache allocation to be symmetric.

Patch 8 suppresses creation of the "cbm_mask" file for asymmetric caches.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/reinette/linux.git resctrl/controls_rfc_v2.4
[2] Typical desktop/laptop CPUs do not enumerate RDT L2 cache allocation. 
    This feature is found on SKUs intended for industrial applications.

Tony Luck (8):
  fs/resctrl: Change UI of "max" file (merge back into earlier patches)
  x86/resctrl: Add L2CAT quirk for Intel Panther Lake
  x86/cpuid: Add and use defines for Intel RDT enumeration leaves
  x86/resctrl: Add X86_FEATURE bits for asymmetric L2
  x86/resctrl: Refactor rdt_get_cache_alloc_cfg()
  arm,x86,fs/resctrl: Prepare for asymmetric caches
  x86/resctrl: Check for and enable asymmetric L2 cache allocation
  fs/resctrl: Suppress creation of cbm_mask info file on asymmetric
    systems

 Documentation/filesystems/resctrl.rst  |  9 +++-
 include/linux/resctrl.h                | 12 ++++-
 arch/x86/include/asm/cpufeatures.h     |  3 ++
 arch/x86/include/asm/cpuid/types.h     |  4 ++
 fs/resctrl/internal.h                  |  2 +
 arch/x86/kernel/cpu/cpuid-deps.c       |  2 +
 arch/x86/kernel/cpu/resctrl/core.c     | 64 +++++++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  2 +-
 arch/x86/kernel/cpu/scattered.c        |  3 ++
 drivers/resctrl/mpam_resctrl.c         | 19 +++++---
 fs/resctrl/ctrlmondata.c               |  9 ++--
 fs/resctrl/pseudo_lock.c               |  2 +-
 fs/resctrl/rdtgroup.c                  | 61 +++++++++++++++---------
 13 files changed, 145 insertions(+), 47 deletions(-)

-- 
2.56.0

