Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EBF37E316
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 21:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407218; cv=none; b=eTBRYWrSgYClGCViOvMvKy1HOg/lnsrppzfDE2roN5E9VAGW40oag1gGIfDk4Y2Em1mq66CXeJtjY8HPeBWX5kIgTqFEIiX56uLGaTnM5p3+kdw47YWJqTYAFYOII8znROIIf7/R+s7Fy7w23gVNwLVwYJgsFWOqVlp5swXp0Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407218; c=relaxed/simple;
	bh=acQNsQP1/mlYA/WiorVXFJgqRz5WGMWwCBgs/Q9/p8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ddZoAoMppdf2DvH1jnpgiZZVCv//RwUKIYdvWhZsp7DawEyHw4mPNcP/8ezHGYT76TUzgSFJ1R7nhjd4uz4A3haCaQvp80NHiTiQyPz/fnICnWfQ8q/wLNvULNqsQBClCA+htCtOCSr02w17DSMCXUzyy+q8JFC09Zrrl3CK1lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L33rBIB5; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L33rBIB5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791407217; x=1822943217;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=acQNsQP1/mlYA/WiorVXFJgqRz5WGMWwCBgs/Q9/p8U=;
  b=L33rBIB5ozZycTaBp3lFs8/qbsoKMZcULyGSunfP0gls4AtmcwzJrK0F
   nV/Ee0wG7b8aXhoAWN7ceeUB5WcEvlulwHaNi/bJtHYoHVWshRu1+pMPS
   CGVeBSQu2Y2YxfWshAJdel6kShd0/uf5J2ih2esJRE8rr1M5mSogZcsw7
   98cQJM3i7cPPKmwBF1qIeBgHOBIvCWZplDe7lTrKM6CpPjPNpf2HENs1b
   b7zUG3UMtj1qVlx0eI+Yrjo6d/4yPemIsJ2g1M6FSeHB61ZYR0Be0qYEs
   B2p4qZFO0ZYyxB3MGzvC/6OufgaICzJwxhltj3idRB6dtcgpiy7Y9PO3t
   A==;
X-CSE-ConnectionGUID: o9+mdhX9Qp6ctqCQWPezLQ==
X-CSE-MsgGUID: qA5k0Bf3Qpe8dN2q5OsQIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="289380"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="289380"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:56 -0700
X-CSE-ConnectionGUID: l1EtfCSDRLmurTJjqzusyQ==
X-CSE-MsgGUID: lBvRxVUBTxqDk6Lpsguxkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="282359583"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:55 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v2 0/5] x86,fs/resctrl: Cleanups in preparation for multiple controls support
Date: Wed,  7 Oct 2026 14:06:42 -0700
Message-ID: <cover.1791406459.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
  - v1: https://lore.kernel.org/lkml/cover.1788452481.git.reinette.chatre@intel.com/
  - Rebase on x86/cache branch of tip with HEAD at:
      50e5282df427 ("x86,fs/resctrl: Add event group descriptions for Intel Diamond Rapids")
  - Rework all changelogs. Most now explain why each change is safe and why it
    is needed independent of the multiple controls work. (Ben)
  - Make subject lines more specific and fix the prefix of the patch removing
    the non-linear bandwidth delay mapping.
  - Keep the informational message printed when an Intel system with non-linear
    MBA delay values is encountered, rewording it and adding the missing
    newline. Match the related warning to the same wording. (Chenyu)
  - Group the memory bandwidth property assignments during Intel MBA enumeration.
  - Clarify in kernel-doc that the MSR_IA32_L{2,3}_QOS_CFG scope property only
    applies to cache resources.
  - Add Reviewed-by tags from Chenyu and Ben.

Hi Everybody,

For resource allocation resctrl assumes there is only one way to allocate
portions of a resource. That is, every resource supporting allocation has a
single control in the schemata file that user space can use to allocate
portions of that resource.

All architectures supported by resctrl already support, or will soon support,
multiple controls per resource. For example, the memory bandwidth resource may
have a "maximum bandwidth" as well as a "minimum bandwidth" control.

Adding support for multiple controls to resctrl is a major endeavour. The goals
are described in [1] and summarized in the Linux Plumbers Conference 2025
slides [2]. The implementation is in progress, with the most recent PoC
available at [3].

This series contains the preparatory cleanups from the PoC that are ready to be
merged independently of the remaining work:
- Remove the unused support for non-linear Intel MBA delay values, including a
  user space configuration check that can never fail.
- Make the scope of MSR_IA32_L{2,3}_QOS_CFG a private x86 property instead of
  a resctrl filesystem cache property.
- Drop an unnecessary helper and an unnecessary function parameter.

The only intended functional change is a reworded informational message
printed if an Intel system with non-linear MBA delay values is encountered.

Changes since previous postings can be found in the individual patches.

[1] https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/
[2] https://lpc.events/event/19/contributions/2093/attachments/1958/4172/resctrl%20Microconference%20LPC%202025%20Tokyo.pdf
[3] https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/

Reinette Chatre (5):
  x86,fs/resctrl: Remove unused non-linear bandwidth delay mapping
  x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check
  x86,fs/resctrl: Move MSR_IA32_L{2,3}_QOS_CFG scope property to x86 resource
  fs/resctrl: Drop unnecessary is_mba_linear() helper
  fs/resctrl: Drop unnecessary parameter from resctrl_io_alloc_parse_line()

 arch/x86/kernel/cpu/resctrl/core.c     | 72 ++++++++------------------
 arch/x86/kernel/cpu/resctrl/internal.h |  4 ++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  4 +-
 fs/resctrl/ctrlmondata.c               | 15 ++----
 fs/resctrl/rdtgroup.c                  |  7 +--
 include/linux/resctrl.h                |  7 ---
 6 files changed, 33 insertions(+), 76 deletions(-)


base-commit: 50e5282df427830fcd810e553f0e355d9cccb3e2
-- 
2.55.0

