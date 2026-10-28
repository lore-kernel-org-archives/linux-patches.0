Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212658;
	b=qNS99vhAd9SfZVmiz1/Z92JTs1fZ2VgX5bTsySC1O4eO82mIx5SBg6RDb1sqgHNZWHhK
	 ftuKvn8HaFsyas+otKC/QaFjqTteVDpMCJtrtF8Lk1dYk4GcB1fjGtnvwSJk25ioUv6mS
	 EQ8V6Zg8yVGg1fM4BGDM5eaY/EggusRnF1VZJvWnq8Nano7ifZebqQ4t2F22XJY3LZJSd
	 8ygCyWpf2R00GE/bs86JzddTLgh6s04jYZNMkTBOKt1Jn9Gpl4L/8NTmtIvfS4fF0ylQs
	 JseQP8pT4oAV3N4h7QukBEdgZgaKfuRxBTzHpmjUi82V1O4GjuzQBDMNTZfLNAZlLVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F6dB/T79e17ai6j+tibDBExh9sUwCIAwyE5upEAEvUw=;
	b=SjioZdzZcAj6jhSZ2kwuHr6vzQSWeT5xVYZ2XfxxQRYsXgrRIMlTlpmiYF/B5k2tAg8y
	 YEnqkaVMaMbVl3dryoFLNDjvZ/fMf+qsxLlKoI4Qn53sgP+u7bFEpQzpIHUCBxmrCRhca
	 dQ+yofW2CSdaWK3gcuZGsQ9OrP85Ns/LaKDL0khCYHBa1npwtTWiNrwYWxfYicdvPhnTO
	 xwau90q6kHLmQHjG1VbqO/bxNdU6XWlhTi/SBHF7wT5zqMH/CDXJXS1f/7tKvAh6mP7+q
	 YyeuR1Pcqh54wgAH3LYCMcqg9TpZTcZUB/CDUrsacBtU5+fX/gN0ZbiN8dM7HyWWDwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Lc8V21L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDE4606A31C;
	Wed, 28 Oct 2026 18:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Lc8V21L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE0D1F01825;
	Wed, 28 Oct 2026 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212657;
	bh=F6dB/T79e17ai6j+tibDBExh9sUwCIAwyE5upEAEvUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Lc8V21LjE540Uv2Mv+KDifzj5B3ECqq9/BXyu9MSfzc7UUiox+Fpko722/8kt00+
	 Wl1UBNgxS2v2Hdy3FLvO9zdmIUSaTeH6GHOIAdf3BQX3kgZDbNnUuh3Nr6OPUIogO+
	 vOLJBVg5PA2hVfiFSLhXBF+w/uDa2fG+SZSAUpvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+2fe61cb2a86066be6985@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0204/1887] perf/core: Fix WARN in perf_sigtrap()
Date: Wed, 28 Oct 2026 17:38:20 +0100
Message-ID: <20261028170503.876381773@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3da6bb419750f3ad834786d6ba7c9d5d062c770b ]

Since exit_task_work() runs after perf_event_exit_task_context() updated
ctx->task to TASK_TOMBSTONE, perf_sigtrap() from perf_pending_task() might
observe event->ctx->task == TASK_TOMBSTONE.

Swap the early exit tests in order not to hit WARN_ON_ONCE().

Closes: https://syzkaller.appspot.com/bug?extid=2fe61cb2a86066be6985
Reported-by: syzbot <syzbot+2fe61cb2a86066be6985@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/b1c224bd-97f9-462c-a3e3-125d5e19c983@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a0bb33854c4a9..e5c79c55ce48e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6595,18 +6595,18 @@ void perf_event_wakeup(struct perf_event *event)
 static void perf_sigtrap(struct perf_event *event)
 {
 	/*
-	 * We'd expect this to only occur if the irq_work is delayed and either
-	 * ctx->task or current has changed in the meantime. This can be the
-	 * case on architectures that do not implement arch_irq_work_raise().
+	 * Both perf_pending_task() and perf_pending_irq() can race with the
+	 * task exiting.
 	 */
-	if (WARN_ON_ONCE(event->ctx->task != current))
+	if (current->flags & PF_EXITING)
 		return;
 
 	/*
-	 * Both perf_pending_task() and perf_pending_irq() can race with the
-	 * task exiting.
+	 * We'd expect this to only occur if the irq_work is delayed and either
+	 * ctx->task or current has changed in the meantime. This can be the
+	 * case on architectures that do not implement arch_irq_work_raise().
 	 */
-	if (current->flags & PF_EXITING)
+	if (WARN_ON_ONCE(event->ctx->task != current))
 		return;
 
 	send_sig_perf((void __user *)event->pending_addr,
-- 
2.53.0



