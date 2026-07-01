Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2288B377555
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880041; cv=none; b=BTOlWg4QmSCQD8QMW5BdQ2jnWHtMgv/RiBQ0tPlr0LF31kluaoqUVBK4PhB7Us8gIx1oGLEoFzj37O34rnhMci+TkVm2BqejmXrRBR64Gqg9bcsTjAa1zvNOykI3wNp2xvzo8US6WVstCpfWN47Zy3Yk/CKULFwjBWVVmQQquc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880041; c=relaxed/simple;
	bh=P23gSM/KoJgVlYS9YKytumK7wqujVdgsF1RSWqimD2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ebIWS5APvWjdNZrWqEBi+2hmRgZc7RChQzjrnrZArxP4dWbHaX2MBwFQ9RsgK0xwNXhHlyL1/0Fe+iTIPfScPYwQDdG3mrzROdRtORvBF7IGSbDLuRoapq/JzIGcSMJ3eqwXsu47rdwUvgCdTOpGVDflRy0zkJu6dQbiA3iivYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TS3nJ8U5; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TS3nJ8U5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880038; x=1814416038;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P23gSM/KoJgVlYS9YKytumK7wqujVdgsF1RSWqimD2k=;
  b=TS3nJ8U5qcOscN5vUPEcw6FQ2Y7METk7VS6Xr11X6IFHp2rAxwTJht5a
   UzB9f+pfnAxID8Gj2p5vrz5LFXFFrF4nlEfA7lOvQHOc5dTaxEBHpoxIe
   Z8xw34zWHiCbJaqocgiZSQTn1sGR03g4vqAX74PPTh/tNuaL/q/cLPEyZ
   jnoTRQNVH8HrAlcD7w6iHSnHCiTJmWIeVQDgUWv3rAVDFlnSthNoSXrE1
   plSpHcmasPcUXT5P6Q1/pbnqzxz94TNQ6pUh520vsLNkrJhmKCyIq5VNI
   y7yK6bjKoym9Qmh24RqjLgtVyHmemx4Z2fho2Ylpmo8LsDGwpUoWLPFky
   A==;
X-CSE-ConnectionGUID: KC+Uk5VaRiyez/VKvS8DtA==
X-CSE-MsgGUID: NY61ckc8ThqBaeEz5rD0zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514228"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514228"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:17 -0700
X-CSE-ConnectionGUID: yvyKPLJXTvG5ihhtmaGpkQ==
X-CSE-MsgGUID: htHXauZgTX+HCeb/wNV7FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080548"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:16 -0700
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
Subject: [PATCH v5 00/10] x86,fs/resctrl: Improve resctrl quality and consistency
Date: Tue, 30 Jun 2026 21:27:00 -0700
Message-ID: <cover.1782857711.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Applies on top of v7.2-rc1 + v5 of "x86,fs/resctrl: Fix long-standing issues":
  https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/

Changes since v4:
- v4: https://lore.kernel.org/lkml/cover.1777419024.git.reinette.chatre@intel.com/
- Rebased on top of V5 "x86,fs/resctrl: Fix long-standing issues":
  https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/
  A significant change in that series is the addition of
  info_kn_lock()/info_kn_unlock() helpers to the info file handlers. With
  the addition of locking to the max_threshold_occ_write() in that series
  it seemed appropriate to re-order the last_cmd_status handling in
  max_threshold_occ_write() to be after the change to last_cmd_status
  custom to contain max_threshold_occ_write() changes to one patch.
- Add resctrl filename to new error messages to disambiguate the various
  "Invalid input" messages. (Tony)
- Add Tony's Reviewed-by tag to all patches.

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

Update v5: The addition of the info_kn_lock()/info_kn_unlock() helpers to
info file handlers now means that rdtgroup_mutex is held every time an info
file is opened. There is thus now less burden to reset last_cmd_status
buffer on each info file access. Even so, since there has not been any
opinions in this regard I opted to keep current behavior.

Any feedback is appreciated.

Regards,

Reinette

Reinette Chatre (10):
  fs/resctrl: Use correct format specifier for printing error pointers
  x86/resctrl: Protect against bad shift
  fs/resctrl: Change pattern used to track number of entries in enum
  fs/resctrl: Use accurate type for rdt_resource::rid
  fs/resctrl: Pass error reading event through to user space
  fs/resctrl: Use accurate and symmetric exit flows
  fs/resctrl: Change last_cmd_status custom during input parsing
  fs/resctrl: Add last_cmd_status support for writes to
    max_threshold_occupancy
  fs/resctrl: Communicate resource group deleted error via
    last_cmd_status
  fs/resctrl: Inform user space when status buffer overflowed

 arch/x86/kernel/cpu/resctrl/core.c |   6 +-
 fs/resctrl/ctrlmondata.c           |  71 ++++++++++-------
 fs/resctrl/monitor.c               |  78 ++++++++++--------
 fs/resctrl/rdtgroup.c              | 123 +++++++++++++++++------------
 include/linux/resctrl.h            |  11 +--
 5 files changed, 173 insertions(+), 116 deletions(-)

-- 
2.54.0

