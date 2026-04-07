Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43253AB275
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577747; cv=none; b=lKOsOMpprwiVrNFCyCu0Q7MpFu+KiZcrptkDjPmh1pLbLi1SKsc7R22G3g3DJXIbqpYg0ua2J98hgSd8+01GYpEF8wRO7pX4ZxU/j5Y3MDyIbMvNqD1yQyDcqOGw/GOiQPdo59x/Kjpqw2EU2nfhzqY0/uypoBTQOrFyv38cL18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577747; c=relaxed/simple;
	bh=EkhkDmw+ds9/eOTSV+LXXneT2S29y5By4Zed2fnWFrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VrwJaH52l0C5+LTU0GG2zi8aJp3+i2K0d+egC1y1BZVfnFnVqROFIsqJ2084EeWUzIIbYso27qjT2nOXxggDZ1MnpvzmCdid2bMLDDR1NkNPcA4urRd5GywbXX+pBMeP1nGL0xzNbPGdiuwYbDGjhUym/GNC2uV8dYEm1Gl2CYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b3W6Q4kq; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b3W6Q4kq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577741; x=1807113741;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EkhkDmw+ds9/eOTSV+LXXneT2S29y5By4Zed2fnWFrg=;
  b=b3W6Q4kqPf8AYSfR9LXyhXPXyEs4nBM8jRKAb90D6r6N47OBHzxQeL3n
   saw8QvUhg72YW6L7Yx4BOkK6h0nULbG00FjgUg5bxxZNS7PHjStApvTzs
   xNeFw3vBcLgrJgGPq5qQMbW6VFGCgu0kdEKjRpmn9ATxg4CxlNBPsWkMj
   AOjjy1ljlQV7zC6wkToxvWV9xpg7P83PhqyMrTzSrqjRdRBvqGHOXKUdS
   S2QGMLEQ/WdzyfiR1L0AVmFmDspXEsNX467RL++7fdk9jmMgNChRmXSjF
   /R7EZgZhNN3QuT6vaMCfqephrR9ajj8id3MqUVUChFcz8IB99Bxmpp0T5
   A==;
X-CSE-ConnectionGUID: /Wy7GTF4SrmjLBx2TrAyXw==
X-CSE-MsgGUID: d6ea9/qmTL6bV9a8B0ia1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432633"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432633"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
X-CSE-ConnectionGUID: yP78gzZnRM2J4hpKjfXIOA==
X-CSE-MsgGUID: zrRE+pCfTGOmvzlhKDDgLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119027"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
Subject: [PATCH v3 00/13] x86,fs/resctrl: Improve resctrl quality and consistency
Date: Tue,  7 Apr 2026 09:01:57 -0700
Message-ID: <cover.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

Reinette Chatre (13):
  MAINTAINERS: Update resctrl entry
  fs/resctrl: Add missing return value descriptions
  fs/resctrl: Avoid "may be used uninitialized" warning
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

 MAINTAINERS                        |   2 +
 arch/x86/kernel/cpu/resctrl/core.c |   4 +-
 fs/resctrl/ctrlmondata.c           |  70 +++++++++-------
 fs/resctrl/monitor.c               |  80 ++++++++++--------
 fs/resctrl/pseudo_lock.c           |   2 +-
 fs/resctrl/rdtgroup.c              | 126 ++++++++++++++++++-----------
 include/linux/resctrl.h            |  11 +--
 7 files changed, 180 insertions(+), 115 deletions(-)

-- 
2.50.1

