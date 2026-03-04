Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC01255F2C
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 00:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583587; cv=none; b=mTVpMxwZUlr5TaaSeFUmMkTxjNqobuEUjqcnm5HXVk3FWF9suhzOfS2mfsgufKbAzL9YTgfOisKA4u4W2/pN/kSuZuM4GPa++rJqtELf6x1S0jeWBAzDJfYWSVcugRoFp68e2VOAjij1BF0lX5OLEkHrU1sHhL0LZINt5wE8j2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583587; c=relaxed/simple;
	bh=Nj/Jxt+UN+W7OM90f3ydgSAdEW3cXmj0uO+enNGrzNo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NN25UDqwSeTIVlGknfeNitwasAXQgg+9Ix3kYvyD292eNqcGZDqD2+/mrVwMMkQ03J+5L5+tZk1+UmM3AbiwItS3Lp1xBehi+zA6xWCy0cKnwtJyzETZKdMgDSCfCEui5tA+9G4bvBxCmyzyWfClXlaEjdmuX0axG4VxJttD5P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dHTNcNk1; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dHTNcNk1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772583585; x=1804119585;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nj/Jxt+UN+W7OM90f3ydgSAdEW3cXmj0uO+enNGrzNo=;
  b=dHTNcNk1Vqt+l4LBRQb21CvrRwPMApbyN9QkA+UEr85/nSJZA4oxObY7
   NBRV4B0tvX1igSp3oX7SrpqifsosP75azQM8mwGsysx7bQXHSLFWURXat
   ny9QYB2Ael6+qAaa6JDZtXY/IekeAooUZQexOgVEL3QW4HmqqoST6QlIc
   twm5KvB+7EZRbAzhq/iENALLinoxI4omYac7JMPCh6eUnQwcQZEta+ur7
   khW/QE0a94Iv6+BQvdOLZLedOLYiy288vjioxDvS/Det9xMHhiqykbRvF
   bHPACpLo0Bi124qZbppwLBwmhMNHcJLh9rHr+QFPGs2ez3zZsqOHWSnOs
   Q==;
X-CSE-ConnectionGUID: 57XeXS21Q5mjk3hvMkkeuA==
X-CSE-MsgGUID: 9FGmXI3kQfaacMLwuepTWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73544989"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73544989"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:44 -0800
X-CSE-ConnectionGUID: YzSeqomwT2+lWnzOIfWxXw==
X-CSE-MsgGUID: Dat+9dNnQ/Ouf87MPD1Uzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218120382"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:44 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	ben.horgan@arm.com,
	yu.c.chen@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 0/9] selftests/resctrl: Fixes and improvements focused on Intel platforms
Date: Tue,  3 Mar 2026 16:19:29 -0800
Message-ID: <cover.1772582958.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
- The new perf interface that resctrl selftests can utilize has been accepted and
  merged into v7.0-rc2. This series can thus now be considered for inclusion.
  For reference,
  commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
  The resctrl selftest changes making use of the new perf interface are backward
  compatible. The selftests do not require a v7.0-rc2 kernel to run but the
  tests can only pass on recent Intel platforms running v7.0-rc2 or later.
- Combine the two outstanding resctrl selftest submissions into one series
  for easier tracking:
  https://lore.kernel.org/lkml/084e82b5c29d75f16f24af8768d50d39ba0118a5.1769101788.git.reinette.chatre@intel.com/
  https://lore.kernel.org/lkml/cover.1770406608.git.reinette.chatre@intel.com/
- Fix typo in changelog of "selftests/resctrl: Improve accuracy of cache
  occupancy test": "the data my be in L2" -> "the data my be in L2"
- Add Zide Chen's RB tags.

Cover letter updated to be accurate wrt perf changes:

The resctrl selftests fail on recent Intel platforms. Intermittent failures
in the CAT test and permanent failures of MBM and MBA tests on new platforms
like Sierra Forest and Granite Rapids.

The MBM and MBA resctrl selftests both generate memory traffic and compare the
memory bandwidth measurements between the iMC PMUs and MBM to determine pass or
fail. Both these tests are failing on recent platforms like Sierra Forest and
Granite Rapids that have two events that need to be read and combined
for a total memory bandwidth count instead of the single event available on
earlier platforms.

resctrl selftests prefer to obtain event details via sysfs instead of adding
model specific details on which events to read. Enhancements to perf to expose
the new event details are available since:
 commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
This series demonstrates use of the new sysfs interface to perf to
obtain to obtain accurate iMC read memory bandwidth measurements.

An additional issue with all the tests is that these selftests are part
performance tests and determine pass/fail on performance heuristics selected
after running the tests on a variety of platforms. When new platforms
arrive the previous heuristics may cause the tests to fail. These failures are
not because of an issue with the resctrl subsystem the tests intend to test
but because of the architectural changes in the new platforms.

Adapt the resctrl tests to not be as sensitive to architectural changes
while adjusting the remaining heuristics to ensure tests pass on a variety
of platforms. More details in individual patches.

Tested by running 100 iterations of all tests on Emerald Rapids, Granite
Rapids, Sapphire Rapids, Ice Lake, Sierra Forest, and Broadwell.

Reinette Chatre (9):
  selftests/resctrl: Improve accuracy of cache occupancy test
  selftests/resctrl: Do not store iMC counter value in counter config
    structure
  selftests/resctrl: Prepare for parsing multiple events per iMC
  selftests/resctrl: Support multiple events associated with iMC
  selftests/resctrl: Increase size of buffer used in MBM and MBA tests
  selftests/resctrl: Raise threshold at which MBM and PMU values are
    compared
  selftests/resctrl: Remove requirement on cache miss rate
  selftests/resctrl: Simplify perf usage in CAT test
  selftests/resctrl: Reduce L2 impact on CAT test

 tools/testing/selftests/resctrl/cache.c       |  17 +--
 tools/testing/selftests/resctrl/cat_test.c    |  43 ++----
 tools/testing/selftests/resctrl/cmt_test.c    |  35 ++++-
 tools/testing/selftests/resctrl/fill_buf.c    |   4 +-
 tools/testing/selftests/resctrl/mba_test.c    |   6 +-
 tools/testing/selftests/resctrl/mbm_test.c    |   6 +-
 tools/testing/selftests/resctrl/resctrl.h     |  17 +--
 tools/testing/selftests/resctrl/resctrl_val.c | 131 +++++++++++++-----
 8 files changed, 162 insertions(+), 97 deletions(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.50.1

