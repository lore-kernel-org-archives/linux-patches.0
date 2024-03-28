Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A011311A0
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643318; cv=none; b=B6I8uDAg+kOdWcDTtTTiesuDaotCGI5p8L1YCWEQgSzHyI9ZbvIpEyKXGIuDFS00tNaZNrY8cACFwmbnNLHk6/2JlChu6/nnP0ilvqtYDZUN9asuzQ4CxuEJcvX5Oi1kW481fY/I8+KaBFqSRTaDzJLMr7kLxpKgeR3UEbGW1yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643318; c=relaxed/simple;
	bh=WDk3Nytz3rdQKdrZoCkbG+T02Itdm5c/GxoSZ2n45IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adW2Ojw1U/QjWgTOKifAs+75vEWJhf/JthQ3R6tNkD2LeoMxesCPaJD3UczgJ5ruhWwpZWSudblo2TDgW8GYN9MkrIUSTF8j3cR3XNz1OCWtOOE9SynT9hJ6EJQawSVJWieaX+ndtSqFaD1dQsTrC2ZUrTMwJcTIE62GVMvZxmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ia7ezMnU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ia7ezMnU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643315; x=1743179315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WDk3Nytz3rdQKdrZoCkbG+T02Itdm5c/GxoSZ2n45IU=;
  b=Ia7ezMnUeVKmtJaQsOR0W4nq0d3NPoXR4r/sl1eAiRb5UrfN6Osx0lyL
   aVfBB70yu3iBX2XGk5HxhVTzUQS5/Ge0fgagB/vve8axr+OiEul9FeNPI
   DpYQRjJJDZC+bVt/y7aR5q5ZGCMFj42pkg940zmUY9dpP/R2c0BMhoMpv
   tZ+jaghtM0dXGpGc0/LNXccy9sasEowOglDMKnEJ3FQ/D0EBP289ed//V
   pyeHJxFkTI5CsrPs+nawrxtMnoK/hA49EoxYEn1zHLCmga6oj5/WES8Hr
   WGoDelMtrLd5ApYXnH0H6RX4ndPnxIM1BP5O72jO73F5q1djFGqI/o9SY
   g==;
X-CSE-ConnectionGUID: Nj53YsIgQjivS1jglXil2Q==
X-CSE-MsgGUID: upwkRYNDQayiAOsqkiQEzA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294783"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294783"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726123"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 53/74] x86/cpu/vfm: Update drivers/platform/x86/intel_scu_wdt.c
Date: Thu, 28 Mar 2024 09:27:47 -0700
Message-ID: <20240328162820.242778-53-tony.luck@intel.com>
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
 drivers/platform/x86/intel_scu_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_wdt.c b/drivers/platform/x86/intel_scu_wdt.c
index a5031a25632e..d0b6637861d3 100644
--- a/drivers/platform/x86/intel_scu_wdt.c
+++ b/drivers/platform/x86/intel_scu_wdt.c
@@ -50,7 +50,7 @@ static struct intel_mid_wdt_pdata tangier_pdata = {
 };
 
 static const struct x86_cpu_id intel_mid_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, &tangier_pdata),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, &tangier_pdata),
 	{}
 };
 
-- 
2.44.0

