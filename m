Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E573F0762
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 03:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780457281; cv=none; b=E7gtiU5Et8AWbCFzkQhRJubE7iWvdGHBTAVXKURhC19Bl4+OvzpeHDZgRmfjLsjh4roJ6fIts955Y11v1d2bQd1F4xv/S3ZC8+SGdHFBGNW9uCJb9kwnZu3XuMgcgqIHeM0yEfyMp5sKwg+5/fRDtaGlGOrHzVv119Kqqb5p3lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780457281; c=relaxed/simple;
	bh=JP2ur9A6LiOPSafheMdfkuIvnoNhxLYGSX4vb8FkVCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mqObkJzSuIMZs0M3NWPBnj9ZA6c3Tdb1AorFqxLB3P6O+n51WdIoOByb80oX3c+y4a5cQf4hZYJcKTGwaVInfSRid0uoe1QSJEuoZ0/RLt9vac4+87mXvria+BeVGkMdjYpuiYoeubNYpiZciQ18gmHSICTVE7c8qU+POfxVK6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aEI1kUEU; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aEI1kUEU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780457279; x=1811993279;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JP2ur9A6LiOPSafheMdfkuIvnoNhxLYGSX4vb8FkVCg=;
  b=aEI1kUEUpcgvmlo9I4vN00Bye6BJ9Mg1EYYNzD2SMNZrME2Q/TATM/NM
   Mry3Ide8fX8HOa+pmbPLwwiS9XUVvlGpl+duZBQAG0Q2h4LJ+mg9OhKuo
   bj0lNBAbDVk2Is0yEvGHhGKbgIBpM2669ZfGkt8okT/ywXB8iYa7bXc1D
   hAdq5QR+YIlpJmHQL48jQM6imGDiyaYw3fYIGGY54XdJEpJXEai61qODQ
   albgXqVX85VDGOnOuCifs/jE+byVER1ZGaHNlrvSxtxePFe7dXkgFOiAw
   3MboOMO88FvgG3wYbIEHf6EO87sr5Wd1p9YpqkmkpjPVOWRIdcJ4FakQj
   w==;
X-CSE-ConnectionGUID: f96pG+R8TxCw2BVDQKwFBw==
X-CSE-MsgGUID: IkW3N5vfRHyxcIK6JieFwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="91938960"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="91938960"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:27:58 -0700
X-CSE-ConnectionGUID: hbQQk0sRS7ayuLsaMpya4w==
X-CSE-MsgGUID: HtUAyFGJTTmapRn2fQIivQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241110092"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:27:58 -0700
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
Subject: [PATCH v4 00/10] x86,fs/resctrl: Fix long-standing issues
Date: Tue,  2 Jun 2026 20:27:28 -0700
Message-ID: <cover.1780456704.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/
v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/

While reviewing the AET series [1] Sashiko reported a deadlock during mount,
and a use-after-free when an L3 domain is removed during CPU offline. More issues
were uncovered as fixes were developed and reviewed. While the goal is to
fix all issues the races surrounding pseudo-locked regions are not yet
solved and have been removed from this version of fixes.

Applies against tip/master to ensure it considers pending x86/cache changes.

Changes since V3:
- Drop majority of pseudo-locking fixes, only keep the double free/double
  list add fix.
- Add patch to help document safe RCU list traversal.
- See individual patches for detailed changes.

[1] https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com

Reinette Chatre (7):
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
 arch/x86/kernel/cpu/resctrl/monitor.c     |   2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |   4 +-
 fs/resctrl/ctrlmondata.c                  |  50 +-
 fs/resctrl/internal.h                     |   3 +-
 fs/resctrl/monitor.c                      | 123 ++--
 fs/resctrl/pseudo_lock.c                  |   2 +-
 fs/resctrl/rdtgroup.c                     | 859 ++++++++++++++--------
 10 files changed, 663 insertions(+), 407 deletions(-)

-- 
2.50.1

