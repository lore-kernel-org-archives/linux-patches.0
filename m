Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1807D366823
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475210; cv=none; b=hoC2u1CNrE9V54nP/Tlho6fK+TXZK3XNXHeGbXKsnmQrNZbpFOMGzenHxM9CsxjAqzWyM8n8vfv3Ga1sYAGYl6JOWO1pxBrA0TaRodB0PjI9ArmVvLwgITDQW3BSvWU65l+8x0JaoOZ3wGWEke6blnNQUZgA2+2GEag1EVrgkGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475210; c=relaxed/simple;
	bh=ukZdy4LskUyR4XxWRuygLVikLJtQTwQF5S64WuW1iX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MDwY6eJlXq1+6J2DPxU2Qduob/gV0JDgcTbjw1pPq0V3fKAePmfVsVxlBHeXD8FIq9kjk0nvOUMTkcRcQsZEq89a4gZV4VYNlPq/oSBFYPPNrH03Iyoff95oYJiC+dlxU24jA7lP9Mzhs+0AF/fBIisoansvxhcbwJEUScubswk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jl2fL0ZY; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jl2fL0ZY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475210; x=1809011210;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ukZdy4LskUyR4XxWRuygLVikLJtQTwQF5S64WuW1iX0=;
  b=jl2fL0ZYDVr5VQz8mk9KnML9ey+BFvWf7RqBoERwYI3TY0b8X9Q+YxMi
   VWnTmf1Ll6nODZ9CMav767mAqtZU8gRMfBCXzAB71R4zXnF0SRYexNi9i
   /JXl7NBf77M1EtZ06QBz2exbG6n7ei5pAcLpQhdBOP1gJd8qKgNYUPJhR
   SVndFdx6i1bQflrAfzMmpeXah+s7n9RCKUzTRBL87GOWVEXbM61dqLMqq
   9qhFegj+SdTg1qeUrwEmbzeq6ca/L53esMo79uBvKSoVLT7sRfpyDceWu
   PZJR4IAzBNKHw4wDL2fdor/L1gP7WkmxnbEGUBHP7kB2Cj9Uez75cW0oL
   w==;
X-CSE-ConnectionGUID: e5ywyM3SSkqkGqkMRkoDYA==
X-CSE-MsgGUID: 5rekD/9/RNSBkAFk3XPBPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424320"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424320"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: /GSH8psgRVWyiuBuKsaAFg==
X-CSE-MsgGUID: VK2VbT5YTcyynZmRu6Yfow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233444997"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:46 -0700
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
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v4 00/10] x86,fs/resctrl: Improve resctrl quality and consistency
Date: Wed, 29 Apr 2026 08:06:30 -0700
Message-ID: <cover.1777419024.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v3:
- v3: https://lore.kernel.org/lkml/cover.1775576382.git.reinette.chatre@intel.com/
- Rebased on v7.1-rc1.
- Drop "MAINTAINERS: Update resctrl entry" and "fs/resctrl: Add missing return
  value descriptions" that can be found in v7.1-rc1.
- Drop "fs/resctrl: Avoid "may be used uninitialized" warning" that just does unnecessary
  work to appease compiler warning that is disabled by default. (Boris)
- Use pr_warn() instead of WARN_ON() in "x86/resctrl: Protect against bad
  shift".

Changes since v2:
- v2: https://lore.kernel.org/lkml/cover.1774043709.git.reinette.chatre@intel.com/
- Rebased on top of tip/master with pending resctrl selftest changes,
  https://lore.kernel.org/lkml/cover.1775266384.git.reinette.chatre@intel.com/,
  applied on top to support testing with latest kernel that has pending resctrl
  changes merged.
- Drop "fs/resctrl: Use stricter checks on input to cpus/cpus_list file"
  that ended up being too strict and removed one use case. (Chris)
- max_threshold_occ_write() switch to guard(). (Chenyu)
- Add more detail to one return value description.
- Add tags.
- No opinions so far on needing to update last_cmd_status on success of all read
  commands. At this time last_cmd_status will continue to return previous
  failure message (if any) after a read command accessing static data succeeds.

Changes since v1:
- v1: https://lore.kernel.org/lkml/cover.1772476561.git.reinette.chatre@intel.com/
- To simplify tracking, include patch to MAINTAINERS submitted separately:
  https://lore.kernel.org/lkml/4274c478922c01f9ceebc805acf991f10a95519f.1771442788.git.reinette.chatre@intel.com/
- Follow recent upstream changes to add reference to tip tree handbook in
  MAINTAINERS entry.
- Use new pattern in resctrl to enable looping over all entries of an enum
  while making adding new enum entries more clear all while avoiding warnings
  when compiling with -Wswitch. (Ben)
- Add another last_cmd_status enhancement that appends "[truncated]" to
  output of info/last_cmd_status if the backing buffer overflowed.
- Please see patch changelogs for details of changes.
- Add tags.

Hi Everybody,

This is a collection of resctrl cleanups assembled together for convenience
and simpler tracking. I'd be happy to split them up if it makes review and/or
handling easier.

Summary of changes:

- Let resctrl pass stricter checks from various tools to provide a cleaner
  baseline with the goal to promote healthier contributions:
  - ./tools/docs/kernel-doc -Wall -v <files>
  - Build with W=12
  - ./scripts/coccicheck
  - Static checkers

- Use accurate and consistent type for all uses of resource ID.

- In the unlikely scenario that resctrl picked a wrong CPU to read an event
  from, pass the error through to user space instead of claiming to succeed
  and returning a (wrong) result.

- Since inception of last_cmd_status feature there have been mismatches
  between resctrl file operation failures and the contents of
  info/last_cmd_status. This pattern keeps propagating with each new resctrl
  feature. Establish a new baseline with a new pattern that ensures
  info/last_cmd_status contains an accurate failure description that matches
  the most recent resctrl file operation failure.

One potential open:

There remains an inconsistency between resctrl file operations that do/can
_not_ fail and the contents of info/last_cmd_status. If a resctrl
file operation fails and an informational error is printed to last_cmd_status
then a subsequent reading of a resctrl file (specifically most of the files
found in info/) may succeed while info/last_cmd_status may or may not return
the error from previous failure.

Ensuring last_cmd_status is reset on every read carries the cost of taking
rdtgroup_mutex on several more user space initiated paths and thus increase
contention on rdtgroup_mutex. I opted to not make this change and instead
focus this work on ensuring that last_cmd_status is accurate whenever there is
a failure during any resctrl file operation. Please let me know if you have
opinions in this regard.

Any feedback is appreciated.

Regards,

Reinette

Reinette Chatre (10):
  fs/resctrl: Use correct format specifier for printing error pointers
  x86/resctrl: Protect against bad shift
  fs/resctrl: Change pattern used to track number of entries in enum
  fs/resctrl: Use accurate type for rdt_resource::rid
  fs/resctrl: Pass error reading event through to user space
  fs/resctrl: Add last_cmd_status support for writes to
    max_threshold_occupancy
  fs/resctrl: Use accurate and symmetric exit flows
  fs/resctrl: Change last_cmd_status custom during input parsing
  fs/resctrl: Communicate resource group deleted error via
    last_cmd_status
  fs/resctrl: Inform user space when status buffer overflowed

 arch/x86/kernel/cpu/resctrl/core.c |   6 +-
 fs/resctrl/ctrlmondata.c           |  70 ++++++++++-------
 fs/resctrl/monitor.c               |  78 +++++++++++--------
 fs/resctrl/rdtgroup.c              | 120 ++++++++++++++++++-----------
 include/linux/resctrl.h            |  11 +--
 5 files changed, 171 insertions(+), 114 deletions(-)

-- 
2.50.1

