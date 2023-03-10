Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8B9881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DA2C433A4;
	Fri, 10 Mar 2023 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459564;
	bh=W/F1RDm1ip5lH1HOwxsafEE4/+ZbE7E4MuzkO3akoes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwzpT3w6Vp+6ba6fX9kyLj4HR63g1NKMIvkdbB43o8THHDqafyb74ys+Y+WECIdx/
	 Tb7Cqa2QzFULDRCBB4MK3mhmT+rf9wWC8vAejw8iDCEm8x575j+NgBwjALJ+1pCqjj
	 t2FV4Xi9EP6VJqiYVAnEoUGHqqhq++8wZnP07570=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/529] sched/deadline,rt: Remove unused parameter from pick_next_[rt|dl]_entity()
Date: Fri, 10 Mar 2023 14:33:08 +0100
Message-Id: <20230310133807.078813974@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index aaf98771f9357..f59cb3e8a6130 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1847,8 +1847,7 @@ static void set_next_task_dl(struct rq *rq, struct task_struct *p, bool first)
 	deadline_queue_push_tasks(rq);
 }
 
-static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
-						   struct dl_rq *dl_rq)
+static struct sched_dl_entity *pick_next_dl_entity(struct dl_rq *dl_rq)
 {
 	struct rb_node *left = rb_first_cached(&dl_rq->root);
 
@@ -1867,7 +1866,7 @@ static struct task_struct *pick_next_task_dl(struct rq *rq)
 	if (!sched_dl_runnable(rq))
 		return NULL;
 
-	dl_se = pick_next_dl_entity(rq, dl_rq);
+	dl_se = pick_next_dl_entity(dl_rq);
 	BUG_ON(!dl_se);
 	p = dl_task_of(dl_se);
 	set_next_task_dl(rq, p, true);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e6f22836c600b..e1ce5d1868b50 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1605,8 +1605,7 @@ static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, bool f
 	rt_queue_push_tasks(rq);
 }
 
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-						   struct rt_rq *rt_rq)
+static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
 {
 	struct rt_prio_array *array = &rt_rq->active;
 	struct sched_rt_entity *next = NULL;
@@ -1628,7 +1627,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
-		rt_se = pick_next_rt_entity(rq, rt_rq);
+		rt_se = pick_next_rt_entity(rt_rq);
 		BUG_ON(!rt_se);
 		rt_rq = group_rt_rq(rt_se);
 	} while (rt_rq);
-- 
2.39.2



