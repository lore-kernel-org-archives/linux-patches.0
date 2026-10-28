Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213626;
	b=TGPy5CZA3UdTjDbYDygnjjdMeA/yBFG+B6sZFFhFGgJ18M+6CVRRuVJSGSmV7HeLheuu
	 0ug9XtxpsNjTFBRdyDNT6hQtB6eIv35nsM/RzNVMWEJfFB8392rR464LJSoybYtjuZHGB
	 7NzPSWY2EIO3fScnRml7jbz+L+K3YV8dOpS9KErOOzHWZiywD2hIWPi062FgnaL7N+Uv6
	 CyzhxYhkf5QtCEgeNJwUNv4CQIrruotEwDWZzpIZMI2q+op7aVSg0JrrkNIfwQ0HhAPSY
	 lcxI9DiyJYImfHj+jZG5yAARWef1Gkt1DM7iSqr/DYOtpU8FuBbchvZSTG+Xg9pzesQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f/D2HJUCBFrtfMDiJwV9N9o+Q+IrNV5ipOQ5MK0LNp8=;
	b=RxyDNhIe0o9DspsgtqBOi8UPrKwemwu7r3QtX07lGBT46q4yRg3my4RyfatC4tXH2/j6
	 4p9OJaGP12a9uqhK5JU8I1zThBCl1gi8Blq6MS0lBcUIBv9yrQ9XvwJ4pv31VX1xheQcW
	 dFOl7m81MfpQ31JRWUaQYjjBBkpMQpLuIMiCqnil9t8Rcm7R+ANpIIUXAdSQDd8GO/MZL
	 qBCLs4HygMxioNLegqc4SJzQs7tGP5wGu7oxhsPx0JPUheW83zet3AzqzRXiGR84RMDBd
	 DVOsLMy9uH73MrFLcNutwp0PSTkAmZggHX9Bw2N5KSqhRPW/vqJSUsEbTX9fzZwjOCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFkqvmsC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F54606A31A;
	Wed, 28 Oct 2026 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFkqvmsC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252CE1F01825;
	Wed, 28 Oct 2026 18:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213625;
	bh=f/D2HJUCBFrtfMDiJwV9N9o+Q+IrNV5ipOQ5MK0LNp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFkqvmsCWtZ6x2/+3jRkdj1O3f/bgnt4gOSCCOR4coiyBcr6nJITJlSj/qB7oeY1G
	 zXKuvziIT169ts36iYTH6FzrPTk/x+XwV0CpkFjnT80jlQpAdCSRamxjT5afc4fHCt
	 VBjyBlkSNilcfctIPpyocH+xl3QkjyeGzRXnoWF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0570/1887] block/rq_qos: protect rq_qos apis with a new lock
Date: Wed, 28 Oct 2026 17:44:26 +0100
Message-ID: <20261028170512.373341103@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit a13bd91be22318768d55470cbc0b0f4488ef9edf ]

commit 50e34d78815e ("block: disable the elevator int del_gendisk")
move rq_qos_exit() from disk_release() to del_gendisk(), this will
introduce some problems:

1) If rq_qos_add() is triggered by enabling iocost/iolatency through
   cgroupfs, then it can concurrent with del_gendisk(), it's not safe to
   write 'q->rq_qos' concurrently.

2) Activate cgroup policy that is relied on rq_qos will call
   rq_qos_add() and blkcg_activate_policy(), and if rq_qos_exit() is
   called in the middle, null-ptr-dereference will be triggered in
   blkcg_activate_policy().

3) blkg_conf_open_bdev() can call blkdev_get_no_open() first to find the
   disk, then if rq_qos_exit() from del_gendisk() is done before
   rq_qos_add(), then memory will be leaked.

This patch add a new disk level mutex 'rq_qos_mutex':

1) The lock will protect rq_qos_exit() directly.

2) For wbt that doesn't relied on blk-cgroup, rq_qos_add() can only be
   called from disk initialization for now because wbt can't be
   destructed until rq_qos_exit(), so it's safe not to protect wbt for
   now. Hoever, in case that rq_qos dynamically destruction is supported
   in the furture, this patch also protect rq_qos_add() from wbt_init()
   directly, this is enough because blk-sysfs already synchronize
   writers with disk removal.

3) For iocost and iolatency, in order to synchronize disk removal and
   cgroup configuration, the lock is held after blkdev_get_no_open()
   from blkg_conf_open_bdev(), and is released in blkg_conf_exit().
   In order to fix the above memory leak, disk_live() is checked after
   holding the new lock.

Fixes: 50e34d78815e ("block: disable the elevator int del_gendisk")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230414084008.2085155-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c     | 12 ++++++++++++
 block/blk-core.c       |  1 +
 block/blk-iocost.c     |  4 ++++
 block/blk-rq-qos.c     |  2 ++
 block/blk-rq-qos.h     | 18 ++++--------------
 block/blk-wbt.c        |  2 ++
 include/linux/blkdev.h |  1 +
 7 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 7d7c99d93bdb8..3a33ec0af8419 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -656,6 +656,13 @@ struct block_device *blkcg_conf_open_bdev(char **inputp)
 		return ERR_PTR(-ENODEV);
 	}
 
+	mutex_lock(&bdev->bd_queue->rq_qos_mutex);
+	if (!disk_live(bdev->bd_disk)) {
+		mutex_unlock(&bdev->bd_queue->rq_qos_mutex);
+		blkdev_put_no_open(bdev);
+		return ERR_PTR(-ENODEV);
+	}
+
 	*inputp = input;
 	return bdev;
 }
@@ -779,6 +786,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 fail_exit_queue:
 	blk_queue_exit(q);
 fail:
+	mutex_unlock(&q->rq_qos_mutex);
 	blkdev_put_no_open(bdev);
 	/*
 	 * If queue was bypassing, we should retry.  Do so after a
@@ -803,9 +811,11 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
  */
 void blkg_conf_finish(struct blkg_conf_ctx *ctx)
 	__releases(&ctx->bdev->bd_queue->queue_lock) __releases(rcu)
+	__releases(&ctx->bdev->bd_queue->rq_qos_mutex)
 {
 	spin_unlock_irq(&bdev_get_queue(ctx->bdev)->queue_lock);
 	rcu_read_unlock();
+	mutex_unlock(&ctx->bdev->bd_queue->rq_qos_mutex);
 	blkdev_put_no_open(ctx->bdev);
 }
 EXPORT_SYMBOL_GPL(blkg_conf_finish);
@@ -1297,7 +1307,9 @@ int blkcg_init_disk(struct gendisk *disk)
 	if (ret)
 		goto err_ioprio_exit;
 
+	mutex_lock(&q->rq_qos_mutex);
 	ret = blk_iolatency_init(disk);
+	mutex_unlock(&q->rq_qos_mutex);
 	if (ret)
 		goto err_throtl_exit;
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 1fcd80a1c54fd..641bc0fa8a4ad 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -412,6 +412,7 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
 	mutex_init(&q->debugfs_mutex);
 	mutex_init(&q->sysfs_lock);
 	mutex_init(&q->sysfs_dir_lock);
+	mutex_init(&q->rq_qos_mutex);
 	spin_lock_init(&q->queue_lock);
 
 	init_waitqueue_head(&q->mq_freeze_wq);
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 93482cc420c97..3989d8c796b0f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3309,11 +3309,13 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
+	mutex_unlock(&bdev->bd_queue->rq_qos_mutex);
 	blkdev_put_no_open(bdev);
 	return nbytes;
 einval:
 	ret = -EINVAL;
 err:
+	mutex_unlock(&bdev->bd_queue->rq_qos_mutex);
 	blkdev_put_no_open(bdev);
 	return ret;
 }
@@ -3434,12 +3436,14 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
+	mutex_unlock(&bdev->bd_queue->rq_qos_mutex);
 	blkdev_put_no_open(bdev);
 	return nbytes;
 
 einval:
 	ret = -EINVAL;
 err:
+	mutex_unlock(&bdev->bd_queue->rq_qos_mutex);
 	blkdev_put_no_open(bdev);
 	return ret;
 }
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index a319311d1ced1..aa45f073d51b0 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -288,9 +288,11 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 
 void rq_qos_exit(struct request_queue *q)
 {
+	mutex_lock(&q->rq_qos_mutex);
 	while (q->rq_qos) {
 		struct rq_qos *rqos = q->rq_qos;
 		q->rq_qos = rqos->next;
 		rqos->ops->exit(rqos);
 	}
+	mutex_unlock(&q->rq_qos_mutex);
 }
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 1ef1f7d4bc3cb..98be0e02a86c1 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -87,21 +87,18 @@ static inline void rq_wait_init(struct rq_wait *rq_wait)
 
 static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 {
+	lockdep_assert_held(&q->rq_qos_mutex);
+
 	/*
 	 * No IO can be in-flight when adding rqos, so freeze queue, which
 	 * is fine since we only support rq_qos for blk-mq queue.
-	 *
-	 * Reuse ->queue_lock for protecting against other concurrent
-	 * rq_qos adding/deleting
 	 */
 	blk_mq_freeze_queue(q);
 
-	spin_lock_irq(&q->queue_lock);
 	if (rq_qos_id(q, rqos->id))
 		goto ebusy;
 	rqos->next = q->rq_qos;
 	q->rq_qos = rqos;
-	spin_unlock_irq(&q->queue_lock);
 
 	blk_mq_unfreeze_queue(q);
 
@@ -113,7 +110,6 @@ static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 
 	return 0;
 ebusy:
-	spin_unlock_irq(&q->queue_lock);
 	blk_mq_unfreeze_queue(q);
 	return -EBUSY;
 
@@ -123,21 +119,15 @@ static inline void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
 {
 	struct rq_qos **cur;
 
-	/*
-	 * See comment in rq_qos_add() about freezing queue & using
-	 * ->queue_lock.
-	 */
-	blk_mq_freeze_queue(q);
+	lockdep_assert_held(&q->rq_qos_mutex);
 
-	spin_lock_irq(&q->queue_lock);
+	blk_mq_freeze_queue(q);
 	for (cur = &q->rq_qos; *cur; cur = &(*cur)->next) {
 		if (*cur == rqos) {
 			*cur = rqos->next;
 			break;
 		}
 	}
-	spin_unlock_irq(&q->queue_lock);
-
 	blk_mq_unfreeze_queue(q);
 
 	mutex_lock(&q->debugfs_mutex);
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index c293e08b301ff..46534c877c12f 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -850,7 +850,9 @@ int wbt_init(struct request_queue *q)
 	/*
 	 * Assign rwb and add the stats callback.
 	 */
+	mutex_lock(&q->rq_qos_mutex);
 	ret = rq_qos_add(q, &rwb->rqos);
+	mutex_unlock(&q->rq_qos_mutex);
 	if (ret)
 		goto err_free;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index de013fc37ef83..c5d07c7609d4b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -397,6 +397,7 @@ struct request_queue {
 
 	struct blk_queue_stats	*stats;
 	struct rq_qos		*rq_qos;
+	struct mutex		rq_qos_mutex;
 
 	const struct blk_mq_ops	*mq_ops;
 
-- 
2.53.0



