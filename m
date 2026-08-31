Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5C3ABD91
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198275; cv=none; b=RYqvEJ0pK6Cuj4QR5p6rmI6bFqiAgBhahqSyD7b3fhdfcoQA+yJncqauHLWCQRWFCyI0K/4roc/vHOqYszzLbh0a3ESTkAmpYFSsZ0uSgu9TbUPDdwhXwZmbl0j5vBShnwr1goxKhNS82XOEHhkmhVjDANudxvXwsGyuVSHGE38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198275; c=relaxed/simple;
	bh=rtXP+ZV+ZhfZyGXoj7bFm+8ohjVE+0kKIObjn4xX2T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okTvSSQ+SllkSCkqcBfhiknp09RqC9jUhuoAJ4VWysfD94z9qTuUtl3Siu99DIxNTg+OSlu0qp3xI20/I4ReQXICF/6v8fmAr1v09U7BddVkv79spfA4uToYmI2+km3+xZRjvgBbzS0MnvEQMna+FqSSiyJdOjjSa5wMREEVNPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JLDSHTx1; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JLDSHTx1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198273; x=1819734273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rtXP+ZV+ZhfZyGXoj7bFm+8ohjVE+0kKIObjn4xX2T4=;
  b=JLDSHTx1iDZRj+onOPJ4JBb2RQS3W6Ebzf4WjogF5j1xqVuBT7mnKGxz
   wFyBI8KNbr/7gemhe5hEay0WWG458bYdPI1cNbpVpVvHuqGxnFC66g7YL
   qA9DFL3CFL/T6mZwp3OMo9LH28ZU0vubnZOK7XhikFDTLZUu/nq3/xyIA
   cEz/E7d40ojsktxy7ERAJTGv+STyPIx92nWnBhy2nEUHzzpkyKBWHSbjr
   jWr5ozOeoXvXvXXIPo5fW/jyOxiKCNVjGVAS0VUjIHo82zWxjqmhF82dc
   akItf7+aRnMf6scemu1DAQgrgkiUEk66NLnXgyX01B49Y/ggzcCkdJGYG
   g==;
X-CSE-ConnectionGUID: B2ZaLEIDSvi6DKFj2RTnGg==
X-CSE-MsgGUID: UC90yREZSXy/c6mB8ZYP7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92479906"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92479906"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:32 -0700
X-CSE-ConnectionGUID: 8d68QUxvSMKsXDWy2/9xmA==
X-CSE-MsgGUID: BcaPZNCtRiuE/1NHI5wk1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906944"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:30 -0700
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
Subject: [PATCH v11 02/23] x86/resctrl: Check if monitoring features are enabled
Date: Mon, 31 Aug 2026 10:44:00 -0700
Message-ID: <20260831174421.13921-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both Intel and AMD manuals say that software must first check
CPUID(0x7,0x0).EBX[12] to see if any monitoring features are enabled
before checking for specific features enabled in subleaves.

Each of the L3-based monitoring features is gated by X86_FEATURE_L3_MON

Add check feature bits.

Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	New patch

 arch/x86/kernel/cpu/resctrl/core.c | 33 ++++++++++++++++++------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2435eddd24eb..fcbecf677914 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -968,20 +968,27 @@ static __init bool get_rdt_mon_resources(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	bool ret = false;
 
-	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
-		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
-		ret = true;
-	}
-	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
-		ret = true;
-	}
-	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
-		ret = true;
+	/* Any monitoring at all? */
+	if (!cpu_feature_enabled(X86_FEATURE_RDT_M))
+		return false;
+
+	/* Any of the L3 monitoring features? */
+	if (cpu_feature_enabled(X86_FEATURE_L3_MON)) {
+		if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
+			resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
+			ret = true;
+		}
+		if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
+			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
+			ret = true;
+		}
+		if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
+			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
+			ret = true;
+		}
+		if (rdt_cpu_has(X86_FEATURE_ABMC))
+			ret = true;
 	}
-	if (rdt_cpu_has(X86_FEATURE_ABMC))
-		ret = true;
 
 	if (!ret)
 		return false;
-- 
2.55.0

