Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF6916F296
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811831; cv=none; b=F9WVLNpYCsiRfNGFjgHDEynhWWb93CECFdSFuIu2pTqDAc/uumJgbUGtR+JtXq70wc5yjbQ6iG11nsnWrWcigc20zZ2JkM7PDjFPfZIPyyadulsmiEHCoI/GU/fSbZw27P2UDOBMNlLW2owLhA+TK1OKQdYtCj+jts0HJued/94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811831; c=relaxed/simple;
	bh=qTA6gl03vEuZNwR+0yktOI8EhYVtmjYM4Gw1yRj+4sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE7fyGlyaF9BRo/sNldQ0j2Mis6iRH+qQFXxSeMdixKb6qO4zTgj4CzAAoNVu+EBwQMwvKpbFfYgKHk+GMT0EZQkzRTvuzCDaopVb8ymSN4Mtwm+RkLayJkhAo0gXNF2Gueg3ONYDzF/f9HSJQqWnoxm4RTFxyuNS3aJwJcHpd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iC+U5IZs; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iC+U5IZs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811827; x=1747347827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qTA6gl03vEuZNwR+0yktOI8EhYVtmjYM4Gw1yRj+4sA=;
  b=iC+U5IZsx3EKg5OjWMoYJDL4XjOpvS+LtnUdRdUvSzJMenbMN7Mfmb0Z
   sNYkF79ak23IWOyv6UKckRMK/HKeEGKfSkfOyIgu9oKMb6Qni7WmcuLg9
   oYDasxXm8mE5yLRzEToO4W8D7N1yxd3wtizQ74r/OGYbNc6X8DTSCOjgB
   +kJz/a3JuUw4niG//7Sty6nDK9Mceplm4dfATATSSP828EabpF2+vMpFj
   797xUunQ46oSPkTBDa/qpbd2jyAlSvztjffF1ir5x4x790B+KG+UsIGwL
   WkraLX7xj+YPxuSYNzInWzGaia3OshDntM7chSdaD1dmFcpyoTPgTQiDH
   g==;
X-CSE-ConnectionGUID: 9SY9MnDCSfqK5SvVssGvCA==
X-CSE-MsgGUID: kft2xuOhQl+EgsSl+z2r2w==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671750"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671750"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:37 -0700
X-CSE-ConnectionGUID: gPDEvwLEQNusl5AbC9hXqw==
X-CSE-MsgGUID: yyvEtaVQTBO97Tpx2we+jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989202"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:37 -0700
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
Subject: [PATCH v18 17/17] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Wed, 15 May 2024 15:23:25 -0700
Message-ID: <20240515222326.74166-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

*** This patch needs updating for new files for monitoring ***

With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
per-NODE instead of per-L3 cache. Suffixes of directories with "L3" in
their name refer to Sub-NUMA nodes instead of L3 cache ids.

Users should be aware that SNC mode also affects the amount of L3 cache
available for allocation within each SNC node.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/arch/x86/resctrl.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index 627e23869bca..401f6bfb4a3c 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -375,6 +375,10 @@ When monitoring is enabled all MON groups will also contain:
 	all tasks in the group. In CTRL_MON groups these files provide
 	the sum for all tasks in the CTRL_MON group and all tasks in
 	MON groups. Please see example section for more details on usage.
+	On systems with Sub-NUMA (SNC) cluster enabled there are extra
+	directories for each node (located within the "mon_L3_XX" directory
+	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
+	where "YY" is the node number.
 
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
@@ -484,6 +488,19 @@ if non-contiguous 1s value is supported. On a system with a 20-bit mask
 each bit represents 5% of the capacity of the cache. You could partition
 the cache into four equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
 
+Notes on Sub-NUMA Cluster mode
+==============================
+When SNC mode is enabled, Linux may load balance tasks between Sub-NUMA
+nodes much more readily than between regular NUMA nodes since the CPUs
+on Sub-NUMA nodes share the same L3 cache and the system may report
+the NUMA distance between Sub-NUMA nodes with a lower value than used
+for regular NUMA nodes.
+The top-level monitoring files in each "mon_L3_XX" directory provide
+the sum of data across all SNC nodes sharing an L3 cache instance.
+Users who bind tasks to the CPUs of a specific Sub-NUMA node can read
+the "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes" in the
+"mon_sub_L3_YY" directories to get node local data.
+
 Memory bandwidth Allocation and monitoring
 ==========================================
 
-- 
2.44.0

