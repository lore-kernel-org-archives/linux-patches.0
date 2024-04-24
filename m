Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2095181335
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982523; cv=none; b=DBfaDZwPgPn6mzvwQ/5Yp/gkA4K0KI/6CtOCPDXTu6zVa4qSs8EncvL6l1Duk0le3cRVXY9IjZIg37wyzaAmpMwjQZXZtUjiH9X+hKY2tHdP65iMeH9KPLdn3nCkqy19aZgWiROP4xdQ0N2r0mwP6Au7I2IMB+YcLq8nRVcEF74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982523; c=relaxed/simple;
	bh=iFfVDMwRelTPhBugxwSRQJDD52d9QsnZEZNpB2fnYgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEJ2v+wVeUn6C5GTJ43ergsX1kMmQimZjspOwFq+yXKgn5MhUWR9BQINocMWUjxTH1bMuxmShKBRGeG69waXtckM9B3nYObIgiaihlW6JUJcN1GXbQ04YOJcC+nVbVjV2L0tAakHJ0l93x4+5SgUywAeDNHAZGz2+tpH4m/bjw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h2BYoSbV; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h2BYoSbV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982521; x=1745518521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iFfVDMwRelTPhBugxwSRQJDD52d9QsnZEZNpB2fnYgc=;
  b=h2BYoSbVmhvJVGA6pcn3+23C95rOQSZ2twMz/3P5m5euqkloTN3FIwGa
   JAtb3D6870Gb4ItsrG9Rccm6ivk0/rETyuIDi3sk1FDySrw4WUBm4bvFC
   k2CGzULWCR/SoJbMMRle+JiIm8K9acn7L7yr7cTymDILa9SQO3YwaPeq8
   b17RjGkH/kP8BMZ9i+FYkSNV8DVh7pni9TsTBSxw3q+BYtl9haT2mRPd9
   Mx8rq3ktjujm4DkZzSFoaveFYBvfTGPC31gKqCXqSAVFNbFQaeRlWI1M2
   I+wbwOsjJiD2h3OK5mk0cd4b2VfH3WQV1AJIG97aqjo4AywiOuo7IuxL9
   g==;
X-CSE-ConnectionGUID: ugTlb03AQ+y/tHVvuzqjEg==
X-CSE-MsgGUID: uGwFM4i4TciYTsXojC7KBQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9482014"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9482014"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:13 -0700
X-CSE-ConnectionGUID: 3Me6owXQQ8yo33zZQJIkew==
X-CSE-MsgGUID: hGlTsOXjSqaC+Kej4mCGHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262754"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:13 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 34/71] x86/mce: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:13 -0700
Message-ID: <20240424181513.41810-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/mce/severity.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index fc8988cfe1c3..7293a1c49050 100644
--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -12,7 +12,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/mce.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/traps.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
@@ -45,14 +45,14 @@ static struct severity {
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
@@ -128,7 +128,7 @@ static struct severity {
 	MCESEV(
 		AO, "Uncorrected Patrol Scrub Error",
 		SER, MASK(MCI_STATUS_UC|MCI_ADDR|0xffffeff0, MCI_ADDR|0x001000c0),
-		MODEL_STEPPING(INTEL_FAM6_SKYLAKE_X, 4), BANK_RANGE(13, 18)
+		VFM_STEPPING(INTEL_SKYLAKE_X, 4), BANK_RANGE(13, 18)
 	),
 
 	/* ignore OVER for UCNA */
@@ -398,7 +398,7 @@ static noinstr int mce_severity_intel(struct mce *m, struct pt_regs *regs, char
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

