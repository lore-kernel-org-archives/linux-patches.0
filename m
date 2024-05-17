Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8588313DB96
	for <patches@lists.linux.dev>; Fri, 17 May 2024 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715966504; cv=none; b=Wy7rFWeYElhsAOO8meOQmjH4wzunzqZWl0pWrxaPUrMubOkaCZXBH9TyBVJWLqUgfdfyLFSVHGl/DTt6ABxfI7pUSVVhaK0hLdEZkRvXjn6NOFVxi6LrpLa4qI3v/hhYGS2eqwoVTLzZ3lCcixagHBCVEbXnascmL1hWsE7T1Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715966504; c=relaxed/simple;
	bh=TDt0aSlSeO1W8R0aLW312iI7Pq6wK9Emi1wPw+nuOzg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K2EvGg3KTn64Xo1ZcZVjBYs7+mJ3yYMVtDS6VW6mfX3eZb5jqB/d4OZVrfZ1l+reLtxyfVn3j9RY64/L+L44gjTy9Hi+uvJvkEloV7Npvh5UbF6qePJ0juMcj9yRoXa38dh9ePu0aaRUzcNXE//wQIGmw1J0poi/sHGHS3jmZa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EoyEzdFv; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EoyEzdFv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715966503; x=1747502503;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TDt0aSlSeO1W8R0aLW312iI7Pq6wK9Emi1wPw+nuOzg=;
  b=EoyEzdFvkiHvoI2t8mUSi0DCjL6o7K3C/FCYA6zpAuccdJKk/ObHid2y
   PzIO7r6Sn8dB7gTxxaiNeYo6uSgC0qdHSfL3uRHC09/1Jpsj1C0J9O4eM
   8+A0RiXMgAuNuK4OvBk0ydOQiyrV4TLs4dQRFlttMCL8Cx90LKv4FhyYJ
   CgIXZj9sUV5w/0GR0wUifOUIx05JXSKuP1jUFxXHB+tb25pj0qG49vDeR
   PDQJbVzFaOWeS0cBoVBdFgg0CxeenbosHKT3nrhmcTsQYKhT4sioj2xXQ
   Pv8I9j2okLsWmfBTAxMpoNxnmvT7yQiougvulcJ4KbAjGQGX2JFOHTN98
   w==;
X-CSE-ConnectionGUID: FBuU9IfBQ+ywk58FC6yqKw==
X-CSE-MsgGUID: hrwf/Fs4QWSrvTDSEUInSA==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="22833127"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="22833127"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 10:21:42 -0700
X-CSE-ConnectionGUID: URzGRJRHR+OhjJwyubxITA==
X-CSE-MsgGUID: 4Sw5FwBRRHOeDKhSWZxYZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="32416073"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 10:21:41 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL
Date: Fri, 17 May 2024 10:21:34 -0700
Message-ID: <20240517172134.7255-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Code in v6.9 arch/x86/kernel/smpboot.c was changed by commit 4db64279bc2b
("x86/cpu: Switch to new Intel CPU model defines") from old code:

 440 static const struct x86_cpu_id intel_cod_cpu[] = {
 441         X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X, 0),       /* COD */
 442         X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X, 0),     /* COD */
 443         X86_MATCH_INTEL_FAM6_MODEL(ANY, 1),             /* SNC */
 444         {}
 445 };
 446
 447 static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 448 {
 449         const struct x86_cpu_id *id = x86_match_cpu(intel_cod_cpu);

new code:

440 static const struct x86_cpu_id intel_cod_cpu[] = {
 441         X86_MATCH_VFM(INTEL_HASWELL_X,   0),    /* COD */
 442         X86_MATCH_VFM(INTEL_BROADWELL_X, 0),    /* COD */
 443         X86_MATCH_VFM(INTEL_ANY,         1),    /* SNC */
 444         {}
 445 };
 446
 447 static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 448 {
 449         const struct x86_cpu_id *id = x86_match_cpu(intel_cod_cpu);

On an Intel CPU with SNC enabled this code previously matched the rule
on line 443 to avoid printing messages about insane cache configuration.
The new code did not match any rules.

Expanding the macros for the intel_cod_cpu[] array shows that the old
is equivalent to:

static const struct x86_cpu_id intel_cod_cpu[] = {
[0] = { .vendor = 0, .family = 6, .model = 0x3F, .steppings = 0, .feature = 0, .driver_data = 0 },
[1] = { .vendor = 0, .family = 6, .model = 0x4F, .steppings = 0, .feature = 0, .driver_data = 0 },
[2] = { .vendor = 0, .family = 6, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 1 },
[3] = { .vendor = 0, .family = 0, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 0 }
}

while the new code expands to:

static const struct x86_cpu_id intel_cod_cpu[] = {
[0] = { .vendor = 0, .family = 6, .model = 0x3F, .steppings = 0, .feature = 0, .driver_data = 0 },
[1] = { .vendor = 0, .family = 6, .model = 0x4F, .steppings = 0, .feature = 0, .driver_data = 0 },
[2] = { .vendor = 0, .family = 0, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 1 },
[3] = { .vendor = 0, .family = 0, .model = 0x00, .steppings = 0, .feature = 0, .driver_data = 0 }
}

Looking at the code for x86_match_cpu():

36 const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 37 {
 38         const struct x86_cpu_id *m;
 39         struct cpuinfo_x86 *c = &boot_cpu_data;
 40
 41         for (m = match;
 42              m->vendor | m->family | m->model | m->steppings | m->feature;
 43              m++) {
			...
 56         }
 57         return NULL;
 58 }
 59 EXPORT_SYMBOL(x86_match_cpu);

it is clear that there was no match because the ANY entry in the table
(array index 2) is now the loop termination condition (all of vendor,
family, model, steppings, and feature are zero).

So this code was working before because the "ANY" check was looking for
any Intel CPU in family 6. But fails now because the family is a wild
card. So the root cause is that x86_match_cpu() has never been able to
match on a rule with just X86_VENDOR_INTEL and all other fields set to
wildcards.

Fix by adding a new flags field to struct x86_cpu_id that has a bit set
to indicate that the vendor field is valid. Update X86_MATCH*() macros
to set that bit. Extend the end-marker check in x86_match_cpu() to
check the flags field too.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Borislav Petkov <bp@alien8.de>
Fixes: 644e9cbbe3fc ("Add driver auto probing for x86 features v4")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Changes since v1:
1) More detailed commit description.
2) Changed "Fixes" tag. Commit 4db64279bc2b merely revealed a twelve
   year old gap in the implementation of x86_match_cpu().

 arch/x86/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index cb4f6c513c48..271c4c95bc37 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -175,10 +175,10 @@ struct cpuinfo_x86 {
 	unsigned		initialized : 1;
 } __randomize_layout;

-#define X86_VENDOR_INTEL	0
 #define X86_VENDOR_CYRIX	1
 #define X86_VENDOR_AMD		2
 #define X86_VENDOR_UMC		3
+#define X86_VENDOR_INTEL	4
 #define X86_VENDOR_CENTAUR	5
 #define X86_VENDOR_TRANSMETA	7
 #define X86_VENDOR_NSC		8
--
2.44.0
---
 include/linux/mod_devicetable.h      | 4 ++++
 arch/x86/include/asm/cpu_device_id.h | 2 ++
 arch/x86/kernel/cpu/match.c          | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 7a9a07ea451b..ede1bd8bc4b1 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -690,6 +690,7 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 steppings;
 	__u16 feature;	/* bit index */
+	__u16 flags;
 	kernel_ulong_t driver_data;
 };
 
@@ -700,6 +701,9 @@ struct x86_cpu_id {
 #define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
+/* x86_cpu_id::flags */
+#define X86_CPU_ID_FLAG_VENDOR_VALID	BIT(0)
+
 /*
  * Generic table type for matching CPU features.
  * @feature:	the bit number of the feature (0 - 65535)
diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 970a232009c3..7fde9bd896d3 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -79,6 +79,7 @@
 	.model		= _model,					\
 	.steppings	= _steppings,					\
 	.feature	= _feature,					\
+	.flags		= X86_CPU_ID_FLAG_VENDOR_VALID,			\
 	.driver_data	= (unsigned long) _data				\
 }
 
@@ -89,6 +90,7 @@
 	.model		= _model,					\
 	.steppings	= _steppings,					\
 	.feature	= _feature,					\
+	.flags		= X86_CPU_ID_FLAG_VENDOR_VALID,			\
 	.driver_data	= (unsigned long) _data				\
 }
 
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 8651643bddae..996f96cfce68 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -39,7 +39,7 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
 	for (m = match;
-	     m->vendor | m->family | m->model | m->steppings | m->feature;
+	     m->vendor | m->family | m->model | m->steppings | m->feature | m->flags;
 	     m++) {
 		if (m->vendor != X86_VENDOR_ANY && c->x86_vendor != m->vendor)
 			continue;
-- 
2.45.0

