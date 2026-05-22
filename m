Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523D53750BC
	for <patches@lists.linux.dev>; Fri, 22 May 2026 19:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477325; cv=none; b=OHBiZYHCCNmvBovdAj/To7ySKSxB71sLiMoWkpfJe2eTozT56vfW+8JZwZDywrYuLBmelgr83FE4V/31JwEK/IEtP6zW03hLa3LaOmvKY0E2Pyvkh6+d5MY7aL5NpP0Dl+0Pbyq5duMlyZc30YhyezDwksIb2NszB58XwQOEqrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477325; c=relaxed/simple;
	bh=DW1QDXXkiN6b9veK8efm6fcCivdbclf+X9OSUSnvhCY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EuSW9rO8sPKvFq4ibd24n+szJA+2skXJdOc6qW9mD4SBTUpAN7P+awR0UPuGv1ObK3TZp3RufhrJXtPO+w06bOOyOsN1QbaggchpnibgHNakAcEWUhKPYh0fjHHFQ+0lkPRTmfiaUd4yxuDDT+8lO/rDdyKW6j1W1Gf8JsbV++Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B8xknDvV; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B8xknDvV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779477324; x=1811013324;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DW1QDXXkiN6b9veK8efm6fcCivdbclf+X9OSUSnvhCY=;
  b=B8xknDvVon3EmC8STZXSTCiY2BjpXBqtHqU0RO8sW+ZIuS4afPUg5xW0
   SwLcexYLunfF77ZQ0R2iyD2iNxGGTlrBjbqYz+tD/cYefL0BOmPwCpv8S
   p/fBuU3hu3yVGB4tQgAAL42CTR/pkYRR0i0Vu2DPFDpDe86RC62nkI+xW
   cabDi/DQHg153eDyZVEU2NDElyITIei6riqpSYA0luHqVDu4Ctnz+flJR
   rLCRoOGqfxx8TK79kPmBRCs3FjyVXiX+UZtV4Z+pSYyWpBtDsRxntpdg/
   pB1wkgPgAOi8Euux9udJPyqTw8Wb3WCVuYX2ejX3a2pqMb/ndlg1PwwyE
   Q==;
X-CSE-ConnectionGUID: xzHV+0MPQTSo4iuwMREdcQ==
X-CSE-MsgGUID: nHQhfmNqSAm+y8XvjN0Hig==
X-IronPort-AV: E=McAfee;i="6800,10657,11794"; a="80140425"
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="80140425"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:23 -0700
X-CSE-ConnectionGUID: UbiZZcNHRHCEE4KNPGirRw==
X-CSE-MsgGUID: yuTnXdjWTP+BP6cWK5atRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="271336456"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:24 -0700
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
Subject: [PATCH v3 0/9] x86,fs/resctrl: Fix long-standing issues
Date: Fri, 22 May 2026 12:15:04 -0700
Message-ID: <cover.1779476724.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/

While reviewing the AET series [1] Sashiko reported a deadlock during mount,
and a use-after-free when an L3 domain is removed during CPU offline. Reinette
found a memory leak in the mount error path while refactoring code for a
solution to the mount hang.

During review of V1 of this series Sashiko found a new UAF on unmount issue
that was fixed in V2.

During review of V2 Sashiko uncovered a couple more new issues: TOCTOU
involving rdtgroup_kn_put() that may lead to UAF or double-free, double
free of pseudo-locked regions, potential deadlock between resctrl unmount and
info file readers. Sashiko also found that the CPU offline fix in V2 is flawed
in its use of is_percpu_thread().

Address all issues identified. This version is significantly different from V2
because of the additional fixes and reworking of the CPU offline fix. I do not
consider this version quite "polished" but after all changes made to address
all the issues identified by Sashiko I would like to check-in with folks (and
Sashiko) on where the fixes are headed and would appreciate any feedback.

Applies against tip/master to ensure it considers pending x86/cache changes.

[1] https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com

Reinette Chatre (6):
  fs/resctrl: Fix deadlock for errors during mount
  fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
  fs/resctrl: Fix pseudo-locking lifetime handling
  fs/resctrl: Prevent deadlock and use-after-free in info file handlers
  x86/resctrl: Ensure domain fully initialized before placed on RCU list
  fs/resctrl: Fix UAF from worker threads when domains are removed

Tony Luck (3):
  fs/resctrl: Move functions to avoid forward references in subsequent
    fixes
  fs/resctrl: Free mon_data structures on rdt_get_tree() failure
  fs/resctrl: Fix use-after-free during unmount

 arch/x86/kernel/cpu/resctrl/core.c      |  18 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |   5 +-
 fs/resctrl/ctrlmondata.c                |  38 +-
 fs/resctrl/internal.h                   |  15 +-
 fs/resctrl/monitor.c                    | 100 ++-
 fs/resctrl/pseudo_lock.c                |  44 +-
 fs/resctrl/rdtgroup.c                   | 847 +++++++++++++++---------
 7 files changed, 680 insertions(+), 387 deletions(-)

-- 
2.50.1

