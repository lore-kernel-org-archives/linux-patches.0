Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6CB130A4F
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643312; cv=none; b=pyt/s3caIe9LTkGBGXEsPip8x9AnVfYBaZ3lXF0k8ez+yNvsQDsjtPzAJKhvpVdVaHsmTatEPeyMvSkHjAvMclmi5/YbJ1wj2zbosedoKbYnb/dkCEodngXA7VyM2VoFqq5OeoeG36i16bbxhYQTYR5hWuoYZZrk8LTZbr4C5HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643312; c=relaxed/simple;
	bh=G4t+oufuiWfevvnnKG7dGJPRWJMmXMgYV/G6McWVaD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPbxz6gOsgQEwmqsYMWzbB8zcPsCqxlqqzRbaOEN8ZOSaY/ikpxPS5CINq0ix+7987mKlPBGK/HfxXSrDsI6ozY8MU/SSk2BXGD83R40eh4FSOOMV1mcDD9nos7oIZWeBVCLsAXRIebhOy1DbqG29EVToYNstIfgbeDW+Zv1iRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDlpS5S5; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDlpS5S5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643309; x=1743179309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G4t+oufuiWfevvnnKG7dGJPRWJMmXMgYV/G6McWVaD8=;
  b=mDlpS5S5I2BH6u24Y1RQomfnVgLYjeqrBUIJzjTaLiUQCeTbZYbMy+bX
   yx0W3kvs1fFmfPtY/umVd7PvODXghfCwxHezMIQFb3BWSv9B2vQpVTc/d
   tE59VnGTDgUJF1k5esgevLZcpPaeFlkQtdqT7skQiRw3sQEay1zNa7P5U
   sEWrmUmY8qmWZYee3oulhMto6RNvknFQdaVIXU8I3ooOF1yutKBtFm4/Q
   cv9GpM9YFxgGOTc3UQcgHNFu+QVMMUtw/Kr+Icz7kBNsQCk4kFvYxxTwM
   QtvtYHDreC305x6h2LvIylOsbHfe5j4Xprog6oV0h4++NKh+S1u4nP0al
   A==;
X-CSE-ConnectionGUID: VxH86Y0kR3qSkC8cqb9rxw==
X-CSE-MsgGUID: youEbkLeSWaoLYT9epznAg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294749"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294749"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726033"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 26/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/resctrl/pseudo_lock.c
Date: Thu, 28 Mar 2024 09:27:20 -0700
Message-ID: <20240328162820.242778-26-tony.luck@intel.com>
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

