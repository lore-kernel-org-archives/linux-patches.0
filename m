Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045744;
	b=jNmGsX2NsHcjga/wL18SxxK2atEZIOdESPSxoP4xvs8YAhr8peWjBTg4OyJ6x+wAq7bj
	 YB0aNEeN65exrpyFNsxd9kp7vOdoo1kLK29HDaCSUH75t9cE5q+eXlfnJhKAk13NZDrKH
	 7gtefwIArfVzz/8J9qb9hanAZHbh/8BL1klMD3ojA6ISXTRL332CELqHwEy2dDdhIiTbs
	 /n4bvqAINd2Bu9UAI7pUoiNPqaENXeowcz9Rr9ATp2Ts2TngZtrbCvVDLriMgkAEfk2gn
	 l1/y99bfzE63sSucXr5SUUo96dU5y7RKJX3GZmhTatBnJJnyPNnRVQ8p8AwAmg2ZTrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bPBiTbBmX6FiO7aHv9B/lvTOq1ZR0IHobWvWz6YDZMA=;
	b=H7Gv+8ltasezj9C06MG3qZTQm0f1x8xs6HH8HTWXHRVKmVznH1NoWTqj6q+X5s9KaRIL
	 N3A5DxRodA8aExcI+/HLsUSUwn+m9Ya78r3p2xI6hATKAjwfx1ajhEklYc0e3rPDEew+y
	 RwQo4PM4+8Ija4nduDXWijO6pocRIyUdjAj5Op0KRnnf7uCLR1itH1zOEVxw2GMMFd20j
	 dj05TWXtT+k+r+iQNwg5C8bHnAQfapuq1Szv28mnMyTm1VWDtGndaH+KqCxqX7I7fNo0c
	 jSVUNybkNCf8mKhSlFDbffRkj4mV7zvDrOxW6/hU5tUNef5QB/uWsGWWpbGTUxDZF8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2w6xm2n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF4C606A32C;
	Wed, 18 Nov 2026 23:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2w6xm2n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7FA1F000C4;
	Wed, 18 Nov 2026 23:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045744;
	bh=bPBiTbBmX6FiO7aHv9B/lvTOq1ZR0IHobWvWz6YDZMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2w6xm2nAsxESX9OaSpF9t6dG8Yzo9Yoe/5CqVW47EVW/MxtSnqkrBqcPFAlFEvI3
	 loU1YLZD+H2wn9X+uI3kVbC1n3y8i8emq0FrT9iXDK2KUX62xE0TCEkSPOZVieZ+d+
	 T+/PIHCtpS31BFyheTj4DaLvkqIBVROic+IG0VQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kir Kolyshkin <kolyshkin@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0992/2857] cgroup: fix cgroup.kill for exited thread group leader
Date: Wed, 18 Nov 2026 15:33:46 +0100
Message-ID: <20261118150237.320711799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Kir Kolyshkin <kolyshkin@gmail.com>

[ Upstream commit da13e0e72a7329c95642c44b2d03d194ab071e04 ]

cgroup.kill does not work in case a process' thread group leader is gone
but other threads are still running. This is because __cgroup_kill()
only walks the thread group leaders and sends SIGKILL to each of them
with send_sig(), which uses PIDTYPE_PID:

1. The exited leader is still listed by CSS_TASK_ITER_PROCS as long as
   the process has live threads, but a signal directed at a single
   exiting task never takes effect: complete_signal() does not look for
   another thread to deliver it to, and __send_signal_locked() now drops
   it altogether.  The process keeps running.

2. The live threads of such a process can be migrated to another cgroup
   by writing any of their IDs to cgroup.procs, while the exited leader
   stays behind.  The destination cgroup has no thread group leader to
   iterate, so writing to its cgroup.kill does nothing at all.

In both cases the cgroup stays populated after cgroup.kill, and a
process inside a container can use this to survive the container being
killed.  This also works with a private PID namespace when the init of
the container is the process, as the PID namespace is not torn down
while init has live threads.

Case 1 can be fixed by using do_send_sig_info(..., PIDTYPE_TGID) instead
of send_sig(), so that the signal is taken by a live thread even if the
task found by the iterator is exiting. Note it was pointed out by Eric
in [1] while reviewing v2 of cgroup.kill patchset, and v3 was meant to
switch to it, but the change was only made in cgroup_post_fork(),
leaving __cgroup_kill() with send_sig().

Case 2 can only be fixed by iterating over all threads, so this is what
the fix also does. Once a thread group is being killed, its other
threads are skipped since they already have a fatal signal pending.

I ran some performance checks and the added cost is ~60 ns per every
thread on my laptop (and less than a millisecond for 10K threads),
which seems low. The time to "populated 0" seems unchanged.

The issue was found in crun by Anthropic's OSS Scanner, and crun is
getting a workaround for it [2] (which does what we needed to do
before cgroup.kill was added).

[1] https://lore.kernel.org/all/m1v97x6niq.fsf@fess.ebiederm.org/
[2] https://github.com/containers/crun/pull/2351

Fixes: 661ee6280931 ("cgroup: introduce cgroup.kill")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 92283899cd95b..2de93523cfd1e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4008,7 +4008,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 	cgrp->kill_seq++;
 	spin_unlock_irq(&css_set_lock);
 
-	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED, &it);
+	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_THREADED, &it);
 	while ((task = css_task_iter_next(&it))) {
 		/* Ignore kernel threads here. */
 		if (task->flags & PF_KTHREAD)
@@ -4018,7 +4018,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		send_sig(SIGKILL, task, 0);
+		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0



