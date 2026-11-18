Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062141;
	b=z2R+lWoiLvO4qQmgiuf0cUauTroiC0LExExfIuMFfvXJw2kLziPg5bQ7S/bZg0d/0L3D
	 iK0GZUw66VL00Saj4zU/qUzC8eFoDxUNx7dKCeBsRFfCge/eBofsnTGY4g9XqcCi32qpb
	 lccpgBmIflJ8+O9vQd5neZ7AyhpNJZ2NHj4VIQ3Yfel/obeMyXj21DquOVcYWeQiduK7F
	 SXybgDfld8Ao44iUvX17AZGC+ob+z2J5CprJPkyzzRoWIzGSOKqyrDBcMCYXnjsDHeEtP
	 /SK7vazcvKUOsGoG9av7t5qkD5W7h+hOyiGApEa7jOJMiuOuQ3/6QXeRPCgaMqf+x7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ccDlipBp4qTD3KZsuNeOsmiLZc9SetFBGAax7coJjaw=;
	b=W4K4onm1bOjp28BOSJkwjVBNyhMXA8aq7C9e6HHlvKMBsYVZfmayfoDBCKzL8AnZN8FF
	 DfcrjDnXH55Fs3XnjcjMI0DY6VKFSZCsPSeGn5mUccg3+kBCG5KBUtCNOQYbX4H6d1Q6p
	 bmsDOJCw5ftjf2QjIhq96wNNiFa/w6FjQtF4AfmRT5PEZjGJF6DBMBq2NVvAtsuCaY+is
	 uZzOVeOt7XFcLAmrP1V80wakR9a7M4bv+DqDzS/7pgQM1cpwk/wXm4lQ7HfNTW7HM/WVV
	 1N9bfLBbU9VwnIMgzpV7/8nU90+yOOKKFo5zaiTBN1DQxKn0kmP9fXMDKm2+bl+Sy+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViWcyLX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2119C606A325;
	Thu, 19 Nov 2026 04:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViWcyLX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1541F000C4;
	Thu, 19 Nov 2026 04:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062141;
	bh=ccDlipBp4qTD3KZsuNeOsmiLZc9SetFBGAax7coJjaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViWcyLX5FKQqn3wfsyOve9AG4KeyB5UzU+rb0HifrN8lvt7qKIL39130s71nvsLlw
	 bHbEu5pDmHeGYt//XaftityUdMeHCXWg3zBmC8glnGky/u4ZphYpyrts+Jhw6a2maS
	 1liBAmOGFQNgJdVNsupoHVaf9MD5x+z8xUlnltaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Qian Cai <cai@redhat.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	John Garry <john.garry@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1803/1848] blk-mq: add new API of blk_mq_hctx_set_fq_lock_class
Date: Wed, 18 Nov 2026 16:04:01 +0100
Message-ID: <20261118150034.787353009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit fb01a2932e81a1fb2273f87ff92dc8172b8880ee ]

flush_end_io() may be called recursively from some driver, such as
nvme-loop, so lockdep may complain 'possible recursive locking'.
Commit b3c6a5997541("block: Fix a lockdep complaint triggered by
request queue flushing") tried to address this issue by assigning
dynamically allocated per-flush-queue lock class. This solution
adds synchronize_rcu() for each hctx's release handler, and causes
horrible SCSI MQ probe delay(more than half an hour on megaraid sas).

Add new API of blk_mq_hctx_set_fq_lock_class() for these drivers, so
we just need to use driver specific lock class for avoiding the
lockdep warning of 'possible recursive locking'.

Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reported-by: Qian Cai <cai@redhat.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 64e21d782020 ("nvme-loop: don't BUG() if a scan runs beside a reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-flush.c      | 25 +++++++++++++++++++++++++
 include/linux/blk-mq.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 33b487b5cbf78..a82c82259112b 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -509,3 +509,28 @@ void blk_free_flush_queue(struct blk_flush_queue *fq)
 	kfree(fq->flush_rq);
 	kfree(fq);
 }
+
+/*
+ * Allow driver to set its own lock class to fq->mq_flush_lock for
+ * avoiding lockdep complaint.
+ *
+ * flush_end_io() may be called recursively from some driver, such as
+ * nvme-loop, so lockdep may complain 'possible recursive locking' because
+ * all 'struct blk_flush_queue' instance share same mq_flush_lock lock class
+ * key. We need to assign different lock class for these driver's
+ * fq->mq_flush_lock for avoiding the lockdep warning.
+ *
+ * Use dynamically allocated lock class key for each 'blk_flush_queue'
+ * instance is over-kill, and more worse it introduces horrible boot delay
+ * issue because synchronize_rcu() is implied in lockdep_unregister_key which
+ * is called for each hctx release. SCSI probing may synchronously create and
+ * destroy lots of MQ request_queues for non-existent devices, and some robot
+ * test kernel always enable lockdep option. It is observed that more than half
+ * an hour is taken during SCSI MQ probe with per-fq lock class.
+ */
+void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
+		struct lock_class_key *key)
+{
+	lockdep_set_class(&hctx->fq->mq_flush_lock, key);
+}
+EXPORT_SYMBOL_GPL(blk_mq_hctx_set_fq_lock_class);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index f8ea27423d1d8..92bbc9a72355a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -5,6 +5,7 @@
 #include <linux/blkdev.h>
 #include <linux/sbitmap.h>
 #include <linux/srcu.h>
+#include <linux/lockdep.h>
 
 struct blk_mq_tags;
 struct blk_flush_queue;
@@ -594,5 +595,7 @@ static inline void blk_mq_cleanup_rq(struct request *rq)
 }
 
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
+void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
+		struct lock_class_key *key);
 
 #endif
-- 
2.53.0



