Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9757BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34492C433EF;
	Tue,  7 Mar 2023 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214901;
	bh=hEmoMWYBUXEAyYEiPiREgit81uMbxcLhiQJnlKujpvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVF+4TC5DavCtB0QVkwrINRSURJ7mEH0WqCkqMVKNsMSGOHk/U2lps06L2lgCJi8z
	 cEfRdhRT2pXmZpK/DLIwj1fHapzNBBDlhMQb+H3ThVfylixwBgmAfU/dj8bRnXQRkH
	 okX9mh/KU62KxSdmN0Uf4OLvVgyNJZkXGTQoUE4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/567] blk-mq: correct stale comment of .get_budget
Date: Tue,  7 Mar 2023 17:56:32 +0100
Message-Id: <20230307165908.342377186@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit 01542f651a9f58a9b176c3d3dc3eefbacee53b78 ]

Commit 88022d7201e96 ("blk-mq: don't handle failure in .get_budget")
remove BLK_STS_RESOURCE return value and we only check if we can get
the budget from .get_budget() now.
Correct stale comment that ".get_budget() returns BLK_STS_NO_RESOURCE"
to ".get_budget() fails to get the budget".

Fixes: 88022d7201e9 ("blk-mq: don't handle failure in .get_budget")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index de45a28925d83..ff1021dbb0d22 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -109,7 +109,7 @@ static bool blk_mq_dispatch_hctx_list(struct list_head *rq_list)
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * be run again.  This is necessary to avoid starving flushes.
@@ -237,7 +237,7 @@ static struct blk_mq_ctx *blk_mq_next_ctx(struct blk_mq_hw_ctx *hctx,
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * be run again.  This is necessary to avoid starving flushes.
-- 
2.39.2



