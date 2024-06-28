Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10D413774B
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 21:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611798; cv=none; b=poazrrMqxNinoidLFM3EOtBqm+gf2ZuTOPPB36WSspNmRvE1S0E7yhyQ1Y9mynv3q1VdEBh1W9JtjS6g3LgcIE7VsrK+zJ0G6JS0k80pF2lsCcetv08Zz/ljvsZTj1P0c5Uoav4ZET7EYbvu32UFiEjdQZnFRP/8RuvltIpbe/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611798; c=relaxed/simple;
	bh=fm2QZisifdMg+3x+dqCxv5EqypsHdl6yyTP9VR+uJyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvT2pBqVKXW3n/AxaVjVntxrYUotVxphxTxx5V0I15RLCzQTlrZO4Z9CZqejk8EW90D8vaxM0Mv6YZdsahiC6kulTZ8YBE1ftf0uoCQKDfENVuB7SNVb+Rt5I/Ix7gwSv6wSSHIqOil01buoH0Nk3L2um6xA7J6ogxd11xoZxN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PojRRDlb; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PojRRDlb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719611797; x=1751147797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fm2QZisifdMg+3x+dqCxv5EqypsHdl6yyTP9VR+uJyY=;
  b=PojRRDlbNuUiC4+AzC7VJXQnLrMFUCs9dlGZBXh57eeyPOzhV9hTc3lM
   VK7aHQMsXV2MTE5vqP3ExE6uX7trrElp6j32YIlvit1N5x1z3pux3AlVg
   J7RdRtR489Fi4AEpX6ctzvr0SMmB9ZBl4DxahZAX3kpil0bAqIbsJYRQz
   216JDx6KpASCRzNCWP5Oow3G5n+9nGVbwDJLYTi8ZZrUt9Ck0AbegzJoh
   Yf5zOqsEoaqfH1R8CwMKpc87RGr2pmS+eL1r9ggYs6gitZd9icsxm+7/Y
   F0Dcpu+8Rb0tUr5wvtLVzwbGMa2ETqjjLQzsnYeDbyMla98ya+KsxKebO
   g==;
X-CSE-ConnectionGUID: MXhxiT6MSRyAoPsJ7AiqYg==
X-CSE-MsgGUID: lKWMycr7SK6j/dCnMnhVXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16762589"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="16762589"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:28 -0700
X-CSE-ConnectionGUID: uWBR2WMUSv65y3+vnd5c5w==
X-CSE-MsgGUID: LXqVnXS9RXmzsxcXaL+iUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="68065660"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:27 -0700
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
Subject: [PATCH v23 09/19] x86/resctrl: Add a new field to struct rmid_read for summation of domains
Date: Fri, 28 Jun 2024 14:56:09 -0700
Message-ID: <20240628215619.76401-10-tony.luck@intel.com>
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

When a user reads a monitor file rdtgroup_mondata_show() calls
mon_event_read() to package up all the required details into an rmid_read
structure which is passed across the smp_call*() infrastructure to code
that will read data from hardware and return the value (or error status)
in the rmid_read structure.

Sub-NUMA Cluster (SNC) mode adds files with new semantics. These require
the smp_call-ed code to sum event data from all domains that share an
L3 cache.

Add a pointer to the L3 "cacheinfo" structure to struct rmid_read
for the data collection routines to use to pick the domains to be
summed.

Reinette suggested that the rmid_read structure has become complex enough
to warrant documentation of each of its fields and provided the kerneldoc
documentation for struct rmid_read.

Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 135190e0711c..681b5bdcd2f9 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -144,12 +144,31 @@ union mon_data_bits {
 	} u;
 };
 
+/**
+ * struct rmid_read - Data passed across smp_call*() to read event count.
+ * @rgrp:  Resource group for which the counter is being read. If it is a parent
+ *	   resource group then its event count is summed with the count from all
+ *	   its child resource groups.
+ * @r:	   Resource describing the properties of the event being read.
+ * @d:	   Domain that the counter should be read from. If NULL then sum all
+ *	   domains in @r sharing L3 @ci.id
+ * @evtid: Which monitor event to read.
+ * @first: Initialize MBM counter when true.
+ * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
+ * @err:   Error encountered when reading counter.
+ * @val:   Returned value of event counter. If @rgrp is a parent resource group,
+ *	   @val includes the sum of event counts from its child resource groups.
+ *	   If @d is NULL, @val includes the sum of all domains in @r sharing @ci.id,
+ *	   (summed across child resource groups if @rgrp is a parent resource group).
+ * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only).
+ */
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_mon_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
+	struct cacheinfo	*ci;
 	int			err;
 	u64			val;
 	void			*arch_mon_ctx;
-- 
2.45.2

