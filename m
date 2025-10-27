Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C767930ACE3;
	Mon, 27 Oct 2025 19:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591976; cv=none; b=kzYoc0SGjiwkonk/JijU8fKX8cWSWe6q4o4Dj4HCwXAjE7A0GV1z7b0wbOpxqq0g3bp0IEqYgxfFHuiBPPKvl5u1/vqT0DaPTlhy6O5x2wRJEP8kjvlIPsDyjmDHT6GtG7v2zn/X9TU30ZYXS+OT5F0yBBFwktyUlSmZagcltMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591976; c=relaxed/simple;
	bh=VzAjiuWTiOfpZ/6whxIPmWfkhOaHJUsS9zFt0wb1wEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRrkYNB6T8p8xrFsyA766K4fYUgdgjWGwIhoi6IN2/A9rULBDzEsiFqbcpEei7iHJJDP7Q5BgckAAfP2JgWvjxTP2T3MMLXVgnzpDF5bPnV5Su0c36rowIfuUyIFnV33TvCBZkcmnvhSijV08IBk261gyiUxwf/okoE+aONgTds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzOLjBoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzOLjBoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC38C4CEFD;
	Mon, 27 Oct 2025 19:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591976;
	bh=VzAjiuWTiOfpZ/6whxIPmWfkhOaHJUsS9zFt0wb1wEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzOLjBoGAhnrN3W2Xxbh9CnjUOckwQc/dBZZGFoRAW82Nu6Y+V4Am9n7Pk8AHVM4A
	 1uxZe+Bihq9+RmBnC7OfAZfTqT77yu9G/uTkFeU7Q4rk8OSwqZe6+8eQSeSg5dqTVr
	 cd2sZ62m9XIgfuob6cD+LgK6BsM0Kg6Ff0EsIA+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/123] sched/balancing: Rename newidle_balance() => sched_balance_newidle()
Date: Mon, 27 Oct 2025 19:35:14 +0100
Message-ID: <20251027183447.313326681@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 7d058285cd77cc1411c91efd1b1673530bb1bee8 ]

Standardize scheduler load-balancing function names on the
sched_balance_() prefix.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Link: https://lore.kernel.org/r/20240308111819.1101550-11-mingo@kernel.org
Stable-dep-of: 17e3e88ed0b6 ("sched/fair: Fix pelt lost idle time detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ea707ee9ddac1..03b809308712e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3959,7 +3959,7 @@ static inline unsigned long cfs_rq_load_avg(struct cfs_rq *cfs_rq)
 	return cfs_rq->avg.load_avg;
 }
 
-static int newidle_balance(struct rq *this_rq, struct rq_flags *rf);
+static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf);
 
 static inline unsigned long task_util(struct task_struct *p)
 {
@@ -4291,7 +4291,7 @@ attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) {}
 static inline void
 detach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) {}
 
-static inline int newidle_balance(struct rq *rq, struct rq_flags *rf)
+static inline int sched_balance_newidle(struct rq *rq, struct rq_flags *rf)
 {
 	return 0;
 }
@@ -7280,7 +7280,7 @@ balance_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 	if (rq->nr_running)
 		return 1;
 
-	return newidle_balance(rq, rf) != 0;
+	return sched_balance_newidle(rq, rf) != 0;
 }
 #endif /* CONFIG_SMP */
 
@@ -7616,10 +7616,10 @@ done: __maybe_unused;
 	if (!rf)
 		return NULL;
 
-	new_tasks = newidle_balance(rq, rf);
+	new_tasks = sched_balance_newidle(rq, rf);
 
 	/*
-	 * Because newidle_balance() releases (and re-acquires) rq->lock, it is
+	 * Because sched_balance_newidle() releases (and re-acquires) rq->lock, it is
 	 * possible for any higher priority task to appear. In that case we
 	 * must re-start the pick_next_entity() loop.
 	 */
@@ -10427,7 +10427,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	ld_moved = 0;
 
 	/*
-	 * newidle_balance() disregards balance intervals, so we could
+	 * sched_balance_newidle() disregards balance intervals, so we could
 	 * repeatedly reach this code, which would lead to balance_interval
 	 * skyrocketing in a short amount of time. Skip the balance_interval
 	 * increase logic to avoid that.
@@ -11155,7 +11155,7 @@ static inline void nohz_newidle_balance(struct rq *this_rq) { }
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
- * newidle_balance is called by schedule() if this_cpu is about to become
+ * sched_balance_newidle is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  *
  * Returns:
@@ -11163,7 +11163,7 @@ static inline void nohz_newidle_balance(struct rq *this_rq) { }
  *     0 - failed, no new tasks
  *   > 0 - success, new (fair) tasks present
  */
-static int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
+static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
 {
 	unsigned long next_balance = jiffies + HZ;
 	int this_cpu = this_rq->cpu;
-- 
2.51.0



