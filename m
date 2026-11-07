Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061931;
	b=fxdasqKDx6cFl0IS7859RARXTg+dbEF6rsUzuXcOoJLS/THn0j3kGkUFzu7WrstjuhPA
	 F8+zCBHJI3cGVxAClObHpCOrTzFwcLASnq1bFuYuqzQjgFPFNW4AzwRN97ggqW/Gn9mW/
	 Bx/LBFi4RM/LTfEQVBJp3pt8yH301jL91mZMwNpIT4FUySdY5yC15+GvbbcWN4HxVr+K+
	 uhsB68LE++1u7GHOy0nKIuNqaKbf8DzIuQiI7aZk1/vVwLhQCxg8vVL1ZqnlqSyeqbzXV
	 Tb0umP5IQ0HNj6rt78TI6fcoQehKk4x6KQckg+EWiRiYaavbla7av9Xgty7VkugTAjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kC8hXWXPtnbLXT0zXk+Yxmo1ErEdwypNlYjrC88u8t0=;
	b=AEtRXNK/z2CdgFu/wFpX87wtjInBw6cgX2aXbr0FREyJVwiCglaBE3t8zeYhqUh6xQqr
	 2y4BVFiG8nISjGd2i28gWoRrdwFdNARWqsyzQpYqQDDrqd4MbLWpUQ3DEAog5Q/qvq7zF
	 uGh+wlKV34zEvQwXC546vpn0xqfu6qRB8zHHIWDJL/iXbACoGlR7wt1CsPAbahQbFqLxS
	 TPPupG72MrdlTNg5Y0+lzwD9iBpdsA/bwY6cD3r5JUxSKgChUlljCMOh8kpMRiZmNRZiR
	 hdbDjcFr6hGcm2wnVGEocd4wPqmBa8rIeGeEaJ6EllQhA8dXaFhg9D5BasigTJgAsWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zkTpOI89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24C9606A32D;
	Sat,  7 Nov 2026 14:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zkTpOI89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E5A1F0089F;
	Sat,  7 Nov 2026 14:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061930;
	bh=kC8hXWXPtnbLXT0zXk+Yxmo1ErEdwypNlYjrC88u8t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkTpOI89LytyRvirWhbbSGM3WR7AIWy0gyOy8+lAIy0zebBtSfuIhpuK1+Zj6qpwm
	 19g2ly19qCBFsOCNIVBYc6o8bvw95K6e/ugYf1SXCdNJfazlmANwSPRUTWuWSo8CpX
	 CnlXDwZklFkTYrCa+HwwPn/xjGx4pVeW9e/4SFF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramin Moussavi <ramin.moussavi@yacoub.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0908/1536] microblaze: dont clobber r3/r4 restored by rt_sigreturn
Date: Sat,  7 Nov 2026 08:48:44 -0500
Message-ID: <20261107135023.137712713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Ramin Moussavi <ramin.moussavi@yacoub.de>

[ Upstream commit da6829138a39fa3b9ec318ca54ff89af9d94d350 ]

ret_from_trap begins by storing the system call return values r3 and r4
back into the saved user pt_regs.  That is right for an ordinary system
call, but sys_rt_sigreturn() returns through the same path and has to be
transparent: restore_sigcontext() has just filled pt_regs from the signal
frame, and every register must reach userspace exactly as saved.  The two
stores overwrite the restored r3/r4 with whatever the C function left in
those registers.

Only r4 is actually lost, and that follows from how sigreturn is written
everywhere rather than from chance.  Architectures have sys_rt_sigreturn()
return the restored return-value register precisely so that this writeback
stores the restored value -- arm returns regs->ARM_r0, riscv and csky
regs->a0, arc regs->r0 -- and microblaze does the same through
*rval_p = regs->r3 in restore_sigcontext().  But the entry macros treat r3
and r4 as a pair, so ret_from_trap writes back two registers while a C
function has only one return value; nothing carries the restored r4.

Commit 791d0a169b91 ("microblaze: Fix sys_rt_sigreturn_wrapper") introduced
this in v2.6.37.  The old wrapper saved r3/r4 before the call and reloaded
them from pt_regs afterwards; switching brlid to brid removed the only
point where they were reloaded, and the stores have been overwriting them
ever since.

Fix it the way the sibling paths already behave: ret_from_irq and
ret_from_exc restore the full register set and do not perform these stores
at all.  Label the instruction after the stores ret_from_trap_no_rval and
enter there, biasing r15 by -8 so that the ABI return "rtsd r15, 8" lands
on it; naming the entry rather than computing ret_from_trap + 8 keeps it
correct if the number of stores ever changes.  Restoring the old
save/reload would work too, but costs four memory accesses and a branch to
undo damage that is better not done.

Any value the compiler keeps in r4 across a signal is lost.  The tightest
windows are the lwx/swx compare-and-swap retry loops gcc emits for atomics:
in uClibc-ng's libc.so alone, 50 of 364 such loops hold the address in r4.
This is not specific to one libc -- musl passes the address as "r"(p), and
glibc has no microblaze atomic-machine.h and so uses gcc's __atomic
builtins, which expand the same way.  Triggering it needs threads plus a
signal storm, which is why it survived 15 years.

Reproduced on qemu-system-microblazeel (petalogix-s3adsp1800) by running
the uClibc-ng NPTL test tst-eintr1 40 times against an unchanged userspace:
on v7.2 built with gcc 16.2.0, 23 of 40 iterations died with SIGSEGV
without this patch and 0 of 40 with it; on v7.0 built with gcc 12.5.0 the
same comparison gave 6 of 40 against 0 of 40.  The register dump of a
failing iteration shows the signature: a zero r4 and a fault at address 0,
while r3 came back intact.

Fixes: 791d0a169b91 ("microblaze: Fix sys_rt_sigreturn_wrapper")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ramin Moussavi <ramin.moussavi@yacoub.de>
Tested-by: Waldemar Brodkorb <wbx@openadk.org>
Link: https://patch.msgid.link/20260821151809.1233057-4-ramin.moussavi@yacoub.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/entry.S | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
index ad44341a5dbc7..efa4ab056fb5f 100644
--- a/arch/microblaze/kernel/entry.S
+++ b/arch/microblaze/kernel/entry.S
@@ -434,7 +434,13 @@ C_ENTRY(_user_exception):
 C_ENTRY(ret_from_trap):
 	swi	r3, r1, PT_R3
 	swi	r4, r1, PT_R4
-
+/*
+ * Entry point for returns that must not store r3/r4 back into pt_regs,
+ * i.e. rt_sigreturn, which has already restored them from the signal
+ * context.  Reached as "rtsd r15, 8" with r15 set to this label minus 8,
+ * so it stays correct if the number of stores above ever changes.
+ */
+ret_from_trap_no_rval:
 	lwi	r11, r1, PT_MODE;
 /* See if returning to kernel mode, if so, skip resched &c.  */
 	bnei	r11, 2f;
@@ -518,6 +524,15 @@ C_ENTRY(ret_from_kernel_thread):
 
 C_ENTRY(sys_rt_sigreturn_wrapper):
 	addik	r30, r0, 0		/* no restarts */
+	/*
+	 * rt_sigreturn restores the full register set from the signal
+	 * context, so it must skip the r3/r4 syscall-return stores at the
+	 * head of ret_from_trap which would otherwise overwrite the
+	 * just-restored r3/r4.  Every C function returns with "rtsd r15, 8"
+	 * -- the ABI return, where the 8 skips the caller's branch and its
+	 * delay slot -- so bias r15 by -8 to land on ret_from_trap_no_rval.
+	 */
+	addik	r15, r0, ret_from_trap_no_rval - 8
 	brid	sys_rt_sigreturn	/* Do real work */
 	addik	r5, r1, 0;		/* add user context as 1st arg */
 
-- 
2.53.0



