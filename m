Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBAD18411A
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982528; cv=none; b=lBiKmFS13Hhf1FGwLpC2boyzBMZL7vJxnt+sKsr9IXhMaAL1WQEwC2Mf9koKIx9bXf1vyPR41Ib2RdWIBTQVP70U2S40YpOk8rDxfEH5k915eBYv4wemo6CmxvCeVhos4CkfC2gMgNZgA/2l7esjmuhQAIKZ5fBKuvVYUl8Qa4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982528; c=relaxed/simple;
	bh=dCC5e5zdUWP8nN10zczP7r4e33cRc3Nah82w39Vvy74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUuRtxsrKmqhkOixBfYk1OqEuCwOMd9nrnNjloxuQx3Dbd922UAfk8On8Ci4Rfx1hKefX1g2zNErvLO8G9HKOrh671VRni5nTPlb5koJnWk13GvlhDBJS9YZkPZWAgOHBRqaq3wAsBUeY1l9vgF7wwWC30K2KMrua2GEUckEXSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h8uztWsp; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h8uztWsp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982527; x=1745518527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dCC5e5zdUWP8nN10zczP7r4e33cRc3Nah82w39Vvy74=;
  b=h8uztWsp61jSchm1cex7mU/Wx7QwOLiUykK8uj7WYDucI+RM1b0hedAn
   2IP0pJXP3P9HyX6GOaOOW8yTkGc7lBCd7cl7yowVfR4+YZ1vJqK2GRBzV
   /gU3yOdaTZVV3e3A1LbYF6L5aBcQAEdPxU/POOJY64uoqg8F+ccxXQKqg
   XrugzU/N3q0/DoS4lG+hpHTBTVsvmJwJS4fB2iCgCed+lNKCMOMidJyJv
   y11xzT41ATliLWZh7LNWj+QdeTd8N+t7oYWpWV6taCOQcUxM5gDsfYna+
   6smjx9pVD89L7hiHjn1GIOpj1guA9WqEn8fzvtJkCq8E8TltHYY5vOCdV
   g==;
X-CSE-ConnectionGUID: 3gMo48RbQkCj9mV519lShw==
X-CSE-MsgGUID: 2ckCEAZkRMKger4NtZAiDQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9482073"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9482073"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:18 -0700
X-CSE-ConnectionGUID: mgTPo2hJR/2Epmgb3jkRYA==
X-CSE-MsgGUID: HLu4AdKOSLGC4CcDZD7aOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262788"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Tony Luck <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 40/71] x86/tsc_msr: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:18 -0700
Message-ID: <20240424181518.41927-1-tony.luck@intel.com>
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

