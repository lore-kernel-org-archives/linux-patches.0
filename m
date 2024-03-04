Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D508F7868F;
	Mon,  4 Mar 2024 21:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588821; cv=none; b=JpcFxI4OezOJAycr/b4JeHIU9gJo1GWz1pM8oZxCWRm213zwgGqrXNaWmYd116Wi/1tNnGeT7AybKphbhELe7ofpABdrQnzRQptI1isj8iyR3AWqUqmvIdS1zFe4SPjt65fAeoJnP1qSnd8UpSHzbXvnfTa37mSWZHPShe0j/dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588821; c=relaxed/simple;
	bh=Ce/hSECyxaGV5opsgF26cKq5SdwG/3/F7hA1gbfEUy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGt4rjAaI0pwjAjVixEMYdq9eumgw4WyMF4s3CpzC1bZVaYrvfTqgzZ/wohl0KUQUcLQwL9neuHlGLyOBb2HmwlCoCmGyg/PMRZKdkH1HJiR5CWviuRQJCz5+JgbwibAW/sqdkJekIGhqGcW5ntv5+fbxz2JnwF+Lk3o2S4jnBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMmVvwvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMmVvwvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1747AC433C7;
	Mon,  4 Mar 2024 21:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588821;
	bh=Ce/hSECyxaGV5opsgF26cKq5SdwG/3/F7hA1gbfEUy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMmVvwvszQPgQu/kSJrA+FtY4yQLBMAOx/HSbwdko3ztXPcHAz4K5CzagBwwudNqe
	 2ZXnfHJxgzEFsskbCnAGJlXpL9iSiw/8PAKPUIfZT1n8mf1uuijrnZ27TvU0euxEVP
	 EHyCXYQvwH5jWVqkwynZXWBnbGZX3ReC7w69b1WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 110/215] x86/boot/compressed: Rename efi_thunk_64.S to efi-mixed.S
Date: Mon,  4 Mar 2024 21:22:53 +0000
Message-ID: <20240304211600.524533936@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit cb8bda8ad4438b4bcfcf89697fc84803fb210017 upstream.

In preparation for moving the mixed mode specific code out of head_64.S,
rename the existing file to clarify that it contains more than just the
mixed mode thunk.

While at it, clean up the Makefile rules that add it to the build.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-2-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/Makefile                        | 6 +++---
 arch/x86/boot/compressed/{efi_thunk_64.S => efi_mixed.S} | 0
 arch/x86/boot/compressed/Makefile       |    6 
 arch/x86/boot/compressed/efi_mixed.S    |  195 ++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/efi_thunk_64.S |  195 --------------------------------
 3 files changed, 198 insertions(+), 198 deletions(-)
 rename arch/x86/boot/compressed/{efi_thunk_64.S => efi_mixed.S} (100%)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -108,11 +108,11 @@ endif
 vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
 vmlinux-objs-$(CONFIG_INTEL_TDX_GUEST) += $(obj)/tdx.o $(obj)/tdcall.o
 
-vmlinux-objs-$(CONFIG_EFI_MIXED) += $(obj)/efi_thunk_$(BITS).o
 vmlinux-objs-$(CONFIG_EFI) += $(obj)/efi.o
-efi-obj-$(CONFIG_EFI_STUB) = $(objtree)/drivers/firmware/efi/libstub/lib.a
+vmlinux-objs-$(CONFIG_EFI_MIXED) += $(obj)/efi_mixed.o
+vmlinux-objs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
 
-$(obj)/vmlinux: $(vmlinux-objs-y) $(efi-obj-y) FORCE
+$(obj)/vmlinux: $(vmlinux-objs-y) FORCE
 	$(call if_changed,ld)
 
 OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
--- /dev/null
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -0,0 +1,195 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2014, 2015 Intel Corporation; author Matt Fleming
+ *
+ * Early support for invoking 32-bit EFI services from a 64-bit kernel.
+ *
+ * Because this thunking occurs before ExitBootServices() we have to
+ * restore the firmware's 32-bit GDT and IDT before we make EFI service
+ * calls.
+ *
+ * On the plus side, we don't have to worry about mangling 64-bit
+ * addresses into 32-bits because we're executing with an identity
+ * mapped pagetable and haven't transitioned to 64-bit virtual addresses
+ * yet.
+ */
+
+#include <linux/linkage.h>
+#include <asm/msr.h>
+#include <asm/page_types.h>
+#include <asm/processor-flags.h>
+#include <asm/segment.h>
+
+	.code64
+	.text
+SYM_FUNC_START(__efi64_thunk)
+	push	%rbp
+	push	%rbx
+
+	movl	%ds, %eax
+	push	%rax
+	movl	%es, %eax
+	push	%rax
+	movl	%ss, %eax
+	push	%rax
+
+	/* Copy args passed on stack */
+	movq	0x30(%rsp), %rbp
+	movq	0x38(%rsp), %rbx
+	movq	0x40(%rsp), %rax
+
+	/*
+	 * Convert x86-64 ABI params to i386 ABI
+	 */
+	subq	$64, %rsp
+	movl	%esi, 0x0(%rsp)
+	movl	%edx, 0x4(%rsp)
+	movl	%ecx, 0x8(%rsp)
+	movl	%r8d, 0xc(%rsp)
+	movl	%r9d, 0x10(%rsp)
+	movl	%ebp, 0x14(%rsp)
+	movl	%ebx, 0x18(%rsp)
+	movl	%eax, 0x1c(%rsp)
+
+	leaq	0x20(%rsp), %rbx
+	sgdt	(%rbx)
+
+	addq	$16, %rbx
+	sidt	(%rbx)
+
+	leaq	1f(%rip), %rbp
+
+	/*
+	 * Switch to IDT and GDT with 32-bit segments. This is the firmware GDT
+	 * and IDT that was installed when the kernel started executing. The
+	 * pointers were saved at the EFI stub entry point in head_64.S.
+	 *
+	 * Pass the saved DS selector to the 32-bit code, and use far return to
+	 * restore the saved CS selector.
+	 */
+	leaq	efi32_boot_idt(%rip), %rax
+	lidt	(%rax)
+	leaq	efi32_boot_gdt(%rip), %rax
+	lgdt	(%rax)
+
+	movzwl	efi32_boot_ds(%rip), %edx
+	movzwq	efi32_boot_cs(%rip), %rax
+	pushq	%rax
+	leaq	efi_enter32(%rip), %rax
+	pushq	%rax
+	lretq
+
+1:	addq	$64, %rsp
+	movq	%rdi, %rax
+
+	pop	%rbx
+	movl	%ebx, %ss
+	pop	%rbx
+	movl	%ebx, %es
+	pop	%rbx
+	movl	%ebx, %ds
+	/* Clear out 32-bit selector from FS and GS */
+	xorl	%ebx, %ebx
+	movl	%ebx, %fs
+	movl	%ebx, %gs
+
+	/*
+	 * Convert 32-bit status code into 64-bit.
+	 */
+	roll	$1, %eax
+	rorq	$1, %rax
+
+	pop	%rbx
+	pop	%rbp
+	RET
+SYM_FUNC_END(__efi64_thunk)
+
+	.code32
+/*
+ * EFI service pointer must be in %edi.
+ *
+ * The stack should represent the 32-bit calling convention.
+ */
+SYM_FUNC_START_LOCAL(efi_enter32)
+	/* Load firmware selector into data and stack segment registers */
+	movl	%edx, %ds
+	movl	%edx, %es
+	movl	%edx, %fs
+	movl	%edx, %gs
+	movl	%edx, %ss
+
+	/* Reload pgtables */
+	movl	%cr3, %eax
+	movl	%eax, %cr3
+
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
+	/* Disable long mode via EFER */
+	movl	$MSR_EFER, %ecx
+	rdmsr
+	btrl	$_EFER_LME, %eax
+	wrmsr
+
+	call	*%edi
+
+	/* We must preserve return value */
+	movl	%eax, %edi
+
+	/*
+	 * Some firmware will return with interrupts enabled. Be sure to
+	 * disable them before we switch GDTs and IDTs.
+	 */
+	cli
+
+	lidtl	(%ebx)
+	subl	$16, %ebx
+
+	lgdtl	(%ebx)
+
+	movl	%cr4, %eax
+	btsl	$(X86_CR4_PAE_BIT), %eax
+	movl	%eax, %cr4
+
+	movl	%cr3, %eax
+	movl	%eax, %cr3
+
+	movl	$MSR_EFER, %ecx
+	rdmsr
+	btsl	$_EFER_LME, %eax
+	wrmsr
+
+	xorl	%eax, %eax
+	lldt	%ax
+
+	pushl	$__KERNEL_CS
+	pushl	%ebp
+
+	/* Enable paging */
+	movl	%cr0, %eax
+	btsl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+	lret
+SYM_FUNC_END(efi_enter32)
+
+	.data
+	.balign	8
+SYM_DATA_START(efi32_boot_gdt)
+	.word	0
+	.quad	0
+SYM_DATA_END(efi32_boot_gdt)
+
+SYM_DATA_START(efi32_boot_idt)
+	.word	0
+	.quad	0
+SYM_DATA_END(efi32_boot_idt)
+
+SYM_DATA_START(efi32_boot_cs)
+	.word	0
+SYM_DATA_END(efi32_boot_cs)
+
+SYM_DATA_START(efi32_boot_ds)
+	.word	0
+SYM_DATA_END(efi32_boot_ds)
--- a/arch/x86/boot/compressed/efi_thunk_64.S
+++ /dev/null
@@ -1,195 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C) 2014, 2015 Intel Corporation; author Matt Fleming
- *
- * Early support for invoking 32-bit EFI services from a 64-bit kernel.
- *
- * Because this thunking occurs before ExitBootServices() we have to
- * restore the firmware's 32-bit GDT and IDT before we make EFI service
- * calls.
- *
- * On the plus side, we don't have to worry about mangling 64-bit
- * addresses into 32-bits because we're executing with an identity
- * mapped pagetable and haven't transitioned to 64-bit virtual addresses
- * yet.
- */
-
-#include <linux/linkage.h>
-#include <asm/msr.h>
-#include <asm/page_types.h>
-#include <asm/processor-flags.h>
-#include <asm/segment.h>
-
-	.code64
-	.text
-SYM_FUNC_START(__efi64_thunk)
-	push	%rbp
-	push	%rbx
-
-	movl	%ds, %eax
-	push	%rax
-	movl	%es, %eax
-	push	%rax
-	movl	%ss, %eax
-	push	%rax
-
-	/* Copy args passed on stack */
-	movq	0x30(%rsp), %rbp
-	movq	0x38(%rsp), %rbx
-	movq	0x40(%rsp), %rax
-
-	/*
-	 * Convert x86-64 ABI params to i386 ABI
-	 */
-	subq	$64, %rsp
-	movl	%esi, 0x0(%rsp)
-	movl	%edx, 0x4(%rsp)
-	movl	%ecx, 0x8(%rsp)
-	movl	%r8d, 0xc(%rsp)
-	movl	%r9d, 0x10(%rsp)
-	movl	%ebp, 0x14(%rsp)
-	movl	%ebx, 0x18(%rsp)
-	movl	%eax, 0x1c(%rsp)
-
-	leaq	0x20(%rsp), %rbx
-	sgdt	(%rbx)
-
-	addq	$16, %rbx
-	sidt	(%rbx)
-
-	leaq	1f(%rip), %rbp
-
-	/*
-	 * Switch to IDT and GDT with 32-bit segments. This is the firmware GDT
-	 * and IDT that was installed when the kernel started executing. The
-	 * pointers were saved at the EFI stub entry point in head_64.S.
-	 *
-	 * Pass the saved DS selector to the 32-bit code, and use far return to
-	 * restore the saved CS selector.
-	 */
-	leaq	efi32_boot_idt(%rip), %rax
-	lidt	(%rax)
-	leaq	efi32_boot_gdt(%rip), %rax
-	lgdt	(%rax)
-
-	movzwl	efi32_boot_ds(%rip), %edx
-	movzwq	efi32_boot_cs(%rip), %rax
-	pushq	%rax
-	leaq	efi_enter32(%rip), %rax
-	pushq	%rax
-	lretq
-
-1:	addq	$64, %rsp
-	movq	%rdi, %rax
-
-	pop	%rbx
-	movl	%ebx, %ss
-	pop	%rbx
-	movl	%ebx, %es
-	pop	%rbx
-	movl	%ebx, %ds
-	/* Clear out 32-bit selector from FS and GS */
-	xorl	%ebx, %ebx
-	movl	%ebx, %fs
-	movl	%ebx, %gs
-
-	/*
-	 * Convert 32-bit status code into 64-bit.
-	 */
-	roll	$1, %eax
-	rorq	$1, %rax
-
-	pop	%rbx
-	pop	%rbp
-	RET
-SYM_FUNC_END(__efi64_thunk)
-
-	.code32
-/*
- * EFI service pointer must be in %edi.
- *
- * The stack should represent the 32-bit calling convention.
- */
-SYM_FUNC_START_LOCAL(efi_enter32)
-	/* Load firmware selector into data and stack segment registers */
-	movl	%edx, %ds
-	movl	%edx, %es
-	movl	%edx, %fs
-	movl	%edx, %gs
-	movl	%edx, %ss
-
-	/* Reload pgtables */
-	movl	%cr3, %eax
-	movl	%eax, %cr3
-
-	/* Disable paging */
-	movl	%cr0, %eax
-	btrl	$X86_CR0_PG_BIT, %eax
-	movl	%eax, %cr0
-
-	/* Disable long mode via EFER */
-	movl	$MSR_EFER, %ecx
-	rdmsr
-	btrl	$_EFER_LME, %eax
-	wrmsr
-
-	call	*%edi
-
-	/* We must preserve return value */
-	movl	%eax, %edi
-
-	/*
-	 * Some firmware will return with interrupts enabled. Be sure to
-	 * disable them before we switch GDTs and IDTs.
-	 */
-	cli
-
-	lidtl	(%ebx)
-	subl	$16, %ebx
-
-	lgdtl	(%ebx)
-
-	movl	%cr4, %eax
-	btsl	$(X86_CR4_PAE_BIT), %eax
-	movl	%eax, %cr4
-
-	movl	%cr3, %eax
-	movl	%eax, %cr3
-
-	movl	$MSR_EFER, %ecx
-	rdmsr
-	btsl	$_EFER_LME, %eax
-	wrmsr
-
-	xorl	%eax, %eax
-	lldt	%ax
-
-	pushl	$__KERNEL_CS
-	pushl	%ebp
-
-	/* Enable paging */
-	movl	%cr0, %eax
-	btsl	$X86_CR0_PG_BIT, %eax
-	movl	%eax, %cr0
-	lret
-SYM_FUNC_END(efi_enter32)
-
-	.data
-	.balign	8
-SYM_DATA_START(efi32_boot_gdt)
-	.word	0
-	.quad	0
-SYM_DATA_END(efi32_boot_gdt)
-
-SYM_DATA_START(efi32_boot_idt)
-	.word	0
-	.quad	0
-SYM_DATA_END(efi32_boot_idt)
-
-SYM_DATA_START(efi32_boot_cs)
-	.word	0
-SYM_DATA_END(efi32_boot_cs)
-
-SYM_DATA_START(efi32_boot_ds)
-	.word	0
-SYM_DATA_END(efi32_boot_ds)


