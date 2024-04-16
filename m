Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6D613C804
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302415; cv=none; b=dldP2JRwXJEgulnoalO+dOmrjkJPFcCaw55Z3nYtB8k2M0q7XQaLf07hQn5R85JrE84fTktx/wXNiNJ1Upvbt80JksxDcLQgZgxLcI41/XXP/rfilib3zXebKZIPwH803TTTJlmWLa5vMib7OnLh9bsl9+qxa7Xv3Z8CCS8zpaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302415; c=relaxed/simple;
	bh=ps9rNqzKSGSOSSF+uk2bNTyXLGrRDgTAM95atyOJquA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exDQIuQ0df3zV0VJiNWi00/kWlzY5ahkDOO0jOAl6Z4sYTPUtz7kYRoMkj8EXfyDoq3w5E9wely+QZPnBG4Nnijch4GCStoTLHJj1rCvbZ+SxOBg8BqrfToCc2QckqbzEbM/u9VGJadPgy4dyAWp1WVHUvRsn6nLPnzZ/A3Fivw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UjAtEYE+; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UjAtEYE+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302412; x=1744838412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ps9rNqzKSGSOSSF+uk2bNTyXLGrRDgTAM95atyOJquA=;
  b=UjAtEYE+ga7Loxv4ukBXNwXqghqNViuiFNdeSsniIWXR2sq+YL/4AuCu
   i0obc4yKZvvZV4QL1X94xS/eW2kWa75aXUjmVSxMqTtYUyxHjw2aBwmRQ
   dthMwRULkniqtM9Jz6yYUONGqN99OlICz5KPsZGOIopVp6uWTKCQfkE1O
   bHLPTNM0mJlRqxRxsrV5BsfCTxtL4h9XCgrkH0BjLbg4nCUNlM8T1gCax
   XVDu/zB39lyloXniktYH1CxKUFXHemEOowjxQaMeBL9sj7HpzxJ2vuDR1
   XrFgjxVQhHysQnXqooNdvm79v2btItgjKURttDvzul10yqXIFRuM8+qpY
   A==;
X-CSE-ConnectionGUID: 3BL6do9yQvm/CDvTTFKORA==
X-CSE-MsgGUID: iH9QHGC+T5K5Kbo9I5nPqw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914811"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914811"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
X-CSE-ConnectionGUID: 5hAYBeKxTHyakmZdUb5HpA==
X-CSE-MsgGUID: irZcxYxXSbyeXfaQxsb6pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22872004"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 30/74] x86/cpu/vfm: Update arch/x86/kvm/pmu.c
Date: Tue, 16 Apr 2024 14:19:32 -0700
Message-ID: <20240416211941.9369-31-tony.luck@intel.com>
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
 arch/x86/kvm/pmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c397b28e3d1b..2faa67a4bfb6 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -34,16 +34,16 @@ EXPORT_SYMBOL_GPL(kvm_pmu_eventsel);
 
 /* Precise Distribution of Instructions Retired (PDIR) */
 static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_D, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_X, NULL),
 	/* Instruction-Accurate PDIR (PDIR++) */
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
 /* Precise Distribution (PDist) */
 static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
-- 
2.44.0

