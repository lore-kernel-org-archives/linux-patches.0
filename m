Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216540;
	b=BICorx+/vWZnRs1N6qJcJdaWhCZ5HMYm7Laz6IdsEB4yKTP3Fq4hFXDZftP/6azvaZlQ
	 N//AESfKFguWGTg4ezz7JfRtXjzvfbMkk10ciOGtBKgBXq3cOy/EFQ4qAuw+mmLig1joC
	 rurK1nrR/WK35u/C0oCPmhnh2AYcs28ldZqVsdioe9+81/7diIXCC2AJ1WPeIalaqNm0L
	 8/Z2WAgauysnxb3Umblm6/TImBK5rzBJHO5ZP9fddCS9W+FO8F16pAku9ybibww+385HU
	 JOUvm6lo4DCBBSePPI9q3IqiDY2IWw/rQ1kaB6Bt3ak27JUtOvIhqZIAEjuVE2XTPtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ylBSRpTwEUrRXe8WzP2E41E3gTczIy+930Ov5Dk5u3U=;
	b=Ko2ysF1vJEgBBnrVi/wxrygWkVtOCWMMKjSXMcqXO220OqIBJIx2dWCTgOenGWV6Y80d
	 +0QuLU7XHsuBFhpkbGj1si5MMFg91G/JFMwpt7zuaLAF9/J1NnSwpuCDTnldCog19KCbH
	 iK8Lvq9YjQX+po5hoO/R6q8yL8tq+MzV4iivWVBa7gFCSOQn+N0gObx+55y0EtLdUuUTH
	 fV7LdT6Sp9BUvwPgXQmr01kZ48+Kef9OK5Ot8LMTkWNIU/Z8/mymTiqYvS6L/Vqm7D3DF
	 AdFmsQ2IB9Uk4YHzvVmm8YXUAY0AARonyR4bx+SpDShXybO4zZXQxrCvzgS0twc850w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XOzXNEWK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6164F606A31D;
	Wed, 28 Oct 2026 19:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XOzXNEWK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C481F01828;
	Wed, 28 Oct 2026 19:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216540;
	bh=ylBSRpTwEUrRXe8WzP2E41E3gTczIy+930Ov5Dk5u3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOzXNEWKeP5hdGAtYCKsZKmtigxDVEoo/iuFY2QW3/a/FfAjAM9y+RC9olfKBdxlt
	 z/dBBYVwkDDGkdiyRWJ45HpLL00pMRA7r+i9qPcHN7VMWkRTcq9bH0mB1DvP/U0aG1
	 vdKpn/O63hr4zrgTSNYp69ytl12pJACyg5ycFDPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1590/1887] arm64: ptrace: Keep orig_x0 in-sync with x0 on syscall entry
Date: Wed, 28 Oct 2026 18:01:26 +0100
Message-ID: <20261028170535.654595997@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit 88b839ce497ccb1ff92f7ae742c78dd2937ba572 ]

Commit e057b9477232 ("arm64: syscall: Ensure saved x0 is kept in-sync
with tracer updates") attempted to resolve a long-standing issue with
syscall entry tracing, where a tracer is able to manipulate the first
syscall argument without being subjected to seccomp or audit checking.

Unfortunately, that fix was incomplete [1], as it failed to update
'orig_x0' between a tracer updating x0 during a seccomp ptrace exit
(SECCOMP_RET_TRACE) and the seccomp filter being re-evaluated.

Rather than add hooks to the core seccomp code, instead move the
synchronisation code into the ptrace GPR and syscall setting code so
that 'orig_x0' is kept up to date with x0 whenever we're stopped on the
syscall entry path.

Cc: Kees Cook <kees@kernel.org>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://sashiko.dev/#/patchset/20260716120640.6590-1-will@kernel.org [1]
Reported-by: Yiqi Sun <sunyiqixm@gmail.com>
Link: https://lore.kernel.org/all/20260529065444.1336608-1-sunyiqixm@gmail.com/
Fixes: e057b9477232 ("arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates")
Fixes: a5cd110cb836 ("arm64/ptrace: run seccomp after ptrace")
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 50 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 3025d14c253de..6fcbde1ed943f 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -564,6 +564,42 @@ static int gpr_get(struct task_struct *target,
 	return membuf_write(&to, uregs, sizeof(*uregs));
 }
 
+static void update_syscall_orig_x0_after_ptrace(struct task_struct *target)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	struct kernel_siginfo *info = target->last_siginfo;
+
+	/*
+	 * Skip the update for NO_SYSCALL (set either by the user or the
+	 * tracer), as regs[0] holds the return value (see the comment in
+	 * el0_svc_common()) and can be unwound using syscall_rollback().
+	 */
+	if (regs->syscallno == NO_SYSCALL)
+		return;
+
+	/* We should only be called when target is in a ptrace stop */
+	if (WARN_ON_ONCE(!info))
+		return;
+
+	/*
+	 * For compat tasks, orig_r0 is provided directly through GPR index
+	 * 17.
+	 */
+	if (is_compat_thread(task_thread_info(target)))
+		return;
+
+	/*
+	 * Don't update orig_x0 for a syscall-exit-stop, as x0 now contains the
+	 * return value of the system call.
+	 */
+	if ((info->si_code & ~0x80) == SIGTRAP &&
+	    target->ptrace_message == PTRACE_EVENTMSG_SYSCALL_EXIT) {
+		return;
+	}
+
+	regs->orig_x0 = regs->regs[0];
+}
+
 static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count,
 		   const void *kbuf, const void __user *ubuf)
@@ -579,6 +615,14 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 		return -EINVAL;
 
 	task_pt_regs(target)->user_regs = newregs;
+
+	/*
+	 * Keep orig_x0 authoritative so that seccomp (via
+	 * syscall_get_arguments()), audit and the restart path all see the same
+	 * first argument the syscall is dispatched with, even if it has been
+	 * updated by a tracer.
+	 */
+	update_syscall_orig_x0_after_ptrace(target);
 	return 0;
 }
 
@@ -722,6 +766,12 @@ static int system_call_set(struct task_struct *target,
 		return ret;
 
 	task_pt_regs(target)->syscallno = syscallno;
+
+	/*
+	 * Re-sync orig_x0 in case the syscall number has been changed
+	 * from NO_SYSCALL.
+	 */
+	update_syscall_orig_x0_after_ptrace(target);
 	return ret;
 }
 
-- 
2.53.0



