Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618648;
	b=Z/Snj+wJxCHykLCuwhd8sQ8mYp7km8KQef9cSFefAIKKPcaczpgc8+HR4qjqbcLWMLdy
	 JEvU66ER39+HhyfbAlMBL5OjeW701DOoN1G0Xc25GtLvgjyOkwGBtD+lCGY07RYn38s8L
	 u45Qpe1CuNuNTnD8PYF3HuQvSFkpQLJWn/4K8+LKQdXxLujmy7QwUd9ws/mOyGpkEYDxr
	 +mh5ktXrDGdi4spB6zFU1fvw0hF9cQlC5JgQyLBhE4jAHWbWY+tSxzk/wbkYf9Xc9MCoS
	 9OQ4CZ7QVj4DgF90o1Brrje/FqGnzj2q9WaYV4ZhtFXyCirmBi6W7suLMaTWRSQgifg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z1EGev7dxQHOGlVTSWEmdcrirFzwgwQ+isMeIlYqZ1A=;
	b=1dgYvIW9H17wdYAcrYlOs+Q79fpYiAo+qboMahkYXyAd7bz9rHzgDo8zI0Y54tfwxwH0
	 GLxR6+izfGU7l7gVbJEkwn46ynEXDA5U1t717im7lyszgp8zUGU4mk7iJvAWQ4QwNlK4l
	 C4C5qX+nhDEwyDuhXwLQ8QAprAr564zgxEA5LBU8QhHPDybknhzVZ7TIGo0n0NTJtHm1J
	 JiV1OfW5mfhiLfpyBQk41gUWSxus6+0tiOwrZGPtdkfp95Av+R7990K/5Sy5ZTdxnX+9w
	 68HLysxuyJT3XyKuTg73o/M882iEHh1H0RxaerDRIfLDVLpft2kOb9gsXaT1uB1yQLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aq3DKfiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54429606A323;
	Wed, 25 Nov 2026 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aq3DKfiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681A61F000C4;
	Wed, 25 Nov 2026 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618647;
	bh=Z1EGev7dxQHOGlVTSWEmdcrirFzwgwQ+isMeIlYqZ1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aq3DKfiOhTTRmOl8dMLgZk97Cca3ONwEmsedt8yni4DreCmIcitwwCpyJPQWlx3Q1
	 afikiiYybnaiWruzFvLK9TU2KJpLPFpFHXNVizQ1VfdIjLt7b4Q3Q6FT9EBpQTGi6U
	 9QtdycoCVqQKUPd57ORnh5r+JT9HiH1fPIjR7l1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0344/1005] sched/deadline: Fix this_bw on class change of a dying task
Date: Wed, 25 Nov 2026 15:28:02 +0100
Message-ID: <20261125143829.793832390@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 0c93e25ef11a9dee43f6076bd1f09771dc2b167e ]

Moving a SCHED_DEADLINE task out of the class with sched_setscheduler(2)
after it stored TASK_DEAD in do_task_dead(), but before __schedule()
dequeued it, subtracts its bandwidth from the runqueue's this_bw twice.
this_bw then stays short until reboot: __sub_rq_bw() warns about the
underflow or about running_bw > this_bw, and GRUB reclaim for
SCHED_FLAG_RECLAIM tasks on that CPU is miscomputed.

The class change dequeues the still queued task with DEQUEUE_SAVE, which
removes its bandwidth from running_bw and this_bw. switched_from_dl()
then calls task_non_contending(), which, if the 0-lag time has passed,
removes it from this_bw again because the task is TASK_DEAD. That
removal is meant for the dying task's own DEQUEUE_SLEEP dequeue, which
has removed nothing before it.

Do the TASK_DEAD removal only on that dequeue path.

Reproduced under QEMU on x86_64 and riscv64 by moving exiting deadline
tasks to SCHED_OTHER in a loop; with this patch there is no warning.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://patch.msgid.link/20261025124657.836229-1-nickolai@csail.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1502a45d76aaf..4d502ca884485 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -444,7 +444,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 			if (!dl_task || READ_ONCE(p->__state) == TASK_DEAD) {
 				struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
 
-				if (READ_ONCE(p->__state) == TASK_DEAD)
+				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				raw_spin_lock(&dl_b->lock);
 				__dl_sub(dl_b, dl_se->dl_bw, dl_bw_cpus(task_cpu(p)));
-- 
2.53.0



