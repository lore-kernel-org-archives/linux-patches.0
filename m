Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FEE20721E
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222926; cv=none; b=l0d2hBUK8KrpTjIkkm/B42cd5mnBVtKpIr+Jx37+GmA7XMBxU1cwEV4MiTDnZ87XycEusJo99WsoTG+nxXDanetKydTOdF/Uc7kvMagTckzhSgrR5oRQJqYte9gIVV/kIuFvszi0D1RLvXNse9Ef1BwkudmKZhsPXAhyLipxS1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222926; c=relaxed/simple;
	bh=miXmdTqCp2YZmLRjd/Hq5yASIhebLezdHmtBpTOcFW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GN/Tl/esVWGtr1v9LcFxNOlBw4Pn+luvVBCdEfxrGfTRYVWcfTF7WkQGNrz2DDVm2lYEhar+JNy8tf6nAFkh9S6mBZoETHIv2/EFoKt8lFVfdwUpykd9+nALVc0b5nF0RCcwV8edRxfahH4baTC2ntT7FILFHrNHLLVloDxAMZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bcg3q6ql; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bcg3q6ql"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730222923; x=1761758923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=miXmdTqCp2YZmLRjd/Hq5yASIhebLezdHmtBpTOcFW8=;
  b=Bcg3q6qlqZ3OvrEH1LcUEE0wEhSOioRarBaX4xP2G9Jpj9pHUZY+Kuen
   c8soBv9eBrVsixHfPd/xF/CbI/j72th2LWx/Asbv0jaumZBBo7CqPrAhF
   Try2SYL9KlMF0UliC2ZiJs4Gtt9KRnsLvokO4y57dziy1olYVyA0z/X1Z
   +5It+09iQqmLVBSyUIk+WntJPtVVcU39G12SzpknLSuQqdq4g08PTqCpl
   +FH5lP8jqjx8DmIgq5JUbQV8XysJ1CeeFgfARmHyuHZf45Yvj9i5NYb3t
   mNGqBUWswSSRKzCCHcve47I2J/0Ah6S5HYs2Rkt9hVsYXeggx8VAKdGEK
   Q==;
X-CSE-ConnectionGUID: k4olgGmXTJuWJl7g1UBFMw==
X-CSE-MsgGUID: 0EDUpiShSOCJz4zAxl5JLg==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="17515678"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="17515678"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:39 -0700
X-CSE-ConnectionGUID: hKlsxY9cSCierr3EPk7ONw==
X-CSE-MsgGUID: d3m9/S7TS7WFH6LcqPhbpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81585606"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
Subject: [PATCH v8 4/7] x86/resctrl: Relax checks for mba_MBps mount option
Date: Tue, 29 Oct 2024 10:28:29 -0700
Message-ID: <20241029172832.93963-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241029172832.93963-1-tony.luck@intel.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
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
index dbfb9d11f3f8..5034a3dd0430 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2345,7 +2345,7 @@ static bool supports_mba_mbps(void)
 	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
-	return (is_mbm_local_enabled() &&
+	return (is_mbm_enabled() &&
 		r->alloc_capable && is_mba_linear() &&
 		r->ctrl_scope == rmbm->mon_scope);
 }
@@ -2772,7 +2772,7 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
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

