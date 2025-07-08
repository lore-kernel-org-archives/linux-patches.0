Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C92A1C5F13
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997877; cv=none; b=RnlTOIdTi+FTGPdXn1OnOtISH+wte6fccQMsr4514OIMZRhAAdAx3lOqGHxeEPUmg6isGeSWEh15nAOSItXKyC8zcj71AsEKx6PXkF+/u+Y1SrK2FZxDATfo9o3u52swOJKKFZiRHLyvXr7mbtBe5ylxiZNNHCCKv/Z6R1gB31Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997877; c=relaxed/simple;
	bh=+djsBe9sZyH57K2ZP7zpuovc0rp9b37H1S78krrCkuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBNithwb557aU+aXEHGgYeSwN3KPxUfztaDM/Ll0SuDUGbq/0KDbyrS7wItt5h5YK6Nuddu1Xuf8pRRy6Ixhk3J8Y+3hb1nWh5RE3A1juOlau2+U5TNYkfFR8FfliB/tWOyVFYYToUTweU6cbHD1EtxGdm7kgx2+CoFLSOaP67Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LP4DlDPg; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LP4DlDPg"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D9CC240E0208;
	Tue,  8 Jul 2025 18:04:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jXbIYgmhZ6wC; Tue,  8 Jul 2025 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1751997867; bh=QRA8Ykwdl6P/4LLeLu87qkzsP7EmXrsEVU++kuDHtd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LP4DlDPgGP1cFXN0xWEPZQLgOUutrXOY4LV5IyUbSWYM1vIMtqXQHIR6ci3635L2C
	 wXkFmWAc5fLGoRNTqA61uZWFWG0cNZCtEG9frhgMNtBKZOwPyhE3eZb9wcx2u5k/DV
	 iISGsYSSEO7QmMl5GLczkNmoCEGOAQ8BYBp7QE8RATRARWOTgcpB4OYhkl/VmPKMpt
	 jcNief0V+AQLpRedgiUPnpNq4tIEp8Ekrf5M24kA2aLOpCDw3E8ZU9Nd11ugaqdoFR
	 OrXpKGf8Gs/+c3HeMAgZ0ZxqebFMdc5/3972+DZhdZYnI9gbHjcYWtPTZxszs4sU5v
	 lKATX0xDTUFQPsTn1y6Xd1qBN1oFg5Mtqpw20WmZncnGKKdrrn4nALClJnNIBfMuwM
	 wLln+7Ouf+ekVThwOx2XUnLScKe5IkX/WlO3xYiikXDxTEXSjLzWl7cLIDz/HqCgo3
	 1yRtwpi0hifoPyZ2gJBF/thhtlI05y3CIsBss8SjGfDxV0EXsjhZzBTboajmaB4Kcz
	 gkk3ty8Ts17n7gj9D7eLNf8/rH/zBE1i230DtVANyNx8LZV9UdjbL4NlRQ+e/qfxMa
	 29HAcZAGXKIjKKOgDQ4K7uhoYsEZuo8ENNLwqFPs5s5iU4mFXquCX+UKp5Qoj2Wknm
	 3n+jbCoNuNrOPUmHV/bcPe3c=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0445C40E0213;
	Tue,  8 Jul 2025 18:04:05 +0000 (UTC)
Date: Tue, 8 Jul 2025 20:04:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@amd.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/160] 5.15.187-rc1 review
Message-ID: <20250708180400.GIaG1dkGnKYAS1QOu0@fat_crate.local>
References: <20250708162231.503362020@linuxfoundation.org>
 <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>
 <20250708172319.GEaG1UB5x3BffeL9VW@fat_crate.local>
 <12b05333-69c2-42b7-89ea-d414ea14eca0@gmail.com>
 <20250708174509.GGaG1ZJSHsChiURgHW@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250708174509.GGaG1ZJSHsChiURgHW@fat_crate.local>

On Tue, Jul 08, 2025 at 07:45:09PM +0200, Borislav Petkov wrote:
> Right, it needs the __weak functions - this is solved differently on newer
> kernels. Lemme send updated patches.

...and 6.1:

Thanks Florian!

---
From 69fdd5ec45b0adfe91432c2288302b124ffc7d6a Mon Sep 17 00:00:00 2001
From: "Borislav Petkov (AMD)" <bp@alien8.de>
Date: Wed, 11 Sep 2024 10:53:08 +0200
Subject: [PATCH] x86/bugs: Add a Transient Scheduler Attacks mitigation

Commit d8010d4ba43e9f790925375a7de100604a5e2dba upstream.

Add the required features detection glue to bugs.c et all in order to
support the TSA mitigation.

Co-developed-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../ABI/testing/sysfs-devices-system-cpu      |   1 +
 .../admin-guide/kernel-parameters.txt         |  13 ++
 arch/x86/Kconfig                              |   9 ++
 arch/x86/include/asm/cpu.h                    |  12 ++
 arch/x86/include/asm/cpufeatures.h            |   6 +
 arch/x86/include/asm/mwait.h                  |   2 +-
 arch/x86/include/asm/nospec-branch.h          |  12 +-
 arch/x86/kernel/cpu/amd.c                     |  58 +++++++++
 arch/x86/kernel/cpu/bugs.c                    | 121 ++++++++++++++++++
 arch/x86/kernel/cpu/common.c                  |  14 +-
 arch/x86/kernel/cpu/scattered.c               |   2 +
 arch/x86/kvm/svm/vmenter.S                    |   6 +
 drivers/base/cpu.c                            |   7 +
 include/linux/cpu.h                           |   1 +
 14 files changed, 259 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 1468609052c7..97e695efa959 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -526,6 +526,7 @@ What:		/sys/devices/system/cpu/vulnerabilities
 		/sys/devices/system/cpu/vulnerabilities/spectre_v1
 		/sys/devices/system/cpu/vulnerabilities/spectre_v2
 		/sys/devices/system/cpu/vulnerabilities/srbds
+		/sys/devices/system/cpu/vulnerabilities/tsa
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6938c8cd7a6f..eaeabff9beff 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6400,6 +6400,19 @@
 			If not specified, "default" is used. In this case,
 			the RNG's choice is left to each individual trust source.
 
+	tsa=		[X86] Control mitigation for Transient Scheduler
+			Attacks on AMD CPUs. Search the following in your
+			favourite search engine for more details:
+
+			"Technical guidance for mitigating transient scheduler
+			attacks".
+
+			off		- disable the mitigation
+			on		- enable the mitigation (default)
+			user		- mitigate only user/kernel transitions
+			vm		- mitigate only guest/host transitions
+
+
 	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8e66bb443351..1da950b1d41a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2586,6 +2586,15 @@ config MITIGATION_ITS
 	  disabled, mitigation cannot be enabled via cmdline.
 	  See <file:Documentation/admin-guide/hw-vuln/indirect-target-selection.rst>
 
+config MITIGATION_TSA
+	bool "Mitigate Transient Scheduler Attacks"
+	depends on CPU_SUP_AMD
+	default y
+	help
+	  Enable mitigation for Transient Scheduler Attacks. TSA is a hardware
+	  security vulnerability on AMD CPUs which can lead to forwarding of
+	  invalid info to subsequent instructions and thus can affect their
+	  timing and thereby cause a leakage.
 endif
 
 config ARCH_HAS_ADD_PAGES
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 37639a2d9c34..c976bbf909e0 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -98,4 +98,16 @@ extern u64 x86_read_arch_cap_msr(void);
 
 extern struct cpumask cpus_stop_mask;
 
+union zen_patch_rev {
+	struct {
+		__u32 rev	 : 8,
+		      stepping	 : 4,
+		      model	 : 4,
+		      __reserved : 4,
+		      ext_model	 : 4,
+		      ext_fam	 : 8;
+	};
+	__u32 ucode_rev;
+};
+
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 28edef597282..1c71f947b426 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -430,6 +430,7 @@
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* "" Automatic IBRS */
+#define X86_FEATURE_VERW_CLEAR		(20*32+ 10) /* "" The memory form of VERW mitigates TSA */
 #define X86_FEATURE_SBPB		(20*32+27) /* "" Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* "" MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* "" CPU is not affected by SRSO */
@@ -447,6 +448,10 @@
 #define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* "" Clear branch history at vmexit using SW loop */
 #define X86_FEATURE_INDIRECT_THUNK_ITS	(21*32 + 5) /* "" Use thunk for indirect branches in lower half of cacheline */
 
+#define X86_FEATURE_TSA_SQ_NO          (21*32+11) /* "" AMD CPU not vulnerable to TSA-SQ */
+#define X86_FEATURE_TSA_L1_NO          (21*32+12) /* "" AMD CPU not vulnerable to TSA-L1 */
+#define X86_FEATURE_CLEAR_CPU_BUF_VM   (21*32+13) /* "" Clear CPU buffers using VERW before VMRUN */
+
 /*
  * BUG word(s)
  */
@@ -498,4 +503,5 @@
 #define X86_BUG_IBPB_NO_RET		X86_BUG(1*32 + 4) /* "ibpb_no_ret" IBPB omits return target predictions */
 #define X86_BUG_ITS			X86_BUG(1*32 + 5) /* CPU is affected by Indirect Target Selection */
 #define X86_BUG_ITS_NATIVE_ONLY		X86_BUG(1*32 + 6) /* CPU is affected by ITS, VMX is not affected */
+#define X86_BUG_TSA			X86_BUG(1*32+ 9) /* "tsa" CPU is affected by Transient Scheduler Attacks */
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 209dce2c79b7..2c6020729dd1 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -80,7 +80,7 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
 static inline void __mwaitx(unsigned long eax, unsigned long ebx,
 			    unsigned long ecx)
 {
-	/* No MDS buffer clear as this is AMD/HYGON only */
+	/* No need for TSA buffer clearing on AMD */
 
 	/* "mwaitx %eax, %ebx, %ecx;" */
 	asm volatile(".byte 0x0f, 0x01, 0xfb;"
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 3713b6dab7f4..c77a65a3e5f1 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -208,8 +208,8 @@
  * CFLAGS.ZF.
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
-.macro CLEAR_CPU_BUFFERS
-	ALTERNATIVE "jmp .Lskip_verw_\@", "", X86_FEATURE_CLEAR_CPU_BUF
+.macro __CLEAR_CPU_BUFFERS feature
+	ALTERNATIVE "jmp .Lskip_verw_\@", "", \feature
 #ifdef CONFIG_X86_64
 	verw x86_verw_sel(%rip)
 #else
@@ -223,6 +223,12 @@
 .Lskip_verw_\@:
 .endm
 
+#define CLEAR_CPU_BUFFERS \
+	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
+
+#define VM_CLEAR_CPU_BUFFERS \
+	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF_VM
+
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY
 	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP
@@ -462,7 +468,7 @@ static __always_inline void x86_clear_cpu_buffers(void)
 
 /**
  * x86_idle_clear_cpu_buffers - Buffer clearing support in idle for the MDS
- * vulnerability
+ * and TSA vulnerabilities.
  *
  * Clear CPU buffers if the corresponding static key is enabled
  */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9ac93b4ba67b..3e3679709e90 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -553,6 +553,61 @@ static void early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
+static bool amd_check_tsa_microcode(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	union zen_patch_rev p;
+	u32 min_rev = 0;
+
+	p.ext_fam	= c->x86 - 0xf;
+	p.model		= c->x86_model;
+	p.stepping	= c->x86_stepping;
+
+	if (c->x86 == 0x19) {
+		switch (p.ucode_rev >> 8) {
+		case 0xa0011:	min_rev = 0x0a0011d7; break;
+		case 0xa0012:	min_rev = 0x0a00123b; break;
+		case 0xa0082:	min_rev = 0x0a00820d; break;
+		case 0xa1011:	min_rev = 0x0a10114c; break;
+		case 0xa1012:	min_rev = 0x0a10124c; break;
+		case 0xa1081:	min_rev = 0x0a108109; break;
+		case 0xa2010:	min_rev = 0x0a20102e; break;
+		case 0xa2012:	min_rev = 0x0a201211; break;
+		case 0xa4041:	min_rev = 0x0a404108; break;
+		case 0xa5000:	min_rev = 0x0a500012; break;
+		case 0xa6012:	min_rev = 0x0a60120a; break;
+		case 0xa7041:	min_rev = 0x0a704108; break;
+		case 0xa7052:	min_rev = 0x0a705208; break;
+		case 0xa7080:	min_rev = 0x0a708008; break;
+		case 0xa70c0:	min_rev = 0x0a70c008; break;
+		case 0xaa002:	min_rev = 0x0aa00216; break;
+		default:
+			pr_debug("%s: ucode_rev: 0x%x, current revision: 0x%x\n",
+				 __func__, p.ucode_rev, c->microcode);
+			return false;
+		}
+	}
+
+	if (!min_rev)
+		return false;
+
+	return c->microcode >= min_rev;
+}
+
+static void tsa_init(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_HYPERVISOR))
+		return;
+
+	if (c->x86 == 0x19) {
+		if (amd_check_tsa_microcode())
+			setup_force_cpu_cap(X86_FEATURE_VERW_CLEAR);
+	} else {
+		setup_force_cpu_cap(X86_FEATURE_TSA_SQ_NO);
+		setup_force_cpu_cap(X86_FEATURE_TSA_L1_NO);
+	}
+}
+
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
@@ -663,6 +718,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		if (!(msr & MSR_K7_HWCR_SMMLOCK))
 			goto clear_sev;
 
+
+	tsa_init(c);
+
 		return;
 
 clear_all:
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d0a5df576e90..dba5262e1509 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -49,6 +49,7 @@ static void __init l1d_flush_select_mitigation(void);
 static void __init gds_select_mitigation(void);
 static void __init srso_select_mitigation(void);
 static void __init its_select_mitigation(void);
+static void __init tsa_select_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
@@ -184,6 +185,7 @@ void __init cpu_select_mitigations(void)
 	srso_select_mitigation();
 	gds_select_mitigation();
 	its_select_mitigation();
+	tsa_select_mitigation();
 }
 
 /*
@@ -2039,6 +2041,94 @@ static void update_mds_branch_idle(void)
 #define TAA_MSG_SMT "TAA CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html for more details.\n"
 #define MMIO_MSG_SMT "MMIO Stale Data CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mmio_stale_data.html for more details.\n"
 
+#undef pr_fmt
+#define pr_fmt(fmt)	"Transient Scheduler Attacks: " fmt
+
+enum tsa_mitigations {
+	TSA_MITIGATION_NONE,
+	TSA_MITIGATION_UCODE_NEEDED,
+	TSA_MITIGATION_USER_KERNEL,
+	TSA_MITIGATION_VM,
+	TSA_MITIGATION_FULL,
+};
+
+static const char * const tsa_strings[] = {
+	[TSA_MITIGATION_NONE]		= "Vulnerable",
+	[TSA_MITIGATION_UCODE_NEEDED]	= "Vulnerable: Clear CPU buffers attempted, no microcode",
+	[TSA_MITIGATION_USER_KERNEL]	= "Mitigation: Clear CPU buffers: user/kernel boundary",
+	[TSA_MITIGATION_VM]		= "Mitigation: Clear CPU buffers: VM",
+	[TSA_MITIGATION_FULL]		= "Mitigation: Clear CPU buffers",
+};
+
+static enum tsa_mitigations tsa_mitigation __ro_after_init =
+	IS_ENABLED(CONFIG_MITIGATION_TSA) ? TSA_MITIGATION_FULL : TSA_MITIGATION_NONE;
+
+static int __init tsa_parse_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off"))
+		tsa_mitigation = TSA_MITIGATION_NONE;
+	else if (!strcmp(str, "on"))
+		tsa_mitigation = TSA_MITIGATION_FULL;
+	else if (!strcmp(str, "user"))
+		tsa_mitigation = TSA_MITIGATION_USER_KERNEL;
+	else if (!strcmp(str, "vm"))
+		tsa_mitigation = TSA_MITIGATION_VM;
+	else
+		pr_err("Ignoring unknown tsa=%s option.\n", str);
+
+	return 0;
+}
+early_param("tsa", tsa_parse_cmdline);
+
+static void __init tsa_select_mitigation(void)
+{
+	if (tsa_mitigation == TSA_MITIGATION_NONE)
+		return;
+
+	if (cpu_mitigations_off() || !boot_cpu_has_bug(X86_BUG_TSA)) {
+		tsa_mitigation = TSA_MITIGATION_NONE;
+		return;
+	}
+
+	if (!boot_cpu_has(X86_FEATURE_VERW_CLEAR))
+		tsa_mitigation = TSA_MITIGATION_UCODE_NEEDED;
+
+	switch (tsa_mitigation) {
+	case TSA_MITIGATION_USER_KERNEL:
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		break;
+
+	case TSA_MITIGATION_VM:
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
+		break;
+
+	case TSA_MITIGATION_UCODE_NEEDED:
+		if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
+			goto out;
+
+		pr_notice("Forcing mitigation on in a VM\n");
+
+		/*
+		 * On the off-chance that microcode has been updated
+		 * on the host, enable the mitigation in the guest just
+		 * in case.
+		 */
+		fallthrough;
+	case TSA_MITIGATION_FULL:
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
+		break;
+	default:
+		break;
+	}
+
+out:
+	pr_info("%s\n", tsa_strings[tsa_mitigation]);
+}
+
 void cpu_bugs_smt_update(void)
 {
 	mutex_lock(&spec_ctrl_mutex);
@@ -2092,6 +2182,24 @@ void cpu_bugs_smt_update(void)
 		break;
 	}
 
+	switch (tsa_mitigation) {
+	case TSA_MITIGATION_USER_KERNEL:
+	case TSA_MITIGATION_VM:
+	case TSA_MITIGATION_FULL:
+	case TSA_MITIGATION_UCODE_NEEDED:
+		/*
+		 * TSA-SQ can potentially lead to info leakage between
+		 * SMT threads.
+		 */
+		if (sched_smt_active())
+			static_branch_enable(&cpu_buf_idle_clear);
+		else
+			static_branch_disable(&cpu_buf_idle_clear);
+		break;
+	case TSA_MITIGATION_NONE:
+		break;
+	}
+
 	mutex_unlock(&spec_ctrl_mutex);
 }
 
@@ -3026,6 +3134,11 @@ static ssize_t srso_show_state(char *buf)
 			  boot_cpu_has(X86_FEATURE_IBPB_BRTYPE) ? "" : ", no microcode");
 }
 
+static ssize_t tsa_show_state(char *buf)
+{
+	return sysfs_emit(buf, "%s\n", tsa_strings[tsa_mitigation]);
+}
+
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
 			       char *buf, unsigned int bug)
 {
@@ -3087,6 +3200,9 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 	case X86_BUG_ITS:
 		return its_show_state(buf);
 
+	case X86_BUG_TSA:
+		return tsa_show_state(buf);
+
 	default:
 		break;
 	}
@@ -3171,4 +3287,9 @@ ssize_t cpu_show_indirect_target_selection(struct device *dev, struct device_att
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_ITS);
 }
+
+ssize_t cpu_show_tsa(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_TSA);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 722eac51beae..9c849a4160cd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1256,6 +1256,8 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 #define ITS		BIT(8)
 /* CPU is affected by Indirect Target Selection, but guest-host isolation is not affected */
 #define ITS_NATIVE_ONLY	BIT(9)
+/* CPU is affected by Transient Scheduler Attacks */
+#define TSA		BIT(10)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
@@ -1303,7 +1305,7 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_AMD(0x16, RETBLEED),
 	VULNBL_AMD(0x17, RETBLEED | SMT_RSB | SRSO),
 	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB | SRSO),
-	VULNBL_AMD(0x19, SRSO),
+	VULNBL_AMD(0x19, SRSO | TSA),
 	{}
 };
 
@@ -1508,6 +1510,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_ITS_NATIVE_ONLY);
 	}
 
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		if (!cpu_has(c, X86_FEATURE_TSA_SQ_NO) ||
+		    !cpu_has(c, X86_FEATURE_TSA_L1_NO)) {
+			if (cpu_matches(cpu_vuln_blacklist, TSA) ||
+			    /* Enable bug on Zen guests to allow for live migration. */
+			    (cpu_has(c, X86_FEATURE_HYPERVISOR) && cpu_has(c, X86_FEATURE_ZEN)))
+				setup_force_cpu_bug(X86_BUG_TSA);
+		}
+	}
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 28c357cf7c75..b9e39c9eb274 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -45,6 +45,8 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_TSA_SQ_NO,	CPUID_ECX,  1, 0x80000021, 0 },
+	{ X86_FEATURE_TSA_L1_NO,	CPUID_ECX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 5be9a63f09ff..42824f9b06a2 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -166,6 +166,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
+	/* Clobbers EFLAGS.ZF */
+	VM_CLEAR_CPU_BUFFERS
+
 	/* Enter guest mode */
 	sti
 
@@ -336,6 +339,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
 	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
 
+	/* Clobbers EFLAGS.ZF */
+	VM_CLEAR_CPU_BUFFERS
+
 	/* Enter guest mode */
 	sti
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 27aff2503765..d68c60f35764 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -601,6 +601,11 @@ ssize_t __weak cpu_show_indirect_target_selection(struct device *dev,
 	return sysfs_emit(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_tsa(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -616,6 +621,7 @@ static DEVICE_ATTR(gather_data_sampling, 0444, cpu_show_gds, NULL);
 static DEVICE_ATTR(spec_rstack_overflow, 0444, cpu_show_spec_rstack_overflow, NULL);
 static DEVICE_ATTR(reg_file_data_sampling, 0444, cpu_show_reg_file_data_sampling, NULL);
 static DEVICE_ATTR(indirect_target_selection, 0444, cpu_show_indirect_target_selection, NULL);
+static DEVICE_ATTR(tsa, 0444, cpu_show_tsa, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -633,6 +639,7 @@ static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_spec_rstack_overflow.attr,
 	&dev_attr_reg_file_data_sampling.attr,
 	&dev_attr_indirect_target_selection.attr,
+	&dev_attr_tsa.attr,
 	NULL
 };
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 186e0e0f2e40..3d3ceccf8224 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -78,6 +78,7 @@ extern ssize_t cpu_show_reg_file_data_sampling(struct device *dev,
 					       struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_indirect_target_selection(struct device *dev,
 						  struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_tsa(struct device *dev, struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,
-- 
2.43.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
