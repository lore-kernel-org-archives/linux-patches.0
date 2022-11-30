Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B5579C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5818FC433C1;
	Wed, 30 Nov 2022 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834549;
	bh=HtuvYn1EQ5IHM4x16ZQTiO4cKQFCLzaTQZaxEJr+Qzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWqa7i50Oshy6+JAlwgVJ8LbDvWg7gzNYgWAe3DjR07h7ZPLkCH11QyuMNyiM72UD
	 sjoT0ELJp/8AHV8NxkjTckiqvdNz6H+9uS7n6XwKwrUCoeFIkfOfVho0NPX9WGmOty
	 PbXaWmNdhlatIitZZcrIN6JAlg/7HamoIURFMTK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 257/289] block: make blk_set_default_limits() private
Date: Wed, 30 Nov 2022 19:24:02 +0100
Message-Id: <20221130180549.929989528@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b3228254bb6e91e57f920227f72a1a7d81925d81 ]

There are no external users of this function.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221110184501.2451620-4-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c   | 1 -
 block/blk.h            | 1 +
 include/linux/blkdev.h | 1 -
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 4949ed3ce7c9..8ac1038d0c79 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -59,7 +59,6 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
 }
-EXPORT_SYMBOL(blk_set_default_limits);
 
 /**
  * blk_set_stacking_limits - set default limits for stacking devices
diff --git a/block/blk.h b/block/blk.h
index 52432eab621e..ff0bec16f0fa 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -324,6 +324,7 @@ void blk_rq_set_mixed_merge(struct request *rq);
 bool blk_rq_merge_ok(struct request *rq, struct bio *bio);
 enum elv_merge blk_try_merge(struct request *rq, struct bio *bio);
 
+void blk_set_default_limits(struct queue_limits *lim);
 int blk_dev_init(void);
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 79624711fda7..e6bf06dc0770 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -946,7 +946,6 @@ extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
-extern void blk_set_default_limits(struct queue_limits *lim);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
-- 
2.35.1



