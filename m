Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E5022CBCC
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069254; cv=none; b=SE3CLyD40hMEOlCfgsTJIVP5G6PkoQBTUaSKvnMoRqnJ0bVycYAcKGsFM2fIo1KDA9c8ugXjJB9t+PwaoObUst68DW2Oc3Tja5N3Q9PIg7uvxDOVwCbCWDQy+I7b2b2mWaN+BAH62dUqWcZG6JpUmY6HYYcLzOI+Z1Pop83D/oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069254; c=relaxed/simple;
	bh=lnFgMXtArObRN3GbXncQyTuX28vMzGs5CIA3S4aIH1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqivTAoVwVsRMPcaJGQ76Fhffw599cPbG3x1djzfq1/7SJ8JqO40kb2E2sQbUarqaUQl69NLYYJ1HU6np9+mRWqPEvz2Jp2jXaLdDL/nnLIX+A8M1ly8hzF87AyFjbqPZqhaIBkbssIBN/2AkArz6WeJJXQZcd9H6j/EnqLKYG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KvD9o3cT; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KvD9o3cT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069253; x=1775605253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lnFgMXtArObRN3GbXncQyTuX28vMzGs5CIA3S4aIH1k=;
  b=KvD9o3cTs53IdKfZIA0B4Vdq7IpxoKC8Imy+YPrHdTqP/AUAkR7/re3S
   /tVfxuVALk4rWx8Zxmefd2jJfEIwfleq7WJXKDukxR3UFqJ8CGE11Xoiw
   i9hm7P3LUp/eu8MsgvpY+yx8Ps8NIf3nQXZIaEP2ceMpbEwzRSZLoN3JW
   kgCqxv2tGwbYcoHsFvYHHjOqKfSv6RBvBaMqx+i+FXlLa0VeD7c6H9QJb
   GVqPpT70aEzRXAlW0+2GwhFKfptzjqd1m+ZUn/3X4Og0nkTsGUQ6+0X9K
   BTgppuK6nU7+DLVcUxLiDoAQoX+LRp8csNILs8U0fnVldsqoJUskt9AJv
   g==;
X-CSE-ConnectionGUID: qC2jmYF3Txy9m9JfMIoC8Q==
X-CSE-MsgGUID: Z/gWnIwhSDCZ7ZV2qrd9Bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193137"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193137"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:46 -0700
X-CSE-ConnectionGUID: CDHgIGQ8Rc28HnppEKH+FQ==
X-CSE-MsgGUID: 98pjoFMHSXKpMXZOdfKK7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315455"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:45 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 04/26] fs/resctrl: Set up Kconfig options for telemetry events
Date: Mon,  7 Apr 2025 16:40:06 -0700
Message-ID: <20250407234032.241215-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enumeration support is provided by the Intel PMT subsystem.

arch/x86 selects this option based on:

X86_64: Counter registers are in MMIO space. There is no readq()
function on 32-bit. Emulation is possible with readl(), but there
are races. Running 32-bit kernels on systems that support this
feature seems pointless.

CPU_SUP_INTEL: It is an Intel specific feature.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/Kconfig                       | 1 +
 drivers/platform/x86/intel/pmt/Kconfig | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ea29d22a621f..44a195ee7a42 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -504,6 +504,7 @@ config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
+	select INTEL_AET_RESCTRL if (X86_64 && CPU_SUP_INTEL)
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
 	select RESCTRL_FS_PSEUDO_LOCK
diff --git a/drivers/platform/x86/intel/pmt/Kconfig b/drivers/platform/x86/intel/pmt/Kconfig
index e916fc966221..b282910b49ef 100644
--- a/drivers/platform/x86/intel/pmt/Kconfig
+++ b/drivers/platform/x86/intel/pmt/Kconfig
@@ -38,3 +38,9 @@ config INTEL_PMT_CRASHLOG
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called intel_pmt_crashlog.
+
+config INTEL_AET_RESCTRL
+	bool
+	help
+	  Architecture config should "select" this option to enable
+	  support for RMID telemtry events in the resctrl file system.
-- 
2.48.1

