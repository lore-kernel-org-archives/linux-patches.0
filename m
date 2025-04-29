Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D451F4736;
	Tue, 29 Apr 2025 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947895; cv=none; b=iyqmdf+r6nGarOdlEgbnkXKbVgFzu+d/bkuuSiYKubJnkcQGyjI8FQiKrSFRt4LFkW0pfZTUExUzqFmr1ESafm7ZeATLVnwsYeo4lOR7Q5Fc4Um+4Hhy5ukOl5CMY5I+k0UQ5OeT9jIPFtI1++XxEL5x5EivxEaRHLK9a0ceUTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947895; c=relaxed/simple;
	bh=+Ol5LLr+CE3dGNdwF1gEugbW8RDk6E17oUT8dbkVWic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNqN3Ay0V0CGwNTt/SjlG5nbzOCkNK7wi59zrdA2enwX+lRmKtBXjESmNpZsfSKYFBag5W0UF1jz3Jy8CgZmpsUnOCzQdOaUQW7EWMOPdF1ftcn6mlNZOH6urtL97pYDUOy6G3qX6HXxPPdLxzf4zkx7aVteocN548sm/QcCaqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTyXKMUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTyXKMUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB950C4CEE3;
	Tue, 29 Apr 2025 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947895;
	bh=+Ol5LLr+CE3dGNdwF1gEugbW8RDk6E17oUT8dbkVWic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTyXKMUGGeMDjvCtpchPvQk883ZK6x01wdKDoUs870W23/RnSrGzDt/uz/jpAHBT8
	 ljgTl4ASuNI5eqbFSYDo0LXglWSIs4IHspu0plHhr5744RsBYYMT/K+JhiVe9dzm2M
	 QtsOYGp4OCZo/yNSbOO8UAjq3teGmmhU/4yc56ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 107/280] LoongArch: Handle fp, lsx, lasx and lbt assembly symbols
Date: Tue, 29 Apr 2025 18:40:48 +0200
Message-ID: <20250429161119.485270684@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 2ef174b13344b3b4554d3d28e6f9e2a2c1d3138f upstream.

Like the other relevant symbols, export some fp, lsx, lasx and lbt
assembly symbols and put the function declarations in header files
rather than source files.

While at it, use "asmlinkage" for the other existing C prototypes
of assembly functions and also do not use the "extern" keyword with
function declarations according to the document coding-style.rst.

Cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/fpu.h |   37 ++++++++++++++++++++++---------------
 arch/loongarch/include/asm/lbt.h |   10 +++++++---
 arch/loongarch/kernel/fpu.S      |    6 ++++++
 arch/loongarch/kernel/lbt.S      |    4 ++++
 arch/loongarch/kernel/signal.c   |   21 ---------------------
 5 files changed, 39 insertions(+), 39 deletions(-)

--- a/arch/loongarch/include/asm/fpu.h
+++ b/arch/loongarch/include/asm/fpu.h
@@ -22,22 +22,29 @@
 struct sigcontext;
 
 #define kernel_fpu_available() cpu_has_fpu
-extern void kernel_fpu_begin(void);
-extern void kernel_fpu_end(void);
 
-extern void _init_fpu(unsigned int);
-extern void _save_fp(struct loongarch_fpu *);
-extern void _restore_fp(struct loongarch_fpu *);
-
-extern void _save_lsx(struct loongarch_fpu *fpu);
-extern void _restore_lsx(struct loongarch_fpu *fpu);
-extern void _init_lsx_upper(void);
-extern void _restore_lsx_upper(struct loongarch_fpu *fpu);
-
-extern void _save_lasx(struct loongarch_fpu *fpu);
-extern void _restore_lasx(struct loongarch_fpu *fpu);
-extern void _init_lasx_upper(void);
-extern void _restore_lasx_upper(struct loongarch_fpu *fpu);
+void kernel_fpu_begin(void);
+void kernel_fpu_end(void);
+
+asmlinkage void _init_fpu(unsigned int);
+asmlinkage void _save_fp(struct loongarch_fpu *);
+asmlinkage void _restore_fp(struct loongarch_fpu *);
+asmlinkage int _save_fp_context(void __user *fpregs, void __user *fcc, void __user *csr);
+asmlinkage int _restore_fp_context(void __user *fpregs, void __user *fcc, void __user *csr);
+
+asmlinkage void _save_lsx(struct loongarch_fpu *fpu);
+asmlinkage void _restore_lsx(struct loongarch_fpu *fpu);
+asmlinkage void _init_lsx_upper(void);
+asmlinkage void _restore_lsx_upper(struct loongarch_fpu *fpu);
+asmlinkage int _save_lsx_context(void __user *fpregs, void __user *fcc, void __user *fcsr);
+asmlinkage int _restore_lsx_context(void __user *fpregs, void __user *fcc, void __user *fcsr);
+
+asmlinkage void _save_lasx(struct loongarch_fpu *fpu);
+asmlinkage void _restore_lasx(struct loongarch_fpu *fpu);
+asmlinkage void _init_lasx_upper(void);
+asmlinkage void _restore_lasx_upper(struct loongarch_fpu *fpu);
+asmlinkage int _save_lasx_context(void __user *fpregs, void __user *fcc, void __user *fcsr);
+asmlinkage int _restore_lasx_context(void __user *fpregs, void __user *fcc, void __user *fcsr);
 
 static inline void enable_lsx(void);
 static inline void disable_lsx(void);
--- a/arch/loongarch/include/asm/lbt.h
+++ b/arch/loongarch/include/asm/lbt.h
@@ -12,9 +12,13 @@
 #include <asm/loongarch.h>
 #include <asm/processor.h>
 
-extern void _init_lbt(void);
-extern void _save_lbt(struct loongarch_lbt *);
-extern void _restore_lbt(struct loongarch_lbt *);
+asmlinkage void _init_lbt(void);
+asmlinkage void _save_lbt(struct loongarch_lbt *);
+asmlinkage void _restore_lbt(struct loongarch_lbt *);
+asmlinkage int _save_lbt_context(void __user *regs, void __user *eflags);
+asmlinkage int _restore_lbt_context(void __user *regs, void __user *eflags);
+asmlinkage int _save_ftop_context(void __user *ftop);
+asmlinkage int _restore_ftop_context(void __user *ftop);
 
 static inline int is_lbt_enabled(void)
 {
--- a/arch/loongarch/kernel/fpu.S
+++ b/arch/loongarch/kernel/fpu.S
@@ -458,6 +458,7 @@ SYM_FUNC_START(_save_fp_context)
 	li.w		a0, 0				# success
 	jr		ra
 SYM_FUNC_END(_save_fp_context)
+EXPORT_SYMBOL_GPL(_save_fp_context)
 
 /*
  * a0: fpregs
@@ -471,6 +472,7 @@ SYM_FUNC_START(_restore_fp_context)
 	li.w		a0, 0				# success
 	jr		ra
 SYM_FUNC_END(_restore_fp_context)
+EXPORT_SYMBOL_GPL(_restore_fp_context)
 
 /*
  * a0: fpregs
@@ -484,6 +486,7 @@ SYM_FUNC_START(_save_lsx_context)
 	li.w	a0, 0					# success
 	jr	ra
 SYM_FUNC_END(_save_lsx_context)
+EXPORT_SYMBOL_GPL(_save_lsx_context)
 
 /*
  * a0: fpregs
@@ -497,6 +500,7 @@ SYM_FUNC_START(_restore_lsx_context)
 	li.w	a0, 0					# success
 	jr	ra
 SYM_FUNC_END(_restore_lsx_context)
+EXPORT_SYMBOL_GPL(_restore_lsx_context)
 
 /*
  * a0: fpregs
@@ -510,6 +514,7 @@ SYM_FUNC_START(_save_lasx_context)
 	li.w	a0, 0					# success
 	jr	ra
 SYM_FUNC_END(_save_lasx_context)
+EXPORT_SYMBOL_GPL(_save_lasx_context)
 
 /*
  * a0: fpregs
@@ -523,6 +528,7 @@ SYM_FUNC_START(_restore_lasx_context)
 	li.w	a0, 0					# success
 	jr	ra
 SYM_FUNC_END(_restore_lasx_context)
+EXPORT_SYMBOL_GPL(_restore_lasx_context)
 
 .L_fpu_fault:
 	li.w	a0, -EFAULT				# failure
--- a/arch/loongarch/kernel/lbt.S
+++ b/arch/loongarch/kernel/lbt.S
@@ -90,6 +90,7 @@ SYM_FUNC_START(_save_lbt_context)
 	li.w		a0, 0			# success
 	jr		ra
 SYM_FUNC_END(_save_lbt_context)
+EXPORT_SYMBOL_GPL(_save_lbt_context)
 
 /*
  * a0: scr
@@ -110,6 +111,7 @@ SYM_FUNC_START(_restore_lbt_context)
 	li.w		a0, 0			# success
 	jr		ra
 SYM_FUNC_END(_restore_lbt_context)
+EXPORT_SYMBOL_GPL(_restore_lbt_context)
 
 /*
  * a0: ftop
@@ -120,6 +122,7 @@ SYM_FUNC_START(_save_ftop_context)
 	li.w		a0, 0			# success
 	jr		ra
 SYM_FUNC_END(_save_ftop_context)
+EXPORT_SYMBOL_GPL(_save_ftop_context)
 
 /*
  * a0: ftop
@@ -150,6 +153,7 @@ SYM_FUNC_START(_restore_ftop_context)
 	li.w		a0, 0			# success
 	jr		ra
 SYM_FUNC_END(_restore_ftop_context)
+EXPORT_SYMBOL_GPL(_restore_ftop_context)
 
 .L_lbt_fault:
 	li.w		a0, -EFAULT		# failure
--- a/arch/loongarch/kernel/signal.c
+++ b/arch/loongarch/kernel/signal.c
@@ -51,27 +51,6 @@
 #define lock_lbt_owner()	({ preempt_disable(); pagefault_disable(); })
 #define unlock_lbt_owner()	({ pagefault_enable(); preempt_enable(); })
 
-/* Assembly functions to move context to/from the FPU */
-extern asmlinkage int
-_save_fp_context(void __user *fpregs, void __user *fcc, void __user *csr);
-extern asmlinkage int
-_restore_fp_context(void __user *fpregs, void __user *fcc, void __user *csr);
-extern asmlinkage int
-_save_lsx_context(void __user *fpregs, void __user *fcc, void __user *fcsr);
-extern asmlinkage int
-_restore_lsx_context(void __user *fpregs, void __user *fcc, void __user *fcsr);
-extern asmlinkage int
-_save_lasx_context(void __user *fpregs, void __user *fcc, void __user *fcsr);
-extern asmlinkage int
-_restore_lasx_context(void __user *fpregs, void __user *fcc, void __user *fcsr);
-
-#ifdef CONFIG_CPU_HAS_LBT
-extern asmlinkage int _save_lbt_context(void __user *regs, void __user *eflags);
-extern asmlinkage int _restore_lbt_context(void __user *regs, void __user *eflags);
-extern asmlinkage int _save_ftop_context(void __user *ftop);
-extern asmlinkage int _restore_ftop_context(void __user *ftop);
-#endif
-
 struct rt_sigframe {
 	struct siginfo rs_info;
 	struct ucontext rs_uctx;


