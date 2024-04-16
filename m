Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A075313B292
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302408; cv=none; b=TbH2HDRKAm0xs7pRmEs1VPJtflo794/R5ZNoynJQod5xwMWS/IlLUZykA6v4eokP3NsPuX+sXDHK6h2Gi50rODzhRhil8n0573fUOdHZQKLXdJqKoQ5yDo3N2WXZRQdtyeBdvFc50BYu1MhGAkb3bPfYbURhEDI4aRllNWKNDwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302408; c=relaxed/simple;
	bh=7/AgHnkjNiRf+M9PKWf9yuiVGp5ERwRmMKgqjNTxAHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgrJ4t3UG9aFSYATU79ZzPezuJsqtzNzLIJppUSxg2JuqAXOEJ1LuEaMJSu7xufDPQ2jp7chlJ727MQ0CFgNVodX0rQX5XX4TsqmxefNofFwXiCsjuiGdoE4j08ZqNPxL3QS4Mhl52GZ8R7eZfNpcPUULxuwJZ+/aQhGLZaXjNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lhaWHCFg; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lhaWHCFg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302407; x=1744838407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7/AgHnkjNiRf+M9PKWf9yuiVGp5ERwRmMKgqjNTxAHw=;
  b=lhaWHCFgIT3fBhs894Et1HCU4VQQMgTAlYv6cj48G7P4fKFx8r9tJA86
   SZ3pwHGKflqU5E0ZtuVw1Jqb+n+VX5397NmRjQYpjVQMXq0KJBQGxcuVI
   jpkX5fQv7+nFzQoA0x2m90UJ0hDUJJ9kiiGsQyOBnKIKNDKJUa+XRc+eI
   P9+4jm0DFVc6tngIgdcbcw6RsT+jNrXUs22ELuogyp6DLUOx2P8crtgtz
   KAtQNv1qutr7fsYEL1kGyREl+wuRmPdgelBGrVdR2ATy6lXmakCeVNpay
   PRqB3yZW8dHc18E0vryGDx1dg0rPhYa8u97p2E4Ru0NCwzj24Jea4ftSp
   A==;
X-CSE-ConnectionGUID: OLtAqhtoSvuGQMCODHzZsA==
X-CSE-MsgGUID: 3X25EhyFQBuShhDP6VrBVg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914748"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914748"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:59 -0700
X-CSE-ConnectionGUID: zO0wPfYYSzOsFksW33l3ng==
X-CSE-MsgGUID: lLJSF8nnT8q60m+rhPlAiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871938"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 18/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/intel.c
Date: Tue, 16 Apr 2024 14:19:20 -0700
Message-ID: <20240416211941.9369-19-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/intel.c | 115 +++++++++++++++++++-----------------
 1 file changed, 60 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3c3e7e5695ba..b85afd5d6128 100644
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
@@ -134,34 +134,41 @@ static void probe_xeon_phi_r3mwait(struct cpuinfo_x86 *c)
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
 
+static bool vfm_match(struct cpuinfo_x86 *c, u32 vfm)
+{
+	return c->x86_vendor == VFM_VENDOR(vfm) &&
+	       c->x86 == VFM_FAMILY(vfm) &&
+	       c->x86_model == VFM_MODEL(vfm);
+}
+
 static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 {
 	int i;
@@ -173,11 +180,8 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_HYPERVISOR))
 		return false;
 
-	if (c->x86 != 6)
-		return false;
-
 	for (i = 0; i < ARRAY_SIZE(spectre_bad_microcodes); i++) {
-		if (c->x86_model == spectre_bad_microcodes[i].model &&
+		if (vfm_match(c, spectre_bad_microcodes[i].vfm) &&
 		    c->x86_stepping == spectre_bad_microcodes[i].stepping)
 			return (c->microcode <= spectre_bad_microcodes[i].microcode);
 	}
@@ -313,7 +317,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * need the microcode to have already been loaded... so if it is
 	 * not, recommend a BIOS update and disable large pages.
 	 */
-	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_stepping <= 2 &&
+	if (c->x86_vfm == INTEL_ATOM_BONNELL && c->x86_stepping <= 2 &&
 	    c->microcode < 0x20e) {
 		pr_warn("Atom PSE erratum detected, BIOS microcode update recommended\n");
 		clear_cpu_cap(c, X86_FEATURE_PSE);
@@ -346,11 +350,11 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 
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
@@ -394,7 +398,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * should be false so that __flush_tlb_all() causes CR3 instead of CR4.PGE
 	 * to be modified.
 	 */
-	if (c->x86 == 5 && c->x86_model == 9) {
+	if (c->x86_vfm == INTEL_QUARK_X1000) {
 		pr_info("Disabling PGE capability bit\n");
 		setup_clear_cpu_cap(X86_FEATURE_PGE);
 	}
@@ -626,12 +630,13 @@ static void init_intel(struct cpuinfo_x86 *c)
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
@@ -1247,9 +1252,9 @@ void handle_bus_lock(struct pt_regs *regs)
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

