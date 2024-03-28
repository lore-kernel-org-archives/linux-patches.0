Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A34F13175E
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643312; cv=none; b=XV/4QQM93v8JDSj1UJTzmPDWzQJ/70U15FPJ2QUpJBuGx/kCu8Xo4js4QqsYcF0di4v/I5KgyxYxve2F1LT47UMyO1l4iOy9FWC6OAwBtreNMqvFvcQPafJUOvWInCe0QQyxuNStzQYxb+jfsXmpHJz/DupFfOyi25C63CsyYzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643312; c=relaxed/simple;
	bh=jXmS4EM7r0+kvBUQwZF9aW8g88ra9fhGJ+GNpy2xvRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqJANyZJoA26SNXqCqSpILCUZwb1RLWrc4hRtZny84fyB3C7wLRDgGi0GeWiQcoiN14RDQSqq5RQucJ/kFcdO8uC/hvSHKrhhozBQPuqbQWn42ONHwgZOQzigeYKiHgJpZRtLUjcydE3PR1DHeJBY4Y6YzfatcPv+z4GZ3g8OSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n8jv75YF; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n8jv75YF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643310; x=1743179310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jXmS4EM7r0+kvBUQwZF9aW8g88ra9fhGJ+GNpy2xvRo=;
  b=n8jv75YFozAul6l+1fkO/jBZiq9+QBNhAHMGEjQn8oFQwNMiSJfNOT2/
   Q4ox//3tAx7ubJO8XYrGsYqMNfBIbHrKOrGUGzxPD7FEn0F5TgS8Y8SH7
   UfM1MedOmfI/riYylSv9tF0KxPoqESj1E8BFzy+A+XPrnMRts7kRs7ZVp
   +zkg9LslNUFdu/UjWeiatwE9WxxMck8bWkAQOY4D1jBpFFGRh1Z8yguEh
   9NigAV868P3PWx7HM6+SNHD9CFz+80BUNqWoxErC0grxlR1KGHmrlzYou
   mXMMDQTbMkzGvImWkYt85lQJTiiQOZjxozt8MEa26fMwikhdDjl6RJWrS
   A==;
X-CSE-ConnectionGUID: /VhrjSVZRwWWf3ZAObrGXQ==
X-CSE-MsgGUID: sAfTEGdlQ+6qvNAhBlZSKQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294755"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294755"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726049"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 31/74] x86/cpu/vfm: Update arch/x86/kvm/vmx/vmx.c
Date: Thu, 28 Mar 2024 09:27:25 -0700
Message-ID: <20240328162820.242778-31-tony.luck@intel.com>
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

