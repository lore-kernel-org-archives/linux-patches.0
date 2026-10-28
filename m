Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217341;
	b=Px88Pj2uMxVrD4M643PNEEizrBabKBK9c2qqQW+lHQt+w5/kSJCNiWV+/CJiRpYVY/Cj
	 +AAehuNrNNynmZ38DEKfnCs1eSlGtCwR+sRmv5cZIeuTHYqSyjJ+qn+OoHxW4f6wIkiW1
	 nvIaTqcewWoC8W5IDodj3TMxpYHvjwrlKSKaJtihtLXov6bUPIS0dtw7m6EbFCouUOA6T
	 ngOvX2dZfQ4e1HUCjJ0UusrU290Rjg2DV43QzO1n+S6a3Rxt2kuLLW1YYIhWgVLwQaJKh
	 dI/7kfsuf1jOtf59IiKCvZ+KnmT6/IgB9T3r7QnXVhl0+2DVnWmOP8An3g3/M8PonzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6jkPWd2NyoN04PtR7z6snhwHkM/C1It/Y9Xmv7j6COc=;
	b=Iv45DmSW2hQEESgacQ2FVIZlyKIobCmq7OcMczNhSwQLAKD24ff+dn59f93X+5I3CIja
	 dS100nD2/cxR1ZS32gAiSQL3n40tpuoPqzxJa69xTvJGYYKy+TbxIgNpUzwQUtAf2kVms
	 ox6E9/ZlI+n1bWDe5TaQx93J/UNFwZLLGeMLHlhDEzKV/y81glcUvm+u++vwYnA5lJW4h
	 BFToXS2+XpTrPye+pCMvHEo1wa6Hu/JgRtLvRND/foAQ738WHXOGFqSz70suHah/a4M9y
	 b5abJHzFZ46m5eY9tLxLTYIbxy9gpAwtT5BEJ9QdFJ37A/amIozfrLSYvHYr20Hts9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mmMhrKYl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0683606A31C;
	Wed, 28 Oct 2026 19:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mmMhrKYl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1B31F01825;
	Wed, 28 Oct 2026 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217340;
	bh=6jkPWd2NyoN04PtR7z6snhwHkM/C1It/Y9Xmv7j6COc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmMhrKYlhj0b+mSyU2Ycv4I8569GHzzptUQYli9k/6v63/8yRMj9f7kZls98qo9I3
	 XAEMO17TUvGNa+rW7zdS2NKaDtADPa73puvNVhslUp/bD2q1CSiyscLOqjU+lORVVM
	 +zqcw19R9XkZ+9Ef/DKJDJcSACn0KfLNcd4xO69E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1869/1887] sched/psi: Create the psimon kthread outside of cgroup_mutex
Date: Wed, 28 Oct 2026 18:06:05 +0100
Message-ID: <20261028170541.985631801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit fadeedd7cfc5d73d33fa3d7ac54b9b27aabd09d2 ]

a5b98009f16d ("sched/psi: fix race between file release and pressure write")
made pressure_write() hold cgroup_mutex across psi_trigger_create(), which
forks the psimon kthread for the first rtpoll trigger. As kthread creation
depends on the whole fork path, the commit inadvertently created a lot of
unwanted locking dependencies from cgroup_mutex.

sched_ext got hit by one: its enable path blocks forks and then grabs
cgroup_mutex, so a pressure write racing a scheduler enable deadlocks, with
every other fork piling up behind.

Fix it by splitting trigger creation so that the worker is forked with
cgroup_mutex dropped and the kernfs active reference left broken. The latter
matters because rmdir and cgroup.pressure writes drain active references
under cgroup_mutex. Publishing the trigger last keeps error reporting
synchronous and preserves the of->priv lifetime rules.

The trigger registered in the first stage pins the group's rtpoll machinery
across the unlocked window, leaving only creation races to resolve. The
catch-up poll on installation covers scheduling attempts dropped while there
was no worker.

v2: Retagged sched/psi (was cgroup).

Fixes: a5b98009f16d ("sched/psi: fix race between file release and pressure write")
Cc: stable@vger.kernel.org
Cc: Edward Adam Davis <eadavis@qq.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>
Reported-by: Matt Fleming <mfleming@cloudflare.com>
Closes: https://lore.kernel.org/all/20260710100441.2653477-1-matt@readmodwrite.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Matt Fleming <mfleming@cloudflare.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/psi.h    |  4 ++-
 kernel/cgroup/cgroup.c | 23 +++++++++++++-
 kernel/sched/psi.c     | 69 ++++++++++++++++++++++++++++++++----------
 3 files changed, 78 insertions(+), 18 deletions(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index e0745873e3f26..7966e3ac03b99 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -25,7 +25,9 @@ void psi_memstall_leave(unsigned long *flags);
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
 struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 				       enum psi_res res, struct file *file,
-				       struct kernfs_open_file *of);
+				       struct kernfs_open_file *of,
+				       bool *need_rtpoll_worker);
+int psi_trigger_create_rtpoll_worker(struct psi_group *group);
 void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 77e3e6d9ff26c..92283899cd95b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3790,6 +3790,7 @@ static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
 	struct psi_group *psi;
+	bool need_rtpoll_worker;
 	ssize_t ret = 0;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
@@ -3809,12 +3810,32 @@ static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
 	}
 
 	psi = cgroup_psi(cgrp);
-	new = psi_trigger_create(psi, buf, res, of->file, of);
+	new = psi_trigger_create(psi, buf, res, of->file, of,
+				 &need_rtpoll_worker);
 	if (IS_ERR(new)) {
 		ret = PTR_ERR(new);
 		goto out_unlock;
 	}
 
+	/*
+	 * The worker fork must run with neither cgroup_mutex nor the file's
+	 * kernfs active reference held. The latter is broken since
+	 * cgroup_kn_lock_live(). @of->priv may be released while unlocked, so
+	 * recheck before publishing @new.
+	 */
+	if (need_rtpoll_worker) {
+		cgroup_unlock();
+		ret = psi_trigger_create_rtpoll_worker(psi);
+		cgroup_lock();
+
+		if (!ret && !of->priv)
+			ret = -ENODEV;
+		if (ret) {
+			psi_trigger_destroy(new);
+			goto out_unlock;
+		}
+	}
+
 	smp_store_release(&ctx->psi.trigger, new);
 
 out_unlock:
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 5294ba4664c60..2d61e95bb398a 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1291,9 +1291,44 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
 	return 0;
 }
 
+/*
+ * Create @group's rtpoll worker after psi_trigger_create() reported the need
+ * for one. kthread creation depends on the whole fork path and we don't want
+ * all of that nested inside cgroup_mutex, so the caller must drop it and any
+ * other lock that forks can wait behind. If two callers race, the loser stops
+ * its never-woken kthread.
+ */
+int psi_trigger_create_rtpoll_worker(struct psi_group *group)
+{
+	struct task_struct *task;
+
+	task = kthread_create(psi_rtpoll_worker, group, "psimon");
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+
+	scoped_guard(mutex, &group->rtpoll_trigger_lock) {
+		if (!rcu_access_pointer(group->rtpoll_task)) {
+			atomic_set(&group->rtpoll_wakeup, 0);
+			wake_up_process(task);
+			rcu_assign_pointer(group->rtpoll_task, task);
+
+			/*
+			 * Poll once to catch up on scheduling attempts dropped
+			 * while there was no rtpoll worker.
+			 */
+			psi_schedule_rtpoll_work(group, 1, true);
+			return 0;
+		}
+	}
+
+	kthread_stop(task);
+	return 0;
+}
+
 struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 				       enum psi_res res, struct file *file,
-				       struct kernfs_open_file *of)
+				       struct kernfs_open_file *of,
+				       bool *need_rtpoll_worker)
 {
 	struct psi_trigger *t;
 	enum psi_states state;
@@ -1301,6 +1336,8 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 	bool privileged;
 	u32 window_us;
 
+	*need_rtpoll_worker = false;
+
 	if (static_branch_likely(&psi_disabled))
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -1362,26 +1399,14 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 	if (privileged) {
 		mutex_lock(&group->rtpoll_trigger_lock);
 
-		if (!rcu_access_pointer(group->rtpoll_task)) {
-			struct task_struct *task;
-
-			task = kthread_create(psi_rtpoll_worker, group, "psimon");
-			if (IS_ERR(task)) {
-				kfree(t);
-				mutex_unlock(&group->rtpoll_trigger_lock);
-				return ERR_CAST(task);
-			}
-			atomic_set(&group->rtpoll_wakeup, 0);
-			wake_up_process(task);
-			rcu_assign_pointer(group->rtpoll_task, task);
-		}
-
 		list_add(&t->node, &group->rtpoll_triggers);
 		group->rtpoll_min_period = min(group->rtpoll_min_period,
 			div_u64(t->win.size, UPDATES_PER_WINDOW));
 		group->rtpoll_nr_triggers[t->state]++;
 		group->rtpoll_states |= (1 << t->state);
 
+		*need_rtpoll_worker = !rcu_access_pointer(group->rtpoll_task);
+
 		mutex_unlock(&group->rtpoll_trigger_lock);
 	} else {
 		mutex_lock(&group->avgs_lock);
@@ -1536,6 +1561,8 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	size_t buf_size;
 	struct seq_file *seq;
 	struct psi_trigger *new;
+	bool need_rtpoll_worker;
+	int ret;
 
 	if (static_branch_likely(&psi_disabled))
 		return -EOPNOTSUPP;
@@ -1560,12 +1587,22 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 		return -EBUSY;
 	}
 
-	new = psi_trigger_create(&psi_system, buf, res, file, NULL);
+	new = psi_trigger_create(&psi_system, buf, res, file, NULL,
+				 &need_rtpoll_worker);
 	if (IS_ERR(new)) {
 		mutex_unlock(&seq->lock);
 		return PTR_ERR(new);
 	}
 
+	if (need_rtpoll_worker) {
+		ret = psi_trigger_create_rtpoll_worker(&psi_system);
+		if (ret) {
+			psi_trigger_destroy(new);
+			mutex_unlock(&seq->lock);
+			return ret;
+		}
+	}
+
 	smp_store_release(&seq->private, new);
 	mutex_unlock(&seq->lock);
 
-- 
2.53.0



