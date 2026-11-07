Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065041;
	b=HjvbYzjRFmKqUv/z+E1ErgjUQsgais4ITSb8JIg0G8egrePZE//d5Ioud6q5+0juV3ms
	 P9DFnBFl6xqK0FV/MPpEqV/K+FCy4SOW0onjur6vd0XwpPtgFeUHloO2tAfeeUgYBNPlk
	 Lgf3hSNlIKAiTBRd08y4na3oaQDu8Wx3RvGw5wYh67blT5VkspllNyaHF1KoN4UlUmOc1
	 BzP/Q+HyDTgEVD3GExM//ZCjN4x8j4mCB4g6OEP2zsVpsHcnMHcZz5byyO/4YV97Lb+kq
	 tc1jOLXAwl0Dhe9/s6fXdNjs0zj3ND8xiZxbCEcVKaAJTIk67PnnPWfopY6DMNfwi9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kDVoyueMGSZ+l13YfOt5JpBk/3vRVVogbf4jl695zd8=;
	b=kiaTfcBhxhjvHPxkCwthlWHYN79LCTtSjwWb+EcqeOikIkFD7konMIow0dSQkFezGXcz
	 yVIPdBlDfOKiz2T2V/Jrk9W6L3WLQeSEo40lZwsdNpcDz/FFEeSE0Z74/TxRJWylSnXJV
	 duQEzo/Ohp+vwQBncgyofm6WYk2TXBH/pByS4x0WDP9xFMYUZz/BM78sZ8HbYd3j4f5YH
	 eyWfrV8qR75jXUOF2QmPCtd69F2Ai5Y/i5SvavVciWjTLDuBcYcOMt1uocZ1qpcEhoFDv
	 71GdDsHuQcZxL+0eBLdEWNSk2aYuC3OSd6iBKZ+XlwHAEbVMWcX1gidwgLgpSlyhKmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LxgEHBIV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CB6606A9D3;
	Sat,  7 Nov 2026 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LxgEHBIV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4DD1F0089F;
	Sat,  7 Nov 2026 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065041;
	bh=kDVoyueMGSZ+l13YfOt5JpBk/3vRVVogbf4jl695zd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxgEHBIVVHmaG8Y1vAbjhwZ09W2M5dwWMrjd2IvXRXCzbnxYxBoGfdv9Uw5cGAB4O
	 PhrzkoZmuiZR13EeAkCcFDmcxXrwNav3iaHgeaLQSP9efnqJhMvo9MBBc7IeBJMnqG
	 UEtzpnehQ6f8rDrWeolBsPVV3f0UR3+iFzuXCCq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Blaszczyk <michalblk@google.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0895/1257] sched_ext: Reset runnable_at when a task leaves its scheduler
Date: Sat,  7 Nov 2026 08:53:11 -0500
Message-ID: <20261107135004.044256124@linuxfoundation.org>
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

From: Michal Blaszczyk <michalblk@google.com>

[ Upstream commit 993e8fbfecbbf284b9644c6f10741b28fb914094 ]

The watchdog measures how long a task has been waiting from
p->scx.runnable_at, which set_task_runnable() resets when the task becomes
runnable after it last ran. ops_dequeue() never asks for a reset, as the
dequeue of a waiting task is temporary, e.g. for a migration or an
attribute change.

Leaving the scheduler isn't temporary. A task which is switched out of
SCHED_EXT while it's waiting keeps its runnable_at. When it's switched back
and becomes runnable, its wait appears to have started before it left, and
the time it spent in another class counts towards the timeout. If the
watchdog checks before the task runs, it aborts the scheduler:

  sched_ext: class_switch_stall: runner[418] failed to run for 3.010s

Here, the task waited for a few milliseconds before it was switched to
SCHED_OTHER, slept outside of SCHED_EXT for three seconds, and was charged
for all of it as soon as it woke up on SCHED_EXT again.

The same happens when scx_sub_enable_workfn() hands a waiting task over to
a new sub-scheduler, which can then be blamed for time the task waited
under the parent. scx_rehome_task() isn't affected, as it moves the task
through SCX_TASK_INIT, which resets runnable_at. The stale runnable_at also
skews the default core-sched ordering in scx_prio_less().

Reset runnable_at in scx_disable_task(), when the task leaves the control
of its scheduler.

Fixes: 8a010b81b3a5 ("sched_ext: Implement runnable task stall watchdog")
Cc: stable@vger.kernel.org # v6.12+
Assisted-by: LLM
Signed-off-by: Michal Blaszczyk <michalblk@google.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 60e8bacc14bb9..84774147a1d5b 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -2232,7 +2232,11 @@ static void ops_dequeue(struct rq *rq, struct task_struct *p, u64 deq_flags)
 	struct scx_sched *sch = scx_task_sched(p);
 	unsigned long opss;
 
-	/* dequeue is always temporary, don't reset runnable_at */
+	/*
+	 * Don't reset runnable_at. If @p is waiting, the wait continues across
+	 * temporary dequeues, e.g. for a migration or an attribute change.
+	 * scx_disable_task() ends it if @p leaves its scheduler.
+	 */
 	clr_task_runnable(p, false);
 
 retry:
@@ -4102,6 +4106,14 @@ static void scx_disable_task(struct scx_sched *sch, struct task_struct *p)
 	scx_set_task_slice(p, 0);
 	p->scx.reenq_cnt = 0;
 
+	/*
+	 * If @p is runnable but not running, its wait started at runnable_at,
+	 * which ops_dequeue() didn't reset. Leaving @sch ends the wait. Reset
+	 * runnable_at the next time @p is enqueued on SCX, so that the watchdog
+	 * doesn't count the time @p spends elsewhere.
+	 */
+	p->scx.flags |= SCX_TASK_RESET_RUNNABLE_AT;
+
 	/*
 	 * Verify the task is not in BPF scheduler's custody. If flag
 	 * transitions are consistent, the flag should always be clear
-- 
2.53.0



