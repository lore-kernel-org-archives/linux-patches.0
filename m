Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98029181CEE
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982525; cv=none; b=eqB/NnRXfcsUKgxd8SmTN5gvdCOmBMnvHmnX9rotnzHx0Rq4zuly7N22nn6fQwOWfoHLIr1SXmO3XJhLsA47/zWsBQWkdUHckWPSBWDaatvoWckpT1PB8PkGRvz+DEnnpwPybTV9N1QiossShzjurHYmNiYZG0CEfO8Rxr+Bf30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982525; c=relaxed/simple;
	bh=rbO/n0ZcIOAgbilZJb15Crb7LJz39zrSZlFzfUY+p5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd4i+125yxaMS2JjoO7ezmdBa+VWfchJS6Bnd1LGgdIZ2qk5SfSNl2Mc5iQ1n18p5cXbOYohg8ujxKRjIGpT9TDmjfBxhhRdkA02oz/9zlVXqKgszmLD3LiPul9iR8ExL1VeKHsIMscIELC2D0Lv3nQRmggCMFg54Fzd1K7vMSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KA8p9YTg; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KA8p9YTg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982523; x=1745518523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rbO/n0ZcIOAgbilZJb15Crb7LJz39zrSZlFzfUY+p5o=;
  b=KA8p9YTgYL9RrnQA1LQMoc7bQDDBrqujxLfNrIyurPNYShfMduUJ6YKB
   hSODJJ6ZkdvTV/4YicH9Z7aHjAVQihtKyPlMY7pBDXAFrntj86DBjKR3G
   lpEUytr96448fKpbdUZogeZSwBDh4gbUnIsFCTv4n3GTrwqBPciRd0yJ1
   WNtdZbd6Z2wAO3kKWtDhHyDfFrueTxf8ezcFhfW0Z+X1srscGIN81yXz6
   1zT1pS0/GqgZtC5yHhBagkpvH3dsyu1EKxn7yIo3P+cTB5sBCqaUILQZB
   9zsqDzFomDipJ/81jtrYckFeLsJMHE/jjZc3ZmiSKUOI6A9lGmEVT3euR
   w==;
X-CSE-ConnectionGUID: ZK6g6T7ORHKgBDpXWBNm6Q==
X-CSE-MsgGUID: l0JjxiQTSMKZtC0VwUvN6g==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9482032"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9482032"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:14 -0700
X-CSE-ConnectionGUID: tbjZvTI6QoKjNbkICFGz+A==
X-CSE-MsgGUID: hMpfnLJBRtKz+nILQ8lYYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262768"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:14 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 36/71] x86/resctrl: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:14 -0700
Message-ID: <20240424181514.41848-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 83e40341583e..19b4fdb94a36 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -22,7 +22,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/cpuhotplug.h>
 
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/resctrl.h>
 #include "internal.h"
 
@@ -821,18 +821,18 @@ static __init bool get_rdt_mon_resources(void)
 
 static __init void __check_quirks_intel(void)
 {
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_HASWELL_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_HASWELL_X:
 		if (!rdt_options[RDT_FLAG_L3_CAT].force_off)
 			cache_alloc_hsw_probe();
 		break;
-	case INTEL_FAM6_SKYLAKE_X:
+	case INTEL_SKYLAKE_X:
 		if (boot_cpu_data.x86_stepping <= 4)
 			set_rdt_options("!cmt,!mbmtotal,!mbmlocal,!l3cat");
 		else
 			set_rdt_options("!l3cat");
 		fallthrough;
-	case INTEL_FAM6_BROADWELL_X:
+	case INTEL_BROADWELL_X:
 		intel_rdt_mbm_apply_quirk();
 		break;
 	}
-- 
2.44.0

