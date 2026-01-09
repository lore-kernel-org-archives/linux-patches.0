Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0482F7AD0;
	Fri,  9 Jan 2026 12:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962304; cv=none; b=KH14AKfhHoWyS5McNndAp1q4nUQ2aGZCTJbolhWbC63lzdQGuwXpkhTg8IQMYF5cUYeHUmRWvZggsCNQ0aoPBZeX3NkLDRwE5hTZHSpko4HXCY4EgpO/XnMfzm5/n2IZEgeM52SVJ28YpIGI62lEKuSqjKTB4NByaw8HdPeFP3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962304; c=relaxed/simple;
	bh=W09lXEHcaJFScgod2XA4vgVOTKzCXZShlehL+9CmZDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho2Q1YawURHwPpQpEGzfm18XixEkBcdRP7f/tr1mFCnavNOL2cSVqimeCxwwvD0aw0m54wxuJ8h84zuBMuf56CkDn5ENSzsmgBYLoyzQn1U4zYAgpxtB2m0FCVlQj+kxPPIKYrFEWPx6ekYrcOfLOObGchnkmFlBqLB/c2IYCJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QW3x0qiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QW3x0qiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DE1C4CEF1;
	Fri,  9 Jan 2026 12:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962304;
	bh=W09lXEHcaJFScgod2XA4vgVOTKzCXZShlehL+9CmZDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QW3x0qivcOhvYbGHePcect4ss+LhJW98FdUACpXP0Dc2BBP/avUmj7hHxGMmh0pou
	 fX0FbRRwj+eb2JZIhjXB1RwV98VaswHYqQ6t7WBpGafMRLOUAOVb42lJTI0draYupj
	 Cub+2eMZ7ITTGs+a/1oRDv1vL22nTjxYAky8OH/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Gerst <brgerst@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 275/634] x86/xen: Move Xen upcall handler
Date: Fri,  9 Jan 2026 12:39:13 +0100
Message-ID: <20260109112127.880637612@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Gerst <brgerst@gmail.com>

[ Upstream commit 1ab7b5ed44ba9bce581e225f40219b793bc779d6 ]

Move the upcall handler to Xen-specific files.

No functional changes.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20250314151220.862768-2-brgerst@gmail.com
Stable-dep-of: e5aff444e3a7 ("x86/xen: Fix sparse warning in enlighten_pv.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/common.c     | 72 -------------------------------------
 arch/x86/xen/enlighten_pv.c | 69 +++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 72 deletions(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index e72dac092245..3c88bdf96e7a 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -20,11 +20,6 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 
-#ifdef CONFIG_XEN_PV
-#include <xen/xen-ops.h>
-#include <xen/events.h>
-#endif
-
 #include <asm/apic.h>
 #include <asm/desc.h>
 #include <asm/traps.h>
@@ -346,70 +341,3 @@ SYSCALL_DEFINE0(ni_syscall)
 {
 	return -ENOSYS;
 }
-
-#ifdef CONFIG_XEN_PV
-#ifndef CONFIG_PREEMPTION
-/*
- * Some hypercalls issued by the toolstack can take many 10s of
- * seconds. Allow tasks running hypercalls via the privcmd driver to
- * be voluntarily preempted even if full kernel preemption is
- * disabled.
- *
- * Such preemptible hypercalls are bracketed by
- * xen_preemptible_hcall_begin() and xen_preemptible_hcall_end()
- * calls.
- */
-DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
-EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
-
-/*
- * In case of scheduling the flag must be cleared and restored after
- * returning from schedule as the task might move to a different CPU.
- */
-static __always_inline bool get_and_clear_inhcall(void)
-{
-	bool inhcall = __this_cpu_read(xen_in_preemptible_hcall);
-
-	__this_cpu_write(xen_in_preemptible_hcall, false);
-	return inhcall;
-}
-
-static __always_inline void restore_inhcall(bool inhcall)
-{
-	__this_cpu_write(xen_in_preemptible_hcall, inhcall);
-}
-#else
-static __always_inline bool get_and_clear_inhcall(void) { return false; }
-static __always_inline void restore_inhcall(bool inhcall) { }
-#endif
-
-static void __xen_pv_evtchn_do_upcall(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	inc_irq_stat(irq_hv_callback_count);
-
-	xen_evtchn_do_upcall();
-
-	set_irq_regs(old_regs);
-}
-
-__visible noinstr void xen_pv_evtchn_do_upcall(struct pt_regs *regs)
-{
-	irqentry_state_t state = irqentry_enter(regs);
-	bool inhcall;
-
-	instrumentation_begin();
-	run_sysvec_on_irqstack_cond(__xen_pv_evtchn_do_upcall, regs);
-
-	inhcall = get_and_clear_inhcall();
-	if (inhcall && !WARN_ON_ONCE(state.exit_rcu)) {
-		irqentry_exit_cond_resched();
-		instrumentation_end();
-		restore_inhcall(inhcall);
-	} else {
-		instrumentation_end();
-		irqentry_exit(regs, state);
-	}
-}
-#endif /* CONFIG_XEN_PV */
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index ee8f452cc58b..9a54049744bf 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -71,6 +71,7 @@
 #include <asm/mwait.h>
 #include <asm/pci_x86.h>
 #include <asm/cpu.h>
+#include <asm/irq_stack.h>
 #ifdef CONFIG_X86_IOPL_IOPERM
 #include <asm/io_bitmap.h>
 #endif
@@ -96,6 +97,44 @@ void *xen_initial_gdt;
 static int xen_cpu_up_prepare_pv(unsigned int cpu);
 static int xen_cpu_dead_pv(unsigned int cpu);
 
+#ifndef CONFIG_PREEMPTION
+/*
+ * Some hypercalls issued by the toolstack can take many 10s of
+ * seconds. Allow tasks running hypercalls via the privcmd driver to
+ * be voluntarily preempted even if full kernel preemption is
+ * disabled.
+ *
+ * Such preemptible hypercalls are bracketed by
+ * xen_preemptible_hcall_begin() and xen_preemptible_hcall_end()
+ * calls.
+ */
+DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
+EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
+
+/*
+ * In case of scheduling the flag must be cleared and restored after
+ * returning from schedule as the task might move to a different CPU.
+ */
+static __always_inline bool get_and_clear_inhcall(void)
+{
+	bool inhcall = __this_cpu_read(xen_in_preemptible_hcall);
+
+	__this_cpu_write(xen_in_preemptible_hcall, false);
+	return inhcall;
+}
+
+static __always_inline void restore_inhcall(bool inhcall)
+{
+	__this_cpu_write(xen_in_preemptible_hcall, inhcall);
+}
+
+#else
+
+static __always_inline bool get_and_clear_inhcall(void) { return false; }
+static __always_inline void restore_inhcall(bool inhcall) { }
+
+#endif
+
 struct tls_descs {
 	struct desc_struct desc[3];
 };
@@ -597,6 +636,36 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_machine_check)
 }
 #endif
 
+static void __xen_pv_evtchn_do_upcall(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	inc_irq_stat(irq_hv_callback_count);
+
+	xen_evtchn_do_upcall();
+
+	set_irq_regs(old_regs);
+}
+
+__visible noinstr void xen_pv_evtchn_do_upcall(struct pt_regs *regs)
+{
+	irqentry_state_t state = irqentry_enter(regs);
+	bool inhcall;
+
+	instrumentation_begin();
+	run_sysvec_on_irqstack_cond(__xen_pv_evtchn_do_upcall, regs);
+
+	inhcall = get_and_clear_inhcall();
+	if (inhcall && !WARN_ON_ONCE(state.exit_rcu)) {
+		irqentry_exit_cond_resched();
+		instrumentation_end();
+		restore_inhcall(inhcall);
+	} else {
+		instrumentation_end();
+		irqentry_exit(regs, state);
+	}
+}
+
 struct trap_array_entry {
 	void (*orig)(void);
 	void (*xen)(void);
-- 
2.51.0



