Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033482;
	b=LtePZQ4hCDSp7ysD21hOxedcwLdlaxFocbpUUvJbLhpvKT14Kbuf8LMKFzI43M7q4ZNK
	 FYq/XiDsD2Lo3SJnHTHEND6sqXjFmLtCD5UXOvHeQXXyOKBs8qA/+uIYnmdicDMWE83r0
	 s6wkK0Eva1GLYEA0Qwy+eri3F2K8totK0FUI0sVkFL/MU0uLqXxI0ju/4UXsODXuYY480
	 JolWuGHDxv1GIrWfj2x3AW9GSlwzi0jrT2zXE9RKXspGqKU1Rr+Q2gxy7IIfBcaK1tOhV
	 wAjIw3LgAJHXEHHwf4ZYde/StAbzLb4A/ErB6oY0wmvy+VKTC4K9p8tKxjsUx52w1ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P4Gu4ZohAO8+wJOe34MzzeKUWVPq7MHY0JvhAPmqsgg=;
	b=FZQH2JIch/XUTBnrq/WNi/SaB8LMDndYhC+fHvVdA3GWMW3H9WgpmVLVuyzzC20D9xBd
	 yR9buYRhSmCpoynwBWa3hiEp7CVBOuaM3vOMUDU2PNHpIXw0c30ExMQ5YMDSy+fgwIsPy
	 NQwj0ACrj2fyMrn8x06oCqf5YHx33wFzvf7VEuMhzr0qU+dy3fsvv+YDtxA7T+EzdIzAk
	 cSYi3/zCFgBqF9y2TWd5LL/udxy9wBRKdYHSGeSSBOgVlTq2AoaRvFPcMyQuCH3PMCVcG
	 mcdFDTSb4/qkuQk00Kstfqc8B02kmlfWtzJjiEAiYxpxsCPrwoca1aS2bM4yR5ncxJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmN9iXQ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0B8606A330;
	Wed, 18 Nov 2026 20:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmN9iXQ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA601F000C7;
	Wed, 18 Nov 2026 20:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033482;
	bh=P4Gu4ZohAO8+wJOe34MzzeKUWVPq7MHY0JvhAPmqsgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmN9iXQ85s+HfNG62Zm6BBXd28oh2Yc2agqe+AM4hJ4x/TKRLnHKbuCTs06m8ldox
	 gUJc1wDIb66/cA/zUTmXLE/Ag31Mbd1cEoDd88wID+OnVrlQL4fDg/d2PN77x+RdIk
	 kNixg+vR2R75qcV56huFRx3htrpAM2omhmxntrzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0012/3318] fork: dont create io threads once PF_POSTCOREDUMP is set
Date: Wed, 18 Nov 2026 15:10:34 +0100
Message-ID: <20261118150314.035757044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 802bccf2dea74..fd10c6e0dcfa3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2867,8 +2867,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
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



