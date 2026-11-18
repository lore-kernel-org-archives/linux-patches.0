Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015027;
	b=J5tinaPdSVXuyCutv6HKFySyb4bXp60uicUnNIPdig1mIqaHNXW4cT0ns0zvHcZCWG1t
	 mzWSraPeyFDeMQa5NgIMlIeUmqKhDeXhBHDoQ0EG3qlGSSU5w1SvZv7qFVDdXVWKNbnfb
	 MDHU/zoqy/KiNA2ri6gTnLia6j9Qwrm0tUH8Qti8hjyRVB38mtvN8v9pfdLTwL7/P03Xb
	 Bw4pqQWLDplkt1EBF4RGkREenzIF5UkCnRW3FLw76ClD9be8cc7ZAxWtX0kNg8Z7Efady
	 cL0jl8GxnqsH7PvPz4lAQg4ixFPwScMhxQ9tFP1YfvYsWetWzZdKcXn630QZX4SzHYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h8Zs6hGPoFDIRSQBwC7cpKhNKEOd9LMEYcyazcK00lc=;
	b=NoYOElxq2vjBjRmitqOaBf63kYFv0/5jqKlHwxzYg8tls8i3eJZoDhM58UhQoe68D1Dh
	 PZa+PFkiTS4p1TOYqSpv0Zcobkwk/QvVs9NKCOJId+PdWb570I+I5B4BWtmbt7fqxSlJX
	 jBUUsABo82sgz5k4dPJITV5B/T0hkCzMa7wwzKT877qZKc8bM9s2NKcgynT04/qPs01e4
	 sWwXOjPrAaMIi06XnFRNlcTSQ5bwTihaalirWALetgHVDIEn2aJTIpVDoPwmDYIbhcDEv
	 LyIZiEuAuLowwdxVJrGTkDvS+XHjeMuuZFRypUE3Gy91CYgIUukQdZGtESc1Yuj2XaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rho+IWhP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E35606A31C;
	Wed, 18 Nov 2026 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rho+IWhP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C561F000C5;
	Wed, 18 Nov 2026 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015027;
	bh=h8Zs6hGPoFDIRSQBwC7cpKhNKEOd9LMEYcyazcK00lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rho+IWhPlnPQdiOOTnNoBKaykc+ywpROB35SmScE+Bpng9Fmdi7WJlRH/PEyySYuV
	 1zTmLCo8suDvIjwA0qJE+GyHign9GoyJKYwjy92mJ977EjOqEOfTL4IEGooW9FmVqY
	 klL2dzTnLhVC0XtLy++4bgac9/q/CP33Se6X6U9I=
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
Subject: [PATCH 7.3 0007/2651] ocfs2/cluster: hold a reference on the heartbeat thread
Date: Wed, 18 Nov 2026 15:20:47 +0100
Message-ID: <20261118150248.266709404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Stable-dep-of: 0a8f258c0f01 ("ocfs2/heartbeat: serialize concurrent writes to a region's dev attribute")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/heartbeat.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index dbc146717e8f3..b45adc39aacca 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1971,18 +1971,22 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
 	o2hb_set_region_stopping(reg, false);
 
-	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
-			      reg->hr_item.ci_name);
+	hb_task = kthread_create(o2hb_thread, reg, "o2hb-%s",
+				 reg->hr_item.ci_name);
 	if (IS_ERR(hb_task)) {
 		ret = PTR_ERR(hb_task);
 		mlog_errno(ret);
 		goto out;
 	}
+	/* The thread may exit on its own, so pin it before it can run. */
+	get_task_struct(hb_task);
 
 	spin_lock(&o2hb_live_lock);
 	reg->hr_task = hb_task;
 	spin_unlock(&o2hb_live_lock);
 
+	wake_up_process(hb_task);
+
 	ret = wait_event_interruptible(o2hb_steady_queue,
 				atomic_read(&reg->hr_steady_iterations) == 0 ||
 				reg->hr_node_deleted);
@@ -2027,7 +2031,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		spin_unlock(&o2hb_live_lock);
 
 		if (hb_task)
-			kthread_stop(hb_task);
+			kthread_stop_put(hb_task);
 
 		o2hb_unmap_slot_data(reg);
 
@@ -2221,7 +2225,7 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	spin_unlock(&o2hb_live_lock);
 
 	if (hb_task)
-		kthread_stop(hb_task);
+		kthread_stop_put(hb_task);
 
 	if (o2hb_global_heartbeat_active()) {
 		spin_lock(&o2hb_live_lock);
-- 
2.53.0



