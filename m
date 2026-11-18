Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018126;
	b=4w/TszD19DX4zY1pheN/AepUS6C/Q2C/RDBFf0df2Ml3iaAP/h4bIvXdXyBAQwACRJMU
	 3SGMw+z+mYPSZqrtbY2KKf9nBYVsI1/x18sirAmouTgpTE9JeqdkenilKRKDj45xvKu+F
	 9omXettfYtXVXP3RvYTOiQUftS/cVWOie59CY5Wg0E5JWwWfCyIcpxow5j9Vz+Fhr+3ul
	 qLZohy43HqTjxHdlxqy7ouJwPM/J+SQSHyGic6yGdO2iUUJ1bwZzv6fg1oCyrng7ntqW7
	 t5QvTfAmhBjpZUdL/y5R63A5ZOvZplXM+ghYQeCqTK+pmrffcN/orB1YX6k0qERzHog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LOJmLpPY4utTi0ybKnRjXRiXryigQTdOrWOWbm6wOFQ=;
	b=KIGgrJjfwrHpz+DsFHCYnsAY364jJmUBnbWWNDQlHqDu5UQwC78O4+iIuCf9hgGzKBnL
	 8BIZssOJA0HuKrxsSG9xCHowNnaEd+AIP6+yU06cFhTppZBhiggTbkQV1d0gvJinS7eKX
	 A7oyDVr3AOgH3LmVqY3kgZiQ87/OVIftGAntRwGw0PrgAF/QWInxiXbnmiw3KjPF9ht9L
	 MBqp4XdrQ+j/Tgg5N8XCJ2OjD5Y9xNHl/I16ZgL/J70lQH55p5WT9kU9Bd+3fQh02T4Cz
	 72ikn7hO9hefrFEjy8yT00QMIr9/n23AVuJzn9u4txBmR/9lT7myY8EPTE+fGQUzZow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jJCmv/lI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BAE606A32C;
	Wed, 18 Nov 2026 16:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJCmv/lI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53821F000C4;
	Wed, 18 Nov 2026 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018126;
	bh=LOJmLpPY4utTi0ybKnRjXRiXryigQTdOrWOWbm6wOFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJCmv/lIbph3vpaThNdMeOvOqCPbuBr6J/KWIo8EFFcRB8OmaPEoXTAtY61hLNIZd
	 lTdHpn6rVWGoO+IGGooxHHbowPYORUxLcxiSg5KSHmFrsweADtWuVJ1EKeJABRZx4V
	 V7cK4qw2rwSuBWdVMzygGwXXL6mdna9PeVyEV9fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrea Righi <arighi@nvidia.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1115/2651] sched: Set TIF_NEED_RESCHED before calling __trace_set_need_resched()
Date: Wed, 18 Nov 2026 15:39:15 +0100
Message-ID: <20261118150328.146596494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit 53bc5c556b82a3ca32b62ba349c4511f91526b9f ]

set_tsk_need_resched() tests TIF_NEED_RESCHED, calls
__trace_set_need_resched() if the flag is clear, then sets it via
set_tsk_thread_flag().  A BPF raw_tp program attached to
sched_set_need_resched executes synchronously inside __bpf_trace_run().
On return, __bpf_trace_run() drops the RCU lock with
rcu_read_unlock_migrate(), which on the preempt-or-BH-disabled path
calls set_need_resched_current() -> set_tsk_need_resched() again.

set_tsk_thread_flag() follows the tracepoint call, so every re-entrant
frame sees TIF_NEED_RESCHED clear and calls __trace_set_need_resched()
again:

  BUG: TASK stack guard page was hit at ffffc9001224ff98
  Oops: stack guard page: 0000 [#1] SMP KASAN PTI
  RIP: 0010:__bpf_trace_sched_set_need_resched_tp+0x1c/0x190
  Call Trace:
   trace_sched_set_need_resched_tp+0x110/0x130
   set_tsk_need_resched include/linux/sched.h:2076
   set_need_resched_current include/linux/sched.h:2094
   rcu_read_unlock_special+0x43a/0x440
   __rcu_read_unlock+0x9e/0x120
   rcu_read_unlock_migrate+0xa9/0x240
   __bpf_trace_run+0x131/0x180
   bpf_trace_run3+0x333/0x430
   __bpf_trace_sched_set_need_resched_tp+0x13a/0x190
   trace_sched_set_need_resched_tp+0x110/0x130
   set_tsk_need_resched include/linux/sched.h:2076
   ...

__resched_curr() has the same ordering, firing the tracepoint before
setting the flag via set_ti_thread_flag() or set_nr_and_not_polling().
Fix it for consistency.

Replace the separate test_tsk_thread_flag() + set_tsk_thread_flag() pair
in set_tsk_need_resched() with test_and_set_tsk_thread_flag().  In
__resched_curr(), move the tracepoint call after the flag is set in
each path.

Fixes: adcc3bfa8806 ("sched: Adapt sched tracepoints for RV task model")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Acked-by: Gabriele Monaco <gmonaco@redhat.com>
Link: https://patch.msgid.link/20260630084750.2792851-1-rhkrqnwk98@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 5 ++---
 kernel/sched/core.c   | 7 +++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78bfc0e32e56f..09d90f5edd2bf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2105,10 +2105,9 @@ static inline int test_tsk_thread_flag(struct task_struct *tsk, int flag)
 
 static inline void set_tsk_need_resched(struct task_struct *tsk)
 {
-	if (tracepoint_enabled(sched_set_need_resched_tp) &&
-	    !test_tsk_thread_flag(tsk, TIF_NEED_RESCHED))
+	if (!test_and_set_tsk_thread_flag(tsk, TIF_NEED_RESCHED) &&
+	    tracepoint_enabled(sched_set_need_resched_tp))
 		__trace_set_need_resched(tsk, TIF_NEED_RESCHED);
-	set_tsk_thread_flag(tsk,TIF_NEED_RESCHED);
 }
 
 static inline void clear_tsk_need_resched(struct task_struct *tsk)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 174b6b2331744..025ed33aa5600 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1196,6 +1196,7 @@ static void __resched_curr(struct rq *rq, int tif)
 {
 	struct task_struct *curr = rq->curr;
 	struct thread_info *cti = task_thread_info(curr);
+	bool need_ipi;
 	int cpu;
 
 	lockdep_assert_rq_held(rq);
@@ -1212,15 +1213,17 @@ static void __resched_curr(struct rq *rq, int tif)
 
 	cpu = cpu_of(rq);
 
-	trace_sched_set_need_resched_tp(curr, cpu, tif);
 	if (cpu == smp_processor_id()) {
 		set_ti_thread_flag(cti, tif);
 		if (tif == TIF_NEED_RESCHED)
 			set_preempt_need_resched();
+		trace_sched_set_need_resched_tp(curr, cpu, tif);
 		return;
 	}
 
-	if (set_nr_and_not_polling(cti, tif)) {
+	need_ipi = set_nr_and_not_polling(cti, tif);
+	trace_sched_set_need_resched_tp(curr, cpu, tif);
+	if (need_ipi) {
 		if (tif == TIF_NEED_RESCHED)
 			smp_send_reschedule(cpu);
 	} else {
-- 
2.53.0



