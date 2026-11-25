Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618652;
	b=OcW172NxEhT2sc3dirBamzTsD5p2kUHTmOVe+SC3nDNYGekC9OxhVUbG3ybQ4jpykpPj
	 Dw+ryppduelL+nAoXDf7vwudRGylTw8BvJ785zbQRs8dIifM4QrUBWy3catPQb7bPeY1E
	 wW8eChD8vdw8EqVTyETIaB+ADV2/hH1Lrta1M/VYBtZDeiC1o4laqt5XFiOrvYoZKGpxX
	 2dZTsGb3LKd9UjkVzMznpaQOA8YR/VGIeyr8e//WA/yORBXdT/SJTtbWrCHzZJ59ZN609
	 bCJ9LGPB0p90hUC5zHQdSouTtgULvDmld8AM59D9pGCS2f1Oqod5aSwVW0qCMx8NAlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P2FcNrMqk9s1Vo+mm0r1DmIndu4Dl+aDWo4vfiBRKcc=;
	b=DcNkia4P7VR3KiJqUcwULNSDGxD6UppB1tN/VFWqNEOwFuoUFLA45QNLngp3BbvW7SVa
	 CejmDPbfdjmoUgoeQuM/z+UKHHbjmdwedo1+hRBs/U15nIYmwTWRd8yj6hztgdXCKcQTF
	 yhdcVcejRIzlDa0DneRZqd/Fg0qlRcKVQk4l3VijiyFuJzqVyEiI0HRn0g2S7ofyoiKAU
	 Fx2zt15CSXkbZH4V69yYPkXfWZpOo1n75d5cXg5MPGsdAtGXcRqaSu7xE4AYke3WlZyi4
	 dYnqwusGqRbVxyZ3xKzIo6AITTY5RpZREZiyykNIBiDj0eigzD0+CXmVGU8cE42VT0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vndJrOon;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021A4606A31E;
	Wed, 25 Nov 2026 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vndJrOon
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E121C1F000C0;
	Wed, 25 Nov 2026 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618651;
	bh=P2FcNrMqk9s1Vo+mm0r1DmIndu4Dl+aDWo4vfiBRKcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vndJrOonrtr0xeZeMuoMURpEgcxyK/4DZok96v1Lz9ao+7ysSrUpimPXD/5DwvDCc
	 gkCFxTKLT0XBdCDjxzDl2r492pTaTX/7NIS8ajQ1vo70dm6EO90IDt24cNJccSqilb
	 RbY7x4gPkzJFon2jc19v5sE11li9Cg90ZDjqV5lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0345/1005] sched/core: Account I/O waits independently of delayed dequeue
Date: Wed, 25 Nov 2026 15:28:03 +0100
Message-ID: <20261125143829.816771558@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 0965587d00b84f0a3b0fc94930d4a5f8ff011eda ]

Starting blkio delay accounting and incrementing rq->nr_iowait in
__block_task() ties both to removal from the runqueue. With EEVDF delayed
dequeue, this misses the initial part of an I/O sleep, or the entire
sleep if the task wakes before it is dequeued. Such tasks are also
missing from procs_blocked while their dequeue is delayed. Final dequeue
can run in another task's context, causing delayacct_blkio_start() to
timestamp the wrong task.

Start both forms of accounting in try_to_block_task(), when the current
task commits to blocking, before delayed dequeue or proxy execution can
retain it on the runqueue. End both when clearing is_blocked, including
queued wakeups and the proxy execution paths that let the current task
continue. Checking is_blocked excludes wakeups that precede blocking.

Save the CPU charged at the start of the wait. Delayed tasks can migrate
while still queued, and proxy execution can also move blocked tasks.
Decrement the saved CPU's counter on unblock, regardless of the task's
current placement, and remove the old dequeue-based accounting.

CPU iowait continues to classify idle time using the counter on the
charged CPU; it does not accumulate the full per-task blocked duration.

Closes: https://lore.kernel.org/r/20261014081731.1068794-1-zhanxusheng@xiaomi.com
Fixes: 152e11f6df29 ("sched/fair: Implement delayed dequeue")
Reported-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Link: https://patch.msgid.link/fd8578a1-e60b-4993-ab51-2b5d63abcf77@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h |  2 ++
 kernel/sched/core.c   | 33 ++++++++++++++++++++-------------
 kernel/sched/sched.h  |  5 -----
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 09d90f5edd2bf..bdfd662e2c37b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -880,6 +880,8 @@ struct task_struct {
 	 */
 	int				recent_used_cpu;
 	int				wake_cpu;
+	/* CPU charged while is_blocked && in_iowait. */
+	int				iowait_cpu;
 
 	int				prio;
 	int				static_prio;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4a051764e7119..1a57b0733fec5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -636,7 +636,7 @@ int task_llc(const struct task_struct *p)
  *
  * p->is_blocked <- { 0, 1 }:
  *
- *   is set by try_to_block_task() and cleared by ttwu_do_wakeup() and tracks
+ *   is set by try_to_block_task() and cleared by unblock_task() and tracks
  *   if the task is blocked. Traditionally this would mirror p->on_rq, however
  *   due things like DELAY_DEQUEUE and PROXY_EXEC, this can diverge.
  *
@@ -3740,12 +3740,22 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 		__schedstat_inc(p->stats.nr_wakeups_sync);
 }
 
+static inline void unblock_task(struct task_struct *p)
+{
+	if (p->is_blocked && p->in_iowait) {
+		delayacct_blkio_end(p);
+		atomic_dec(&cpu_rq(p->iowait_cpu)->nr_iowait);
+	}
+
+	p->is_blocked = 0;
+}
+
 /*
  * Mark the task runnable.
  */
 static inline void ttwu_do_wakeup(struct task_struct *p)
 {
-	p->is_blocked = 0;
+	unblock_task(p);
 	WRITE_ONCE(p->__state, TASK_RUNNING);
 	trace_sched_wakeup(p);
 }
@@ -3843,10 +3853,6 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
 		en_flags |= ENQUEUE_RQ_SELECTED;
 	if (wake_flags & WF_MIGRATED)
 		en_flags |= ENQUEUE_MIGRATED;
-	else if (p->in_iowait) {
-		delayacct_blkio_end(p);
-		atomic_dec(&task_rq(p)->nr_iowait);
-	}
 
 	activate_task(rq, p, en_flags);
 	wakeup_preempt(rq, p, wake_flags);
@@ -4419,11 +4425,6 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 
 		cpu = select_task_rq(p, p->wake_cpu, &wake_flags);
 		if (task_cpu(p) != cpu) {
-			if (p->in_iowait) {
-				delayacct_blkio_end(p);
-				atomic_dec(&task_rq(p)->nr_iowait);
-			}
-
 			wake_flags |= WF_MIGRATED;
 			psi_ttwu_dequeue(p);
 			set_task_cpu(p, cpu);
@@ -6766,6 +6767,12 @@ static bool try_to_block_task(struct rq *rq, struct task_struct *p,
 
 	p->is_blocked = 1;
 
+	if (p->in_iowait) {
+		p->iowait_cpu = cpu_of(rq);
+		atomic_inc(&rq->nr_iowait);
+		delayacct_blkio_start();
+	}
+
 	/*
 	 * We check should_block after signal_pending because we
 	 * will want to wake the task in that case. But if
@@ -6938,7 +6945,7 @@ find_proxy_task(struct rq *rq, struct task_struct *donor, struct rq_flags *rf)
 		if (!mutex) {
 			clear_task_blocked_on(p, mutex);
 			if (task_current(rq, p)) {
-				p->is_blocked = 0;
+				unblock_task(p);
 				return p;
 			}
 			goto deactivate;
@@ -6974,7 +6981,7 @@ find_proxy_task(struct rq *rq, struct task_struct *donor, struct rq_flags *rf)
 			 */
 			__clear_task_blocked_on(p, NULL);
 			if (task_current(rq, p)) {
-				p->is_blocked = 0;
+				unblock_task(p);
 				return p;
 			}
 			goto deactivate;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8d805aa7c85dc..d798bc63dfa5b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3082,11 +3082,6 @@ static inline void __block_task(struct rq *rq, struct task_struct *p)
 	if (p->sched_contributes_to_load)
 		rq->nr_uninterruptible++;
 
-	if (p->in_iowait) {
-		atomic_inc(&rq->nr_iowait);
-		delayacct_blkio_start();
-	}
-
 	ASSERT_EXCLUSIVE_WRITER(p->on_rq);
 
 	/*
-- 
2.53.0



