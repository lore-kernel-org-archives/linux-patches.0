Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3772B9B7;
	Tue, 23 Jan 2024 01:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974113; cv=none; b=ivJJ+onGkMdHAxSq4aE69HxyE5K3XBRcmo9YiiClr/5stN1ppA6slV1IjaRE5UtXwx7z0NVs1ZwvKDqDFJug3ybX0FN1SFH6uSvHqjr4e++wUCKsR3lU5dAwdtEZvvE2ZMVSQO7wsGkcy7lhj7FEHbH6+WdngUFoCyQM6FQ+tQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974113; c=relaxed/simple;
	bh=BDj7xWi/bbAZjDDZ4RADsvOx2cZ+237xd8qfqbxYtHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnwLbCgbRk8T6Fy4GfdDg0P6K1xu0YH+oR2C/erP6R6TnlFJewxIk0U9oejKtyKnxdCrWCLbWLbXAXa529nDirQLX+/ScySmQG90Z0WxkMsFMj1M0MOxv4v/x2aKskNePhZSHGAZBq88rvHV4k+e4T4tnx7i2vH3LjJCrRYnl+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsnIbdA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsnIbdA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D647AC43399;
	Tue, 23 Jan 2024 01:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974113;
	bh=BDj7xWi/bbAZjDDZ4RADsvOx2cZ+237xd8qfqbxYtHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsnIbdA6Ir3iCqjp8/trNxr0RpjV1RVSlKFbfGoYth7o8G/grCVFgDaeTGK8G2Q/9
	 kO+nySx7Q+tBNs/WYY/E9cGzO5IdDpMpLe1vWZPRDEfIuuPGX0CPyTUIjE/sCZzoM8
	 8lTG3nfUOoIPyBPyifEim1eVrtfEnjsgUaBEDwkM=
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
Subject: [PATCH 5.15 168/374] block: make BLK_DEF_MAX_SECTORS unsigned
Date: Mon, 22 Jan 2024 15:57:04 -0800
Message-ID: <20240122235750.473062285@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 73a80895e3ae..959b5c1e6d3b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -136,7 +136,7 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 	limits->max_hw_sectors = max_hw_sectors;
 
 	max_sectors = min_not_zero(max_hw_sectors, limits->max_dev_sectors);
-	max_sectors = min_t(unsigned int, max_sectors, BLK_DEF_MAX_SECTORS);
+	max_sectors = min(max_sectors, BLK_DEF_MAX_SECTORS);
 	max_sectors = round_down(max_sectors,
 				 limits->logical_block_size >> SECTOR_SHIFT);
 	limits->max_sectors = max_sectors;
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 686ec6bcdef3..4a867233b14a 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1902,8 +1902,7 @@ static int null_add_dev(struct nullb_device *dev)
 	blk_queue_physical_block_size(nullb->q, dev->blocksize);
 	if (!dev->max_sectors)
 		dev->max_sectors = queue_max_hw_sectors(nullb->q);
-	dev->max_sectors = min_t(unsigned int, dev->max_sectors,
-				 BLK_DEF_MAX_SECTORS);
+	dev->max_sectors = min(dev->max_sectors, BLK_DEF_MAX_SECTORS);
 	blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
 
 	if (dev->virt_boundary)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 67344dfe07a7..905844172cfd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1334,11 +1334,12 @@ static inline bool bdev_is_partition(struct block_device *bdev)
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



