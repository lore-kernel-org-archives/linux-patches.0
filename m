Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027064;
	b=vIu0XEs1J3A0Q+JOpNBSDwQ3TaVUKYefaxYAS5uaXFYaHVpf59JaJbThAynhrFG0r9XE
	 Gb9BRygMNQEOIshnfEMvbKjfhVWlH8hW/q8HHwQOVoPXjYBlH6k4FhMFnx7TVHW+m8ftt
	 lGw4h72Qd7C9ckR1XpQCDQ1qmVwY2Abh0hUAo0Ih9QvLgnwpnOsRBnDv8UicuFAd+XzZl
	 +Qv66S1HR0OerQsxAlzyTUogqmdLrkJQmbUV52QaQWRNWw3oYzbavdpqSExNsClmA0/o2
	 5vR0FpDt2Fz8K4ZXrBOeh7TxHfZ83wroWb7pHQYZgBGPiqW+TW0onZVtwl4uNXoqs/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFGI7avrxDMDJG/ItMDrFopG3/mKpkV5i1BrnoITlDg=;
	b=j4hfzs2FFmNmvXy+S5sja2AOg4HMMHVqH+3l3tpHMAzunKW4d73dM5Siy6ox7+VdC3B6
	 49h1IuboUQlOTq5fY8zLxcmkiGsU9aZuDQZ4D4kXh0w67oUMxPqFKfH0/LAfJ8xR8QcYG
	 fWNA+h0AOLOJH6TZOlhzXhx8xpJFslu72AUShXrKwwNmLilwPlnE99w2Li7GHzkUfqWIn
	 120zE2xcvUN8pibw0GM/VL6XqmDODKQOEmVRJwclfgfzCmkR0/4uHgpPxU67o7WaO6y3y
	 5KlwkzeFRAb1h5U0XfdE7mSTzZp9V+0TqpLFd2QIx6xMkwPvkqa1/LHP/tEKEi5BFQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YZH2P/Sl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FB9606A32C;
	Wed, 18 Nov 2026 18:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZH2P/Sl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880D61F000C4;
	Wed, 18 Nov 2026 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027064;
	bh=gFGI7avrxDMDJG/ItMDrFopG3/mKpkV5i1BrnoITlDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZH2P/SlWTiZ/Zhk5LeF42NtYAd/+eJDKv53Z/cx0X3FLfDW1U8iGYA+HnrOn8vfO
	 U6Ej7/BGuOfD4dgIu4YxvKpcuIqqnKXZikUqbK7E9ubTUzn7ieASnRan9OuNQQbLx0
	 79gDhYdheXtihLG9tiiQWETd7RKjZ9qet8oQ0GMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>,
	Yun Lu <luyun@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1658/2151] bpf: Fix NULL task dereference in task work cancellation
Date: Wed, 18 Nov 2026 15:56:33 +0100
Message-ID: <20261118150222.239554730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Yun Lu <luyun@kylinos.cn>

[ Upstream commit c961f7b41a108313a4705baac7b27d2174cc8035 ]

bpf_task_work_irq() publishes ctx->work with task_work_add() before
changing the context from SCHEDULING to SCHEDULED.  The target task can
run the callback on another CPU before the handler reaches its final
state transition.

The handler then reloads ctx->task for cancellation if its final cmpxchg
observes FREED.  By that point the callback or context destruction may
already have cleared ctx->task, causing task_work_cancel() to dereference
a NULL task pointer.

One concrete interleaving is:

  1. CPU 0 changes PENDING to SCHEDULING and successfully queues
     ctx->work with task_work_add(), but has not attempted the final
     state cmpxchg.

  2. The target task on CPU 1 runs the callback.  It changes SCHEDULING
     to RUNNING, executes the BPF subprogram, resets ctx->task,
     publishes STANDBY and drops the callback's context reference.

  3. CPU 2 deletes the map value.  It changes STANDBY to FREED and drops
     the map's context reference without queuing asynchronous
     cancellation.

  4. CPU 0 resumes.  Its SCHEDULING-to-SCHEDULED cmpxchg observes FREED,
     and the cancellation attempt passes NULL to task_work_cancel().

If deletion publishes FREED before the callback claims RUNNING, the
callback takes its FREED exit and drops its context reference.  Context
destruction can then clear ctx->task before CPU 0 attempts cancellation.

A controlled reproducer with a delay before the final cmpxchg triggered
the following fault on a v7.3-rc3 based x86-64 KVM guest:

  BUG: kernel NULL pointer dereference, address: 0000000000000890
  RIP: 0010:task_work_cancel+0xd/0xa0
  RDI: 0000000000000000
  CR2: 0000000000000890
  Call Trace:
   <IRQ>
   bpf_task_work_irq+0x95/0x100
   irq_work_run_list+0x4f/0x90
   irq_work_run+0x18/0x50
   </IRQ>

0x890 is the task_struct::task_works offset in that build, read through
the NULL task argument.

Capture ctx->task before task_work_add() publishes the callback and use
that pointer for the handler's cancellation attempt.  The round still
holds its task reference when the pointer is captured.  Releasing that
reference uses bpf_task_release(), which calls put_task_struct_rcu_user(),
so the handler's existing RCU read-side section keeps the captured task
alive even if ctx->task is subsequently cleared.

The asynchronous cancellation path reads ctx->task directly, which is
safe there: queuing it requires deletion to observe SCHEDULED, and that
xchg wins against the callback's transition to RUNNING, so the callback
takes its FREED exit without resetting ctx->task, while the map
reference transferred to the cancellation handler prevents context
destruction until cancellation completes.

The handler-tail and asynchronous cancellation attempts are mutually
exclusive: asynchronous cancellation is queued only if deletion observes
SCHEDULED after the scheduling handler's final cmpxchg has succeeded.
If that cmpxchg instead observes FREED, the scheduling handler attempts
cancellation with the captured pointer.

Fixes: 38aa7003e369 ("bpf: task work scheduling kfuncs")
Reported-by: Jackie Liu <liuyun01@kylinos.cn>
Suggested-by: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261012061915.231254-2-luyun_611@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index fd59259ca9780..12f21abb0ea20 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4007,15 +4007,21 @@ static void bpf_task_work_ctx_put(struct bpf_task_work_ctx *ctx)
 	}
 }
 
-static void bpf_task_work_cancel(struct bpf_task_work_ctx *ctx)
+static void bpf_task_work_cancel(struct bpf_task_work_ctx *ctx,
+				 struct task_struct *task)
 {
 	/*
 	 * Scheduled task_work callback holds ctx ref, so if we successfully
 	 * cancelled, we put that ref on callback's behalf. If we couldn't
 	 * cancel, callback will inevitably run or has already completed
 	 * running, and it would have taken care of its ctx ref itself.
+	 *
+	 * The caller passes the task explicitly: the scheduling handler must
+	 * not read ctx->task after the work is published (the callback may
+	 * have reset it), while in the asynchronous cancellation path
+	 * ctx->task is stable, see bpf_task_work_cancel_scheduled().
 	 */
-	if (task_work_cancel(ctx->task, &ctx->work))
+	if (task_work_cancel(task, &ctx->work))
 		bpf_task_work_ctx_put(ctx);
 }
 
@@ -4056,6 +4062,7 @@ static void bpf_task_work_callback(struct callback_head *cb)
 static void bpf_task_work_irq(struct irq_work *irq_work)
 {
 	struct bpf_task_work_ctx *ctx = container_of(irq_work, struct bpf_task_work_ctx, irq_work);
+	struct task_struct *task;
 	enum bpf_task_work_state state;
 	int err;
 
@@ -4066,7 +4073,16 @@ static void bpf_task_work_irq(struct irq_work *irq_work)
 		return;
 	}
 
-	err = task_work_add(ctx->task, &ctx->work, ctx->mode);
+	/*
+	 * Capture the task pointer before the work is published: once the
+	 * callback runs, it may reset ctx->task. The capture happens while
+	 * this round's task reference is held, and every path that can
+	 * release it runs after this handler entered its rcu read-side
+	 * section. bpf_task_release() is put_task_struct_rcu_user(), so the
+	 * task_struct itself cannot be freed before this section ends.
+	 */
+	task = ctx->task;
+	err = task_work_add(task, &ctx->work, ctx->mode);
 	if (err) {
 		bpf_task_work_ctx_reset(ctx);
 		/*
@@ -4080,14 +4096,14 @@ static void bpf_task_work_irq(struct irq_work *irq_work)
 
 	/*
 	 * It's technically possible for just scheduled task_work callback to
-	 * complete running by now, going SCHEDULING -> RUNNING and then
-	 * dropping its ctx refcount. Instead of capturing an extra ref just
-	 * to protect below ctx->state access, we rely on rcu_read_lock
-	 * above to prevent kfree_rcu from freeing ctx before we return.
+	 * complete running by now, going SCHEDULING -> RUNNING, resetting
+	 * ctx->task and dropping its ctx refcount. The rcu read-side section
+	 * above keeps both the ctx memory and the captured task pointer
+	 * valid until this handler returns.
 	 */
 	state = cmpxchg(&ctx->state, BPF_TW_SCHEDULING, BPF_TW_SCHEDULED);
 	if (state == BPF_TW_FREED)
-		bpf_task_work_cancel(ctx); /* clean up if we switched into FREED state */
+		bpf_task_work_cancel(ctx, task); /* clean up if we switched into FREED state */
 }
 
 static struct bpf_task_work_ctx *bpf_task_work_fetch_ctx(struct bpf_task_work *tw,
@@ -4254,7 +4270,13 @@ static void bpf_task_work_cancel_scheduled(struct irq_work *irq_work)
 {
 	struct bpf_task_work_ctx *ctx = container_of(irq_work, struct bpf_task_work_ctx, irq_work);
 
-	bpf_task_work_cancel(ctx); /* this might put task_work callback's ref */
+	/*
+	 * Deletion observed SCHEDULED and won against the callback's
+	 * transition to RUNNING. The callback takes its FREED exit without
+	 * resetting ctx->task, and the transferred map reference prevents
+	 * destruction until cancellation completes.
+	 */
+	bpf_task_work_cancel(ctx, ctx->task); /* this might put task_work callback's ref */
 	bpf_task_work_ctx_put(ctx); /* and here we put map's own ref that was transferred to us */
 }
 
-- 
2.53.0



