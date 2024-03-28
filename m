Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD7B130AD4
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643311; cv=none; b=eIEqGlbmOame1c7AmmKnfpfyU+IvnJsWDa5Z3K2F9h9xL8Cf2rbvZ6kNNw1olRVUk/Jhlrc6DRgAPNLM3gU4LYKPJGErKR9LPLrKt0iUInGo70A+ntOjPn/HnYhI4DiqnqP7mgqYOr+bZ+CCkt43LALF4T3F0AZHNsDnDGw/2pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643311; c=relaxed/simple;
	bh=trJqd6HAIWm0ZLzTkKn5fSR0Q66QoBmJlQmHYiIxlZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twVWKLMBKNuzzXGNEuyODRJtur+bI8HNEnUEoYx4PplkfKZotKXgQ3dCds2dvPBqmIhdiAt7EphdIBeEJsLloHkxwfD/acmUP8gBwqIAFn0q6mGFAG2J63Nf7AI83m5ADkiVIuV1cLMMdKiaouM/MgZaOSRYkOoq9CzBt7C9QFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZKVaJYcT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZKVaJYcT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643308; x=1743179308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=trJqd6HAIWm0ZLzTkKn5fSR0Q66QoBmJlQmHYiIxlZc=;
  b=ZKVaJYcTVxL+O6o5GMGyBjwCRfDhUe5ihjfwkLOdfyaENb8nT+OmB5QA
   gSBCOFSfN/YTREK2dwik2gKSpwkPGJX4JMcXBu22CyW8fZlt9/vlwz8/U
   yjCjLqsmy7wCIEwk33njXsEzuI+T7PCcgFJQVNhIC9g7VSDni0xJvGaMT
   8JH92oPqSQEDbXGjnhJWH8uMx8Nxiw6HWNrk+y55qAj9IjRaqJrCUihNc
   0JubGHQU3HrxMuakck8sUAGrd9aqpwJajTQ4oNudH4n6WJvDzYBcE8oH9
   g93FIgsD97l/LH2+/E7NUHPjTkYlox0XpUUzI1QASANvbCm30n9z1uuQG
   w==;
X-CSE-ConnectionGUID: Mb+6GS1EQZOgFX7id77PkA==
X-CSE-MsgGUID: ORlRxPVaRzCy7LXqf4pg+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294746"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294746"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726022"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 23/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/mce/severity.c
Date: Thu, 28 Mar 2024 09:27:17 -0700
Message-ID: <20240328162820.242778-23-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/mce/severity.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index c4477162c07d..65e570bd3fc4 100644
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
@@ -386,7 +387,7 @@ static noinstr int mce_severity_intel(struct mce *m, struct pt_regs *regs, char
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

