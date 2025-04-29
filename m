Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D8A25484E;
	Tue, 29 Apr 2025 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950235; cv=none; b=GT8W3kCCUijUAIC/NhEXo1+GK3t/D/hvqC7PcotzKo4Q5TkkbIa6DdQM9UnvVUIUitqJJcbc3UpMuPkoAvAgyULLf6F3zqIvOAAIukRFws8xuSZyafBrtQLNBojT5Fth00qiw+t1cpt6zT//lGv4UyaTYnMzEoXYLe4DEWYO+ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950235; c=relaxed/simple;
	bh=K1p80DJihUfXiwMmEh+EQaNCHzG58NPQla04qgnzxp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYga0sz29mqJxES9OLhplczmN7O3eD2nTCA6rb0k+qAKgg+T46hxIuNSa1P59e7ofRQfA/dBbHcafaZqEUJQAv824QyhVeEroq4oNia4uNFuzlSDWPJhYaJrZ7epXggF2vjrrjgp1up14bKEZrCDAHz3lmJpEii4BxENB38guY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c34kLPQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c34kLPQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F4FC4CEE3;
	Tue, 29 Apr 2025 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950234;
	bh=K1p80DJihUfXiwMmEh+EQaNCHzG58NPQla04qgnzxp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c34kLPQQi8ice/iW2tl4ul1fqZmvxhFp1mey3TzVCuAyZm8FZhBq+eRNelxZw2KEH
	 1biIh84H5c0oBqYI76x5FHyTeBhBQu4NTnxFAYdD84DWvwZrxzXJo10YWYOtqkD/WK
	 XUDGRuG8DDqNu31JBw1ZP9dO7auIXJRx3sUuT9Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tong Tiangen <tongtiangen@huawei.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/204] x86/extable: Remove unused fixup type EX_TYPE_COPY
Date: Tue, 29 Apr 2025 18:41:31 +0200
Message-ID: <20250429161059.539524468@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit cb517619f96718a4c3c2534a3124177633f8998d ]

After

  034ff37d3407 ("x86: rewrite '__copy_user_nocache' function")

rewrote __copy_user_nocache() to use EX_TYPE_UACCESS instead of the
EX_TYPE_COPY exception type, there are no more EX_TYPE_COPY users, so
remove it.

  [ bp: Massage commit message. ]

Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240204082627.3892816-2-tongtiangen@huawei.com
Stable-dep-of: 1a15bb8303b6 ("x86/mce: use is_copy_from_user() to determine copy-from-user context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/asm.h                 | 3 ---
 arch/x86/include/asm/extable_fixup_types.h | 2 +-
 arch/x86/kernel/cpu/mce/severity.c         | 1 -
 arch/x86/mm/extable.c                      | 9 ---------
 4 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index ca8eed1d496ab..2bec0c89a95c2 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -229,9 +229,6 @@ register unsigned long current_stack_pointer asm(_ASM_SP);
 #define _ASM_EXTABLE_UA(from, to)				\
 	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_UACCESS)
 
-#define _ASM_EXTABLE_CPY(from, to)				\
-	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_COPY)
-
 #define _ASM_EXTABLE_FAULT(from, to)				\
 	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_FAULT)
 
diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/asm/extable_fixup_types.h
index 991e31cfde94c..afad9c0b07e0c 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -36,7 +36,7 @@
 #define	EX_TYPE_DEFAULT			 1
 #define	EX_TYPE_FAULT			 2
 #define	EX_TYPE_UACCESS			 3
-#define	EX_TYPE_COPY			 4
+/* unused, was: #define EX_TYPE_COPY	 4 */
 #define	EX_TYPE_CLEAR_FS		 5
 #define	EX_TYPE_FPU_RESTORE		 6
 #define	EX_TYPE_BPF			 7
diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index c4477162c07d1..bca780fa5e577 100644
--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -290,7 +290,6 @@ static noinstr int error_context(struct mce *m, struct pt_regs *regs)
 
 	switch (fixup_type) {
 	case EX_TYPE_UACCESS:
-	case EX_TYPE_COPY:
 		if (!copy_user)
 			return IN_KERNEL;
 		m->kflags |= MCE_IN_KERNEL_COPYIN;
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 271dcb2deabc3..2354c0156e51c 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -163,13 +163,6 @@ static bool ex_handler_uaccess(const struct exception_table_entry *fixup,
 	return ex_handler_default(fixup, regs);
 }
 
-static bool ex_handler_copy(const struct exception_table_entry *fixup,
-			    struct pt_regs *regs, int trapnr)
-{
-	WARN_ONCE(trapnr == X86_TRAP_GP, "General protection fault in user access. Non-canonical address?");
-	return ex_handler_fault(fixup, regs, trapnr);
-}
-
 static bool ex_handler_msr(const struct exception_table_entry *fixup,
 			   struct pt_regs *regs, bool wrmsr, bool safe, int reg)
 {
@@ -267,8 +260,6 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 		return ex_handler_fault(e, regs, trapnr);
 	case EX_TYPE_UACCESS:
 		return ex_handler_uaccess(e, regs, trapnr, fault_addr);
-	case EX_TYPE_COPY:
-		return ex_handler_copy(e, regs, trapnr);
 	case EX_TYPE_CLEAR_FS:
 		return ex_handler_clear_fs(e, regs);
 	case EX_TYPE_FPU_RESTORE:
-- 
2.39.5



