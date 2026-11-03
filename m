Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793741000;
	b=bUwZyHjE+hL00bGscDQWZWna7HtMQcSpwOPp+NNmSRbuBhnXrbarx2gxE7hJzx3cFi/S
	 dT4IL7qxklYGpxNlXrgB3MeY+PAyE1dpjE0DWyqUjWnAvmiD449HpSIpGbazYxcMTelGT
	 bd/P/OJg2mKfYq9u9m42G9sStyquoiLMFQT3bz4lfY3KbeS1IDpGD6uZc6t05GDQ56zWG
	 caB4NX7mBv3LoHwXk0cYZzn0FFnfnCvCow2UA8JF0S2t0CmkLnw9zzvRd4AwfQopj/orQ
	 JZv4pxtxBCro0yj8cS2QljUVKwAQK6ixP+Rhb8PbppkrpGQEBr2cBqGaxRoRn6DongA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793741000;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AXZqEU1qjd5SmyV+eo6w2meL1q8x6lBVrN6Yng2OPz8=;
	b=vwSjojFGdcSGx61zWsKLcgrqwVhLvG6WMEkoDFxm7UGHV26qShMMdWUaps3ErpkeSLVg
	 G2A+6+QINjO9H4ZJw/1RF1K3mUUauTvEbs68NeCrFrL/15L5pDMzcLrlKoHndvLiAZmLy
	 OGlUGotQyWVEIUwDp4WW59m7cw5YHwvaPwHrz4amRNwUKXL0h87eVEVsiVaWly+TW2Oz6
	 tFdBn/pYKM0kiVUvkBDv1y/YNDHeNeUY7bM0SSKb9ZZV9sR3IYro+e+CWiiLBUCfYtOFz
	 LwXtfGtTgCCUxXvGmzjDn8FhmaU2xrj3yjAwbuoZWarJfbetlKi7g3bk5IVEG7WJnRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PSf6jyPd;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1092606A329
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1092606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PSf6jyPd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793740996; x=1825276996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VG2e2QOTHcr2nBhUOJmYyynSgIpQnI0CkKaffEDKc/0=;
  b=PSf6jyPd8+gPedJpsuOtSnfHN/iUZoty6vwFNLWpiFhXFmWPxLczRPM+
   yT7FVTeP+jZleWBH8E5srlM2TwBLh5uzb6myTscUWcVd8cKpxHYuTpil1
   j9m3UxBnvyvmO7xuZ2ocscpDSG2ZgSktYk53+hOCkBGGtpJTiSLwT/sua
   bQr2lgHX/LnMvDgWsUeBT8DFtQ3BRcC4aCc9t7nQfnsXPExX3HxE4pvQG
   2jrxzWA3apx/jyaXhYToVcgjyxRNnlyPPut4zX5yrla/K9rLAvcx1iKJY
   agziBfiEwXEtRpjaiaGDII+UMHZSxNN0F8yHQJgbHe/DVH1G1xDI6HSGD
   g==;
X-CSE-ConnectionGUID: EthFZYB0RdqSCAcZlS4vXQ==
X-CSE-MsgGUID: u/TElufhSkig5fd7zvdTiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393523"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393523"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:11 -0800
X-CSE-ConnectionGUID: Ec0yudJdQvSio7tN92P5gA==
X-CSE-MsgGUID: yvjmrbh+QkCh/Mq/D60Biw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624587"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:10 -0800
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
Subject: [RFC PATCH v2 08/11] x86/resctrl: Use cpu_feature_enabled() for RDT allocation
Date: Tue,  3 Nov 2026 13:22:51 -0800
Message-ID: <20261103212254.18314-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103212254.18314-1-tony.luck@intel.com>
References: <20261103212254.18314-1-tony.luck@intel.com>
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

The RDT allocation probe uses boot_cpu_has() to test X86_FEATURE_RDT_A.

Use cpu_feature_enabled() for this feature check.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index cd3bcd71f475..197d50b795bc 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1063,7 +1063,7 @@ static __init bool get_rdt_alloc_resources(void)
 	if (rdt_alloc_capable)
 		return true;
 
-	if (!boot_cpu_has(X86_FEATURE_RDT_A))
+	if (!cpu_feature_enabled(X86_FEATURE_RDT_A))
 		return false;
 
 	if (rdt_cpu_has(X86_FEATURE_CAT_L3)) {
-- 
2.56.0

