Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2CC21CA0E
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958261; cv=none; b=PmFLx6ExQh2Y8Afn/ResxrDFJiUTgxK1hiy7Fl0hWgwcXnuWhDhea1qeAB11JlwU/G/tyIBFCvIJPUzD2DT3zsG88AnKgFlBRbrAYqZ60HArSavgmviIzvSzsEJLPDqKzQy0WwgkIAs4Vy493/VHsq5AzKIp7++zNDSgKtDL0rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958261; c=relaxed/simple;
	bh=6BiOBBRPksYZ79Zl+8MOX/mVDJcU5/RCvN/jjbfh2To=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=swwfljwuK7kXV8SddC0MZ++jMTsDRfDren2d5hSMnJc9XVytjkARsMakj979uWH7Y030nmY9OPyUPZZIPrYFs8EhwRwmKSydlR9o6uIWaJvATVJ6ZboRo0p7PCUu8ZC9yQ3ZI/vHJCkIOJ7j5FJz9i2SDlXhzzu1h1lyOdD5Ok8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZPZaHPb; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZPZaHPb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745958259; x=1777494259;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6BiOBBRPksYZ79Zl+8MOX/mVDJcU5/RCvN/jjbfh2To=;
  b=dZPZaHPbjzlxUS3T+1eEnPwaiMNHl5m9tR2zDlxgPnabMeWmcXRt3e+g
   xkInKReoIuvF1a0tMen4qUV/sBaDU5EODEN93X0jWJvyPwGe2nBDWGGAL
   Ie71MjEybMYVt+FVafTBAtVwRpyahczk2FCTpuyee7Bzq3ImbW+sSurPN
   6dJ193LLo2ND6rsO3qpBd4oE9QpI0U9c8mtajxC+BKJ719TjhIfy9Wuwo
   4Orkim80PM14CHRvj7XeNsmuLTVj9JbLfGscVqz3fvrb6VBG9bWnoP91P
   kciqUno0B/4gNEmQoexMOVkc6Ny2vZiDlBViqwsyfc0Rx8wAPDafkIUJJ
   Q==;
X-CSE-ConnectionGUID: PNCA1CkfQRykngq/jccROA==
X-CSE-MsgGUID: m5uthNoWRtOZnhT8lqXhPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="47314061"
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="47314061"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 13:24:19 -0700
X-CSE-ConnectionGUID: RI1MOyAVRkqbMRiE3WF4hg==
X-CSE-MsgGUID: pF+gcqPGQnSzbcYU37YAzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="139036124"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 13:24:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: rafael@kernel.org
Cc: lenb@kernel.org,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 0/4] Add interfaces for ACPI MRRM table
Date: Tue, 29 Apr 2025 13:24:07 -0700
Message-ID: <20250429202412.380637-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Memory used to be homogeneous. Then NUMA came along. Later different
types of memory (persistent memory, on-package high bandwidth memory,
CXL attached memory).

Each type of memory has its own performance characteristics, and users
will need to monitor and control access by type.

The MRRM solution is to tag physical address ranges with "region IDs"
so that platform firmware[1] can indicate the type of memory for each
range (with separate tags available for local vs. remote access to
each range). Note that these ranges can include addresses reserved
for future hotplugged memory.

The region IDs will be used to provide separate event counts for each
region for "perf" and for the "resctrl" file system to monitor and
control memory bandwidth in each region.

Users will need to know the address range(s) that are part of each
region. This patch series adds
	/sys/firmware/acpi/memory_ranges/rangeX
directories to provide user space accessible enumeration.

-Tony

[1] MRRM definition allow for future expansion for the OS to assign
these region IDs.

Changes since version 3 here:
https://lore.kernel.org/all/20250410223207.257722-1-tony.luck@intel.com/

1) Rebase to v6.15-rc4
2) Removed ugly #ifdef in acpi_mrrm.c with better fix for CONFIG_NUMA=n
3) Moved stub for acpi_mrrm_max_mem_region() into #else !ACPI section
   of <linux/acpi.h>

Tony Luck (4):
  ACPICA: Define MRRM ACPI table
  ACPI/MRRM: Minimal parse of ACPI MRRM table
  ACPI/MRRM: Add /sys files to describe memory ranges
  ACPI: Add documentation for exposing MRRM data

 include/linux/acpi.h                          |   9 +
 include/acpi/actbl1.h                         |   7 +
 include/acpi/actbl2.h                         |  42 ++++
 drivers/acpi/acpi_mrrm.c                      | 183 ++++++++++++++++++
 Documentation/ABI/testing/sysfs-firmware-acpi |  21 ++
 arch/x86/Kconfig                              |   1 +
 drivers/acpi/Kconfig                          |   3 +
 drivers/acpi/Makefile                         |   1 +
 8 files changed, 267 insertions(+)
 create mode 100644 drivers/acpi/acpi_mrrm.c


base-commit: b4432656b36e5cc1d50a1f2dc15357543add530e
-- 
2.48.1

