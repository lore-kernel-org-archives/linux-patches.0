Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D9F1C2304
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495908; cv=none; b=MijpLUn725ackiYMrqXCYcFlitFhZfQ/rS/544rXvwhegwijrXcYZ5sT3TLXGLzEs7oT5Eb+DrOzvrB+DRo7Unh0QvfbF/Fn1covJ2v6VqXETo3ZUQt7kwzVkvInvCAMTl/8/vmuNI+o8szMBPBD098W3/69KwkS2aIwobdkSzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495908; c=relaxed/simple;
	bh=EzHNCGkFW4pzZxYwMtbicWPPZh4LNVsfxDMf79eOOok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDDlDRzO/EYNRPE6/eONaFDF+f0dO3lSKrDJh71aSOCcsGNFd5992M6KKTsaz9wgotZteJg0rPyX76vj6ytCTFgoqpHTknlE550K0lsgQg2/Tv1kIHgcPyOdk/IDwWQUX2AEiv2UDgFC4NrSOIcLhTo8WjRxrs+Z63uL61N41f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E8RKnQ4m; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E8RKnQ4m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495907; x=1746031907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EzHNCGkFW4pzZxYwMtbicWPPZh4LNVsfxDMf79eOOok=;
  b=E8RKnQ4mjli4XAyLDI5QjoKElEe9mlZQa3NrUvg3G6xSg9rCGweUq8YN
   AGHfEddbAaTVYMU0MSRML/ViiiRSIhpu3u0KXwEYUySBJxFWAT3B85PGr
   W2hq3SBp39umpv2xK63/6Kh3rqZnwXYk+ZHn+kbAjBFW32Xjx2mEuKvWQ
   Sp1DXvkCMaPXW4iaAwTTL6mOyj7lJLRo8cXFFTRe0dC4MlfUR7Jqlv94H
   888/Cv51vY2OJQUtfwjSnYkzQdxBk6TGG3eYkaYzN+TdNmJ7pOXXt7lRN
   +picT+gJybQL1JTvD+BfCE1ywGXggcRAmcrP9v/vgDXLcEbf4ESaMVm0u
   A==;
X-CSE-ConnectionGUID: wGFi50bmQM2qQVMHE/Ec5w==
X-CSE-MsgGUID: ddQkqXumT0iePtxfybxT+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075735"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075735"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: 0VLHcjPJTOCTYD8CqY/1zA==
X-CSE-MsgGUID: OaNTei8vTqKF+koxjRmoJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515499"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 32/47] x86/boot: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:45 -0700
Message-ID: <20240430165100.73491-32-tony.luck@intel.com>
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

New CPU #defines encode vendor and family as well as model but
boot code doesn't have all the infrastructure to use them. Hard
code the one CPU model number used here.

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

