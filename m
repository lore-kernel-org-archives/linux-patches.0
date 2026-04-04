Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5B42BD0B
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 01:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267806; cv=none; b=VGau2mFwDRGXIrz+Rxr1Ppjp/omLxruD9zbDBtlTh9XJOr0f3xqu30tm19ihnBxxZkP6F+yjkeINu/AavVJ08Eg2+yCHmnDOJxAX23qth4XBdnUDGnc8+q5ZU11kIOVd0c1hB+WCdZxOD4fe9J4i/CEokXidw03TMPrif/8tTWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267806; c=relaxed/simple;
	bh=SnVEYvcFy8oSbkOvmYPPrajsMz1D7zXAXpxq9nblfG8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UkjuM42oQZT9pVZXx8wk25L3iF25nW0oPm7y5bcLDjCntr2ofXvHQkumQO/mkkl/HhRpikgeSpgph8D24EJqhqdqVRLKrBECj5OKDib3nh94JO34RRQbCMagAF2tsL/cr1bobFhznHURhZnm3VznH5jrxa9BztK6YRrwi6tmTaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l9GaO8C5; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l9GaO8C5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775267804; x=1806803804;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SnVEYvcFy8oSbkOvmYPPrajsMz1D7zXAXpxq9nblfG8=;
  b=l9GaO8C5/UaNcrwPaFPUYHU2WvXZcSfsCSPuueMytgy9ufUXRFVtdMES
   Kxh7BoKKhDNnoIBKbaBfKr/f6p0zlm/8pgW+9WYQXG8XeHDx0roGRfKco
   +n0njMoll21hfDGH0C8nyLKmnhUFRgJQBPBozr0nG6wfg417TQ/Cny2Q1
   NKCCzztzsAZrXNFIEs5pALQUweU3nTLX0a8WghPTi+TPvH2Qf/1cf+C0F
   8fdAAkVMFsqXP1LX9Qy15vGLGv2rdcxjXeCgU1nd2CdgY1T02uN1bVoyJ
   bwxbDHKaXQdW5KlRq6AFHu4kZJHS9xvm6kVWFyprgG1HE5u5GQVaqBk/R
   A==;
X-CSE-ConnectionGUID: gGtHU+teTtC2B0UYRUdeaQ==
X-CSE-MsgGUID: aefgoDuHRIimaAORlyzbig==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76219358"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76219358"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:43 -0700
X-CSE-ConnectionGUID: 6m3UxA2OQmCJlKqAtU0qBw==
X-CSE-MsgGUID: Igrb2QAMTOSehy04/25xZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224121492"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:15 -0700
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
Subject: [PATCH v4 00/10] selftests/resctrl: Fixes and improvements focused on Intel platforms
Date: Fri,  3 Apr 2026 18:55:59 -0700
Message-ID: <cover.1775266384.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Shuah,

Could you please consider this series for inclusion?

No problem if you already took v3. There have been no functional changes since v3.

Thank you very much,

Reinette

Changes since v3:
- v3: https://lore.kernel.org/lkml/cover.1773432891.git.reinette.chatre@intel.com/
- No functional changes.
- Start sentence in changelog using upper case. (Ilpo)
- Add Reviewed-by tags.

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

