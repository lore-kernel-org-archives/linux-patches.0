Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027152;
	b=IPtZvhDIANmy6Efb+hQi3Mi+oWjFjG3woDcbT/dUNtJR46UBYTtQiS1Ah2CjW/wZd/Uh
	 3D4W3UL78Aru1rOaXsaVY9kEHVoRLBEtktsfJuPtZpGOFK1Albbm+Zi0uWRWXpoFBGe+R
	 UE8mNZHM7ArbHi01bXlrhfwUGcq15XEF2ay0s754T5SfrFGXrGKVD1znzYg3bvon7TsnC
	 Y549XNrfXvaUn6s8aUlHMOcTfvC+WOsyc7LMlpTRpwzuISIB5K30GQMAb2E9BfXjGWx0e
	 OmdlAtP4ghE9YuMlZUtCqJiLV2NVcbkbqcLMamRMsaRzCmZg/WP2BrfGWbdwCZjC59A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q07FKypgV0G801s2xFHnp7FutRD5KMn9V10/1wRBZNg=;
	b=cZ6LglymtbUzpvuxb6WNofCJD2jiUmALNL3qIDERk+BdIw2wFcbsdSnDS0h7vhUwRQZc
	 mdjkQ+zYlaE1ajtJiSo2DeJ0IkApX1yG73agh8reQ29X0s+zUWwfZaJ9huVlbzCcFdVyq
	 PvgMf1ns9yGYcL5WkZK1EMYhkHEPFss5ZILoMO7x0KQK5Kq+q33ZTThQySFaxjYFEbR7h
	 8nmTG2AfR6j7uYVRHACjzSJ4P8QT9l6KGXMnXZOXyiYvY5pZsniabtDTC2a0SPSFy7B4b
	 4QD0BNEFxhbeSWljuLJiAl5BXlC9dpCuaUpQmr2jUh/HIHGJqM0CuHVVTyJpv+4mFvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYv5Ob7p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C081606A320;
	Wed, 18 Nov 2026 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYv5Ob7p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1441D1F000C4;
	Wed, 18 Nov 2026 18:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027151;
	bh=q07FKypgV0G801s2xFHnp7FutRD5KMn9V10/1wRBZNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYv5Ob7pfLxO+U5DhEEsjENvSybCUsX9zwIIxtJJxSZfER2r4qbk4fQ/LCbZxpiuc
	 WISgElCUpG5XFnv2/px5kZdr8mJMP3xlYCuqLKQMSX6Dorug+pxgm9PVqxUXd377h+
	 9jeMoZ9qGDMHJTYqfg15yoTjnmq5B9aaPvW62KUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1686/2151] blk-mq: share one tags_srcu instance across all tag sets
Date: Wed, 18 Nov 2026 15:57:01 +0100
Message-ID: <20261118150223.246941519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit e1c51edd6a575ba3b6fc5acb57ed2fec6951a910 ]

Freed request pages and flush queues are handed to call_srcu() so that
concurrent tag iterators never see them disappear. Each tag set embeds
its own srcu_struct for this, which blk_mq_free_tag_set() has to drain
with srcu_barrier() before cleanup_srcu_struct(). The barrier waits for
a full SRCU grace period even when the callbacks are long done, adding
1-3 ms to every tag set teardown. Drivers that free tag sets under a
lock make it worse: ublk does it under the global ublk_ctl_mutex, so
deleting devices from many threads serializes on that grace period.

The callbacks free memory that only blk-mq owns. They touch neither
the tag set nor driver code, so they don't need a per-set domain.
Replace the per-set srcu_struct with a single global one. Freeing a tag
set no longer waits for a grace period, and each tag set no longer
allocates per-CPU SRCU state. The read side is unchanged. The only cost
is that a long-running iterator can now delay these frees for other tag
sets too, which only postpones freeing memory.

On 7.3-rc5 in a 16-vCPU VM, with 1 queue and depth 16 per ublk device,
median of 3 runs (5 for the 16-thread null_blk case):

                                       before     after
  ublk DEL_DEV p50, serial             3.45 ms    0.17 ms
  ublk delete 1000 devices, serial     19.5 s     14.9 s
  ublk delete 4000 devices, 16 thr     19.0 s     2.9 s
  null_blk destroy 500 devs, serial    9.97 s     9.25 s
  null_blk destroy 256 devs, 16 thr    5.15 s     4.30 s

Fixes: ad0d05dbddc1 ("blk-mq: Defer freeing of tags page_list to SRCU callback")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://patch.msgid.link/20261001-bug-blk-mq-global-tags-srcu-v1-1-e8415da10d1b@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c     | 17 ++++++++++++-----
 block/blk-mq.c         | 15 ++++-----------
 block/blk-mq.h         |  2 ++
 include/linux/blk-mq.h |  3 ---
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 5b664dbdf6555..496da16f6f4f5 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -17,6 +17,13 @@
 #include "blk-mq.h"
 #include "blk-mq-sched.h"
 
+/*
+ * Protects tag iteration against the deferred freeing of tags->page_list and
+ * flush queues. The callbacks touch neither the tag set nor driver code, so
+ * one global instance is enough and freeing a tag set needn't wait for them.
+ */
+DEFINE_SRCU(blk_mq_tags_srcu);
+
 /*
  * Recalculate wakeup batch when tag is shared by hctx.
  */
@@ -437,7 +444,7 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 	unsigned int flags = tagset->flags;
 	int i, nr_tags, srcu_idx;
 
-	srcu_idx = srcu_read_lock(&tagset->tags_srcu);
+	srcu_idx = srcu_read_lock(&blk_mq_tags_srcu);
 
 	nr_tags = blk_mq_is_shared_tags(flags) ? 1 : tagset->nr_hw_queues;
 
@@ -446,7 +453,7 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
 					      BT_TAG_ITER_STARTED);
 	}
-	srcu_read_unlock(&tagset->tags_srcu, srcu_idx);
+	srcu_read_unlock(&blk_mq_tags_srcu, srcu_idx);
 }
 EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
 
@@ -506,7 +513,7 @@ void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_tag_iter_fn *fn,
 	if (!percpu_ref_tryget(&q->q_usage_counter))
 		return;
 
-	srcu_idx = srcu_read_lock(&q->tag_set->tags_srcu);
+	srcu_idx = srcu_read_lock(&blk_mq_tags_srcu);
 	if (blk_mq_is_shared_tags(q->tag_set->flags)) {
 		struct blk_mq_tags *tags = q->tag_set->shared_tags;
 		struct sbitmap_queue *bresv = &tags->breserved_tags;
@@ -536,7 +543,7 @@ void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_tag_iter_fn *fn,
 			bt_for_each(hctx, q, btags, fn, priv, false);
 		}
 	}
-	srcu_read_unlock(&q->tag_set->tags_srcu, srcu_idx);
+	srcu_read_unlock(&blk_mq_tags_srcu, srcu_idx);
 	blk_queue_exit(q);
 }
 
@@ -612,7 +619,7 @@ void blk_mq_free_tags(struct blk_mq_tag_set *set, struct blk_mq_tags *tags)
 		return;
 	}
 
-	call_srcu(&set->tags_srcu, &tags->rcu_head, blk_mq_free_tags_callback);
+	call_srcu(&blk_mq_tags_srcu, &tags->rcu_head, blk_mq_free_tags_callback);
 }
 
 void blk_mq_tag_resize_shared_tags(struct blk_mq_tag_set *set, unsigned int size)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 82df2f6073d8d..833e70af63b0d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3707,9 +3707,9 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 	};
 	int srcu_idx;
 
-	srcu_idx = srcu_read_lock(&hctx->queue->tag_set->tags_srcu);
+	srcu_idx = srcu_read_lock(&blk_mq_tags_srcu);
 	blk_mq_all_tag_iter(tags, blk_mq_has_request, &data);
-	srcu_read_unlock(&hctx->queue->tag_set->tags_srcu, srcu_idx);
+	srcu_read_unlock(&blk_mq_tags_srcu, srcu_idx);
 
 	return data.has_rq;
 }
@@ -3981,7 +3981,7 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
-	call_srcu(&set->tags_srcu, &hctx->fq->rcu_head,
+	call_srcu(&blk_mq_tags_srcu, &hctx->fq->rcu_head,
 			blk_free_flush_queue_callback);
 	hctx->fq = NULL;
 
@@ -4884,9 +4884,6 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 		if (ret)
 			goto out_free_srcu;
 	}
-	ret = init_srcu_struct(&set->tags_srcu);
-	if (ret)
-		goto out_cleanup_srcu;
 
 	init_rwsem(&set->update_nr_hwq_lock);
 
@@ -4895,7 +4892,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 				 sizeof(struct blk_mq_tags *), GFP_KERNEL,
 				 set->numa_node);
 	if (!set->tags)
-		goto out_cleanup_tags_srcu;
+		goto out_cleanup_srcu;
 
 	for (i = 0; i < set->nr_maps; i++) {
 		set->map[i].mq_map = kcalloc_node(nr_cpu_ids,
@@ -4924,8 +4921,6 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	}
 	kfree(set->tags);
 	set->tags = NULL;
-out_cleanup_tags_srcu:
-	cleanup_srcu_struct(&set->tags_srcu);
 out_cleanup_srcu:
 	if (set->flags & BLK_MQ_F_BLOCKING)
 		cleanup_srcu_struct(set->srcu);
@@ -4972,8 +4967,6 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 	kfree(set->tags);
 	set->tags = NULL;
 
-	srcu_barrier(&set->tags_srcu);
-	cleanup_srcu_struct(&set->tags_srcu);
 	if (set->flags & BLK_MQ_F_BLOCKING) {
 		cleanup_srcu_struct(set->srcu);
 		kfree(set->srcu);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index c4fccdeb54412..01d8ef8a4d460 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -178,6 +178,8 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 		unsigned int reserved_tags, unsigned int flags, int node);
 void blk_mq_free_tags(struct blk_mq_tag_set *set, struct blk_mq_tags *tags);
 
+extern struct srcu_struct blk_mq_tags_srcu;
+
 unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
 unsigned long blk_mq_get_tags(struct blk_mq_alloc_data *data, int nr_tags,
 		unsigned int *offset);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b54506b3b76d9..dffc1e3ceb8f1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -523,8 +523,6 @@ enum hctx_type {
  *		   request_queue.tag_set_list.
  * @srcu:	   Use as lock when type of the request queue is blocking
  *		   (BLK_MQ_F_BLOCKING).
- * @tags_srcu:	   SRCU used to defer freeing of tags page_list to prevent
- *		   use-after-free when iterating tags.
  * @update_nr_hwq_lock:
  * 		   Synchronize updating nr_hw_queues with add/del disk &
  * 		   switching elevator.
@@ -549,7 +547,6 @@ struct blk_mq_tag_set {
 	struct mutex		tag_list_lock;
 	struct list_head	tag_list;
 	struct srcu_struct	*srcu;
-	struct srcu_struct	tags_srcu;
 
 	struct rw_semaphore	update_nr_hwq_lock;
 };
-- 
2.53.0



