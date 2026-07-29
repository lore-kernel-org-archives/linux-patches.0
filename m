Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E4B36A37B
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346087; cv=none; b=CcAJYvGfvwEysi8PHSgELUGaJYvnKUR6oJb0txsBebCmYkysnbiDyokMpdVAuOUBLYpkXfiMjYME3BMi8hP1PeDI85DOpd0pJa+oA5uBIhDUHlmh4kWdYoBen8hAd4KBqhhxwGZIp765WW5w/+TLXhZdowiaA3ANDB8jSnf09C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346087; c=relaxed/simple;
	bh=NkhxnrVCgBoJtNMZcboVTETYbyHJChCrveIGG964THw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g37IqIl83VdJCJ4VneqvQM7h2j9XxZ8JQd1qRzo0qEwQeZQA18sBBdPa5SdMLw4M7flnoooOZiycNqzs8jV7YUkBanGziQGoVbZFW7hk26MNFASbUvUjESuNI1v7jlkzSTe+zR8WrRqY9IwhzlTZYdIi+OhppkwGaioorD2jgcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZsL5ZEQ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZsL5ZEQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346084; x=1816882084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NkhxnrVCgBoJtNMZcboVTETYbyHJChCrveIGG964THw=;
  b=RZsL5ZEQ8fI2qL+0VaD/gkDenDeuLsLMHVzK48HsTdW5XK2ZQTlu8jV1
   e2doT7G9QOGAowLWxcIGgjUStI96etXjYrieaoiM8+KrepAtDtqOMoAet
   xYv0yJf34LSNg/MGq5kGdgZUIr7sB9jgSsI/v6szh++IqNM8Nq/nFHxwF
   pNgQdI4103uJO066GFLlg5swiV3h6TFtWqFRhW83A8s4yirOve98TOYxI
   OLxEU44xMsplCgK8au7P0ra6YUFvOB6P8sEkekiJKnPfI5JazhnE0X13R
   yPp3JzEzQXVd80tpoLIBKqEZbrFpyHV/md58134b/EXo5jMejb38Nhrj/
   w==;
X-CSE-ConnectionGUID: w4dsESYcSOSTCCbiNywJlQ==
X-CSE-MsgGUID: 1VlxB5qlTyKMlAqMU+dNxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473581"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473581"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:01 -0700
X-CSE-ConnectionGUID: s9moVI4zRsSK5eFa+a9o4A==
X-CSE-MsgGUID: NxA1NHXrRZiJsy6CE1HMjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024556"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:01 -0700
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
Subject: [PATCH v10 04/17] x86/resctrl: Honor rdt=perf option to force enable AET perf events
Date: Wed, 29 Jul 2026 10:27:39 -0700
Message-ID: <20260729172752.11561-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
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

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	Rewrite commit comment based on Reinette suggestion
	Dropped the change to event_group::force_off kerneldoc

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

