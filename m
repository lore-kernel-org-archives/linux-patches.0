Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047068;
	b=nn40Hy/1lWOzv/Q3NxSqqsP9vok3vtkPU7naWXteM4lwOl0NF/ixKW+YttZDCuMQ5xUO
	 ZxidC5dgXBSd3YfpKump5sUbVRoqlweVOXoCjl3LKBGGh22mKYHEXUOnpF2U3rmsC2yw6
	 uTEutLvi1HzNACWZQxAqohJYw0y6LsOiABWcYYHL6oDH1ai9Lawqd9DxJGfOz/8TnKC2K
	 VkEAe0XU/Qhhzx6Re3g6RUDe0FjchDW1ODTYfgZe8vJySDP6uZCeLT6rMbXeXQiGWoHHg
	 zSda1SwqX2LKwjClknh0GEBUPx+uSDiZse8EDnHgh67ztiK6/Yy/XW69LHkVNsdFU+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/sRYej8csscaKQgnnxAm45Wv9o8pG3cJBxceav/2BB8=;
	b=aOpkwZjITZCm5r+c2E1SEAoedVvwTZS6XwkNCNBN7rQR+R0ZX72Nt220PUDQGOSONlbI
	 D0BkXhzhC9xgiJWBVYjtxQbloNj3LrzbUM6uLweQNtMWFYNBC+g2GUAyE/o32S7tXfFHH
	 SpSRm0QG8IQ0XUrKnEoJloTCesgBAl4tuBNrFuanj0GIkReSbXSxIgOAYTTwo0Qw1FxFB
	 0TlJ+zFml/zuh86tBvbrLFR8lpK4unU7A1ZfImkQXpASnukLd+swawhGlBNfG49wZJ+qe
	 DKtswCfcurTOJk4hpr/7yIht69ajJzQcdjKM9tglPdwCjxNIwbxE2PLuyNIA/EY6t4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JA9cKThv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AD4606A330;
	Thu, 19 Nov 2026 00:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JA9cKThv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624571F000C4;
	Thu, 19 Nov 2026 00:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047067;
	bh=/sRYej8csscaKQgnnxAm45Wv9o8pG3cJBxceav/2BB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JA9cKThvVnER23phD7HGvOeqzvdkAkDhN7R9NN9Bf0qfrcKcNBKw53SOeRFL7EvU+
	 srGeuZDG1B0tOnrYsP4Ae8e1dSQsXoqLtWAzsShLIYjfeyEQaINoZhNYp4lnMaJu0Y
	 3g442OsIoJgzBE1YDQjSPeyvRKC2qGZ9gt3iqu5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Ming Lei <ming.lei@redhat.com>,
	Chao Leng <lengchao@huawei.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1504/2857] block: set the disk capacity to 0 in blk_mark_disk_dead
Date: Wed, 18 Nov 2026 15:42:18 +0100
Message-ID: <20261118150255.489356639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 71b26083d59cd4ab22489829ffe7d4ead93f5546 ]

nvme and xen-blkfront are already doing this to stop buffered writes from
creating dirty pages that can't be written out later.  Move it to the
common code.

This also removes the comment about the ordering from nvme, as bd_mutex
not only is gone entirely, but also hasn't been used for locking updates
to the disk size long before that, and thus the ordering requirement
documented there doesn't apply any more.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chao Leng <lengchao@huawei.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20221101150050.3510-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 61b6d1df1d62 ("xen-blkfront: Fix IO race during unplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c                | 5 +++++
 drivers/block/xen-blkfront.c | 1 -
 drivers/nvme/host/core.c     | 7 +------
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index ee6dc7feccc6f..f06195e53571c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -595,6 +595,11 @@ void blk_mark_disk_dead(struct gendisk *disk)
 	blk_queue_flag_set(QUEUE_FLAG_DYING, disk->queue);
 	set_bit(GD_DEAD, &disk->state);
 	blk_queue_start_drain(disk->queue);
+
+	/*
+	 * Stop buffered writers from dirtying pages that can't be written out.
+	 */
+	set_capacity_and_notify(disk, 0);
 }
 EXPORT_SYMBOL_GPL(blk_mark_disk_dead);
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index df0eaf15a4ddd..7ad03bcd9f274 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2134,7 +2134,6 @@ static void blkfront_closing(struct blkfront_info *info)
 	if (info->rq && info->gd) {
 		blk_mq_stop_hw_queues(info->rq);
 		blk_mark_disk_dead(info->gd);
-		set_capacity(info->gd, 0);
 	}
 
 	for_each_rinfo(info, rinfo, i) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9521126738940..61a34581ca70a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5337,10 +5337,7 @@ static void nvme_stop_ns_queue(struct nvme_ns *ns)
 /*
  * Prepare a queue for teardown.
  *
- * This must forcibly unquiesce queues to avoid blocking dispatch, and only set
- * the capacity to 0 after that to avoid blocking dispatchers that may be
- * holding bd_butex.  This will end buffered writers dirtying pages that can't
- * be synced.
+ * This must forcibly unquiesce queues to avoid blocking dispatch.
  */
 static void nvme_set_queue_dying(struct nvme_ns *ns)
 {
@@ -5349,8 +5346,6 @@ static void nvme_set_queue_dying(struct nvme_ns *ns)
 
 	blk_mark_disk_dead(ns->disk);
 	nvme_start_ns_queue(ns);
-
-	set_capacity_and_notify(ns->disk, 0);
 }
 
 /**
-- 
2.53.0



