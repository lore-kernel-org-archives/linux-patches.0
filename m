Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617675;
	b=ZpplcDd5EQiNXf9YWAu5UfwFtujsNiDdS4NHiJAp1cxTrLa5jD+llskaVbYUHiI+FYms
	 h145qhMlyUol+xarBI/vK/Ak2VNbuB/GUX/xdlVS6hGO7Gc7Tqtdpd7Jbk0Gd8m7Fh4+t
	 G2zgPDhiygurAid90GxeVMyV+ijHmZpL8211Oa9X+7O5VsBMKrr7ZYNxeBNvORdvGEjSE
	 OTetgODC4V4hui8iTvw8UdgqrjuFhD3C3wxnLJ2dNFd+hxti/xWMBgCA6flu3vGmSyENx
	 4tUVhTsU83QCITueFdqKpGe2AFKCtUK5TdzY6LygkroK/HjLp6pz+jI7YPq4Yt2ygJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iwN5hPTSzveawySJShxloU+1Izf37UGRFUPZJ4tcycc=;
	b=JgB+O/qzJHVKbEST7/grobC1AyVN9E5ZUyAAItJ+zfO+zkR4hmYn6l2mVLikpvMcVzAI
	 lyX+8AxNCLRR97y2Rf8eIRfbqJxMVY8XUWB/rIiLfFRDd7bRIiybqNXwZ1hElWQK1cLZe
	 4q2s8FmDixDMeNb5FMlZzZfTaazaMaj0lKn+668NPfYLq47vgRos5nYXgIKEcQDDuQ5Pf
	 36bnktzIzZC2YlHgICs832nivPHJ9thSFhg4pe95lUk57kuEuCm8Oobw8kzC8U9ODWCvz
	 jYBPMWlTTLu/G3m5DwLTnqm/vrwAFNoL+t5lyJGcaxjSmn/v7vpclwG+Vh/263ZOjbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMKrzUNG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC5A606A31E;
	Wed, 25 Nov 2026 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMKrzUNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7AA1F000D3;
	Wed, 25 Nov 2026 14:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617674;
	bh=iwN5hPTSzveawySJShxloU+1Izf37UGRFUPZJ4tcycc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMKrzUNGAqhJ9r1xOFohwQA0EfIpTQVPvS2trBIuqKEhRASp4cwSnjJNzc02NcmN0
	 uptKn2K5yggwhF5wBJeD5DchPIbzLZjEz7Q2y2eM1VduONp7qZMPu8B4UJb8TsdTnE
	 lBaUlMLxUvPcbJjH/CzJP4IV1n+osSnSh7JV0sAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Malyshev <mike.malyshev@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0022/1005] io_uring/io-wq: apply the current cpuset to new workers
Date: Wed, 25 Nov 2026 15:22:40 +0100
Message-ID: <20261125143822.255563128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mikhail Malyshev <mike.malyshev@gmail.com>

Commit 0659e44ce739ecd856164c75a5325b7959a2921d upstream.

Since commit 84eacf177faa ("io_uring/io-wq: inherit cpuset of cgroup in
io worker"), io_wq_create() copies the cpuset of the creating task into
wq->cpu_mask, and io_init_new_worker() gives each new worker that copy.
A cpuset change, or a move of the task to another cgroup, updates the
workers that exist but not the copy, so workers started later run on
the CPUs the cgroup had when the io-wq was created, which may since
have been given to other tasks. Workers come and go for the life of the
io-wq, and a worker that cpuset moved is also retired at its next idle
timeout and replaced on the old CPUs.

Keep wq->cpu_mask for the affinity of the io-wq itself, all CPUs or the
mask set with IORING_REGISTER_IOWQ_AFF, and intersect it with the cpuset
of the worker when the worker starts, falling back to the cpuset if the
two do not intersect, as __set_cpus_allowed_ptr() does. Use the same
mask in the idle exit test, and go back to all CPUs when the registered
affinity is removed.

Fixes: 84eacf177faa ("io_uring/io-wq: inherit cpuset of cgroup in io worker")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Malyshev <mike.malyshev@gmail.com>
Link: https://patch.msgid.link/20261111162705.1150983-1-mike.malyshev@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 358f32888a853..d2ef08d65ec89 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -738,6 +738,34 @@ static bool io_worker_retire(struct io_wq_acct *acct, struct io_worker *worker)
 	return false;
 }
 
+/*
+ * The CPUs a worker of @wq runs on: those of the io-wq affinity that the
+ * worker's cpuset allows, or the cpuset if they have none in common, as the
+ * scheduler does with a task's requested affinity when its cpuset changes.
+ * Read the cpuset each time: it can change while the io-wq exists.
+ */
+static void io_wq_worker_cpus(struct io_wq *wq, struct task_struct *tsk,
+			      struct cpumask *cpus)
+{
+	cpuset_cpus_allowed(tsk, cpus);
+	if (cpumask_intersects(cpus, wq->cpu_mask))
+		cpumask_and(cpus, cpus, wq->cpu_mask);
+}
+
+/* Is the current worker on a CPU that a new worker would not get? */
+static bool io_wq_worker_off_cpus(struct io_wq *wq)
+{
+	cpumask_var_t cpus;
+	bool off;
+
+	if (!alloc_cpumask_var(&cpus, GFP_KERNEL))
+		return false;
+	io_wq_worker_cpus(wq, current, cpus);
+	off = !cpumask_test_cpu(raw_smp_processor_id(), cpus);
+	free_cpumask_var(cpus);
+	return off;
+}
+
 static int io_wq_worker(void *data)
 {
 	struct io_worker *worker = data;
@@ -816,8 +844,7 @@ static int io_wq_worker(void *data)
 		}
 		if (!ret) {
 			last_timeout = true;
-			exit_mask = !cpumask_test_cpu(raw_smp_processor_id(),
-							wq->cpu_mask);
+			exit_mask = io_wq_worker_off_cpus(wq);
 		}
 	}
 
@@ -867,9 +894,16 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 static void io_init_new_worker(struct io_wq *wq, struct io_wq_acct *acct, struct io_worker *worker,
 			       struct task_struct *tsk)
 {
+	cpumask_var_t cpus;
+
 	tsk->worker_private = worker;
 	worker->task = tsk;
-	set_cpus_allowed_ptr(tsk, wq->cpu_mask);
+	/* Without a mask, the worker keeps its creator's CPUs. */
+	if (alloc_cpumask_var(&cpus, GFP_KERNEL)) {
+		io_wq_worker_cpus(wq, tsk, cpus);
+		set_cpus_allowed_ptr(tsk, cpus);
+		free_cpumask_var(cpus);
+	}
 
 	raw_spin_lock(&acct->workers_lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &acct->free_list);
@@ -1366,7 +1400,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	if (!alloc_cpumask_var(&wq->cpu_mask, GFP_KERNEL))
 		goto err;
-	cpuset_cpus_allowed(data->task, wq->cpu_mask);
+	cpumask_copy(wq->cpu_mask, cpu_possible_mask);
 	wq->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 	wq->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 				task_rlimit(current, RLIMIT_NPROC);
@@ -1588,7 +1622,7 @@ int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask)
 		else
 			ret = -EINVAL;
 	} else {
-		cpumask_copy(tctx->io_wq->cpu_mask, allowed_mask);
+		cpumask_copy(tctx->io_wq->cpu_mask, cpu_possible_mask);
 	}
 	rcu_read_unlock();
 
-- 
2.53.0



