Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831610;
	b=LF5NBcx1le2b4Y+f7wzo9QK7y5OIOcy1Qyp9NO0U1OYHfpoSmVXQMjenzInxqziCGSiR
	 y7lRXBeldVyB/JdebUmXzqXBRFw5H/FydBwsEhDT83SMRqydBhNUQstBml0QINs8KdQ1S
	 iQCUS+Ryle9VSEELz8EASqTiacSYSqp/YJ+YSGVUztDiHkq2nqUEm9qC/DscM9NVIXKPe
	 pKZzt9Yl7WRNdwjezM2D7kAGfjle03NdWIJvynzttmvXNoEdTJ+KlNbwpvI2NgGP3B4WM
	 +pb5FZa/gio90CNXdiYBRXSZny/63pM5IFI0nXnsfnCgOkIIU91k7cQlqVWcmN6Tbfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OdZR05O1ffiwAXxOyeGrHurfkx1RHuCI3Hxe0kUWCQM=;
	b=lp8dM3NU5tV+BUeYy5B633YjR7PNHBEJfnRqdCQe8+9RmswUSAch5ONKUamw+hyqYbaH
	 nD4PWdAralwpWuY0reaUfiXzthD+cPIWT/tS4cUZmTdym5HhD9DAX9Z5OAcmqh7a6zr0l
	 /UOuyPBTCHnJchY0JdSm/6GCWLePHZHgvBaK4jcvWJ0IhbBc+3JV/mfsTQxVssFdWTSxD
	 re0ND0m1m5ersOCsUa96sEQb/T59IsZHmUchUWHCYSAX5WYetU9BjzuZQFqCjlr7GADTd
	 SrUCrcc1XR1+jdCttytVGoUhQfhqgC/q6/9HyZ88vGls9IH+Q472ipKn64NE/6bkNxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p14nX7nd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA30606A32C;
	Wed,  4 Nov 2026 22:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p14nX7nd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55D91F000C1;
	Wed,  4 Nov 2026 22:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831610;
	bh=OdZR05O1ffiwAXxOyeGrHurfkx1RHuCI3Hxe0kUWCQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p14nX7ndkU66wrnAxBMvWUkszYuXQIAdwVb5ohPOLDnf/u4eIluQ0+rIrnfvy9hXx
	 VZKdMnSviKnp9kdy0R8nhmMhe+JHhfXsfrvMgxXBSF6WjOWgZhOG0VzNBJena/9gys
	 fBX764KBw1ka3W2DbVgzRG2Yy9ujZCc/wgYKzDwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Andrea Righi <arighi@nvidia.com>,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Kuba Piecuch <jpiecuch@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0809/1005] sched_ext: sync disable_irq_work in bpf_scx_unreg()
Date: Wed,  4 Nov 2026 16:09:02 -0500
Message-ID: <20261104211106.014238306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 510a27055446b8f0d29487ca8b8d2033dc2b6ca6 ]

When unregistered my self-written scx scheduler, the following panic
occurs.

[  229.923133] Kernel text patching generated an invalid instruction at 0xffff80009bc2c1f8!
[  229.923146] Internal error: Oops - BRK: 00000000f2000100 [#1]  SMP
[  230.077871] CPU: 48 UID: 0 PID: 1760 Comm: kworker/u583:7 Not tainted 7.0.0+ #3 PREEMPT(full)
[  230.086677] Hardware name: NVIDIA GB200 NVL/P3809-BMC, BIOS 02.05.12 20251107
[  230.093972] Workqueue: events_unbound bpf_map_free_deferred
[  230.099675] Sched_ext: invariant_0.1.0_aarch64_unknown_linux_gnu_debug (disabling), task: runnable_at=-174ms
[  230.116843] pc : 0xffff80009bc2c1f8
[  230.120406] lr : dequeue_task_scx+0x270/0x2d0
[  230.217749] Call trace:
[  230.228515]  0xffff80009bc2c1f8 (P)
[  230.232077]  dequeue_task+0x84/0x188
[  230.235728]  sched_change_begin+0x1dc/0x250
[  230.240000]  __set_cpus_allowed_ptr_locked+0x17c/0x240
[  230.245250]  __set_cpus_allowed_ptr+0x74/0xf0
[  230.249701]  ___migrate_enable+0x4c/0xa0
[  230.253707]  bpf_map_free_deferred+0x1a4/0x1b0
[  230.258246]  process_one_work+0x184/0x540
[  230.262342]  worker_thread+0x19c/0x348
[  230.266170]  kthread+0x13c/0x150
[  230.269465]  ret_from_fork+0x10/0x20
[  230.281393] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
[  230.287621] ---[ end trace 0000000000000000 ]---
[  231.160046] Kernel panic - not syncing: Oops - BRK: Fatal exception in interrupt

The root cause is that the JIT page backing ops->quiescent() is freed
before all callers of that function have stopped.

The expected ordering during teardown is:
    bitmap_zero(sch->has_op) + synchronize_rcu()
        -> guarantees no CPU will ever call sch->ops.* again
    -> only THEN free the BPF struct_ops JIT page

bpf_scx_unreg() is supposed to enforce the order, but after
commit f4a6c506d118 ("sched_ext: Always bounce scx_disable() through
irq_work"), disable_work is no longer queued directly, causing
kthread_flush_work() to be a noop. Thus, the caller drops the struct_ops
map too early and poisoned with AARCH64_BREAK_FAULT before
disable_workfn ever execute.

So the subsequent dequeue_task() still sees SCX_HAS_OP(sch, quiescent)
as true and calls ops.quiescent, which hit on the poisoned page and BRK
panic.

Add a helper scx_flush_disable_work() so the future use cases that want
to flush disable_work can use it.
Also amend the call for scx_root_enable_workfn() and
scx_sub_enable_workfn() which have similar pattern in the error path.

Fixes: f4a6c506d118 ("sched_ext: Always bounce scx_disable() through irq_work")
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ 6.18.y has neither f4a6c506d118 nor sub-schedulers. Here, the flush is
  a no-op when scx_disable() loses the exit claim to scx_vexit(), whose
  error_irq_work queues disable_work later. Sync error_irq_work instead
  of disable_irq_work and drop the scx_sub_enable_workfn() hunk. ]
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index f3e3146e5febf..d2460a88fba35 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4207,6 +4207,20 @@ static void scx_disable(struct scx_sched *sch, enum scx_exit_kind kind)
 		kthread_queue_work(sch->helper, &sch->disable_work);
 }
 
+/**
+ * scx_flush_disable_work - flush the disable work and wait for it to finish
+ * @sch: the scheduler
+ *
+ * sch->disable_work might still not queued, causing kthread_flush_work()
+ * as a noop. Syncing the irq_work first is required to guarantee the
+ * kthread work has been queued before waiting for it.
+ */
+static void scx_flush_disable_work(struct scx_sched *sch)
+{
+	irq_work_sync(&sch->error_irq_work);
+	kthread_flush_work(&sch->disable_work);
+}
+
 static void dump_newline(struct seq_buf *s)
 {
 	trace_sched_ext_dump("");
@@ -4968,7 +4982,7 @@ static void scx_root_enable_workfn(struct kthread_work *work)
 	 * completion. sch's base reference will be put by bpf_scx_unreg().
 	 */
 	scx_error(sch, "scx_root_enable() failed (%d)", ret);
-	kthread_flush_work(&sch->disable_work);
+	scx_flush_disable_work(sch);
 	cmd->ret = 0;
 }
 
@@ -5142,7 +5156,7 @@ static void bpf_scx_unreg(void *kdata, struct bpf_link *link)
 	struct scx_sched *sch = ops->priv;
 
 	scx_disable(sch, SCX_EXIT_UNREG);
-	kthread_flush_work(&sch->disable_work);
+	scx_flush_disable_work(sch);
 	kobject_put(&sch->kobj);
 }
 
-- 
2.53.0



