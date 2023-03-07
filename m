Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30414BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F92C433EF;
	Tue,  7 Mar 2023 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209092;
	bh=6vCbbMgmyRdRXG/Af51n79H0zZPcjBETadY2OmH+J+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+dDSwHXNveJ9gVHGVuCtYKuEtT685fMXjCvR0ifkiX11om0/XfDk9khx5+9EsJ8l
	 1OzYOLcIRG4we+HezjRK/BzjlWi1cbJPfgByCnd8p2uMQCDtSIkhQ1bdJuGBbWcEtz
	 vmMxTsIOlxWajoNh/j9sVFxwUzpYuJ7BYRB3mM9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0107/1001] blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
Date: Tue,  7 Mar 2023 17:47:59 +0100
Message-Id: <20230307170026.771514129@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 23d1a90fec427..ae40cdb7a383c 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -19,8 +19,7 @@
 #include "blk-wbt.h"
 
 /*
- * Mark a hardware queue as needing a restart. For shared queues, maintain
- * a count of how many hardware queues are marked for restart.
+ * Mark a hardware queue as needing a restart.
  */
 void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
 {
-- 
2.39.2



