Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443052;
	b=aPoeNBYYtJxp+0bNxE6FgSiiTcbOQ2gQ0lOpVapRdc4ENa4XHJgmW55UTzAV5wzT7rS7
	 wnUKmOQx17E0HA6H2bkVyj9GJu4rLbCdVezouVH/KFfapf8etuHfHDK3NN2cxVaIbwlNg
	 dZhG2Tsa5YFi5oLolMXYHkpgc5cjA/5wNf3nWco6QPj9ktYq5yVAfvn/TPMdfrTWeGjNq
	 qcjC6RgiNiGdPsiVEple1gLfF1uhu6E/+3l0F04j6RT2XV9SxoumixTqrHHLzGzwhKo6b
	 +Y6huJD6xul7/biWHTh3xxIEqYh/Xc8yw8l4la7MmD+dKHx5rp8lEoPfT0fb398+1bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443052;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fFV+ePMSuvzYML9yaWKb9HMSvgNkAUop4qhyYIxImGs=;
	b=DReXKnGO6rMppyszTwqVvMkoVdpIjIpAmxmBGihcFkYdi2gMaIComahcsVHckX/+Jrp6
	 Wi5XnWCDe3/+Wg1FkYANVPQP6CKpuDa5GO9uFhVhErnkpbViElomt5azKAZ/GoUJNlpT2
	 wUFIDjU7OUYcevuY0uLEH3JhdOEsASbsoQ81lnB7VuZuylJvu0+Bn62Cc+eM5iaUfL4s0
	 EbQRsDjlZa6tEvSW5+n6rjmPDArj6yA5jIvp4mzUcjmaGWKk+RfUBGTLWTLn3J6tl5m3o
	 2oPYxWlzPeNfjID1YQHg6M/V1FCVFBQtM3JAjWT1oTHNc6LqTh+gx/8MzMNvfEsBnsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZVS1cuZN;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94ED606A321
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D94ED606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZVS1cuZN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443051; x=1823979051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OEhFWoohzJAQsnbEU6+qh3E8KtBe1eFBjZy8vQv9TdI=;
  b=ZVS1cuZNEgMOh4qngt+LmRYwFmOkrhxN+If2iaJ7AB8kdqJL+FR9DZTV
   9a/rE2PisOliBaqxBU0HX8sCJfEfyz/g4LVQpwnCUMJ9fRxCj2fx+VlMf
   jQyHe56vgjf2BMDnjp+95yTv1JE9Za56uhR87ZGrmQHZTSP6gFnUTEUr7
   qbH9MGoFh3NP+LFzLBKOME9v98/CVIjfTvVVLhLxraZ3fEjAzDltSig5G
   jTtvXVafhMFtwy7qIWYA9Yck7ruV1JffM+d5esUgRPpMwYo0gRlZzu43A
   GtllrS0F0Vyfs28PIBQeUaf58z6XnA1IfyUvVMedkpMx26Z4CbQHYTmqS
   w==;
X-CSE-ConnectionGUID: 5lHH1vRkRGu5CJ7NWdKvnQ==
X-CSE-MsgGUID: HdF8ez6gRveq2mfOgMy4aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131118"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131118"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:48 -0700
X-CSE-ConnectionGUID: 7OAd5viQSY64WiG03SEM2g==
X-CSE-MsgGUID: dM2KSZ5bTUyxkHsd0ZxuHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008620"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:48 -0700
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
Subject: [PATCH v14 02/24] x86/resctrl: Check if monitoring features are supported
Date: Mon, 19 Oct 2026 13:50:09 -0700
Message-ID: <20261019205031.16977-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both Intel and AMD manuals say that software must first check
CPUID(0x7,0x0).EBX[12] (X86_FEATURE_CQM) to see if any resource monitoring
features are supported before checking for resource specific features
supported in subleaves. The L3 resource monitoring features are further gated
by CPUID(0xF,0x0).EDX[1] (X86_FEATURE_CQM_LLC).

resctrl enables L3 monitoring based only on the individual monitoring
features. It can thus enable L3 monitoring on a system that does not report
support for resource monitoring.

Do not enable L3 monitoring unless both X86_FEATURE_CQM and X86_FEATURE_CQM_LLC
are supported. This also applies to assignable counters, which rely on the
RMID count and scale enumerated in CPUID leaf 0xF.

Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Tested-by: Chen Yu <yu.c.chen@intel.com>
---
v14:
Maintainer note: No need to backport this fix. No issues have been seen
from this failure to follow the exact enumeration process in the manual.

	Move maintainer note after the "---"
	Put the X86_FEATURE_* parenthetical comments back (without "Linux")
	s/monitoring features/resource monitoring features/g
	Add Reinette RB tag
	Add problem paragraph between context and solution.
	Add Chen Yu Tested-by tag
---
 arch/x86/kernel/cpu/resctrl/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 55214d6fdc49..34ca3c7cc046 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -968,6 +968,14 @@ static __init bool get_rdt_mon_resources(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	bool ret = false;
 
+	/* Any monitoring at all? */
+	if (!cpu_feature_enabled(X86_FEATURE_CQM))
+		return false;
+
+	/* Any of the L3 monitoring features? */
+	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
+		return false;
+
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
 		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
 		ret = true;
-- 
2.56.0

