Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054080;
	b=LGpae+vYLj5sVrpVcqbQTMf+YNfQoFZkUPx5VyV6aMT7EaMAn7XIJyT1LnENW/R8VLBo
	 KBE6j5pCzHfa87/B2cqayGoGUgsn5s0+U5Ef6JAhN1HQTAqixiYSUIBT8n0C0PSHTANuu
	 77cgfrA2yoY/wxZkHLOSOppdj1+WVBYvz7JnUrqaSjDJ5wHJRqlKI8Pf1YNxHRsyQKoF/
	 h8WJiiU4MvC6ibWahujf47P2R/hr4aeWptjrYcyArgCUQnlc5Y+GbpUEwtDBnauvHw+YD
	 viUbLNfnRQadBEp+GKmuQAAHWD1y0U9GRsxRvnfHD34gfWKqZkDrbH5nVEBFLyKnt6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h5sMmabdZSyALvvuDDNKOBAxOxS1huDtIXjgpfc1cqg=;
	b=l7kMWblkMCUfJkCYPPKSyr+2yY+0zCuTpkZJPtLiG8NbPPBFqS5oAhRhWCXbJr1JV3cG
	 p1HsFl5lue56wa7BOo5tuHuKuFOOZQnvMkFBzdI2oknGwNFasTtowqkjKpQae70TqzWqT
	 Kb2ZN/s/ls8jKlTRsj6jZNMbJJnZ+6UjAhcet4wNxhDAPNTeRYQzEy9ymf0ih9AppQShw
	 NX7Zc8GuEKOiz2SYb3JasJu2EGx4xQvK/MlUcBWBpq2yxhR4aReoFMH+w0DgXhe4+v3HG
	 eV3XuUrvN0rd4xd1rEI9wO0Zrr7pmU0FKYHG+VVP39aLUXQRz7n++SdvNZIWrxLLEgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wc9Oog98;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3B8606A32A;
	Thu, 19 Nov 2026 02:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wc9Oog98
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471F81F000C4;
	Thu, 19 Nov 2026 02:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054079;
	bh=h5sMmabdZSyALvvuDDNKOBAxOxS1huDtIXjgpfc1cqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wc9Oog98IfWtTUtvbGku9Au/3pJpBXWxCtDtQDgLIP8cwrzTdHzN0FBlmP7asLe2h
	 gekrtw7gXyxlHry8opemDR4o+beV5Yi0wC85zeSdYMQ1s3F8hmr1jOSOPIQ8Ppbn56
	 vEVRFUYvdohNT8cx0obgHL8W+Pn8rqwjuYenJYw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1146/2214] signal: Remove task argument from dequeue_signal()
Date: Wed, 18 Nov 2026 15:47:02 +0100
Message-ID: <20261118150057.852680883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit a2b80ce87a87fc18c594e74d13031d5e347b69cb ]

The task pointer which is handed to dequeue_signal() is always current. The
argument along with the first comment about signalfd in that function is
confusing at best. Remove it and use current internally.

Update the stale comment for dequeue_signal() while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Stable-dep-of: d72e0fb3b00c ("signalfd: don't dequeue the forced fatal signals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/signalfd.c                |  4 ++--
 include/linux/sched/signal.h |  5 ++---
 kernel/signal.c              | 23 ++++++++++-------------
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index e20d1484c6633..07cc5f6d3483a 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -160,7 +160,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 	DECLARE_WAITQUEUE(wait, current);
 
 	spin_lock_irq(&current->sighand->siglock);
-	ret = dequeue_signal(current, &ctx->sigmask, info, &type);
+	ret = dequeue_signal(&ctx->sigmask, info, &type);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
@@ -175,7 +175,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(current, &ctx->sigmask, info, &type);
+		ret = dequeue_signal(&ctx->sigmask, info, &type);
 		if (ret != 0)
 			break;
 		if (signal_pending(current)) {
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index d71dc9a933d44..6f105308ab5f0 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -274,8 +274,7 @@ static inline int signal_group_exit(const struct signal_struct *sig)
 extern void flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
-extern int dequeue_signal(struct task_struct *task, sigset_t *mask,
-			  kernel_siginfo_t *info, enum pid_type *type);
+extern int dequeue_signal(sigset_t *mask, kernel_siginfo_t *info, enum pid_type *type);
 
 static inline int kernel_dequeue_signal(void)
 {
@@ -285,7 +284,7 @@ static inline int kernel_dequeue_signal(void)
 	int ret;
 
 	spin_lock_irq(&task->sighand->siglock);
-	ret = dequeue_signal(task, &task->blocked, &__info, &__type);
+	ret = dequeue_signal(&task->blocked, &__info, &__type);
 	spin_unlock_irq(&task->sighand->siglock);
 
 	return ret;
diff --git a/kernel/signal.c b/kernel/signal.c
index 8d711b8a2dd84..d4e477e599385 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -622,20 +622,18 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
 }
 
 /*
- * Dequeue a signal and return the element to the caller, which is
- * expected to free it.
- *
- * All callers have to hold the siglock.
+ * Try to dequeue a signal. If a deliverable signal is found fill in the
+ * caller provided siginfo and return the signal number. Otherwise return
+ * 0.
  */
-int dequeue_signal(struct task_struct *tsk, sigset_t *mask,
-		   kernel_siginfo_t *info, enum pid_type *type)
+int dequeue_signal(sigset_t *mask, kernel_siginfo_t *info, enum pid_type *type)
 {
+	struct task_struct *tsk = current;
 	bool resched_timer = false;
 	int signr;
 
-	/* We only dequeue private signals from ourselves, we don't let
-	 * signalfd steal them
-	 */
+	lockdep_assert_held(&tsk->sighand->siglock);
+
 	*type = PIDTYPE_PID;
 	signr = __dequeue_signal(&tsk->pending, mask, info, &resched_timer);
 	if (!signr) {
@@ -2801,8 +2799,7 @@ bool get_signal(struct ksignal *ksig)
 		type = PIDTYPE_PID;
 		signr = dequeue_synchronous_signal(&ksig->info);
 		if (!signr)
-			signr = dequeue_signal(current, &current->blocked,
-					       &ksig->info, &type);
+			signr = dequeue_signal(&current->blocked, &ksig->info, &type);
 
 		if (!signr)
 			break; /* will return 0 */
@@ -3657,7 +3654,7 @@ static int do_sigtimedwait(const sigset_t *which, kernel_siginfo_t *info,
 	signotset(&mask);
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	sig = dequeue_signal(tsk, &mask, info, &type);
+	sig = dequeue_signal(&mask, info, &type);
 	if (!sig && timeout) {
 		/*
 		 * None ready, temporarily unblock those we're interested
@@ -3676,7 +3673,7 @@ static int do_sigtimedwait(const sigset_t *which, kernel_siginfo_t *info,
 		spin_lock_irq(&tsk->sighand->siglock);
 		__set_task_blocked(tsk, &tsk->real_blocked);
 		sigemptyset(&tsk->real_blocked);
-		sig = dequeue_signal(tsk, &mask, info, &type);
+		sig = dequeue_signal(&mask, info, &type);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-- 
2.53.0



