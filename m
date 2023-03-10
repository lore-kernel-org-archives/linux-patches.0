Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB2E8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A43C433EF;
	Fri, 10 Mar 2023 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457671;
	bh=MzHVV2SAdIaosX4r2iT03klKd05bYP278kyQ9k4Ngwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdNQFkV6Uyb2IXhAL0LJalFlhJpFg1oDvYQBWe9ZB79BtBPGB/877xbpdsOy5YfAy
	 t3Gn5PnOuWye5mSu+uiSZAldgVM5ZVBJeeJ/iHYTxPmPPqAH4tDD7ql5BKxjyEKIfn
	 btn5cfOwmBoDjo83F1ftoZZ87NXddr0fJojrDRwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/252] blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
Date: Fri, 10 Mar 2023 14:36:28 +0100
Message-Id: <20230310133719.378845457@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit c31e76bcc379182fe67a82c618493b7b8868c672 ]

Commit 97889f9ac24f8 ("blk-mq: remove synchronize_rcu() from
blk_mq_del_queue_tag_set()") remove handle of TAG_SHARED in restart,
then shared_hctx_restart counted for how many hardware queues are marked
for restart is removed too.
Remove the stale comment that we still count hardware queues need restart.

Fixes: 97889f9ac24f ("blk-mq: remove synchronize_rcu() from blk_mq_del_queue_tag_set()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index d89a757cbde0f..dfa0a21a1fe46 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -51,8 +51,7 @@ void blk_mq_sched_assign_ioc(struct request *rq, struct bio *bio)
 }
 
 /*
- * Mark a hardware queue as needing a restart. For shared queues, maintain
- * a count of how many hardware queues are marked for restart.
+ * Mark a hardware queue as needing a restart.
  */
 void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
 {
-- 
2.39.2



