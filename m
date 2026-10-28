Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214284;
	b=Rk1QUSC0BP2BFHbzb9s4OEsAAOWaS6ohUoyikxVzbquH+ckqu1A79UFSAXEeQvx0huR/
	 QnR45gIQArDWXNpI8nrhMBRWiJZrirMXv2p0bQpqUWfbG8aBftVN33c7zdQEj+obpwjd6
	 1nDyoU56BCa+qIbcF2A0ThGYtRjUBQhd8hVo5rWRn/rgbsLoeMBpvi0Kv0xwAazU6qRIg
	 RQ5e84+MHWIb5hb7rZYEa4zgdAy4+goRGKDwd0+B56E0KHAkZIZH/msW3GK0mu3AEqzLz
	 CKR9NWhPhO10ashniqLCu+RP+Vw+9vEOJYGOCcOiyXQReamodUtk6dkUgo+7xjydyWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sItRB8bz7JKzwbZQTI6G/gRO6RyVNhf7u5juxz5Y+uI=;
	b=pSFBBa2vaXLlBnpOF0GviUktCQIcTnKFQ6vd8C6OeHho4zvM7qkXgUaVYRPfmp6016en
	 Vg9W8zVCvUvyFnk0EgEYtqN+sTyhebYp7j+IH8sKPydh+zh8DjStdTPGfbzytXaC6b2PU
	 smyQdwi3U6ug/vP92hAGjryiH8VnUIyaafaiINxMoDHIM1wkGbqM1ylFT7owmjT2cJjEn
	 VbKMVszZ3ttjRkdLLiEHkOTz/HPML6cBPq2sh1Iw/Ow8u9K8cLhRTqAjskdV9XO2mw3O0
	 1pjt/zAZeBRuPH2GoNRfJm5al64ywDbGEVdgxpOFrz8/eFHJ7zwo6qR/jOtrEztGWHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0tjmAAI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C836606A33A;
	Wed, 28 Oct 2026 19:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0tjmAAI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B041F01825;
	Wed, 28 Oct 2026 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214283;
	bh=sItRB8bz7JKzwbZQTI6G/gRO6RyVNhf7u5juxz5Y+uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0tjmAAIUvxrXG/OtsVorMMkZHEaaU4WdkNGOFey9IXoYQj9L7f9DT3vLW0EnATYu
	 YtiobMetmhC4HvCcY8dvJ25OCU3fZ8fiZwkQi9gOaFU9EKPI0QTkx36b0q6ylnaFlG
	 wobxrdanFLbrcfowUdTmcaS9tND6BjNWtSWXlvAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e74b94fe601ab9552d69@syzkaller.appspotmail.com,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Cyril Bur <cyrilbur@tenstorrent.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0802/1887] riscv: save the SR_SUM status over switches
Date: Wed, 28 Oct 2026 17:48:18 +0100
Message-ID: <20261028170517.680138566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 788aa64c01f1262310b4c1fb827a36df170d86ea ]

When threads/tasks are switched we need to ensure the old execution's
SR_SUM state is saved and the new thread has the old SR_SUM state
restored.

The issue was seen under heavy load especially with the syz-stress tool
running, with crashes as follows in schedule_tail:

Unable to handle kernel access to user memory without uaccess routines
at virtual address 000000002749f0d0
Oops [#1]
Modules linked in:
CPU: 1 PID: 4875 Comm: syz-executor.0 Not tainted
5.12.0-rc2-syzkaller-00467-g0d7588ab9ef9 #0
Hardware name: riscv-virtio,qemu (DT)
epc : schedule_tail+0x72/0xb2 kernel/sched/core.c:4264
 ra : task_pid_vnr include/linux/sched.h:1421 [inline]
 ra : schedule_tail+0x70/0xb2 kernel/sched/core.c:4264
epc : ffffffe00008c8b0 ra : ffffffe00008c8ae sp : ffffffe025d17ec0
 gp : ffffffe005d25378 tp : ffffffe00f0d0000 t0 : 0000000000000000
 t1 : 0000000000000001 t2 : 00000000000f4240 s0 : ffffffe025d17ee0
 s1 : 000000002749f0d0 a0 : 000000000000002a a1 : 0000000000000003
 a2 : 1ffffffc0cfac500 a3 : ffffffe0000c80cc a4 : 5ae9db91c19bbe00
 a5 : 0000000000000000 a6 : 0000000000f00000 a7 : ffffffe000082eba
 s2 : 0000000000040000 s3 : ffffffe00eef96c0 s4 : ffffffe022c77fe0
 s5 : 0000000000004000 s6 : ffffffe067d74e00 s7 : ffffffe067d74850
 s8 : ffffffe067d73e18 s9 : ffffffe067d74e00 s10: ffffffe00eef96e8
 s11: 000000ae6cdf8368 t3 : 5ae9db91c19bbe00 t4 : ffffffc4043cafb2
 t5 : ffffffc4043cafba t6 : 0000000000040000
status: 0000000000000120 badaddr: 000000002749f0d0 cause:
000000000000000f
Call Trace:
[<ffffffe00008c8b0>] schedule_tail+0x72/0xb2 kernel/sched/core.c:4264
[<ffffffe000005570>] ret_from_exception+0x0/0x14
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace b5f8f9231dc87dda ]---

The issue comes from the put_user() in schedule_tail
(kernel/sched/core.c) doing the following:

asmlinkage __visible void schedule_tail(struct task_struct *prev)
{
...
        if (current->set_child_tid)
                put_user(task_pid_vnr(current), current->set_child_tid);
...
}

the put_user() macro causes the code sequence to come out as follows:

1:	__enable_user_access()
2:	reg = task_pid_vnr(current);
3:	*current->set_child_tid = reg;
4:	__disable_user_access()

The problem is that we may have a sleeping function as argument which
could clear SR_SUM causing the panic above. This was fixed by
evaluating the argument of the put_user() macro outside the user-enabled
section in commit 285a76bb2cf5 ("riscv: evaluate put_user() arg before
enabling user access")"

In order for riscv to take advantage of unsafe_get/put_XXX() macros and
to avoid the same issue we had with put_user() and sleeping functions we
must ensure code flow can go through switch_to() from within a region of
code with SR_SUM enabled and come back with SR_SUM still enabled. This
patch addresses the problem allowing future work to enable full use of
unsafe_get/put_XXX() macros without needing to take a CSR bit flip cost
on every access. Make switch_to() save and restore SR_SUM.

Reported-by: syzbot+e74b94fe601ab9552d69@syzkaller.appspotmail.com
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Cyril Bur <cyrilbur@tenstorrent.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Deepak Gupta <debug@rivosinc.com>
Link: https://lore.kernel.org/r/20250410070526.3160847-2-cyrilbur@tenstorrent.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/processor.h | 1 +
 arch/riscv/kernel/asm-offsets.c    | 5 +++++
 arch/riscv/kernel/entry.S          | 9 +++++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 94a0590c69710..2a22ee93c54c9 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -39,6 +39,7 @@ struct thread_struct {
 	unsigned long s[12];	/* s[0]: frame pointer */
 	struct __riscv_d_ext_state fstate;
 	unsigned long bad_cause;
+	unsigned long status;
 };
 
 /* Whitelist the fstate from the task_struct for hardened usercopy */
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 9e6e35da69ce4..1c228973971f4 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -33,6 +33,7 @@ void asm_offsets(void)
 	OFFSET(TASK_THREAD_S10, task_struct, thread.s[10]);
 	OFFSET(TASK_THREAD_S11, task_struct, thread.s[11]);
 	OFFSET(TASK_TI_FLAGS, task_struct, thread_info.flags);
+	OFFSET(TASK_THREAD_STATUS, task_struct, thread.status);
 	OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_count);
 	OFFSET(TASK_TI_KERNEL_SP, task_struct, thread_info.kernel_sp);
 	OFFSET(TASK_TI_USER_SP, task_struct, thread_info.user_sp);
@@ -331,6 +332,10 @@ void asm_offsets(void)
 		  offsetof(struct task_struct, thread.s[11])
 		- offsetof(struct task_struct, thread.ra)
 	);
+	DEFINE(TASK_THREAD_STATUS_RA,
+		  offsetof(struct task_struct, thread.status)
+		- offsetof(struct task_struct, thread.ra)
+	);
 
 	DEFINE(TASK_THREAD_F0_F0,
 		  offsetof(struct task_struct, thread.fstate.f[0])
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index f6c3841df2f5a..2f8bc50c3b4ab 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -502,7 +502,16 @@ ENTRY(__switch_to)
 	REG_S s9,  TASK_THREAD_S9_RA(a3)
 	REG_S s10, TASK_THREAD_S10_RA(a3)
 	REG_S s11, TASK_THREAD_S11_RA(a3)
+
+	/* save the user space access flag */
+	csrr  s0, CSR_STATUS
+	REG_S s0, TASK_THREAD_STATUS_RA(a3)
+
 	/* Restore context from next->thread */
+	REG_L s0,  TASK_THREAD_STATUS_RA(a4)
+	li    s1,  SR_SUM
+	and   s0,  s0, s1
+	csrs  CSR_STATUS, s0
 	REG_L ra,  TASK_THREAD_RA_RA(a4)
 	REG_L sp,  TASK_THREAD_SP_RA(a4)
 	REG_L s0,  TASK_THREAD_S0_RA(a4)
-- 
2.53.0



