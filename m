Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E0528C5B1
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198273; cv=none; b=cKXbWavts+1dge+UTcL+yJkR8lM+o9h/7wj8kTjiyW7oHHdgyvWorRBP0o++vZb0WUIjw2y9/mBcZSySnj07QtmK+fX0dMHGh+DuawvhwMEzE96opGwfzBihbedNia4HIKUmtLlkVIGn8TJbuvuYrhmPeWjvhwLseb2rIZWXSXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198273; c=relaxed/simple;
	bh=m4mCceyYGSEylh507AjhMHMA9CPOWNWzet0C2V3dNlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8hkVw9hHqBOnBNa9kxSNtiTNbbvJPnEwU33qoDd21+W6QzVJ45wgQkn+l6FLeXcTEbUcZGlQ7gUgPR7ur3bWfJwZb1nvLbwKNzloN0PiqcaeHkRhx7T9C4UplCILtwOQKWV3uhIddGTp5Zuhkt3YvFXBx18eYdOwRxh4WDoikI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iDeT0F59; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iDeT0F59"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198272; x=1819734272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m4mCceyYGSEylh507AjhMHMA9CPOWNWzet0C2V3dNlE=;
  b=iDeT0F59lBGBtgWpEczIw35PWv3pjyiDzitZ6xHDXoGnMou7yc216HR4
   UFFmcarENnniUCHoLx7p8dgDcRPVyL42etp6sqSsjJDn2RZflIAX6kmsr
   mGHRvhI4N9KebDqtsP9yhFRico2KE6puw+8dTJ1BFYyR7hFkoYjnZaiig
   veSk/t/ue23/in9vvB995sk3muYPO4PXE4He1eQlgWwGDej/HOE74obfq
   OxySwan8CUJBT54sYzkMQ+ZopuqA5RZMaGC57e2RYTZwcKcO3+PN5x/eH
   EAOhIC2rOkqefNh5KuMk7kPwr05DeSJ5CGi+SI9xk/Xw0OhoXDx3clUUy
   g==;
X-CSE-ConnectionGUID: 5ZYKjUZnRXGLNK4lxmwIZA==
X-CSE-MsgGUID: O1KWLFVFQdqESCaWszfP9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92479897"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92479897"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:31 -0700
X-CSE-ConnectionGUID: oyh3d6yoRQar0JlkqKYxeg==
X-CSE-MsgGUID: 6pizaa+7SniFHBRsJIjcng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268906938"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:30 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 01/23] x86/resctrl: Give better names to X86_FEATURE flags for monitoring
Date: Mon, 31 Aug 2026 10:43:59 -0700
Message-ID: <20260831174421.13921-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The feature flags for enumeration of Resource Director Technology (RDT)
capabilities were chosen when the only feature was LLC cache occupancy
monitoring and they were given names using the abbreviation CQM for
Cache Quality of Service Monitoring.

Additional monitoring features have been added to CPUs and the names
are now more likely to confuse than inform the purpose of these flags.

Rename X86_FEATURE_CQM to X86_FEATURE_RDT_M (to match the Intel Software
Developer's Manual, and for symmetry with X86_FEATURE_RDT_A).

Rename X86_FEATURE_CQM_LLC to X86_FEATURE_L3_MON since it enumerates
that some L3 monitoring features may be present.

Add missing dependency to cpuid_deps[].

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	New patch. Fix FEATURE options

 Documentation/arch/x86/cpuinfo.rst       | 2 +-
 arch/x86/include/asm/cpufeatures.h       | 4 ++--
 tools/arch/x86/include/asm/cpufeatures.h | 4 ++--
 arch/x86/kernel/cpu/cpuid-deps.c         | 8 +++++---
 arch/x86/kernel/cpu/resctrl/core.c       | 2 +-
 arch/x86/kernel/cpu/scattered.c          | 2 +-
 6 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/arch/x86/cpuinfo.rst b/Documentation/arch/x86/cpuinfo.rst
index 17fce95367e6..5aa4e9d2ad23 100644
--- a/Documentation/arch/x86/cpuinfo.rst
+++ b/Documentation/arch/x86/cpuinfo.rst
@@ -96,7 +96,7 @@ Flags can be from scattered CPUID-based features
 Hardware features enumerated in sparsely populated CPUID leaves get
 software-defined values. Still, CPUID needs to be queried to determine
 if a given feature is present. This is done in init_scattered_cpuid_features().
-For instance, X86_FEATURE_CQM_LLC is defined as 11*32 + 0 and its presence is
+For instance, X86_FEATURE_L3_MON is defined as 11*32 + 0 and its presence is
 checked at runtime in the respective CPUID leaf [EAX=f, ECX=0] bit EDX[1].
 
 The intent of scattering CPUID leaves is to not bloat struct
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f70ee74b5f92..6a7f0adb123e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -252,7 +252,7 @@
 #define X86_FEATURE_ERMS		( 9*32+ 9) /* "erms" Enhanced REP MOVSB/STOSB instructions */
 #define X86_FEATURE_INVPCID		( 9*32+10) /* "invpcid" Invalidate Processor Context ID */
 #define X86_FEATURE_RTM			( 9*32+11) /* "rtm" Restricted Transactional Memory */
-#define X86_FEATURE_CQM			( 9*32+12) /* "cqm" Cache QoS Monitoring */
+#define X86_FEATURE_RDT_M		( 9*32+12) /* "cqm" Resource Director Technology Monitoring */
 #define X86_FEATURE_ZERO_FCS_FDS	( 9*32+13) /* Zero out FPU CS and FPU DS */
 #define X86_FEATURE_MPX			( 9*32+14) /* "mpx" Memory Protection Extension */
 #define X86_FEATURE_RDT_A		( 9*32+15) /* "rdt_a" Resource Director Technology Allocation */
@@ -285,7 +285,7 @@
  *
  * Reuse free bits when adding new feature flags!
  */
-#define X86_FEATURE_CQM_LLC		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
+#define X86_FEATURE_L3_MON		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
 #define X86_FEATURE_CQM_OCCUP_LLC	(11*32+ 1) /* "cqm_occup_llc" LLC occupancy monitoring */
 #define X86_FEATURE_CQM_MBM_TOTAL	(11*32+ 2) /* "cqm_mbm_total" LLC Total MBM monitoring */
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* "cqm_mbm_local" LLC Local MBM monitoring */
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 6547c0aee45b..9b71a7663e26 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -242,7 +242,7 @@
 #define X86_FEATURE_ERMS		( 9*32+ 9) /* "erms" Enhanced REP MOVSB/STOSB instructions */
 #define X86_FEATURE_INVPCID		( 9*32+10) /* "invpcid" Invalidate Processor Context ID */
 #define X86_FEATURE_RTM			( 9*32+11) /* "rtm" Restricted Transactional Memory */
-#define X86_FEATURE_CQM			( 9*32+12) /* "cqm" Cache QoS Monitoring */
+#define X86_FEATURE_RDT_M		( 9*32+12) /* "cqm" Resource Director Technology Monitoring */
 #define X86_FEATURE_ZERO_FCS_FDS	( 9*32+13) /* Zero out FPU CS and FPU DS */
 #define X86_FEATURE_MPX			( 9*32+14) /* "mpx" Memory Protection Extension */
 #define X86_FEATURE_RDT_A		( 9*32+15) /* "rdt_a" Resource Director Technology Allocation */
@@ -275,7 +275,7 @@
  *
  * Reuse free bits when adding new feature flags!
  */
-#define X86_FEATURE_CQM_LLC		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
+#define X86_FEATURE_L3_MON		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
 #define X86_FEATURE_CQM_OCCUP_LLC	(11*32+ 1) /* "cqm_occup_llc" LLC occupancy monitoring */
 #define X86_FEATURE_CQM_MBM_TOTAL	(11*32+ 2) /* "cqm_mbm_total" LLC Total MBM monitoring */
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* "cqm_mbm_local" LLC Local MBM monitoring */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 99801e844b30..58482c264b76 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -67,9 +67,11 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512_4FMAPS,		X86_FEATURE_AVX512F   },
 	{ X86_FEATURE_AVX512_VPOPCNTDQ,		X86_FEATURE_AVX512F   },
 	{ X86_FEATURE_AVX512_VP2INTERSECT,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_CQM_OCCUP_LLC,		X86_FEATURE_CQM_LLC   },
-	{ X86_FEATURE_CQM_MBM_TOTAL,		X86_FEATURE_CQM_LLC   },
-	{ X86_FEATURE_CQM_MBM_LOCAL,		X86_FEATURE_CQM_LLC   },
+	{ X86_FEATURE_L3_MON,			X86_FEATURE_RDT_M     },
+	{ X86_FEATURE_CQM_OCCUP_LLC,		X86_FEATURE_L3_MON    },
+	{ X86_FEATURE_CQM_MBM_TOTAL,		X86_FEATURE_L3_MON    },
+	{ X86_FEATURE_CQM_MBM_LOCAL,		X86_FEATURE_L3_MON    },
+	{ X86_FEATURE_ABMC,			X86_FEATURE_L3_MON    },
 	{ X86_FEATURE_BMEC,			X86_FEATURE_CQM_MBM_TOTAL   },
 	{ X86_FEATURE_BMEC,			X86_FEATURE_CQM_MBM_LOCAL   },
 	{ X86_FEATURE_SDCIAE,			X86_FEATURE_CAT_L3    },
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 55214d6fdc49..2435eddd24eb 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1078,7 +1078,7 @@ static enum cpuhp_state rdt_online;
 /* Runs once on the BSP during boot. */
 void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 {
-	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
+	if (!cpu_has(c, X86_FEATURE_L3_MON) && !cpu_has(c, X86_FEATURE_ABMC)) {
 		c->x86_cache_max_rmid  = -1;
 		c->x86_cache_occ_scale = -1;
 		c->x86_cache_mbm_width_offset = -1;
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 8665a6474806..7e5490e1e537 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -32,7 +32,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APX,			CPUID_EDX, 21, 0x00000007, 1 },
 	{ X86_FEATURE_RRSBA_CTRL,		CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_BHI_CTRL,			CPUID_EDX,  4, 0x00000007, 2 },
-	{ X86_FEATURE_CQM_LLC,			CPUID_EDX,  1, 0x0000000f, 0 },
+	{ X86_FEATURE_L3_MON,			CPUID_EDX,  1, 0x0000000f, 0 },
 	{ X86_FEATURE_CQM_OCCUP_LLC,		CPUID_EDX,  0, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_TOTAL,		CPUID_EDX,  1, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_LOCAL,		CPUID_EDX,  2, 0x0000000f, 1 },
-- 
2.55.0

