Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064049;
	b=teWE/kOwD06nACFMNg/Og+/mIALb3Heo1AcPNCaq8Hc28ugnR/E6eTgP+9xtOSwiCc8k
	 XlV/yWYy3SQs6/uzYG6+kZxmRADBb0gnMCKQZG6R/TyeKNfxB5Y39QsCC8gkP9YDQp0tJ
	 7qFVdHPE8/azBlsB+3YDMgeNh/2Qn4YrrlwNePF9Q0QfXDqVGSUaQCAY8N0FHQh3Wq3qY
	 xaVPBgNOLyodAXiGKfRrG2TZMJMmDnjfufOw2xIhou0GSbkVAnjvdK73JC4fovA2gf9JT
	 U8/WSEuF14eyziq0/aCOsYTb8gspiw0N6c05cpXCE8LMwBIkWHXObHotUkBUtiHAyUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HlSQLEG39l12bWaX49N0MXvm5s8vhgxsGa5WOVmaklY=;
	b=JfvhbULvPqtcMG5mWJI8TTfbAmkYEaSVsQ7NYXjAj6kfIyCCS+RvpQp3N6M0uzqCiIyX
	 o2jAhDybwbYqKQPhta5asD66mKnrrly6q86zHeI68Fi2zZhbG1BeXoumykEGZ6cowNt7E
	 FILaNEWmAIFKng0xfgOElIm8aFT8AgwHJRAmZ+2w7sbKriq2/fSBQO7JG9L1MTKfHHYPf
	 v8BuE0ALbvFz9AydqI7eZxmkLYa1cP+Q8mrT+kLUOZCL+SeHIaIapwHj+v1+d+9BloK7A
	 aebcrrgNcQuJHiIQCTnXgqOlFyz27pCZtweFqRT56Kt29FJJraB2eOWGohgULljfH1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohmdlwiC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DECA606C005;
	Sat,  7 Nov 2026 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohmdlwiC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F791F008A2;
	Sat,  7 Nov 2026 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064049;
	bh=HlSQLEG39l12bWaX49N0MXvm5s8vhgxsGa5WOVmaklY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohmdlwiC6QyWWaAiCuqH1SiH2ZpH5yFA18Z9sPQkypYHSDZPxshvI80eawxSKEgI1
	 oRjCC1o1XWC4a3dmYsgjiM9dk2L7h6EnN+/Mdku8N6hGBL6PR3yZwW/VKWQqtLu7Q8
	 VxZKy8gSbVJlE+4XD0m+UbMR9SevBJHMyLPzGcn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com,
	Kusaram Devineni <kusaram@devineni.in>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0222/1257] signalfd: dont dequeue the forced fatal signals
Date: Sat,  7 Nov 2026 08:41:58 -0500
Message-ID: <20261107134945.663060679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit d72e0fb3b00c6a1146bcfd7186ad9f6f609ba236 ]

These signals should act like SIGKILL, in that userspace must never dequeue
them. But as Kusaram explains, io_uring-driven signalfd_read_iter() called
from get_signal() -> task_work_run() paths can do this before get_signal()
has a chance to dequeue such a signal and notice SA_IMMUTABLE.

Change signalfd_poll() and signalfd_dequeue() to add pending SA_IMMUTABLE
signals to ctx->sigmask.

TODO: we should probably change force_sig_info_to_task(HANDLER_EXIT) to
make fatal_signal_pending() true, or add a fatal_or_forced_signal_pending()
helper. Then signalfd_dequeue() could just return -EINTR in this case.
This also makes sense for get_signal(), which could prioritize a fatal
signal sent by (say) force_sig_seccomp(force_coredump => true), just like
it already prioritizes SIGKILL.

Cc: stable@kernel.org
Reported-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
Tested-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/69d122fd.050a0220.2dbe29.001c.GAE@google.com/
Suggested-by: Kusaram Devineni <kusaram@devineni.in>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Link: https://patch.msgid.link/adO3HG8bvwRPcmte@redhat.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/signalfd.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index dff53745e3524..22bc0870a824d 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -48,17 +48,30 @@ static int signalfd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static void refine_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
+{
+	struct k_sigaction *k = current->sighand->action;
+	int n;
+
+	*sigmask = ctx->sigmask;
+	for (n = 1; n <= _NSIG; ++n, ++k) {
+		if (k->sa.sa_flags & SA_IMMUTABLE)
+			sigaddset(sigmask, n);
+	}
+}
+
 static __poll_t signalfd_poll(struct file *file, poll_table *wait)
 {
 	struct signalfd_ctx *ctx = file->private_data;
 	__poll_t events = 0;
+	sigset_t sigmask;
 
 	poll_wait(file, &current->sighand->signalfd_wqh, wait);
 
 	spin_lock_irq(&current->sighand->siglock);
-	if (next_signal(&current->pending, &ctx->sigmask) ||
-	    next_signal(&current->signal->shared_pending,
-			&ctx->sigmask))
+	refine_sigmask(ctx, &sigmask);
+	if (next_signal(&current->pending, &sigmask) ||
+	    next_signal(&current->signal->shared_pending, &sigmask))
 		events |= EPOLLIN;
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -155,11 +168,13 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 				int nonblock)
 {
 	enum pid_type type;
-	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
+	sigset_t sigmask;
+	ssize_t ret;
 
 	spin_lock_irq(&current->sighand->siglock);
-	ret = dequeue_signal(&ctx->sigmask, info, &type);
+	refine_sigmask(ctx, &sigmask);
+	ret = dequeue_signal(&sigmask, info, &type);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
@@ -174,7 +189,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(&ctx->sigmask, info, &type);
+		ret = dequeue_signal(&sigmask, info, &type);
 		if (ret != 0)
 			break;
 		if (signal_pending(current)) {
@@ -184,6 +199,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 		spin_unlock_irq(&current->sighand->siglock);
 		schedule();
 		spin_lock_irq(&current->sighand->siglock);
+		refine_sigmask(ctx, &sigmask);
 	}
 	spin_unlock_irq(&current->sighand->siglock);
 
-- 
2.53.0



