Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585845;
	b=5A0WM1E5b2l/U1C0o8O4mqWrfaFHmT76qdBzfXlhFfgaSTh9YnX32Q2tc4YWxujKOuiB
	 aeOu3YgqrUocHJjcoFIKuJUM0WnJOKcqnldAenObOgpy+Un1zBLP/rZ20tjRXTLhc7XIv
	 iagYMWE7mIbvRpzt3GaQQ5wVmJsmQBNTHxXEQkGlbrZyu6yj2KsvEivJ3ihEOCNY8frSW
	 eIC5Cvxpoj93PjbZoE7VL4Do9hdi7fINzskTxJUPc42Irte6OtRFYoyHLnXteFYUuzCIo
	 Wd2oJpd+xL450mwKnucQmTQcR/R61U1JjMPl0abN96nuRQqA4u2KCL5ycv03QgGNdPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dcK9vuUGYKIQYIx3eWLY0fYFYayJSfEb3R4fNREl9Ps=;
	b=Z8Q7kpYA/G+vVgBkXp5eqIRRs6ptFv6+WlZGWutjzzsc+l+LHGzO3kZn4RZrxNlR3SGi
	 jkNDV1/pDF8uLJaU7x6CnRYq9GoAvftLC0pN9se6aiZB2lwjGdBgMF9eQZ33Boa15B5yM
	 WORT22ijlcrob/gTRo5gp0sEtdCdM22DGp5vP0LJ6/2pcgUcSD3si0SB5io3u0LXZctUb
	 XlH99jZdiUnkDmzLcoQbIcjHyprSdGqQHBXMCMDLVydvisDXaX7vRlWLq3DmqDm+Awpng
	 9hQ1P4lKqfMDo77b9VkLECExCpCPbg2NKOzB6WzsNuotEiBIf7HXaEFrpwwSSZ4ZYoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NmZwEPHu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356D5606BAB6;
	Fri, 13 Nov 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NmZwEPHu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E081F000C4;
	Fri, 13 Nov 2026 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585845;
	bh=dcK9vuUGYKIQYIx3eWLY0fYFYayJSfEb3R4fNREl9Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NmZwEPHu97qVYroQAbl5g2ZEga4sOPXf+Zylkh248/5PPXvS4rEHdnEQKEfo2L7es
	 0JAxcJvXp4F6odVV2xAGGgTZEY8NpAlpvDZMTLqlN9UK13Vag9W4Ot3ZtjO+R6bm1x
	 Z4O0pntL55BHINTLgl3CkC2n5Ak1T8kK+BbTl4EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 423/507] sched/fair: Clear throttle state when leaving the fair class
Date: Fri, 13 Nov 2026 10:52:07 -0500
Message-ID: <20261113153811.081586474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index b35e23f93bcd2..913630c0b0590 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7021,8 +7021,8 @@ static void dequeue_throttled_task(struct task_struct *p, int flags)
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



