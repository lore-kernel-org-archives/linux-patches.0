Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C530813CFA9
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302413; cv=none; b=hUXsExVawC2i6viE2yk9Zqy3prr9kzxOelotBoIsHWcixjDh85Dts1IEANi9f+5ZcdgF/53vcMzU15EUlzHlkp7vTG1VVMSUzLzmzWm8vXMh7zW+tlnBSUCcVdSXRelO7pd03CVrKX8uRA9lh8qEKPuSAKHKu/z5fNhzRwSaZeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302413; c=relaxed/simple;
	bh=dCC5e5zdUWP8nN10zczP7r4e33cRc3Nah82w39Vvy74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8s4Cb//bULDdYRKHIPc1YT/njWUO2qVf04UoEZjemrxsVKkbwnaMmuGO0OwW1Au6sc8a36wimfShy+62YdqNNFki34gqBrYJ9l9BK1ecX3bCkKNg/AQJjl8nMO855INQ3IcvV1ZKjby+1TzjZ6Ad9t/hzeRD7zBpt/C5pGBIdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XfFwV+D1; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XfFwV+D1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302412; x=1744838412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dCC5e5zdUWP8nN10zczP7r4e33cRc3Nah82w39Vvy74=;
  b=XfFwV+D1Z/+b5mfgFa/vX23lUU+a9rInp6URfbjUllKf6NP+1SMLQRYh
   9c/WeGoBMvs0CUPpFCRB2hlNtNELjNSjFlQlgmfXbfQdRBsWLM1Y8gNAp
   LK4f3wgG5FOPEH5R6AZ0Q8dZG4t4lVbu0gA79s6o0d/pnULArkx16EjDT
   P9nvCnc2bxnAxlZefviNrE1r5SEZjntVuQcNLSbq5fpXuni1h/X4X5no+
   +FReeRJVVYB6PP9OJrVx0vHHpdhOwE1rOyB3MfS8du+2LQsIzBpCo0lAu
   b+O/o+YrHYUG568+KQ0t0T5uJu3JfYgLWo2ab4jQAnYa+YdDw0U1AnOq0
   Q==;
X-CSE-ConnectionGUID: DnGk+icuT1iPvhqhTgTJng==
X-CSE-MsgGUID: NUwJTOBlSpmxqwVWi3zP3w==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914806"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914806"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
X-CSE-ConnectionGUID: YWSaaA5GTcSY8jmub7GgTA==
X-CSE-MsgGUID: T6zItUXeTgawv/8wVvA9Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871999"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 29/74] x86/cpu/vfm: Update arch/x86/kernel/tsc_msr.c
Date: Tue, 16 Apr 2024 14:19:31 -0700
Message-ID: <20240416211941.9369-30-tony.luck@intel.com>
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

