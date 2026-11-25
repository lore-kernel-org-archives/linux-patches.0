Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619066;
	b=CgMo2lPuVXHbBRe5Em0vUlyfuQAb5N0lIRblUa8GQNWZiVUy9e8M+1kAST0HeXUFfQRP
	 Y8UpZl5kgum4hzHz9U/KxMqESWFs+4LkHk6KRy9gAj08SFJTQrDWWF9662Yq3b9kl7V7b
	 /bB+mzdVlH6VV5cN5AgnpzDg4sdykHi5ob6I4wAE//UPwZwnt1t+Nbejmtuyh2xZn2nna
	 62Iv7wskQPF9/B4XEDnAsR4vTQgQOtPePrdODpauFwNVLbuHerBmEf8gZhHqe0KuSwWqV
	 6khRkoKy8r3kwIJLBkXsJNqN9DZXKWzDDnGVfR/zDvXYk0cTGa/1GTzk7BW3oYU95lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xG84lcmsdUQHT7/BNMLrYvgcgj9MKmf4KOGmXa0NK1s=;
	b=BQemq2wwFxPii5yGXbhVAU1ebiOOYZIepl5363c5FdLOu8hMmA2/PSKU/B8mpyOM5j4I
	 A1oJmHbmTv630SuKQrJHvA9gGHqqEnhtRv/ZWzDC69KZA72Px2dGvAnN1uosuv0HQJiec
	 Y7rljeT9PapRNoRH4K4lxLJiNW4jJSx4AB4+zDzZjQ4OAGbeRyqTxxGND/htuKvTw54cO
	 L5lxDoZNi69EdVD5ulc+xov8lbuzQ1IdXyIUkP7NnMWE2ySpR2J/46ahRwY0OiEJEaM9l
	 StbxhI5Tu5het5h7cFCjlS2zmP+eyh15UBMA4ZlYIxZe/xldS1gqIrkrn0WiOfxQ6og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bL3XjjGu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A15606A31E;
	Wed, 25 Nov 2026 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bL3XjjGu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FC91F000CA;
	Wed, 25 Nov 2026 15:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619065;
	bh=xG84lcmsdUQHT7/BNMLrYvgcgj9MKmf4KOGmXa0NK1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bL3XjjGukJ/oZEB4KFbxb1fWqBteAcyctPL8KaRkix9wNfAwIwlWLjxXrEbm4WEBk
	 qYrk/WFAxGoYWW41qximlXxEHtV5KkPHuhxfPmbrGjDrF3s3ZcVv99/aMfElDNM737
	 msfsrMPvi5/LavoadWrrO/ikqqRSLb52VrvDI2p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0478/1005] sched_ext: Add scx_bpf_dsq_reenq_task() to re-enqueue single tasks from a DSQ iteration
Date: Wed, 25 Nov 2026 15:30:16 +0100
Message-ID: <20261125143832.945376806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit b3768d058c98d4e8114a246d3267d7dae1c123fb ]

scx_bpf_dsq_reenq() re-enqueues a whole DSQ, but a scheduler that loses the
cpus serving a DSQ, such as a sub-scheduler after a cap revoke, needs only
the stranded tasks placed again.

Add scx_bpf_dsq_reenq_task(), which marks a task from a DSQ iteration. When
the iteration ends, the DSQ's deferred re-enqueue walk is scheduled once and
re-enqueues only the marked tasks. The kfunc locks the task's rq and the DSQ
like scx_bpf_dsq_move() and is callable from the same contexts. The mark is
cleared when the task leaves the DSQ, so a task consumed before the walk is
not re-enqueued.

An iteration's DSQ can be destroyed before the iteration ends, so
schedule_dsq_reenq() now skips a destroyed DSQ instead of aborting the
scheduler. scx_bpf_dsq_reenq() racing scx_bpf_destroy_dsq() takes the same
path.

Declare the kfunc for the tools and add a compat probe.

v2: Note in the kerneldoc that another iteration's re-enqueue may take a
marked task early, and that a task on another scheduler returns false
(Andrea).

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Stable-dep-of: fcbff7b56a88 ("sched_ext: make DSQ iterator stay drained after NULL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/ext.h                |  1 +
 kernel/sched/ext/ext.c                   | 82 +++++++++++++++++++++++-
 kernel/sched/ext/internal.h              |  2 +
 tools/sched_ext/include/scx/common.bpf.h |  1 +
 tools/sched_ext/include/scx/compat.bpf.h |  6 ++
 5 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/ext.h b/include/linux/sched/ext.h
index 81a29b3c0e5d8..444e1bfdab8fd 100644
--- a/include/linux/sched/ext.h
+++ b/include/linux/sched/ext.h
@@ -155,6 +155,7 @@ enum scx_ent_flags {
 /* scx_entity.dsq_flags */
 enum scx_ent_dsq_flags {
 	SCX_TASK_DSQ_ON_PRIQ	= 1 << 0, /* task is queued on the priority queue of a dsq */
+	SCX_TASK_DSQ_REENQ	= 1 << 1, /* marked by scx_bpf_dsq_reenq_task() */
 };
 
 enum scx_dsq_lnode_flags {
diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index fd9f949f3647f..78773d42b32df 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -492,11 +492,13 @@ enum scx_dsq_iter_flags {
 	/* iterate in the reverse dispatch order */
 	SCX_DSQ_ITER_REV		= 1U << 16,
 
+	__SCX_DSQ_ITER_HAS_REENQ	= 1U << 29,
 	__SCX_DSQ_ITER_HAS_SLICE	= 1U << 30,
 	__SCX_DSQ_ITER_HAS_VTIME	= 1U << 31,
 
 	__SCX_DSQ_ITER_USER_FLAGS	= SCX_DSQ_ITER_REV,
 	__SCX_DSQ_ITER_ALL_FLAGS	= __SCX_DSQ_ITER_USER_FLAGS |
+					  __SCX_DSQ_ITER_HAS_REENQ |
 					  __SCX_DSQ_ITER_HAS_SLICE |
 					  __SCX_DSQ_ITER_HAS_VTIME,
 };
@@ -1175,7 +1177,9 @@ void schedule_dsq_reenq(struct scx_sched *sch, struct scx_dispatch_q *dsq,
 			WRITE_ONCE(dru->flags, dru->flags | reenq_flags);
 		}
 	} else {
-		scx_error(sch, "DSQ 0x%llx not allowed for reenq", dsq->id);
+		/* destroyed since the caller resolved it, nothing to reenq */
+		if (READ_ONCE(dsq->id) != SCX_DSQ_INVALID)
+			scx_error(sch, "DSQ 0x%llx not allowed for reenq", dsq->id);
 		return;
 	}
 
@@ -1770,6 +1774,7 @@ void scx_task_unlink_from_dsq(struct task_struct *p, struct scx_dispatch_q *dsq)
 		RB_CLEAR_NODE(&p->scx.dsq_priq);
 		p->scx.dsq_flags &= ~SCX_TASK_DSQ_ON_PRIQ;
 	}
+	p->scx.dsq_flags &= ~SCX_TASK_DSQ_REENQ;
 
 	list_del_init(&p->scx.dsq_list.node);
 	dsq_dec_nr(dsq, p);
@@ -4746,7 +4751,9 @@ static void process_deferred_reenq_locals(struct rq *rq)
 static bool user_task_should_reenq(struct task_struct *p, u64 reenq_flags, u32 *reason)
 {
 	*reason = SCX_TASK_REENQ_KFUNC;
-	return reenq_flags & SCX_REENQ_ANY;
+	if (reenq_flags & SCX_REENQ_ANY)
+		return true;
+	return (reenq_flags & SCX_REENQ_MARKED) && (p->scx.dsq_flags & SCX_TASK_DSQ_REENQ);
 }
 
 static void reenq_user(struct rq *rq, struct scx_dispatch_q *dsq, u64 reenq_flags)
@@ -9771,6 +9778,8 @@ BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_slice, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_vtime, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move_vtime, KF_RCU)
+/* also in scx_kfunc_ids_unlocked, same contexts as scx_bpf_dsq_move() */
+BTF_ID_FLAGS(func, scx_bpf_dsq_reenq_task, KF_RCU)
 #ifdef CONFIG_EXT_SUB_SCHED
 BTF_ID_FLAGS(func, scx_bpf_sub_dispatch, KF_IMPLICIT_ARGS)
 #endif
@@ -9886,6 +9895,7 @@ BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_slice, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_vtime, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move_vtime, KF_RCU)
+BTF_ID_FLAGS(func, scx_bpf_dsq_reenq_task, KF_RCU)
 /* also in scx_kfunc_ids_select_cpu: also callable from ops.select_cpu()/ops.enqueue() */
 BTF_ID_FLAGS(func, __scx_bpf_select_cpu_and, KF_IMPLICIT_ARGS | KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_select_cpu_and, KF_RCU)
@@ -10239,7 +10249,8 @@ __bpf_kfunc struct task_struct *bpf_iter_scx_dsq_next(struct bpf_iter_scx_dsq *i
  * bpf_iter_scx_dsq_destroy - Destroy a DSQ iterator
  * @it: iterator to destroy
  *
- * Undo bpf_iter_scx_dsq_new().
+ * Undo bpf_iter_scx_dsq_new(). If the iteration marked tasks with
+ * scx_bpf_dsq_reenq_task(), schedule their re-enqueue.
  */
 __bpf_kfunc void bpf_iter_scx_dsq_destroy(struct bpf_iter_scx_dsq *it)
 {
@@ -10255,6 +10266,13 @@ __bpf_kfunc void bpf_iter_scx_dsq_destroy(struct bpf_iter_scx_dsq *it)
 		list_del_init(&kit->cursor.node);
 		raw_spin_unlock_irqrestore(&kit->dsq->lock, flags);
 	}
+
+	if (kit->cursor.flags & __SCX_DSQ_ITER_HAS_REENQ) {
+		guard(preempt)();
+		schedule_dsq_reenq(kit->dsq->sched, kit->dsq, SCX_REENQ_MARKED,
+				   scx_locked_rq());
+	}
+
 	kit->dsq = NULL;
 }
 
@@ -10340,6 +10358,64 @@ __bpf_kfunc void scx_bpf_dsq_reenq(u64 dsq_id, u64 reenq_flags,
 	schedule_dsq_reenq(sch, dsq, reenq_flags, locked_rq);
 }
 
+/**
+ * scx_bpf_dsq_reenq_task - Re-enqueue a task from a DSQ iteration
+ * @it__iter: DSQ iterator in progress
+ * @p: task to re-enqueue
+ *
+ * Mark @p, which is on the DSQ iterated by @it__iter and was queued before the
+ * iteration started, for re-enqueue. When the iteration ends, the DSQ's marked
+ * tasks go through ops.enqueue() with %SCX_ENQ_REENQ in DSQ order and the other
+ * tasks on the DSQ keep their positions. A marked task that leaves the DSQ in
+ * the meantime is not re-enqueued. The mark belongs to @p, so a re-enqueue
+ * scheduled by another iteration of the DSQ may re-enqueue @p before this
+ * iteration ends. @p must be on the DSQ's scheduler.
+ *
+ * Re-enqueues are performed asynchronously. Can be called from ops.dispatch()
+ * or any BPF context which doesn't hold a rq lock (e.g. BPF timers or SYSCALL
+ * programs).
+ *
+ * Return %true if @p was marked, %false if @p left the DSQ or was queued after
+ * the iteration started, @p is on another scheduler, or the iterator holds no
+ * DSQ.
+ */
+__bpf_kfunc bool scx_bpf_dsq_reenq_task(struct bpf_iter_scx_dsq *it__iter,
+					struct task_struct *p)
+{
+	struct bpf_iter_scx_dsq_kern *kit = (void *)it__iter;
+	struct scx_dispatch_q *dsq = kit->dsq;
+	struct rq *src_rq, *entry_rq;
+	unsigned long flags;
+	bool marked = false;
+
+	/* NULL after a failed bpf_iter_scx_dsq_new(), see scx_dsq_move() */
+	if (unlikely(!dsq))
+		return false;
+
+	/* the cursor check needs @p's rq locked */
+	src_rq = task_rq(p);
+	entry_rq = kf_switch_rq_lock(src_rq, &flags);
+
+	scoped_guard (raw_spinlock, &dsq->lock) {
+		if (nldsq_cursor_lost_task(&kit->cursor, src_rq, dsq, p))
+			break;
+
+		if (unlikely(!scx_task_on_sched(dsq->sched, p))) {
+			scx_error(dsq->sched, "scx_bpf_dsq_reenq_task() on %s[%d] but the task belongs to a different scheduler",
+				  p->comm, p->pid);
+			break;
+		}
+
+		p->scx.dsq_flags |= SCX_TASK_DSQ_REENQ;
+		/* the walk is scheduled once, by bpf_iter_scx_dsq_destroy() */
+		kit->cursor.flags |= __SCX_DSQ_ITER_HAS_REENQ;
+		marked = true;
+	}
+
+	kf_restore_rq_lock(src_rq, entry_rq, flags);
+	return marked;
+}
+
 /**
  * scx_bpf_reenqueue_local___v2 - Re-enqueue tasks on a local DSQ
  * @aux: implicit BPF argument to access bpf_prog_aux hidden from BPF progs
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index 2f35b98adb72b..028f1c987d4ec 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -1888,6 +1888,8 @@ enum scx_reenq_flags {
 
 	/* internal: kernel-issued on cap revoke, not accepted from BPF */
 	SCX_REENQ_CAP_REVOKE	= 1LLU << 1,
+	/* internal: tasks marked by scx_bpf_dsq_reenq_task() */
+	SCX_REENQ_MARKED	= 1LLU << 2,
 
 	__SCX_REENQ_FILTER_MASK	= 0xffffLLU,
 
diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 22f24ebef8a9a..6e419fdfc779a 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -74,6 +74,7 @@ struct task_struct *scx_bpf_dsq_peek(u64 dsq_id) __ksym __weak;
 int bpf_iter_scx_dsq_new(struct bpf_iter_scx_dsq *it, u64 dsq_id, u64 flags) __ksym __weak;
 struct task_struct *bpf_iter_scx_dsq_next(struct bpf_iter_scx_dsq *it) __ksym __weak;
 void bpf_iter_scx_dsq_destroy(struct bpf_iter_scx_dsq *it) __ksym __weak;
+bool scx_bpf_dsq_reenq_task(struct bpf_iter_scx_dsq *it, struct task_struct *p) __ksym __weak;
 void scx_bpf_exit_bstr(s64 exit_code, char *fmt, unsigned long long *data, u32 data__sz) __ksym __weak;
 void scx_bpf_error_bstr(char *fmt, unsigned long long *data, u32 data_len) __ksym;
 void scx_bpf_dump_bstr(char *fmt, unsigned long long *data, u32 data_len) __ksym __weak;
diff --git a/tools/sched_ext/include/scx/compat.bpf.h b/tools/sched_ext/include/scx/compat.bpf.h
index 6944221f96cc0..bc24f6ec432fa 100644
--- a/tools/sched_ext/include/scx/compat.bpf.h
+++ b/tools/sched_ext/include/scx/compat.bpf.h
@@ -414,6 +414,12 @@ static inline bool __COMPAT_has_generic_reenq(void)
 	return bpf_ksym_exists(scx_bpf_dsq_reenq___compat);
 }
 
+/* v7.4: Add scx_bpf_dsq_reenq_task(). */
+static inline bool __COMPAT_has_dsq_reenq_task(void)
+{
+	return bpf_ksym_exists(scx_bpf_dsq_reenq_task);
+}
+
 /*
  * v6.19: The new void variant can be called from anywhere while the older v1
  * variant can only be called from ops.cpu_release(). The double ___ prefixes on
-- 
2.53.0



