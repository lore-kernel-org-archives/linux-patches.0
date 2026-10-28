Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214672;
	b=ZxGrZlcIvXug+8C7S9nete1XBiN1a1CsVuOhXNZ5AgXHj2HZHxM4OxF3yBUIBIFauemY
	 T3YdQ8NGmQjfT+hx1CD0I34LXxJFUBHuk+pobzVjaYATDvTJmc2ivG+w8SucZc1h3N1U2
	 p5jsBgc+ceblNfpoIwc9F0HezL7Wb898inapHp044CjfDEfiy/3dM8vzwO8PIc4IyzpSI
	 rwUhFA+kVUjGRbaD6j35ItMzW9dW4PQQa2N0dn/0RaUhBAbgjwklBo4JHt1mjs3c44Ejs
	 l0a33PXNFN40z6vSywCvMoqAg6+j90rR4CyaPP8ilMydcyg3gl9zuK7x6GQZAzWmV6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUp0e+lhienAE5Kl0CO9edKc8FGaDh5BB2ZgD9eddCY=;
	b=iLrq7zWKCDlpu0XeP9ont9W3GCXHa/cEy5xIXy4aoJJ2pqrUjcdW7zH3eOZmMubQCvWL
	 xeV0pFgdJKxW3HysG2TdD2d182x+WKJADGu2K9UM+TPWYSe4vBNk9CRVKrALFsKj+1fPs
	 +2uXs/f+fJDzCdCjS7ePM7zpcSvJ1viGmcV5d48eDC0De0Qcx6twyCgZTLd0cbime7b3i
	 ycvXbOdlFqV9M3TVmU5EdNYAaYOEofq9rkVTfofQqkrvGvjqrQczeBP8yKIcvp1D5UEEt
	 nhUxUiogDoUHj5b3CxxNMg7bw18S7s2NkQB/mOMLnMrshf1xcHWM5sx2VfPKQnJz4dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EpK/bN3T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADBB606B7CF;
	Wed, 28 Oct 2026 19:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpK/bN3T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD581F01825;
	Wed, 28 Oct 2026 19:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214671;
	bh=nUp0e+lhienAE5Kl0CO9edKc8FGaDh5BB2ZgD9eddCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpK/bN3TvTMbetg85351I317dwdixAw3YXB4ORIjBOe0N0MosnvwNyjPyOLPDGLab
	 J7WN54i3SYArPbHs87Qmd35Edb4bi7jRs8v/Vt3PZDhMcanTznXG1IbVDhZzjFO0az
	 ecHVH4/JzGFd1hFf4gBPuRzHYdKkEYRjXTEs8K50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Goncalves <bgoncalv@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0939/1887] sched/deadline: Fix missing ENQUEUE_REPLENISH during PI de-boosting
Date: Wed, 28 Oct 2026 17:50:35 +0100
Message-ID: <20261028170520.780227431@linuxfoundation.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit d658686a1331db3bb108ca079d76deb3208ed949 ]

Running stress-ng --schedpolicy 0 on an RT kernel on a big machine
might lead to the following WARNINGs (edited).

 sched: DL de-boosted task PID 22725: REPLENISH flag missing

 WARNING: CPU: 93 PID: 0 at kernel/sched/deadline.c:239 dequeue_task_dl+0x15c/0x1f8
 ... (running_bw underflow)
 Call trace:
  dequeue_task_dl+0x15c/0x1f8 (P)
  dequeue_task+0x80/0x168
  deactivate_task+0x24/0x50
  push_dl_task+0x264/0x2e0
  dl_task_timer+0x1b0/0x228
  __hrtimer_run_queues+0x188/0x378
  hrtimer_interrupt+0xfc/0x260
  ...

The problem is that when a SCHED_DEADLINE task (lock holder) is
changed to a lower priority class via sched_setscheduler(), it may
fail to properly inherit the parameters of potential DEADLINE donors
if it didn't already inherit them in the past (shorter deadline than
donor's at that time). This might lead to bandwidth accounting
corruption, as enqueue_task_dl() won't recognize the lock holder as
boosted.

The scenario occurs when:
1. A DEADLINE task (donor) blocks on a PI mutex held by another
   DEADLINE task (holder), but the holder doesn't inherit parameters
   (e.g., it already has a shorter deadline)
2. sched_setscheduler() changes the holder from DEADLINE to a lower
   class while still holding the mutex
3. The holder should now inherit DEADLINE parameters from the donor
   and be enqueued with ENQUEUE_REPLENISH, but this doesn't happen

Fix the issue by introducing __setscheduler_dl_pi(), which detects when
a DEADLINE (proper or boosted) task gets setscheduled to a lower
priority class. In case, the function makes the task inherit DEADLINE
parameters of the donoer (pi_se) and sets ENQUEUE_REPLENISH flag to
ensure proper bandwidth accounting during the next enqueue operation.

Fixes: 2279f540ea7d ("sched/deadline: Fix priority inheritance with multiple scheduling classes")
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260302-upstream-fix-deadline-piboost-b4-v3-1-6ba32184a9e0@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fa9008e5d8bd6..7494e05bbdc81 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7368,6 +7368,33 @@ static struct task_struct *find_process_by_pid(pid_t pid)
  */
 #define SETPARAM_POLICY	-1
 
+#ifdef CONFIG_RT_MUTEXES
+static inline void __setscheduler_dl_pi(int newprio, int policy,
+			      struct task_struct *p, int *queue_flags)
+{
+	/*
+	 * In case a DEADLINE task (either proper or boosted) gets
+	 * setscheduled to a lower priority class, check if it neeeds to
+	 * inherit parameters from a potential pi_task. In that case make
+	 * sure replenishment happens with the next enqueue.
+	 */
+
+	if (dl_prio(newprio) && !dl_policy(policy)) {
+		struct task_struct *pi_task = rt_mutex_get_top_task(p);
+
+		if (pi_task) {
+			p->dl.pi_se = pi_task->dl.pi_se;
+			*queue_flags |= ENQUEUE_REPLENISH;
+		}
+	}
+}
+#else /* !CONFIG_RT_MUTEXES */
+static inline void __setscheduler_dl_pi(int newprio, int policy,
+			      struct task_struct *p, int *queue_flags)
+{
+}
+#endif /* !CONFIG_RT_MUTEXES */
+
 static void __setscheduler_params(struct task_struct *p,
 		const struct sched_attr *attr)
 {
@@ -7669,6 +7696,7 @@ static int __sched_setscheduler(struct task_struct *p,
 	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS)) {
 		__setscheduler_params(p, attr);
 		__setscheduler_prio(p, newprio);
+		__setscheduler_dl_pi(newprio, policy, p, &queue_flags);
 	}
 	__setscheduler_uclamp(p, attr);
 
-- 
2.53.0



