Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08503E49D
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245199; cv=none; b=ZYYJ6UT727urglcL+Ol+VZ3JxG7EyOn+s8yVwM7kR75zOQTNbS9SFHOZSiNuzKaEmI6Pgl01I96aLTFZgXufbcqD2FSFmEsBLvkx7KtFrt1qNWoLbYLDEfImU6LxQlQknXbaRGEGQ0UbmEsU/j0Pk/QPmZxMNL+LRn2mc0xu2r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245199; c=relaxed/simple;
	bh=03T9yfzcZ8ZB3B9N87naTXotOa1eOTCCA1OUJjwYFE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oaujRT8LBBhRH5Ca4NZt0cCxbYhjwT4gZvI5G7y05tUvKxbjtb85JXICQeE+bVs/OCIQOG2tg+Amrs4hawWCJkcAOwVVPr8UhBFYYt236UiHlNRYEs3cJsjF1//1DLsEHOqcBhgzfD+XcgyMRxMBmHD5wXLSWLvtKBy9rioeP0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ukf/lcRw; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ukf/lcRw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245198; x=1747781198;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=03T9yfzcZ8ZB3B9N87naTXotOa1eOTCCA1OUJjwYFE8=;
  b=Ukf/lcRw4c4BdSYF03q2fSL1stE5k0rjLkpdRYWUu8v31O55WPCYl9xL
   QHE8mfDBxBp0oXpkiLzjgQqdPuWWe6LjTczwss2qXjncF/0GjZeC1rB1b
   QLdftIxqUG6+LF/8G5sf4QJ72nUo134LA5K9xl+nc35ZrO0FN0XmTXAD+
   Ugv4J959zj8UGn7bt4uBi8ZIeygBiHCy7zwbY69+3sF7p2U/Lyz3qNJlv
   S5kabLd9Ul3Yq9Nx3h0Jp8WUi78o4rLxrD7UlOSY/99+RsqJ/ZM925qmU
   wBNZ9E7s/3gPvVy0CFARazaeQnEas7PgbWY4KneZxc0Zz8fFF8T68mldA
   g==;
X-CSE-ConnectionGUID: kFg1h9twQs2Ic8+dt3la6A==
X-CSE-MsgGUID: y/EEF7MvR3mCw8Cd25rexg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199501"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199501"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
X-CSE-ConnectionGUID: 8N9fDOHGTkmTNQ1TY04XVw==
X-CSE-MsgGUID: N3SwCssRQsicrAdtSWQkPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593378"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:34 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 00/49] New Intel CPUID families
Date: Mon, 20 May 2024 15:45:31 -0700
Message-ID: <20240520224620.9480-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

tl;dr
- Please consider patches 0001 & 0002 as urgent to fix a regression.

- Middle set (0003..0047) are independent of each other (I think)
  and can be applied in ant order at a more lesisurely pace.

- Patches 0048 & 0049 cleanup unused macros *after* all the others
  have been applied.

Full cover letter here:
Link: https://lore.kernel.org/all/20240416211941.9369-1-tony.luck@intel.com/

This series also available with:
 $ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git new_families_v6

Signed-off-by: Tony Luck <tony.luck@intel.com>

Changes since v5:
Link: https://lore.kernel.org/all/20240430164913.73473-1-tony.luck@intel.com/

Rebased to upstream v6.10 Linus merge tree on May 20th:
commit 72ece20127a3 ("Merge tag 'f2fs-for-6.10.rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs")

Found a regression with the use of "INTEL_ANY" to match from
any family (instead of just from family 6.

   Patch 0002 fixes this. See this link for previous discussion for
   fix. Link: https://lore.kernel.org/all/20240517172134.7255-1-tony.luck@intel.com/
   Patch 0001 must be applied along with this patch to fix the one
   spot in the kernel that doesn't use X86_MATCH*() macros to
   initialize things.

A handful of other patches have been updated to resolve conflicts
with changes pulled into the merge window from other trees.

Tony Luck (49):
  crypto: x86/aes-xts - Switch to new Intel CPU model defines
  x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL
  tpm: Switch to new Intel CPU model defines
  platform/x86/intel/ifs: Switch to new Intel CPU model defines
  media: atomisp: Switch to new Intel CPU model defines
  ASoC: Intel: avs: es8336: Switch to new Intel CPU model defines
  platform/x86: intel_scu_wdt: Switch to new Intel CPU model defines
  KVM: x86/pmu: Switch to new Intel CPU model defines
  KVM: VMX: Switch to new Intel CPU model defines
  cpufreq: Switch to new Intel CPU model defines
  intel_idle: Switch to new Intel CPU model defines
  PCI: PM: Switch to new Intel CPU model defines
  powercap: intel_rapl: Switch to new Intel CPU model defines
  ASoC: Intel: Switch to new Intel CPU model defines
  thermal: intel: intel_tcc_cooling: Switch to new Intel CPU model
    defines
  x86/platform/intel-mid: Switch to new Intel CPU model defines
  platform/x86: intel_speed_select_if: Switch to new Intel CPU model
    defines
  platform/x86: intel-uncore-freq: Switch to new Intel CPU model defines
  platform/x86: intel_ips: Switch to new Intel CPU model defines
  platform/x86: intel_telemetry: Switch to new Intel CPU model defines
  platform/x86: intel: telemetry: Switch to new Intel CPU model defines
  platform/x86: intel_turbo_max_3: Switch to new Intel CPU model defines
  platform/x86: p2sb: Switch to new Intel CPU model defines
  platform/x86/intel: pmc: Switch to new Intel CPU model defines
  platform/x86/intel/pmc: Switch to new Intel CPU model defines
  crypto: x86/poly1305 - Switch to new Intel CPU model defines
  crypto: x86/twofish - Switch to new Intel CPU model defines
  x86/cpu/intel: Switch to new Intel CPU model defines
  x86/PCI: Switch to new Intel CPU model defines
  x86/virt/tdx: Switch to new Intel CPU model defines
  perf/x86/intel: Switch to new Intel CPU model defines
  x86/platform/atom: Switch to new Intel CPU model defines
  x86/cpu: Switch to new Intel CPU model defines
  x86/boot: Switch to new Intel CPU model defines
  EDAC/i10nm: Switch to new Intel CPU model defines
  EDAC, pnd2: Switch to new Intel CPU model defines
  EDAC/sb_edac: Switch to new Intel CPU model defines
  EDAC/skx: Switch to new Intel CPU model defines
  extcon: axp288: Switch to new Intel CPU model defines
  ACPI: LPSS: Switch to new Intel CPU model defines
  ACPI: x86: Switch to new Intel CPU model defines
  cpufreq: intel_pstate: Switch to new Intel CPU model defines
  perf/x86/rapl: Switch to new Intel CPU model defines
  platform/x86: ISST: Switch to new Intel CPU model defines
  powercap: intel_rapl: Switch to new Intel CPU model defines
  tools/power/turbostat: Switch to new Intel CPU model defines
  peci, hwmon: Switch to new Intel CPU model defines
  x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
  x86/cpu/vfm: Delete all the *_FAM6_ CPU #defines

 .../atomisp/include/linux/atomisp_platform.h  |  27 +--
 include/linux/mod_devicetable.h               |   4 +
 include/linux/peci-cpu.h                      |  24 ++
 include/linux/peci.h                          |   6 +-
 include/linux/platform_data/x86/soc.h         |  12 +-
 arch/x86/include/asm/cpu_device_id.h          |  30 +--
 arch/x86/include/asm/intel-family.h           |  85 +------
 drivers/char/tpm/tpm.h                        |   2 +-
 drivers/char/tpm/tpm_tis_core.h               |   2 +-
 drivers/peci/internal.h                       |   6 +-
 arch/x86/boot/cpucheck.c                      |   2 +-
 arch/x86/crypto/aesni-intel_glue.c            |  16 +-
 arch/x86/crypto/poly1305_glue.c               |   4 +-
 arch/x86/crypto/twofish_glue_3way.c           |  10 +-
 arch/x86/events/intel/core.c                  | 212 +++++++++---------
 arch/x86/events/rapl.c                        |  90 ++++----
 arch/x86/kernel/cpu/intel.c                   | 108 +++++----
 arch/x86/kernel/cpu/match.c                   |   4 +-
 arch/x86/kvm/pmu.c                            |   8 +-
 arch/x86/kvm/vmx/vmx.c                        |  20 +-
 arch/x86/pci/intel_mid_pci.c                  |   4 +-
 arch/x86/platform/atom/punit_atom_debug.c     |  11 +-
 arch/x86/platform/intel-mid/intel-mid.c       |   7 +-
 arch/x86/virt/vmx/tdx/tdx.c                   |   8 +-
 drivers/acpi/x86/lpss.c                       |   4 +-
 drivers/acpi/x86/utils.c                      |  44 ++--
 drivers/cpufreq/intel_pstate.c                |  90 ++++----
 drivers/cpufreq/speedstep-centrino.c          |   8 +-
 drivers/edac/i10nm_base.c                     |  20 +-
 drivers/edac/pnd2_edac.c                      |   4 +-
 drivers/edac/sb_edac.c                        |  14 +-
 drivers/edac/skx_base.c                       |   2 +-
 drivers/extcon/extcon-axp288.c                |   2 +-
 drivers/hwmon/peci/cputemp.c                  |   8 +-
 drivers/idle/intel_idle.c                     | 116 +++++-----
 drivers/pci/pci-mid.c                         |   4 +-
 drivers/peci/core.c                           |   5 +-
 drivers/peci/cpu.c                            |  21 +-
 drivers/peci/device.c                         |   3 +-
 drivers/platform/x86/intel/ifs/core.c         |  15 +-
 drivers/platform/x86/intel/pmc/core.c         |  46 ++--
 drivers/platform/x86/intel/pmc/pltdrv.c       |  16 +-
 .../intel/speed_select_if/isst_if_common.c    |   8 +-
 .../intel/speed_select_if/isst_if_mbox_msr.c  |   2 +-
 .../platform/x86/intel/telemetry/debugfs.c    |   4 +-
 drivers/platform/x86/intel/telemetry/pltdrv.c |   4 +-
 drivers/platform/x86/intel/turbo_max_3.c      |   4 +-
 .../intel/uncore-frequency/uncore-frequency.c |  56 ++---
 drivers/platform/x86/intel_ips.c              |   3 +-
 drivers/platform/x86/intel_scu_wdt.c          |   2 +-
 drivers/platform/x86/p2sb.c                   |   2 +-
 drivers/powercap/intel_rapl_common.c          | 120 +++++-----
 drivers/powercap/intel_rapl_msr.c             |  16 +-
 drivers/thermal/intel/intel_soc_dts_thermal.c |   2 +-
 drivers/thermal/intel/intel_tcc_cooling.c     |  30 +--
 sound/soc/intel/avs/boards/es8336.c           |   8 +-
 tools/power/x86/turbostat/turbostat.c         | 165 ++++++++------
 57 files changed, 740 insertions(+), 810 deletions(-)


base-commit: 72ece20127a366518d91c5ab8e9dd8bf7d7fdb2f
-- 
2.45.0

