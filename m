Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09145146A86
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302418; cv=none; b=pfKLMgj8Fb83SgUWAD6aw7lKoCpvLSpVGZ3aSReBCxWnyCmrkljfr7NYicA/+3YkeAHlMBOsBIQxxJZunrVJPiGwpQHSYUux2Sk4kgONUMJ+KPsvvlEJXfb8qvGS0NXCmeyPZmymXu04/EidPblWWOqSxzpz6/SbavMMGOw4ZIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302418; c=relaxed/simple;
	bh=LSVHB/ZFgQlGo/cpHX9BEf/V4nmVp0b/qXAMR2F9w/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiP6FKaCWq8H+4sFx0AmVGZOfl9C5g3wmMg7n4aTLLNw0r90TW/3xIjgerPQmBqHsgYR/+uAydn4iL965YG6WGkLFC6qvNZlUKYB16DVNW2HQDNjZpkS8Da/vPReHVC+iuV2hAQ3qev2r/0Xf8HfDOhBs3uKY8uCCamB8wtR7cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DRwVLFe9; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DRwVLFe9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302417; x=1744838417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LSVHB/ZFgQlGo/cpHX9BEf/V4nmVp0b/qXAMR2F9w/o=;
  b=DRwVLFe9GTu30qXX/7pV+MhF40ZSEHdfMMzWBI4W0/AjEi8l3/14xJ1j
   ql8n0URWquYYznFLIX/WxUru2J1IMqCc/Tm0vXD+W7tdz+G6V94bOaNIa
   jqNSwT/4pwKSjaRnC22KGqAaTYW7HeuhHLh9u+VOSGZEFKZVXFZcKYWSC
   Rx2eWKvMG1y4ldGmSh/GhXy/cOvmSmODuTxYO1FUTWDjLiEkJsiAokTvk
   v+BIGsoyDPmDYIfnfH3yvOz14fxX4pX1zUK/sg7NlF5Mlm/W0pWKNoQJv
   coWVW3sIt5CoQPaDwMri4w3R+M9g/xxJGtAT0k94vWngHwf/AwGsOH2VX
   Q==;
X-CSE-ConnectionGUID: hiZw9h7zRFu4onP841hQBQ==
X-CSE-MsgGUID: s0FCEp3OSd+KB9Re4BOGig==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914856"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914856"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:03 -0700
X-CSE-ConnectionGUID: RZuV7ujTQ8iw8hCKDRSCbw==
X-CSE-MsgGUID: /cgppyrATcuFIEaBQ8rkDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22872076"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:03 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 39/74] x86/cpu/vfm: Update arch/x86/boot/cpucheck.c
Date: Tue, 16 Apr 2024 14:19:41 -0700
Message-ID: <20240416211941.9369-40-tony.luck@intel.com>
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

