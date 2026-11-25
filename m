Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621544;
	b=Kp7KEVzkCkHtwbcn43N4IpertnvWDGx6IkNxyIPnkE4fE1n/z8lMyJfoLqm7J1+CdfCc
	 ZFSyek3hAy7bVdhlsiMZn1O7GIGViQn9sPhaAGw01qliY2HXVy1rVBeiZztDbi0xZBgE1
	 i1GsAaoNBWPc2bUdAi6ZxdPnYVW61GPfr9rooGZO3qLpoUpBCJAnhIU8qX//DzIn9dEAW
	 gPdQsw1Kq+QDhxDcrLZsomBNE3S16bnQ+2jXfjg9W62CfCrey9zN6sMT3gN9JDcci0wgx
	 5yf5bWLsGqv1mmjdkwOV/5saai7wYevPIQyjq3StW2NcdoyI2UYqu/PznuYXfwgqzYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=es/EhKC8mBURzAMCp0lyQ4dFBrP8NaupHCW84RZXHbw=;
	b=m88NisvOcaA+GHNG00AHyUjByNxTkoe5hZULQjCBH+ovbSqrOE8WcNu8/gPQ9zWshwFU
	 JvEWoCEkKCasCHoljXRK//Qqkd31EmZwppNmdNcso56Omb/E0OryA8iiGduBGD76139le
	 bRXDwwaRJNE4l99YZ4CtIY9VJhIAYSH+vItYGvwkAeO9Vn4qNsQcp82hR9ue5nXGNjS/R
	 sWOLNeAegSHgq7S5f3XfdxywAACP3l7OJCc595HNaPhEoOIwLSCs9P8hOTyG59Pov0wCZ
	 bSYUCgDY5B1+sLz8N0Ws87qq++FgjiB6snvWReapC4eBBdf9ysBOWddWjjiB+tj277w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyWLB2zB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B5E606A321;
	Wed, 25 Nov 2026 15:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyWLB2zB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CB31F000C4;
	Wed, 25 Nov 2026 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621544;
	bh=es/EhKC8mBURzAMCp0lyQ4dFBrP8NaupHCW84RZXHbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyWLB2zB50c+EAhzZghAU6wdf4q0jvpBisjMQRnl7eSD4EVdXZJLpI5QUBhJSxw2W
	 xdwy1lF30xbgRrRbscBH68E8FXNX4f55d+e02D8W2mBlpERQjRfI/McZ5aeZ5sE6e3
	 VuObo48owrN/KjsbIU2sezvBGQG2vAGl0UoF/bx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 213/990] blk-mq: add a new queue sysfs attribute async_depth
Date: Wed, 25 Nov 2026 15:26:20 +0100
Message-ID: <20261125143827.079429845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit f98afe4f31bb8b07fea318606c08030c2049587e ]

Add a new field async_depth to request_queue and related APIs, this is
currently not used, following patches will convert elevators to use
this instead of internal async_depth.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3a9892bca4dd ("blk-mq: reset queue state on scheduler teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       |  1 +
 block/blk-mq.c         |  6 ++++++
 block/blk-sysfs.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 block/elevator.c       |  1 +
 include/linux/blkdev.h |  1 +
 5 files changed, 51 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index c2300b201d4ff..0eba4243ebfd8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -463,6 +463,7 @@ struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id)
 	fs_reclaim_release(GFP_KERNEL);
 
 	q->nr_requests = BLKDEV_DEFAULT_RQ;
+	q->async_depth = BLKDEV_DEFAULT_RQ;
 
 	return q;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7bdc9b1d7b746..530be27759c0e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4704,6 +4704,7 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	spin_lock_init(&q->requeue_lock);
 
 	q->nr_requests = set->queue_depth;
+	q->async_depth = set->queue_depth;
 
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 	blk_mq_map_swqueue(q);
@@ -5083,6 +5084,11 @@ struct elevator_tags *blk_mq_update_nr_requests(struct request_queue *q,
 		q->elevator->et = et;
 	}
 
+	/*
+	 * Preserve relative value, both nr and async_depth are at most 16 bit
+	 * value, no need to worry about overflow.
+	 */
+	q->async_depth = max(q->async_depth * nr / q->nr_requests, 1);
 	q->nr_requests = nr;
 	if (q->elevator && q->elevator->type->ops.depth_updated)
 		q->elevator->type->ops.depth_updated(q);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index af12526d866a9..2b251460db45b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -133,6 +133,46 @@ queue_requests_store(struct gendisk *disk, const char *page, size_t count)
 	return ret;
 }
 
+static ssize_t queue_async_depth_show(struct gendisk *disk, char *page)
+{
+	guard(mutex)(&disk->queue->elevator_lock);
+
+	return queue_var_show(disk->queue->async_depth, page);
+}
+
+static ssize_t
+queue_async_depth_store(struct gendisk *disk, const char *page, size_t count)
+{
+	struct request_queue *q = disk->queue;
+	unsigned int memflags;
+	unsigned long nr;
+	int ret;
+
+	if (!queue_is_mq(q))
+		return -EINVAL;
+
+	ret = queue_var_store(&nr, page, count);
+	if (ret < 0)
+		return ret;
+
+	if (nr == 0)
+		return -EINVAL;
+
+	memflags = blk_mq_freeze_queue(q);
+	scoped_guard(mutex, &q->elevator_lock) {
+		if (q->elevator) {
+			q->async_depth = min(q->nr_requests, nr);
+			if (q->elevator->type->ops.depth_updated)
+				q->elevator->type->ops.depth_updated(q);
+		} else {
+			ret = -EINVAL;
+		}
+	}
+	blk_mq_unfreeze_queue(q, memflags);
+
+	return ret;
+}
+
 static ssize_t queue_ra_show(struct gendisk *disk, char *page)
 {
 	ssize_t ret;
@@ -538,6 +578,7 @@ static struct queue_sysfs_entry _prefix##_entry = {	\
 }
 
 QUEUE_RW_ENTRY(queue_requests, "nr_requests");
+QUEUE_RW_ENTRY(queue_async_depth, "async_depth");
 QUEUE_RW_ENTRY(queue_ra, "read_ahead_kb");
 QUEUE_LIM_RW_ENTRY(queue_max_sectors, "max_sectors_kb");
 QUEUE_LIM_RO_ENTRY(queue_max_hw_sectors, "max_hw_sectors_kb");
@@ -760,6 +801,7 @@ static struct attribute *blk_mq_queue_attrs[] = {
 	 */
 	&elv_iosched_entry.attr,
 	&queue_requests_entry.attr,
+	&queue_async_depth_entry.attr,
 #ifdef CONFIG_BLK_WBT
 	&queue_wb_lat_entry.attr,
 #endif
diff --git a/block/elevator.c b/block/elevator.c
index 7a97998cd8bd7..3bcd37c2aa340 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -589,6 +589,7 @@ static int elevator_switch(struct request_queue *q, struct elv_change_ctx *ctx)
 		blk_queue_flag_clear(QUEUE_FLAG_SQ_SCHED, q);
 		q->elevator = NULL;
 		q->nr_requests = q->tag_set->queue_depth;
+		q->async_depth = q->tag_set->queue_depth;
 	}
 	blk_add_trace_msg(q, "elv switch: %s", ctx->name);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5d073a96324aa..620093f1e5449 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -546,6 +546,7 @@ struct request_queue {
 	 * queue settings
 	 */
 	unsigned int		nr_requests;	/* Max # of requests */
+	unsigned int		async_depth;	/* Max # of async requests */
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	struct blk_crypto_profile *crypto_profile;
-- 
2.53.0



