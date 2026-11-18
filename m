Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059214;
	b=uaLo+S31wL062cwkAJ8k3Yc8rCna5fUrON1CJ+kDypoDP4ylusxnYvWoNS/B7Ot6qLRY
	 mhWhlN+i2PmKCYQDsaaQ9uI/kbnh2JHMabaTL5uX67n61OHpLUfSRc9wS4ZDyU9iKSP35
	 dVtg5cGdWez88SQKUcgn2HJghc0kxkCn/s/u/+Q2JAcdB6HOmTU+5vNYv9udbqF59zvpH
	 2sqtNuPGzKJ/w0ZREln+3//1awlBR69oIq7ZPSxTrWZElSzs2JbOMBkHd7tTcDSTzvEOg
	 27XOW+MwsI0SUnaeTFueUK1CRq8edRl1O6mXiqM/9bBbtceeMz12WedZnsFZGTZjP8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=peAnX3k7TGoRolz3sdS8aeg5t4OrJ37AjN1DOXWwFxc=;
	b=TrX/aiAsdcLOqr9oCBWL/QBEtsl5hEeHUH2tnALvdgM7RNULWMGU0z4yoc7eVVO0tgD6
	 dTZg8u9J9MdRUuqw43TEnaz26TtuImBKbxxP8jMvyYAHuwUN8aja1mSVQ/jhD4Nceu1ED
	 pnAT97M1VkhFF7/OhDcipskEgoPjKhqcK+usMqr4qInJ+tf3Y+jxTCjdJy8k4ovqEgR9j
	 /xXIxgIkipqjQ8gB8MBRgWDtbDjENdWI1x2D2pMB26eIYtzQU/jYNcnh2RgxoHr8kUamh
	 yIQp6RoEuDGGaTrMWVA1CAhpXS9IHXUgBZgtUBVZ3gJdxOkDqzyr/Lugkz0nhNZRLxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tvma0F4G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92756606A31C;
	Thu, 19 Nov 2026 03:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tvma0F4G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8481F000C4;
	Thu, 19 Nov 2026 03:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059214;
	bh=peAnX3k7TGoRolz3sdS8aeg5t4OrJ37AjN1DOXWwFxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvma0F4G/Hxc72o+f6gqczZk2V2UXswK2IdEyRZvplAaJ7BPmtNyfLBylRHcpZbBx
	 AxM9CLF9TAABJfXsaymyj3E3mgI5dWqUjsrYpIIULB4j+zWVhR0VWmPgrnSYh5mdQB
	 isXxpv9yCzxIcnC0XzuSnuUiREEsrCg4g3yPJp5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0763/1848] arm64: sdei: Run the event handler on the kernel vectors
Date: Wed, 18 Nov 2026 15:46:41 +0100
Message-ID: <20261118145948.380644553@linuxfoundation.org>
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

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

[ Upstream commit 9bf6ee7952c7ee151c30e0fffcfc61b58127c899 ]

With KPTI, VBAR_EL1 holds the trampoline vectors from the return to EL0
until the next exception from EL0 maps the kernel and installs the
kernel vectors. The trampoline vectors only handle exceptions from EL0;
their current-EL half is zero-filled.

An SDEI event is dispatched regardless of PSTATE.DAIF, so it lands there
whenever the CPU is in user space. The SDEI entry trampoline maps the
kernel but leaves VBAR_EL1 alone. An exception taken by the handler then
executes the zeros, takes an undefined instruction exception to the same
vector, and loops there forever. The event never completes and the CPU
is lost; RCU stall reports are the first sign of it.

RAS notifications land in user space whenever a task consumes the
error, and NMI backtraces land wherever the CPU happens to be. The GHES
handler takes no exception on its own, but any exception in the handler
path does it: a WARN, a kprobe hit, or a fault fixed up by a _nofault()
accessor.

Install the kernel vectors in __sdei_handler() when VBAR_EL1 holds the
trampoline vectors, and restore it before returning to firmware. The
switch covers irqentry_nmi_enter() and irqentry_nmi_exit() too, as Usama
Arif pointed out: their tracepoints and context tracking WARNs can take
an exception as well.

The IRQ-like resume into user space must still go through the
trampoline to map the kernel. do_sdei_event() takes the interrupted
VBAR_EL1 and keeps basing the resume address on it.

Fixes: 79e9aa59dc29 ("arm64: sdei: Add trampoline code for remapping the kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Breno Leitao <leitao@debian.org>
[catalin.marinas@arm.com: use raw_cpu_read() for this_cpu_vector]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ kas: 5.10 has __sdei_handler() in sdei.c around a static
  _sdei_handler(); pass vbar to that ]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/sdei.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
index 0083f5afa51db..36e4a95ae980b 100644
--- a/arch/arm64/kernel/sdei.c
+++ b/arch/arm64/kernel/sdei.c
@@ -17,6 +17,7 @@
 #include <asm/sections.h>
 #include <asm/stacktrace.h>
 #include <asm/sysreg.h>
+#include <asm/vectors.h>
 #include <asm/vmap_stack.h>
 
 unsigned long sdei_exit_mode;
@@ -162,16 +163,18 @@ unsigned long sdei_arch_get_entry_point(int conduit)
  *  SDEI_EV_HANDLED -  success, return to the interrupted context.
  *  SDEI_EV_FAILED  -  failure, return this error code to firmare.
  *  virtual-address -  success, return to this address.
+ *
+ * vbar is the interrupted context's VBAR_EL1, for the IRQ-like resume.
  */
 static __kprobes unsigned long _sdei_handler(struct pt_regs *regs,
-					     struct sdei_registered_event *arg)
+					     struct sdei_registered_event *arg,
+					     unsigned long vbar)
 {
 	u32 mode;
 	int i, err = 0;
 	int clobbered_registers = 4;
 	u64 elr = read_sysreg(elr_el1);
 	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
-	unsigned long vbar = read_sysreg(vbar_el1);
 
 	if (arm64_kernel_unmapped_at_el0())
 		clobbered_registers++;
@@ -230,13 +233,31 @@ static __kprobes unsigned long _sdei_handler(struct pt_regs *regs,
 asmlinkage noinstr unsigned long
 __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 {
+	unsigned long vbar;
 	unsigned long ret;
 
+	/*
+	 * With KPTI, VBAR_EL1 holds the trampoline vectors from the return to
+	 * EL0 until the next exception from EL0 maps the kernel. They only
+	 * handle exceptions from EL0: an exception taken here would run their
+	 * empty current-EL half and never come back. Switch to the kernel
+	 * vectors. The IRQ-like resume keeps using the interrupted VBAR, so it
+	 * still goes through the trampoline.
+	 */
+	vbar = read_sysreg(vbar_el1);
+	if (arm64_kernel_unmapped_at_el0() &&
+	    vbar == (unsigned long)raw_cpu_read(this_cpu_vector)) {
+		write_sysreg((unsigned long)vectors, vbar_el1);
+		isb();
+	}
+
 	arm64_enter_nmi(regs);
 
-	ret = _sdei_handler(regs, arg);
+	ret = _sdei_handler(regs, arg, vbar);
 
 	arm64_exit_nmi(regs);
 
+	write_sysreg(vbar, vbar_el1);
+
 	return ret;
 }
-- 
2.53.0



