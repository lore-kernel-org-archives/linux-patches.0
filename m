Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A398E12A167;
	Tue, 23 Jan 2024 00:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971051; cv=none; b=hJiw2Sm+HoEa22mfNVDKUxNOX0mTqWJ/MlEU9cH+uv0d/lCYieL/oXLW0vosjDO4bFjnaoSiZuTjsgxf9d7I3QbXgXxOSIJ0DPc/tFthapADnOM7QzYXq/Ldw1UFFDlZaoarX6uU0vZKfo2kC07nv/MJjUF5u0yB1OzNVuRjA0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971051; c=relaxed/simple;
	bh=IOBWHO3VngJql3svVgdiyiMWT/uWal6UpYkEKXsYyP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzskLTBEp+yFDF5lZJ8a3/k3KeK6MUhve64BRCahGclzRn552JY2x8Kq98t9K91amr00aMjg4SpNN6FwjD+Kziehkox95MUZXdUN6nkRMyWo6BqmHZolStzTJDW2Pja47Pgfvy5wplDGnEA9N1uhekRtpxQX2l17jYcYZG+Sn14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnUE65z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnUE65z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05905C43399;
	Tue, 23 Jan 2024 00:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971051;
	bh=IOBWHO3VngJql3svVgdiyiMWT/uWal6UpYkEKXsYyP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnUE65z6UrLk1fDQ20vJTP9b3r6+ytTwYcy4ncbXtPYJk56/5oCznqoxsxUBPslgl
	 ZHkGTYr7seYH9+NEvS6N1H94+YUNAOu1Zg/fQjZq/gFkT6LwbGmiGgyvMRqN0rTxfE
	 5MQxkMWNhQbd+2xvbpTKfEH2pD9N5ruN9LeUDn+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/417] block: make BLK_DEF_MAX_SECTORS unsigned
Date: Mon, 22 Jan 2024 15:55:14 -0800
Message-ID: <20240122235756.887287730@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 0a26f327e46c203229e72c823dfec71a2b405ec5 ]

This is used as an unsigned value, so define it that way to avoid
having to cast it.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230105205146.3610282-2-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 9a9525de8654 ("null_blk: don't cap max_hw_sectors to BLK_DEF_MAX_SECTORS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c          | 2 +-
 drivers/block/null_blk/main.c | 3 +--
 include/linux/blkdev.h        | 3 ++-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 86ff375c00ce..bbca4ce77a2d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -135,7 +135,7 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 	limits->max_hw_sectors = max_hw_sectors;
 
 	max_sectors = min_not_zero(max_hw_sectors, limits->max_dev_sectors);
-	max_sectors = min_t(unsigned int, max_sectors, BLK_DEF_MAX_SECTORS);
+	max_sectors = min(max_sectors, BLK_DEF_MAX_SECTORS);
 	max_sectors = round_down(max_sectors,
 				 limits->logical_block_size >> SECTOR_SHIFT);
 	limits->max_sectors = max_sectors;
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index e9f38eba2f13..d921653b096b 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2116,8 +2116,7 @@ static int null_add_dev(struct nullb_device *dev)
 	blk_queue_physical_block_size(nullb->q, dev->blocksize);
 	if (!dev->max_sectors)
 		dev->max_sectors = queue_max_hw_sectors(nullb->q);
-	dev->max_sectors = min_t(unsigned int, dev->max_sectors,
-				 BLK_DEF_MAX_SECTORS);
+	dev->max_sectors = min(dev->max_sectors, BLK_DEF_MAX_SECTORS);
 	blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
 
 	if (dev->virt_boundary)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 07a7eeef47d3..e255674a9ee7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1109,11 +1109,12 @@ static inline bool bdev_is_partition(struct block_device *bdev)
 enum blk_default_limits {
 	BLK_MAX_SEGMENTS	= 128,
 	BLK_SAFE_MAX_SECTORS	= 255,
-	BLK_DEF_MAX_SECTORS	= 2560,
 	BLK_MAX_SEGMENT_SIZE	= 65536,
 	BLK_SEG_BOUNDARY_MASK	= 0xFFFFFFFFUL,
 };
 
+#define BLK_DEF_MAX_SECTORS 2560u
+
 static inline unsigned long queue_segment_boundary(const struct request_queue *q)
 {
 	return q->limits.seg_boundary_mask;
-- 
2.43.0



