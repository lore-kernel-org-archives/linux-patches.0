Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FD4288D0
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477189; cv=none; b=Poc0AWeYQN/JdYIVD8tUNzemApxKEM0UkOsDEo2QkwFctpCZq7cSrPgMzN98SfuqnGHlyE3UQIe7V2VdzojQmTx6UDeWnKtNFYW8qlbOxD2fKlRhMyNiHQoIiOLiBEs05vpKEtcVHpEhQP9SdOsgyejvVPXceVFCyKCVxwl8qZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477189; c=relaxed/simple;
	bh=OSu8IUWQWVNeLAe7zHYbaScIgdWCpnVgJ5f1AJGirxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fO9edzVBpleehk7SQW/w75ebX4yv5PJbU9a0oGDezTxkoMtvD5oerMJ3j/ubu15Vc024KwaBAM+4GML/rN/jYeihqUhFmcoSAC0bwu2YS1IoFWq6lP22vIOoEx8Xr/rwfjBz66ojND9aCy0nVObutdmA+2GRiZjSCFd1efiyyTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YK50DUds; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YK50DUds"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477187; x=1804013187;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OSu8IUWQWVNeLAe7zHYbaScIgdWCpnVgJ5f1AJGirxU=;
  b=YK50DUdssuvMeHVOL60xtQXA0mZySKS0Qcgz3DGNPSb/RRBG2emZ3OiR
   /M2GohOsKGD0cINr98suMtMW67ZBF4oT9NertWHVr0Od2B6wExrR/QGne
   f/rzWz3RWUiTyG0jOX/mqZ1ICFLg+Hlx+ai/YQUVAhlagtF6M6d8uYPBc
   dMrwBvtMwu1fEkVfQlX/DBs7VqtcZJA5ZztJu7xj4JQNc0lEQ60tB0gq3
   Q3vZrqATtMsAu7YgeSRDckgFLgdqg3ziqGucQW5gPes2ZefRouqbOx12X
   cHM3Sf+mSSkWfk7wHDEa/SftRy8T4HRj+/h6E4d6+7UhEMsEWOn7oyHwp
   Q==;
X-CSE-ConnectionGUID: OaJ/O8U4QQWmxYKxVyjuMw==
X-CSE-MsgGUID: xOJ3prFlS32oSzSiSwd6aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135417"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135417"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
X-CSE-ConnectionGUID: /KXGgAEyRge9JcWsfoHOEg==
X-CSE-MsgGUID: M13Mlu4aTpCJhY5XEsjLbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604074"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
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
Subject: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and consistency
Date: Mon,  2 Mar 2026 10:46:06 -0800
Message-ID: <cover.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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


Reinette Chatre (11):
  fs/resctrl: Add missing return value descriptions
  fs/resctrl: Avoid "may be used uninitialized" warning
  fs/resctrl: Use correct format specifier for printing error pointers
  x86/resctrl: Protect against bad shift
  fs/resctrl: Use accurate type for rdt_resource::rid
  fs/resctrl: Pass error reading event through to user space
  fs/resctrl: Add last_cmd_status support for writes to
    max_threshold_occupancy
  fs/resctrl: Use accurate and symmetric exit flows
  fs/resctrl: Use stricter checks on input to cpus/cpus_list file
  fs/resctrl: Change last_cmd_status custom during input parsing
  fs/resctrl: Communicate resource group deleted error via
    last_cmd_status

 arch/x86/kernel/cpu/resctrl/core.c |   4 +-
 fs/resctrl/ctrlmondata.c           |  70 +++++++++-------
 fs/resctrl/monitor.c               |  80 +++++++++++--------
 fs/resctrl/pseudo_lock.c           |   2 +-
 fs/resctrl/rdtgroup.c              | 124 ++++++++++++++++++-----------
 include/linux/resctrl.h            |   8 +-
 6 files changed, 173 insertions(+), 115 deletions(-)

-- 
2.50.1

