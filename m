Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973B44071DA;
	Sun,  7 Jun 2026 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827030; cv=none; b=d/Hyp9HgvfcN4gVOkztEY/7ggCh2U7rFEdW8LdyZp4CWAQR/2B6MikZBn8Mvg584uD4JGYF3weLAZdR+8huxJV7BtDGHk7fHT64dvvCw4flM4wbTDrC3e3qSf2O8GUnKqloeKsYElqRUzloTfgfwHeY4qEDn/x7YtySktggpPz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827030; c=relaxed/simple;
	bh=OPkfZtdlmN/wCw6c8GPMe/D2dA6uLLSkfI57pqOIf9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGZk2Zp6OBouadmY9pwACegtoX5axfdUDFiMOxFLoyPmKlbTGrtoX8qRJD9eWM+tuu8ieM5IUxpQIW1HX5z+FF7rqjpYchLotO0mEoGHzUgxocrx0fvsmbI3Zwtq8qEgiZF0Md49zvRVYb0wffei3TQSSvC8kS4KFrwrV4GhvbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iqt9jl9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iqt9jl9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94F21F00893;
	Sun,  7 Jun 2026 10:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827029;
	bh=QbixXJ+ZiP8W72AyElLplb/u9mxwl/4DVD66TW9kcg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iqt9jl9iWuxInHsQDjK2wQ7RMkmADfqDXK5u0/3LdsIUU5HDNfmPsbfp2Ve6NrVsY
	 XTF8lUuBcK2HARGiBYX3DGxh3+wPRv7aCJfHeCclG6WIkzahcIxp7SkHvNMjZg1uZh
	 POdHrdWVfpKn2ePYDYh1BpBQucLqkpfSpSey+K2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/307] arm64: entry: Add entry and exit functions for debug exceptions
Date: Sun,  7 Jun 2026 11:56:53 +0200
Message-ID: <20260607095728.222759286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

[ Upstream commit eaff68b3286116d499a3d4e513a36d772faba587 ]

Move the `debug_exception_enter()` and `debug_exception_exit()`
functions from mm/fault.c, as they are needed to split
the debug exceptions entry paths from the current unified one.

Make them externally visible in include/asm/exception.h until
the caller in mm/fault.c is cleaned up.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Tested-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Will Deacon <will@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250707114109.35672-7-ada.coupriediaz@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/exception.h |  4 ++++
 arch/arm64/kernel/entry-common.c   | 22 ++++++++++++++++++++++
 arch/arm64/mm/fault.c              | 22 ----------------------
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index f296662590c7f8..b1d6a65f6d2256 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -77,4 +77,8 @@ void do_serror(struct pt_regs *regs, unsigned long esr);
 void do_signal(struct pt_regs *regs);
 
 void __noreturn panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigned long far);
+
+void debug_exception_enter(struct pt_regs *regs);
+void debug_exception_exit(struct pt_regs *regs);
+
 #endif	/* __ASM_EXCEPTION_H */
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index d23315ef7b679b..2e04e04aaf2ad6 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -441,6 +441,28 @@ static __always_inline void fpsimd_syscall_exit(void)
 	__this_cpu_write(fpsimd_last_state.to_save, FP_STATE_CURRENT);
 }
 
+/*
+ * In debug exception context, we explicitly disable preemption despite
+ * having interrupts disabled.
+ * This serves two purposes: it makes it much less likely that we would
+ * accidentally schedule in exception context and it will force a warning
+ * if we somehow manage to schedule by accident.
+ */
+void debug_exception_enter(struct pt_regs *regs)
+{
+	preempt_disable();
+
+	/* This code is a bit fragile.  Test it. */
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "exception_enter didn't work");
+}
+NOKPROBE_SYMBOL(debug_exception_enter);
+
+void debug_exception_exit(struct pt_regs *regs)
+{
+	preempt_enable_no_resched();
+}
+NOKPROBE_SYMBOL(debug_exception_exit);
+
 UNHANDLED(el1t, 64, sync)
 UNHANDLED(el1t, 64, irq)
 UNHANDLED(el1t, 64, fiq)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2d1ebc0c3437f2..7c87d2b3b06eaa 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -939,28 +939,6 @@ void __init hook_debug_fault_code(int nr,
 	debug_fault_info[nr].name	= name;
 }
 
-/*
- * In debug exception context, we explicitly disable preemption despite
- * having interrupts disabled.
- * This serves two purposes: it makes it much less likely that we would
- * accidentally schedule in exception context and it will force a warning
- * if we somehow manage to schedule by accident.
- */
-static void debug_exception_enter(struct pt_regs *regs)
-{
-	preempt_disable();
-
-	/* This code is a bit fragile.  Test it. */
-	RCU_LOCKDEP_WARN(!rcu_is_watching(), "exception_enter didn't work");
-}
-NOKPROBE_SYMBOL(debug_exception_enter);
-
-static void debug_exception_exit(struct pt_regs *regs)
-{
-	preempt_enable_no_resched();
-}
-NOKPROBE_SYMBOL(debug_exception_exit);
-
 void do_debug_exception(unsigned long addr_if_watchpoint, unsigned long esr,
 			struct pt_regs *regs)
 {
-- 
2.53.0



