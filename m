Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214304;
	b=zcLPzI99ZOVyCvDmKZMd3e6c1B7h+GwAKDFjvpdKOpMb6mOqIvqyNK7UuZW5wMzwaFSa
	 aGKQL05NZ3Un2KqWkn+9WHe4mygPIo76/08VAnbbco7erS87a0a0fcGMpnnInCfHyO+dy
	 L67LJhQiolkA9xnQZFcMQ4GojHSStEGJss6QInWhkMBstHKhUkyuAvtd8IfyrQP3inl9G
	 zcX+n0NYn8JOp4te6p2Zb+D5zNUkXx1rvGP7AjzBESIiadze+pz4BPNHsiNVJ77aIa8ln
	 wY6CpQJNl6cHDTTjUaLosuw0DYULdBYOwPPgZV215gusBGJfGUzDCJ+x3ydFyYaGkTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EmXqn1Mfvn3zQ6sjhalgGwYdeLUoR/FIslIXKwJl420=;
	b=LdbwEfxMqZsLJ0tDRAGl0NUsc9zUocQvoLq0GvV4GOBGP7kWPsQdJOHtGcZDQ5ajnotu
	 wc6vYA5iWOAiNpvlbouUP9b5G81gLiouLZ+M9sZeGUbeY2EJEoAiJfg65v7Bhqt1W/Er1
	 YWdq1vwWtt9f6Y/Pd2j7GRQVXxFlDNi5I04qPXI1aRngAkMWdJpP6vS4pCAuk4uHQi/zf
	 byVGTz3Es54pE1YMtxoXm3mZcLStxEgcG1795HiGVJpDwzRqwCQ6BmcKRxL+A/chPH9dd
	 FnePH2jVPc2n6Uk+jOfWXMA0zeNzeSQ1ob86gxKBOasnx06LD/XYXim3Am/uIzDck4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6xOlKeq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F17606BF8E;
	Wed, 28 Oct 2026 19:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6xOlKeq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E3A1F01828;
	Wed, 28 Oct 2026 19:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214303;
	bh=EmXqn1Mfvn3zQ6sjhalgGwYdeLUoR/FIslIXKwJl420=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6xOlKeqEGK8Ye3MLzTAp73Ubc0pcG/Aiu8R8MKBXok1zCc5DLSvBvRa1epG/48sU
	 8mFqUXfq/vSIAROJXNaMas9XRUsYZ6U3QQs+WG50m+g43NWiwQ6z5AEAfSId7Y4Zp5
	 6nZQ2rOxWYkvHqebkY3tIPlPyC5QF4EdrKbKNEmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yi Lai" <yi1.lai@linux.intel.com>,
	syzbot+3c4321e10eea460eb606@syzkaller.appspotmail.com,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0768/1887] perf: Fix hang while freeing sigtrap event
Date: Wed, 28 Oct 2026 17:47:44 +0100
Message-ID: <20261028170516.916763653@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 56799bc035658738f362acec3e7647bb84e68933 ]

Perf can hang while freeing a sigtrap event if a related deferred
signal hadn't managed to be sent before the file got closed:

perf_event_overflow()
   task_work_add(perf_pending_task)

fput()
   task_work_add(____fput())

task_work_run()
    ____fput()
        perf_release()
            perf_event_release_kernel()
                _free_event()
                    perf_pending_task_sync()
                        task_work_cancel() -> FAILED
                        rcuwait_wait_event()

Once task_work_run() is running, the list of pending callbacks is
removed from the task_struct and from this point on task_work_cancel()
can't remove any pending and not yet started work items, hence the
task_work_cancel() failure and the hang on rcuwait_wait_event().

Task work could be changed to remove one work at a time, so a work
running on the current task can always cancel a pending one, however
the wait / wake design is still subject to inverted dependencies when
remote targets are involved, as pictured by Oleg:

T1                                                      T2

fd = perf_event_open(pid => T2->pid);                  fd = perf_event_open(pid => T1->pid);
close(fd)                                              close(fd)
    <IRQ>                                                  <IRQ>
    perf_event_overflow()                                  perf_event_overflow()
       task_work_add(perf_pending_task)                        task_work_add(perf_pending_task)
    </IRQ>                                                 </IRQ>
    fput()                                                 fput()
        task_work_add(____fput())                              task_work_add(____fput())

    task_work_run()                                        task_work_run()
        ____fput()                                             ____fput()
            perf_release()                                         perf_release()
                perf_event_release_kernel()                            perf_event_release_kernel()
                    _free_event()                                          _free_event()
                        perf_pending_task_sync()                               perf_pending_task_sync()
                            rcuwait_wait_event()                                   rcuwait_wait_event()

Therefore the only option left is to acquire the event reference count
upon queueing the perf task work and release it from the task work, just
like it was done before 3a5465418f5f ("perf: Fix event leak upon exec and file release")
but without the leaks it fixed.

Some adjustments are necessary to make it work:

* A child event might dereference its parent upon freeing. Care must be
  taken to release the parent last.

* Some places assuming the event doesn't have any reference held and
  therefore can be freed right away must instead put the reference and
  let the reference counting to its job.

Reported-by: "Yi Lai" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/all/Zx9Losv4YcJowaP%2F@ly-workstation/
Reported-by: syzbot+3c4321e10eea460eb606@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/673adf75.050a0220.87769.0024.GAE@google.com/
Fixes: 3a5465418f5f ("perf: Fix event leak upon exec and file release")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250304135446.18905-1-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |  1 -
 kernel/events/core.c       | 64 +++++++++++---------------------------
 2 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 41ff70f315a92..1c32eec27b045 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -765,7 +765,6 @@ struct perf_event {
 	struct irq_work			pending_irq;
 	struct callback_head		pending_task;
 	unsigned int			pending_work;
-	struct rcuwait			pending_work_wait;
 
 	atomic_t			event_limit;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a64e0254e803c..49b79617723ab 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2317,6 +2317,7 @@ event_sched_out(struct perf_event *event,
 		    !event->pending_work &&
 		    !task_work_add(current, &event->pending_task, TWA_RESUME)) {
 			event->pending_work = 1;
+			WARN_ON_ONCE(!atomic_long_inc_not_zero(&event->refcount));
 		} else {
 			local_dec(&event->ctx->nr_pending);
 		}
@@ -5016,35 +5017,9 @@ static bool exclusive_event_installable(struct perf_event *event,
 static void perf_addr_filters_splice(struct perf_event *event,
 				       struct list_head *head);
 
-static void perf_pending_task_sync(struct perf_event *event)
-{
-	struct callback_head *head = &event->pending_task;
-
-	if (!event->pending_work)
-		return;
-	/*
-	 * If the task is queued to the current task's queue, we
-	 * obviously can't wait for it to complete. Simply cancel it.
-	 */
-	if (task_work_cancel(current, head)) {
-		event->pending_work = 0;
-		local_dec(&event->ctx->nr_pending);
-		return;
-	}
-
-	/*
-	 * All accesses related to the event are within the same
-	 * non-preemptible section in perf_pending_task(). The RCU
-	 * grace period before the event is freed will make sure all
-	 * those accesses are complete by then.
-	 */
-	rcuwait_wait_event(&event->pending_work_wait, !event->pending_work, TASK_UNINTERRUPTIBLE);
-}
-
 static void _free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending_irq);
-	perf_pending_task_sync(event);
 
 	unaccount_event(event);
 
@@ -5166,10 +5141,17 @@ static void perf_remove_from_owner(struct perf_event *event)
 
 static void put_event(struct perf_event *event)
 {
+	struct perf_event *parent;
+
 	if (!atomic_long_dec_and_test(&event->refcount))
 		return;
 
+	parent = event->parent;
 	_free_event(event);
+
+	/* Matches the refcount bump in inherit_event() */
+	if (parent)
+		put_event(parent);
 }
 
 /*
@@ -5253,11 +5235,6 @@ int perf_event_release_kernel(struct perf_event *event)
 		if (tmp == child) {
 			perf_remove_from_context(child, DETACH_GROUP);
 			list_move(&child->child_list, &free_list);
-			/*
-			 * This matches the refcount bump in inherit_event();
-			 * this can't be the last reference.
-			 */
-			put_event(event);
 		} else {
 			var = &ctx->refcount;
 		}
@@ -5283,7 +5260,8 @@ int perf_event_release_kernel(struct perf_event *event)
 		void *var = &child->ctx->refcount;
 
 		list_del(&child->child_list);
-		free_event(child);
+		/* Last reference unless ->pending_task work is pending */
+		put_event(child);
 
 		/*
 		 * Wake any perf_event_free_task() waiting for this event to be
@@ -5294,7 +5272,11 @@ int perf_event_release_kernel(struct perf_event *event)
 	}
 
 no_ctx:
-	put_event(event); /* Must be the 'last' reference */
+	/*
+	 * Last reference unless ->pending_task work is pending on this event
+	 * or any of its children.
+	 */
+	put_event(event);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(perf_event_release_kernel);
@@ -6699,11 +6681,6 @@ static void perf_pending_task(struct callback_head *head)
 	struct perf_event *event = container_of(head, struct perf_event, pending_task);
 	int rctx;
 
-	/*
-	 * All accesses to the event must belong to the same implicit RCU read-side
-	 * critical section as the ->pending_work reset. See comment in
-	 * perf_pending_task_sync().
-	 */
 	preempt_disable_notrace();
 	/*
 	 * If we 'fail' here, that's OK, it means recursion is already disabled
@@ -6715,12 +6692,13 @@ static void perf_pending_task(struct callback_head *head)
 		event->pending_work = 0;
 		perf_sigtrap(event);
 		local_dec(&event->ctx->nr_pending);
-		rcuwait_wake_up(&event->pending_work_wait);
 	}
 
 	if (rctx >= 0)
 		perf_swevent_put_recursion_context(rctx);
 	preempt_enable_notrace();
+
+	put_event(event);
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
@@ -11915,7 +11893,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending_irq, perf_pending_irq);
 	init_task_work(&event->pending_task, perf_pending_task);
-	rcuwait_init(&event->pending_work_wait);
 
 	mutex_init(&event->mmap_mutex);
 	raw_spin_lock_init(&event->addr_filters.lock);
@@ -13100,8 +13077,7 @@ perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
 		 * Kick perf_poll() for is_event_hup();
 		 */
 		perf_event_wakeup(parent_event);
-		free_event(event);
-		put_event(parent_event);
+		put_event(event);
 		return;
 	}
 
@@ -13221,13 +13197,11 @@ static void perf_free_event(struct perf_event *event,
 	list_del_init(&event->child_list);
 	mutex_unlock(&parent->child_mutex);
 
-	put_event(parent);
-
 	raw_spin_lock_irq(&ctx->lock);
 	perf_group_detach(event);
 	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
-	free_event(event);
+	put_event(event);
 }
 
 /*
-- 
2.53.0



