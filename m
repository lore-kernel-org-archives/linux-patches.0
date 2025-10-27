Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D705D22A4DB;
	Mon, 27 Oct 2025 19:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592271; cv=none; b=ogZGRLtrRzT0abMZVYMvvJz9uPs5UyGUDavPHp1A3Kt1+BdfGMcl7WBidKeASrkw7sEj0bq828hWJeXPKSTyS5eeyU5H9hEC/pmkBpFH1YiHsEBt4C8coLsCyzGuVNID/XHbymEZbfJuhykotG3eALl1nNYsaYhaUuTHuf7e9Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592271; c=relaxed/simple;
	bh=FSCapbaynUuE/EFPIpElQmjrUmz+Xg2+7hNVysNnUcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6f3+KDtQ7JcFa85Cfx3mHSv1eCHuqDRUL8Do+3A8RF9k9lkqGPy3/hDLiTfyOqKtP/dDDI6Rs3RhwrX+QHrNOPJxsfKsF532ZZHORDvVEghHKl+Gx7+/pYh1cLaBdOaNis6rwHGPi4oNr2C6yc7IRzmj0Vb5qT2TwTf+w2Ciwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5a5KP1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5a5KP1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A76C4CEF1;
	Mon, 27 Oct 2025 19:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592271;
	bh=FSCapbaynUuE/EFPIpElQmjrUmz+Xg2+7hNVysNnUcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5a5KP1d9r0wSOs1dZbYI4U4XRg3jfm+zfVYtQmPevGExXLUAQM6L6WlpB+OG4vMK
	 ia4hOQDx82S5CzfnBgRXBYXSLKpxRFfil6KSkcUnLFxm2zzRN0HFss/N++YD7ge0O/
	 BDwXgjL7Bz9pYymTJc1/r/q1ixew21IMKnVRP+Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/157] sched/balancing: Rename newidle_balance() => sched_balance_newidle()
Date: Mon, 27 Oct 2025 19:35:20 +0100
Message-ID: <20251027183502.870813575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2deb896883d38..cf889d1ed13d1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4261,7 +4261,7 @@ static inline unsigned long cfs_rq_load_avg(struct cfs_rq *cfs_rq)
 	return cfs_rq->avg.load_avg;
 }
 
-static int newidle_balance(struct rq *this_rq, struct rq_flags *rf);
+static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf);
 
 static inline unsigned long task_util(struct task_struct *p)
 {
@@ -4590,7 +4590,7 @@ attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) {}
 static inline void
 detach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) {}
 
-static inline int newidle_balance(struct rq *rq, struct rq_flags *rf)
+static inline int sched_balance_newidle(struct rq *rq, struct rq_flags *rf)
 {
 	return 0;
 }
@@ -7575,7 +7575,7 @@ balance_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 	if (rq->nr_running)
 		return 1;
 
-	return newidle_balance(rq, rf) != 0;
+	return sched_balance_newidle(rq, rf) != 0;
 }
 #endif /* CONFIG_SMP */
 
@@ -7911,10 +7911,10 @@ done: __maybe_unused;
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
@@ -10786,7 +10786,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	ld_moved = 0;
 
 	/*
-	 * newidle_balance() disregards balance intervals, so we could
+	 * sched_balance_newidle() disregards balance intervals, so we could
 	 * repeatedly reach this code, which would lead to balance_interval
 	 * skyrocketing in a short amount of time. Skip the balance_interval
 	 * increase logic to avoid that.
@@ -11548,7 +11548,7 @@ static inline void nohz_newidle_balance(struct rq *this_rq) { }
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
- * newidle_balance is called by schedule() if this_cpu is about to become
+ * sched_balance_newidle is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  *
  * Returns:
@@ -11556,7 +11556,7 @@ static inline void nohz_newidle_balance(struct rq *this_rq) { }
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



