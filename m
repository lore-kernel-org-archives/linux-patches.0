Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A925712F38E
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643323; cv=none; b=Rd51zm+tWhgvJB1XA0ssbKYqYv6NtGrvDWgkwFUNu41RtO30YZVFUpGHV9g/lm+Vxm7igpWFlo95eKh1Nx7NoPa4yQp1mBno1WoZLD9BWGNbh/DET9trADu0fZpTOqC8Pffe4xdtQv22ltMm4BImTg3lhjQDSNCUeEyxQl7GzYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643323; c=relaxed/simple;
	bh=LSVHB/ZFgQlGo/cpHX9BEf/V4nmVp0b/qXAMR2F9w/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqfyKQRvby1AlGfu0l1cWWWfQH/uUoL5Ha6fdfyjwUczR2of3E+DR95lW7Veuj59zTqhjNJJvaES1pbLBFxyjQ9xLoLpHTR9LYJtswcBxkdrIozMtly+eiCSOATv0ZEtaqRM5eG+ZeBV+/ZGHv8WRMqxiypnl84uXo9+ehCGGzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MPxqW371; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MPxqW371"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643320; x=1743179320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LSVHB/ZFgQlGo/cpHX9BEf/V4nmVp0b/qXAMR2F9w/o=;
  b=MPxqW371wSJogGuqSr4+0vBd36xLJvgxP7Go7cLHWLiAqNT/yU4+2wMA
   q4zJlPthbkxsssaIS2LuD3vLtDMH9JROSaphxxEHIxmxDKuNRKiZmsaw0
   iudS595yzzoC8r4OXvARYW2zJ4n1er/CozRnnhZP4UGIOIBFJouhMwU/g
   1PEWtJFcwsg4/4dYZQkeQjeIabyj0A0LPGMOMzDutsy1b7WJqzg3mnACI
   GR7YfqbPFCK/sqw68s/WGN6QNUR3xoy9/xA49g3at9lnsY9vU5rr3Of4B
   Jt/943HYDTNlIKfTkhHVu9SssQA7zTEfSUsrB4Ye+r1Pkmtct/2f632Tf
   g==;
X-CSE-ConnectionGUID: 3wyPESsqT9q2ji9vHhoZUA==
X-CSE-MsgGUID: shjqIOVLQaS7LKgnPs1qIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294807"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294807"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726194"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 72/74] x86/cpu/vfm: Update arch/x86/boot/cpucheck.c
Date: Thu, 28 Mar 2024 09:28:06 -0700
Message-ID: <20240328162820.242778-72-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
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
 arch/x86/boot/cpucheck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index fed8d13ce252..0aae4d4ed615 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -203,7 +203,7 @@ int check_knl_erratum(void)
 	 */
 	if (!is_intel() ||
 	    cpu.family != 6 ||
-	    cpu.model != INTEL_FAM6_XEON_PHI_KNL)
+	    cpu.model != 0x57 /*INTEL_XEON_PHI_KNL*/)
 		return 0;
 
 	/*
-- 
2.44.0

