Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B029131196
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643313; cv=none; b=VtCaEKy7vHTI9djB1Y1PZdYmZqqwCO5NVRjKJYHNuKy/KDcl/d5pGGWdSLabV4v/SdRKeOnsjM7639Usyieu2ekwyLlifs8xzElyT51LkGi6/1rpQJ3I5TdQ4jDIfqurg4Xv2waPWwoBxsaouyFSvyILPVawjPbRbrKhJ97g820=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643313; c=relaxed/simple;
	bh=FfXHVVXxAXvXhf26U3fzvKJ4+8iaBCg597mpHe5hnu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttv68xKsn5RfPHJRwHjUOZDZSLdjf/VuRQtCA5ogaw3T5R18vF51ptrGzEOoCsBDTDOhqfVgA5pFoGr4YKisvUxCVpTz0tgSwCAmS/hstsEiY+Fo2VYbeCJj0ectK7QZPe0IKNWa8YQpM8zfwJjvGzn2kG6aeTeyvLGxuiuU1Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SmUlkJtZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SmUlkJtZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643310; x=1743179310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FfXHVVXxAXvXhf26U3fzvKJ4+8iaBCg597mpHe5hnu0=;
  b=SmUlkJtZGCZD//JpzHiDpt0YSH9gDSt8ntAprtQxtiocuLGetYtJ5sSF
   sxWZINb6qPWrcUbYxg6WVPH6OVDDT5IkBJhhp8szRfPbonH9KMVNTh44v
   4+733kLHf9MYkWxbJhBHzcifY7nuwD+2W0jxopwL7FrEoYWN/PrMoeX7u
   8E4p0kdCUShpJZxJ4QHvUWfPwS6kB5IATbjRnqvN1zr6RRSDsmiY7edF/
   oZZngYAfD5UNxFWTdvGRpa7RTYK3XfaSHU8lUy1vjX7ZrdNMsGyFgOyRa
   qMUQI7V6y5yI7RLkm9LLD64VPmxoGwwgVugFYGtRHuh+T0hRWrokE3Cmp
   w==;
X-CSE-ConnectionGUID: gyi5SawAQl2TRH3ib5JerA==
X-CSE-MsgGUID: MgBdN2pmT2qEIDF3eXQOig==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294756"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294756"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726053"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 32/74] x86/cpu/vfm: Update arch/x86/mm/init.c
Date: Thu, 28 Mar 2024 09:27:26 -0700
Message-ID: <20240328162820.242778-32-tony.luck@intel.com>
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
 arch/x86/mm/init.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 679893ea5e68..fadc3fc3ee41 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -261,21 +261,17 @@ static void __init probe_page_size_mask(void)
 	}
 }
 
-#define INTEL_MATCH(_model) { .vendor  = X86_VENDOR_INTEL,	\
-			      .family  = 6,			\
-			      .model = _model,			\
-			    }
 /*
  * INVLPG may not properly flush Global entries
  * on these CPUs when PCIDs are enabled.
  */
 static const struct x86_cpu_id invlpg_miss_ids[] = {
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE   ),
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_L ),
-	INTEL_MATCH(INTEL_FAM6_ATOM_GRACEMONT ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE  ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_P),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_S),
+	X86_MATCH_VFM(INTEL_ALDERLAKE, 0),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L, 0),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S, 0),
 	{}
 };
 
-- 
2.44.0

