Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17FD233927
	for <patches@lists.linux.dev>; Mon, 13 Jul 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783964429; cv=none; b=X3bSkRwztCh+fi1u4XC6FakK8yCL8oOs4AYm2hVkSpnELUPU3D0tQdqoZRR4Te2nv5svl7lAQvGbhl9ZktmO7UoT5uUzWB7q5iWKBCqeiT+hQUt8TxzBZUgdONJ1uw/nD07WCgD0ihIy9PuYOJ6QSx+pUwm2tgP+are7yy3uaM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783964429; c=relaxed/simple;
	bh=i9IGYdXD9+8Mkw0M1G7DOHF8yR31gRFkEmMO+ijz5qU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BYshjS6Uwog/k9Yx1IUx5wGTpx1urwVqQsPB/sRAQpWGlhXr0NSaFplzelE3mewFGOpGJps9e1jYGa0a3L+9D5Z18tVToqbQBB9bIh6x1/vW7knDeiNZm5MIQD4ig2+09uFOlwF/GWJg6ANQPNRqIpgF9y5cfF+qikR/FPeKGEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J9Ika+kO; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J9Ika+kO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783964428; x=1815500428;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i9IGYdXD9+8Mkw0M1G7DOHF8yR31gRFkEmMO+ijz5qU=;
  b=J9Ika+kOxVWCNas3dno/Ng+UjnXUNOnwj1Bb98JmxYLrqh0alrGRMIq+
   W9VrQRpZ+fWAL+Chj49VQ7t1Ma1zwch71mZc9QBJcm4tkt/2hPxk2aj9P
   CJVIcdAT7DE5Q6pHj5/5UaoI088mdBAOQlzFBl1G9xlW960tN8KpBcFVk
   LhZPbEsl/5HA/M9i1EaMtKz/ge/4XMG2/cydsEsIOCc98O6YTMk6BoPYI
   kGM3XwdHfMDfYecoaLqrsM7qQ1tS7ZJ8RuWjaZ2YdYesm74Cl0Qd1Y5ah
   Q+AQDrGYCyWXyfXMVSUJisKbKg2QznS8SeXQN751FcnoPRzA8EeGwrgWD
   Q==;
X-CSE-ConnectionGUID: aBCEJHpLQEukOvJhMaWhkw==
X-CSE-MsgGUID: 3EZwaWJ/RvaZPZij4liP0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="107375508"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="107375508"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:26 -0700
X-CSE-ConnectionGUID: GYqX4Dd3RN6O5zRydjVEYQ==
X-CSE-MsgGUID: kdMlBbklQwujj8GXcXLpiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254483876"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:25 -0700
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
Subject: [PATCH v7 0/7] x86,fs/resctrl: Fix long-standing issues
Date: Mon, 13 Jul 2026 10:39:36 -0700
Message-ID: <cover.1783963505.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v6: https://lore.kernel.org/lkml/cover.1783377598.git.reinette.chatre@intel.com/
v5: https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/
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

Applies against v7.2-rc3.

Changes since V6:
- Drop first three patches that are in v7.2-rc3.
- Remove extra blank lines. (Tony)
- No functional changes.

Changes since V5:
- Drop patch #1 (x86,fs/resctrl: Prevent out-of-bounds access while offlining
  CPU when SNC enabled) that can be found in v7.2-rc2.
- Re-order remaining patches so that stable candidate patches are at
  beginning of series. The stable candidates are:
  Patch 1: fs/resctrl: Free mon_data structures on rdt_get_tree() failure
  Patch 2: fs/resctrl: Fix use-after-free during unmount
  Patch 3: fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
- To support the backporting to stable patch #1 adds a forward declaration
  that is removed in patch #5 that moves the actual functions to avoid too many
  forward declarations.
- The end result of changes since v5: v6 net changes are identical to V5
  changes.

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

Reinette Chatre (6):
  x86,fs/resctrl: Document safe RCU list traversal
  fs/resctrl: Fix deadlock on errors during mount
  fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
  fs/resctrl: Prevent deadlock and use-after-free in info file handlers
  x86/resctrl: Ensure domain fully initialized before placed on RCU list
  fs/resctrl: Fix UAF from worker threads when domains are removed

Tony Luck (1):
  fs/resctrl: Move functions to avoid forward references in subsequent
    fixes

 arch/x86/kernel/cpu/resctrl/core.c        |  18 +-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |   4 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c   |   5 +-
 arch/x86/kernel/cpu/resctrl/monitor.c     |   2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |   4 +-
 fs/resctrl/ctrlmondata.c                  |  50 +-
 fs/resctrl/internal.h                     |   3 +-
 fs/resctrl/monitor.c                      | 131 ++--
 fs/resctrl/pseudo_lock.c                  |   2 +-
 fs/resctrl/rdtgroup.c                     | 858 +++++++++++++---------
 10 files changed, 660 insertions(+), 417 deletions(-)


base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.54.0

