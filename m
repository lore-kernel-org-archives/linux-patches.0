Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022799;
	b=GrYeihHOzTx1s1ycUSEgfunLGHFw1naDt5/Kyw0tlb+eYQQpvtEijQejaWZEBMstHjdm
	 2VJs8voSogKkSvXhEPHpRVR+O10Tu0oAUgV5oV0VbqSOF+fbCDIzTonfXA3IPEhH3nVZi
	 +oHNFK4/6AR/ZN9o7tDfrDDVEe9CKf1HVMhrMsdYw/J8XU3lLbZ/Y+z8TqJUwHtNmSJIj
	 Wq+C0q1900fsPbiEz2+heBn4PQaQqyuh6J5WuIF6FTzrPaoSjUYyuHJyafT67jxIw4Xv4
	 pX2hVNv/GE8LVfh4OAPFWuPc8hjw76GWcKy1PNz7DqlXVr3Pc4pZS2YBR83pqWP4gCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uIuDVi9cTOZ38lXaPo/SHHjxw/R8ecjV/WVBcbdm59A=;
	b=ElgKRJfprIACRiBJ2OUk9HxzZlbr0JxYDUIoyWJRhGBxa4x88r4PJj5cXC5mbQ9dNqIj
	 d1WSvb4rDFhgYLOIO09tmlyS3tOm9XC0Oam5YozbzJYJnj6HRCO+pWi5RxbwhI/4i0+li
	 +EDnlQw5fHFEVb8A/+eBr8CTczZ7Z5ebfFq990MT338wMC3sAOk6xj34dr/ZPwdh+mBJ1
	 /fMjPGAdoFOoVydvV2XucJGVt0OnIZV3OAyFFQQPWSRmS6RGjwet2jkdW5cmNjadK2LpR
	 Qdx8NVDRSO10N5dCyLquuF2Hha0+edyLl01qLj9RV3Z4/mayaUR21gUJh7I+uxpqRyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlfE8RNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E92606A332;
	Wed, 18 Nov 2026 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlfE8RNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4A21F000C4;
	Wed, 18 Nov 2026 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022799;
	bh=uIuDVi9cTOZ38lXaPo/SHHjxw/R8ecjV/WVBcbdm59A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlfE8RNhrMdakG4XBuQ0naiB6Bl0zr+3zhYFJ77bkTrWgVxOmL5VRaaNf4thZ+FX7
	 isWXnW9lXEstXOxHJFs1T+3IKnNq/bP09bo9qTza2UDwkXhuOfojIWdrxfrlhSjmIQ
	 vlUk40UFLARUhxbo5Z7ZslZpzatzY5mckiGzOSiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuba Piecuch <jpiecuch@google.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0091/2151] sched_ext: Skip ops.set_weight() for disabled tasks
Date: Wed, 18 Nov 2026 15:30:26 +0100
Message-ID: <20261118150125.115152223@linuxfoundation.org>
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

From: Kuba Piecuch <jpiecuch@google.com>

[ Upstream commit 0e2f4ab68a89fad42e0f5a9ff4b740738e7aa1d6 ]

When switching a task's sched_class away from sched_ext, we get the
following sequence of events in __sched_setscheduler():

sched_change_begin()
  switched_from_scx()
    scx_disable_task(p)
      ops.disable(p)
__setscheduler_params()
  set_load_weight()
    reweight_task_scx(p)
      ops.set_weight(p)
p->sched_class = next_class;
sched_change_end()
  ...

Notably, ops.set_weight() is called _after_ ops.disable().
This violates the expected semantics of the callbacks, the expectation
being that ops.disable() can only be followed by ops.exit_task() or
ops.enable().

Skipping the weight adjustment for disabled tasks should be harmless
since the weight will be recalculated in scx_enable_task() if the task
ever rejoins SCX.

Fixes: 637b0682821b ("sched: Fold sched_class::switch{ing,ed}_{to,from}() into the change pattern")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 48b8fb873b852..af5828f093045 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3109,6 +3109,17 @@ static void reweight_task_scx(struct rq *rq, struct task_struct *p,
 
 	lockdep_assert_rq_held(task_rq(p));
 
+	/*
+	 * When switching sched_class away from SCX, reweight_task_scx()
+	 * is called _after_ scx_disable_task(). Skip calling ops.set_weight()
+	 * since the BPF scheduler may have already forgotten the task in
+	 * ops.disable().
+	 * p->scx.weight will be recalculated in scx_enable_task() if the task
+	 * ever returns to SCX class.
+	 */
+	if (scx_get_task_state(p) != SCX_TASK_ENABLED)
+		return;
+
 	p->scx.weight = sched_weight_to_cgroup(scale_load_down(lw->weight));
 	if (SCX_HAS_OP(sch, set_weight))
 		SCX_CALL_OP_TASK(sch, SCX_KF_REST, set_weight, rq,
-- 
2.53.0



