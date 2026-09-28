Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FFC503902
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633741; cv=none; b=eFWHZY9vbypo80Me9Dnb/CcGd08YxwVuFHBir+msIUCeCdkxiNP8rw2wcwJzxKPfajYFJGkYuxRB7FPiCnFmFoZqjTxMQ0ahAClIXn5EcfXTbYmJ7Mr7JE7SwmssBT4l0xUkCIEUOgw6PYBrFXBYcQFlwni9ddEOs2E5hLpOfjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633741; c=relaxed/simple;
	bh=R/bZL9/i7VtvxOOoAHBt/F+3fVEIN+/aOaIsm8jgjUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDbvvCsbYZdp8Nejl6jH/LlibZheB+8t3FWQJmkp5Qk9AHKYyc57hO7qdtDQixeSPoiujRPDKeIoSOeepla1iFGq/ALcnRmMn2xG65SjS9fA8sW54Xpsc1/IZkXNIBHSjLiBMgPhhFph0FBBRpV9fq6rU4ZBIIOQ0G2DF4BHsAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VQjLg9cS; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VQjLg9cS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633738; x=1822169738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R/bZL9/i7VtvxOOoAHBt/F+3fVEIN+/aOaIsm8jgjUo=;
  b=VQjLg9cS7gWBAf+2sqWCxJXAsZnlP7/N82B0pGpf1xv4N43LryLoUfaB
   lWY6fqATHsId07ge7gKbDfavCi+pNxwHqLqGjt375OdsjDObAzB//Zkul
   Sbe/2U4CnrpEVCMcSadTaUqiQIgAfIZK+NlBl8i8QrR3ZzuCl6Lwp3TdS
   ApE9MGPZ1k3li3HTkoIx2rCInQ7CE+G8N8Tl4uJjBBX8dNV4hiAEE6e91
   V+MiKgCi8OX6TLy3hknOyaJkIgwbiADeDAEqcdcclP9EgY4tK55Vw67Oe
   IHFGXSxIHB4WeX4Hiugdp7uAIJHaU3qcN7rx6SahOwPMSFtsxect8coj8
   Q==;
X-CSE-ConnectionGUID: ziBPCPq8RK6/nqKIi3/EOQ==
X-CSE-MsgGUID: IHLKXppxTKmF1a1MJjKe8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387245"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387245"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:19 -0700
X-CSE-ConnectionGUID: zHfXL/DjQMihVdd4rsKjAg==
X-CSE-MsgGUID: Anp5SF25SuW5edB8U2CWqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685496"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:18 -0700
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
Subject: [PATCH v13 11/25] x86/resctrl: Honor rdt={perf|energy} options to force enable AET events
Date: Mon, 28 Sep 2026 15:14:55 -0700
Message-ID: <20260928221509.68002-12-tony.luck@intel.com>
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
v13:
	Update subject and commit comment to reflect that this change
	applies equally to rdt=energy.
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

