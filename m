Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B93848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C381C433D2;
	Fri, 10 Mar 2023 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458445;
	bh=x0IsObqfoacKlwwFr8Jx4QlUKPoxvl1OhHw3MxhG6cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/9W1XRVmiHSh+tO6oct2sDXue4TL4vkulPTVm1URc/dGzag8BYcWH1vqENWVZjcP
	 z4FKX/aRaoLg2hu6x+RXyQsF768QVPBuV5TRz6e4YgHdv35Acab2EEr6LH81q/v23y
	 oGcQJE+ZI1RB9H2aZtO6SXN9pXqa9U9QSj0xlhvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/357] sched/deadline,rt: Remove unused parameter from pick_next_[rt|dl]_entity()
Date: Fri, 10 Mar 2023 14:35:18 +0100
Message-Id: <20230310133735.299222394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

[ Upstream commit 821aecd09e5ad2f8d4c3d8195333d272b392f7d3 ]

The `struct rq *rq` parameter isn't used. Remove it.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20220302183433.333029-7-dietmar.eggemann@arm.com
Stable-dep-of: 7c4a5b89a0b5 ("sched/rt: pick_next_rt_entity(): check list_entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 5 ++---
 kernel/sched/rt.c       | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d8052c2d87e49..ba3d7c223999e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1793,8 +1793,7 @@ static void set_next_task_dl(struct rq *rq, struct task_struct *p, bool first)
 	deadline_queue_push_tasks(rq);
 }
 
-static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
-						   struct dl_rq *dl_rq)
+static struct sched_dl_entity *pick_next_dl_entity(struct dl_rq *dl_rq)
 {
 	struct rb_node *left = rb_first_cached(&dl_rq->root);
 
@@ -1816,7 +1815,7 @@ pick_next_task_dl(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 	if (!sched_dl_runnable(rq))
 		return NULL;
 
-	dl_se = pick_next_dl_entity(rq, dl_rq);
+	dl_se = pick_next_dl_entity(dl_rq);
 	BUG_ON(!dl_se);
 	p = dl_task_of(dl_se);
 	set_next_task_dl(rq, p, true);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c11d3d79d4c31..e5d42947e57ab 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1550,8 +1550,7 @@ static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, bool f
 	rt_queue_push_tasks(rq);
 }
 
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-						   struct rt_rq *rt_rq)
+static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
 {
 	struct rt_prio_array *array = &rt_rq->active;
 	struct sched_rt_entity *next = NULL;
@@ -1573,7 +1572,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
-		rt_se = pick_next_rt_entity(rq, rt_rq);
+		rt_se = pick_next_rt_entity(rt_rq);
 		BUG_ON(!rt_se);
 		rt_rq = group_rt_rq(rt_se);
 	} while (rt_rq);
-- 
2.39.2



