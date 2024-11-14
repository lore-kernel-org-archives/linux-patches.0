Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E418489
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 00:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543443; cv=none; b=ANGs70P10DxzIORZsYDM3mjFUH4p1+wAKYvrsypGKVKh9CkoTkuD9wozsLfPaAvH3rVX+FwRIRMCzVLyvAL40Ne2H64gx5yNaYK/QmnJu1YavfFvjfWxluDDo28KRAPXqcmjHiPCqEpBBvYVfQK0RMzQxgboQ7fHoRe3dO+LrB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543443; c=relaxed/simple;
	bh=ZkSSM2q5MnFvLgg48mZuk8LBjeJj2H/nYXDhejRCDUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyuQlxJN+vs1tCkQasZY/EKNnrXZC7U17Gt+NafsYF6KugBSF6CDXSzwTyUs++Xcwalcw1n8BmVM4BlhnfX89MMOtFn91po5Y9BbTLRGCb1cFbWV7gzggLqVU2eb3EhIJRL24OIDDQE2RlHld0HWgdAQug2PggrwPsZJBGov9Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PpQiZIFq; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PpQiZIFq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731543441; x=1763079441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZkSSM2q5MnFvLgg48mZuk8LBjeJj2H/nYXDhejRCDUU=;
  b=PpQiZIFqTNHYl0UAIR5lTYrBCq+k6tM11vioADDRWUBU+LRyd9R+f9cC
   dDdRJSBF7PT/aUmXXxXJIplJsE9lFq8J9rwwLvSvQShugOm73fCnwUKDY
   U3vcBI5SvpBWjrmrZUbtRrnfASY3Vl6O998V6JRRI9ZqfyJb3CD9w7ol1
   8JvdS6++pwnR5YW/Cm13B520/4Kg3ezrZxiCtVI0vRBHzdX1oIo6Xs+F6
   eZxQPzPBGWDPO8iNVpBFQJnrDylk+M4jMHJej4VYcfEc6uGcby49q7Czl
   PE5xLi8aQXe4YJZFQUaE2J6mokjxTCgIiAV2BN0nbPeNiT7Pbnaiw+hdS
   g==;
X-CSE-ConnectionGUID: oR31pc8TTBGRr1frp+62fw==
X-CSE-MsgGUID: NJFgixbtTk2+8MneHynLTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="30869500"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="30869500"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:18 -0800
X-CSE-ConnectionGUID: NCDS9fs3TSWPUjm/p/Xn3w==
X-CSE-MsgGUID: LppNAjtBRamNw5SHSe9vWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92081163"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:18 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v9 5/9] x86/resctrl: Relax checks for mba_MBps mount option
Date: Wed, 13 Nov 2024 16:17:07 -0800
Message-ID: <20241114001712.80315-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114001712.80315-1-tony.luck@intel.com>
References: <20241114001712.80315-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This option may be used with any memory bandwidth monitoring event.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index a8022bddf9f7..3a89516e6f56 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2334,7 +2334,7 @@ static bool supports_mba_mbps(void)
 	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
-	return (is_mbm_local_enabled() &&
+	return (is_mbm_enabled() &&
 		r->alloc_capable && is_mba_linear() &&
 		r->ctrl_scope == rmbm->mon_scope);
 }
@@ -2759,7 +2759,7 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ctx->enable_cdpl2 = true;
 		return 0;
 	case Opt_mba_mbps:
-		msg = "mba_MBps requires local MBM and linear scale MBA at L3 scope";
+		msg = "mba_MBps requires MBM and linear scale MBA at L3 scope";
 		if (!supports_mba_mbps())
 			return invalfc(fc, msg);
 		ctx->enable_mba_mbps = true;
-- 
2.47.0

