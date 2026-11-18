Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035745;
	b=HNpheASTxIah4nIsKBWH0wsvyNVOSk63Mq3vTI5QFWHIrHGIEYbtnf2i03jfTAXDRUWc
	 LebbxmzE47WQHlnK4P+dtz4P0zTIgmsBw0xAiaMSIzcUde2bDe9ELW1LaPnvZT1pjldAB
	 Iv/6t0f4MlNLstxvoWCFbi33n9wAfekC3latWRUPF4pczqnY7d9YQZ8ZZQSP8rkmahyTH
	 eNHQVbSvAOjbbHRr0qs0JwlbqRru7eTP3tGdlMDqOm3arsXL4+JNJk9ad5ekbmnOh3uKh
	 Ti2lmGb+8Pn/nIRrJvdPEF/KlTmaFv5Mj8LaFXycZF8FaWZ4St+ZpztWapwPEGQBQvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8tLKrBH5RheiYHV+qgRfnvex8//ipnRpexE/42sjnHI=;
	b=WNqnW4AYleGk0x6GYJ0J9vznl5ZnnSfI3iLKUTDLqpyM+hE7SPqoEnos9hKMFcj+gww6
	 gC4d9GuIoJmve0cb+Vct3SOc+/tsbAF9MaMLq/dAZ7DEJADKINBo4Uo46qaLoB5aoVnzF
	 HK8qLlB954IRZ4OM2+UQds3sGngrpj8s0uMlLJgo0lgWiZ0q1POaZ91WjKy3W5Z6GL9LB
	 tJhlkRP9AoAKY8Svrn9Sskw6KdcR8O/TZRbyQZCfZtUH7NGMh1nbK47Ja52CvNpkWwP5c
	 RvIyRexqqk/Kovo+R+Hq9xzWlwcoi5TxYOx/fCMGljrmpOcLLwotRdxC4VqqhKl3SsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oaL9NaXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F77606A31C;
	Wed, 18 Nov 2026 21:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oaL9NaXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833221F000C4;
	Wed, 18 Nov 2026 21:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035745;
	bh=8tLKrBH5RheiYHV+qgRfnvex8//ipnRpexE/42sjnHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oaL9NaXzy1mNrPYSHObVoe8QKcUapcUl7DWKUdM5nbYazHggN2p2AKWReQ5DVF2c9
	 bNWj+P8iig4HUSs+AsIeR50or9vqPwDSdwx7o/TMQ3r2pE64rR8wjyyJFxr+5E7vBX
	 hWeWtsiVXk+ztm13WSGlQyUs7l6Q18Opf3gL8quY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Price <thesamprice@gmail.com>,
	Ramin Moussavi <ramin.moussavi@yacoub.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0812/3318] microblaze: preserve the MSR carry flags across signals
Date: Wed, 18 Nov 2026 15:23:54 +0100
Message-ID: <20261118150343.371557498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4956014a99379..6bbc16f98d5eb 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -33,6 +33,7 @@
 #include <linux/linkage.h>
 #include <linux/resume_user_mode.h>
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



