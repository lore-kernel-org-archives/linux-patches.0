Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740994;
	b=zFWt3OKiKqvEml5I3PxMb2k6HeRwM0VccRhRDH4WfIZw7HYYFnXqA90Dq9tCixMFpuFw
	 SlmII7hf9eF9pIaebyI/7JNFkzdkv71SP3SWzpdMnfBbXq30sNXWdJ1yEsXZKBSm7Lbpm
	 lhTBvEpezlfGpvxtMyqdhGxO5lIHBga+GZwiIBrZyQE1sgS1H0dszkL7+ZGzJO6x42/xT
	 ix3Lotfe9OkCOmqPPX6f0UGOlLTk01wVEPbaehj7Eh9EhtpDWl2AOCmgfh/pXT7uLX4P0
	 uoW3LYoB99QGS6onquoL5NFxBSN/F8uqfNW5B4cyi8Swl8YABfAjHHq4elpGTqmEBNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740994;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SXz4nMvHzvD1MXHTtKALh1igeYk07op+8rhFgEC2hqI=;
	b=lNOKFipQ2QMRBzxM3FXaHhof1RLc8OZaeijo1jmvoXDmb0wx+DhkacmfzPjADWxXReKI
	 N0wjOk4HQvc5jVXt+4DLCsuKWFmRiAugJHgdgNjRdje9SRMrg1OUeDBbQeAKR55V3EX3J
	 4mlteYMaCmcNxAyVC6Z+h6QfXbdK+ty6aTyhTj/77soo4scOnEtLgP0C/NbpnWiVKITvf
	 LrQyJa1mp+aFullhC3EWruTMsF+sHZ9FcJ1YRUJJSwIeKBxyXMjO6y31QcJACCSLBHXaf
	 bJMUYXjSAwGEFQEGHRUnenXklncMFUDeMOdQcctBaHeKaOuG5oq+MBCG9DBekvKQXyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=b4nNpco6;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C69F606D801
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C69F606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=b4nNpco6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793740994; x=1825276994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6AMsRp8i7eTEp4YhS7JYbu4RWn3JI7F18EUFw4DxaXs=;
  b=b4nNpco6O9hUCNfctTcbV/g5E7gklT7niLFXOKUm+AxlrasPzV00rEML
   PWDOhnsC1/ZBusSpYmXBuh4eyU/v2I2y+f/ub/Kvepb6LTAiDl4sWymhh
   lrcZ72jC9cShgNqVNgzHVTjZEysONyloqeyfd0bTR9PZBXqULKxF7izsQ
   TqhNHWPNtWJM6OJB42BuzJQS5kxoJKmrsmPIbB2uYh5SAbgIVRZEBMyKy
   mZ1YHzy5+iEwP8BIlk40mX0my1F+eAZ11yKIRXU+99HHNnUgsVd/AFJDA
   ybTz/KoDJv3CJLm9OXfagwYI6QyIWA1iKLFzB3PJbKRlYHw6ikp0oibhY
   A==;
X-CSE-ConnectionGUID: nnaUtv6LTX2ONmrLmnrr5A==
X-CSE-MsgGUID: xhJ+EeB8QZWNEQMTnMUv9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393488"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393488"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:11 -0800
X-CSE-ConnectionGUID: 0lT8Q2HAR1eoLwxQ0jBmMA==
X-CSE-MsgGUID: +l9ZFnohSG2c3fnPa2Tviw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624566"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:08 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH v2 03/11] x86/cpuid: Define Intel RDT enumeration leaves
Date: Tue,  3 Nov 2026 13:22:46 -0800
Message-ID: <20261103212254.18314-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103212254.18314-1-tony.luck@intel.com>
References: <20261103212254.18314-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel RDT monitoring and allocation use separate symmetric and asymmetric
CPUID leaves. The symmetric leaf numbers are also hard-coded in resctrl.

Define constants for all four leaves and use the symmetric monitoring and
allocation constants instead of numeric leaf values.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/cpuid/types.h | 4 ++++
 arch/x86/kernel/cpu/resctrl/core.c | 8 ++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpuid/types.h b/arch/x86/include/asm/cpuid/types.h
index 3d0e611c97ba..9594965a54e7 100644
--- a/arch/x86/include/asm/cpuid/types.h
+++ b/arch/x86/include/asm/cpuid/types.h
@@ -28,9 +28,13 @@ enum cpuid_regs_idx {
 #define CPUID_LEAF_MWAIT	0x05
 #define CPUID_LEAF_DCA		0x09
 #define CPUID_LEAF_XSTATE	0x0d
+#define CPUID_LEAF_RDT_M	0x0f
+#define CPUID_LEAF_RDT_A	0x10
 #define CPUID_LEAF_TSC		0x15
 #define CPUID_LEAF_FREQ		0x16
 #define CPUID_LEAF_TILE		0x1d
+#define CPUID_LEAF_RDT_M_ASYM	0x27
+#define CPUID_LEAF_RDT_A_ASYM	0x28
 
 #define CPUID_RANGE(idx)	((idx) & 0xffff0000)
 #define CPUID_RANGE_MAX(idx)	(CPUID_RANGE(idx) + 0xffff)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 709075ffc706..c66ff4cdd84b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -235,7 +235,7 @@ static __init bool __get_mem_config_intel(struct rdt_resource *r)
 	union cpuid_0x10_x_edx edx;
 	u32 ebx, ecx, max_delay;
 
-	cpuid_count(0x00000010, 3, &eax.full, &ebx, &ecx, &edx.full);
+	cpuid_count(CPUID_LEAF_RDT_A, 3, &eax.full, &ebx, &ecx, &edx.full);
 	hw_res->num_closid = edx.split.cos_max + 1;
 	max_delay = eax.split.max_delay + 1;
 
@@ -357,7 +357,7 @@ static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
 	union cpuid_0x10_x_edx edx;
 	u32 ebx, default_ctrl;
 
-	cpuid_count(0x00000010, idx, &eax.full, &ebx, &ecx.full, &edx.full);
+	cpuid_count(CPUID_LEAF_RDT_A, idx, &eax.full, &ebx, &ecx.full, &edx.full);
 	hw_res->num_closid = edx.split.cos_max + 1;
 	hw_ctrl = kzalloc_obj(*hw_ctrl);
 	if (!hw_ctrl)
@@ -1196,7 +1196,7 @@ void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 	}
 
 	/* will be overridden if occupancy monitoring exists */
-	c->x86_cache_max_rmid = cpuid_ebx(0xf);
+	c->x86_cache_max_rmid = cpuid_ebx(CPUID_LEAF_RDT_M);
 
 	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
 	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
@@ -1205,7 +1205,7 @@ void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 		u32 eax, ebx, ecx, edx;
 
 		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
-		cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
+		cpuid_count(CPUID_LEAF_RDT_M, 1, &eax, &ebx, &ecx, &edx);
 
 		c->x86_cache_max_rmid  = ecx;
 		c->x86_cache_occ_scale = ebx;
-- 
2.56.0

