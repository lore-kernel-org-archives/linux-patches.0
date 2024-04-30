Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8782B184135
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495900; cv=none; b=Yn602gp8ChzVZB6wtxBb0VAC+lT8WE22HlHi3KYzj1pVh3kBoU5+SFmCNfmm7308NAcGklHVJulIHaxhVjIwIYcPLl9eauth+AHkskqlsnGXMtHWWgp2IXwtNNsD6V3T0UGTne2I7z2u72QtdEshbbljAI4IxyP7vMbB4wRNjVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495900; c=relaxed/simple;
	bh=UM/R+mI/W21KnKAJqgtQCB1iHQKdULAasN6DfUW+ROs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNuDtdrDI9NqLB58TK0J4iGzlTDJRUR9YsH4LnV4mEpvZwFk5yRFpZzWr9mPWghbZh0AonfMyGIJZSCwK1LIsGi2OvuO2HOhmVMt26u93DX+BEL00E+8eoDzb5joaXs640TLEB71MsTs2/lKvuaoEmn61rlTPCLEid/hupTwBK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VbLwTtL/; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VbLwTtL/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495899; x=1746031899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UM/R+mI/W21KnKAJqgtQCB1iHQKdULAasN6DfUW+ROs=;
  b=VbLwTtL/S1kNtKskgopjOndjZkO29IcZHn2G1ZIQTQC7gsEGT7f4VQIr
   pvy+pAB8WU2VfPog5ffL+GqDrRvVK16S5izZp/rB49xperqhd671s6DeW
   drlkd7GOpdCa/9lKeo3WdkJHGBcsKWosX53rDmSUuVvXcOgR61E/7I3qH
   F2/a7+d5D5YeshtFxTPGsG784R+n/bBD/BUMmcPz3dcUbmFokMMbYQHQi
   esyE+fs+8BKFrBiRkAjqTasmEKOdQXV3vxml/C8yzCFNSccG4uQkCG3TK
   b38YgAXVGvSuHdIGxWiQrEgqKMBPakfcU5YcCUs1AByyTfeIMJzlK08s2
   w==;
X-CSE-ConnectionGUID: WNHhGu7rQne3AHB7fUTfoQ==
X-CSE-MsgGUID: SM5Adx+VSDSVbnVtSkewzw==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075658"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075658"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: 7xy4iIbwTnWB3NFrn7IskA==
X-CSE-MsgGUID: oERwbzFfTyq56//e+8I41w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515441"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:13 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v5 15/47] platform/x86: intel_speed_select_if: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:28 -0700
Message-ID: <20240430165100.73491-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
index 1b6eab071068..6c36f7704fe7 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
@@ -161,7 +161,7 @@ static struct notifier_block isst_pm_nb = {
 };
 
 static const struct x86_cpu_id isst_if_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X, NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, isst_if_cpu_ids);
-- 
2.44.0

