Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063752;
	b=hRitPsbrvTyY1mxwyzYioet/vK12m0cKNJAggeDuOJmGD+jWX2d7V8XiUXUwhPLiJ/QD
	 50+jhlMaeA1YiL209wFqzAD+X5x/0GGKaYOEuvrCpfmVIs3mI4MsCZ9QC5jZ2eB382iJ5
	 QktXPsyqbe9oCzVUKrWI6rmgFh4akEYgJDiKODQG5iWHC4Bqnqf9ko6zVqdhCGdZSWL5R
	 VajQFw0ihmnLvd1BSZ1MZiD5lm7DVs0kOkmDRs1Fi8q1NnWEU/wxgGMHo9CWZVD0JHYde
	 hPkCPcYOghYAERGgTfScL1ngcXbKNvRRmS+T9p9Q1gmixIzatA4GoV0WH5jMxdwkAsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1vYUu3ScqDo9Y5xjO+dMWSx9IUKkIK6laJS9mcCP5Fo=;
	b=IqiOjt6D4tDF8V2pZSv89Y5P+CRpEvjpKtwYDb9xp4iV00C3cKgXbq2iqaoqqQlaWSmm
	 pJx3+kviCWFm1zm/H4a2PmHgJPIvI9mVrJAwAQtqzpjBM6imKx6rg5bRJ4Q1hTqRL3J80
	 oHpAq2iIc1vnoS92BxiCogpwTxXaDMENfNxKtvPPwGocU9cMeWn9bhal67kfTSomK36ev
	 2mIxAp4N5n6K42gD3ULTeJ2kb8ecAdzV1i3ckvZQJh37IuATEce7hM/qqSQ5/f/7e136j
	 N4PdLJDF5uJNrZGo2ZuuIDUMslG8XODaA4fXzAl0ZI1xYBGjpwZddCzuN4Jtsbkbo0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPZkuHVd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE20606D809;
	Sat,  7 Nov 2026 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPZkuHVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2885A1F008A1;
	Sat,  7 Nov 2026 15:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063752;
	bh=1vYUu3ScqDo9Y5xjO+dMWSx9IUKkIK6laJS9mcCP5Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPZkuHVdgffe+SxmUUMADOCaYNARF78zXm1f66x2YshFYA8MZ2jZuW7R9/FpClWKL
	 T/MOxKxbYdYdK5rUMWNOvNZXIAVeVNCZ2sYai2pJLI43Z1pAfjYg9xgIZ/4y4xO4uR
	 llaUn0pd/8Y0nDWrzgXqiKTod8aOzIRVyKeGaGho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 808/869] LoongArch: Only send SIGTRAP signal if necessary in do_watch()
Date: Sat,  7 Nov 2026 08:58:10 -0500
Message-ID: <20261107134920.405737893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit f087903018e35d38b8932e18b010ee2e8699d1a1 ]

In do_watch(), the kernel unconditionally forces a SIGTRAP signal at the
end of the handler via force_sig(SIGTRAP). This is essential for ptrace
operations, but it severely disrupts standard perf_event usage.

Under normal perf usage, it is not necessary to force a SIGTRAP signal
on every hit. Forcing it unnecessarily aborts the target process if no
user-space signal handler is registered, which violates performance
monitoring behaviors and injects context switch overheads.

However, a conditional check using only 'current->ptrace' would block
legitimate user-requested signals when a perf_event is configured with
'attr.sigtrap = 1' for asynchronous user-space tracking.

Fix this by refactoring breakpoint_handler() and watchpoint_handler()
to return a boolean status indicating whether any triggered breakpoint
explicitly requires a signal notification. Update do_watch() to enforce
the SIGTRAP signal only when the process is actively being debugged via
ptrace, or when the underlying perf_event infrastructure specifically
demands it via 'attr.sigtrap'.

Cc: stable@vger.kernel.org
Fixes: 424421a7f34c ("LoongArch: ptrace: Add hardware single step support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |  4 ++--
 arch/loongarch/kernel/hw_breakpoint.c      | 18 ++++++++++++++++--
 arch/loongarch/kernel/traps.c              |  9 ++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/include/asm/hw_breakpoint.h b/arch/loongarch/include/asm/hw_breakpoint.h
index 5faa97a87a9e2..d202052df8a16 100644
--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -116,8 +116,8 @@ extern void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 extern int hw_breakpoint_slots(int type);
 extern void hw_breakpoint_pmu_read(struct perf_event *bp);
 
-void breakpoint_handler(struct pt_regs *regs);
-void watchpoint_handler(struct pt_regs *regs);
+bool breakpoint_handler(struct pt_regs *regs);
+bool watchpoint_handler(struct pt_regs *regs);
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 extern void ptrace_hw_copy_thread(struct task_struct *task);
diff --git a/arch/loongarch/kernel/hw_breakpoint.c b/arch/loongarch/kernel/hw_breakpoint.c
index 7f69cf361a5e2..d009ed780cf02 100644
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -482,9 +482,10 @@ NOKPROBE_SYMBOL(update_bp_registers);
 /*
  * Debug exception handlers.
  */
-void breakpoint_handler(struct pt_regs *regs)
+bool breakpoint_handler(struct pt_regs *regs)
 {
 	int i;
+	bool need_sigtrap = false;
 	struct perf_event *bp, **slots;
 
 	slots = this_cpu_ptr(bp_on_reg);
@@ -494,17 +495,24 @@ void breakpoint_handler(struct pt_regs *regs)
 			bp = slots[i];
 			if (bp == NULL)
 				continue;
+
 			perf_bp_event(bp, regs);
+			if (bp->attr.sigtrap)
+				need_sigtrap = true;
+
 			csr_write32(0x1 << i, LOONGARCH_CSR_FWPS);
 			update_bp_registers(regs, 0, 0);
 		}
 	}
+
+	return need_sigtrap;
 }
 NOKPROBE_SYMBOL(breakpoint_handler);
 
-void watchpoint_handler(struct pt_regs *regs)
+bool watchpoint_handler(struct pt_regs *regs)
 {
 	int i;
+	bool need_sigtrap = false;
 	struct perf_event *wp, **slots;
 
 	slots = this_cpu_ptr(wp_on_reg);
@@ -514,11 +522,17 @@ void watchpoint_handler(struct pt_regs *regs)
 			wp = slots[i];
 			if (wp == NULL)
 				continue;
+
 			perf_bp_event(wp, regs);
+			if (wp->attr.sigtrap)
+				need_sigtrap = true;
+
 			csr_write32(0x1 << i, LOONGARCH_CSR_MWPS);
 			update_bp_registers(regs, 0, 1);
 		}
 	}
+
+	return need_sigtrap;
 }
 NOKPROBE_SYMBOL(watchpoint_handler);
 
diff --git a/arch/loongarch/kernel/traps.c b/arch/loongarch/kernel/traps.c
index 4c2e5a13f07e4..9ce12327d64ea 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -807,6 +807,8 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 #ifndef CONFIG_HAVE_HW_BREAKPOINT
 	pr_warn("Hardware watch point handler not implemented!\n");
 #else
+	bool need_sigtrap = !!current->ptrace;
+
 	if (kgdb_breakpoint_handler(regs))
 		goto out;
 
@@ -843,11 +845,12 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 			}
 		}
 	} else {
-		breakpoint_handler(regs);
-		watchpoint_handler(regs);
+		need_sigtrap |= breakpoint_handler(regs);
+		need_sigtrap |= watchpoint_handler(regs);
 	}
 
-	force_sig(SIGTRAP);
+	if (need_sigtrap)
+		force_sig(SIGTRAP);
 out:
 #endif
 	irqentry_exit(regs, state);
-- 
2.53.0



