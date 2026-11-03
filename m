Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740994;
	b=WwQM5VVphEh/7C7XK7dUZwJ/nhrxuMl0T3GHQUCzuoeV5SGUXNpFUOMLAii/YGzBysJn
	 fAM3/Dk9r6OeB2OQdfuYk1ld6O7KyF7QQvGX1MXY8IXnwEYScIOxKtOPS+y0Celos0GBT
	 8tsXb3+F86yIsSeYrCOwjvHj2len01m5eYamdSQv1w05jRZXwhk23e/n82F5vmRt6xGhn
	 QVr8E7X5rVLXLhYEabgFi7GCP+AaIR1+BEbhKl9SWwo+x/F6+z1fnw2180CLyrzznNfhs
	 kNnUy8VaI/8LkOefhTu5qysIy9cLHZPwkVGc+UCtqISPKJA/jBWjdSC5YyMeBxcIRog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740994;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=qYRiGQ3KNp0bEqyQAn08IyMyimUsWPwAs+MRr512r9s=;
	b=NXkFvaxtvDyJIIWdHdIAqZcWCVILDHw3VqxGlRFEB1CxLHHT/0ExQHqgIpCIX/2OFDGt
	 Px58YOImKH/cNWpyT24r37aLEEouBGO3+BCzSMKEHomssoDu8fXOmHfhKlWnyJimS/f/V
	 w73Q3qFB5qR+ahTCyIHeizT7TdDU5W5tXiXLxwK0jrpCPTqqdh7lRNM8jRXOOC+VkLXgz
	 rZNJVLS1W13uEn8z2O6EY8W+ZtwMaHHuhBdS1uzCyvQQYpb7Yq11MCeVqph0+S6JFM4VC
	 ZQSXPBMCbJf5Pck+g9XYDKSvwleUZKFvlIpmyx8TZAGEfrofshmOKFHQnDhvNsdXNTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="CIAzSO/j";
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569F606A330
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5569F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CIAzSO/j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793740993; x=1825276993;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8kDrjnLmp6W3GIQokEeixHyPlF6zEwaEEjSFy9Pt0VY=;
  b=CIAzSO/jXw/HjBiznVOxdDAjk2uhmhaiAM1nTqJFr+QwcM3ZKLB/cF1j
   FPNdnJkYjrCWvt0GUO9tWV5/aWc8hhKEkOT5MsiCIIpNTI9xKBick/L84
   MWJje0wvgWrrKbfejT/hoTC0CRlUTM6B//PZbaMkpKD0jCAw7sVj7oybe
   TzvmW0nsJwLVn77ijxwHtUTG3ENlfArMNX1uCzc61MooBMqFfpUon+smy
   G1zMskSYQv50U9esEIYexU4r2bg/DxvDGG104D/I+EHt3vtL5S271TKRQ
   zQAi8lXvjEnYF4Wrw4g8ecPA7bTlF9B0u4h9+IId9Th2G/YVxnEdCRjXg
   w==;
X-CSE-ConnectionGUID: JWx/xXI6TaK4keQaSmTnpQ==
X-CSE-MsgGUID: SrjIvpGIRaig9vUtNV/ocg==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393479"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393479"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:10 -0800
X-CSE-ConnectionGUID: vhMMWsasSUC2qDInYo2Ecw==
X-CSE-MsgGUID: AQD9sFJFTge4eiQB92AAeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624545"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:06 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH v2 00/11] x86/resctrl: Support asymmetric L2 CAT on hybrid CPUs
Date: Tue,  3 Nov 2026 13:22:43 -0800
Message-ID: <20261103212254.18314-1-tony.luck@intel.com>
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

Stil RFC as it builds on Reinette's multiple control patches[0].

Some hybrid CPUs (e.g. Panther Lake) have L2 caches whose cache
allocation capabilities differ between P-core and E-core domains.
Today these show up as symmetric L2 CAT, on just the P-core. New CPUID
leaves enumerate asymmetric allocation separately, including per-domain
capacity bitmask (CBM) lengths.

This series teaches resctrl to use that enumeration:

 - Define the four Intel RDT CPUID leaves, and add the asymmetric
   L2 CAT/CDP feature bits, CPUID dependencies and rdt= boot options
   (l2cat_asym, l2cdp_asym).
 - Disable symmetric L2 CAT on Panther Lake, where it is misreported.
 - Clean up rdt_get_cache_alloc_cfg() (failure handling, leaf argument)
   and the RDT allocation feature checks to prepare for a second leaf.
 - Move the CBM length from the shared control to each control domain
   (touches fs/resctrl, x86 and MPAM) since lengths can now differ.
 - Enumerate asymmetric L2 CAT/CDP from CPUID leaf 0x28 when no
   shareable bits are reported (resctrl cannot represent them per
   domain). info/L2/cbm_mask reports the minimum CBM across domains.
 - Change the "max" file to show per-domain values, matching the
   schemata format, so the UI needs no change for asymmetric controls.
 - Document the new options and the cbm_mask semantics.

Changes since first RFC[1]:

*) No new/renamed resource or control. Just keep this as "L2" for both.

*) Keep the info/L2/cbm_mask but make it display the minimum mask across
   all domains. Naive legacy s/w may use this and waste some cache.

*) Chen Yu pointed out that I don't need to search the resource for the
   control to update the domain. Drop the helper and just update the
   bitmask length in domain_add_cpu_ctrl()

*) Find per-domain cbm_len for L3 as well as L2 cache (though still only
   look for asymmetric L2

*) Intel L2 caches don't have any shareable bits. Check that the
   shareable mask is zero (as this series doesn't update file system
   code to handle asymmetric shareable bits).

[0] Link: git://git.kernel.org/pub/scm/linux/kernel/git/reinette/linux.git resctrl/controls_rfc_v2.4
[1] Link: https://lore.kernel.org/all/auDiLEujZ5BGCACj@agluck-desk3/

Tony Luck (11):
  fs/resctrl: Change UI of "max" file (merge back into earlier patches)
  x86/resctrl: Disable symmetric L2 CAT on Panther Lake
  x86/cpuid: Define Intel RDT enumeration leaves
  x86/resctrl: Add asymmetric L2 CAT feature bits and boot options
  x86/resctrl: Handle cache allocation setup failures
  x86/resctrl: Pass the CPUID leaf to rdt_get_cache_alloc_cfg()
  arm,x86,fs/resctrl: Store cache bitmask length per control domain
  x86/resctrl: Use cpu_feature_enabled() for RDT allocation
  x86/resctrl: Accept asymmetric RDT allocation features
  x86/resctrl: Enable asymmetric CAT from CPUID leaf 0x28
  fs/resctrl: Document asymmetric L2 allocation options

 .../admin-guide/kernel-parameters.txt         |   3 +-
 Documentation/filesystems/resctrl.rst         |   8 +-
 include/linux/resctrl.h                       |  12 +-
 arch/x86/include/asm/cpufeatures.h            |   3 +
 arch/x86/include/asm/cpuid/types.h            |   4 +
 arch/x86/kernel/cpu/cpuid-deps.c              |   2 +
 arch/x86/kernel/cpu/resctrl/core.c            | 138 +++++++++++++-----
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        |   2 +-
 arch/x86/kernel/cpu/scattered.c               |   3 +
 drivers/resctrl/mpam_resctrl.c                |  14 +-
 fs/resctrl/ctrlmondata.c                      |   9 +-
 fs/resctrl/pseudo_lock.c                      |   2 +-
 fs/resctrl/rdtgroup.c                         |  56 ++++---
 13 files changed, 184 insertions(+), 72 deletions(-)

-- 
2.56.0

