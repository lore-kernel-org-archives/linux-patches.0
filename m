Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F643A6B8D
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941765; cv=none; b=XuR57kaBEBA7AMb3spkX4+QHTv+K28ZKM/q/g+w4cEhmT3WnnlM1IDCGLmycd3sYpgQOGERZOhZRw3GoBMMrpnkZFHwXZyd1YWstOL7IuhwsbB0Vz+zaZf0tGAh2Gb2DwD+H82IvEEzQCCxNCydFTKhW0r6OPJPpJxBv6XvbWIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941765; c=relaxed/simple;
	bh=lofdQoyRzrGjXcpLhosBO5YHSdcqvd3I+aoQEcXfbBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYHGpy4Bz+vdmehznN1uo5lPlFSWVGzeT/ss0rLWCjzUURn27H0aGQT9pBF9mI797GlkOn7pbs0JHxtIABXKxreOwXE9IsE31Ho3RMuqlCTO5Qi/c7CoXSfJtNb2NbA01wYo4dlmWV5oCSKu+MOJLX/wRt/UNePJCm/aeNodydI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bvT7hXp/; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bvT7hXp/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941764; x=1814477764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lofdQoyRzrGjXcpLhosBO5YHSdcqvd3I+aoQEcXfbBw=;
  b=bvT7hXp/Z7JXwTDIQm8R2A6SBK57Wt2NbJlZq8wy4A6uSMZAcltRtdj4
   tA3NWzp2D1JwsbBj9fsLnqJpHtNNbE4RDXGRQmTnecFA+VTFvhMbcS0CL
   IgUvP5XDcikgXNiYqViOE92iFEgt6a0CZWvFC7ZdfBpitVEmZ6au0t3c6
   akdJ2O3JrgyjYbX7XAuifix05NnkDslHoYOmXjJlbamOuG6uKXRSYRizj
   AoodlBqUeFeKs75rQHxIb/DnPhbe8efh8HH+vFi4gJ4PfZ7UsxPaaUn1K
   HCYTFpa5xUteyPO3mLZALaogCJl86hv/NWHId3mxHKWFu+6YGjm+j57SQ
   g==;
X-CSE-ConnectionGUID: 3gaSJI1iRau7gOYDyGS9ag==
X-CSE-MsgGUID: ruwaq2uQSmCudjSSTqo3Iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285769"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285769"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:02 -0700
X-CSE-ConnectionGUID: we0R5oYZQiCBEuYhfFcGDg==
X-CSE-MsgGUID: 6ytAqTr7RE6p6tHrUVROvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242526"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:02 -0700
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
Subject: [PATCH v9 03/12] x86/resctrl: Honor rdt=perf option to force enable AET perf events
Date: Wed,  1 Jul 2026 14:35:44 -0700
Message-ID: <20260701213553.15222-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel command line option "rdt=" is used to force enable or disable
individual resctrl features.

Linux only enumerates AET (Application Energy Telemetry) once on first
mount. But that is going to change to enumerate on each mount to allow the
pmt_telemetry driver to be configured as a module, and allow unloading when
not in use.

The following scenario will be a problem:

1) User mounts the resctrl file system.  all_regions_have_sufficient_rmid()
notes that a perf telemetry region supports fewer RMIDs than expected for
the event_group and sets e->force_off = true. But the user had specified
"rdt=perf" on the kernel command line so perf events are enabled for
this first mount.

2) Resctrl file system is unmounted and later remounted.

3) During this new mount cycle enable_events() sees that e->force_off is
set and stops enumeration for this event group. So on this second, and
all subsequent, mounts perf events are not enabled.

Fix by checking the state of e->force_on at the start of enable_events().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index c22c3cf5167d..cd8257c58f84 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -60,8 +60,8 @@ struct pmt_event {
  *			data for all telemetry regions of type @pfname.
  *			Valid if the system supports the event group,
  *			NULL otherwise.
- * @force_off:		True when "rdt" command line or architecture code disables
- *			this event group due to insufficient RMIDs.
+ * @force_off:		True when "rdt" command line disables this event group
+ *			to avoid system limitations due to insufficient RMIDs.
  * @force_on:		True when "rdt" command line overrides disable of this
  *			event group.
  * @guid:		Unique number per XML description file.
@@ -228,7 +228,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int skipped_events = 0;
 
-	if (e->force_off)
+	if (e->force_off && !e->force_on)
 		return false;
 
 	if (!group_has_usable_regions(e, p))
-- 
2.54.0

