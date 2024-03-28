Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF547131195
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643311; cv=none; b=qjWIgZIbw2KGDe7zKkkctZkmMLftzHCl4jN5yRpPerxyTIVkMspPp7VTm3MeG52W3l1/Us670FUlD1uZgJvOWVo3AbSyfA9xr0WcXJTPJUiJq5TcMCZyPo1xUMEoSK/LkSX7tKrb34TOwmMLhUAWxa7lMF9T7Rdy0WWUPV7w7HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643311; c=relaxed/simple;
	bh=4Evugcn3kVWKJZ07W69Ngsq6GMblRUkSDp2ZEKxPWWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVPEXRhPOm8khx/vERuzUiKQ7HbaHG4Z4ax0RiZCPX0f2bj+/El2jsMAIkYuVELFg4sZHUkFlXdpvbCCFIsDSjK1qix3/JBUvjjiN65Dx+AWLa6qD/v7gqju5WrQXpO/whfYJwgAYVjKBGRf9ZPsTURgbjQt+J7WmK3Bt7CdJIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JvTSGBGW; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JvTSGBGW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643308; x=1743179308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Evugcn3kVWKJZ07W69Ngsq6GMblRUkSDp2ZEKxPWWk=;
  b=JvTSGBGWEwoSZCtGECl9JelRHd0mvsfZ7de5t92ZIgF+DMLkpI/LzUq8
   tyRqYef8GEfcHMWBb6wSw8kHXxHt7CMKErVwsvrrizBptKIRw1X8Ndb+O
   6d/o9yZ0uo6To8nCIl3P2v9FwKO93QogL2i/IWHs8mrC1QYDTtjb0P0Jb
   oclIXQfsAIf/0RW5JwAHByUo5CrUseYh2EXs5kRPDI2Fbdr1k9cnalFj9
   BKeXZIv6RgqZfOugAxggTkap8SxKXw7RPYdVIWz6xJ0qqrOWFYx2V9VKJ
   b6xxYY+pqPyLMy0RBUJT+AiEfhj91amU1IBLvVetAxfQO0lu0JPyt8YYW
   g==;
X-CSE-ConnectionGUID: Q09oizGzRnqEJivmbUHcdg==
X-CSE-MsgGUID: Mydzw2PNStmEQyCyv5/5Gg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294745"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294745"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726019"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 22/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/mce/intel.c
Date: Thu, 28 Mar 2024 09:27:16 -0700
Message-ID: <20240328162820.242778-22-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/mce/intel.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 399b62e223d2..a73e3ff847aa 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -13,6 +13,7 @@
 #include <linux/cpumask.h>
 #include <asm/apic.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -455,10 +456,10 @@ static void intel_imc_init(struct cpuinfo_x86 *c)
 {
 	u64 error_control;
 
-	switch (c->x86_model) {
-	case INTEL_FAM6_SANDYBRIDGE_X:
-	case INTEL_FAM6_IVYBRIDGE_X:
-	case INTEL_FAM6_HASWELL_X:
+	switch (c->x86_vfm) {
+	case INTEL_SANDYBRIDGE_X:
+	case INTEL_IVYBRIDGE_X:
+	case INTEL_HASWELL_X:
 		if (rdmsrl_safe(MSR_ERROR_CONTROL, &error_control))
 			return;
 		error_control |= 2;
@@ -484,12 +485,11 @@ bool intel_filter_mce(struct mce *m)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
 	/* MCE errata HSD131, HSM142, HSW131, BDM48, HSM142 and SKX37 */
-	if ((c->x86 == 6) &&
-	    ((c->x86_model == INTEL_FAM6_HASWELL) ||
-	     (c->x86_model == INTEL_FAM6_HASWELL_L) ||
-	     (c->x86_model == INTEL_FAM6_BROADWELL) ||
-	     (c->x86_model == INTEL_FAM6_HASWELL_G) ||
-	     (c->x86_model == INTEL_FAM6_SKYLAKE_X)) &&
+	if ((c->x86_vfm == INTEL_HASWELL ||
+	     c->x86_vfm == INTEL_HASWELL_L ||
+	     c->x86_vfm == INTEL_BROADWELL ||
+	     c->x86_vfm == INTEL_HASWELL_G ||
+	     c->x86_vfm == INTEL_SKYLAKE_X) &&
 	    (m->bank == 0) &&
 	    ((m->status & 0xa0000000ffffffff) == 0x80000000000f0005))
 		return true;
-- 
2.44.0

