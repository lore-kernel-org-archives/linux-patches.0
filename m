Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F2F3859DC
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851543; cv=none; b=ErjcTpGt3ScBqZcofBklqnh6tkz9/Fky8Q/ZYgjc6VOciZOxCQ8UYB7QCdaBtkRCC0dkgqwAQIvFr/KQGEcEb/UHeTl1ECJFkmOOS3kzzXFvYnmvGLE1wTmuq5/lbVeKinIwg5JdA6NQB8YYQSFrbnTcr5VxxefeuSqEoim6xLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851543; c=relaxed/simple;
	bh=TpqgBuTQel4V5/BGOHX3wAgyHeUcGtOmEJQ2AKSmzOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3KN+x1Q/Z09HVTTTFFc1jwDATL/UVdbRdjHAfR5t4CxdEh4eFDfDZpnX1FrKD99x8aVlQ/8BrJCLisoHQezK01sNEhhub+drgURl+urByx8axShkIeoPlXXx5vyzbAf6aQ26EWI28bm2iN82xaAIWAFn3Shr9ySaXnabATGpNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AsSpZrCw; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AsSpZrCw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775851541; x=1807387541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TpqgBuTQel4V5/BGOHX3wAgyHeUcGtOmEJQ2AKSmzOg=;
  b=AsSpZrCwsWje5iKA4D1KPQFi4Mip3xtudK6oTW/eP2cRbir0WD/F7xat
   4oRKVSXLCIwpPCAQNfpacaqqXjJv1WU67ZrJIIIDPIe4SZohel8kx2rmn
   Zad/KtMZpBUYrlDTvL0YoL6rcmqsJiZVTZslUqN/E7NOuZVdGKAqAvbG8
   6Y5r0vkcy+niSSYqd58z07bbZ1zoTTy/V0l5wI31pcw1kK8j9p3oLqHBk
   hmOaLbTOFHVqdjnOdpGr5VpOekzwPHfkx0EnTi6EKjYR79iadNSSGkWWL
   3aaQPSV25IKjxry+FFK2i9n2mGFSdSUXKdqxegzUaZNKIQz7GsNn4OsWT
   w==;
X-CSE-ConnectionGUID: 7w06vap4S429p25d35xxmA==
X-CSE-MsgGUID: 9Q2MU5HZQl21/KNtqAJ+iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76898061"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76898061"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:40 -0700
X-CSE-ConnectionGUID: RAow2HSwTw6pLENSIsE6EQ==
X-CSE-MsgGUID: n0RpBQcMTnCXaCWFyY2vyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="228155001"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:39 -0700
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
Subject: [RFC PATCH v5 1/7] x86/resctrl: Stop setting event_group::force_off on RMID shortage
Date: Fri, 10 Apr 2026 13:05:26 -0700
Message-ID: <20260410200532.58602-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410200532.58602-1-tony.luck@intel.com>
References: <20260410200532.58602-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the force_off assignment from all_regions_have_sufficient_rmid().
This preserves current single-enumeration behaviour while preparing for
the upcoming per-mount enumeration, where latching force_off would
incorrectly suppress re-enumeration on subsequent mounts - even when the
user explicitly requested the feature via "rdt={feature}".

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 89b8b619d5d5..e2af700bca04 100644
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
@@ -214,10 +214,8 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
 		if (!p->regions[i].addr)
 			continue;
 		tr = &p->regions[i];
-		if (tr->num_rmids < e->num_rmid) {
-			e->force_off = true;
+		if (tr->num_rmids < e->num_rmid)
 			return false;
-		}
 	}
 
 	return true;
-- 
2.53.0

