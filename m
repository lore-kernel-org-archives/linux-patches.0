Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC3417C9E7
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009564; cv=none; b=HLC2fPXM0h+JhAUqCa3BH5qqBvtIPOfGQbRCRbWq4YxzAvIOvimZNfBHokT6fftRPv17Oo0KqF72oripyCit9GqxhElFwQUYuDJDB3FwZMlRYW0u4EFqLr/vuwFcp9JbX/6AEpIwkk5FyIkeNtCLdnaUBR72OIQxlsXsKPqkH70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009564; c=relaxed/simple;
	bh=2l7f6lDOELlYeE6YGD7wOuDWjXUX38xsa3dzLbcLFzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWl8mAprHIDhwRkvgmlE6uM0OukbSk3/2s1xIRqikX4ILImUibQCgZgpCEmugID+6Uzer+cqRYe8CySQAbZiYFNWKgCAPOaDtyUUNGtoeaj9W843nAxG/Ucn945KlaKW1pUZIbEZibu0Aw/m95xA9OYP24qhaz+8AbE1JtPsLXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=luAahNR6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="luAahNR6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009562; x=1750545562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2l7f6lDOELlYeE6YGD7wOuDWjXUX38xsa3dzLbcLFzk=;
  b=luAahNR6wIXNA33AL3QUpcE+i/tt/QWxC7nZQxhW4ac9zJpIBtkDDWIe
   Z8eNa44YYnxTzgAZytq2wPRhv2pDLGgB7n3DsKuJbhhu2JY9WfyDOpHm0
   D+LzTm856M9cHxGlqIg2zIXZUYLPjkB0KhUXUlNTKtHObVi7FdO4ceXOw
   BFMMp5IxOAKRsRv5LhPTCzm7B/UGnqduGxrAZN/G5dprclsP9egOAgzHj
   9kxLE6/1J0WL8pyaSr1CkB6z+SMp/p/pABT30AaEzQojjjrXZzwsJxAyI
   WoX97kLaFxm8pa5NAqgQ7tlnambrE7WGzT5Mx2Ci21ArlrEcmU2Evpcqh
   A==;
X-CSE-ConnectionGUID: HLBiAZYpSHeslUi5XKvfDg==
X-CSE-MsgGUID: G2I2F7y1S/aflb8jlQBLfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691377"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691377"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:09 -0700
X-CSE-ConnectionGUID: PaRqZGfbT0yLJhHV7AJ7hg==
X-CSE-MsgGUID: +ueKP6e6Q5iQ4+/I4tNCuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935696"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v21 18/18] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Fri, 21 Jun 2024 15:38:59 -0700
Message-ID: <20240621223859.43471-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621223859.43471-1-tony.luck@intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With Sub-NUMA Cluster (SNC) mode enabled the scope of monitoring resources
is per-NODE instead of per-L3 cache. Backwards compatibility is maintained
by providing files in the mon_L3_XX directories that sum event counts
for all SNC nodes sharing an L3 cache.

New files provide per-SNC node event counts.

Users should be aware that SNC mode also affects the amount of L3 cache
available for allocation within each SNC node.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 Documentation/arch/x86/resctrl.rst | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index 627e23869bca..a824affd741d 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -375,6 +375,10 @@ When monitoring is enabled all MON groups will also contain:
 	all tasks in the group. In CTRL_MON groups these files provide
 	the sum for all tasks in the CTRL_MON group and all tasks in
 	MON groups. Please see example section for more details on usage.
+	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
+	directories for each node (located within the "mon_L3_XX" directory
+	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
+	where "YY" is the node number.
 
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
@@ -484,6 +488,29 @@ if non-contiguous 1s value is supported. On a system with a 20-bit mask
 each bit represents 5% of the capacity of the cache. You could partition
 the cache into four equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
 
+Notes on Sub-NUMA Cluster mode
+==============================
+When SNC mode is enabled, Linux may load balance tasks between Sub-NUMA
+nodes much more readily than between regular NUMA nodes since the CPUs
+on Sub-NUMA nodes share the same L3 cache and the system may report
+the NUMA distance between Sub-NUMA nodes with a lower value than used
+for regular NUMA nodes.
+
+The top-level monitoring files in each "mon_L3_XX" directory provide
+the sum of data across all SNC nodes sharing an L3 cache instance.
+Users who bind tasks to the CPUs of a specific Sub-NUMA node can read
+the "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes" in the
+"mon_sub_L3_YY" directories to get node local data.
+
+Memory bandwidth allocation is still performed at the L3 cache
+level. I.e. throttling controls are applied to all SNC nodes.
+
+L3 cache allocation bitmaps also apply to all SNC nodes. But note that
+the amount of L3 cache represented by each bit is divided by the number
+of SNC nodes per L3 cache. E.g. with a 100MB cache on a system with 10-bit
+allocation masks each bit normally represents 10MB. With SNC mode enabled
+with two SNC nodes per L3 cache, each bit only represents 5MB.
+
 Memory bandwidth Allocation and monitoring
 ==========================================
 
-- 
2.45.2

