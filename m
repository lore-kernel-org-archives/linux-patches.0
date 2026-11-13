Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591276;
	b=VlHzi3kWqG3pLAsnJiFb2n+3lUC9dGSe2s+8Oc84c9KQZn0FIkyMO8USSijdpJLemnCu
	 4KolLbgKmoF90CFpsxcVTW7g8SuYfhZmMOSrQNNZpnFnvGLQm/z4rAiafqh4XRLsnQQmA
	 nVisXEAFH4g69HlZm6XQLP+gqCZYV/BQwV5JqKwNzq+9npwr282qWruaf+G8rcPdEo6Dw
	 oz1wbGAVn5sAcnJ64pYyc7yMsEABONXN5TTapZDKiFQny3MdnLsMdeK6UQY3gHMpbPYdq
	 pCQdyz8isOvU8x+pkvtv2Hwa9jSPDvxwHY8HbZqK69Z+amdEyfWSts5wvrNHe879+Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wh32q83FYCVTG5JHMhLqLCLAXMPyUYxbZklNPOHf3Q4=;
	b=r80Z33fAIjwOInk6+TYtqxHBYHBfAzAxMgpI53J7cM/PPAlzokVbt0hIzD8KDTJxgfkH
	 uZIlCeeg7v6Hoh5w3GiFnXyGkjzkuPcILzn94eKVKT/EwNfEeZetyAuh+Rqma6M2j4zTY
	 J2vSTOVsZMlL4euqya9z6tAQMyKTYy7dORdvQ+Dr/f1QDYOszhmhTmDNwen3O1X9gtMHR
	 h3qNEt8u6aBcBN0OAdHl8cNOzkbSNwKsu38h6xq5/VggNoznnI+hlXVCeUNEtnbDdYFK/
	 Jm1yaaWTwlPMsDxRoVSrE2hbzN6XGUI4CsLgecQFR9Xh7YxZm39PlRexKFDljJ2StDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XTGpPZj/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC7D6076FB4;
	Fri, 13 Nov 2026 17:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTGpPZj/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D191F000C4;
	Fri, 13 Nov 2026 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591276;
	bh=Wh32q83FYCVTG5JHMhLqLCLAXMPyUYxbZklNPOHf3Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTGpPZj/yXMhmfGftstVcJqRTecSMBPEy1/Ji2wXZom2+rQGl2/NYNyzWQ8gu2Cqf
	 roVCG4J+7ZyKshYraW5+eDZYa8tJt72NZIWBJPtOEd6ViZW6OyYMjwKH1EblFTbmZX
	 XqY1jZmVw3c11Y2E+ZzLinYycaX7RVy1SwcwZoss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 398/670] arm64: sdei: Run the event handler on the kernel vectors
Date: Fri, 13 Nov 2026 10:49:22 -0500
Message-ID: <20261113153825.242014678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ kas: keep arm64_enter_nmi()/arm64_exit_nmi() in __sdei_handler() ]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/sdei.h    |  3 ++-
 arch/arm64/kernel/entry-common.c | 21 ++++++++++++++++++++-
 arch/arm64/kernel/sdei.c         |  6 ++++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sdei.h b/arch/arm64/include/asm/sdei.h
index 484cb6972e99a..3b689185f3715 100644
--- a/arch/arm64/include/asm/sdei.h
+++ b/arch/arm64/include/asm/sdei.h
@@ -44,7 +44,8 @@ asmlinkage unsigned long __sdei_handler(struct pt_regs *regs,
 					struct sdei_registered_event *arg);
 
 unsigned long do_sdei_event(struct pt_regs *regs,
-			    struct sdei_registered_event *arg);
+			    struct sdei_registered_event *arg,
+			    unsigned long vbar);
 
 unsigned long sdei_arch_get_entry_point(int conduit);
 #define sdei_arch_get_entry_point(x)	sdei_arch_get_entry_point(x)
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index ea3876d99c2ec..8539e75a2b7ea 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -27,6 +27,7 @@
 #include <asm/stacktrace.h>
 #include <asm/sysreg.h>
 #include <asm/system_misc.h>
+#include <asm/vectors.h>
 
 /*
  * Handle IRQ/context state management when entering from kernel mode.
@@ -1087,6 +1088,7 @@ asmlinkage void noinstr __noreturn handle_bad_stack(struct pt_regs *regs)
 asmlinkage noinstr unsigned long
 __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 {
+	unsigned long vbar;
 	unsigned long ret;
 
 	/*
@@ -1111,10 +1113,27 @@ __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 	else if (cpu_has_pan())
 		set_pstate_pan(0);
 
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
-	ret = do_sdei_event(regs, arg);
+	ret = do_sdei_event(regs, arg, vbar);
 	arm64_exit_nmi(regs);
 
+	write_sysreg(vbar, vbar_el1);
+
 	return ret;
 }
 #endif /* CONFIG_ARM_SDE_INTERFACE */
diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
index 255d12f881c26..c867baa9f9f64 100644
--- a/arch/arm64/kernel/sdei.c
+++ b/arch/arm64/kernel/sdei.c
@@ -208,16 +208,18 @@ unsigned long sdei_arch_get_entry_point(int conduit)
  *  SDEI_EV_HANDLED -  success, return to the interrupted context.
  *  SDEI_EV_FAILED  -  failure, return this error code to firmare.
  *  virtual-address -  success, return to this address.
+ *
+ * vbar is the interrupted context's VBAR_EL1, for the IRQ-like resume.
  */
 unsigned long __kprobes do_sdei_event(struct pt_regs *regs,
-				      struct sdei_registered_event *arg)
+				      struct sdei_registered_event *arg,
+				      unsigned long vbar)
 {
 	u32 mode;
 	int i, err = 0;
 	int clobbered_registers = 4;
 	u64 elr = read_sysreg(elr_el1);
 	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
-	unsigned long vbar = read_sysreg(vbar_el1);
 
 	if (arm64_kernel_unmapped_at_el0())
 		clobbered_registers++;
-- 
2.53.0



