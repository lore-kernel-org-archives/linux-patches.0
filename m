Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0A213D500
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302416; cv=none; b=PvNYNglSo7EMIkICn65BvC7DqMiItDBQ/9jCqqmuBGgqoYylEKayhXsmgyyODOOUiCFxg49rXgVf4pnkwlggm0uCkRQUYD323WPVoaQEidDmLx2VX8+57UIeS4XQ1EjtWUKw/yGLJ5VDtb4ElPERDkkvIcexqsz4n4LCFdIljoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302416; c=relaxed/simple;
	bh=jXmS4EM7r0+kvBUQwZF9aW8g88ra9fhGJ+GNpy2xvRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bN2D+o/9mqhVG9HSOO3U5bFCA+sUapVCpNvWe7tGxdLp+5Ja/6DvVp996isfnpZIiMAJjv+JB+RAFsBux3NML10t/eVbD2bmscywGDbgounOdNeQ8li2it1aqNTEPAYfIep5uDbKmgnyPnMVpom8QGmnmsZHRvyUyoNH/ud0q8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bdMHpZ/b; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bdMHpZ/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302413; x=1744838413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jXmS4EM7r0+kvBUQwZF9aW8g88ra9fhGJ+GNpy2xvRo=;
  b=bdMHpZ/bvkkfjsKUpK1wiqbk6GdvgT4irpp7F8bb0FTKnYMEZzSq+7pr
   UKXwL9T7OEm0P22k8k8lTIWULNehtZ9F67AVJvFJERCHfbXDf3a6LxpQo
   GCFce2IWA8LN0DdbylR0+pLJmlC61MTDNTvWOB5s0EPjxsjmYCEGtl74m
   ZNGbf0OGdUxVugj2M7ly0nU3sEPkA36EqmVJGKbWFHItnHspBklbp8Rnv
   xV8NZ0h2SWhW5ES7tpId3ChVKjoVNrpGouE70xeHq5xdZtTOdztX1xN4a
   NMfHeWgBMtlDpxIapLS2DUOGvGVR1+g0kELhcsv+F+3efkmD86nkDNNj2
   A==;
X-CSE-ConnectionGUID: 47qXrqM4Rkas0NyaWoT/0g==
X-CSE-MsgGUID: dccFxlkJS5e2tuJ4oig4xw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914815"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914815"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:02 -0700
X-CSE-ConnectionGUID: YmLKKXS8Q+OVBrgG9Hcdmw==
X-CSE-MsgGUID: dQvrz27wSuOHxJq6KYgSmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22872010"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 31/74] x86/cpu/vfm: Update arch/x86/kvm/vmx/vmx.c
Date: Tue, 16 Apr 2024 14:19:33 -0700
Message-ID: <20240416211941.9369-32-tony.luck@intel.com>
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
 arch/x86/kvm/vmx/vmx.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37a89eda90f..2c747f2642c6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2518,17 +2518,15 @@ static bool cpu_has_sgx(void)
  */
 static bool cpu_has_perf_global_ctrl_bug(void)
 {
-	if (boot_cpu_data.x86 == 0x6) {
-		switch (boot_cpu_data.x86_model) {
-		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
-		case INTEL_FAM6_NEHALEM:	/* AAP115 */
-		case INTEL_FAM6_WESTMERE:	/* AAT100 */
-		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
-		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
-			return true;
-		default:
-			break;
-		}
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_NEHALEM_EP:	/* AAK155 */
+	case INTEL_NEHALEM:	/* AAP115 */
+	case INTEL_WESTMERE:	/* AAT100 */
+	case INTEL_WESTMERE_EP:	/* BC86,AAY89,BD102 */
+	case INTEL_NEHALEM_EX:	/* BA97 */
+		return true;
+	default:
+		break;
 	}
 
 	return false;
-- 
2.44.0

