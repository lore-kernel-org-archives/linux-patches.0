Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF38313BC24
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302410; cv=none; b=i7yjYWuueFd5sIA2E2p14HXTUxwi/kUTPq0jDNqauYnr2oBSlKRlypAiive3wr18s6UZl6wjb9t6YRtI4HgHddadasu5wByvTWgQ49FuBFBGYQ/KgRrqqfoFN18UvNMYFaNGGFQvxklGF8KBxvwLVLVmWw2S2hxkOogkEyi2Cps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302410; c=relaxed/simple;
	bh=V7tAuIZjmFHYG3CI6ExUFzsfFSGKj73ay9CLKOtBQZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3tk/U9t7ZE9rkosv3AGvdY5oWHLW19h6M7PFl3mokG40DPxfAcPWpttUUm4P2quvcTUFUGVmExRSNo4AifFEgveuwCePrpTcEpwEwFADcpcFLnpkO6RHVfShsvSEFY3GNfLuiqZOlXPlhohQcEC5c/C71b+/tlPapdJ5mzSQWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RfgtTBPM; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RfgtTBPM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302408; x=1744838408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V7tAuIZjmFHYG3CI6ExUFzsfFSGKj73ay9CLKOtBQZI=;
  b=RfgtTBPMSff8z/uskcSjWm84zMlQ2Altkoc7UBnrtM3q9bLUestkBg+L
   ZXPvxcQ0rngvK1xgv0VSM0UBaIVFEnW8YdnbIfd8hwhQ5/0xXg475giR1
   V2hfI8rgCGc+r0tN4TklLWUXoUCLgbbbZZ2Pm6xWkdIM5bBN2bNiM8cug
   SskxOKEzOH/fCgR7kK8RbBqIkapxG38REnP7BuBoBJIpy1iNMRTlPfgeK
   09Xv44H25N/3H+iOhljRJPmNqR50tU4cEs45ygu/9lY3A7OXCKS9X8PcV
   HBpwrffKMiV8NbxNhWar6HLEhSsI6w+Ayd+GONg30wDJlzrbVVPC/SX0N
   w==;
X-CSE-ConnectionGUID: dbZTnQGgTWisV/xqxbbuPA==
X-CSE-MsgGUID: xCRWepAERLaan6Prgh8VSQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914766"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914766"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
X-CSE-ConnectionGUID: qHJGg+RXT+6pOTc0XTGgdw==
X-CSE-MsgGUID: 6Vk4HKArQbKfNp1Fw0o3hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871947"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 21/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/mce/core.c
Date: Tue, 16 Apr 2024 14:19:23 -0700
Message-ID: <20240416211941.9369-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416211941.9369-1-tony.luck@intel.com>
References: <20240416211941.9369-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/mce/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 771a9f183260..fe9d141672ef 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -47,6 +47,7 @@
 #include <linux/kexec.h>
 
 #include <asm/fred.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/traps.h>
@@ -1948,14 +1949,14 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		if (c->x86 == 6 && c->x86_model <= 13 && cfg->bootlog < 0)
 			cfg->bootlog = 0;
 
-		if (c->x86 == 6 && c->x86_model == 45)
+		if (c->x86_vfm == INTEL_SANDYBRIDGE_X)
 			mce_flags.snb_ifu_quirk = 1;
 
 		/*
 		 * Skylake, Cascacde Lake and Cooper Lake require a quirk on
 		 * rep movs.
 		 */
-		if (c->x86 == 6 && c->x86_model == INTEL_FAM6_SKYLAKE_X)
+		if (c->x86_vfm == INTEL_SKYLAKE_X)
 			mce_flags.skx_repmov_quirk = 1;
 	}
 
-- 
2.44.0

