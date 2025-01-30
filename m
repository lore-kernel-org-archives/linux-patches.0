Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DAA1E3DC8;
	Thu, 30 Jan 2025 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246829; cv=none; b=MPLyjZJXsiwmMH9kqQlyjIZowrESWwpAHZVOumY4GPPXlZ8HnhQM2ZOKYJm2KYQH4cPcrkHYtbMvdut4ROn/UZXHREdAJvqjY40ddvbCSR35iMZbC7lO1K6mYvC9QPD9B8D/0AS+kF0NRKcgMLJG3pQVAy9uG/cClOMuHyebXSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246829; c=relaxed/simple;
	bh=hapBAqyn4bvwHpvdTyQTpOOa6Au4jvPfN4YCEQ0wRYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdrP4+6yZOYR4XeLW5fkkYoJ4mwToX0WyznWmsiCF/fZwMvg1mw7H1yN++VlqXThhnEfpVPn72bcbOIDo5+WnRs+gnhAc2eZhoTFqzijxfraoiakvP9WtGmMdxydmp2hUVFI6CiHw1cVj8tvSIk15dbgj4yjHqDqd73iSYM9cAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDXZ26Mq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDXZ26Mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ADDC4CED2;
	Thu, 30 Jan 2025 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246829;
	bh=hapBAqyn4bvwHpvdTyQTpOOa6Au4jvPfN4YCEQ0wRYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDXZ26Mqjx7WBajI/r4VZTP52Ud5PJBxzcGX7RB28/NsUl9sV6xdQyZqujqeBhLYO
	 82NXsIa/d43WBtdgQX+kuGDqQyqHwHCVeETdbMhN5gPCRbOQgYQNZomvh/b7bTLKMM
	 OxfHrSZ3VOO+uOQqjCP/wWPpFmbsB0LI28KukXlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olof Johansson <olof@lixom.net>,
	Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH 5.4 52/91] riscv: prefix IRQ_ macro names with an RV_ namespace
Date: Thu, 30 Jan 2025 15:01:11 +0100
Message-ID: <20250130140135.751296849@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Walmsley <paul.walmsley@sifive.com>

commit 2f3035da4019780250658d1ffe486bc324e04805 upstream.

"IRQ_TIMER", used in the arch/riscv CSR header file, is a sufficiently
generic macro name that it's used by several source files across the
Linux code base.  Some of these other files ultimately include the
arch/riscv CSR include file, causing collisions.  Fix by prefixing the
RISC-V csr.h IRQ_ macro names with an RV_ prefix.

Fixes: a4c3733d32a72 ("riscv: abstract out CSR names for supervisor vs machine mode")
Reported-by: Olof Johansson <olof@lixom.net>
Acked-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/csr.h      |   18 +++++++++---------
 arch/riscv/kernel/irq.c           |    6 +++---
 drivers/irqchip/irq-sifive-plic.c |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -114,9 +114,9 @@
 # define SR_PIE		SR_MPIE
 # define SR_PP		SR_MPP
 
-# define IRQ_SOFT	IRQ_M_SOFT
-# define IRQ_TIMER	IRQ_M_TIMER
-# define IRQ_EXT	IRQ_M_EXT
+# define RV_IRQ_SOFT		IRQ_M_SOFT
+# define RV_IRQ_TIMER	IRQ_M_TIMER
+# define RV_IRQ_EXT		IRQ_M_EXT
 #else /* CONFIG_RISCV_M_MODE */
 # define CSR_STATUS	CSR_SSTATUS
 # define CSR_IE		CSR_SIE
@@ -131,15 +131,15 @@
 # define SR_PIE		SR_SPIE
 # define SR_PP		SR_SPP
 
-# define IRQ_SOFT	IRQ_S_SOFT
-# define IRQ_TIMER	IRQ_S_TIMER
-# define IRQ_EXT	IRQ_S_EXT
+# define RV_IRQ_SOFT		IRQ_S_SOFT
+# define RV_IRQ_TIMER	IRQ_S_TIMER
+# define RV_IRQ_EXT		IRQ_S_EXT
 #endif /* CONFIG_RISCV_M_MODE */
 
 /* IE/IP (Supervisor/Machine Interrupt Enable/Pending) flags */
-#define IE_SIE		(_AC(0x1, UL) << IRQ_SOFT)
-#define IE_TIE		(_AC(0x1, UL) << IRQ_TIMER)
-#define IE_EIE		(_AC(0x1, UL) << IRQ_EXT)
+#define IE_SIE		(_AC(0x1, UL) << RV_IRQ_SOFT)
+#define IE_TIE		(_AC(0x1, UL) << RV_IRQ_TIMER)
+#define IE_EIE		(_AC(0x1, UL) << RV_IRQ_EXT)
 
 #ifndef __ASSEMBLY__
 
--- a/arch/riscv/kernel/irq.c
+++ b/arch/riscv/kernel/irq.c
@@ -23,11 +23,11 @@ asmlinkage __visible void __irq_entry do
 
 	irq_enter();
 	switch (regs->cause & ~CAUSE_IRQ_FLAG) {
-	case IRQ_TIMER:
+	case RV_IRQ_TIMER:
 		riscv_timer_interrupt();
 		break;
 #ifdef CONFIG_SMP
-	case IRQ_SOFT:
+	case RV_IRQ_SOFT:
 		/*
 		 * We only use software interrupts to pass IPIs, so if a non-SMP
 		 * system gets one, then we don't know what to do.
@@ -35,7 +35,7 @@ asmlinkage __visible void __irq_entry do
 		riscv_software_interrupt();
 		break;
 #endif
-	case IRQ_EXT:
+	case RV_IRQ_EXT:
 		handle_arch_irq(regs);
 		break;
 	default:
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -262,7 +262,7 @@ static int __init plic_init(struct devic
 		 * Skip contexts other than external interrupts for our
 		 * privilege level.
 		 */
-		if (parent.args[0] != IRQ_EXT)
+		if (parent.args[0] != RV_IRQ_EXT)
 			continue;
 
 		hartid = plic_find_hart_id(parent.np);


