Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3FF1C8FA3
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611803; cv=none; b=Hv/ZAqaOWlw/HZwJdYHXzJOBJ+4q84wo7+nvuQq1Fm1EWV7pK5+1uGBqu+hiNby3hUzEMTlIP/14th4RByGh3+P53o0M/B6RPYX+tLsYltTem12/oN5LN9dxrd0tTMi8plj4MKAzQmZjGB2ptUoDW0NXnlK7Qa1wMu/FfaXAvsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611803; c=relaxed/simple;
	bh=2l7f6lDOELlYeE6YGD7wOuDWjXUX38xsa3dzLbcLFzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqjjIoIdN+CJuTyhHK8M5hwFh6ltpCUTvkS0fK+xRD89693+D0k1xj0TGACW3G5Nz/0vCmEKe5NjLobobgKwtyx81vv2tvh16UCkK7YY9CyNDuSKva2eF/wW9um8vBenJPQQr1K9ChSLGveTmzYQG05v6hEr5wqCTYOE32PJdPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bmYaW8l0; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bmYaW8l0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719611802; x=1751147802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2l7f6lDOELlYeE6YGD7wOuDWjXUX38xsa3dzLbcLFzk=;
  b=bmYaW8l0tlkgleMPOAiPW6ps7uagR3iOdaH2XvcFu3LO7ne26OYqag6f
   bAFxoPi9hSBcT+aiZGdj5rboL/LNy92k0us20XwmtpCI/ywO5Ignfuv0F
   qhG0oaHut62SmbOC+4cjSswyFQiW51MJsIilL+BDjgxz/2vOCa+Ypn1jV
   tg5wibNsHYsPY0Is1leWKfaIE9gLPNo08hvKuUCS6li1j019hzIcP+8MM
   FWV/6ccSiCs841mAw8iLQsHxP8KvrpsE9aHwukzEyCMH93KSjKLJ4PtiI
   0zN6L3n3eNt6H51/9wVz3aiXsEd8QBUlfiDVUu6NeW8NPI1jMsWGO/JvU
   A==;
X-CSE-ConnectionGUID: lj9J9Qr4SKC5mKRaMFmadA==
X-CSE-MsgGUID: m815BxVkRsySmpaVrEMcbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16762661"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="16762661"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:28 -0700
X-CSE-ConnectionGUID: CiKeyujKT6mFC6FPuFRhAA==
X-CSE-MsgGUID: 5XLIWAw+T32RV/vwacZ9tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="68065690"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:28 -0700
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
Subject: [PATCH v23 19/19] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Fri, 28 Jun 2024 14:56:19 -0700
Message-ID: <20240628215619.76401-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240628215619.76401-1-tony.luck@intel.com>
References: <20240628215619.76401-1-tony.luck@intel.com>
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

