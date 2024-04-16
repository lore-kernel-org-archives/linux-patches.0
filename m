Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E1713C673
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302411; cv=none; b=oITDihrfII50BDexh0NEPWmAafiB6d6MY1QhfLyptdGmLaPyBDI/ZQfg9kFAQ45rynElSgUWAv08Hsc1Va73Kr0BM/T+AHjmBkEfQd7aT/9CbI32MUvEDMkC0cjawSOZ2cfpv9wotdvSiHvWhGWgETX/J6H5FJTEva0B7daGe8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302411; c=relaxed/simple;
	bh=kl4BWoKNzmqLiy/g3wM2ev5Gf0696Je9BfnGHGdGncs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko4rqn92el0anGDXPvDv+1yK6y/jgL2FIraOKJyFQrEbS3InS3G109euKiyKyIHTo+39kWWGOy5LbAEQOZLQQqs0YuhxjWL2EU7G3tQCras/cpgnDBTTb2CTud2FqyRg7e854FGNbHnrXnr6xbTjj5h25ZEuG5ApAmtmJIHLzs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DWlLq358; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DWlLq358"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302409; x=1744838409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kl4BWoKNzmqLiy/g3wM2ev5Gf0696Je9BfnGHGdGncs=;
  b=DWlLq358/e7G3dLtA1Jg/yrcRMJzxw3Thg+3ZEpWOdgAYlB5zi8JNfnl
   CNOPOdONpcZ2IJB7GDVddEfrbmXNtVQVrSPB98pSOxtdCfOFqdQrbg2QR
   h/T4ZAQ6Sl7bB8rUYLM4l36QKsrc22ORwg7IatvvG4K/I9QHq95skpCEe
   2QD4CNVwMjDXmAhSGesK1fPJh2TEBKdpwRyjuziON4D2lKc8qD16VO389
   Svn5aKFnrli4W3//hzL+EdceA3v7Ga3aj9zlPGFyToUIuAROHJdB469XP
   kmJqCOZcqf7vFVTJoHhcg4epe7NbN5yIBdKu5B7BLXWbenXEhceF9PKLX
   w==;
X-CSE-ConnectionGUID: 42qefXYBRtagbQ8QN8Hfgw==
X-CSE-MsgGUID: Bs5ThoXaRY+g/UPcVSgXWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914778"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914778"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
X-CSE-ConnectionGUID: JK4NaIOMRji5M2t9henXWA==
X-CSE-MsgGUID: Tf1QsGLYRDGiRwhCHU05uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871956"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 23/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/mce/severity.c
Date: Tue, 16 Apr 2024 14:19:25 -0700
Message-ID: <20240416211941.9369-24-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/mce/severity.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index ee85fe2ccf65..85f5de718725 100644
--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -12,6 +12,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/mce.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/traps.h>
 #include <asm/insn.h>
@@ -45,14 +46,14 @@ static struct severity {
 	unsigned char context;
 	unsigned char excp;
 	unsigned char covered;
-	unsigned char cpu_model;
+	unsigned int cpu_vfm;
 	unsigned char cpu_minstepping;
 	unsigned char bank_lo, bank_hi;
 	char *msg;
 } severities[] = {
 #define MCESEV(s, m, c...) { .sev = MCE_ ## s ## _SEVERITY, .msg = m, ## c }
 #define BANK_RANGE(l, h) .bank_lo = l, .bank_hi = h
-#define MODEL_STEPPING(m, s) .cpu_model = m, .cpu_minstepping = s
+#define VFM_STEPPING(m, s) .cpu_vfm = m, .cpu_minstepping = s
 #define  KERNEL		.context = IN_KERNEL
 #define  USER		.context = IN_USER
 #define  KERNEL_RECOV	.context = IN_KERNEL_RECOV
@@ -128,7 +129,7 @@ static struct severity {
 	MCESEV(
 		AO, "Uncorrected Patrol Scrub Error",
 		SER, MASK(MCI_STATUS_UC|MCI_ADDR|0xffffeff0, MCI_ADDR|0x001000c0),
-		MODEL_STEPPING(INTEL_FAM6_SKYLAKE_X, 4), BANK_RANGE(13, 18)
+		VFM_STEPPING(INTEL_SKYLAKE_X, 4), BANK_RANGE(13, 18)
 	),
 
 	/* ignore OVER for UCNA */
@@ -397,7 +398,7 @@ static noinstr int mce_severity_intel(struct mce *m, struct pt_regs *regs, char
 			continue;
 		if (s->excp && excp != s->excp)
 			continue;
-		if (s->cpu_model && boot_cpu_data.x86_model != s->cpu_model)
+		if (s->cpu_vfm && boot_cpu_data.x86_model != s->cpu_vfm)
 			continue;
 		if (s->cpu_minstepping && boot_cpu_data.x86_stepping < s->cpu_minstepping)
 			continue;
-- 
2.44.0

