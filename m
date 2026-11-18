Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033312;
	b=N67mFFcaoAvLk5fic4Mxk9q2/aLP8r3RgZYm6ycUeOH+TJBsbK+Pak4qK8yc0Xks6SCN
	 XllRf8ly26+nO+HTcVXpRkZ+jjmKFQn0rfrQdHQLLUtHUYfQ8QVeny9LZqyh28hmBeEIH
	 +GUZ65PayisFiR8XUABwYPCbooSKszdotqeyBbfJfBeuHn8AQ1WUUkbBcevak9IDBEX3w
	 aG7Bx+BEmAQTHkDf1zi/TV6LMau4aZKYQ8L/CmghW9a30XFqo6Y6C8BQ1nRMrSAbbYssw
	 x3gma4cNWq3Hfyq1QMyT7Vbg5KNnavSUcnqg3x7CxSTlkclsvmM5b0zpYZ39B8k+v9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TqtEzRnJtZSHMg87mEepnlEYZ3EhEYrSTFdy2ZnNcDs=;
	b=TSumGEhRq4tPhGkeOv6oREOOmghWu+B+CecIUcjBk3r5lYzXSQdU496qhouFgsZ1XZH6
	 7Iov56Ys7CT4Au0+1YW6FIcNSl0jVTGecTDXG1ZoBCjtROtor7WGstaYCWsToCn/Hariq
	 qmDUD30B1QU3DVOziVfsm706KOR0zbfB3ktmHUIoHmWnlDUdbpE6AxhBTKUQ+A6GUHpo/
	 wrN5Q9D1dAWQgxRSSLAy8fQg36N7w9QgOrJb3ZTpzONVoNxG7LgUENN2RF0k7P7d2rYBd
	 R2mcVtZ/VghZnL7QqMZZ9iur+8GbNeKI4wpwf5v79C6dq+eYmYPAqMdRyVNo1WZBHog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ffL26ljy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83070606A31C;
	Wed, 18 Nov 2026 20:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ffL26ljy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848301F000C4;
	Wed, 18 Nov 2026 20:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033312;
	bh=TqtEzRnJtZSHMg87mEepnlEYZ3EhEYrSTFdy2ZnNcDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffL26ljyjwaPZB2lqGYDI7EdF1tXLNbGPFpWr76s445GuZgAfFNzQlHkZjSfXlL4H
	 sgyWo1MTCUI3XLezJDn3H5z2vUde4iwmg9E5H+TS4qzv+MBvzvPB5aKFHte5YOj8mW
	 UrsQn1yK+7btc1gz+wGVQYwAYnclmVAhndYky+64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dmitrii Chervov <fary.ru@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1723/1756] mm: fix OOM killer inaccuracy on large many-core systems
Date: Wed, 18 Nov 2026 16:04:10 +0100
Message-ID: <20261118150118.178622221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 5898aa8f9a0b42fe1f65c7364010ab15ec5c38bf ]

Use the precise, albeit slower, precise RSS counter sums for the OOM
killer task selection and console dumps.  The approximated value is too
imprecise on large many-core systems.

The following rss tracking issues were noted by Sweet Tea Dorminy [1],
which lead to picking wrong tasks as OOM kill target:

  Recently, several internal services had an RSS usage regression as part of a
  kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
  read RSS statistics in a backup watchdog process to monitor and decide if
  they'd overrun their memory budget. Now, however, a representative service
  with five threads, expected to use about a hundred MB of memory, on a 250-cpu
  machine had memory usage tens of megabytes different from the expected amount
  -- this constituted a significant percentage of inaccuracy, causing the
  watchdog to act.

  This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
  into percpu_counter") [1].  Previously, the memory error was bounded by
  64*nr_threads pages, a very livable megabyte. Now, however, as a result of
  scheduler decisions moving the threads around the CPUs, the memory error could
  be as large as a gigabyte.

  This is a really tremendous inaccuracy for any few-threaded program on a
  large machine and impedes monitoring significantly. These stat counters are
  also used to make OOM killing decisions, so this additional inaccuracy could
  make a big difference in OOM situations -- either resulting in the wrong
  process being killed, or in less memory being returned from an OOM-kill than
  expected.

Here is a (possibly incomplete) list of the prior approaches that were
used or proposed, along with their downside:

1) Per-thread rss tracking: large error on many-thread processes.

2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
   increased system time in make test workloads [1]. Moreover, the
   inaccuracy increases with O(n^2) with the number of CPUs.

3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
   error is high with systems that have lots of NUMA nodes (32 times
   the number of NUMA nodes).

commit 82241a83cd15 ("mm: fix the inaccurate memory statistics issue for
users") introduced get_mm_counter_sum() for precise proc memory status
queries for some proc files.

The simple fix proposed here is to do the precise per-cpu counters sum
every time a counter value needs to be read.  This applies to the OOM
killer task selection, oom task console dumps (printk).

This change increases the latency introduced when the OOM killer executes
in favor of doing a more precise OOM target task selection.  Effectively,
the OOM killer iterates on all tasks, for all relevant page types, for
which the precise sum iterates on all possible CPUs.

As a reference, here is the execution time of the OOM killer before/after
the change:

AMD EPYC 9654 96-Core (2 sockets)
Within a KVM, configured with 256 logical cpus.

                                  |  before  |  after   |
----------------------------------|----------|----------|
nr_processes=40                   |  0.3 ms  |   0.5 ms |
nr_processes=10000                |  3.0 ms  |  80.0 ms |

Link: https://lkml.kernel.org/r/20260114143642.47333-1-mathieu.desnoyers@efficios.com
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ Backported without changes ]
Signed-off-by: Dmitrii Chervov <fary.ru@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h |  7 +++++++
 mm/oom_kill.c      | 22 +++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 81e973784d3be..a6348b25aee22 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2731,6 +2731,13 @@ static inline unsigned long get_mm_rss(struct mm_struct *mm)
 		get_mm_counter(mm, MM_SHMEMPAGES);
 }
 
+static inline unsigned long get_mm_rss_sum(struct mm_struct *mm)
+{
+	return get_mm_counter_sum(mm, MM_FILEPAGES) +
+		get_mm_counter_sum(mm, MM_ANONPAGES) +
+		get_mm_counter_sum(mm, MM_SHMEMPAGES);
+}
+
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
 {
 	return max(mm->hiwater_rss, get_mm_rss(mm));
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 8aa712afd8ae1..53ab72f747fdf 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -229,7 +229,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss, pagetable and swap space use.
 	 */
-	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
+	points = get_mm_rss_sum(p->mm) + get_mm_counter_sum(p->mm, MM_SWAPENTS) +
 		mm_pgtables_bytes(p->mm) / PAGE_SIZE;
 	task_unlock(p);
 
@@ -403,10 +403,10 @@ static int dump_task(struct task_struct *p, void *arg)
 
 	pr_info("[%7d] %5d %5d %8lu %8lu %8lu %8lu %9lu %8ld %8lu         %5hd %s\n",
 		task->pid, from_kuid(&init_user_ns, task_uid(task)),
-		task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-		get_mm_counter(task->mm, MM_ANONPAGES), get_mm_counter(task->mm, MM_FILEPAGES),
-		get_mm_counter(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
-		get_mm_counter(task->mm, MM_SWAPENTS),
+		task->tgid, task->mm->total_vm, get_mm_rss_sum(task->mm),
+		get_mm_counter_sum(task->mm, MM_ANONPAGES), get_mm_counter_sum(task->mm, MM_FILEPAGES),
+		get_mm_counter_sum(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
+		get_mm_counter_sum(task->mm, MM_SWAPENTS),
 		task->signal->oom_score_adj, task->comm);
 	task_unlock(task);
 
@@ -598,9 +598,9 @@ static bool oom_reap_task_mm(struct task_struct *tsk, struct mm_struct *mm)
 
 	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
 			task_pid_nr(tsk), tsk->comm,
-			K(get_mm_counter(mm, MM_ANONPAGES)),
-			K(get_mm_counter(mm, MM_FILEPAGES)),
-			K(get_mm_counter(mm, MM_SHMEMPAGES)));
+			K(get_mm_counter_sum(mm, MM_ANONPAGES)),
+			K(get_mm_counter_sum(mm, MM_FILEPAGES)),
+			K(get_mm_counter_sum(mm, MM_SHMEMPAGES)));
 out_finish:
 	trace_finish_task_reaping(tsk->pid);
 out_unlock:
@@ -954,9 +954,9 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	mark_oom_victim(victim);
 	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
-		K(get_mm_counter(mm, MM_ANONPAGES)),
-		K(get_mm_counter(mm, MM_FILEPAGES)),
-		K(get_mm_counter(mm, MM_SHMEMPAGES)),
+		K(get_mm_counter_sum(mm, MM_ANONPAGES)),
+		K(get_mm_counter_sum(mm, MM_FILEPAGES)),
+		K(get_mm_counter_sum(mm, MM_SHMEMPAGES)),
 		from_kuid(&init_user_ns, task_uid(victim)),
 		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
 	task_unlock(victim);
-- 
2.53.0



