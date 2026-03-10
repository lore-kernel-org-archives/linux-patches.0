Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7F389DEF;
	Tue, 10 Mar 2026 11:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141971; cv=none; b=Rqj8TwjbmI8icVppzOhslvSwcD940G4nwmyJNamkdKyd4ZShHqCRnkcfefbu+29UoJ0c9ux9kLfBqIV02Zn/x8ecBH3JrgqrOxnkq4f2VOzGyDnIrR7QddCr+SHWcP2j+jHbDYKCOykuYLBCTT5UGl6409fgi1HTJWR47P7Z+pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141971; c=relaxed/simple;
	bh=qypdzIZQjaHVSjJfEWFvSR5tck3kaougy/s0kT9Lk3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5jqcUXP8SX4Zflwix1aI9Ou6t+ipQVZoXOHVq2imhDJrY7k2HSTmjFA0TGWOlpd0Hy4RKmGgddcPvL2ZArixtsfp+8J9PL2rGIAZ4B+QohqF38Ca7Fg3wzquqwPR992J/P5gUAKyqFQ4crUJoJJkhWQi9qW9fTjieTQJvMK0/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSziVL54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSziVL54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2129C19423;
	Tue, 10 Mar 2026 11:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141971;
	bh=qypdzIZQjaHVSjJfEWFvSR5tck3kaougy/s0kT9Lk3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSziVL546AeIzdT/rdPImSFSZXCkuZXPgzzqgzjJWNw784/l0n79QjcgxOA/gyKAz
	 8753qoq2VOhkOAFFibihKVvVasf8y3QCEZjrc3HmplOda2BaATYvqkKm/G6hYMXJw1
	 W7lBB3QRclS2hZsvRH9lnLISHIA8J0ASlKayzLCfvoVh6vEdLShS+qgH4SyrGyJgd/
	 PN65gY1dZTsIVE0P/IMUbNGYXPPBLwYE5626YAPpb3Tbnwb4AJ1QvrwZYOmigUQsF/
	 mEjJKPjQ1RzsKKE79GkA+951LMLTel4aK94Q9hWZTV94YTXkqnxOsm+++AfuOhUIow
	 xOxewXSaBuSgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/314] unwind_user/x86: Enable frame pointer unwinding on x86
Date: Tue, 10 Mar 2026 07:15:55 -0400
Message-ID: <5ee31c7d27fc049018e87ba959a5abd780451323.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 49cf34c0815f93fb2ea3ab5cfbac1124bd9b45d0 ]

Use ARCH_INIT_USER_FP_FRAME to describe how frame pointers are unwound
on x86, and enable CONFIG_HAVE_UNWIND_USER_FP accordingly so the
unwind_user interfaces can be used.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20250827193828.347397433@kernel.org
Stable-dep-of: d55c571e4333 ("x86/uprobes: Fix XOL allocation failure for 32-bit tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig                   |  1 +
 arch/x86/include/asm/unwind_user.h | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)
 create mode 100644 arch/x86/include/asm/unwind_user.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a3700766a8c08..ee41af778a9dc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -298,6 +298,7 @@ config X86
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UACCESS_VALIDATION		if HAVE_OBJTOOL
 	select HAVE_UNSTABLE_SCHED_CLOCK
+	select HAVE_UNWIND_USER_FP		if X86_64
 	select HAVE_USER_RETURN_NOTIFIER
 	select HAVE_GENERIC_VDSO
 	select VDSO_GETRANDOM			if X86_64
diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
new file mode 100644
index 0000000000000..b166e102d4445
--- /dev/null
+++ b/arch/x86/include/asm/unwind_user.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_UNWIND_USER_H
+#define _ASM_X86_UNWIND_USER_H
+
+#include <asm/ptrace.h>
+
+#define ARCH_INIT_USER_FP_FRAME(ws)			\
+	.cfa_off	=  2*(ws),			\
+	.ra_off		= -1*(ws),			\
+	.fp_off		= -2*(ws),			\
+	.use_fp		= true,
+
+static inline int unwind_user_word_size(struct pt_regs *regs)
+{
+	/* We can't unwind VM86 stacks */
+	if (regs->flags & X86_VM_MASK)
+		return 0;
+#ifdef CONFIG_X86_64
+	if (!user_64bit_mode(regs))
+		return sizeof(int);
+#endif
+	return sizeof(long);
+}
+
+#endif /* _ASM_X86_UNWIND_USER_H */
-- 
2.51.0

