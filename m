Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6CE12DD92
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643312; cv=none; b=W6YKJbbr/EllSN+4yD5/FtYFxnhBDI9rsckC2wAYGeE4my+Y0cCDt5yWtzlwngNV0N0zOH4zzhFB9nEg98buiD4kXyvF1sPkP57sBgrpVeh3k50XDluf3coosXLqtyUU40+/4vHXIa7KMy3V3RcE86AILkgjjUz0vmxKzxdajWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643312; c=relaxed/simple;
	bh=+Fm13jE6hTwP19fhDPxn1Q7OQc3mIiRTUiyPAsD88MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM7QcrjozUd4Vj9Ke+/iN+qEHMgwf7cpuR+AFFslQy5oT08a8RuKQqCL1kGj3QO4Ys7PUb1vHcYNCAsnX2FVrQo2BXqBvHFcY/L2aMGIQo73L/CTCa3quGRmBGXmansXOoaKModppivCs7LuXSuPANlCDf28Hb85GMARKxlsNsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T0eM8/S7; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T0eM8/S7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643309; x=1743179309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Fm13jE6hTwP19fhDPxn1Q7OQc3mIiRTUiyPAsD88MY=;
  b=T0eM8/S7uvxPTdUolUw4VM1fsrQAWMngOu2uKEqyz65n9zVbJFYDD9z1
   7HgCtM35b7HtruQjzwOU1tSN2M4LqbsM24EuBSVMi17A/DGZWcuEXCtgR
   bNwYiuqLgWIlcGLREdzqF+0mafzle2Yk0H0pkJvn5ktHXNGho5E5khRa0
   OCRX32VK9mVyhyK7UIpAdsZALZ1Qq6ICl4wmlpEJoiy+lsGXsQYPVZ5us
   zOSxrBwj6lCqOmqT37CnLPy/7SepvMsvVAETh2M5xv+jY1vzkV214yixp
   EYD8bno1WrCehCeF9qV405oGJWnx6WzSdTvJTaQqzKymv+B/IBcJ41ZDg
   g==;
X-CSE-ConnectionGUID: D/z42coZS2+VM9Wa4ChBUg==
X-CSE-MsgGUID: upFetM8ARWSgzmEcNsh7KQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294750"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294750"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726036"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 27/74] x86/cpu/vfm: Update arch/x86/kernel/smpboot.c
Date: Thu, 28 Mar 2024 09:27:21 -0700
Message-ID: <20240328162820.242778-27-tony.luck@intel.com>
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
 arch/x86/kernel/smpboot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 76bb65045c64..c35ecd9078e4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -438,9 +438,9 @@ static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
  */
 
 static const struct x86_cpu_id intel_cod_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X, 0),	/* COD */
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X, 0),	/* COD */
-	X86_MATCH_INTEL_FAM6_MODEL(ANY, 1),		/* SNC */
+	X86_MATCH_VFM(INTEL_HASWELL_X, 0),	/* COD */
+	X86_MATCH_VFM(INTEL_BROADWELL_X, 0),	/* COD */
+	X86_MATCH_VFM(INTEL_ANY, 1),		/* SNC */
 	{}
 };
 
-- 
2.44.0

