Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0641315696E;
	Thu, 12 Dec 2024 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024858; cv=none; b=bWfI6rQ7WB4SVCl8g4VuobadyfXRHhd8mRFSL3p/HsbyxNCryG8KrTRfEeb0Q8kYXheK6TpKmvkNlPKJB3wv+ctyxX9PG1FH7bwdNzCdUKRrSQYp2rhXeZZQQbFlOe8BB/f3GD14N0snGU7bXofJEpQF2lhkkw9/ai7juQTWdbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024858; c=relaxed/simple;
	bh=0Le5+qRjJ7mVV5MCIyFwW5QFPY9NOoAiseepq3gHT0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh0y2BKjEMbbo4TJS8VcJfzZTaLTtLqCXXDDMGPrY98qKynxRurW/8ys6pLJYWMRdQd+Bz3som4iSd/FtyFfZ/U+sSTHQErRcHZFBiDYlr+A9xTCBZ9mycdm3psMsBonw8mb4Z+Pow0HQiWt+2UCLjTd1sebnLdpSRgbBioMlZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1vQQvaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1vQQvaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9E4C4CECE;
	Thu, 12 Dec 2024 17:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024857;
	bh=0Le5+qRjJ7mVV5MCIyFwW5QFPY9NOoAiseepq3gHT0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1vQQvaAOwm+Nyvbbmr5ZSd9oXeXrtJHJSpsHtP0nAS84tHxPqHMRr4zoFYW7JeXq
	 aD/49TkY9jBPMTprbE6O/pRAAvjlefkAIKptMleQjQBrx4v19bVNKynNn6K5wYmab9
	 cQP31pmaO2NLyeJR11nJWJ/KySLiH8aKvJMIofCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Valentin Schneider <valentin.schneider@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/459] sched/fair: Remove unused parameter of update_nohz_stats
Date: Thu, 12 Dec 2024 16:02:53 +0100
Message-ID: <20241212144310.939207476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 64f84f273592d17dcdca20244168ad9f525a39c3 ]

idle load balance is the only user of update_nohz_stats and doesn't use
force parameter. Remove it

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210224133007.28644-4-vincent.guittot@linaro.org
Stable-dep-of: ff47a0acfcce ("sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a6e34c58cee92..0af373c4d7450 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8650,7 +8650,7 @@ group_type group_classify(unsigned int imbalance_pct,
 	return group_has_spare;
 }
 
-static bool update_nohz_stats(struct rq *rq, bool force)
+static bool update_nohz_stats(struct rq *rq)
 {
 #ifdef CONFIG_NO_HZ_COMMON
 	unsigned int cpu = rq->cpu;
@@ -8661,7 +8661,7 @@ static bool update_nohz_stats(struct rq *rq, bool force)
 	if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
 		return false;
 
-	if (!force && !time_after(jiffies, rq->last_blocked_load_update_tick))
+	if (!time_after(jiffies, rq->last_blocked_load_update_tick))
 		return true;
 
 	update_blocked_averages(cpu);
@@ -10690,7 +10690,7 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
 
 		rq = cpu_rq(balance_cpu);
 
-		has_blocked_load |= update_nohz_stats(rq, true);
+		has_blocked_load |= update_nohz_stats(rq);
 
 		/*
 		 * If time for next balance is due,
-- 
2.43.0



