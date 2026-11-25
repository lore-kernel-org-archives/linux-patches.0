Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625443;
	b=JNMnVQJWV1X1NBOP94TF48M9S4jh1P2lFsfVnflGGAxZ9yl/fkpH1Ncgamzby8sblj49
	 dV18fithxB+qSYw9o7DJ1EHsWblyAHlVfmH3oDjnAQuxQJtxTF8cjG3NeI5ja7EyPP3AF
	 0+e0itWnbijWDGIjZNOvXTOzfDUI3IXxATVYkiR3bXp4hWB+ManLeqf+3fEK0XDA7exCh
	 XnxKN3BEbsFhx8Z3eq4y7IGCwh0B5MB2hiZU4AW1qmxJ+KOTENu1pGc4FdWPwQPs8Y9kU
	 xBkL/QjoLIURDxDAKvgxpTSCDSLFw/6h8PsgSQUq1+AUEfYovml5txC2DvBSKx6qm6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Ad9yKs/8i5D1PWRXvfLjDAyEteK0gC0e14t5D+3qPI=;
	b=EtFLZktSgHkTQwgHmfiGscAqDX5iF211krib5QDUPfsFP+4bIFwxUik3WjTeu0PQAq4s
	 bJXl1u1rUNn9Gwu8A94EaCiUw/h2ROu4Vpam3fbzv0aUuIDUKWLTJqhJW9xrBLi21kDkY
	 DDpinSBMx7zwmwROvSyX7aAtKWBrWv8epArlr+nwcIxSfzBLhB+Hkhh5a3PkPAo4c5B6n
	 ZKK3S9haxOYcK8CDKVb8OFfZXaA1ZWtY1W/FG5PXFUht9wHY/OOvw60T7+3733k0sr9ms
	 MmGu/GDB5rP8gzqlGsRHiAiASX8tgkcip2aQSrpp6/RjENrCDn65G+Kzj+3TFNMBKxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZQjxP58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D27B606A321;
	Wed, 25 Nov 2026 16:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZQjxP58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF2A1F000CF;
	Wed, 25 Nov 2026 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625442;
	bh=6Ad9yKs/8i5D1PWRXvfLjDAyEteK0gC0e14t5D+3qPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZQjxP58kZivRmmpAqLNThkiF6O0xhbreUDs0A6PlBM2ld6pSm6Uu7V8IcSwvqw6V
	 V60CIA7/w0f0mzGcdWGIrvO/D3fTWfHt7AxIBP4TkuPkMwWg+JKJ9sxIGLjGAqNVak
	 K2x5akuae6v6TikzQRk162psmk3NxxpfTVUVgkX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 463/816] proc: report SIGEV_NONE in /proc/pid/timers if target task has died
Date: Wed, 25 Nov 2026 15:33:31 +0100
Message-ID: <20261125143859.917569707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Replaced the missing it_pid_type field with (notify & SIGEV_THREAD_ID) ? PIDTYPE_PID : PIDTYPE_TGID and adapted to the local show_timer() layout, without the guard() lock or posixtimer_valid(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 427fb5abb07c7..0f58fe8697c4e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2527,6 +2527,7 @@ static int show_timer(struct seq_file *m, void *v)
 	struct k_itimer *timer;
 	struct timers_private *tp = m->private;
 	int notify;
+	pid_t nr = 0;
 	static const char * const nstr[] = {
 		[SIGEV_SIGNAL] = "signal",
 		[SIGEV_NONE] = "none",
@@ -2536,6 +2537,13 @@ static int show_timer(struct seq_file *m, void *v)
 	timer = hlist_entry((struct hlist_node *)v, struct k_itimer, list);
 	notify = timer->it_sigev_notify;
 
+	if (timer->it_pid &&
+	    pid_has_task(timer->it_pid,
+			 (notify & SIGEV_THREAD_ID) ? PIDTYPE_PID : PIDTYPE_TGID))
+		nr = pid_nr_ns(timer->it_pid, tp->ns);
+	else
+		notify = SIGEV_NONE;
+
 	seq_printf(m, "ID: %d\n", timer->it_id);
 	seq_printf(m, "signal: %d/%px\n",
 		   timer->sigq->info.si_signo,
@@ -2543,7 +2551,7 @@ static int show_timer(struct seq_file *m, void *v)
 	seq_printf(m, "notify: %s/%s.%d\n",
 		   nstr[notify & ~SIGEV_THREAD_ID],
 		   (notify & SIGEV_THREAD_ID) ? "tid" : "pid",
-		   pid_nr_ns(timer->it_pid, tp->ns));
+		   nr);
 	seq_printf(m, "ClockID: %d\n", timer->it_clock);
 
 	return 0;
-- 
2.53.0



