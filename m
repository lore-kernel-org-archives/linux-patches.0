Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1976927D784;
	Tue, 27 May 2025 16:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364602; cv=none; b=Ux6qT8SzQk3RXRLZ6Kxawmt9d7feZTCL7zgztoETm5NU/XbJJPJin6Qjh1xc8SNDHP7Ns0geFHOgHPFG4t26/X5Stz7ItGQwxiOaol0ZVzzCA9m7pVWeBMB2c6N3W/qlV3gkcRIJHObP2+O72lQRW6S+Xq7qLXIMeBf2cQOtb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364602; c=relaxed/simple;
	bh=vgEmh/qc0pqxLrmZxaZiTuMJJnPQNn+nzrYCya/RAFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArpnP7KWEIdgByJwewIwTtSwGw+kFdYN92VaOeH7pOVlnhcEymAdAUsET0KNkxAv+ucZyPc8Wb7EZMW1yQCtcAHAagKNEUEesETkibv1BRn43sZk2L5Eii230t2VS6kIFYrNf+Xn87y5NZP/nC1F4CrSVGS7yolr1fKoi0Ly4pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBR+HncT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBR+HncT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AC7C4CEE9;
	Tue, 27 May 2025 16:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364601;
	bh=vgEmh/qc0pqxLrmZxaZiTuMJJnPQNn+nzrYCya/RAFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBR+HncTLlfdz9+e+6/eU8dvCWDSeyXIfX6s2/4m+IAfNGg2qxZX7S9RayIbn+3gA
	 zRFjKLDnkS17mfOShjF3NQ9fvI07HkYMLGvgkrjXRF4q4O9O2bZzn6SYQ96mJpR1+W
	 t9iwFeRJdQbk6PSL290ocOAgHfThhvn/QrdmcgmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Brian Gerst <brgerst@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/626] x86/headers: Replace __ASSEMBLY__ with __ASSEMBLER__ in UAPI headers
Date: Tue, 27 May 2025 18:20:00 +0200
Message-ID: <20250527162449.390083369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 8a141be3233af7d4f7014ebc44d5452d46b2b1be ]

__ASSEMBLY__ is only defined by the Makefile of the kernel, so
this is not really useful for UAPI headers (unless the userspace
Makefile defines it, too). Let's switch to __ASSEMBLER__ which
gets set automatically by the compiler when compiling assembly
code.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Brian Gerst <brgerst@gmail.com>
Link: https://lore.kernel.org/r/20250310104256.123527-1-thuth@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/uapi/asm/bootparam.h  | 4 ++--
 arch/x86/include/uapi/asm/e820.h       | 4 ++--
 arch/x86/include/uapi/asm/ldt.h        | 4 ++--
 arch/x86/include/uapi/asm/msr.h        | 4 ++--
 arch/x86/include/uapi/asm/ptrace-abi.h | 6 +++---
 arch/x86/include/uapi/asm/ptrace.h     | 4 ++--
 arch/x86/include/uapi/asm/setup_data.h | 4 ++--
 arch/x86/include/uapi/asm/signal.h     | 8 ++++----
 8 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 9b82eebd7add5..dafbf581c515d 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -26,7 +26,7 @@
 #define XLF_5LEVEL_ENABLED		(1<<6)
 #define XLF_MEM_ENCRYPTION		(1<<7)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 #include <linux/screen_info.h>
@@ -210,6 +210,6 @@ enum x86_hardware_subarch {
 	X86_NR_SUBARCHS,
 };
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_X86_BOOTPARAM_H */
diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index 2f491efe3a126..55bc668671560 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -54,7 +54,7 @@
  */
 #define E820_RESERVED_KERN        128
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/types.h>
 struct e820entry {
 	__u64 addr;	/* start of memory segment */
@@ -76,7 +76,7 @@ struct e820map {
 #define BIOS_ROM_BASE		0xffe00000
 #define BIOS_ROM_END		0xffffffff
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 
 #endif /* _UAPI_ASM_X86_E820_H */
diff --git a/arch/x86/include/uapi/asm/ldt.h b/arch/x86/include/uapi/asm/ldt.h
index d62ac5db093b4..a82c039d8e6a7 100644
--- a/arch/x86/include/uapi/asm/ldt.h
+++ b/arch/x86/include/uapi/asm/ldt.h
@@ -12,7 +12,7 @@
 /* The size of each LDT entry. */
 #define LDT_ENTRY_SIZE	8
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 /*
  * Note on 64bit base and limit is ignored and you cannot set DS/ES/CS
  * not to the default values if you still want to do syscalls. This
@@ -44,5 +44,5 @@ struct user_desc {
 #define MODIFY_LDT_CONTENTS_STACK	1
 #define MODIFY_LDT_CONTENTS_CODE	2
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 #endif /* _ASM_X86_LDT_H */
diff --git a/arch/x86/include/uapi/asm/msr.h b/arch/x86/include/uapi/asm/msr.h
index e7516b402a00f..4b8917ca28fe7 100644
--- a/arch/x86/include/uapi/asm/msr.h
+++ b/arch/x86/include/uapi/asm/msr.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI_ASM_X86_MSR_H
 #define _UAPI_ASM_X86_MSR_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
@@ -10,5 +10,5 @@
 #define X86_IOC_RDMSR_REGS	_IOWR('c', 0xA0, __u32[8])
 #define X86_IOC_WRMSR_REGS	_IOWR('c', 0xA1, __u32[8])
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* _UAPI_ASM_X86_MSR_H */
diff --git a/arch/x86/include/uapi/asm/ptrace-abi.h b/arch/x86/include/uapi/asm/ptrace-abi.h
index 16074b9c93bb5..5823584dea132 100644
--- a/arch/x86/include/uapi/asm/ptrace-abi.h
+++ b/arch/x86/include/uapi/asm/ptrace-abi.h
@@ -25,7 +25,7 @@
 
 #else /* __i386__ */
 
-#if defined(__ASSEMBLY__) || defined(__FRAME_OFFSETS)
+#if defined(__ASSEMBLER__) || defined(__FRAME_OFFSETS)
 /*
  * C ABI says these regs are callee-preserved. They aren't saved on kernel entry
  * unless syscall needs a complete, fully filled "struct pt_regs".
@@ -57,7 +57,7 @@
 #define EFLAGS 144
 #define RSP 152
 #define SS 160
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 /* top of stack page */
 #define FRAME_SIZE 168
@@ -87,7 +87,7 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/types.h>
 #endif
 
diff --git a/arch/x86/include/uapi/asm/ptrace.h b/arch/x86/include/uapi/asm/ptrace.h
index 85165c0edafc8..e0b5b4f6226b1 100644
--- a/arch/x86/include/uapi/asm/ptrace.h
+++ b/arch/x86/include/uapi/asm/ptrace.h
@@ -7,7 +7,7 @@
 #include <asm/processor-flags.h>
 
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #ifdef __i386__
 /* this struct defines the way the registers are stored on the
@@ -81,6 +81,6 @@ struct pt_regs {
 
 
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_X86_PTRACE_H */
diff --git a/arch/x86/include/uapi/asm/setup_data.h b/arch/x86/include/uapi/asm/setup_data.h
index b111b0c185449..50c45ead4e7c9 100644
--- a/arch/x86/include/uapi/asm/setup_data.h
+++ b/arch/x86/include/uapi/asm/setup_data.h
@@ -18,7 +18,7 @@
 #define SETUP_INDIRECT			(1<<31)
 #define SETUP_TYPE_MAX			(SETUP_ENUM_MAX | SETUP_INDIRECT)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 
@@ -78,6 +78,6 @@ struct ima_setup_data {
 	__u64 size;
 } __attribute__((packed));
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_X86_SETUP_DATA_H */
diff --git a/arch/x86/include/uapi/asm/signal.h b/arch/x86/include/uapi/asm/signal.h
index f777346450ec3..1067efabf18b5 100644
--- a/arch/x86/include/uapi/asm/signal.h
+++ b/arch/x86/include/uapi/asm/signal.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI_ASM_X86_SIGNAL_H
 #define _UAPI_ASM_X86_SIGNAL_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/types.h>
 #include <linux/compiler.h>
 
@@ -16,7 +16,7 @@ struct siginfo;
 typedef unsigned long sigset_t;
 
 #endif /* __KERNEL__ */
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 
 #define SIGHUP		 1
@@ -68,7 +68,7 @@ typedef unsigned long sigset_t;
 
 #include <asm-generic/signal-defs.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 
 # ifndef __KERNEL__
@@ -106,6 +106,6 @@ typedef struct sigaltstack {
 	__kernel_size_t ss_size;
 } stack_t;
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_X86_SIGNAL_H */
-- 
2.39.5



