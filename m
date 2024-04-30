Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B1117F397
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495897; cv=none; b=WzRJccAmVVqAn/2s+ZWV6MGk0U+h4HHIEKf6fu9arh+5Go6PM0+8VKg+yVmfJyHmH8PdMRAD+Epnb+9JKMMQNHv8NTtjR6PiP2WRgv1i5vI1Y7vknlZktPRwG1q9HZ6Al2xFvUykimWob2SKF4NBmJA6A8n57r18F2zhzTiXsNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495897; c=relaxed/simple;
	bh=DTmj/yYZ5S3zG9s0UR1lWeqfV7XL+xXwEY+aB15HzFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2yz136MW0JR3SO+dAF2YLxsfXWDWhxxgNIvYHSa8D6S0hAGaRaTNAQEhW4G08P0vgLtTqat1NhrBfKzdIsHD2GLCpWfwuYu08i+MLNk3ZTXwbT5OxcgryI9fhNT10ElS+8ie/yPUoSzbhfAGHfn6mqYD4WrWRWq5iklnjaSb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b4KUusvS; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b4KUusvS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495896; x=1746031896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DTmj/yYZ5S3zG9s0UR1lWeqfV7XL+xXwEY+aB15HzFA=;
  b=b4KUusvSFBu+M1Pfyvn1GBxAvKe8IVULMzE83OAniL9ITk8sFiSkYKP+
   aqAUNXda3PivAGSEN2p+CI9UK3kzZr7kFNVXwLTzL0MikH0eDgdkdTYX/
   s5UsLv6P8kSd5oMSJ+GD6qJqcENM7DXNKINguA03rGvs44oRn+1j2YBiO
   hZlAtR6sZo7Hw115snLHj2oSepbVRKeC3bLqfKxW6gtUNiM2vuBQakNq2
   kvQ0PPvxWX61N/G33cpvA/M9kof2pKCYsu1m/6BbNBW9wSA7fRnPaeX5a
   raaKNLfO4FYctSBUiOoYIQYibwl3OOeL7I2BDD4LrD5gZ25q/BJQDToru
   Q==;
X-CSE-ConnectionGUID: 3FSlImdvRW6kAeW/Lu3uiw==
X-CSE-MsgGUID: a3WvBTrTQEGjLwbRpZ8cUQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075625"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075625"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: anfkp59/Qg6H7QpFiAyMdQ==
X-CSE-MsgGUID: 6BisjhuYQrekitoFHVbG5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515421"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v5 07/47] KVM: VMX: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:20 -0700
Message-ID: <20240430165100.73491-7-tony.luck@intel.com>
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
Acked-by: Sean Christopherson <seanjc@google.com>
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

