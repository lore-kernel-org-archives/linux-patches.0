Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BF647CC74
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198282; cv=none; b=hq6dAzh6Rj0STO/Z8MHSFwgjvk0LTc7T2pjlT1p7HnmBjBD1hxXjsQW6E7a2DE7+fovWQMNcN4Xt/bEUX6EFkdIPaUe6JxeeHCOj0yzXGq8H7FAgfM/8vvll2EP8uL78mYfsVg/oVwJ2Nz2skYI+cPcME8AzB2R7CDzZxPW9+g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198282; c=relaxed/simple;
	bh=mAzQ71BhAUoGeMnhg82LIMQq95rZ3w48PFxb/i/5Bf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5/j8Qw5X3RhUIcA+VtQ8Dt6z8FnOSNOCtZAYss4GX2oXQ2o6Si0jsNkwWavIHwn1ys8r5tr1sIei66Pvy25r7CN/dcvmJUX1in6ydKPr5NMpe5AolZSJT6WctnPCoLw/kIjAHzBGSESMayh6wW92cpbdkwPrqdFkfhwu/YMao0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kjx05zip; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kjx05zip"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198280; x=1819734280;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mAzQ71BhAUoGeMnhg82LIMQq95rZ3w48PFxb/i/5Bf4=;
  b=Kjx05zipoCxcHmHczJmiapsuJ8tcswtgchTJZZJoeR6P4Uu8bzTHqGqa
   X+K11AmhZ3Nd0XeHobg2nTYJ9TY5r+QQEOhcATdR0TR0NP3laNceplCzX
   QmGA61KqoElQKrpzsYlmlC5FmHJvADKoABxaxu2nuTLj66ZpqhfJcgZnT
   5PoXp1iKe5CEbS9J4hjlWbyTj5kjqHj5rkoOHFW8XYVp2wdw8EZgkF2Wy
   OXuanbaSvWT1bjW9LFfn58e/2ENytp9ohYjjYvCVJxF10urVkmyzoo3mW
   myI/n+qFIc0/mGcHhTetZW5fZpOPZaLj8CvaebSJGB0IVnnElVSXS0vf+
   Q==;
X-CSE-ConnectionGUID: xj/Z6wAEQHW3QJJNP6rYGw==
X-CSE-MsgGUID: qK3XoZibQpimPxeVGGc9Nw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480002"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480002"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:37 -0700
X-CSE-ConnectionGUID: 5E11CAkNRFyDYfPtv1++7w==
X-CSE-MsgGUID: 28qhHTZoRteowi8E7pKKrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906977"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:35 -0700
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
Subject: [PATCH v11 10/23] x86/resctrl: Honor rdt=perf option to force enable AET perf events
Date: Mon, 31 Aug 2026 10:44:08 -0700
Message-ID: <20260831174421.13921-11-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v11:
	Add Reinette RB tag.

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

