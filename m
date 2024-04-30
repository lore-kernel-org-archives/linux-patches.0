Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC6417BB0C
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495908; cv=none; b=qXI7ZDiHltWj4CaTQ4CohjLuble+2MnT98yEBWUDOSh7q7tI/kPWn8Qh0E0nipIGx+oOLD9UllQq0guvDjbliIUC//UFbFDbMpTFCQf+PrSWJtBA+YKlVuQwxTHwoM70jkinbD38CI46aTP9+FoyqvjHxTAnwLsfoLe1RTj6yoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495908; c=relaxed/simple;
	bh=C2SAJMjIbQgdrQxrsryoRU0tt7pO/DJgVRUdu2geuCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWH5Y8kxzlTCNkcpIPQtF2qPSx2l6JdAbvRIaNm2NB5do4WvrnzYTlJivsF3dJ+7qmDDiBtd/PncVbVNdFqmv+2456WQIJ9OL/klKgfwy6Rul+/9zM8ldfXLsnYFCVW/x6o6fXyKmHPVd0e1g17ckd0WneW5vfjBAbyuOWIh62o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WD/ZeRth; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WD/ZeRth"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495906; x=1746031906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C2SAJMjIbQgdrQxrsryoRU0tt7pO/DJgVRUdu2geuCU=;
  b=WD/ZeRthmjqHcqtb+Ov+oTrT+2xJgQLMa0BH+lTMODKb5Gznx7KmUS4n
   hCxe8CX5LmB7Xj1qMbWoibNtCovpoTSerUm387pgx+DHJ9ps/rjN9m+kS
   yAmxdbv+62ZMOACsLP5cp07p9JsTX/lBlPupyIc3hYaVmzTUxg6JUJqIH
   Cdk0J7eOiPvqLwiOIOL6B7+jIPpZMQmF16RJCIfpG0ux2tR8hedZrQTRd
   C7Lj+/ZD+g14SIQf1MciAI0M0q0CyVq0OjLYNU+VZXo0XuuUIEkQiYWpr
   2uj7bXcHWqRnbN9tBdHQ/9L5f43pQ7IsTwhVrm/WbxKrSoBlIwwJ6+uy/
   g==;
X-CSE-ConnectionGUID: /xQVYBC0RUus6+QODae39g==
X-CSE-MsgGUID: 4NAFqUUFS1OosRWg/P7kTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075725"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075725"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:22 -0700
X-CSE-ConnectionGUID: y4nESYRPTC+zjffwKmOT+w==
X-CSE-MsgGUID: 51VGHKiDSEKnwwwzYnwt4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515485"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 26/47] x86/cpu/intel: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:39 -0700
Message-ID: <20240430165100.73491-26-tony.luck@intel.com>
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
---
 arch/x86/kernel/cpu/intel.c | 108 ++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3c3e7e5695ba..98ff73c6ace0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -72,19 +72,19 @@ static bool cpu_model_supports_sld __ro_after_init;
  */
 static void check_memory_type_self_snoop_errata(struct cpuinfo_x86 *c)
 {
-	switch (c->x86_model) {
-	case INTEL_FAM6_CORE_YONAH:
-	case INTEL_FAM6_CORE2_MEROM:
-	case INTEL_FAM6_CORE2_MEROM_L:
-	case INTEL_FAM6_CORE2_PENRYN:
-	case INTEL_FAM6_CORE2_DUNNINGTON:
-	case INTEL_FAM6_NEHALEM:
-	case INTEL_FAM6_NEHALEM_G:
-	case INTEL_FAM6_NEHALEM_EP:
-	case INTEL_FAM6_NEHALEM_EX:
-	case INTEL_FAM6_WESTMERE:
-	case INTEL_FAM6_WESTMERE_EP:
-	case INTEL_FAM6_SANDYBRIDGE:
+	switch (c->x86_vfm) {
+	case INTEL_CORE_YONAH:
+	case INTEL_CORE2_MEROM:
+	case INTEL_CORE2_MEROM_L:
+	case INTEL_CORE2_PENRYN:
+	case INTEL_CORE2_DUNNINGTON:
+	case INTEL_NEHALEM:
+	case INTEL_NEHALEM_G:
+	case INTEL_NEHALEM_EP:
+	case INTEL_NEHALEM_EX:
+	case INTEL_WESTMERE:
+	case INTEL_WESTMERE_EP:
+	case INTEL_SANDYBRIDGE:
 		setup_clear_cpu_cap(X86_FEATURE_SELFSNOOP);
 	}
 }
@@ -106,9 +106,9 @@ static void probe_xeon_phi_r3mwait(struct cpuinfo_x86 *c)
 	 */
 	if (c->x86 != 6)
 		return;
-	switch (c->x86_model) {
-	case INTEL_FAM6_XEON_PHI_KNL:
-	case INTEL_FAM6_XEON_PHI_KNM:
+	switch (c->x86_vfm) {
+	case INTEL_XEON_PHI_KNL:
+	case INTEL_XEON_PHI_KNM:
 		break;
 	default:
 		return;
@@ -134,32 +134,32 @@ static void probe_xeon_phi_r3mwait(struct cpuinfo_x86 *c)
  * - Release note from 20180108 microcode release
  */
 struct sku_microcode {
-	u8 model;
+	u32 vfm;
 	u8 stepping;
 	u32 microcode;
 };
 static const struct sku_microcode spectre_bad_microcodes[] = {
-	{ INTEL_FAM6_KABYLAKE,		0x0B,	0x80 },
-	{ INTEL_FAM6_KABYLAKE,		0x0A,	0x80 },
-	{ INTEL_FAM6_KABYLAKE,		0x09,	0x80 },
-	{ INTEL_FAM6_KABYLAKE_L,	0x0A,	0x80 },
-	{ INTEL_FAM6_KABYLAKE_L,	0x09,	0x80 },
-	{ INTEL_FAM6_SKYLAKE_X,		0x03,	0x0100013e },
-	{ INTEL_FAM6_SKYLAKE_X,		0x04,	0x0200003c },
-	{ INTEL_FAM6_BROADWELL,		0x04,	0x28 },
-	{ INTEL_FAM6_BROADWELL_G,	0x01,	0x1b },
-	{ INTEL_FAM6_BROADWELL_D,	0x02,	0x14 },
-	{ INTEL_FAM6_BROADWELL_D,	0x03,	0x07000011 },
-	{ INTEL_FAM6_BROADWELL_X,	0x01,	0x0b000025 },
-	{ INTEL_FAM6_HASWELL_L,		0x01,	0x21 },
-	{ INTEL_FAM6_HASWELL_G,		0x01,	0x18 },
-	{ INTEL_FAM6_HASWELL,		0x03,	0x23 },
-	{ INTEL_FAM6_HASWELL_X,		0x02,	0x3b },
-	{ INTEL_FAM6_HASWELL_X,		0x04,	0x10 },
-	{ INTEL_FAM6_IVYBRIDGE_X,	0x04,	0x42a },
+	{ INTEL_KABYLAKE,	0x0B,	0x80 },
+	{ INTEL_KABYLAKE,	0x0A,	0x80 },
+	{ INTEL_KABYLAKE,	0x09,	0x80 },
+	{ INTEL_KABYLAKE_L,	0x0A,	0x80 },
+	{ INTEL_KABYLAKE_L,	0x09,	0x80 },
+	{ INTEL_SKYLAKE_X,	0x03,	0x0100013e },
+	{ INTEL_SKYLAKE_X,	0x04,	0x0200003c },
+	{ INTEL_BROADWELL,	0x04,	0x28 },
+	{ INTEL_BROADWELL_G,	0x01,	0x1b },
+	{ INTEL_BROADWELL_D,	0x02,	0x14 },
+	{ INTEL_BROADWELL_D,	0x03,	0x07000011 },
+	{ INTEL_BROADWELL_X,	0x01,	0x0b000025 },
+	{ INTEL_HASWELL_L,	0x01,	0x21 },
+	{ INTEL_HASWELL_G,	0x01,	0x18 },
+	{ INTEL_HASWELL,	0x03,	0x23 },
+	{ INTEL_HASWELL_X,	0x02,	0x3b },
+	{ INTEL_HASWELL_X,	0x04,	0x10 },
+	{ INTEL_IVYBRIDGE_X,	0x04,	0x42a },
 	/* Observed in the wild */
-	{ INTEL_FAM6_SANDYBRIDGE_X,	0x06,	0x61b },
-	{ INTEL_FAM6_SANDYBRIDGE_X,	0x07,	0x712 },
+	{ INTEL_SANDYBRIDGE_X,	0x06,	0x61b },
+	{ INTEL_SANDYBRIDGE_X,	0x07,	0x712 },
 };
 
 static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
@@ -173,11 +173,8 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_HYPERVISOR))
 		return false;
 
-	if (c->x86 != 6)
-		return false;
-
 	for (i = 0; i < ARRAY_SIZE(spectre_bad_microcodes); i++) {
-		if (c->x86_model == spectre_bad_microcodes[i].model &&
+		if (c->x86_vfm == spectre_bad_microcodes[i].vfm &&
 		    c->x86_stepping == spectre_bad_microcodes[i].stepping)
 			return (c->microcode <= spectre_bad_microcodes[i].microcode);
 	}
@@ -313,7 +310,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * need the microcode to have already been loaded... so if it is
 	 * not, recommend a BIOS update and disable large pages.
 	 */
-	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_stepping <= 2 &&
+	if (c->x86_vfm == INTEL_ATOM_BONNELL && c->x86_stepping <= 2 &&
 	    c->microcode < 0x20e) {
 		pr_warn("Atom PSE erratum detected, BIOS microcode update recommended\n");
 		clear_cpu_cap(c, X86_FEATURE_PSE);
@@ -346,11 +343,11 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 
 	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
 	if (c->x86 == 6) {
-		switch (c->x86_model) {
-		case INTEL_FAM6_ATOM_SALTWELL_MID:
-		case INTEL_FAM6_ATOM_SALTWELL_TABLET:
-		case INTEL_FAM6_ATOM_SILVERMONT_MID:
-		case INTEL_FAM6_ATOM_AIRMONT_NP:
+		switch (c->x86_vfm) {
+		case INTEL_ATOM_SALTWELL_MID:
+		case INTEL_ATOM_SALTWELL_TABLET:
+		case INTEL_ATOM_SILVERMONT_MID:
+		case INTEL_ATOM_AIRMONT_NP:
 			set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC_S3);
 			break;
 		default:
@@ -394,7 +391,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * should be false so that __flush_tlb_all() causes CR3 instead of CR4.PGE
 	 * to be modified.
 	 */
-	if (c->x86 == 5 && c->x86_model == 9) {
+	if (c->x86_vfm == INTEL_QUARK_X1000) {
 		pr_info("Disabling PGE capability bit\n");
 		setup_clear_cpu_cap(X86_FEATURE_PGE);
 	}
@@ -626,12 +623,13 @@ static void init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_PEBS);
 	}
 
-	if (c->x86 == 6 && boot_cpu_has(X86_FEATURE_CLFLUSH) &&
-	    (c->x86_model == 29 || c->x86_model == 46 || c->x86_model == 47))
+	if (boot_cpu_has(X86_FEATURE_CLFLUSH) &&
+	    (c->x86_vfm == INTEL_CORE2_DUNNINGTON ||
+	     c->x86_vfm == INTEL_NEHALEM_EX ||
+	     c->x86_vfm == INTEL_WESTMERE_EX))
 		set_cpu_bug(c, X86_BUG_CLFLUSH_MONITOR);
 
-	if (c->x86 == 6 && boot_cpu_has(X86_FEATURE_MWAIT) &&
-		((c->x86_model == INTEL_FAM6_ATOM_GOLDMONT)))
+	if (boot_cpu_has(X86_FEATURE_MWAIT) && c->x86_vfm == INTEL_ATOM_GOLDMONT)
 		set_cpu_bug(c, X86_BUG_MONITOR);
 
 #ifdef CONFIG_X86_64
@@ -1247,9 +1245,9 @@ void handle_bus_lock(struct pt_regs *regs)
  * feature even though they do not enumerate IA32_CORE_CAPABILITIES.
  */
 static const struct x86_cpu_id split_lock_cpu_ids[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,	0),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,	0),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,	0),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,	0),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,	0),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,	0),
 	{}
 };
 
-- 
2.44.0

