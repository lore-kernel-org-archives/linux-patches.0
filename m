Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FB750AC38
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633758; cv=none; b=IiECWCJz9aEhk3MtWpLrTkMblT9qh69D9i8ML4wQw9zHWc4j+Ogm4/g6AU7KsQBAUaj18x2XInSDoT20jlpj5tSLbwd+O67mwIvmzGXxA1rB1nmLfSoWQbgrkaPnTPgXXMS4kKmjEd47wYC/Lqa4ec1Rp1bo6qsMmnLAUDym/Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633758; c=relaxed/simple;
	bh=HRaGWkms3o2AV/USNZBUgC1MVEPrSsotLJzEAs7VjQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMIgRAWPbdY+yIsPJSv+p2yfeAVVPVd9ljxdLAs7cJbKmFsMXzzufPWFCDzCTUzJ5B3mSYG4msXaQ+2oorIr+aYqBgdckZf+dz1uGJ42EEDPF1bCTxKQ/TuuTUSIqR2RcCKNeCv16J/XB/tXA9s7lpjh75adO2ghHqVKNxSxcR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GeDWrzBz; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GeDWrzBz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633757; x=1822169757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HRaGWkms3o2AV/USNZBUgC1MVEPrSsotLJzEAs7VjQ0=;
  b=GeDWrzBzcdeEfcVR22fvdSbGQXqpX8rAVTPGr4yogNmfOYoVymAc4ctg
   XSXMbxxsR6xdk92kzC9oJOb3vCUREso75oIFmFrGYhslC21BRK5ExhB1v
   yxs4xUk72qkzfJZGgD4qgP6lbfWmcUD7xTbGZvSyPszI2Clk0mLvD3yHN
   9zWz2AqNF4hzMAm7kA+DUT/RPEPN1W4WGS7hTUxXXq2CywneeJR7tzcvR
   jGrH1qoOV4zVkMGEAgxpSN6yp0IviXyz24Rdr9Tr65ZLy77lpIY+g6mtH
   XgN4zlV4cJXNAMKdhmTekb4YF0r13aY0/k9xQ8DUv2eP+6SfzwWZkL2uO
   g==;
X-CSE-ConnectionGUID: 5U47IJT/Tbmk8dS7OsZ63Q==
X-CSE-MsgGUID: iMjy9ra3SvmbcGjxK/THtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387382"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387382"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:21 -0700
X-CSE-ConnectionGUID: ey560ApjQ8SfoX68oi0eEw==
X-CSE-MsgGUID: 8jxHqtqjTdOjzifYcBudgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685555"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v13 25/25] x86,fs/resctrl: Document telemetry mount timing caveat
Date: Mon, 28 Sep 2026 15:15:09 -0700
Message-ID: <20260928221509.68002-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PMT driver enumerates telemetry features asynchronously, so an
automatic mount of resctrl from /etc/fstab early in boot may occur before
those features are available, resulting in them not being enabled in the
mounted instance.

Add a footnote to the 'If telemetry monitoring is enabled' sentence
explaining the race and providing a solution.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Drop the "Mounting resctrl with telemetry" section. Include the
	solution in the footnote.
---
 Documentation/filesystems/resctrl.rst | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index b52795e03303..dcae1076f863 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -629,7 +629,7 @@ When monitoring is enabled all MON groups will also contain:
 	each instance of an L3 cache. Each directory contains files for the enabled
 	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
 
-	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
+	If telemetry monitoring is enabled [#]_, there will be a "mon_PERF_PKG_YY"
 	directory for each physical processor package. Each directory contains
 	files for the enabled telemetry events (e.g. "core_energy". "activity",
 	"uops_retired", etc.)
@@ -668,6 +668,11 @@ When monitoring is enabled all MON groups will also contain:
 	returned if the MBM event does not have an assigned counter in the
 	CTRL_MON group nor in any of its associated MON groups.
 
+.. [#] Telemetry features are enumerated asynchronously by the PMT driver, so
+   an automatic mount of resctrl from ``/etc/fstab`` at boot may not enable
+   them. To avoid this race, defer the mount until after the ``pmt_telemetry``
+   module has loaded.
+
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
-- 
2.55.0

