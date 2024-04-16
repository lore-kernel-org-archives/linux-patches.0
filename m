Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D1E13C8E2
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302412; cv=none; b=ee1O7FzDuiCSWX8IliSRsacBNlgNSJvVGIGl7yYgzrVhjAOrohUZypu6bk/n12wJD1/VW8I7Z7KLKhX6bTr7UGYmoISAjLB7Mo+iU+4li5gZ611ZQW5GNsuR7bV+9zBLOW3eSDrs+ctX2gOGrwq8QyxRCl9q9VQel2Bugsyvao8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302412; c=relaxed/simple;
	bh=G4t+oufuiWfevvnnKG7dGJPRWJMmXMgYV/G6McWVaD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQsqluUeoLRY7ZJ5uK7Ew4nF9dVCVL2bT3oOex6BwePu1GGe0Oazswv/YP4uBDQbY7YCxggQ9Gu89pizhCTEyFibx20WAdcAoCrEv3bhrE7PB5FapDGuiRpdDox2mcZot7Kgulxf0ujHLDwPwBjlqaGoidGSPadPV8mwehxVhTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJdFL/0m; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJdFL/0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302410; x=1744838410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G4t+oufuiWfevvnnKG7dGJPRWJMmXMgYV/G6McWVaD8=;
  b=kJdFL/0m8Vgmi6wBPPb1Bt1UpvtRgZFPjw6kV/xl3BRczyvMYlq56x4R
   oKKVoAQmHgHeMAFoivT5+y6BCtlMNND0S4tqiVMcX12Js9TV+CXO2U6b+
   Cvk+O4Qx/PIv9hNS08hBzU+W6UKU5XV7BOHodeFbkK/goQI0M0xwzJgRJ
   kMrhfSgUwYJy+Iy3TeKn2IJ4b0SQ5OPsyoGi3vrBKJEY3l0NQJKyxIDy9
   GcdcO3Nt7mOxLektRAnvzc0O7gPMGEw+4J6Y+NKBgV/sejGpDbEossES+
   yPTc3tkrUpdBbZTeNOVGj6ri/5Bh8PVZCRBuO2SPhjgXD+E5oV1pk+MR7
   w==;
X-CSE-ConnectionGUID: Oec9UfRiSriJr/zpQdYjUQ==
X-CSE-MsgGUID: 2AvPRJWnSLmVvWRcraSj4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914792"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914792"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
X-CSE-ConnectionGUID: KllF7TpVTm6QLorEhQCEpA==
X-CSE-MsgGUID: jGVcYaaBRaiWdcuW7aOySA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871976"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 26/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/resctrl/pseudo_lock.c
Date: Tue, 16 Apr 2024 14:19:28 -0700
Message-ID: <20240416211941.9369-27-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 884b88e25141..a068f0c3bc20 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/cacheflush.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/resctrl.h>
 #include <asm/perf_event.h>
@@ -88,8 +89,8 @@ static u64 get_prefetch_disable_bits(void)
 	    boot_cpu_data.x86 != 6)
 		return 0;
 
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_BROADWELL_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_BROADWELL_X:
 		/*
 		 * SDM defines bits of MSR_MISC_FEATURE_CONTROL register
 		 * as:
@@ -100,8 +101,8 @@ static u64 get_prefetch_disable_bits(void)
 		 * 63:4 Reserved
 		 */
 		return 0xF;
-	case INTEL_FAM6_ATOM_GOLDMONT:
-	case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
+	case INTEL_ATOM_GOLDMONT:
+	case INTEL_ATOM_GOLDMONT_PLUS:
 		/*
 		 * SDM defines bits of MSR_MISC_FEATURE_CONTROL register
 		 * as:
@@ -1084,9 +1085,9 @@ static int measure_l2_residency(void *_plr)
 	 *     L2_HIT   02H
 	 *     L2_MISS  10H
 	 */
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_ATOM_GOLDMONT:
-	case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_ATOM_GOLDMONT:
+	case INTEL_ATOM_GOLDMONT_PLUS:
 		perf_miss_attr.config = X86_CONFIG(.event = 0xd1,
 						   .umask = 0x10);
 		perf_hit_attr.config = X86_CONFIG(.event = 0xd1,
@@ -1123,8 +1124,8 @@ static int measure_l3_residency(void *_plr)
 	 *       MISS      41H
 	 */
 
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_BROADWELL_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_BROADWELL_X:
 		/* On BDW the hit event counts references, not hits */
 		perf_hit_attr.config = X86_CONFIG(.event = 0x2e,
 						  .umask = 0x4f);
@@ -1142,7 +1143,7 @@ static int measure_l3_residency(void *_plr)
 	 */
 
 	counts.miss_after -= counts.miss_before;
-	if (boot_cpu_data.x86_model == INTEL_FAM6_BROADWELL_X) {
+	if (boot_cpu_data.x86_vfm == INTEL_BROADWELL_X) {
 		/*
 		 * On BDW references and misses are counted, need to adjust.
 		 * Sometimes the "hits" counter is a bit more than the
-- 
2.44.0

