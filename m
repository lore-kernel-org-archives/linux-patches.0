Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D77131195
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643309; cv=none; b=WSICubJ3mIl9AF/TzA56UVKKuk/mdlO29TDPRQRk6n9vC9bUFsyxpgmBbh6RdQ9oeubVDlotrQ8DhFj2qm9j9608EJFeS38JkkjRodGG9goM1YX1gtWnhabu48h+qyhwYbm/CXflT5ai3F+CbTFdrmR/mJ9M83AZgFlIhQQkwhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643309; c=relaxed/simple;
	bh=9rMjpqoCOgRty8mRKqjOBHEBAP+bItOsOB0U8/8T0P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/8j77sU9iGBUh1Gx9OQTuXudlDO21raacehGd51QkEdXywNhqumWoYiPbkek3ETDOcxQTjG4DH5PUyFLkLgvISBT1vxtCnsYY3na942rcUecDKkGJ2j3XqcDR7zNQPFkaxViSl51fsKpBRG1SuZcQuqD8RqkDZ7nFMYT98878M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJzvTeUF; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJzvTeUF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643306; x=1743179306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9rMjpqoCOgRty8mRKqjOBHEBAP+bItOsOB0U8/8T0P4=;
  b=gJzvTeUFvfaaHGPgFMjzDlqxnlUIH+ajW1zbbJs4NtyZJmtZ3Mvmf/vM
   GOP8WzVoJNzVfRmrP3XIUQmeVCokKwVG34RhCsfE5rLBD4p6D7wnSXdkr
   Nu3PuIGGbVb6n9oWZ7Rn1ksDC77Cb+T8+oz0bKvq6WnFdD7MerTWPHX64
   uZ+I29LMHP1n1RpRh7jj2D5nBybzUqZ8Oh3K9hiwtbMhSRg2DTr2S22U1
   WONzInCokHbMEb1I78ckuxzGLd8IOi9XqCJGa9BqzCpQ8wH0od3FaNEA2
   TO6kEQfJ/GxCoUZJbLV9kCyl8MYVCth5V5iNdcZ2itAdq85XpZ5M30Jtg
   Q==;
X-CSE-ConnectionGUID: uVQz+iu+Rl2q/8DHdrJhRw==
X-CSE-MsgGUID: 6rWAweafS4icshhE1VoSUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294737"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294737"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725993"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 15/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/aperfmperf.c
Date: Thu, 28 Mar 2024 09:27:09 -0700
Message-ID: <20240328162820.242778-15-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/aperfmperf.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index fdbb5f07448f..f9a8c7b7943f 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -124,25 +124,24 @@ static bool __init slv_set_max_freq_ratio(u64 *base_freq, u64 *turbo_freq)
 	return true;
 }
 
-#define X86_MATCH(model)					\
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,		\
-		INTEL_FAM6_##model, X86_FEATURE_APERFMPERF, NULL)
+#define X86_MATCH(vfm)						\
+	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_APERFMPERF, NULL)
 
 static const struct x86_cpu_id has_knl_turbo_ratio_limits[] __initconst = {
-	X86_MATCH(XEON_PHI_KNL),
-	X86_MATCH(XEON_PHI_KNM),
+	X86_MATCH(INTEL_XEON_PHI_KNL),
+	X86_MATCH(INTEL_XEON_PHI_KNM),
 	{}
 };
 
 static const struct x86_cpu_id has_skx_turbo_ratio_limits[] __initconst = {
-	X86_MATCH(SKYLAKE_X),
+	X86_MATCH(INTEL_SKYLAKE_X),
 	{}
 };
 
 static const struct x86_cpu_id has_glm_turbo_ratio_limits[] __initconst = {
-	X86_MATCH(ATOM_GOLDMONT),
-	X86_MATCH(ATOM_GOLDMONT_D),
-	X86_MATCH(ATOM_GOLDMONT_PLUS),
+	X86_MATCH(INTEL_ATOM_GOLDMONT),
+	X86_MATCH(INTEL_ATOM_GOLDMONT_D),
+	X86_MATCH(INTEL_ATOM_GOLDMONT_PLUS),
 	{}
 };
 
-- 
2.44.0

