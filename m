Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7B959B4E
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643308; cv=none; b=qdJJuuqvztSZWkFFyp5WDw0xTplaN/L8uhgUAqjLlXZjBI4mxTp6FBQwnT8mPYw9N+xfREhMPUJK+Zp2G9MxM5PK64ARw+91xNf4rIyd/MNsDlCPdmnQW/jaKhxS6OBBOLzc2H9msKoxKYbvF1SZM4QUnt5+uv8/rbcLfa/Se4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643308; c=relaxed/simple;
	bh=SHMkDQNhLJVSbQAhNMfggf+iNz/SzZPr73nQsNDr5PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qdw/iwd11vyT3LRoKNU03NACogEe05v1c8eSE7rlm5zgNdkVksIRvlA4LHdG8zsbTs6b/REoJGixR7TxMwNGgPBM40MWSU5oRT0oyu6hltAyzQRwonX7TapSmtl+67LC3sO4H7a0CJh1zM5Rh5/Xf2SR6HXQ1QO49bWsd8h2vkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWIPLCDf; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWIPLCDf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643305; x=1743179305;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SHMkDQNhLJVSbQAhNMfggf+iNz/SzZPr73nQsNDr5PA=;
  b=TWIPLCDfk2/91d9LRIaqnlGdVys0+3hG+eUC1xyXNftPF1+2WeU4rtI/
   3Fx5F/BQae67kSBJW/+MM/Ue+VJM8TNK9KAQr2eew3BWurtvceeJefmAJ
   dUMhZYyLay2pElBu5eSbIBCVGGQNNrz9uswwmAW1qXlfttqk4t/cB/Hme
   cXGImsDTVw/3j7rVn4YUq8uCCn8MSo/Bi0dxhAvt3aBwQJhybcNKR9a+I
   tHONlno1V6ksgYSSsTs9He6zynWKmi+KHFCuYm4oQfAezpAfY434mmNaj
   KgqZzvoTg/SNzwv1nhqnVX4BRd8GkYAMCyUymsLd6VqVS9A40CIaSuFFz
   A==;
X-CSE-ConnectionGUID: x5J7gRydRmakH88bx1p2oQ==
X-CSE-MsgGUID: SCYGJj3OS2WovSelfMyt7A==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294732"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294732"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725979"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 11/74] x86/cpu/vfm: Update arch/x86/events/intel/uncore_snbep.c
Date: Thu, 28 Mar 2024 09:27:05 -0700
Message-ID: <20240328162820.242778-11-tony.luck@intel.com>
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
 arch/x86/events/intel/uncore_snbep.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 2eaf0f339849..74b8b21e8990 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* SandyBridge-EP/IvyTown uncore support */
+#include <asm/cpu_device_id.h>
 #include "uncore.h"
 #include "uncore_discovery.h"
 
@@ -3285,7 +3286,7 @@ void bdx_uncore_cpu_init(void)
 	uncore_msr_uncores = bdx_msr_uncores;
 
 	/* Detect systems with no SBOXes */
-	if ((boot_cpu_data.x86_model == 86) || hswep_has_limit_sbox(BDX_PCU_DID))
+	if (boot_cpu_data.x86_vfm == INTEL_BROADWELL_D || hswep_has_limit_sbox(BDX_PCU_DID))
 		uncore_msr_uncores[BDX_MSR_UNCORE_SBOX] = NULL;
 
 	hswep_uncore_pcu.constraints = bdx_uncore_pcu_constraints;
@@ -5394,7 +5395,7 @@ static int icx_iio_get_topology(struct intel_uncore_type *type)
 static void icx_iio_set_mapping(struct intel_uncore_type *type)
 {
 	/* Detect ICX-D system. This case is not supported */
-	if (boot_cpu_data.x86_model == INTEL_FAM6_ICELAKE_D) {
+	if (boot_cpu_data.x86_vfm == INTEL_ICELAKE_D) {
 		pmu_clear_mapping_attr(type->attr_update, &icx_iio_mapping_group);
 		return;
 	}
-- 
2.44.0

