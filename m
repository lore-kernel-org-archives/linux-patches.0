Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3330B40D574
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038972; cv=none; b=icCdipUyVKM5b9qhvrt5f/lEMvtiLRL9BRxD++q8tWy5ZvStwqlRbcRU85Os3q9oHcn1NFdB2AwWXQp+DSkroPrgx8v6Nu5bRm0mefvZ44DiEx/VZfL9wHnVVoLZggGnQeuMMJr5ceOvGNfb9UCNsUfMExDHJEDuvVbI26ar8c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038972; c=relaxed/simple;
	bh=yr3wUOmLRM1szI4050WBuMXfAinstpDgC0NOj7XulGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PmhM+RZXe/+i+E1y4OBMy4MFvVvYTq9xb1UCbcQDDLmnOtlrHvX7746GEZY2eWEIm6PN9XZXEQ6rJu/+xSJuVEVwQgTPx6ijJrY1/dDp22N/W0rKslxQxfiNJWIlPAvqlfheBY2jve7i05PZYWY1ZLwR4IMR2desQSYdbukXSvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kUxBqCje; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kUxBqCje"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781038971; x=1812574971;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yr3wUOmLRM1szI4050WBuMXfAinstpDgC0NOj7XulGc=;
  b=kUxBqCjeYP5IF4c5zpBHSHck9HaSqDZ9J7d7mPx6Hm+66uxG0oa/Z44m
   AEAtpacs2Pdknod8X8KIbM8c42H9T4dBP3oLMODZ6rI8JLfONwSJAdxgD
   JUB8WB29w+B07bw1+J/BgVYgMb1WEKLde2Tpb/AVvhc9qXEPQacOcS6YI
   s/V/NH1jQ8ssXzHrFr4ra3nKF5A4GOESzwR8tEk//qRE4Bgdp4zeXeiMO
   OfGMdU5WZo1O3sOBgbE2lY/4irdMIyPb1C6NEawAjJkrcrgpssWQ2SMEz
   gczcXGF8A+rSS9Cy2km7EHAG9ZWcSEYBQm6un6SRGRuraO/4AUpQ08nWv
   w==;
X-CSE-ConnectionGUID: zc6uQtiaRjap/0oRYHtnZQ==
X-CSE-MsgGUID: GfKaibVXSyKxyNf0nObt2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81725044"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81725044"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:50 -0700
X-CSE-ConnectionGUID: 48ag1mGTRbSvoSoUjh3wDw==
X-CSE-MsgGUID: GEo2BAsYSEucMuS03O4bDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="251045634"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:48 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
Date: Tue,  9 Jun 2026 14:02:26 -0700
Message-ID: <cover.1781029125.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4: https://lore.kernel.org/lkml/cover.1780456704.git.reinette.chatre@intel.com/
v3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/
v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/

While reviewing the AET series [1] Sashiko reported a deadlock during mount,
and a use-after-free when an L3 domain is removed during CPU offline. More issues
were uncovered as fixes were developed and reviewed. While the goal is to
fix all issues the races surrounding pseudo-locked regions are not yet
solved and have been removed from this series (last appearance was in V3 of
this series).

Applies against tip/master to ensure it considers pending x86/cache changes
as well as the lockdep_is_cpus_held() stubs available in smp/core.

Changes since V4:
- Add new fix to prevent out-of-bouds read when SNC is enabled and domain
  with busy RMID goes offline.
- Add substitute for "is domain going offline" check to workers to avoid
  reading any event counters on soon-to-be-offline domain since its
  cpu_mask is empty and reading an event counter on an SNC enabled system
  depends on knowing a CPU associated with the domain.

Changes since V3:
- Drop majority of pseudo-locking fixes, only keep the double free/double
  list add fix.
- Add patch to help document safe RCU list traversal.
- See individual patches for detailed changes.

[1] https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com

Reinette Chatre (8):
  x86,fs/resctrl: Prevent out-of-bounds access while offlining CPU when
    SNC enabled
  x86,fs/resctrl: Document safe RCU list traversal
  fs/resctrl: Fix deadlock on errors during mount
  fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
  fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
  fs/resctrl: Prevent deadlock and use-after-free in info file handlers
  x86/resctrl: Ensure domain fully initialized before placed on RCU list
  fs/resctrl: Fix UAF from worker threads when domains are removed

Tony Luck (3):
  fs/resctrl: Move functions to avoid forward references in subsequent
    fixes
  fs/resctrl: Free mon_data structures on rdt_get_tree() failure
  fs/resctrl: Fix use-after-free during unmount

 arch/x86/kernel/cpu/resctrl/core.c        |  18 +-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |   4 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c   |   5 +-
 arch/x86/kernel/cpu/resctrl/monitor.c     |   7 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |   4 +-
 fs/resctrl/ctrlmondata.c                  |  50 +-
 fs/resctrl/internal.h                     |   3 +-
 fs/resctrl/monitor.c                      | 170 +++--
 fs/resctrl/pseudo_lock.c                  |   2 +-
 fs/resctrl/rdtgroup.c                     | 859 ++++++++++++++--------
 10 files changed, 698 insertions(+), 424 deletions(-)

-- 
2.50.1

