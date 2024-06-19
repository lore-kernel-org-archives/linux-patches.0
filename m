Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EFB82495;
	Wed, 19 Jun 2024 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803143; cv=none; b=FFzqkJUezTdhnXZfcq62QeOeObsBjD7NtovPFpWNQLqFFQF9S9jwg4P20JeQUDXv1x+z5Vw18vBtGJPc1+3eLRwzsBAsrDPs5LpbXVECXDhq+nZvDyXX4V8Wmq70LW2jmaf+DWWJ8MBnwpgFmCsm1gzCZ4CtdzZRSoPCA9Me+tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803143; c=relaxed/simple;
	bh=4V3uxCZkiVGDAoeZgi9vljr08xmD1nvkzgHoYXVuMo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuVInd8WxVm88OzrmwK+LMaLzyLLHaJIcG0XyQofW7ZfntlFRZhOIStVPFyw5oL9n1FaT67AftBZu9pElM+xeqNzHGLppYDxGq7Eq+krGQUjQ37VaskMQz/ks3dexPh4OxXSR4JX+e7yyZYioiUZu3Ierlvck7wUlep+Mya9n5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5yJxnFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5yJxnFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C11C2BBFC;
	Wed, 19 Jun 2024 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803143;
	bh=4V3uxCZkiVGDAoeZgi9vljr08xmD1nvkzgHoYXVuMo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5yJxnFnq4xGR0omBvCoNx5dAV3woEoeyZD5MirNHEB8gJ4K78X75JBlczOuQSu0y
	 b/RJwSjHym9AO5esM3Z83gHukMGqwIdhfNdIlGyt3JzMQrEnN1cr/WA7lHnCDhKwkB
	 SShEL4wKrOSQNh7RvcpRyXBHn6L8CEO41B76soPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 167/281] x86/asm: Use %c/%n instead of %P operand modifier in asm templates
Date: Wed, 19 Jun 2024 14:55:26 +0200
Message-ID: <20240619125616.263650277@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 41cd2e1ee96e56401a18dbce6f42f0bdaebcbf3b ]

The "P" asm operand modifier is a x86 target-specific modifier.

When used with a constant, the "P" modifier emits "cst" instead of
"$cst". This property is currently used to emit the bare constant
without all syntax-specific prefixes.

The generic "c" resp. "n" operand modifier should be used instead.

No functional changes intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20240319104418.284519-3-ubizjak@gmail.com
Stable-dep-of: 8c860ed825cb ("x86/uaccess: Fix missed zeroing of ia32 u64 get_user() range checking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/main.c               |  4 ++--
 arch/x86/include/asm/alternative.h | 22 +++++++++++-----------
 arch/x86/include/asm/atomic64_32.h |  2 +-
 arch/x86/include/asm/cpufeature.h  |  2 +-
 arch/x86/include/asm/irq_stack.h   |  2 +-
 arch/x86/include/asm/uaccess.h     |  4 ++--
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index c4ea5258ab558..9049f390d8347 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -119,8 +119,8 @@ static void init_heap(void)
 	char *stack_end;
 
 	if (boot_params.hdr.loadflags & CAN_USE_HEAP) {
-		asm("leal %P1(%%esp),%0"
-		    : "=r" (stack_end) : "i" (-STACK_SIZE));
+		asm("leal %n1(%%esp),%0"
+		    : "=r" (stack_end) : "i" (STACK_SIZE));
 
 		heap_end = (char *)
 			((size_t)boot_params.hdr.heap_end_ptr + 0x200);
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 67b68d0d17d1e..0cb2396de066d 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -294,10 +294,10 @@ static inline int alternatives_text_reserved(void *start, void *end)
  * Otherwise, if CPU has feature1, newinstr1 is used.
  * Otherwise, oldinstr is used.
  */
-#define alternative_input_2(oldinstr, newinstr1, ft_flags1, newinstr2,	     \
-			   ft_flags2, input...)				     \
-	asm_inline volatile(ALTERNATIVE_2(oldinstr, newinstr1, ft_flags1,     \
-		newinstr2, ft_flags2)					     \
+#define alternative_input_2(oldinstr, newinstr1, ft_flags1, newinstr2,	\
+			   ft_flags2, input...)				\
+	asm_inline volatile(ALTERNATIVE_2(oldinstr, newinstr1, ft_flags1, \
+		newinstr2, ft_flags2)					\
 		: : "i" (0), ## input)
 
 /* Like alternative_input, but with a single output argument */
@@ -307,7 +307,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 
 /* Like alternative_io, but for replacing a direct call with another one. */
 #define alternative_call(oldfunc, newfunc, ft_flags, output, input...)	\
-	asm_inline volatile (ALTERNATIVE("call %P[old]", "call %P[new]", ft_flags) \
+	asm_inline volatile (ALTERNATIVE("call %c[old]", "call %c[new]", ft_flags) \
 		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
 
 /*
@@ -316,12 +316,12 @@ static inline int alternatives_text_reserved(void *start, void *end)
  * Otherwise, if CPU has feature1, function1 is used.
  * Otherwise, old function is used.
  */
-#define alternative_call_2(oldfunc, newfunc1, ft_flags1, newfunc2, ft_flags2,   \
-			   output, input...)				      \
-	asm_inline volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]", ft_flags1,\
-		"call %P[new2]", ft_flags2)				      \
-		: output, ASM_CALL_CONSTRAINT				      \
-		: [old] "i" (oldfunc), [new1] "i" (newfunc1),		      \
+#define alternative_call_2(oldfunc, newfunc1, ft_flags1, newfunc2, ft_flags2, \
+			   output, input...)				\
+	asm_inline volatile (ALTERNATIVE_2("call %c[old]", "call %c[new1]", ft_flags1, \
+		"call %c[new2]", ft_flags2)				\
+		: output, ASM_CALL_CONSTRAINT				\
+		: [old] "i" (oldfunc), [new1] "i" (newfunc1),		\
 		  [new2] "i" (newfunc2), ## input)
 
 /*
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 3486d91b8595f..d510405e4e1de 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -24,7 +24,7 @@ typedef struct {
 
 #ifdef CONFIG_X86_CMPXCHG64
 #define __alternative_atomic64(f, g, out, in...) \
-	asm volatile("call %P[func]" \
+	asm volatile("call %c[func]" \
 		     : out : [func] "i" (atomic64_##g##_cx8), ## in)
 
 #define ATOMIC64_DECL(sym) ATOMIC64_DECL_ONE(sym##_cx8)
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 686e92d2663ee..3508f3fc928d4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -173,7 +173,7 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
 static __always_inline bool _static_cpu_has(u16 bit)
 {
 	asm goto(
-		ALTERNATIVE_TERNARY("jmp 6f", %P[feature], "", "jmp %l[t_no]")
+		ALTERNATIVE_TERNARY("jmp 6f", %c[feature], "", "jmp %l[t_no]")
 		".pushsection .altinstr_aux,\"ax\"\n"
 		"6:\n"
 		" testb %[bitnum]," _ASM_RIP(%P[cap_byte]) "\n"
diff --git a/arch/x86/include/asm/irq_stack.h b/arch/x86/include/asm/irq_stack.h
index 798183867d789..b71ad173f8776 100644
--- a/arch/x86/include/asm/irq_stack.h
+++ b/arch/x86/include/asm/irq_stack.h
@@ -100,7 +100,7 @@
 }
 
 #define ASM_CALL_ARG0							\
-	"call %P[__func]				\n"		\
+	"call %c[__func]				\n"		\
 	ASM_REACHABLE
 
 #define ASM_CALL_ARG1							\
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 237dc8cdd12b9..0f9bab92a43d7 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -78,7 +78,7 @@ extern int __get_user_bad(void);
 	int __ret_gu;							\
 	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
 	__chk_user_ptr(ptr);						\
-	asm volatile("call __" #fn "_%P4"				\
+	asm volatile("call __" #fn "_%c4"				\
 		     : "=a" (__ret_gu), "=r" (__val_gu),		\
 			ASM_CALL_CONSTRAINT				\
 		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
@@ -177,7 +177,7 @@ extern void __put_user_nocheck_8(void);
 	__chk_user_ptr(__ptr);						\
 	__ptr_pu = __ptr;						\
 	__val_pu = __x;							\
-	asm volatile("call __" #fn "_%P[size]"				\
+	asm volatile("call __" #fn "_%c[size]"				\
 		     : "=c" (__ret_pu),					\
 			ASM_CALL_CONSTRAINT				\
 		     : "0" (__ptr_pu),					\
-- 
2.43.0



