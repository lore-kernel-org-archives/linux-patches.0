Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDD8214A78
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 21:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754948162; cv=none; b=XGDQ4U6MdqxgjMhstKD2pnPCStl91h4VS27ItcHn5O5OThS6GHWNuHlDHEPOD0JWQrEdLi0VxHbQA2rWu+CjKWmTyp5ohTWpJGpOesyufcqL1ll60nanVOalCRosNyQhTC/cqK72dqqJUmsDyLBVm7XrMIGJV9uobVCEQCeeXzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754948162; c=relaxed/simple;
	bh=Td5Y69wZ/vqDs+pwAUfa4E8sns/AAfWGCvdYmRZ+mCU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UQ5V/wgrlTJ8Oe/7nrMf0ngHU0Ww4hwBv05L0bIJMYpujJ2P5kSQxUXu3HCYz6ovgKN4gkQMnrCt6mKVfc0KTOj+pkWTCa5c+RY4MhGHdSLsZrsXRGFNNwBYRBYWM5Ge9cQOqlUJUK1n/yJv+j3C1CyW5/h6cJsJkHKNAzSciJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OUVpraiN; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OUVpraiN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754948161; x=1786484161;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Td5Y69wZ/vqDs+pwAUfa4E8sns/AAfWGCvdYmRZ+mCU=;
  b=OUVpraiNfjH65hu/E4gxA5029gJSdu2UWhpUCU2tpZ8RjzxfRU18y8r3
   tjjiK9wWO1eGXNLe/PhaBUewBhNqvEB8WewEsQLM+NtIXn0iYR+ngAoI2
   d8CqsplHCtGCFHx7gqXf4XFPSG6xXpuchIGbSnf2TnXYPY0pXUXZJTzL2
   Xt7IGYtWisRWoqHkGESzVAC0iTHsjzs/ZBDV+Fan7rt2Hfg9EbYhYpPAK
   IB8Qt4e5PKy9hyurilwNLZWqls3DbTY//l5dpjlUfwVIIqLpSVM6iV708
   VqcPnkOoXLokmVmNOSoR+xuBDs5Sb1KWyghMiTZHqvqJvarC5Y6BSodli
   A==;
X-CSE-ConnectionGUID: 2edOjk0MSDyFHmUu+Onu4g==
X-CSE-MsgGUID: XJdczAUtS7+gzVVN579VtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="56928250"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="56928250"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 14:33:57 -0700
X-CSE-ConnectionGUID: QkRI21NpR6+402jaftRBFA==
X-CSE-MsgGUID: UQP9UUmJQlSxyxiIhbTHOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="189696396"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 14:33:56 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Rename and move CPU model entry for Diamond Rapids
Date: Mon, 11 Aug 2025 14:33:45 -0700
Message-ID: <20250811213345.7029-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This model was added as INTEL_PANTHERCOVE_X (based on the name of the
core) with a comment that the platform name is Diamond Rapids. It was
also placed at the end of the file in a new section for family 19
processors.

This is different from previous naming. Andrew Cooper complained.
PeterZ agreed and posted a patch[1] to fix the name and move it in
sequence with other Xeon servers. But without a commit description or
sign-off the patch wasn't ever applied.

Patch updated to cover one additional use of the #define by turbostat
and to change the "Family 6" comment to also list 18 and 19 since new
models in these families are mixed in with family 6.

Link: https://lore.kernel.org/all/20250214130205.GK14028@noisy.programming.kicks-ass.net/ # [1]

Originally-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h                        | 7 +++----
 .../platform/x86/intel/speed_select_if/isst_if_common.c    | 2 +-
 drivers/platform/x86/intel/tpmi_power_domains.c            | 2 +-
 tools/power/x86/turbostat/turbostat.c                      | 2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index e345dbdf933e..f32a0eca2ae5 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -51,7 +51,7 @@
 #define INTEL_PENTIUM_MMX		IFM(5, 0x04) /* P55C */
 #define INTEL_QUARK_X1000		IFM(5, 0x09) /* Quark X1000 SoC */
 
-/* Family 6 */
+/* Family 6, 18, 19 */
 #define INTEL_PENTIUM_PRO		IFM(6, 0x01)
 #define INTEL_PENTIUM_II_KLAMATH	IFM(6, 0x03)
 #define INTEL_PENTIUM_III_DESCHUTES	IFM(6, 0x05)
@@ -126,6 +126,8 @@
 #define INTEL_GRANITERAPIDS_X		IFM(6, 0xAD) /* Redwood Cove */
 #define INTEL_GRANITERAPIDS_D		IFM(6, 0xAE)
 
+#define INTEL_DIAMONDRAPIDS_X		IFM(19, 0x01) /* Panther Cove */
+
 #define INTEL_BARTLETTLAKE		IFM(6, 0xD7) /* Raptor Cove */
 
 /* "Hybrid" Processors (P-Core/E-Core) */
@@ -203,9 +205,6 @@
 #define INTEL_P4_PRESCOTT_2M		IFM(15, 0x04)
 #define INTEL_P4_CEDARMILL		IFM(15, 0x06) /* Also Xeon Dempsey */
 
-/* Family 19 */
-#define INTEL_PANTHERCOVE_X		IFM(19, 0x01) /* Diamond Rapids */
-
 /*
  * Intel CPU core types
  *
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 71e104a068e9..7449873c3d40 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -790,7 +790,7 @@ static const struct x86_cpu_id isst_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	SST_HPM_SUPPORTED),
 	X86_MATCH_VFM(INTEL_ICELAKE_D,		0),
 	X86_MATCH_VFM(INTEL_ICELAKE_X,		0),
-	X86_MATCH_VFM(INTEL_PANTHERCOVE_X,	SST_HPM_SUPPORTED),
+	X86_MATCH_VFM(INTEL_DIAMONDRAPIDS_X,	SST_HPM_SUPPORTED),
 	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	0),
 	X86_MATCH_VFM(INTEL_SKYLAKE_X,		SST_MBOX_SUPPORTED),
 	{}
diff --git a/drivers/platform/x86/intel/tpmi_power_domains.c b/drivers/platform/x86/intel/tpmi_power_domains.c
index 9d8247bb9cfa..e8d103782d64 100644
--- a/drivers/platform/x86/intel/tpmi_power_domains.c
+++ b/drivers/platform/x86/intel/tpmi_power_domains.c
@@ -85,7 +85,7 @@ static const struct x86_cpu_id tpmi_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	NULL),
 	X86_MATCH_VFM(INTEL_ATOM_DARKMONT_X,	NULL),
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_D,	NULL),
-	X86_MATCH_VFM(INTEL_PANTHERCOVE_X,	NULL),
+	X86_MATCH_VFM(INTEL_DIAMONDRAPIDS_X,	NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, tpmi_cpu_ids);
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 72a280e7a9d5..47eb2d4d13a5 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1195,7 +1195,7 @@ static const struct platform_data turbostat_pdata[] = {
 	{ INTEL_EMERALDRAPIDS_X, &spr_features },
 	{ INTEL_GRANITERAPIDS_X, &spr_features },
 	{ INTEL_GRANITERAPIDS_D, &spr_features },
-	{ INTEL_PANTHERCOVE_X, &dmr_features },
+	{ INTEL_DIAMONDRAPIDS_X, &dmr_features },
 	{ INTEL_LAKEFIELD, &cnl_features },
 	{ INTEL_ALDERLAKE, &adl_features },
 	{ INTEL_ALDERLAKE_L, &adl_features },
-- 
2.50.1

