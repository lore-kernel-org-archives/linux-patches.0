Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019489;
	b=km1KLnbMpQwlTlYpC4EgNM3MZfa9SH30XQ14YHwmRQl0nAtlY/TFOJdcQGoc6ttxCok8
	 ly9mAPE3rOSKiPJ9+47DWkYnjipell/n9iN8gshoe850uIQgBpXNjdUm9PMU8rMy9y0Ow
	 wVda4cfb5p2C0/rUcGIsiA/+Mmu2GT33xnFCs4cjVyZXj5cc9cvNnO2p6SFxZzf/Kdye1
	 uOwbEpyGbzl4T8efFJjGefOfMAC7G2rOfT7qLtyyflE9pAyv78Xzm27+iqTjAme9sIyr4
	 2I3ws8+NdZiJ6mDSDeW3IJ0OeIxKEmfplYJPz86tdHpWoGfxti5eEaP6BGqCDfHJvSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=39AXncB2MXrfOACL69A+UXfMUdrpLHlnbnfJKEScvf0=;
	b=nzElb897iqly0o8scyDEAsLHyOiA6KwCYOOhWz9XKT5yTeld2+ClJvWq5M2ywulFeWsL
	 8tR6tYU66r56IHNKkJJcovRvDn2Dv3XKZ+5CQ1F5DkzVGLinh5jVhhw/Voo46/h8GRCNL
	 OM5oHRhv4lSWLEPzX+Yhwt/3qT8Z3bGJ23NZ1jhdKLOGd3h8uHPMnUB9n15y1/bIvuNHg
	 cAPADdEbYgBK3g/ieoblPH+fZ8cefWwRAaIKlB3FoD4LyN2nWFvUyeVSEv4cdcul/Xopd
	 gSIzJ6zAagOJvWqE+WKYKCGGTac2uEtzZ0IT1EBZzBEvxZxCkzIyg6PrX8UC/7qWEAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUmb2SGe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01E606A7C4;
	Wed, 18 Nov 2026 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUmb2SGe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8016E1F000C5;
	Wed, 18 Nov 2026 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019489;
	bh=39AXncB2MXrfOACL69A+UXfMUdrpLHlnbnfJKEScvf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUmb2SGekFKmLgXsfzdklavJnqRi4GRzzDM0M/IYZG5KDRrGXHI8kx2v/u5zWiu2c
	 UcqGSj4E95qOk4ZVaCeeztxlT3QDmLqHpysDUeGCZfMtq5IxBY39+rc/X6xb1et82c
	 0DJOEoZvzPOr+OwIawEDXG+kLkbrj7lGrMI2mjLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1612/2651] powerpc: fix NMI exit ordering: restore soft masks after irqentry_nmi_exit()
Date: Wed, 18 Nov 2026 15:47:32 +0100
Message-ID: <20261118150345.874661288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

[ Upstream commit 8fa763bc3ee9bd215476ab91ee480c649eaa4b29 ]

When running with CONFIG_PPC_IRQ_SOFT_MASK_DEBUG=y and LOCKDEP=y, an
Oops is triggered during NMI exit:

  [  202.258332] Oops: Exception in kernel mode, sig: 4 [#1]
  NIP [000000000003e178] 0x3e178
  LR  [c00000000003e174] arch_local_irq_restore+0x2a4/0x328
  TRAP: 0700  MSR: 0000000000081000 <ME>

The faulting instruction at NIP is a 'trap' (0fe00000) inside the
rfi_flush_fallback trampoline at a userspace-looking low address, reached
after a bad rfid caused by an incorrect SRR0 value.

Root cause:
DEFINE_INTERRUPT_HANDLER_NMI used to call arch_interrupt_nmi_exit_prepare()
*before* irqentry_nmi_exit(), giving this sequence:

  arch_interrupt_nmi_enter_prepare()   // saves irq_soft_mask, irq_happened
  irqentry_nmi_enter()                 // __nmi_enter() -> nmi_count++, in_nmi()=true
  ____func(regs)                       // NMI handler body
  arch_interrupt_nmi_exit_prepare()    // RESTORES irq_soft_mask=0 (IRQS_ENABLED)
                                       // RESTORES irq_happened with pending bits
  irqentry_nmi_exit()                  // instrumentation block runs here...
    trace_hardirqs_on_prepare()        //   ...with in_nmi()==true still
    lockdep_hardirqs_on_prepare()      //   ...and irq_soft_mask already restored to 0
      -> arch_local_irq_restore(0)     // mask=0 -> enable path entered
           WARN_ON_ONCE(in_nmi())      // FIRES: __nmi_exit() hasn't run yet
    __nmi_exit()                       // nmi_count-- (too late)

arch_interrupt_nmi_exit_prepare() restores irq_soft_mask to whatever
the interrupted thread had (IRQS_ENABLED / 0) and restores irq_happened
with any pending deferred-interrupt bits that were present when the NMI
fired.  This is correct and necessary before rfid back to the interrupted
context, but it must not happen until irqentry_nmi_exit() has fully
completed.

With irq_soft_mask=0 and pending bits in irq_happened, the
trace_hardirqs_on_prepare() call inside irqentry_nmi_exit()'s
instrumentation block reaches lockdep_hardirqs_on_prepare() which
calls __trace_hardirqs_on_caller(), which eventually calls
arch_local_irq_restore(0) (the IRQS_ENABLED / enable path).

arch_local_irq_restore() with mask=0 hits the CONFIG_PPC_IRQ_SOFT_MASK_DEBUG
guards at irq_64.c:217:

  WARN_ON_ONCE(in_nmi());   // TRUE: __nmi_exit() not yet called

The WARN_ON_ONCE fires a 'trap' instruction (tw 31,0,0 / 0fe00000) in
kernel mode with MSR_PR=0, MSR_IR=0 (real-mode).  The program check
handler (TRAP 0700) takes the sig:4 (SIGILL) path via do_program_check()
and calls die(), producing the Oops.

The RESTART_TABLE mechanism in arch_local_irq_restore then causes the
bad rfid that lands at the userspace-looking address visible in the NIP.

The bug is invisible with LOCKDEP=n because trace_hardirqs_on_prepare()
is a no-op when CONFIG_TRACE_IRQFLAGS is not set (TRACE_IRQFLAGS is
selected by PROVE_LOCKING which selects LOCKDEP).

Fix:
Move arch_interrupt_nmi_exit_prepare() to after the irqentry_nmi_exit()
block, so that:

  irqentry_nmi_exit()                 // __nmi_exit() -> nmi_count--, in_nmi()=false
  arch_interrupt_nmi_exit_prepare()   // now safe to restore soft mask state

The instrumentation inside irqentry_nmi_exit() now executes while
in_nmi() is still true (nmi_count not yet decremented), but
irq_soft_mask is still IRQS_ALL_DISABLED (NMI-entry value), so
arch_local_irq_restore() is never called with mask=0 from that path.
After __nmi_exit() returns, arch_interrupt_nmi_exit_prepare() restores
the pre-NMI soft mask and irq_happened, which is the correct state for
the rfid back to the interrupted context.

Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/d4cccba9-ce5c-424b-864c-2248fb0d99e6@linux.ibm.com/
Fixes: bee25f97ad24 ("powerpc: Enable GENERIC_ENTRY feature")
Signed-off-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20261003094509.3408190-1-mkchauras@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/interrupt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/interrupt.h b/arch/powerpc/include/asm/interrupt.h
index 355f6bbf9894d..c7d0e71eac839 100644
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -302,7 +302,6 @@ interrupt_handler long func(struct pt_regs *regs)			\
 		state = irqentry_nmi_enter(regs);			\
 	}								\
 	ret = ____##func (regs);					\
-	arch_interrupt_nmi_exit_prepare(regs, &nmi_state);		\
 	if (mfmsr() & MSR_DR) {						\
 		/* nmi_exit if relocations are on */			\
 		irqentry_nmi_exit(regs, state);				\
@@ -318,6 +317,7 @@ interrupt_handler long func(struct pt_regs *regs)			\
 	} else {							\
 		irqentry_nmi_exit(regs, state);				\
 	}								\
+	arch_interrupt_nmi_exit_prepare(regs, &nmi_state);		\
 									\
 	return ret;							\
 }									\
-- 
2.53.0



