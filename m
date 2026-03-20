Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CCC2ED846
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044235; cv=none; b=SqhtH7DArMYVe5AdwfIS2kO1SSgkN9JjkBEU4857XEiio8C2QXJb6G93hGnZD/cKKc+7zifdNjIdDqMlqKB3gMjc+T4MGdgcTB+SNIsDDhO7B4FJecVBWL3vkeRgeVcgYRdxPjV5//VJ7kWJf2OytdyE7xLbS/yueG7Sde6bFdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044235; c=relaxed/simple;
	bh=+e8kpRBt7Bz02RMHeF2deNwekfepP0rgAolx8zRW8aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZNTfvHQr7NZup5xjX6Kwoo/KoRK74Y+Ogbz0/L31/q/YtAn36WQ9OtSBF4j3jsjxPzsqND7reLxsdrnOwbqY1pIWvxMc4snx42fIBF+lpHeuVysQFh0gq4q0OXTkXLN8vt67EKvp9yo4mlrF9OHnGfJO/X/ebEgf33+tBORZZrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K9xJV4CN; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K9xJV4CN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044233; x=1805580233;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+e8kpRBt7Bz02RMHeF2deNwekfepP0rgAolx8zRW8aQ=;
  b=K9xJV4CNjm5UufRWo1rOGUkPH+CDEDnFMsIU8sSEnRRZMSQAMgpDqgXr
   mYb8MDyKo0ykaUJ3/a6Dc/CHi0THG4UDKbLpdckduCtlT5yif0HgvHeuC
   vTRWBVKt2oItuJw3G4xzYe9nv85aNIV8ras3lAv3MN0rQKbsyZFvRCAU4
   WGpnQRpGqBnwzyuLIDRxQyJt/9fYJ979KQy1kzWWF8tT5BiQjn1J9D9/j
   ULJk02JPgKt4H9CK1nEg7+TG/l1r/A7MhTV3SeZG/EMiVPgbDxHdLDyOr
   DUZK1xkfngvEaNA3vSAYkb6/dY346M88Xpd02XPhRT1+4PX2AhUwV317F
   A==;
X-CSE-ConnectionGUID: 6qavOzfrQ2SHSqpf5JUzYQ==
X-CSE-MsgGUID: p1eq15i2QvmqYhAFNHT1dA==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758324"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758324"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:53 -0700
X-CSE-ConnectionGUID: uVBQhpjKQrmOf3RTyGAIRA==
X-CSE-MsgGUID: lZT/e7olQFSD7F9j6DHogw==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:52 -0700
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
Subject: [PATCH v2 00/14] x86,fs/resctrl: Improve resctrl quality and consistency
Date: Fri, 20 Mar 2026 15:03:10 -0700
Message-ID: <cover.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

Reinette Chatre (14):
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
  fs/resctrl: Use stricter checks on input to cpus/cpus_list file
  fs/resctrl: Change last_cmd_status custom during input parsing
  fs/resctrl: Communicate resource group deleted error via
    last_cmd_status
  fs/resctrl: Inform user space when status buffer overflowed

 MAINTAINERS                        |   2 +
 arch/x86/kernel/cpu/resctrl/core.c |   4 +-
 fs/resctrl/ctrlmondata.c           |  70 +++++++++------
 fs/resctrl/monitor.c               |  80 ++++++++++-------
 fs/resctrl/pseudo_lock.c           |   2 +-
 fs/resctrl/rdtgroup.c              | 137 ++++++++++++++++++-----------
 include/linux/resctrl.h            |  11 +--
 7 files changed, 188 insertions(+), 118 deletions(-)

-- 
2.50.1

