Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617602;
	b=L4taBYMBwYw30aTh4ZrWmJ22r2HWx4qahujC+FpHEvMPmk9GdDXcisqE3UOb4GKFV53o
	 sMcqr5XeXWYgopi5ySwKRrGB9stoS7uA5J4ecTAWdRqqsC6oNsx0KH/8m+kM84eDYpEe1
	 v6iNk3jxWODtqENXihJIJ1GkFJBs2tLwQBnXQnMsnxueAUfMMLo6zZiGLkF1glHqjGmQC
	 ryQXA5JjbpbS0tB3pePqvBOUSvilKIp5tY4SyxB8Sq+CX5won8y0G7fmEKFgMpLAVHAgU
	 8Dbzl6gZX5/IfHGuNC2t7ieiTIxtla21ThRXtNbEoVX9EJQLNeXSxBJJKnlTRwxGGhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DTrF44VUnvKAx5fWKT602HBU7NPjZjhrZm0YL29DITY=;
	b=dR/hEiIBxwy0nr5973o7+MUWiFQQBh+uaDxh9wfr3ybOlNEu/5zSFcDsfyIQkPRpUruZ
	 SZGM+VOxN/2ha/aW9UqNTYrULLAdwK9vubiloHcNu5xukkpxktW4UCUewjgfOoPHp3bar
	 LoDF1N2GWWLTOoGycRf/kz6L8fd4mvUP9MNKUGldz6rNH7fCaCy+svAH9xMsUnGEoH9Be
	 6AeGhdpRuzqfJyWMeee5fUizmNhex0m4Towj7vnS0o9/8l36k/o7yZYv+bjh34ACLonqs
	 vgW6eflwZ81Fw5CZSI7dxMmwI1TyaraT2c9enej9rALyNHcG4Q/HzEUOaUKCuzJhBPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xB+TIxTy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6734606A31E;
	Wed, 25 Nov 2026 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xB+TIxTy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D251F000C0;
	Wed, 25 Nov 2026 14:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617602;
	bh=DTrF44VUnvKAx5fWKT602HBU7NPjZjhrZm0YL29DITY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xB+TIxTyL4o/mMLRqNg92S/QEwe//cJRVY3BwRTh/7107Z2N06bi2OqoLIVDyGXuu
	 YdRD0ajEmg1zyNs0OeCA26v9/mOWW0QOLxMTPuv8h1/m6xL2OIn/b+ImhN8szGSbZE
	 qg6KFZH1+550b8wTRMWXcR3qrDcJIvB35WawKRx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b0d54b9e81de55179e47@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0018/1005] io_uring/io-wq: show stuck workers rather than WARN on a slow exit
Date: Wed, 25 Nov 2026 15:22:36 +0100
Message-ID: <20261125143822.163412495@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit d4912d6440bf6d255e1fa1c360c8ddb39d0e01bd upstream.

io_wq_exit_workers() triggers a WARN_ON_ONCE() if it has waited more than
IO_URING_EXIT_WAIT_MAX for the workers to exit. That can be triggered at
will, for example with an open on a FUSE mount where the server never
replies to the lookup. The worker can't be canceled, and the exit waits
until the server goes away.

The stack trace from the WARN isn't useful either, as it's that of the
exiting task and that is always the task exit, exec, or SQPOLL thread
exit path. Print a message and show the workers that are still around
instead, that's where the interesting stack traces are.

Reported-by: syzbot+b0d54b9e81de55179e47@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 6b93950602621..358f32888a853 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/debug.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/rculist_nulls.h>
@@ -1444,6 +1445,22 @@ static void io_wq_cancel_tw_create(struct io_wq *wq)
 	}
 }
 
+static bool io_wq_worker_show(struct io_worker *worker, void *data)
+{
+	sched_show_task(worker->task);
+	return false;
+}
+
+/* The exit path is always the same, show what the workers are stuck on */
+static void io_wq_show_stuck_workers(struct io_wq *wq)
+{
+	pr_warn("io-wq: %s/%d stuck waiting for workers to exit\n",
+		current->comm, task_pid_nr(current));
+	rcu_read_lock();
+	io_wq_for_each_worker(wq, io_wq_worker_show, NULL);
+	rcu_read_unlock();
+}
+
 static void io_wq_exit_workers(struct io_wq *wq)
 {
 	unsigned long timeout, warn_timeout;
@@ -1465,8 +1482,8 @@ static void io_wq_exit_workers(struct io_wq *wq)
 	 *
 	 * where completely overloading the system with tons of long running
 	 * io-wq items can easily trigger the hung task timeout. Only sleep
-	 * uninterruptibly for half that time, and warn if we exceeded end
-	 * up waiting more than IO_URING_EXIT_WAIT_MAX.
+	 * uninterruptibly for half that time, and show the stuck workers if
+	 * we end up waiting more than IO_URING_EXIT_WAIT_MAX.
 	 */
 	timeout = sysctl_hung_task_timeout_secs * HZ / 2;
 	if (!timeout)
@@ -1475,7 +1492,8 @@ static void io_wq_exit_workers(struct io_wq *wq)
 	do {
 		if (wait_for_completion_timeout(&wq->worker_done, timeout))
 			break;
-		WARN_ON_ONCE(time_after(jiffies, warn_timeout));
+		if (time_after(jiffies, warn_timeout))
+			DO_ONCE_LITE(io_wq_show_stuck_workers, wq);
 	} while (1);
 
 	spin_lock_irq(&wq->hash->wait.lock);
-- 
2.53.0



