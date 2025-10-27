Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D5B32143F;
	Mon, 27 Oct 2025 18:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590854; cv=none; b=Dy/jJrGMhbsg0YyY3nPRN0gH4PR0MRkzIBoONVuJtg0xS1qnW1iLAPnQK1i41k00sej2Z+47P1a4WBc9ZFvzlEZMx+wO9KckVKuLF1YpVUr9NAWCvJWmubqULY175kC7QE8o8YWHCEaxlOjgFa/iKvsu/mnh+8BskYy78zfRMJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590854; c=relaxed/simple;
	bh=tZEyQ7skKNfEVgSpdiMWta9LmUJyJXME9GgMvZxL0zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5cE8HPWAzKrYY1QjeKIZFvYhMvh5Z16AuAGlro9rxRKawaYEEsDzjddJpEypcqcQt92+jJA1PxMXP4qrekQDS6YgCEPqkpW6NXgisgZk7bp7ycb9/8qywx5l9U+Y5Sbr0jxIRXfgSIBUaoGLHno/YeQGUVcL/tym6eVJp8Xebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNVkdHR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNVkdHR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36013C4CEF1;
	Mon, 27 Oct 2025 18:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590853;
	bh=tZEyQ7skKNfEVgSpdiMWta9LmUJyJXME9GgMvZxL0zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNVkdHR7Hi3Fn7IQfD9jRiB5EY34Bgz2lBjfpMyxXw58zYZM0fQlLxY2TF2zL20sm
	 q4zUV9qogBjC6A19ozc70zKysrBfWs47G8dXs8+ux2WVwLRdNxTTjUpwz18bdntZOT
	 skNeC7SZlw/SQn9Pj4RUW/AWQpid1FBSVx8Kh5cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/224] sched/balancing: Rename newidle_balance() => sched_balance_newidle()
Date: Mon, 27 Oct 2025 19:35:14 +0100
Message-ID: <20251027183513.403158790@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1d82b9cc9eb77..62c0348ef556a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3690,7 +3690,7 @@ static inline unsigned long cfs_rq_load_avg(struct cfs_rq *cfs_rq)
 	return cfs_rq->avg.load_avg;
 }
 
-static int newidle_balance(struct rq *this_rq, struct rq_flags *rf);
+static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf);
 
 static inline unsigned long task_util(struct task_struct *p)
 {
@@ -3851,7 +3851,7 @@ attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags
 static inline void
 detach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) {}
 
-static inline int newidle_balance(struct rq *rq, struct rq_flags *rf)
+static inline int sched_balance_newidle(struct rq *rq, struct rq_flags *rf)
 {
 	return 0;
 }
@@ -6690,7 +6690,7 @@ balance_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 	if (rq->nr_running)
 		return 1;
 
-	return newidle_balance(rq, rf) != 0;
+	return sched_balance_newidle(rq, rf) != 0;
 }
 #endif /* CONFIG_SMP */
 
@@ -6981,10 +6981,10 @@ done: __maybe_unused;
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
@@ -9182,7 +9182,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	ld_moved = 0;
 
 	/*
-	 * newidle_balance() disregards balance intervals, so we could
+	 * sched_balance_newidle() disregards balance intervals, so we could
 	 * repeatedly reach this code, which would lead to balance_interval
 	 * skyrocketting in a short amount of time. Skip the balance_interval
 	 * increase logic to avoid that.
@@ -9897,10 +9897,10 @@ static inline void nohz_newidle_balance(struct rq *this_rq) { }
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
- * newidle_balance is called by schedule() if this_cpu is about to become
+ * sched_balance_newidle is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-static int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
+static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
 {
 	unsigned long next_balance = jiffies + HZ;
 	int this_cpu = this_rq->cpu;
-- 
2.51.0



