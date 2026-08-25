Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4204819005E
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681736; cv=none; b=rEcjnjqkHRdUjYSzB2uga9ncRrh7t6K5i87waAaYH78ade26CYWR9/nwVG97NUeGbp2kfeBz4+ZLlIDMErsEuiYikPouxltidjKKzWinCr04UvEJjMeHMlSrP64hph2i0RX54m242UVhszNKSE4QS20C7U1PzYhuTIM7XO/ZEUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681736; c=relaxed/simple;
	bh=BQRcC2xG25uM6+R1xvzpnNV4l0LH9qmzaH2Rw5U2sE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s8Zl8O9qmL9ttsdVVeqer9qPNN2eoroLtLjqZEiLCdDnfXEJ4PpvMq1BIXg6fp6jJbMX97Z4CXlVs6PkEmQIFYXj7lhntfwtYUAN9Ipi3/fjz6+Xc4/twM2nmkOftEzuDuRPt6ZgODIc2aAN4fqvBRcyg7Bt4uBbNM5WUiCIsRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZG4qV+Tk; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZG4qV+Tk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787681734; x=1819217734;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BQRcC2xG25uM6+R1xvzpnNV4l0LH9qmzaH2Rw5U2sE4=;
  b=ZG4qV+Tk58uSii7Y9z2qcQErFV/dWjsZASFDct8oNMbm8NDHHEDZGxvN
   Txf1WxPYBMhmbUfsWOn4dKxCNXRfyznqUTjpR0E5XM+f8m+vXsoB4Y/8P
   /RiDZnPNPaJgTovS3pGPLCZEdVMM7sJXgi7qOTJ2Sl9qazuk0308Y0ylu
   B4hkhcFupRrN23nnpKNCTgDuJhku49Khlo9nHmRQ/VCKOyawsyNVOItVw
   c9z/8utEMq7t+EBkj91Q/vpaosktS+rTfFnIl8jQyRn2XjP+bmyF2zyx0
   6EF5+Vkaf3HYqCJkPXh053tCIfuYdStpSsKG9SrL+sWlT7l6Xh80PosYS
   Q==;
X-CSE-ConnectionGUID: A7u9ZVOuRUmkwCHTu+fz5Q==
X-CSE-MsgGUID: gXz0F4F5Tx6d0G5ljaJOYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88174197"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88174197"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:33 -0700
X-CSE-ConnectionGUID: 5QRSZkUrRKiNUYCMYGyHVg==
X-CSE-MsgGUID: nYB2sVXxRPKJvHw+0RL08Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="265559591"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.141])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:33 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
	Breno Leitao <leitao@debian.org>,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 0/7] Intel platform driver to reset bitfix filters
Date: Tue, 25 Aug 2026 11:15:19 -0700
Message-ID: <20260825181526.13203-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some Intel CPUs implement a "bitfix filter" to suppress reporting of the
same corrected errors repeatedly in the case where aging silicon
develops stuck bits.

But when systems run for weeks, or months, the filters may become clogged
with transient errors.

When the filter is full (indicated by a "yellow" signature in a machine
check bank) clear the filter. This may make space for additional hard
errors.

Save a time stamp when clearing a filter. Log with "WARN" severity if
the filter overflows quickly (in tem minutes or less).

This code was originally developend by Qiuxu as an add-on to an EDAC
driver. But not everyone wants to run an EDAC driver, so I pulled the
code out into a standalone platform driver. Much of Qiuxu's code was
cut-and-pasted into this driver, so he gets Co-developed-by credit
throughout.

Qiuxu Zhuo (1):
  cacheinfo: Export get_cpu_cacheinfo_id() for loadable modules

Tony Luck (6):
  x86/mce: Enumeration updates for Intel bitfix filter reset
  platform/x86/intel/bff: Add stub Intel bitfix filter driver
  platform/x86/intel/bff: Add Diamond Rapids support
  platform/x86/intel/bff: Reset bitfix filter when it overflows
  platform/x86/intel/bff: Compute unique ID for overflowed filter
  platform/x86/intel/bff: Report frequent filter resets

 include/linux/cacheinfo.h           |  12 +-
 arch/x86/include/asm/mce.h          |   6 +
 arch/x86/include/asm/msr-index.h    |   2 +
 drivers/base/cacheinfo.c            |  17 ++
 drivers/platform/x86/intel/bff.c    | 284 ++++++++++++++++++++++++++++
 drivers/platform/x86/intel/Kconfig  |  13 ++
 drivers/platform/x86/intel/Makefile |   1 +
 7 files changed, 324 insertions(+), 11 deletions(-)
 create mode 100644 drivers/platform/x86/intel/bff.c


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
2.55.0

