Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199982;
	b=c5dGzIK6E4wZ9arLIKYxEdsFFImyHw6c39onjVWzl/A/pduG1P1niDxD9enOAEixCNV2
	 ePcLcbdyiqkoNzyFvIfUHBVvieSKsbWELi6hHHSM6A2sqzoNGjfYUjJQ1MxOsyQsRNejO
	 UMNihEPqM1eNMpTgfbK3CnJowkGCaM4DrJdqBdJB3KzXyoZtgUrYx1moPrdeYD0Z4H/By
	 44Cs2ON7d737orIoLfxZ/r51w3tfrb6Upt9EkyMZRJaYyt/MZ68LDEnBqWokGpoefPwVq
	 gvgsxetoO+MMM5H9j4d5vsaOPVmmnCrxQ+l8f0NDIrT1/qY4pUI0MiwgejD3Dr6r0NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199982;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ZhWYiKMz0I909x14S6WTsCN17CSOKetN9y0mlG9X2U8=;
	b=HZEvWgm6QnwsMC+SH0FzEqlS8R4cUflPn75k5jV7HHxnOw4Lv2RMrJ0Dj/u8e5TufaFH
	 MUmT0yFpPIKqyCtLOEvI0fW8iMUTVZHUrD7lvcDYCxAlHDk2tOgD592FFDez7rqzvwmPv
	 DIMDSZyBKfQES1bUD+Ul65CzCvlVd0tZb7locZKBiKVKc9GxqQCe1gRadlAbsPF1a/cfp
	 q9CbbTmYW/V9oMTQCT5KQIXFhc9SsLlALyhC3OjxuKU5LWxwa1IcSl7SowTHHSXsJn3W+
	 Sazx+FrCbBlERitHxQPDpXn9t8dfsMd8h+lqQaGsJDebAYgaoPUY8sBqNcg1XG+fEyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=X3W9HLwC;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F92860A2613
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 18:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F92860A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=X3W9HLwC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795199980; x=1826735980;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9YaEU0TvIY/OjSK1wIFdzU3b2/N0S3hNw7ve94G6eTo=;
  b=X3W9HLwCY6t7WeVTocYVDx47V5N3Gv5tMpdEeAWKHU6Rc4NjtQZfF8xr
   TTzxuFcp8ZtBhTZJ7xX79Yl6bVr85Jtdes9eK+Imbcf8Rmd6+6qPlTUcr
   Hpdj4BbNLvP5XUTbwFSACN240jEqGckw60FfqDyxszNnyzP7CYRuE4csi
   pYaa2pr0USFHs/AxFZ2mz+O0jbUgdtrwo04D1t42+gGeNF+SGry8kZE46
   r2Ub0RvtFG2pySY2sMM27TE5WiW8rAsQ9LItFdrTulMMyEjr4ZE8mI4Qc
   gCaCnU0y/WyCEj25SEoBUzY7+a8ZwgLDgZ0qp4nW4HK/MIATKFoV40pAc
   w==;
X-CSE-ConnectionGUID: dLJw0ua/Tv6OU1OMyMx5Ig==
X-CSE-MsgGUID: AAzGEEt2TzionDo2ATKFpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3931813"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3931813"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:39 -0800
X-CSE-ConnectionGUID: ggHYqvJLTjixJLp2B4jDTg==
X-CSE-MsgGUID: zm1wqfjKRE2iZobvEAfJKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12590711"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:39 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	tony.luck@intel.com,
	ben.horgan@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH 0/3] fork,arm,x86,fs/resctrl: Fix stale resource group assignment on fork
Date: Fri, 20 Nov 2026 10:39:29 -0800
Message-ID: <cover.1795197419.git.reinette.chatre@intel.com>
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

Hi Everybody,

Jedrzej reported that a newly created resource group can start out with tasks
in it, before any task has been assigned to it. He created the reproducer in
patch 3 to demonstrate this.

Hitting this needs a fork() to overlap the removal of the resource group the
forking task belongs to. A system that forks heavily while monitor groups are
created and removed around it will eventually do both at once.

Removing a resctrl resource group moves the group's tasks to another group by
walking the task list, and then frees the group's CLOSID and RMID. A task
created while that walk runs escapes it: fork() copies the parent's CLOSID
and RMID early in copy_process(), before the new task is linked onto the task
list, and the walk holds tasklist_lock for read so the new task cannot join
the list until the walk has finished.

The new task is thus left with the CLOSID and RMID of a resource group that no
longer exists, and passes them on to every task it creates.

Once the freed CLOSID and RMID are handed to a resource group created later the
strays appear in that group's tasks file, their memory accesses are counted in
its monitoring data, and they are subject to its allocation policy, while the
group intended for them does not control or monitor them.

Series layout
=============

Patch 1 depicts the race.

resctrl has no fork() hook today. Patch 1 adds one, resctrl_copy_process(),
called from copy_process() while tasklist_lock is held for write, which is the
lock the task list walk is serialized against. Considering klp_copy_process(),
this seems to match the custom used to address an issue with this shape.

  1   Add resctrl_copy_process() and assign a task's CLOSID and RMID
      with tasklist_lock held
  2   Record the new tasklist_lock requirement with lockdep
  3   Reproducer, not for inclusion

Why is this an RFC?
===================

- resctrl_copy_process() runs on every fork(), so
  resctrl_arch_copy_closid_rmid() is a static inline on x86 but is
  out-of-line for MPAM. The note below patch 1 describes what was
  attempted to make it inline for MPAM and asks the MPAM maintainers
  what shape it should take there.

- Patch 1 touches kernel/fork.c. It adds a single call inside the
  existing write_lock_irq(&tasklist_lock) region of copy_process(),
  immediately after klp_copy_process() on which it is modelled.

How was this tested?
====================
The issue can be reproduced using Jedrzej's script found in patch #3. On
my test system the issue is encountered on a single run. With these fixes
the reproducer did not encounter the issue in 100 runs.

What remains?
=============
On x86 the CLOSID and RMID are separate values in struct task_struct and
__resctrl_sched_in() reads them without a lock, so a task can still be
labelled with a mismatched pair for the duration of a move. Unlike the
fork case, which is permanent and invisible to every later walk of the
task list, that window is transient and the pair is corrected at the next
context switch. MPAM stores the two as a single value.

The series is based on v7.4-rc3.

Any feedback is appreciated.

Thank you.

Reinette

Jedrzej Wasiukiewicz (1):
  NOT_FOR_INCLUSION: selftests/resctrl: Tasks keep using removed RMID
    after fork() reproducer

Reinette Chatre (2):
  fork,arm,x86,fs/resctrl: Fix stale resource group assignment vs
    copy_process()
  arm,x86/resctrl: Assert tasklist_lock is held when setting CLOSID and
    RMID

 arch/arm64/include/asm/mpam.h                 |   6 +
 arch/x86/include/asm/resctrl.h                |  11 ++
 drivers/resctrl/mpam_resctrl.c                |   8 ++
 fs/resctrl/rdtgroup.c                         |  21 +++
 include/linux/arm_mpam.h                      |   1 +
 include/linux/resctrl.h                       |  28 ++++
 kernel/fork.c                                 |   3 +
 .../selftests/resctrl/stray_tasks_repro.sh    | 122 ++++++++++++++++++
 8 files changed, 200 insertions(+)
 create mode 100755 tools/testing/selftests/resctrl/stray_tasks_repro.sh


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.56.0

