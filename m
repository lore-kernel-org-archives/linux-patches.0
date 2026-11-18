Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038857;
	b=gn/U/CZpeRmpX09AR3tj/XmlcjhwDm+iLkEx6FB6f4Y1ERCcTDYGM6s5PKaOvDzIhtJa
	 s07FsNHQ4iUbZLhv5potSUczyPTETThYrTn7ci6Xgg//p1flUtpPYQTvk4bgqyeYAMIZO
	 DMem/We6CwY7DcHXCKmBSknyPviY8sndZH/rvvQZnm7X0Kq7BoIUWfxVU1LHiPJjYK6nL
	 V04QrdCDu6BcubzXc4NB1f96WEoqg+iHQjg/BJ4hqEsdHrjz7XSqBoF4WpamoFesXTMc+
	 xLdT/SnmiKEpTA5MibuPqc7GJ6bXA3NWxzs/bsuaytWJj+PbTi+m546gwlnWYpSFo3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j4gNsQKV4h2/mQ/BH0FGLkeQfQ+kMubNRZLkBSo7iq0=;
	b=giz+SIHz/qBkoe7iJeciRLWlCpYQf7ax4srpdc5ZL/n5rKP/FrBnIwRjgWlPZUx3x+xi
	 4d+TWsVXq2MlxLj60uE/+uBvpI3FoQwQHqakUEt+INrXQjnNKY6ExjQh6YRxeULiIdXxu
	 4ZD/ioNrHhKbJ0zjI/t7ocRX+iV1Fz4lUyMxtonuzDT5XryiT2SS84pM7PByDiQO+POvg
	 EzG6QnfWmPdT4FkdLWYDJcTSDNochaSntUk9xPcLV7zpWJtMOxzfzx0EeH+riGXnkNcGQ
	 5t/ll7eKc9fatH24oYIlBlnge7T4GvVyf5cvjSr5TG0j4SnQVd/cqeHNLU2LbS3ynIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j3DHoPXF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDA6606A320;
	Wed, 18 Nov 2026 21:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j3DHoPXF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864A61F000C4;
	Wed, 18 Nov 2026 21:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038857;
	bh=j4gNsQKV4h2/mQ/BH0FGLkeQfQ+kMubNRZLkBSo7iq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3DHoPXFflsp1Gxe0vUNnJRwxndFu33SZWji+Vv3/g2L/X4pbH3x2w5oncOkgGdy3
	 SCQ/D//5TzyWtPBFt5sDvp6dW9Rjt5uoBLzEs3BisPTzhCKN68L5T/xDGYh/BPWc8H
	 JXt/bihHwatdsnJE3SaAExXPs3oXvRL0OgEJ2TdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1892/3318] ocfs2/cluster: hold a reference on the heartbeat thread
Date: Wed, 18 Nov 2026 15:41:54 +0100
Message-ID: <20261118150418.763708753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit aa2e38aabaae87236290e486a2b77cfa3adfbebe ]

Since commit 688bc88e2046 ("ocfs2/cluster: keep heartbeat local node
stable"), o2hb_thread() leaves its loop and returns when the local node
changes, for example after "echo 0 > node/<name>/local".  The thread was
started with kthread_run() and nothing holds a reference to its
task_struct, so the task is freed once it exits, while reg->hr_task still
points to it.

Reading the region's pid attribute then reads the freed task, and removing
the region calls kthread_stop() on it:

  BUG: KASAN: slab-use-after-free in o2hb_region_pid_show+0xb3/0xc0
  refcount_t: addition on 0; use-after-free.
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:kthread_stop+0xb1/0x390

The thread could already return by itself before, when heartbeat start was
aborted or on an unclean stop, but the local node change makes it
reachable from userspace at any time.

Create the thread, take a reference on it and only then wake it, so the
reference cannot race with the thread exiting.  Drop it with
kthread_stop_put().

Link: https://lore.kernel.org/20260923010149.14391-1-kmehltretter@gmail.com
Fixes: 688bc88e2046 ("ocfs2/cluster: keep heartbeat local node stable")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260616074931.3774929-1-zzzccc427%40gmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Heming Zhao <heming.zhao@suse.com>
[ sashal: adjusted context to keep the existing mutex_unlock() before the wait, placing wake_up_process() ahead of it, and the error path goes to out3 instead of out. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/heartbeat.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8f089d0b03c5b..536bfa59201e0 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1956,18 +1956,22 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
 	o2hb_set_region_stopping(reg, false);
 
-	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
-			      reg->hr_item.ci_name);
+	hb_task = kthread_create(o2hb_thread, reg, "o2hb-%s",
+				 reg->hr_item.ci_name);
 	if (IS_ERR(hb_task)) {
 		ret = PTR_ERR(hb_task);
 		mlog_errno(ret);
 		goto out3;
 	}
+	/* The thread may exit on its own, so pin it before it can run. */
+	get_task_struct(hb_task);
 
 	spin_lock(&o2hb_live_lock);
 	reg->hr_task = hb_task;
 	spin_unlock(&o2hb_live_lock);
 
+	wake_up_process(hb_task);
+
 	/*
 	 * Don't hold hr_dev_mutex across the wait, which can take seconds.
 	 * hr_bdev is already set, so other writers still get -EINVAL.
@@ -2018,7 +2022,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		spin_unlock(&o2hb_live_lock);
 
 		if (hb_task)
-			kthread_stop(hb_task);
+			kthread_stop_put(hb_task);
 
 		o2hb_unmap_slot_data(reg);
 
@@ -2217,7 +2221,7 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	spin_unlock(&o2hb_live_lock);
 
 	if (hb_task)
-		kthread_stop(hb_task);
+		kthread_stop_put(hb_task);
 
 	if (o2hb_global_heartbeat_active()) {
 		spin_lock(&o2hb_live_lock);
-- 
2.53.0



