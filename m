Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB169C129;
	Mon,  1 Apr 2024 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988907; cv=none; b=N08dXplUnXjFlcYprYHBqJpw5B152CkxpONAHbLP4oPzKgvgPS6EhHwgVJ9742LpvhvDf3dzivxz6nl4sfQdIPGbF/h6AbvmU0igVAslIIkFArX8EqYUIyL1s+UjqHg2yXqzWt36oxhL5sjE7TBnO63jVvd4Ndyj/9X2Xdr+FOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988907; c=relaxed/simple;
	bh=KsX1tucVfWyb3nz78pELikdnc9TDaxRHgiWehZfZ3a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiigxwqtEaloMRy2+P6230bXaEzyxQAzNYP/W3SSXH7T6a1iwvWdjqeaA4MKXjGAdheKE0RrHyCSYNztg3OkBvsKFzGnJjoxL+IktEUZWkc32J/fVWgkNVWvxCGkJohmYTC5bS3njS4raeIYCpAeIsLIEC2HZ9OK9FMl1k6CIgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=su4psnO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="su4psnO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1B5C433F1;
	Mon,  1 Apr 2024 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988907;
	bh=KsX1tucVfWyb3nz78pELikdnc9TDaxRHgiWehZfZ3a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=su4psnO4mvzD9bTkqs+r32OeTU1MPvR4IY6ePUjoQv3AHEtArnjt/KpnXv/fWAuGn
	 kOStFWP7eYmMf/WBCXyVAOqPPGpfhnzB6mCAou6vsyKPQp4at8BWQsFQ0lMh3bPYe+
	 TWZw+jCdz0vmM884hhGR9wSipeo6cKw1mTz0+jvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.7 296/432] x86/Kconfig: Remove CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
Date: Mon,  1 Apr 2024 17:44:43 +0200
Message-ID: <20240401152602.004186043@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 29956748339aa8757a7e2f927a8679dd08f24bb6 upstream.

It was meant well at the time but nothing's using it so get rid of it.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240202163510.GDZb0Zvj8qOndvFOiZ@fat_crate.local
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt  |    4 +---
 Documentation/arch/x86/amd-memory-encryption.rst |   16 ++++++++--------
 arch/x86/Kconfig                                 |   13 -------------
 arch/x86/mm/mem_encrypt_identity.c               |   11 +----------
 4 files changed, 10 insertions(+), 34 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3327,9 +3327,7 @@
 
 	mem_encrypt=	[X86-64] AMD Secure Memory Encryption (SME) control
 			Valid arguments: on, off
-			Default (depends on kernel configuration option):
-			  on  (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y)
-			  off (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=n)
+			Default: off
 			mem_encrypt=on:		Activate SME
 			mem_encrypt=off:	Do not activate SME
 
--- a/Documentation/arch/x86/amd-memory-encryption.rst
+++ b/Documentation/arch/x86/amd-memory-encryption.rst
@@ -87,14 +87,14 @@ The state of SME in the Linux kernel can
 	  kernel is non-zero).
 
 SME can also be enabled and activated in the BIOS. If SME is enabled and
-activated in the BIOS, then all memory accesses will be encrypted and it will
-not be necessary to activate the Linux memory encryption support.  If the BIOS
-merely enables SME (sets bit 23 of the MSR_AMD64_SYSCFG), then Linux can activate
-memory encryption by default (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y) or
-by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
-not enable SME, then Linux will not be able to activate memory encryption, even
-if configured to do so by default or the mem_encrypt=on command line parameter
-is specified.
+activated in the BIOS, then all memory accesses will be encrypted and it
+will not be necessary to activate the Linux memory encryption support.
+
+If the BIOS merely enables SME (sets bit 23 of the MSR_AMD64_SYSCFG),
+then memory encryption can be enabled by supplying mem_encrypt=on on the
+kernel command line.  However, if BIOS does not enable SME, then Linux
+will not be able to activate memory encryption, even if configured to do
+so by default or the mem_encrypt=on command line parameter is specified.
 
 Secure Nested Paging (SNP)
 ==========================
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1539,19 +1539,6 @@ config AMD_MEM_ENCRYPT
 	  This requires an AMD processor that supports Secure Memory
 	  Encryption (SME).
 
-config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
-	bool "Activate AMD Secure Memory Encryption (SME) by default"
-	depends on AMD_MEM_ENCRYPT
-	help
-	  Say yes to have system memory encrypted by default if running on
-	  an AMD processor that supports Secure Memory Encryption (SME).
-
-	  If set to Y, then the encryption of system memory can be
-	  deactivated with the mem_encrypt=off command line option.
-
-	  If set to N, then the encryption of system memory can be
-	  activated with the mem_encrypt=on command line option.
-
 # Common NUMA Features
 config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -97,7 +97,6 @@ static char sme_workarea[2 * PMD_SIZE] _
 
 static char sme_cmdline_arg[] __initdata = "mem_encrypt";
 static char sme_cmdline_on[]  __initdata = "on";
-static char sme_cmdline_off[] __initdata = "off";
 
 static void __init sme_clear_pgd(struct sme_populate_pgd_data *ppd)
 {
@@ -504,7 +503,7 @@ void __init sme_encrypt_kernel(struct bo
 
 void __init sme_enable(struct boot_params *bp)
 {
-	const char *cmdline_ptr, *cmdline_arg, *cmdline_on, *cmdline_off;
+	const char *cmdline_ptr, *cmdline_arg, *cmdline_on;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned long feature_mask;
 	unsigned long me_mask;
@@ -587,12 +586,6 @@ void __init sme_enable(struct boot_param
 	asm ("lea sme_cmdline_on(%%rip), %0"
 	     : "=r" (cmdline_on)
 	     : "p" (sme_cmdline_on));
-	asm ("lea sme_cmdline_off(%%rip), %0"
-	     : "=r" (cmdline_off)
-	     : "p" (sme_cmdline_off));
-
-	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT))
-		sme_me_mask = me_mask;
 
 	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
 				     ((u64)bp->ext_cmd_line_ptr << 32));
@@ -602,8 +595,6 @@ void __init sme_enable(struct boot_param
 
 	if (!strncmp(buffer, cmdline_on, sizeof(buffer)))
 		sme_me_mask = me_mask;
-	else if (!strncmp(buffer, cmdline_off, sizeof(buffer)))
-		sme_me_mask = 0;
 
 out:
 	if (sme_me_mask) {


