Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022661;
	b=aq5PhoUil1iOcIdBljcoaFSk3HQNSXauumaH6HnCt3FTnktHe/YmCN4rh3EFmNMlnUOD
	 wt11aAodXXVCQ3FQVSILFICoJfx5QeBi3G8NrjEQ46XEbeiMe+rUcOhjglez8tC1kE4LR
	 rp9bix5XyqLTwjpq8s7tyzZX4A4nM1e0fGNN9m37WWhp49YSFxlSj3eV+ewnxHedZC2aa
	 knPg58k9E8gO/2CVJhkxyRD6DOmCaELRJCe+dTZ9DvI6so6tOhDexwG1I8+rxAxTojimM
	 KT+NVOBLagzZENb7i0IFAke/JKtWm9I8/Osnx+wi5wkbBbXAOLoouG9HmqWoQQV84Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J5wGdQcUspDRhpNEQkai5GI5CgMNwO2RiExYoMyOi5E=;
	b=W3ADL+b/qfNc6CkxiSAcFqfOpwcKK5HZ5glFJXGsEhKWxh0zern4wqDV8bZjUPq7O2TG
	 GfX0szcbGVKKi8ZIEEp67Q+SorhZLcg3YOnUpjBhVIOJFULTekBNPqPRUbZCrL1FJHyTU
	 S9mqhSvujc8ADlxVAlbPPWyIqQ7Yg9Y7EMMEXWn4PCs3pzeqaYsqNUlH7H3r0RssrlKDU
	 JLzbsGvoiobp56ZUDrlGUxRcm9E2bNWAfQOyeFgpCsLTVXURvyEjVkJ61CNLBMdvP9uVL
	 KXOSD0OLVqkIsEaN+JMHjTma56xz8VDHIDN/HdGg+vl3s86iCNswffbyUaFFwsNl7yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDqXQkFD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787EA606A333;
	Wed, 18 Nov 2026 17:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDqXQkFD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2B11F000C4;
	Wed, 18 Nov 2026 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022661;
	bh=J5wGdQcUspDRhpNEQkai5GI5CgMNwO2RiExYoMyOi5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDqXQkFDlOYrHQJL5LWiG5HwP9ttKeXFlEOWMWF/LYdhCKlqtJhz+o8nBNEDeT5Rz
	 n+DA4hGdeIbeHUVTKgqV+y0I9O1EE3FbD9U6GiJ2dmSpDVvv3foWElUwkrIzAD8JAm
	 g2gli6qXcnjyMdIMfZdESWNHpgSGXlpaKY57U5Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0090/2151] sched/fair: Clear throttle state when leaving the fair class
Date: Wed, 18 Nov 2026 15:30:25 +0100
Message-ID: <20261118150125.079001427@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit c282051fc2cae2ea54770ebe435dbea090272c25 ]

Task-based CFS bandwidth throttling removes a task's fair sched_entity
while the scheduler core still considers the task queued. p->throttled
carries the fair-specific state across dequeue/enqueue operations.

DEQUEUE_CLASS removes the task from cfs_rq->throttled_limbo_list
but retains the bit. If the last finite CFS quota is disabled while
the task runs in another class, it is absent from the unthrottle walk and
the bit survives.
Returning to fair while cfs_bandwidth_used() is false then performs a real
fair enqueue with p->throttled still set.

After bandwidth is re-enabled, a class-change dequeue treats the
stale bit as limbo state and skips __dequeue_task(). p->se.on_rq therefore
remains set, and put_prev_task_fair() places the entity in the EEVDF tree
while the task moves to RT. On exit, the fair picker can select the
TASK_DEAD task. __schedule() then returns to do_task_dead(),
which hits BUG().

Keep p->throttled across migrations and group moves, but clear it on
DEQUEUE_CLASS because fair-specific state must not outlive fair-class
membership. A later return to fair uses the normal enqueue path. That path
still respects a throttled cfs_rq.

A KASAN, LOCKDEP and DEBUG_LIST v7.3 kernel reproduced the do_task_dead()
BUG in 3/3 root and 3/3 delegated uid-1000 runs with CapPrm=CapEff=0 and
RLIMIT_RTPRIO=1. The fix passed both matrices plus a 3/3 class-switch
control with bandwidth continuously enabled, without a scheduler warning,
KASAN report, lockdep splat or crash.

An AI coding assistant analyzed the state mismatch and drafted the initial
reproducer, fix candidate and this changelog. The source paths, trigger,
controls and results were rechecked against the cited revisions.

Fixes: e1fad12dcb66 ("sched/fair: Switch to task based throttle model")
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Aaron Lu <ziqianlu@bytedance.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261022235234.150957-1-4ncienth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fbc277c6963c5..a063e302fbf8e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5988,8 +5988,8 @@ static void dequeue_throttled_task(struct task_struct *p, int flags)
 	WARN_ON_ONCE(p->se.on_rq);
 	list_del_init(&p->throttle_node);
 
-	/* task blocked after throttled */
-	if (flags & DEQUEUE_SLEEP) {
+	/* Task blocked after throttling or is leaving the fair class: */
+	if (flags & (DEQUEUE_SLEEP | DEQUEUE_CLASS)) {
 		p->throttled = false;
 		return;
 	}
-- 
2.53.0



