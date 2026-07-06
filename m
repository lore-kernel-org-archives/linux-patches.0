Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8D1364024
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 22:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378002; cv=none; b=Oyw/aaRRU8mQLNVKX3qiL6YywGz8gKQEmLgBHbCpCipuswNc71/N86R+wCFe+eSPJ6lK5YvHydEcdwhEI1GR2jnllsLEyTz/4GbmEF+z/0HyMh8/EtFz9PU+/86lPOhtZCAk85SRSiRi/zQLKIULSiFevJiU2KRzcD6xRa56JNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378002; c=relaxed/simple;
	bh=FhG0GoHgZ9YRXECERguuLdBhavrWZhd2iWkf44z1rv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qngxN02CRfZEtrG0YJQzL2xKH2tCSuBsFpmyzGdEcmGFoTriy98x7gFP3JHJlmbxcTZXW5n338LSG06GwbRuG74lY89yYCmGuEBH+PRskd0jsEXCbBCe4qbCwwmo+HKASaW8j0tGl3WFpx8lk2AG2LdHs0Xr6qA7WS5AB+74SHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RbbCgMmS; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RbbCgMmS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783377999; x=1814913999;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FhG0GoHgZ9YRXECERguuLdBhavrWZhd2iWkf44z1rv4=;
  b=RbbCgMmSSL6P4nocoEOfHMBIRaNzwwAct5k6Y+ejBaRX+c7A+wckmH+9
   +nIVve5BlfNPap0clXklVoR/6RuUULlNG/7G1a30g9b/aV1UTL9yEobOq
   KSOsdAkSWyTATkfsi5EHyrxXDTcYdUggHSgtXrVobLQAAPrzniyC1Tulh
   PRrjeN1RapWRCJuqp+ABtVxKhnQb0u7DYzjxLtgR50U8aotqoTIiT+RRd
   u2LivPPKbC7QwnxZbYr1gh57BZ3UyCKxWY3I3NmpDMgwvxqoJZC6IHv8i
   EZSQFZOv0OTOUIIRhBoDnZkJKRMcRm8HkeIFqnRck4nFl5blyAEM8ZtzN
   g==;
X-CSE-ConnectionGUID: oOCHiFk7TZq/SQJUQ8zuxg==
X-CSE-MsgGUID: 4AHqrYu/Q2aokkwY2E+J6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="95401461"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="95401461"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:38 -0700
X-CSE-ConnectionGUID: 0gdh/c2KRbe4bMSBF2GFtA==
X-CSE-MsgGUID: wIOu4QSlS3qMaPX6mF+amw==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:38 -0700
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
Subject: [PATCH v6 00/10] x86,fs/resctrl: Fix long-standing issues
Date: Mon,  6 Jul 2026 15:46:20 -0700
Message-ID: <cover.1783377598.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Applies against v7.2-rc2.

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

Reinette Chatre (7):
  fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
  x86,fs/resctrl: Document safe RCU list traversal
  fs/resctrl: Fix deadlock on errors during mount
  fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
  fs/resctrl: Prevent deadlock and use-after-free in info file handlers
  x86/resctrl: Ensure domain fully initialized before placed on RCU list
  fs/resctrl: Fix UAF from worker threads when domains are removed

Tony Luck (3):
  fs/resctrl: Free mon_data structures on rdt_get_tree() failure
  fs/resctrl: Fix use-after-free during unmount
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
 fs/resctrl/rdtgroup.c                     | 859 ++++++++++++++--------
 10 files changed, 671 insertions(+), 407 deletions(-)

-- 
2.54.0

