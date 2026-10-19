Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443050;
	b=qKcUrJyEPxDZE+I6YuPJQypuq0ack8n8kgx19vCqh1Eh0yM+jd/4EWApAeOBvk7hxuMH
	 u1007TAqNs8ZnG3+Gzlw+MqroaiC3DUPCPtpb/aM1ihIDmW4GD9SzIrQMdC/cF68mNdHM
	 Xr6WXGeuXAXoxvsxYrEijbfnwrOjdioBROLthdYmXMTgQyAOTzrF75wy7q5KfbGzQ4tGY
	 /fTBhQZec25vWZKX9ruL2XJMJ8fho3snitB8ostOV+0CgK/GTEKksYbqaMAMNj77k+wLX
	 JhX+JX1gl8NEnez4idkPzqcPkJPCDmJS4cqGtAjmEtne28mVPtmbS82qOtKBeVuurgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443050;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=VpBTw/eXnsZSaPgWWJ6FKgBC2JXr839VO9Dmyx8+bhE=;
	b=26EbIeU3SIkxb/U268Oz/C5jI6Lv09W1lrw9svmeUeep7erXLi4TUjoyp7tKJVgkRia3
	 Dhvw4vIrxHdiKaIfXH2tMCGF0sf5joRuDZrR29i2a55U6j/pWTOvk5wpq47uhhq5jBRLz
	 20/JtXjNgENZVQRZ4n4I3DTq9BAzJ/tBAHMiZktuzDC9BO/WtO2qhNpK1TrDxFUxdvFcw
	 W9BRSxxPOuuKZybznXMzvlTIK6rX7WehJKnBHsh5/fGwIS3O6Ksya0Mg1hLxJTK5n4yA0
	 Af7qNGQD43XbBF/ErBH1N2+iYSjIs/THWurftCqb0KUdd6K9ICKym/ILwemVUq0arTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lOoYCBJ7;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95B9606A31F
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C95B9606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lOoYCBJ7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443049; x=1823979049;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FBe1MMu/51yKV6+nDscVY1+pdF7VHUy9QdrsXisND0A=;
  b=lOoYCBJ7GB+LjeJcKlV/HMg3TPGXCxZ04Jyjj3ZvMJMcd8bNujkXGNBF
   q7KcsADXOJLDzYS31ZpJ4tbcy7eeapQIV8GQmMdl7eBq9Dik8ggxd7qsL
   sKcYGUdD8wiqIuEGK9fjvaDlg7tKT7CNa3GfVnFQWx1Wy5gjrRqZ6CSMy
   UM+NVi6p1NX2uZeailSNGfeTHNi+bOgb8eU+JjPiDIgFyfGq1E7GsvB7y
   vZQcdR10o07tLDlQ1IzQ42GOpC1aGnk+Qs68xS8sazeTUehZVdHL1/8bA
   Ii4mR07zwkzz+42vRBiHzjdpYUBYPk2gKB9JmpS9W8UfjUjV+OgnK5CV9
   w==;
X-CSE-ConnectionGUID: EZ8m7ySiTvS0KqA8C/H3Iw==
X-CSE-MsgGUID: x06ZU9x0SUa2Ukky6Nn7CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131100"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131100"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:48 -0700
X-CSE-ConnectionGUID: yvf/vGXhSJuVs6aUAarbWQ==
X-CSE-MsgGUID: xsFDYSZ3QkOAxfHdWljiaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008614"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:48 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v14 00/24] Allow AET to use PMT as loadable module
Date: Mon, 19 Oct 2026 13:50:07 -0700
Message-ID: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Requiring INTEL_PMT_TELEMETRY=y to enable AET is a functional workaround
to enable enumeration of Application Energy Telemetry (AET) events, but
unacceptable to many users. It results in increased configuration complexity,
increased kernel memory footprint and inability to patch problems by unloading
a module and loading an updated version.

Add a registration function to the AET code that can be used by
INTEL_PMT_TELEMETRY to provide the enumeration functions.

INTEL_PMT_TELEMETRY can be loaded/unloaded independently of
resctrl file system mount/unmount. Perform enumeration on
every mount and cleanup on every unmount.

Patch series based on TIP tree x86/cache branch current HEAD is:
  2c10b3fa5bdf ("fs/resctrl: Ensure default group reports tasks on monitor-only systems")

Signed-off-by: Tony Luck <tony.luck@intel.com>

Previous version (v13) here:
Link: https://lore.kernel.org/all/20260928221509.68002-1-tony.luck@intel.com/

Changes since v13:

[PATCH v14 01/24] x86/cpufeatures: Add missing CQM feature dependency
	Add AMD64 manual
	s/Linux X86_FEATURE_CQM/X86_FEATURE_CQM/
	Complete the trio of context, problem, solution paragraphs
	by adding the problem statement.

[PATCH v14 02/24] x86/resctrl: Check if monitoring features are supported

	Move maintainer note after the "---"
	Put the X86_FEATURE_* parenthetical comments back (without "Linux")
	s/monitoring features/resource monitoring features/g
	Add Reinette RB tag
	Add problem paragraph between context and solution.
	Add Chen Yu Tested-by tag

[PATCH v14 03/24] x86/resctrl: Centralize monitoring feature enumeration
	Structure commit in context, problem, solution.
	Add note that there is still one user of boot_cpu_data.

[PATCH v14 04/24] x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
	Replaced commit message with Reinette suggestion from v12 review.
	Two tweaks suggested by AI commit review:
		Be more specific that "early" enumeration is simply
		before resctrl.
		s/consumer/reader/g

[PATCH v14 05/24] x86/resctrl: Delete resctrl_cpu_detect()
	Split first paragraph into two: context and problem.
	Don't list all the fields as a regex.

[PATCH v14 06/24] arm,x86,fs/resctrl: Replace architecture capability helpers with generic versions
	New Subject: without {alloc,mon}
	New commit message in context, problem, solution format
	Did not apply Reinette RB tag because of commit message rewrite.

[PATCH v14 07/24] x86/resctrl: Update special case for Intel Haswell enumeration
	Updated commit comment in context, problem, solution form.

[PATCH v14 08/24] x86/resctrl: Delete rdt_alloc_capable and rdt_mon_capable
	New commit message in context, problem, solution format.

[PATCH v14 09/24] fs/resctrl: Remove redundant calls to resctrl_mon_capable()
	New commit message confessing that this is fixing a performance
	problem created by an earlier patch this series.

[PATCH v14 10/24] x86/resctrl: Honor rdt={perf|energy} options to force enable AET events
	New commit message. Dropped previous supplied Reinette RB tag.

[PATCH v14 11/24] fs/resctrl: Add interface to disable a monitor event
	New commit message. Dropped previous applied Reinette RB tag.

[PATCH v14 12/24] arm,x86,fs/resctrl: Allocate maximum needed rmid_ptrs[]
	New commit message.

[PATCH v14 13/24] arm,x86,fs/resctrl: Use right size for L3 monitor data structures
	New commit message.

[PATCH v14 14/24] x86,fs/resctrl: Handle systems where AET is the only monitoring feature
	New commit message.

[PATCH v14 15/24] x86/resctrl: Add PMT registration API for AET enumeration callbacks
	New commit message.

[PATCH v14 16/24] platform/x86/intel/pmt: Register enumeration functions with resctrl
	New commit message.

[PATCH v14 17/24] x86/resctrl: Use registered function pointers for AET enumeration
	Updates to resolve locking problems reported by Sashiko in v13.

	AET is now going to use a single mutex for both registration
	and in a later patch for device removal. So change the name
	from aet_register_lock to just aet_lock.

	Reverse locking hierarchy between AET and pmt_telemetry.
	No longer OK to call into pmt_telemetry to enumerate
	features with the aet_lock held. Instead, make use of
	module pinning while holding aet_lock.

	New commit message

[PATCH v14 18/24] arm,x86,fs/resctrl: Enumerate AET on every resctrl mount
	New commit comment.
	aet_register_lock name changed to aet_lock.
	Babu: Add commit comment about event_group::force_off

[PATCH v14 19/24] x86/resctrl: Enforce system RMID limit on AET
	New commit comment

[PATCH v14 20/24] x86/resctrl: Export interface to report telemetry unbind/remove
	Dropped aet_mmio_lock. Now safe to use aet_lock.
	New commit message
	Add code comment noting that per-package may be over-reaction.

[PATCH v14 21/24] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
	Added commit comment on lock order.
	New commit comment.

[PATCH v14 22/24] x86/resctrl: Require 64-bit x86 for resctrl support
	New commit message.

[PATCH v14 23/24] x86/resctrl: Simplify Kconfig options for resctrl
	New commit message.

[PATCH v14 24/24] x86,fs/resctrl: Document telemetry mount timing caveat
	Updated commit message. Include unmount/remount as solution
	if early mount did not include AET.


Tony Luck (24):
  x86/cpufeatures: Add missing CQM feature dependency
  x86/resctrl: Check if monitoring features are supported
  x86/resctrl: Centralize monitoring feature enumeration
  x86/resctrl: Apply Intel MBM quirk from rdt_get_l3_mon_config()
  x86/resctrl: Delete resctrl_cpu_detect()
  arm,x86,fs/resctrl: Replace architecture capability helpers with
    generic versions
  x86/resctrl: Update special case for Intel Haswell enumeration
  x86/resctrl: Delete rdt_alloc_capable and rdt_mon_capable
  fs/resctrl: Remove redundant calls to resctrl_mon_capable()
  x86/resctrl: Honor rdt={perf|energy} options to force enable AET
    events
  fs/resctrl: Add interface to disable a monitor event
  arm,x86,fs/resctrl: Allocate maximum needed rmid_ptrs[]
  arm,x86,fs/resctrl: Use right size for L3 monitor data structures
  x86,fs/resctrl: Handle systems where AET is the only monitoring
    feature
  x86/resctrl: Add PMT registration API for AET enumeration callbacks
  platform/x86/intel/pmt: Register enumeration functions with resctrl
  x86/resctrl: Use registered function pointers for AET enumeration
  arm,x86,fs/resctrl: Enumerate AET on every resctrl mount
  x86/resctrl: Enforce system RMID limit on AET
  x86/resctrl: Export interface to report telemetry unbind/remove
  platform/x86/intel/pmt: Inform resctrl when MMIO maps are being
    removed
  x86/resctrl: Require 64-bit x86 for resctrl support
  x86/resctrl: Simplify Kconfig options for resctrl
  x86,fs/resctrl: Document telemetry mount timing caveat

 Documentation/filesystems/resctrl.rst      |   8 +-
 include/linux/arm_mpam.h                   |   3 -
 include/linux/intel_vsec.h                 |  14 ++
 include/linux/resctrl.h                    |  84 ++++++++++-
 arch/x86/include/asm/processor.h           |   4 -
 arch/x86/include/asm/resctrl.h             |  24 +---
 arch/x86/kernel/cpu/resctrl/internal.h     |  33 ++---
 arch/x86/kernel/cpu/amd.c                  |   3 -
 arch/x86/kernel/cpu/cpuid-deps.c           |   1 +
 arch/x86/kernel/cpu/hygon.c                |   3 -
 arch/x86/kernel/cpu/intel.c                |   7 -
 arch/x86/kernel/cpu/resctrl/core.c         | 150 +++++++++++---------
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 156 +++++++++++++++++++--
 arch/x86/kernel/cpu/resctrl/monitor.c      |  78 +++++++----
 drivers/platform/x86/intel/pmt/telemetry.c |  45 +++++-
 drivers/resctrl/mpam_resctrl.c             |  44 +++---
 fs/resctrl/monitor.c                       | 111 +++++++++++----
 fs/resctrl/pseudo_lock.c                   |   6 +-
 fs/resctrl/rdtgroup.c                      |  72 ++++++----
 arch/x86/Kconfig                           |  15 +-
 arch/x86/kernel/cpu/resctrl/Makefile       |   3 +-
 21 files changed, 590 insertions(+), 274 deletions(-)


base-commit: 2c10b3fa5bdf61e344bc522e6c2e00d870ce7ab8
-- 
2.56.0

