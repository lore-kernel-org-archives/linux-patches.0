Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025729;
	b=q6CD+zkD9r4AlZXupAW9NMf5XsBy7NHPNHO4f4Pnd+TV4LmQhsimp8jij2qQBhQDsIcd
	 WMZG7XmSbvQ8LsFo0MU73V4VPaqU72xTWszXvSxJI2H6GbqN+ldri/3hXT692zaOBbaMD
	 uQL+Pr3J0BXuwsNvd9StIOZJ435xny50Q561z5f/azkT9H3nMZr7iQ8DNajDslNXS/CBI
	 1EznTyIIBFow2T9bbFosRIgfyW1qMS7+cXRmmeJykpYo6FrApRsDsODrqJkrnO0GCk16X
	 sfDi449Xnko+BezWkXkN8S6bDS2q5RDqy+tXwsQdm6WPlld0ngD+qxoCHJXqnfZ+KQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9gJoFO2FYlStIGGQAmCRdhiIcV87HWDuzRTqOVl2qSc=;
	b=QwOp2kYB39ormDzJzZlWCmlDCFymz88LmaEmY6sjTV+TOJ3WvRt4zPD4uhkUHN6Xs2wG
	 j5EPwVc52xw7hYwE8rm+vA3zt/7hwCYG0QBRDYsIU/EmJ+WNB9NIn5fqKJ4AT9CacEXwO
	 Zy8yaHz63EkKmkB2JqtL8nHQV9nZbJjcNnY3qfp88D+1JvYU8RcFOlE5Ghi6vnlFNd2r1
	 B8RGFfv7p2bX4YMPgbfbaKg8tUxdkhD1iTIiZwOaDu8e7/RnxS1uxkYj2gWHROg/TlYOi
	 cyKNozvhetFFHhxcHezTJDzIVnzr2E1MkWKWBv6FzM15IUyn+/q/tplZHMYqgZ8SVCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVhnWuFZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B4B606A325;
	Wed, 18 Nov 2026 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVhnWuFZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFA71F000C4;
	Wed, 18 Nov 2026 18:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025729;
	bh=9gJoFO2FYlStIGGQAmCRdhiIcV87HWDuzRTqOVl2qSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVhnWuFZWptB16wdvKtmEkWR7lvLtvnrHQSqqAQppW3SNk+GgjCjZGCGw3QGP7+ua
	 suvnbXIalFhul+ucdt7T9r3mO1F/xAaGiKfLXlE7fjkJ+WBBMmQv9thy0r0Pi/qWCy
	 Q+9oXQHrHh41eODp/d9XxtXU0VcQij0uoUYq5Kac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1181/2151] proc: report SIGEV_NONE in /proc/pid/timers if target task has died
Date: Wed, 18 Nov 2026 15:48:36 +0100
Message-ID: <20261118150205.147774506@linuxfoundation.org>
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

From: Andrei Vagin <avagin@google.com>

[ Upstream commit 0a27f795030ce6a2c71525b0544e3b13bba8828e ]

When a posix timer is created targeting a specific thread (using
SIGEV_SIGNAL | SIGEV_THREAD_ID), it takes a reference to the target struct
pid in timer->it_pid.  If the target thread subsequently terminates, its
numeric tid is freed and can be recycled for an unrelated task.  However,
the timer holds its reference to the original struct pid.

show_timer() in /proc/[pid]/timers previously called pid_nr_ns() directly
on timer->it_pid without checking whether any task remained attached to
that struct pid.  As a result:

1. It reported the stale tid, which could mistakenly refer to a recycled
   pid.

2. In the kernel, expired signals for dead target threads are dropped by
   posixtimer_send_sigqueue() because posixtimer_get_target() returns
   NULL, so the timer functionally acts as SIGEV_NONE.

3. Checkpoint/restore tools (CRIU) parsing /proc/[pid]/timers would try
   to restore a timer with SIGEV_SIGNAL | SIGEV_THREAD_ID targeting a
   non-existent or unrelated thread.

Check pid_has_task(timer->it_pid, timer->it_pid_type) in show_timer().  If
the target task has died, override notify to SIGEV_NONE and report PID 0
(e.g., 'notify: none/pid.0').

Link: https://lore.kernel.org/20260816161216.984580-1-avagin@google.com
Fixes: 57b8015e07a7 ("posix-timers: Show sigevent info in proc file")
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c8d783f3b2ac6..8480745351605 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2527,17 +2527,23 @@ static int show_timer(struct seq_file *m, void *v)
 	struct k_itimer *timer = hlist_entry((struct hlist_node *)v, struct k_itimer, list);
 	struct timers_private *tp = m->private;
 	int notify = timer->it_sigev_notify;
+	pid_t nr = 0;
 
 	guard(spinlock_irq)(&timer->it_lock);
 	if (!posixtimer_valid(timer))
 		return 0;
 
+	if (timer->it_pid && pid_has_task(timer->it_pid, timer->it_pid_type))
+		nr = pid_nr_ns(timer->it_pid, tp->ns);
+	else
+		notify = SIGEV_NONE;
+
 	seq_printf(m, "ID: %d\n", timer->it_id);
 	seq_printf(m, "signal: %d/%px\n", timer->sigq.info.si_signo,
 		   timer->sigq.info.si_value.sival_ptr);
 	seq_printf(m, "notify: %s/%s.%d\n", nstr[notify & ~SIGEV_THREAD_ID],
 		   (notify & SIGEV_THREAD_ID) ? "tid" : "pid",
-		   pid_nr_ns(timer->it_pid, tp->ns));
+		   nr);
 	seq_printf(m, "ClockID: %d\n", timer->it_clock);
 
 	return 0;
-- 
2.53.0



