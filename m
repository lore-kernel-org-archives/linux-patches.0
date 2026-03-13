Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EC4374E57
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 20:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433976; cv=none; b=hL88tfc7zkTRA+YgeRssFEq0K2LbCpbjtGRpO0ry34B6XGaqtqsH46ZezbpxyIybct21XPG9OoOME11cdAN91lnorZxI0fodJBWPz2BXzJXkbIUEdPJc6JtxQlZa/svLZMLsrDgDmShhqCAe4AsqjPm7tmAeBxQXOMoElWcE9cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433976; c=relaxed/simple;
	bh=xIWOR4Xe13E2Ir9yUvPwaa4rH35Gg6GEN0r+dx8HhZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YhUMVNa6qXc0OwVpEWt9b0/w2wG3baqyRcDY9W8fgZIQ9/ErYwiBjWrFIs3wvzEwKjMU/Rde9HEOMXG/KTwv+k2D6o3kHB2oGqsbMtMgWSapdUKI2kBX5hSpUod3ibUHL9sQaprD3qys4Hci5uMs3SUpY9pqL5j41gZ1RE8LTWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iAIXXdpD; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iAIXXdpD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773433972; x=1804969972;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xIWOR4Xe13E2Ir9yUvPwaa4rH35Gg6GEN0r+dx8HhZM=;
  b=iAIXXdpDDxj3bo5z4XOH+2s/hlqLwy/MegB/yRZSYle43dawvYNOBeQ3
   KWKHBkgDs6yBEOzWW1bBZLhsezzYWealeHMIu2/Yu3wgU5e7z6C67jyvj
   Z3MaLVP55xhGUWKCPlqcW17sTt/Vbcbzcaw8S7OEsjPmKRHXTqCb7i0hs
   lR00zCYQT7NOl8XqGIW8frvUu5MrtdI266Rox74HFzzAocHOh5q8Ib6Rw
   f/pKPPqUD/j/LspgWOsLBXHVIWOIWqPplf2PQ8D9rP2JJiE1zcbtwkW04
   RZDqiDZ1L4NYNLeOwjyqyDKwqcKxfZTt4lvEn+pE9BYTFFAqMNrNst9Vk
   g==;
X-CSE-ConnectionGUID: 99nkyhBiRDafeAyLbXatDw==
X-CSE-MsgGUID: 5SUAQJyQTYW6bZPPmKrfFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="74519238"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="74519238"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:51 -0700
X-CSE-ConnectionGUID: FHcCMGAkS2Wi88jJGtfFqw==
X-CSE-MsgGUID: ey/86xT6TpSwe6hIcxQlPA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:50 -0700
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
	jason.zeng@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 00/10] selftests/resctrl: Fixes and improvements focused on Intel platforms
Date: Fri, 13 Mar 2026 13:32:27 -0700
Message-ID: <cover.1773432891.git.reinette.chatre@intel.com>
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
- v2: https://lore.kernel.org/linux-patches/cover.1772582958.git.reinette.chatre@intel.com/
- Rebased on top of v7.0-rc3.
- Split "selftests/resctrl: Improve accuracy of cache occupancy test" into
  changes impacting L3 and L2 respectively. (Ilpo)
- "long_mask" -> "full_mask", "return_value" -> "measurement", "org_count"
  -> "orig_count". (Ilpo)
- Use PATH_MAX where appropriate. (Ilpo)
- Handle errors first to reduce indentation. (Ilpo)
- Detailed changes in changelogs.
- No functional changes since v2. Series tested by running 20 iterations of all
  tests on Emerald Rapids, Granite Rapids, Sapphire Rapids, Ice Lake, Sierra
  Forest, and Broadwell.

Changes since v1:
- v1: https://lore.kernel.org/lkml/cover.1770406608.git.reinette.chatre@intel.com/
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
  occupancy test": "the data my be in L2" -> "the data may be in L2"
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
This series demonstrates use of the new sysfs interface to perf
to obtain accurate iMC read memory bandwidth measurements.

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

Reinette Chatre (10):
  selftests/resctrl: Improve accuracy of cache occupancy test
  selftests/resctrl: Reduce interference from L2 occupancy during cache
    occupancy test
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

 tools/testing/selftests/resctrl/cache.c       |  30 ++--
 tools/testing/selftests/resctrl/cat_test.c    |  41 ++----
 tools/testing/selftests/resctrl/cmt_test.c    |  36 ++++-
 tools/testing/selftests/resctrl/fill_buf.c    |   4 +-
 tools/testing/selftests/resctrl/mba_test.c    |   6 +-
 tools/testing/selftests/resctrl/mbm_test.c    |   6 +-
 tools/testing/selftests/resctrl/resctrl.h     |  20 ++-
 tools/testing/selftests/resctrl/resctrl_val.c | 135 +++++++++++++-----
 8 files changed, 179 insertions(+), 99 deletions(-)

-- 
2.50.1

