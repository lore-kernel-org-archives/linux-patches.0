Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528E617994C
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982513; cv=none; b=m6UeIc+cZcTOC7Hs/Q9TyTX5FJCQn5/WlDksC9nGD0y4esC6vSNRQpBlzEGMgh5+dnMLcLOpm/ArF6X+cEXbGb4euU3pmZTNMBw2O+pEd8flxWR4rCYYacg+J7BGQC/qWOa7PLkEWXTvWS3q/Ca5C5pDeZGAOJzXAASqB8PiSYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982513; c=relaxed/simple;
	bh=XAPDGw5vqm4R68C0iiGxVia58si6InFh20Tr6Ma0z9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEqkrEl857h6D0b6xrRvrizFoDoxSXhlfWtN1y9Narnbp/hPeCkgm6iWhUGyiUS8PV3RlqXpXIt0G0yOt7eYu4s6nvjIHW+ZOYTWopb9wuqKKFRjfwD3Y7y3aDpF+Ze2V+BpZLe8jxMkI30IU6jW5lnyO5T34Vqik0HR+mZkpno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=glasWeAx; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="glasWeAx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982512; x=1745518512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XAPDGw5vqm4R68C0iiGxVia58si6InFh20Tr6Ma0z9k=;
  b=glasWeAxXDcIP6X9tg/ssV/M8P0SE9CYu5WJ5/Z5Bwq1AQRdLiVTO5g2
   di89aPgfI0O6Dq0Md2unwD/BEnb78MIZF7Y2XC2KzvlnJsVJc2mGXjof7
   6y6MF+ULmo8bYwqalchhDP5QdB/H6ZCCIlckxYlvff5VJzMZBEu8SDprm
   T7JVzyzG3ij9+bbU2j23/4nliaOMHFst4/8sDrju4E/L2z2n4YNYlH9nQ
   WMGXPx3s1UUGYRQM8ULGWFnqJhK1aUlRsFluH1ezHwvT9cCqBVaXuFRxM
   4GXM6o+bQx+xenSnT7nAwe6A2jCsVzRliwcD4GJT9CYcLlQH2Bs6XssNt
   w==;
X-CSE-ConnectionGUID: 2uy3MmDsTy+Snip+SstmnQ==
X-CSE-MsgGUID: 5GLP1V9mRFSlgDBS7wDCBw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481865"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481865"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:00 -0700
X-CSE-ConnectionGUID: oL0hbClGS/eFPq2nAJ6efw==
X-CSE-MsgGUID: KzqisXLkSG+cK+UlSZDgUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262639"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 19/71] perf/x86/lbr: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:00 -0700
Message-ID: <20240424181500.41519-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/events/intel/lbr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 78cd5084104e..86277196ffad 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -2,6 +2,7 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
+#include <asm/cpu_device_id.h>
 #include <asm/perf_event.h>
 #include <asm/msr.h>
 
@@ -1457,7 +1458,7 @@ void __init intel_pmu_lbr_init_atom(void)
 	 * to have an operational LBR which can freeze
 	 * on PMU interrupt
 	 */
-	if (boot_cpu_data.x86_model == 28
+	if (boot_cpu_data.x86_vfm == INTEL_ATOM_BONNELL
 	    && boot_cpu_data.x86_stepping < 10) {
 		pr_cont("LBR disabled due to erratum");
 		return;
-- 
2.44.0

