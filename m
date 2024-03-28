Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCE4130AC8
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643312; cv=none; b=scHFNahCmHulCT3XTF/aVnWYklnZYpyPVzAoQOJrSD05e1T7iRBQ+3oO1IZ3DoHcpauD2pptdTuA9Sn1+5WoZgzvR4dl1Dm88YG45EHU+EMCwxMnk/piz93NFrl/bHMNICnjePPvIlc/DW8QbOGxyCpHu5236WbASxvpVpomLdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643312; c=relaxed/simple;
	bh=ps9rNqzKSGSOSSF+uk2bNTyXLGrRDgTAM95atyOJquA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWHsRES4MzLqffUdzIdeMRXbRixMzMpvYHDol7Wrppn7Q+zbgt8RanXyvUpuWvVgG6jTH1S+9z53aEsa1OmTX+cy2vWIvPH+11DZjv2rNigEi4vRruzjRhylgUeID47EiAX+JxLnPrqw/yVXdnWppR9/c5S5s+qyT8yP+tixhGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vc9v6G1e; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vc9v6G1e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643310; x=1743179310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ps9rNqzKSGSOSSF+uk2bNTyXLGrRDgTAM95atyOJquA=;
  b=Vc9v6G1eVf1QKtBi1XgPYmm3IkybgONFRDwYrzfKYbX/nyUIfijSBzpR
   xh+GQKduzgCepSPXU1xL49pgPo/RARPceSs5CZtELowgZLa4QXFCRo0nL
   giO7VTUYldb1KtEDlDNIZ0/6ZuOW40WA5WxSNJyrlXKV1vrCS6tZONFp8
   PMKk2ET380YJarOTOfMQkLHIrh9ibt+tzrirPV3gDOCBRjF2fnshgWwBF
   t7ynMnov65ZoIctXYnT4znKHOM5yW9h8mBLAQjQlTHRvuX7S8sSxPq8VB
   K1sbcqEIEe33wnGvn0B3ni0wiXAsw9VQcElxYYkWNHgECT48aijNY2lYV
   g==;
X-CSE-ConnectionGUID: NMiJTGGXQo+4f3gzTmYtEw==
X-CSE-MsgGUID: n4UTjUuNStiLY3W0dqzmFA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294754"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294754"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726046"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 30/74] x86/cpu/vfm: Update arch/x86/kvm/pmu.c
Date: Thu, 28 Mar 2024 09:27:24 -0700
Message-ID: <20240328162820.242778-30-tony.luck@intel.com>
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

