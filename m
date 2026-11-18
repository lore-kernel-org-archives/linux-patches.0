Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018999;
	b=JnEpo7YJtLPuKjvL48GCMlyp5e9HZujcZYQXoqbzdWcjqAA2fZpW672mMOGdk1NzKeu4
	 VLv+qDl9m5kMSt4mD7BqPdQPovGbQb34mEt9ivrXebkNZf1f7XQpZNhBmwDn2g2937imq
	 meyyokn4CDOtgzteyrHbRrNYZHbt4uhSHby4JyDbeVcI5d6Zj+nLyIL7Y01bk4Bm3KcMH
	 8HBqQ2UEVDRcrb0r3FrsPUFIxMo0Q8hcpe5LTLmMGCbpZzLk5w3vfaf3CSH4u3KqseiZV
	 74cUlxPnxHL+flePyA1vZlYIToSbCL6rp3hzh1/FxWIhDYN6eF6zoApczl635djXOcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9YgJxQtFzPunXTGJzBYV/sgObgCkRuu0wAnTOrTS53M=;
	b=DDN5E9qxn3tuU6EWzR2p+WIdSNyRTf18jrGS5RNER+jPBzTmdUdVSKIfMroM6LQ8Z7IZ
	 jxOygG9PEzp2BJgDsT/arMzn9N8v9XWhrAjZPsckwh1giC0Uwm2fErnLlYMQWnfs40xvW
	 hoQdQPywPWv3q0zdZpnKZWAjQDQL4BM5rEBKEgRJPkYXeOXPP26Y+5fciWNxoxNMx4BGr
	 X56EixNldV7s2EnmOF9Tyiprx98k4o57QgGS5XuOj0VKUVrlvem83jPw0Ptf/FYu9ClT2
	 bt0PVO52ooIlXE+BKvSOaoCfkrp0YPUi/Z7bkTKQBbf7lsiuN5FiK8U8T6m6bFcc5YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNOhROfP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D0D606A31C;
	Wed, 18 Nov 2026 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNOhROfP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFBF1F000C5;
	Wed, 18 Nov 2026 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018998;
	bh=9YgJxQtFzPunXTGJzBYV/sgObgCkRuu0wAnTOrTS53M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNOhROfPrPexiPXbZxV6h65/IyDNkEcHAmzoE8lSmQSfd7GBevOSchvcHzk8VmMaN
	 Let6+CPaTtV1chh4Fhasr7cTBwNx79KyXTeAfElzTb8rJx/Ke6G7uRLm7XuDvWfVgp
	 2K/lDPgHT1txCDs7nhV2DYE3cxLd9SCvdZRNpXl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1398/2651] proc: report SIGEV_NONE in /proc/pid/timers if target task has died
Date: Wed, 18 Nov 2026 15:43:58 +0100
Message-ID: <20261118150338.340111861@linuxfoundation.org>
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
index 6a39de424f62a..1455de58e53cf 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2519,17 +2519,23 @@ static int show_timer(struct seq_file *m, void *v)
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



