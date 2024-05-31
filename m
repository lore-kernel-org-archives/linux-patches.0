Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8D017D343
	for <patches@lists.linux.dev>; Fri, 31 May 2024 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185457; cv=none; b=GjgsPv6kDVtus9m+FtUucr66RoATiJMlFeXQizwQ6nz7OuSFSUDvo3wHTwbD76XA/ca7q61IZuzz9fOgLelbAmUj2CFKry9Ic63A1IRG+g5fCji50orXFlHmJql2l11d/bQNBcD3HL/ykLkwI71RivTTfUkZ6a90MjhVFcTgqlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185457; c=relaxed/simple;
	bh=/lOtInnt6prvkKlLm8woy26AEwqxaaGOlQ+2tGdoA84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qVE6xX/+hPCHXYbP2OKcRliu554LrOztWRWlf+wmzyqB45x1TXC2522hRVRjKY6ZFpNtT8Az5a38ymMayzyODL7Fs6SUJ9FpOi/RQ5QM9W9F0igXCiz2zjd6+tNG6uTmrOPP/+9vt1Ez+fm09cMQEacuCZ9m2Hp1ke8kGETuFyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m8lSd+Vy; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m8lSd+Vy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717185456; x=1748721456;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/lOtInnt6prvkKlLm8woy26AEwqxaaGOlQ+2tGdoA84=;
  b=m8lSd+Vy2jAuc8tZdimL2j/1N3yr63xVdP9btHd44we4Mg3vQ7+34jE+
   ZWFD1MAfR591a+MzufWk2Gt1L9emgV2VG750Y9nT/H+Fb/U6IzT2mJsui
   /EyShW8Kydx2g79M3s4tRGFETyhr8zRG9vLk+tLwxPnoR5ZwiA9607AMi
   +/ZfVC4oslhCYuWFjbiKuVzs8FMmO9Lf2DFv6V6TRdo7abOSu1+30XL/K
   DaIzdgBoe/uvTXbXvaIJ8J4JXblXw6Y4M/j+17dL3gvapze2D3tdG7K+F
   XAk0mMk2RH1EPQg2lFMCKADPnFZwXcLYkTKT0TPqrzKGeOc7lIdcmvRYK
   A==;
X-CSE-ConnectionGUID: g6EMipNRRC2qKJmF4FRaYw==
X-CSE-MsgGUID: ole/oxMzRFulvD6B1NS3hw==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13501131"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13501131"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 12:57:32 -0700
X-CSE-ConnectionGUID: 9CQNwWH2SSebzbLyMWYUOw==
X-CSE-MsgGUID: 3hwgAf8STv+CgTeLHf44Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="59438867"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 12:57:32 -0700
From: Tony Luck <tony.luck@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 0/3] Add and use get_cpu_cacheinfo_level()
Date: Fri, 31 May 2024 12:57:17 -0700
Message-ID: <20240531195720.232561-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[get_maintainer.pl is vague about who owns <linux/cacheinfo.h>
 to I've scattershooted some of the folks that committed changes
 for this file]

This helper function came up in discussion of the resctrl patches
for Sub-NUMA Cluster (SNC) support. Reinette pointed out[1] that there
are already two places where it would clean things up by avoiding
open coding. The SNC patches will add two additional call sites.

So rather than have this jammed up as part of the SNC series, I'm
posting it as a simple standalone cleanup.

Signed-off-by: Tony Luck <tony.luck@intel.com>

[1] https://lore.kernel.org/all/050c64b3-20b3-4db6-b782-f5124ebaab31@intel.com/

Tony Luck (3):
  cacheinfo: Add function to get cacheinfo for a given (cpu, cachelevel)
  x86/resctrl: Replace open code cacheinfo search in
    pseudo_lock_region_init()
  x86/resctrl: Replace open code cacheinfo search in
    rdtgroup_cbm_to_size()

 include/linux/cacheinfo.h                 | 21 ++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 17 ++++++-----------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 14 +++++---------
 3 files changed, 27 insertions(+), 25 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.0

