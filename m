Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060554;
	b=pl2bnM7n/0eCzX2JJyvYDEqZ/eAjKmtE56BZaNIZgua65yoNlZNQsKQKrpj1/EK+2DQj
	 xGnvbphOoe9kreT5kgs3ow3zK0UhwEoMRCWoRrplX95l7k9fz6xya+a9t7KTWZbatz08L
	 hE3rLJ4+s2ed11TJ9MgKEdtp7RYsVbjbLSo2OCMJZUGBn0eSk5yQT90FO3XgWHPS/sGtr
	 dXhu6N67Pjn6DC6dxl6Qy6Kq+QXmVT7MNfis3yETjULJOlhr1gGlA7amcXZ4fDHlbnMBo
	 IV1sEo8xeRBf5N2YcnZKVVWOU0uG+NZhAS3qlpz85rOTQj9zjc8QPnMhpPuLUculkHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zm1o99+5Ij+hZGj7fd9fx9AABuyYWhZxRUrMNEOv2CI=;
	b=v1Xg9rLXFdj7Sg8Al9g4vl1bme5Tm2dGAOVFnRz/nH0ymp9UP4EdI+QNuK23yR0/wSLU
	 T2QVZVwB0xtmQPKQb6qYqEOfEg7klkD2vsNy99TzS/a+3clNscxBzpMFgi4+cqOW4M5om
	 PIDet6KvoNuOMkkQ1EybHsL2ivZy6IbL/L2Xs3+tyGEmDKL3Q4eJfXeGApt1EhWzfWLD2
	 NurUiLDA4rGNzTXMcSx1wIf/7wuxNJrcXTOhcZZUGyE+R5Hv53u4PkhxgvXrBeb3clD8B
	 VDQ5SCOCY+71pimQNRZ3FtqIWzdKDE6KZuLnZEgZG6Tf6RUz+xzj3glhY2QrThj59Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RcJE5t1A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05125606A326;
	Sat,  7 Nov 2026 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RcJE5t1A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699FF1F0089F;
	Sat,  7 Nov 2026 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060553;
	bh=zm1o99+5Ij+hZGj7fd9fx9AABuyYWhZxRUrMNEOv2CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcJE5t1AHYzC+reEgPcVkPO+jXD5+C5oUzEfHQtVlMwOZlCA7KNvPjDDAgE+0cqiJ
	 7Ur0mIIq+3TrtKdlz1MXb7OYnfVE7G+15OSN6+Mdhk3GdNTWjCkgqMfiSVxJllls1t
	 OP8sJmTC6aSEzOdFCEzEDqYHsX9nXtKvyz1c8Eqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0019/1536] fork: dont create io threads once PF_POSTCOREDUMP is set
Date: Sat,  7 Nov 2026 08:33:55 -0500
Message-ID: <20261107134958.219239062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 1f978881ce6c9ac4f4d4a7b6a6e52339eadcd350 ]

zap_process() skips every thread that already has PF_POSTCOREDUMP set.
Such a thread is past synchronize_group_exit(), so a coredump can't
catch it anymore. It isn't counted in core_state->threads_remaining and
it isn't sent SIGKILL.

do_exit() sets PF_POSTCOREDUMP in synchronize_group_exit() and calls
io_uring_files_cancel() right after that. The cancellation runs task
work and a create_worker_cb() that io-wq queued before the exit creates
a new io-wq worker from there. If another thread started a coredump in
the meantime that worker joins a thread-group which is already being
dumped. zap_process() never saw it so it was never counted. But when it
exits it sees signal->core_state in synchronize_group_exit() and
decrements threads_remaining like any other thread.

So the count reaches zero one thread early and the dumper leaves
coredump_wait_inactive() while a thread it counted is still running.

The task has no fatal signal pending because zap_process() deliberately
didn't send it one, and it never went through get_signal() so it doesn't
have PF_SIGNALED either.

Refuse to create an io thread when the creator has PF_POSTCOREDUMP.
That costs nothing. io_uring_files_cancel() raises IO_WQ_BIT_EXIT
before it runs any task work, so a worker created from there only ever
gets to exit again, and io_should_retry_thread() doesn't retry -EINTR.

Clearing PF_POSTCOREDUMP for the new thread in copy_process() was the
other option. It makes the worker a thread like any other, but it only
helps while the dump hasn't started. A worker born after zap_process()
has run is invisible to it whatever its flags say and still decrements
threads_remaining on the way out. Refusing to create it covers both, and
then no task is ever born with the flag, so there is nothing to clear.

Moving io_uring_files_cancel() ahead of synchronize_group_exit() closes
the same window. It runs the cancellation, and whatever that can block
on, before the thread announces itself to the dumper. A thread that
blocks there never reaches coredump_task_exit() at all, so the dumper
ends up waiting for a thread that never parks. Refusing the creation
leaves the cancellation where it is. But it's very ugly to run io_uring
work even before we did all the generic exit work.

Fixes: 92307383082d ("coredump:  Don't perform any cleanups before dumping core")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-14-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index c82956f8fc9d5..140a615daf42e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2774,8 +2774,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 		.user_worker	= 1,
 	};
 
-	/* A creator past its fatal signal gets no thread. */
-	if (current->flags & PF_SIGNALED)
+	/* A creator past its fatal signal or its coredump point gets no thread. */
+	if (current->flags & (PF_SIGNALED | PF_POSTCOREDUMP))
 		return ERR_PTR(-EINTR);
 
 	return copy_process(NULL, 0, node, &args);
-- 
2.53.0



