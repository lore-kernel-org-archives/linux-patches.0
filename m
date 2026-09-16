Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57C54E4316
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600423; cv=none; b=NlaQ4egP8M+KDlzRHm4kVuO3AmIbSFRqvVJ6PUBbnOU9TODZOM7fVbRIBjEcykN28h5oRsW4aOqs9ruE9Y77KkuncxXUwJRvU2oe3N1g9m7vsFa3jU9yNZDts+TtRyXotNjxRls+Wmuh2fMX0yi5B03f3Qog5iWldeMam1bOq2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600423; c=relaxed/simple;
	bh=GcxFliNTIAtRq7uiuS+67NRJavF9d5TyAC+yRtsjs+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKG/T6139RkSU8iB9GgYZTwSS76fMlyJhIJAfpjd50MlxhpytSx+OODq5vwQodYYKsNzrZLSVrQSLZcHwCUeyg8nTOzVtuwTI6VtJVpyJRJchPkq4al9AJ5MM97RjCwdtlKEK0ipUqWKYBaQvMYvNc76cA1ZNxZYcY1e1fE6y5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yw5u5Re9; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yw5u5Re9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600421; x=1821136421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GcxFliNTIAtRq7uiuS+67NRJavF9d5TyAC+yRtsjs+4=;
  b=Yw5u5Re9lD8xCRyDnEgUW9jzYtOIPTJlEaxV74YnP9BL0oM9YfdEUEb7
   /e2MRIxnxKeqbxtjvH6bShiBBIO/yBsWm7pc3ILPCJt0cgyLnDc34BAkH
   jb053XMqZ14Mgl02AskG/IcuPk5nJlDHcwoBMxlZkcW3flc7nZKFlYYBB
   YhqNVAHe0wbcuyT8NdKrCITYkE+1TgxPVvtyeuvW4KOjL9nhh4qg3+qJx
   3u/xDVSSFF3a/eq5CLeHm2mQCSuGK52+6w1r3JznypzmCIutLieiZRTai
   KRWtVJ7SFzOP21cAgNyjquXj02qEnG05klVfzNNeQMg8NQozNOzwqjhnb
   w==;
X-CSE-ConnectionGUID: pu5RJoDjTmaUaf6sa7b6dQ==
X-CSE-MsgGUID: DQnNwpY5Svq32MvRBH6L3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861405"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861405"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:35 -0700
X-CSE-ConnectionGUID: mXegwrkSScyepjynTHED1A==
X-CSE-MsgGUID: kZgJRk6XQJ2jWjiMlOShMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231459"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:34 -0700
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
Subject: [PATCH v12 10/25] x86/resctrl: Honor rdt=perf option to force enable AET perf events
Date: Wed, 16 Sep 2026 16:13:05 -0700
Message-ID: <20260916231320.14502-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl can disable ("force_off") a feature supported by the platform if,
for example, there is an erratum related to the feature or, in the case of AET
(Application Energy Telemetry), when the event group has insufficient RMIDs. The
"rdt=" kernel command line option lets the user override ("force_on") when
a feature is disabled in such case. Users may also disable ("force_off")
individual supported resctrl features they do not need.

Linux enumerates AET once on first mount and skips this enumeration if
the associated event group is supported but disabled. Since AET is only
enumerated once, this check is guaranteed to only consider disabling via
the rdt= kernel parameter.

However, when transitioning to enumerate AET on every mount, it is no longer
correct to skip enumeration simply because an event group is marked as
disabled. It is then possible for resctrl to have force-disabled the event
group during an earlier enumeration due to insufficient RMIDs, which would
improperly cause the kernel to ignore a user's explicit rdt= override on
subsequent mounts.

Ensure the user's command line choices take precedence over system-level limits.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	No change
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index c22c3cf5167d..4ad6ad78e93e 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -228,7 +228,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int skipped_events = 0;
 
-	if (e->force_off)
+	if (e->force_off && !e->force_on)
 		return false;
 
 	if (!group_has_usable_regions(e, p))
-- 
2.55.0

