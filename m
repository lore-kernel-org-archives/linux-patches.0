Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590571;
	b=yjPR7wojFNu80IoUfLxzNe30JCEvVrIW7qm3Pu36KIz50Ix5Pau1KIGXLovo4n7Dxa+t
	 CqQWHgEJaKE6Ny4A1T9XweXFE70KxIb/ctzoLvgWpZPhJoZq4kJ/ay0JAMVh5HfJoR9On
	 8SOSSAE2736NIM0bZCqCP6oc+MxLWPhvjHY0oRZaCDkNhScC+84TfxnJICxioJuU5E92X
	 QxZUy3sL/JxZNU2J8nfaPPrl5M3n4lPN3rbSdOTa8KiF583zXkr+RFfvfMjHXoC3dL3Wg
	 57FBOXOX+WrxFXRyL4O4fuO+s3VR3ur5kSiXBiUDM7TUc2vq2EROoEdk+eMScFrzitA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ilCo3PmR/AIH7useeLTOS+GE2uOajLvbBJ0HvCiwPzI=;
	b=NWd9mpXNMNmU0YpX0QjRHaXwtn0WIcDQRHgBQLp1YHnlvGsC4ziCaDfkPVEtjDTVrFAC
	 jRlj5TS0gCwN2qOnbTZ4nRKQ62yrOzYRcJYIc6kwwVcASQ7JTN2dxa3OAoEGN0f9nne1z
	 bcAz5b1iM72gT3Tb8nSp1q5O0zFgmMTjl3k3zMYKkl0MDGJFSsa+vkkWB+/3e+fuKbr6H
	 V7LzYHqDdeFDEN2ikBRkHRHjgc03TaGGmfAThyqTWIb92EEPX4LqKbXir2qa9pqBd1AJn
	 NsQhqwL+TOMg7BS25otpcR5EAL3I9Bz7NSX5JMlvXZO4OxB5VCYJLE+O5AFLSsCy2BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvnDXsr7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74AF6073FC0;
	Fri, 13 Nov 2026 17:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvnDXsr7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A221F000C4;
	Fri, 13 Nov 2026 17:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590571;
	bh=ilCo3PmR/AIH7useeLTOS+GE2uOajLvbBJ0HvCiwPzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvnDXsr7wL/DTPx7Xgjrb5pL+tzpFP4dzIYb8kAcW3K79xnH4z49GNgryBre3RPtb
	 lRt8agBQtQ2RZ10fZ4Lr4aOFBAt+em8GHUPF2u0u2yySN9yB71yIuVDM1jb9Cs+Loo
	 G6uoU8Y3IYrWg1I2sk3BCYAOFidznPpn1Zoe2kqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 459/686] arm64: sdei: Preserve the interrupted contexts exception registers
Date: Fri, 13 Nov 2026 10:49:52 -0500
Message-ID: <20261113153836.416521447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry-common.c | 21 ++++++++++++-
 arch/arm64/kernel/sdei.c         | 53 ++++++++++++++++++++++++++------
 2 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 67ecb9fdb355e..4334bade249be 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -994,7 +994,7 @@ asmlinkage void noinstr __noreturn handle_bad_stack(struct pt_regs *regs)
 asmlinkage noinstr unsigned long
 __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 {
-	unsigned long vbar;
+	unsigned long elr, spsr, esr, far, vbar;
 	irqentry_state_t state;
 	unsigned long ret;
 
@@ -1020,6 +1020,17 @@ __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
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
@@ -1039,6 +1050,14 @@ __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 	ret = do_sdei_event(regs, arg, vbar);
 	irqentry_nmi_exit(regs, state);
 
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
index f77e30314fe13..839b0723f5dbc 100644
--- a/arch/arm64/kernel/sdei.c
+++ b/arch/arm64/kernel/sdei.c
@@ -199,6 +199,31 @@ unsigned long sdei_arch_get_entry_point(int conduit)
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
+	switch (ESR_ELx_EC(esr)) {
+	case ESR_ELx_EC_DABT_CUR:
+		return esr_fsc_is_translation_fault(esr) ||
+		       esr_fsc_is_permission_fault(esr) ||
+		       esr_fsc_is_access_flag_fault(esr);
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
@@ -215,6 +240,7 @@ unsigned long __kprobes do_sdei_event(struct pt_regs *regs,
 	int i, err = 0;
 	int clobbered_registers = 4;
 	u64 elr = read_sysreg(elr_el1);
+	u64 nested_elr, nested_esr, nested_far;
 	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
 
 	if (arm64_kernel_unmapped_at_el0())
@@ -227,18 +253,27 @@ unsigned long __kprobes do_sdei_event(struct pt_regs *regs,
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



