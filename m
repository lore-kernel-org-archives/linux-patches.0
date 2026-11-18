Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058928;
	b=JMpuHRUCK3A3ts/daTKNzv1ipq/1tj5525pjqZYu0lWo/ujtQG2B7QuWzREseks1AbEU
	 5dWowO9u2f7KzIS77Frc6nwhT/rg13VbypQg8YoekVGb+ovi3GYShPs4hbVtWF/69ZjCT
	 MiIAxs+5lKswqs3V/8O+r+V83jZaZIylsmDxe09s4ocrfHrC4joQfBqGIwLZ+4EJFyyR8
	 qguPjnEmpMJrbgSQJFnYr4fsZIZTsRqd3bo4jXglRpXyl01NC76chRV6pHJoaUb+QXKLq
	 ad8jLe7dloGfKPJSSiHQxHhhBTfhAjbL3IIDjWipMnrEIKtSROQG2O9odFPt0OhhSmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+wwHrLmpS6yDKKv6itkPyyZYzuh7XyfIh9cPfHswLhk=;
	b=R/OZssnCkImmWn8N/Bw3SkjZLJV5f6IrViErlmA1A15B+2qDmscfCgCBsplM5dq1Vi/I
	 s6Ofbo2pmptnWNtjpeLg0rUWOW/mbA9BHXw+JSSQr/bgG1EpImxCQEVRM33DIUCIQx717
	 gRotdUDIs0YQhrQscvYsLXs4zj5WYh3ZRzUKn48cmeSyMLI0l54KgdO2HXi1bK+rbEZVs
	 5TDpaK5rE3hN+S7jNjJQfsenusNokAd5xGhI9gmulwu6hB6d5ypNpf6Sm1un0wxuc5rj9
	 dPev9wMyA2Mh9UbGT8PcqbnDjzxFFvA89uE36ZcMM7nI3EJ4XTo9gXeP/lsL8PAr9zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C6u3j/Q2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D43606A31C;
	Thu, 19 Nov 2026 03:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6u3j/Q2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176141F000C4;
	Thu, 19 Nov 2026 03:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058928;
	bh=+wwHrLmpS6yDKKv6itkPyyZYzuh7XyfIh9cPfHswLhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6u3j/Q2GmYDKvVxdgznSRZaeYZ4La6r5PRHCZmOyP0LEtxoh8atkWFybOfMX9SRI
	 gM48kNOl0s93ZUQvXUcrhbfdl5DqrJtaKWbRoRy1pqZnDxDvREH7P20THenO8HUlti
	 rfJ0DG6IDr/ubZVml9u2/azKpSH1gpJpNYvgMlWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Tengda Wu <wutengda@huaweicloud.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0659/1848] arm64: kprobes: Remove redundant kprobe_step_ctx
Date: Wed, 18 Nov 2026 15:44:57 +0100
Message-ID: <20261118145943.363564966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu <mhiramat@kernel.org>

commit ba090f9cafd53dbabe0f0a8c4ccae44203d3731b upstream.

The kprobe_step_ctx (kcb->ss_ctx) has ss_pending and match_addr, but
those are redundant because those can be replaced by KPROBE_HIT_SS and
&cur_kprobe->ainsn.api.insn[1] respectively.
To simplify the code, remove the kprobe_step_ctx.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201103134900.337243-2-jean-philippe@linaro.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kprobes.h   |  7 ----
 arch/arm64/kernel/probes/kprobes.c | 53 +++++++-----------------------
 2 files changed, 12 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
index 0a15d23296273..6d131318d5779 100644
--- a/arch/arm64/include/asm/kprobes.h
+++ b/arch/arm64/include/asm/kprobes.h
@@ -34,18 +34,11 @@ struct prev_kprobe {
 	unsigned long saved_irqflag;
 };
 
-/* Single step context for kprobe */
-struct kprobe_step_ctx {
-	unsigned long ss_pending;
-	unsigned long match_addr;
-};
-
 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned int kprobe_status;
 	unsigned long saved_irqflag;
 	struct prev_kprobe prev_kprobe;
-	struct kprobe_step_ctx ss_ctx;
 };
 
 void arch_remove_kprobe(struct kprobe *);
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 412afe22257d9..215733a51f976 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -34,7 +34,7 @@ DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 static void __kprobes
-post_kprobe_handler(struct kprobe_ctlblk *, struct pt_regs *);
+post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs *);
 
 static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 {
@@ -68,7 +68,7 @@ static void __kprobes arch_simulate_insn(struct kprobe *p, struct pt_regs *regs)
 		p->ainsn.api.handler((u32)p->opcode, (long)p->addr, regs);
 
 	/* single step simulated, now go for post processing */
-	post_kprobe_handler(kcb, regs);
+	post_kprobe_handler(p, kcb, regs);
 }
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
@@ -192,19 +192,6 @@ static void __kprobes kprobes_restore_local_irqflag(struct kprobe_ctlblk *kcb,
 	regs->pstate |= kcb->saved_irqflag;
 }
 
-static void __kprobes
-set_ss_context(struct kprobe_ctlblk *kcb, unsigned long addr)
-{
-	kcb->ss_ctx.ss_pending = true;
-	kcb->ss_ctx.match_addr = addr + sizeof(kprobe_opcode_t);
-}
-
-static void __kprobes clear_ss_context(struct kprobe_ctlblk *kcb)
-{
-	kcb->ss_ctx.ss_pending = false;
-	kcb->ss_ctx.match_addr = 0;
-}
-
 static void __kprobes setup_singlestep(struct kprobe *p,
 				       struct pt_regs *regs,
 				       struct kprobe_ctlblk *kcb, int reenter)
@@ -224,7 +211,6 @@ static void __kprobes setup_singlestep(struct kprobe *p,
 		/* prepare for single stepping */
 		slot = (unsigned long)p->ainsn.api.insn;
 
-		set_ss_context(kcb, slot);	/* mark pending ss */
 		kprobes_save_local_irqflag(kcb, regs);
 		instruction_pointer_set(regs, slot);
 	} else {
@@ -264,13 +250,8 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 }
 
 static void __kprobes
-post_kprobe_handler(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
+post_kprobe_handler(struct kprobe *cur, struct kprobe_ctlblk *kcb, struct pt_regs *regs)
 {
-	struct kprobe *cur = kprobe_running();
-
-	if (!cur)
-		return;
-
 	/* return addr restore if non-branching insn */
 	if (cur->ainsn.api.restore != 0)
 		instruction_pointer_set(regs, cur->ainsn.api.restore);
@@ -387,33 +368,23 @@ static void __kprobes kprobe_handler(struct pt_regs *regs)
 	 */
 }
 
-static int __kprobes
-kprobe_ss_hit(struct kprobe_ctlblk *kcb, unsigned long addr)
-{
-	if ((kcb->ss_ctx.ss_pending)
-	    && (kcb->ss_ctx.match_addr == addr)) {
-		clear_ss_context(kcb);	/* clear pending ss */
-		return DBG_HOOK_HANDLED;
-	}
-	/* not ours, kprobes should ignore it */
-	return DBG_HOOK_ERROR;
-}
-
 static int __kprobes
 kprobe_breakpoint_ss_handler(struct pt_regs *regs, unsigned int esr)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	int retval;
-
-	/* return error if this is not our step */
-	retval = kprobe_ss_hit(kcb, instruction_pointer(regs));
+	unsigned long addr = instruction_pointer(regs);
+	struct kprobe *cur = kprobe_running();
 
-	if (retval == DBG_HOOK_HANDLED) {
+	if (cur && (kcb->kprobe_status == KPROBE_HIT_SS)
+	    && ((unsigned long)&cur->ainsn.api.insn[1] == addr)) {
 		kprobes_restore_local_irqflag(kcb, regs);
-		post_kprobe_handler(kcb, regs);
+		post_kprobe_handler(cur, kcb, regs);
+
+		return DBG_HOOK_HANDLED;
 	}
 
-	return retval;
+	/* not ours, kprobes should ignore it */
+	return DBG_HOOK_ERROR;
 }
 
 static struct break_hook kprobes_break_ss_hook = {
-- 
2.53.0



