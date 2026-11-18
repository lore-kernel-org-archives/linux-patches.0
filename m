Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058192;
	b=uxRkdQrsbtJdBCpQrQKrOQYrhRJGOujvzcDsLdB4bMJn1yu0w9j8OtXrtligVoSiQ53a
	 Mw0qhOy9h4vweiPBPXrAL2yOuh9LLmtOnKhyTp/2ZnLKbvwJjKthY3/0gut26cRvErBbq
	 u511HlgSrmU+cjZ0s242SVqO7wNx1AIDJIGkA5+ttIT2ulTMA7fSGTegQy0xCAKX2sdmE
	 q9brAXFLIcOTBalzqquZ86mx8e4NnIV2+HEKGdWfOYaJAKYTn6w2oPFrVK/XCIGz0R501
	 7osdgyRvjgyu9SJ2Y35/I+RtLpil2LFT3MED+5skbBIPsrxHliI8FSfEqJ/JncH3GEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uwM8eF6pff0lBo8xWYOwllBplWlKKqT+MkT7ilcdOGk=;
	b=yoXtbsf8/TvToRS90av1aP6aP+N1JPUw1PXWHlGBv5krFyqMi3MnH1eIFIlc1v6pomfP
	 5ieKUNWlBG0+rK16i2LrFx3B8Csl/LXzB5B3FTR9va59DM+9yl2ExVe1rdfJ+sdQ7QDxO
	 kirjcEQ9fMhUI4cupuSgKpVDQ/VLR8vb018yPt5GvPsmRcGb2di/k9J7/vi5j645UaGJR
	 BcYidSgTWu2XHbqY/C4KUMjItcLRZmINwbvYFOYrLTaPSZ4dphjOqPojRdaE8Q/tZrt6b
	 OXszgim7wdwSlkN13z9+gnWszvEkpwQ4ql2IgNoexW+fvSC4bVJJXWyhENMZQnRgYiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJeL+eGq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D3A606A31C;
	Thu, 19 Nov 2026 03:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJeL+eGq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6419A1F000C4;
	Thu, 19 Nov 2026 03:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058191;
	bh=uwM8eF6pff0lBo8xWYOwllBplWlKKqT+MkT7ilcdOGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJeL+eGqh6SyfWrcWZz5XVlt5wvLB72BXEPcwh4iTxxK+8kgsKWGvV7sgHWCb+xKw
	 FsaPHUIcttgdA/PwWWghe+C/kFKVLeEz79ta2jBQWiLTlnZF3ECfItL9OjlmnBUQyh
	 5InyKA0eZV0mg92UliQ0xUMy4jXpFwRaxCn+Xe/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Price <thesamprice@gmail.com>,
	Ramin Moussavi <ramin.moussavi@yacoub.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0356/1848] microblaze: preserve the MSR carry flags across signals
Date: Wed, 18 Nov 2026 15:39:54 +0100
Message-ID: <20261118145927.825445754@linuxfoundation.org>
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

From: Sam Price <thesamprice@gmail.com>

[ Upstream commit ca35dd21a5f8343f47a23e4e5b3f0ffccf76a4ae ]

setup_sigcontext() and restore_sigcontext() copy r0-r31, pc, ear, esr and
fsr to and from the signal frame but never touch MSR.  The interrupted
MSR is therefore dropped from the signal context entirely: the handler's
ucontext does not expose it, a handler cannot adjust the resumed
arithmetic flags through uc_mcontext.regs.msr, and -- because
restore_sigcontext() leaves regs->msr as whatever the rt_sigreturn trap
left in it -- the interrupted context resumes with the carry produced by
the syscall entry path (_user_exception does "addi r14, r14, 4", which
writes carry), not with its own.

Other architectures round-trip the user-visible flags through the signal
frame (arm's cpsr, csky's carry, x86's eflags), so a handler can both read
and adjust the resumed flags; purely privileged status registers such as
riscv's sstatus are left out.  MicroBlaze should do the same for the
user-writable bits.

Concretely, MSR[C] (carry) is lost across signal delivery.  Code that
keeps a live carry across a point where a signal can be delivered -- for
example an lwx/swx compare-and-swap retry loop, between the swx and the
carry test -- resumes with the handler's carry and mis-evaluates the
result; the same failure class as the rt_sigreturn r3/r4 clobber, reached
through a different register.  Demonstrated under qemu-system-microblazeel
(machine petalogix-s3adsp1800): a handler that sets MSR_C in
uc_mcontext.regs.msr has no effect before this change (0 of 132 in-window
signals propagated) and takes effect after (130 of 132).

Save MSR in setup_sigcontext() so the handler's ucontext exposes it.  The
signal frame is user-writable, so restore_sigcontext() must not restore it
verbatim: MicroBlaze packs the user-writable carry (MSR_C, MSR_CC) and the
privileged control bits (MSR_UM, MSR_VM, MSR_IE, MSR_EE, ...) into the one
register, and a verbatim restore would let userspace alter privileged
return state -- rtbd derives the resumed mode from MSR_UMS/MSR_VMS.
Restore only MSR_C | MSR_CC from the frame and keep the rest from the
current regs->msr.  This mirrors x86's
restore_sigcontext(), which masks the restored EFLAGS to FIX_EFLAGS for
the same reason; arches whose status register is purely privileged (e.g.
riscv sstatus) simply do not restore it at all.

Comment on the exposed MSR reworded: it is not read-only,
restore_sigcontext() applies MSR_C|MSR_CC from the frame.  Author's
Signed-off-by kept; he agreed to comment and changelog cleanups.

Fixes: 2148daa9c45f ("microblaze_v8: Signal support")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Price <thesamprice@gmail.com>
Signed-off-by: Ramin Moussavi <ramin.moussavi@yacoub.de>
Tested-by: Waldemar Brodkorb <wbx@openadk.org>
Link: https://patch.msgid.link/20260821151809.1233057-6-ramin.moussavi@yacoub.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/signal.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 1a41f7266a000..ed01c384fff83 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -33,6 +33,7 @@
 #include <linux/linkage.h>
 #include <linux/tracehook.h>
 #include <asm/entry.h>
+#include <asm/registers.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
@@ -81,6 +82,22 @@ static int restore_sigcontext(struct pt_regs *regs,
 	COPY(pc);	COPY(ear);	COPY(esr);	COPY(fsr);
 #undef COPY
 
+	/*
+	 * The frame is user-writable, so restore only the user-writable
+	 * status flags (carry) and keep the kernel-controlled MSR bits
+	 * (UMS/VMS/IE/EE/...) from regs->msr: rtbd derives the resumed mode
+	 * from UMS/VMS, so a verbatim restore would hand userspace the
+	 * privileged return state.  Same idea as x86 masking the restored
+	 * EFLAGS to FIX_EFLAGS.
+	 */
+	{
+		unsigned long msr;
+
+		err |= __get_user(msr, &sc->regs.msr);
+		regs->msr = (regs->msr & ~(MSR_C | MSR_CC)) |
+			    (msr & (MSR_C | MSR_CC));
+	}
+
 	*rval_p = regs->r3;
 
 	return err;
@@ -140,6 +157,7 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
 	COPY(r26);	COPY(r27);	COPY(r28);	COPY(r29);
 	COPY(r30);	COPY(r31);
 	COPY(pc);	COPY(ear);	COPY(esr);	COPY(fsr);
+	COPY(msr);	/* restore_sigcontext() accepts only carry state */
 #undef COPY
 
 	err |= __put_user(mask, &sc->oldmask);
-- 
2.53.0



