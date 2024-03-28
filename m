Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397588626D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643312; cv=none; b=PKNHoa+R+FManBrNdtQn2vvhYcGmDAX6JkVvEK5rxbi+k9kbCBqSfvGz3r7IPH+j8G3iE7wOgOj1ZJ4N3HJt5D6AF35qHIQ9TMkTxht0svdkd4ctrQxmYMxOSXR0t25qbDCFJ+SoqEJs++WhTRPfVqR85TrP8J2EH5abB7nTyYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643312; c=relaxed/simple;
	bh=dCC5e5zdUWP8nN10zczP7r4e33cRc3Nah82w39Vvy74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1Nhk4Lpp3eqW7bq7uZK3Xj74QRhb17aOFGGigEOHnQRohNxgp0CKifFeUAaA5z3i5jfL3jEy2rstxUrVd+VisJQNWA5D6xebqj4KR2L6C7vENQIEW3SbAnvKcXGUnQEuqWRSEk/X0dq+iiLQdr/aTRKuvn0yrIZuWEAhURSxZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mSEkQZlG; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mSEkQZlG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643309; x=1743179309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dCC5e5zdUWP8nN10zczP7r4e33cRc3Nah82w39Vvy74=;
  b=mSEkQZlGSDc5eaFbUPa71Ocgy4TnF5V8BpvCHiS8Q2+9QvWcJZQcdsF1
   wDsgTfHwAwl80QCOz+SdO+uXkGrPheg1ORw4xUD1GQfDdnQpMb9YcY93f
   8pB3BiczmbaFGciud7MOFo2EHJYCvSInLAiep9lCvLpifw44qPXHAWzBq
   Pm/NvMvp7NjBSHKce5NA97c/JNf7tF4YytTUD5tH0ERlxlwMmTmmfi6mD
   GkmxJvra+zFoVSoetgYFXcFZ+UxQyhufJ2wPT6ff1eyqxut2RAG7jlHji
   ZLmFWlW4XbC8/oicNUlDQuIHZOMFdByegX1/k9K1sf7EImcaUepYSmdGc
   Q==;
X-CSE-ConnectionGUID: hueRlKSsSd2Dp/iiIbLxOw==
X-CSE-MsgGUID: 0Ag+8ozERcSmhccWoUsqUA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294753"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294753"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726042"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 29/74] x86/cpu/vfm: Update arch/x86/kernel/tsc_msr.c
Date: Thu, 28 Mar 2024 09:27:23 -0700
Message-ID: <20240328162820.242778-29-tony.luck@intel.com>
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
 arch/x86/kernel/tsc_msr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index 6555a857a1e6..deeb02825670 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -147,13 +147,13 @@ static const struct freq_desc freq_desc_lgm = {
 };
 
 static const struct x86_cpu_id tsc_msr_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SALTWELL_MID,	&freq_desc_pnw),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SALTWELL_TABLET,&freq_desc_clv),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	&freq_desc_byt),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID,	&freq_desc_tng),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&freq_desc_cht),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT_MID,	&freq_desc_ann),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT_NP,	&freq_desc_lgm),
+	X86_MATCH_VFM(INTEL_ATOM_SALTWELL_MID,	&freq_desc_pnw),
+	X86_MATCH_VFM(INTEL_ATOM_SALTWELL_TABLET, &freq_desc_clv),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	&freq_desc_byt),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID,	&freq_desc_tng),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	&freq_desc_cht),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_MID,	&freq_desc_ann),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_NP,	&freq_desc_lgm),
 	{}
 };
 
-- 
2.44.0

