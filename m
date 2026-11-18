Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032255;
	b=va/5I/IfdnBfYpC4J+HYSn0DJjGndOMfJA4RuNDsY6b3iojk83RyV4wIdrgSqVhe03cO
	 2GVoPfLQeSLMqOjEBjN7qEAQSZTatPEUYKrQv1+rFGBGcBgFpBJBq4z6XYJGGPCIsbEXt
	 ELjjB1A2bkNM4Vkna2TUbJ8HUfw6G8YIbNBNgTeiGrj+KkanKrpHM2B2bm8QDl22gbGmd
	 /03PiC1o9FxlfWpV/MIsVIFBL0s9nliF8hYn/kF9cATb5717W8/W9F2ieQ7iQhNBPaZv8
	 gV3pXfVQWWCob2iiTbKaBbwL6k/ZG5pmpJQtwg3Qe1PoYqJalyXxrQvYL9wkGqjLtSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1fTC9yd9k0Ewqpxr9mCXuMbMgXYiZ83x+kxNzYTgQoM=;
	b=ABYDUPqjtiOp2QUhjfBZ8ebrRokU5UCiAuR/ZAUZhf46mdsIiX6sTjo+lVzKycEQAhyt
	 RKX+e+hJpqsxs40QscWc9JYw51kggYj7sR6e7Kz4MleGKXDZE2tq5uFtUlop7T0cyN7F5
	 wpKumAoRA9gMxErK+oY2hINxzCM4d83jxLAH0c3xDS/r1IEzTT1xSe5sXlgqXxcMraqeE
	 2uyfMct9gWd7Kf6IVUIOQ2oK949ggtwv5idz1b05TKeFeH23RApqWkyXXag3KBAWrTJDE
	 XdQ//FZsdhBD4IpGhSh5/4aYHHAYabcQNkFwsK+fDVSwtYtc7QmkuUw2b17f/fLcUrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LO0ebdh1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE54606A31C;
	Wed, 18 Nov 2026 20:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LO0ebdh1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1471F000C4;
	Wed, 18 Nov 2026 20:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032255;
	bh=1fTC9yd9k0Ewqpxr9mCXuMbMgXYiZ83x+kxNzYTgQoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LO0ebdh13+1D13sQvn9LQLEPKRazVrA1wE388u02FkU6SY+GBBxFyy5hawC2V1dlQ
	 dAFpwQsSMJ81UqRQMRcy1IfnOeLj0kixq93mjEPwY+EmcEfCANKM2aOHy8XOdLCA3n
	 eTUiZlShtKuhrRUzBYI1qz8ZDSXPDq9ExMN4Nv10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1347/1756] bpf: Implement bpf_send_signal_task() kfunc
Date: Wed, 18 Nov 2026 15:57:54 +0100
Message-ID: <20261118150102.954954886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 6280cf718db0c557b5fe44e2d2e8ad8e832696a7 ]

Implement bpf_send_signal_task kfunc that is similar to
bpf_send_signal_thread and bpf_send_signal helpers  but can be used to
send signals to other threads and processes. It also supports sending a
cookie with the signal similar to sigqueue().

If the receiving process establishes a handler for the signal using the
SA_SIGINFO flag to sigaction(), then it can obtain this cookie via the
si_value field of the siginfo_t structure passed as the second argument
to the handler.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241016084136.10305-2-puranjay@kernel.org
Stable-dep-of: 2d1f101ee619 ("bpf: Claim the per-CPU send_signal irq_work before filling it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c     |  1 +
 kernel/trace/bpf_trace.c | 53 ++++++++++++++++++++++++++++++++++------
 2 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 617f1b8c36703..4197961bb9e1a 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3113,6 +3113,7 @@ BTF_ID_FLAGS(func, bpf_task_get_cgroup1, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 #endif
 BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_throw)
+BTF_ID_FLAGS(func, bpf_send_signal_task, KF_TRUSTED_ARGS)
 BTF_KFUNCS_END(generic_btf_ids)
 
 static const struct btf_kfunc_id_set generic_kfunc_set = {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index bac2db75dcd1d..741a8be780538 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -804,6 +804,8 @@ struct send_signal_irq_work {
 	struct task_struct *task;
 	u32 sig;
 	enum pid_type type;
+	bool has_siginfo;
+	struct kernel_siginfo info;
 };
 
 static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
@@ -811,27 +813,46 @@ static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
 static void do_bpf_send_signal(struct irq_work *entry)
 {
 	struct send_signal_irq_work *work;
+	struct kernel_siginfo *siginfo;
 
 	work = container_of(entry, struct send_signal_irq_work, irq_work);
-	group_send_sig_info(work->sig, SEND_SIG_PRIV, work->task, work->type);
+	siginfo = work->has_siginfo ? &work->info : SEND_SIG_PRIV;
+
+	group_send_sig_info(work->sig, siginfo, work->task, work->type);
 	put_task_struct(work->task);
 }
 
-static int bpf_send_signal_common(u32 sig, enum pid_type type)
+static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struct *task, u64 value)
 {
 	struct send_signal_irq_work *work = NULL;
+	struct kernel_siginfo info;
+	struct kernel_siginfo *siginfo;
+
+	if (!task) {
+		task = current;
+		siginfo = SEND_SIG_PRIV;
+	} else {
+		clear_siginfo(&info);
+		info.si_signo = sig;
+		info.si_errno = 0;
+		info.si_code = SI_KERNEL;
+		info.si_pid = 0;
+		info.si_uid = 0;
+		info.si_value.sival_ptr = (void *)(unsigned long)value;
+		siginfo = &info;
+	}
 
 	/* Similar to bpf_probe_write_user, task needs to be
 	 * in a sound condition and kernel memory access be
 	 * permitted in order to send signal to the current
 	 * task.
 	 */
-	if (unlikely(current->flags & (PF_KTHREAD | PF_EXITING)))
+	if (unlikely(task->flags & (PF_KTHREAD | PF_EXITING)))
 		return -EPERM;
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
 	/* Task should not be pid=1 to avoid kernel panic. */
-	if (unlikely(is_global_init(current)))
+	if (unlikely(is_global_init(task)))
 		return -EPERM;
 
 	if (preempt_count() != 0 || irqs_disabled()) {
@@ -849,19 +870,22 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		 * to the irq_work. The current task may change when queued
 		 * irq works get executed.
 		 */
-		work->task = get_task_struct(current);
+		work->task = get_task_struct(task);
+		work->has_siginfo = siginfo == &info;
+		if (work->has_siginfo)
+			copy_siginfo(&work->info, &info);
 		work->sig = sig;
 		work->type = type;
 		irq_work_queue(&work->irq_work);
 		return 0;
 	}
 
-	return group_send_sig_info(sig, SEND_SIG_PRIV, current, type);
+	return group_send_sig_info(sig, siginfo, task, type);
 }
 
 BPF_CALL_1(bpf_send_signal, u32, sig)
 {
-	return bpf_send_signal_common(sig, PIDTYPE_TGID);
+	return bpf_send_signal_common(sig, PIDTYPE_TGID, NULL, 0);
 }
 
 static const struct bpf_func_proto bpf_send_signal_proto = {
@@ -873,7 +897,7 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
 
 BPF_CALL_1(bpf_send_signal_thread, u32, sig)
 {
-	return bpf_send_signal_common(sig, PIDTYPE_PID);
+	return bpf_send_signal_common(sig, PIDTYPE_PID, NULL, 0);
 }
 
 static const struct bpf_func_proto bpf_send_signal_thread_proto = {
@@ -3518,3 +3542,16 @@ static int __init bpf_kprobe_multi_kfuncs_init(void)
 }
 
 late_initcall(bpf_kprobe_multi_kfuncs_init);
+
+__bpf_kfunc_start_defs();
+
+__bpf_kfunc int bpf_send_signal_task(struct task_struct *task, int sig, enum pid_type type,
+				     u64 value)
+{
+	if (type != PIDTYPE_PID && type != PIDTYPE_TGID)
+		return -EINVAL;
+
+	return bpf_send_signal_common(sig, type, task, value);
+}
+
+__bpf_kfunc_end_defs();
-- 
2.53.0



