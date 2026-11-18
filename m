Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044217;
	b=cY5L+qVMyQqBisTmPPEc8GZVfhYBc/5xwv5HhszIJ377YZsUWMgFN5nmsnXrhf+m+7ND
	 8lde4QijjBPK7kkHbCAQxd+PYlRBEbmwoaN66FewnI4Ys+ZLf03FVPI2g0AIDFtggkJ3R
	 9ztVi1TqiOYT+jK2DUp8SJGLOT0F2beTdK2NHuHkhmJLBZv5HpAMQ55dcgD+RNBAexZ9a
	 SzBJCIwd6yEZmG3alkwtYIN82lDFoRRyMyFPaDmE3qJxDOo+YAYTxYeSUKcM/XTk9vUvF
	 xpsqWDrQs419pP5kDXe/S8RpHTz3cYE75EiKVIMPUG0WIQh0OhmoaHqEryvxk3b1N2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CIJwKjn/CjCBlnlzAzG8k3FvAE4VGpBtW742Au1tvvQ=;
	b=rZTU3QoFvXNsxggYdKYjUQfUXj1F0oZafRhpCSiLtkfl8e4Ke/UNYKq0jsRYjzNdSefW
	 Cc4FYpwY61dBbQI2/M/6xtChLqPOKqlzzUTN695UB9K0Q50lF8l0jsTv+9pFkxpX6KUWM
	 mJk3iWkQpTZawzl4ZN2x9h7ln3u9mdksrs6eB1dheDaK5s/zu186W0Fbb2DGg/PKWAmRZ
	 yjD3gRmP7Of4kgV3AErzJD7O8UL2VG0kkXHVKGeTp5fL9bgRZVTqzIWIkQ+2raCCsirM+
	 kr7jKsymwPwQ2ct7YmA+3DT6e391RpnE0yjLWdGOeAYHHlx2OO4h7Do2KGdqVP5CE7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0xrLHPp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0BE606A320;
	Wed, 18 Nov 2026 23:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0xrLHPp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EFC1F000C4;
	Wed, 18 Nov 2026 23:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044217;
	bh=CIJwKjn/CjCBlnlzAzG8k3FvAE4VGpBtW742Au1tvvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0xrLHPpJMz1GpeQwatjGOBN0Mdi3NM5yjDKropbTxeD0o45Bu6XdOjVkhvNKS+sf
	 YBg55kxP+E9Qgc3RTKlif2sgWkmIVjdcLgQ+wekXKMS0b2De3IbjnxXdsXZOU6QbhM
	 JGhtmy8azJfezjb4fGv3BBHcgd7IoFFXMMcEy1j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	EJ Campbell <ejc3@meta.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0489/2857] x86/kvm: Dont consume async #PF flags on a kernel #PF in NMI context
Date: Wed, 18 Nov 2026 15:25:23 +0100
Message-ID: <20261118150219.061680352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: EJ Campbell <ejc3@meta.com>

[ Upstream commit 81d99abe2bd81379abfb595e403bbbee6fbfc624 ]

An async #PF "page not present" event arrives through the #PF vector,
and its reason sits in the per-CPU apf_reason.flags until
__kvm_handle_async_pf() reads and clears it. If an NMI arrives after
the event is injected and before the #PF handler reads the flags, and
the NMI handler itself takes a #PF, that fault reads and clears the
flags belonging to the #PF it interrupted. It then finds interrupts
disabled in the NMI context it interrupted, and panics:

  Kernel panic - not syncing: Host injected async #PF in interrupt
disabled region
  Call Trace:
   <NMI>
   panic+0x52/0x60
   __kvm_handle_async_pf+0xb0/0xb0
   exc_page_fault+0x71/0xb0
   asm_exc_page_fault+0x27/0x30
  RIP: 0010:__get_user_nocheck_8+0x6/0x20
   perf_callchain_user+0x147/0x1a0
   get_perf_callchain+0x12d/0x1c0
   ...
   perf_event_nmi_handler+0x26/0x50
   exc_nmi+0xe8/0x110
  RIP: 0010:asm_exc_page_fault+0x0/0x30
   </NMI>

The last RIP line shows the NMI landing on the first instruction of
the #PF entry. perf with user call chains takes such a fault: the
sampling NMI walks the user stack with __get_user(), which faults when
a saved frame pointer is not a valid user address or the walk runs off
the top of the stack. The same window exists when KVM, running as an
L1 hypervisor with DELIVERY_AS_PF_VMEXIT, reads the flags itself after
a #PF VM-exit.

The NMI entry code saves and restores CR2 for this nesting, but not the
async #PF reason. Andy Lutomirski described the race, with perf as the
example, when async #PF delivery was reworked in 2020 [1]. Saving and
clearing the flags across the NMI, next to CR2, was discussed there but
not merged.

Since that rework, Linux has stopped setting KVM_ASYNC_PF_SEND_ALWAYS,
so the host delivers "page not present" only for user mode faults and
a kernel-mode fault in NMI context (including kernel-mode #MC and #DB)
cannot be an async page fault.  In that case, return without touching
the flags so that the interrupted handler finds them intact.

Tested on v7.3-rc5 in a 4-vCPU, 2 GiB guest restored from a snapshot
whose memory is served on demand through userfaultfd, so that reading
it back takes async #PFs, while every thread samples hardware cycles
with user call chains and points its frame pointer at an unmapped page.
Without this patch the guest panicked as above in 3 of 3 runs. With it,
the guest survived 3 of 3 runs of 60 seconds, and the host counted
148,441 to 153,334 kvm_async_pf_not_present events in the first 20
seconds of each. On 6.18.50 the results were the same: the guest
panicked without the patch and survived with it.

Link: https://lore.kernel.org/all/ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org/ [1]
Link: https://lore.kernel.org/all/20211126123145.2772-1-jiangshanlai@gmail.com/ [2]
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: EJ Campbell <ejc3@meta.com>
Link: https://patch.msgid.link/CADkxfh-uQTca_6jB1JPDq1MsKffF_UKGQR339oQSJNcoV75GNQ@mail.gmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kvm.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 014bfe7fb91cc..e109760eefd86 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -254,11 +254,39 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
 
+static __always_inline bool kvm_apf_reason_pending(void)
+{
+	return __this_cpu_read(async_pf_enabled) &&
+	       __this_cpu_read(apf_reason.flags);
+}
+
 noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 {
-	u32 flags = kvm_read_and_reset_apf_flags();
 	irqentry_state_t state;
+	u32 flags;
+
+	if (!kvm_apf_reason_pending())
+		return false;
+
+	/*
+	 * The guest does not enable KVM_ASYNC_PF_SEND_ALWAYS, so the host
+	 * delivers async #PF only to user mode (or as a #PF VM-exit, which KVM
+	 * reads itself). A #PF from kernel mode can still arrive between that
+	 * delivery and the read of the reason flags, inside an NMI that
+	 * interrupted it, for instance perf reading user memory for a call
+	 * chain. Such a fault is not async, so leave the async PF flags
+	 * untouched for the outer handler.  Outside NMI context, on the other
+	 * hand, async PF flags on a kernel-mode fault mean the host is broken.
+	 */
+	if (!user_mode(regs)) {
+		if (likely(in_nmi()))
+			return false;
+		state = irqentry_enter(regs);
+		instrumentation_begin();
+		panic("Host injected async #PF in kernel mode\n");
+	}
 
+	flags = kvm_read_and_reset_apf_flags();
 	if (!flags)
 		return false;
 
@@ -274,8 +302,6 @@ noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 		panic("Host injected async #PF in interrupt disabled region\n");
 
 	if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
-		if (unlikely(!(user_mode(regs))))
-			panic("Host injected async #PF in kernel mode\n");
 		/* Page is swapped out by the host. */
 		kvm_async_pf_task_wait_schedule(token);
 	} else {
-- 
2.53.0



