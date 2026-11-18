Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053561;
	b=TCBr8/0uHfXpp/thtTf3L0A1yfIIGiTGLsmrIeD2dnmOfUCT1s5Y2Edl+IlZ7WX86WNa
	 t2J3eSXlRf3S9mpN1K0Prar2VJdGkW24DnyQG6iUebFmFjBBQV9s6EKywyDvgkQrIKVzG
	 5l+CXAszhMqqV6y8yC7cPdSJtkOQ0rrUACt0+ZeJi42b939MiEFjDjEVwkc9TJ9xuxYvZ
	 t4G9/E+C9PXjE+ad0d1XZpF1dDAFFaop8U6yah36wy2RreomqrAjh8LY5ub3gcKSAUbvV
	 HWeFPlDcZiX6DzTNd1UX0bkQV3s3B05cZb06p/FKTKv2RT73+4j4lbf3gfTWUwUdaHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ay7mL5BZGJ1FCmQGA5deaObgyO+7gUKhfeHCK0JlU1g=;
	b=xWIAchQ9EaajyZbDyfMJWQQCA0bx02MOeYZQ8KmtpoaVr7/v7UnTdglS+IxKod/Hi1sZ
	 EOzke0sq35lj9k7l7CkeXCzlspgUiPvYIEDkmH/oDUnS8WzW5YBZp8Kt9Mm8LH8ChHxY/
	 rNqqRCQNkjY+C8M6ODqp1GyJizzMUkHpkG7hxaaKsVa9PTyT8+rpkzIYJinIdgwy7i5U2
	 xTmjxB+KSEkHNuc8fRFBTdNJ6wxCfpIvwLKwjmEUv8Vwwgh21amvWUMB7OM1FsshEVqAS
	 MT7CCxS+z+6ozZxQO2zTwykQONIJC4w47/qNZQf9LFBPDXISYyeIdBt/nzblFRwvTvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b8CjLr1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56AB606A325;
	Thu, 19 Nov 2026 01:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b8CjLr1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020F61F000C5;
	Thu, 19 Nov 2026 01:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053561;
	bh=ay7mL5BZGJ1FCmQGA5deaObgyO+7gUKhfeHCK0JlU1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8CjLr1g/A2vZYuYzFrwYcknZN8XeGbBDlZzqd2VZjijdGgr6zhHKQ5+PW5wFP+0J
	 g9BOw3sUIF/1wFavwXGSPhxIwH5N7KHUIzJH8hzjeE7RWVzo0bzrz/ftf151Sw9B5C
	 hhpPOmRcYq9QFyj+exxYzmsXmyVuQkpYONMJW7RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0936/2214] arm64: sdei: Preserve the interrupted contexts exception registers
Date: Wed, 18 Nov 2026 15:43:32 +0100
Message-ID: <20261118150049.808877698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

[ Upstream commit 58c1eb84e97701c583605ba2fd553b69afba2245 ]

An SDEI event is dispatched by firmware regardless of PSTATE.DAIF, so it
can interrupt the kernel where the exception registers are live:

 - exception entry, before kernel_entry has saved ELR_EL1/SPSR_EL1 and
   before the C handler has read ESR_EL1/FAR_EL1;
 - exception return, after kernel_exit has loaded ELR_EL1/SPSR_EL1 and
   before the ERET.

An IRQ or pseudo-NMI cannot arrive there with PSTATE.I set. Firmware
saves only x0-x17, PC and PSTATE around an SDEI event, so a synchronous
exception taken by the handler overwrites the interrupted context's
ELR, SPSR, ESR and FAR. do_sdei_event() only notices that ELR changed,
and warns.

The interrupted context then carries on with the handler's state. A
task interrupted on its way into the kernel can be sent SIGILL for the
handler's kernel data abort. A task interrupted on its way back to user
space ERETs to EL1, at the handler's fixup address, with user registers
loaded.

With SDEI delivering NMI backtraces, this happens in normal operation.
The handler runs show_regs(), which reads through possibly-NULL pointers
with the _nofault() accessors. print_worker_info() faults this way for a
kworker that is not running a work item, and a single sysrq-l warned
once per such kworker.

Save ELR, SPSR, ESR and FAR in __sdei_handler() before
irqentry_nmi_enter(), which can take an exception too, and restore them
after irqentry_nmi_exit().

Once they are restored, a nested exception is harmless if its handler is
safe in NMI context. That holds for EL1 data aborts on translation,
permission and access-flag faults, which never take the mmap lock in NMI
context, and for BRK. Warn once, with the syndrome, about any other
exception class.

Fixes: f5df26961853 ("arm64: kernel: Add arch-specific SDEI entry code and CPU masking")
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ kas: keep arm64_enter_nmi()/arm64_exit_nmi() in __sdei_handler();
  open-code the fault type check, no esr_fsc_is_*() helpers here ]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry-common.c | 21 +++++++++++-
 arch/arm64/kernel/sdei.c         | 55 ++++++++++++++++++++++++++------
 2 files changed, 66 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 0efe4ee319f45..0f52fbb5cfe6d 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -821,7 +821,7 @@ asmlinkage void noinstr handle_bad_stack(struct pt_regs *regs)
 asmlinkage noinstr unsigned long
 __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 {
-	unsigned long vbar;
+	unsigned long elr, spsr, esr, far, vbar;
 	unsigned long ret;
 
 	/*
@@ -846,6 +846,17 @@ __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 	else if (cpu_has_pan())
 		set_pstate_pan(0);
 
+	/*
+	 * Nothing saved the interrupted context's exception registers on the
+	 * way in, and it may be in the middle of exception entry or return
+	 * (SDEI ignores DAIF). Save them before anything can take an exception
+	 * and overwrite them.
+	 */
+	elr = read_sysreg(elr_el1);
+	spsr = read_sysreg(spsr_el1);
+	esr = read_sysreg(esr_el1);
+	far = read_sysreg(far_el1);
+
 	/*
 	 * With KPTI, VBAR_EL1 holds the trampoline vectors from the return to
 	 * EL0 until the next exception from EL0 maps the kernel. They only
@@ -865,6 +876,14 @@ __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 	ret = do_sdei_event(regs, arg, vbar);
 	arm64_exit_nmi(regs);
 
+	/*
+	 * Put them back unconditionally. An unchanged ELR does not rule out a
+	 * nested exception: one may have returned to the same address.
+	 */
+	write_sysreg(elr, elr_el1);
+	write_sysreg(spsr, spsr_el1);
+	write_sysreg(esr, esr_el1);
+	write_sysreg(far, far_el1);
 	write_sysreg(vbar, vbar_el1);
 
 	return ret;
diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
index c95a71156e99a..43bfe19e08a92 100644
--- a/arch/arm64/kernel/sdei.c
+++ b/arch/arm64/kernel/sdei.c
@@ -235,6 +235,33 @@ unsigned long sdei_arch_get_entry_point(int conduit)
 	return 0;
 }
 
+/*
+ * Exceptions an SDEI handler may take without harm once __sdei_handler() has
+ * restored the interrupted context's exception registers. Their handlers are
+ * safe in NMI context:
+ *  - EL1 data aborts on translation, permission and access-flag faults:
+ *    faulthandler_disabled() is true in NMI context, so do_page_fault() never
+ *    takes the mmap lock. This covers the _nofault() accessors used by the
+ *    generic dump_stack()/show_regs() code (e.g. print_worker_info()).
+ *  - BRK: kprobes, WARN/BUG, kCFI and UBSAN traps, all NMI-capable.
+ * Anything else taken at EL1 is fatal on its own, or unexpected here.
+ */
+static bool sdei_nested_exception_ok(unsigned long esr)
+{
+	unsigned long fsc_type = esr & ESR_ELx_FSC_TYPE;
+
+	switch (ESR_ELx_EC(esr)) {
+	case ESR_ELx_EC_DABT_CUR:
+		return fsc_type == ESR_ELx_FSC_FAULT ||
+		       fsc_type == ESR_ELx_FSC_PERM ||
+		       fsc_type == ESR_ELx_FSC_ACCESS;
+	case ESR_ELx_EC_BRK64:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * do_sdei_event() returns one of:
  *  SDEI_EV_HANDLED -  success, return to the interrupted context.
@@ -251,6 +278,7 @@ unsigned long __kprobes do_sdei_event(struct pt_regs *regs,
 	int i, err = 0;
 	int clobbered_registers = 4;
 	u64 elr = read_sysreg(elr_el1);
+	u64 nested_elr, nested_esr, nested_far;
 	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
 
 	if (arm64_kernel_unmapped_at_el0())
@@ -263,18 +291,27 @@ unsigned long __kprobes do_sdei_event(struct pt_regs *regs,
 	}
 
 	err = sdei_event_handler(regs, arg);
-	if (err)
-		return SDEI_EV_FAILED;
 
-	if (elr != read_sysreg(elr_el1)) {
-		/*
-		 * We took a synchronous exception from the SDEI handler.
-		 * This could deadlock, and if you interrupt KVM it will
-		 * hyp-panic instead.
-		 */
-		pr_warn("unsafe: exception during handler\n");
+	/*
+	 * A synchronous exception taken by the handler has overwritten the
+	 * exception registers; __sdei_handler() puts them back. Only the last
+	 * one's syndrome survives; report it if it is not one known to be
+	 * harmless.
+	 *
+	 * If the event interrupted a KVM world switch, VBAR points at the KVM
+	 * hyp vectors and any such exception is a hyp panic instead.
+	 */
+	nested_elr = read_sysreg(elr_el1);
+	nested_esr = read_sysreg(esr_el1);
+	nested_far = read_sysreg(far_el1);
+	if (nested_elr != elr && !sdei_nested_exception_ok(nested_esr)) {
+		pr_warn_once("unexpected exception during handler: ESR %#llx FAR %#llx near %pS\n",
+			     nested_esr, nested_far, (void *)nested_elr);
 	}
 
+	if (err)
+		return SDEI_EV_FAILED;
+
 	mode = regs->pstate & (PSR_MODE32_BIT | PSR_MODE_MASK);
 
 	/*
-- 
2.53.0



