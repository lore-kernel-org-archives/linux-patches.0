Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F74154CF6C
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600435; cv=none; b=HP2MVkvfVLb4flPqSvsbQpJ13hXzHcD4s2lbm0XE390Q2yIP9yEprJfD9cyH8IuOJBx+OUm9GylxQrVIO0eNxrej6iqOR4ntj0lpXUwTEEocu+hAOBPLQm/e/tHzaiHisEbxwMWG/hygQ28EL1r8PX6n7Qx0HP+WPEXoYA3xnRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600435; c=relaxed/simple;
	bh=ctBegGBZtB/D5EoHsAL2gv9lKuYA19IzLJVZ+J8QjRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHQWF0t2Rb6fOS62TZGyOg7+cH6nC0bJU/CtrALiMTwX99YJaFLAP/AniNupET7CMHRYVAELWtO7ILY8poej1ViEz+Ua09vAMjnLyhwxvCH/PR23ms9CRQARw5BXsSVWDo/zvgE5bMDsy3wNt5d1GbJOycgE/+lGSEqcwCsPH20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kZ8nFMj2; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kZ8nFMj2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600433; x=1821136433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ctBegGBZtB/D5EoHsAL2gv9lKuYA19IzLJVZ+J8QjRI=;
  b=kZ8nFMj2thlFUKC8YNzYYenwfMC74jPZXG4BymdZIIuKHot2egFh0W1e
   9G69hcQaybHqorFkYNfvyu4JSgDDaRXu33beeSyCa0/1bQFaoEK0EjedL
   x0kDg2nxx7s5OpJ0UGUBSJviHpzeVvSto0j+J9SszzJh2st3xzDM7pjCg
   hVbcwirs5kA/7vqqjcIoBMkSVQXyL+kXjU0srJ/vu9DAmVBVITLnFKLBC
   7xONMsesmpY5nJBo5A+af00ku4AwKWgHk49qXr7J3/LKDjM7UXEndeIEb
   HbsgF+49YPunrMUvlaQ6ovstGo4vlWM6kX0b0ls9nZD4N2699C+eRMYcI
   Q==;
X-CSE-ConnectionGUID: oGrCdJRESxqFIhm/OUjr9g==
X-CSE-MsgGUID: N+U6Gx1NQ4uTv4yQYeQnfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861499"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861499"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:39 -0700
X-CSE-ConnectionGUID: 0TXb/eG/RUqKAr9Y8uri9g==
X-CSE-MsgGUID: UJyFVRoVReqdVwXh3uGsUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231492"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:39 -0700
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
Subject: [PATCH v12 20/25] x86/resctrl: Enforce system RMID limit on AET
Date: Wed, 16 Sep 2026 16:13:15 -0700
Message-ID: <20260916231320.14502-21-tony.luck@intel.com>
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

AET (Application Energy Telemetry) event groups each support a specific
number of RMIDs. But that number may be lower than the number supported
by the system. This is especially true on systems with SNC (Sub-NUMA Cluster)
enabled as that reduces the number of supported RMIDs.

Reduce r->mon.num_rmid if needed to ensure that info/PERF_PKG_MON/num_rmids
does not display an unachievable value to users.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Replacement for v11 patch 14 "Enforce system RMID limit ..."
---
 arch/x86/kernel/cpu/resctrl/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 3bf4d1a07593..a20439a5099a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -798,6 +798,12 @@ void resctrl_arch_pre_mount(void)
 	if (!intel_aet_pre_mount())
 		return;
 
+	/*
+	 * AET may claim to support more RMIDs than are permitted to be
+	 * assigned to IA32_PQR_ASSOC.RMID. Enforce this limit.
+	 */
+	r->mon.num_rmid = min(r->mon.num_rmid, pqr_assoc_num_rmid);
+
 	/*
 	 * Late discovery of telemetry events means the domains for the
 	 * resource were not built. Do that now.
-- 
2.55.0

