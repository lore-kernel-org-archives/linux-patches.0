Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F583431F6
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754891; cv=none; b=fwsW1bXL83qSIDfV5QhcByL+1ADCLqKI/mEcFHXIYOqqEaekGMJSPi3bTvB2Net7S6NDbUCoZ5iAgHPCpANH4L/z5YnQPqNL+Dpf4QwM4QX6xPV653IZuRGC0iGdX5E/V6iqxPp49l0K96Fl9aAk9oyu9YgiLywx+ZF0be/r8ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754891; c=relaxed/simple;
	bh=S9HaWzcxXMFw0jHafQiONR5gJD/44wXod7b+Cn3Qfb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgoTrZKIR4eMeHrNy2R1LA0vG83P+VgC6hQvpOJCufGS05gzB87wAdfmOH9UIrV/vaM6Fk1Ez/kr1unRpKZ9f7tJ3xTCPU0kDV9R00hDS8dXbp+4mVlSaiVpKvxaWBSk1GlUjJQBLcBH1mGjbKYidUwTEAJB/DrLlIJKYoywodo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j+uEmmp3; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j+uEmmp3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754890; x=1793290890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S9HaWzcxXMFw0jHafQiONR5gJD/44wXod7b+Cn3Qfb0=;
  b=j+uEmmp3twUOHqvwQaZjzej2rb3riaRSIcnL216Cg3wkhpTkohRk1z+4
   s57EaEbJRGisRtCgetxW5hEg+pHADzMzD3+Fbj+dDAXo3/FjqvSgP3Htl
   /eIjd/qVAcfOvCIj0n8OzpLWMV/wm7aiCW731ka+TL4t3Jye3/uDXiy/W
   LJp9IYQlVLrMphIqECGfju/IKnxfvtv3fMKes8nvFehLuMFSeC7sW170y
   dCNFAlYwUzWpboxg6cySC5lf4Ye3VdJx1Y04Y7LqcCHkk5b0QTHzBY7Ls
   CRsuXmQ7omN/ShziuiQ15aU/1MvtKF3Y4GuryZONSZ7w+zRj8WW4MLESB
   Q==;
X-CSE-ConnectionGUID: 1UPgumebTPqd/sIdgygfqQ==
X-CSE-MsgGUID: hpOryw+0QIy8ADHEz/iZwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481316"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481316"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:27 -0700
X-CSE-ConnectionGUID: 6J4fzmZLQzK0wzSOahtzRA==
X-CSE-MsgGUID: bEORkgDFSamnQ59yZ1nUkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901314"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v13 06/32] fs/resctrl: Split L3 dependent parts out of __mon_event_count()
Date: Wed, 29 Oct 2025 09:20:49 -0700
Message-ID: <20251029162118.40604-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Carve out the L3 resource specific event reading code into a separate
helper to support reading event data from a new monitoring resource.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/monitor.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 572a9925bd6c..179962a81362 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -413,7 +413,7 @@ static void mbm_cntr_free(struct rdt_mon_domain *d, int cntr_id)
 	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
 }
 
-static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
 	int cpu = smp_processor_id();
 	u32 closid = rdtgrp->closid;
@@ -494,6 +494,18 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	return ret;
 }
 
+static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+{
+	switch (rr->r->rid) {
+	case RDT_RESOURCE_L3:
+		return __l3_mon_event_count(rdtgrp, rr);
+
+	default:
+		rr->err = -EINVAL;
+		return -EINVAL;
+	}
+}
+
 /*
  * mbm_bw_count() - Update bw count from values previously read by
  *		    __mon_event_count().
-- 
2.51.0

