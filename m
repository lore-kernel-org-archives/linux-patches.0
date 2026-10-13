Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68A34F55C6;
	Tue, 13 Oct 2026 12:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894066; cv=none; b=flzSbA5nGzEiTvZqb0yhkpw2esmt1jI6HkjvEpO5XdMKLTg37Zvx5cIlFwCFGVrV07iC8lqmIHWKZB8/59fYloFb4dORuaSHKOPg2oTfYZmgI6qiQ1av5WhsKTPmwpcc5+bx/8Acpx2F9n2+o38mO+1cQvXt/12VngBy5heTxTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894066; c=relaxed/simple;
	bh=9W4I0YcFdeZe8zgWlGVpGxQXTSU1xRxXz6DEal/0dco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cX0aQSU9J1lnKjOeDkrS6j6TaN6QDVO7QQisNBUfZCJ6OPzgl2Ss9QAaDxGyGiNEGx76xk6RRcw5WDSrWw67QLQoyaiIrJnSXgRNnHnHTz2GMds20Um90UWCsSA7KMvpU5+JTgr2o1hERV/GEWuIzyaUjhF9ygbFXaI6QOo58a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JisIU3vW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JisIU3vW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C421F000FF;
	Tue, 13 Oct 2026 12:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894064;
	bh=w/eWThBBZdkWqSrlCpUcHWlZgxJSBeO2XsHMzZx6aSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JisIU3vWJAWkOKksMCFJ0u+IFJBrye6qU0c5odSWBJcjpKLBvS3FF4n1ZpWqeUJIr
	 pL50rjOJaYpK+Oq0abCWBLrQYHa/2OPwJ3DRk/0AwnLGmWZBayuaS9EvEYUp5YXuyx
	 c3Mj0paIsn6v+nizyoYRQjB7Bm7YEB4tfEkLOAXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 433/621] scsi: sd: Move the sd_config_discard() function definition
Date: Tue, 13 Oct 2026 13:37:08 +0200
Message-ID: <20261013112931.110821375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c0daf4836114fcbdf64bf817cab00b75ce712945 ]

Move the sd_config_discard() function definition such that its
forward declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260114175054.4118163-3-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 114 +++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a9fcccb16d9e5..73e2a96bd338f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -102,8 +102,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #define SD_MINORS	16
 
-static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
-		unsigned int mode);
 static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
@@ -120,6 +118,62 @@ static const char *sd_cache_types[] = {
 	"write back, no read (daft)"
 };
 
+static void sd_disable_discard(struct scsi_disk *sdkp)
+{
+	sdkp->provisioning_mode = SD_LBP_DISABLE;
+	blk_queue_disable_discard(sdkp->disk->queue);
+}
+
+static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
+		unsigned int mode)
+{
+	unsigned int logical_block_size = sdkp->device->sector_size;
+	unsigned int max_blocks = 0;
+
+	lim->discard_alignment = sdkp->unmap_alignment * logical_block_size;
+	lim->discard_granularity = max(sdkp->physical_block_size,
+			sdkp->unmap_granularity * logical_block_size);
+	sdkp->provisioning_mode = mode;
+
+	switch (mode) {
+
+	case SD_LBP_FULL:
+	case SD_LBP_DISABLE:
+		break;
+
+	case SD_LBP_UNMAP:
+		max_blocks = min_not_zero(sdkp->max_unmap_blocks,
+					  (u32)SD_MAX_WS16_BLOCKS);
+		break;
+
+	case SD_LBP_WS16:
+		if (sdkp->device->unmap_limit_for_ws)
+			max_blocks = sdkp->max_unmap_blocks;
+		else
+			max_blocks = sdkp->max_ws_blocks;
+
+		max_blocks = min_not_zero(max_blocks, (u32)SD_MAX_WS16_BLOCKS);
+		break;
+
+	case SD_LBP_WS10:
+		if (sdkp->device->unmap_limit_for_ws)
+			max_blocks = sdkp->max_unmap_blocks;
+		else
+			max_blocks = sdkp->max_ws_blocks;
+
+		max_blocks = min_not_zero(max_blocks, (u32)SD_MAX_WS10_BLOCKS);
+		break;
+
+	case SD_LBP_ZERO:
+		max_blocks = min_not_zero(sdkp->max_ws_blocks,
+					  (u32)SD_MAX_WS10_BLOCKS);
+		break;
+	}
+
+	lim->max_hw_discard_sectors = max_blocks *
+		(logical_block_size >> SECTOR_SHIFT);
+}
+
 static void sd_set_flush_flag(struct scsi_disk *sdkp,
 		struct queue_limits *lim)
 {
@@ -835,62 +889,6 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	return protect;
 }
 
-static void sd_disable_discard(struct scsi_disk *sdkp)
-{
-	sdkp->provisioning_mode = SD_LBP_DISABLE;
-	blk_queue_disable_discard(sdkp->disk->queue);
-}
-
-static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
-		unsigned int mode)
-{
-	unsigned int logical_block_size = sdkp->device->sector_size;
-	unsigned int max_blocks = 0;
-
-	lim->discard_alignment = sdkp->unmap_alignment * logical_block_size;
-	lim->discard_granularity = max(sdkp->physical_block_size,
-			sdkp->unmap_granularity * logical_block_size);
-	sdkp->provisioning_mode = mode;
-
-	switch (mode) {
-
-	case SD_LBP_FULL:
-	case SD_LBP_DISABLE:
-		break;
-
-	case SD_LBP_UNMAP:
-		max_blocks = min_not_zero(sdkp->max_unmap_blocks,
-					  (u32)SD_MAX_WS16_BLOCKS);
-		break;
-
-	case SD_LBP_WS16:
-		if (sdkp->device->unmap_limit_for_ws)
-			max_blocks = sdkp->max_unmap_blocks;
-		else
-			max_blocks = sdkp->max_ws_blocks;
-
-		max_blocks = min_not_zero(max_blocks, (u32)SD_MAX_WS16_BLOCKS);
-		break;
-
-	case SD_LBP_WS10:
-		if (sdkp->device->unmap_limit_for_ws)
-			max_blocks = sdkp->max_unmap_blocks;
-		else
-			max_blocks = sdkp->max_ws_blocks;
-
-		max_blocks = min_not_zero(max_blocks, (u32)SD_MAX_WS10_BLOCKS);
-		break;
-
-	case SD_LBP_ZERO:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks,
-					  (u32)SD_MAX_WS10_BLOCKS);
-		break;
-	}
-
-	lim->max_hw_discard_sectors = max_blocks *
-		(logical_block_size >> SECTOR_SHIFT);
-}
-
 static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
 {
 	struct page *page;
-- 
2.53.0



