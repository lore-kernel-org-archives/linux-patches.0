Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3BBBA53
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 23:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719617750; cv=none; b=FlkSLmMhp9hMYQQi90L8hdf0oK6i3ZPC9mNmGISDZ8F4lc5XOy+3/d5PRrxQKGvhVMUh2mfYx0pMBJSHoTZuBd9O0uacmkrDBHzzUHQ8rlxlSJnXIfNkM6uTu0OrkZUZcSslEhn2y5lQj4NuGBACtJsLKXhGt9/Qceg6YT54/ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719617750; c=relaxed/simple;
	bh=uwOwcCLt1q4uROCTzISF5KXz+wEZMoPhC1AORFnpp1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LYN/94UN00T0yy0f73trdCU4a2eaurfWpWo75Jmv+odU2P+IOsgBgSK7jRiQEJ0bh+Q0aL8zaYznGhyUDEM7ly0SHa3IHbFzUylT7ZYBCSvXOctN5MwWvnWRPgQDgsY1GrtcZpKHhxEoqM4Al+DY7+39Yr2fs7rGPnhb0UpUNsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AoeEweRb; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AoeEweRb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719617748; x=1751153748;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uwOwcCLt1q4uROCTzISF5KXz+wEZMoPhC1AORFnpp1I=;
  b=AoeEweRbf0sGZykimsStVM+ok7fT7+Skv2/Eg1uTchlKb2FeTMPDd+64
   FEqww06+saIUFg7r6fGjEidLbBIsdGzXk5zkTXit8rGNoylvYazqEsfWu
   zQh4nUL+XbsnIW7lwTomNvjcyyFisG35V4YTBlMl5kJHjeNOlvLqshejC
   2JTKzVYWrHbSUEpw9SrNhcbbrHtVF4C/XpQeYDTNNQvDf3Hv4rcGT7XkR
   lSZojpG//SBdxsy1p4dNz6Rudg/yf/D5Vk5Coed9GWyJ94eLYl1Q8rzON
   tI1O9PRkJqD40sFoPyOJradipjTHfojFh4XRC6lmAcGVdqnxUsD8T/MOc
   g==;
X-CSE-ConnectionGUID: 1lrvjB5cS1KMFcLHWgY4Yg==
X-CSE-MsgGUID: c+JmHOpYS1qV9hy9hOjBkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="20575387"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="20575387"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 16:35:48 -0700
X-CSE-ConnectionGUID: Nn82DNXYRgiCiGHMkKdCKA==
X-CSE-MsgGUID: OF/4E9F4TeOjiHfSk7djUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="45300261"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 16:35:48 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 0/2] New Intel CPUID families
Date: Fri, 28 Jun 2024 16:35:38 -0700
Message-ID: <20240628233540.77900-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Final steps in the migration to new Intel family support.

These two patches should be applied at the end of the v6.11 merge window
after all the trees listed below have been merged.

Maybe right before v6.11-rc1 is tagged, or in the rc1..rc2 week of
updates.

Posting patches now as I'll be offline for the merge window.

Base for this series in linux-next 1eb586a9782c ("Add linux-next specific
files for 20240628") which I used to test build allmodconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>

Original cover letter here:
Link: https://lore.kernel.org/all/20240416211941.9369-1-tony.luck@intel.com/

Changes since v6 https://lore.kernel.org/all/20240520224620.9480-1-tony.luck@intel.com/

All but the final two cleanup patches have been applied to various
maintainer trees and are staged in linux-next ready for the v6.11
merge window. Trees (as named in linux-next Next/SHA1s) commit-ids and
shortlog names here:

char-misc	a43b9ec091b1 peci, hwmon: Switch to new Intel CPU model defines
crypto		adc5167be555 crypto: x86/poly1305 - Switch to new Intel CPU model defines
crypto		b2d3d79780fa crypto: x86/twofish - Switch to new Intel CPU model defines
drivers-x86	0ff9c76fda20 platform/x86: intel_telemetry: Switch to new Intel CPU model defines
drivers-x86	12929ac3ef8d platform/x86: intel_ips: Switch to new Intel CPU model defines
drivers-x86	1630dc626c87 platform/x86: ISST: Add model specific loading for common module
drivers-x86	33af65ad6749 platform/x86/intel/pmc: Switch to new Intel CPU model defines
drivers-x86	490d573b5a85 platform/x86/intel/ifs: Switch to new Intel CPU model defines
drivers-x86	568e639a617f platform/x86: intel-uncore-freq: Switch to new Intel CPU model defines
drivers-x86	5b3eaf10e2e0 x86/platform/atom: Switch to new Intel CPU model defines
drivers-x86	70a4fa3f4fc1 platform/x86: intel_turbo_max_3: Switch to new Intel CPU model defines
drivers-x86	a42f41466f98 platform/x86: intel_speed_select_if: Switch to new Intel CPU model defines
drivers-x86	d30f57b7413f platform/x86: intel_scu_wdt: Switch to new Intel CPU model defines
drivers-x86	fad21268dc31 platform/x86: p2sb: Switch to new Intel CPU model defines
edac		9593189cf061 EDAC/sb_edac: Switch to new Intel CPU model defines
edac		bc39bfbaa2c8 EDAC/i10nm: Switch to new Intel CPU model defines
edac		c2c887e9f967 EDAC/skx: Switch to new Intel CPU model defines
edac		e09d576c862e EDAC, pnd2: Switch to new Intel CPU model defines
extcon		089a6e37c539 extcon: axp288: Switch to new Intel CPU model defines
jc_docs		f77afc2796d5 Documentation/x86: Switch to new Intel CPU model defines
kvm-x86		0c468a6a020c KVM: VMX: Switch to new Intel CPU model infrastructure
kvm-x86		8387435bebac KVM: x86/pmu: Switch to new Intel CPU model defines
pci		d5debddce5b6 PCI/PM: Switch to new Intel CPU model defines
pm		0f46ecc4242a thermal: intel: intel_tcc_cooling: Switch to new Intel CPU model defines
pm		17c4fc386b0c intel_idle: Switch to new Intel CPU model defines
pm		35ba8ec0fbd0 ACPI: x86: Switch to new Intel CPU model defines
pm		4b32e5e873f7 powercap: intel_rapl_msr: Switch to new Intel CPU model defines
pm		691fef8ccbb7 cpufreq: Switch to new Intel CPU model defines
pm		a31a0a3e90b4 thermal: intel: intel_soc_dts_thermal: Switch to new Intel CPU model defines
pm		b9064fb834bf powercap: intel_rapl: Switch to new Intel CPU model defines
pm		ca8752384c6f cpufreq: intel_pstate: Switch to new Intel CPU model defines
pm		dde8ec86c3fd ACPI: LPSS: Switch to new Intel CPU model defines
sound-asoc	34864c05a54d ASoC: Intel: avs: es8336: Switch to new Intel CPU model defines
tip		189e8d4b9849 x86/virt/tdx: Switch to new Intel CPU model defines
tip		2cf615a4519b x86/platform/intel-mid: Switch to new Intel CPU model defines
tip		6568fc18c2f6 x86/cpu/intel: Switch to new Intel CPU model defines
tip		6fd5e8855e60 x86/boot: Switch to new Intel CPU model defines
tip		744866f5c0e2 x86/cpu: Switch to new Intel CPU model defines
tip		8e887536b896 perf/x86/rapl: Switch to new Intel CPU model defines
tip		ac6bee4bf73c x86/PCI: Switch to new Intel CPU model defines
tip		d142df13f357 perf/x86/intel: Switch to new Intel CPU model defines
turbostat	1b3bf0747d4f tools/power/turbostat: Switch to new Intel CPU model defines
v4l-dvb-next	156922faabce media: atomisp: Switch to new Intel CPU model defines

Tony Luck (2):
  x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
  x86/cpu/vfm: Delete all the *_FAM6_ CPU #defines

 arch/x86/include/asm/cpu_device_id.h | 20 -------
 arch/x86/include/asm/intel-family.h  | 85 +---------------------------
 2 files changed, 2 insertions(+), 103 deletions(-)


base-commit: 1eb586a9782cde8e5091b9de74603e0a8386b09e
-- 
2.45.2

