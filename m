Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD446277818
	for <patches@lists.linux.dev>; Thu, 27 Feb 2025 22:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740696521; cv=none; b=Vy+VA//b2V+8TUr0AXxr2mS/yRS4YjilxbkbnaTG6AU0VkQ34xUQHjpjXlxW9HHOF8ejUpthFiaUtMK1/RR7xoBEHSoRNNPdEf4MjKcCpFZBBIdjfckvG3F83EUwiUx8P4XkVeqFHTBZHFNqTthXHW6w0AZk58KFQVoUgkUy+yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740696521; c=relaxed/simple;
	bh=e0RjurjURyeV3jmQZ5PTbWo/NvwJLTmtc7mi0B4tqKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AJQkITH/LIUHNUD/XEniaCyx/O567nbR1OxeTKDSQXB5E/lE7UlEmmIyNx34Qutc/ryGbXHfSU0zqSk48o+hC8jOxkRNHcw7AAC2yOqqpX2fyGxbPjI+FBIO7D4NUwzf5RJDiJcznCJfvgCL2k5eI/ULu0649yThlDkNbJTUcwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jO8FT3dt; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jO8FT3dt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740696519; x=1772232519;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e0RjurjURyeV3jmQZ5PTbWo/NvwJLTmtc7mi0B4tqKo=;
  b=jO8FT3dtVn0D0EOD3gLXkJCk7635Ir6ob4kgPXFv94DB9qn3bfjR6DJG
   63W1ji+tVg6aGaQpI4RwJSdVk3uGa2MNYaXMDjtglLxiuea8sZc+eAB1N
   rR27buLAIc4MAJy+8ibGl7yBXZA10S8HG/nFqoTdQB4JDjqSvYGTuzKRp
   XNXUfp41PghOHieusjpq5Y6KvzFyh5ZpwzFiRqiNtONyeDolsESntYEBN
   L2dIbgjIn2z5ZUfCuklG8GrijwG4P2fQTOXJykPinLLiFUnw+AiuefH3A
   /D5MiO7rS2mVZOofxOhqRCim+h5jjz6C61nU5+EkV6KzPPYDBaKmDgcDR
   g==;
X-CSE-ConnectionGUID: sD9ETKN6TBWeVLWJTFn+9A==
X-CSE-MsgGUID: D7as3LN5SwulnVFumi5u2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="64077559"
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="64077559"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 14:48:38 -0800
X-CSE-ConnectionGUID: WAiM3Ce2TxCyCU5Gj8R5Wg==
X-CSE-MsgGUID: wbjOuz/TRCa9JWfPAs6s3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="117187041"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 14:48:38 -0800
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 0/4] Add interfaces for ACPI MRRM table
Date: Thu, 27 Feb 2025 14:48:24 -0800
Message-ID: <20250227224828.306537-1-tony.luck@intel.com>
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

Changes since v1 posted at:
  https://lore.kernel.org/all/20250210211223.6139-1-tony.luck@intel.com/

1) Target /sys directory for the files moved from
  /sys/devices/system/memory to /sys/firmware/acpi/memory.

While the old target had a useful sounding name, it is really all about
hotplug memory while this enumeration is about different types of memory
with hotplug being a non-issue as memory ranges can describe addresses
that are reserved for future addition of different types of memory.

2) The ACPICA changes in patch one have been committed to the acpica
git repository and will make their way into Linux for the next ACPICA
release. Patch included here for convenience.

3) I included a "testing" patch that provides a fake MRRM table so
that anyone can compile and run this series to check things out.

Tony Luck (4):
  ACPICA: Define MRRM ACPI table
  ACPI/MRRM: Create /sys/firmware/acpi/memory_ranges/rangeX ABI
  ACPI: Add documentation for exposing MRRM data
  acpi_mrrm: fake for testing, do not apply!

 include/linux/acpi.h                          |   6 +
 include/acpi/actbl1.h                         |   7 +
 include/acpi/actbl2.h                         |  42 ++++
 drivers/acpi/acpi_mrrm.c                      | 185 ++++++++++++++++++
 Documentation/ABI/testing/sysfs-firmware-acpi |  16 ++
 arch/x86/Kconfig                              |   1 +
 drivers/acpi/Kconfig                          |   3 +
 drivers/acpi/Makefile                         |   1 +
 8 files changed, 261 insertions(+)
 create mode 100644 drivers/acpi/acpi_mrrm.c


base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.48.1

