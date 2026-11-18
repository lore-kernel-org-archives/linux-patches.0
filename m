Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060739;
	b=tABKbeWLNEgB9k9qDwoixITpI2+/Sf1Q0le7oO733UeMzxg7xUOck7DpODxhmd2rFMsc
	 TkkS0dzlD/jVItlpLwaHsK6MEQ5fARN1yr+uKh+BH/vDg0ontISAH8ksL/iT4QTXsbzAU
	 EG2R3LPb+v3MrOJ0/Vaj2f1YQg8ResJb6R/JavHqLq/eCho7RVdl6ZuhOZyTbUOAPKx0B
	 LjQiQKk/nhEpE5qfIT78jdA1T0FW3j6isJs9d9m3pYRLd/T1ySy0HNINQsu0PeHFR9aHW
	 CPmTyLqR02hM5XrWl+quD1AkxeCpInmQVJouxeC+MeO9rQsgCh8wJGGzNzEmcuyIsHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zzh/1I5U598qGw8yft4u2Ue+hUb/QnTEup1g5EdakSI=;
	b=o9VbE6gjQoBBTOzmB5hI3bagYNumJFzz7H6tsWMH97K0FHcYeTQwGq4Qko//VXC3CvGy
	 I8FC6hl77BNbKfUPxdfCTK9kqE7N7DHMJp6lgxgc5NnFu6VEuts8GlXIyzFHgr/9nv388
	 BAJyTfvEDCmmwtinGjmG7dTGHDDT1+uxholBJRagrYCECqit8A8aOVTqY4Z9NPWwUI1BG
	 ivSwCaAcUZ+/gH729AHvxX+xw4psSKFU2MLyfvOj2ciK8XJlQgxFAAeuvmWMOzHu5NJ7d
	 C1X4dCJDx3hJMinNFUiviy2BELhSeBMPTp49WRblc+KbqexgxL/Aei1X82cdUCWP8Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itFP2sV5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3E2606A326;
	Thu, 19 Nov 2026 03:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itFP2sV5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF37B1F000C4;
	Thu, 19 Nov 2026 03:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060739;
	bh=Zzh/1I5U598qGw8yft4u2Ue+hUb/QnTEup1g5EdakSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itFP2sV5bay0+ZrSWDnZS0pKTNpbkLgTeLnfQ6DvNRnUca4cH8ZUKXjPKV0drgc5J
	 Fd5NwNw8AQG3bmNDXhtXVsGO8CZjGqZmKE0+pxtUn0A92m8nE/AQBdbQBQST5ybj42
	 dVQuNh2loXB3Ro3jATCf4azgJT9+sKBB+DHKLJXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1307/1848] swim: use blk_mq_alloc_disk
Date: Wed, 18 Nov 2026 15:55:45 +0100
Message-ID: <20261118150014.193757037@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 51fbfedfcc86273eded52f05a2c1aa75e91df8ff ]

Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Link: https://lore.kernel.org/r/20210602065345.355274-13-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 994a778d9665 ("swim: Configure parameter memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index b10052eacce77..0fa87c9c6206c 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -824,23 +824,20 @@ static int swim_floppy_init(struct swim_priv *swd)
 	spin_lock_init(&swd->lock);
 
 	for (drive = 0; drive < swd->floppy_count; drive++) {
-		struct request_queue *q;
-
-		swd->unit[drive].disk = alloc_disk(1);
-		if (swd->unit[drive].disk == NULL) {
-			err = -ENOMEM;
+		err = blk_mq_alloc_sq_tag_set(&swd->unit[drive].tag_set,
+				&swim_mq_ops, 2, BLK_MQ_F_SHOULD_MERGE);
+		if (err)
 			goto exit_put_disks;
-		}
 
-		q = blk_mq_init_sq_queue(&swd->unit[drive].tag_set, &swim_mq_ops,
-						2, BLK_MQ_F_SHOULD_MERGE);
-		if (IS_ERR(q)) {
-			err = PTR_ERR(q);
+		swd->unit[drive].disk =
+			blk_mq_alloc_disk(&swd->unit[drive].tag_set,
+					  &swd->unit[drive]);
+		if (IS_ERR(swd->unit[drive].disk)) {
+			blk_mq_free_tag_set(&swd->unit[drive].tag_set);
+			err = PTR_ERR(swd->unit[drive].disk);
 			goto exit_put_disks;
 		}
 
-		swd->unit[drive].disk->queue = q;
-		swd->unit[drive].disk->queue->queuedata = &swd->unit[drive];
 		swd->unit[drive].swd = swd;
 	}
 
@@ -848,6 +845,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 		swd->unit[drive].disk->flags = GENHD_FL_REMOVABLE;
 		swd->unit[drive].disk->major = FLOPPY_MAJOR;
 		swd->unit[drive].disk->first_minor = drive;
+		swd->unit[drive].disk->minors = 1;
 		sprintf(swd->unit[drive].disk->disk_name, "fd%d", drive);
 		swd->unit[drive].disk->fops = &floppy_fops;
 		swd->unit[drive].disk->events = DISK_EVENT_MEDIA_CHANGE;
@@ -866,14 +864,10 @@ static int swim_floppy_init(struct swim_priv *swd)
 	do {
 		struct gendisk *disk = swd->unit[drive].disk;
 
-		if (disk) {
-			if (disk->queue) {
-				blk_cleanup_queue(disk->queue);
-				disk->queue = NULL;
-			}
-			blk_mq_free_tag_set(&swd->unit[drive].tag_set);
-			put_disk(disk);
-		}
+		if (!disk)
+			continue;
+		blk_cleanup_disk(disk);
+		blk_mq_free_tag_set(&swd->unit[drive].tag_set);
 	} while (drive--);
 	return err;
 }
-- 
2.53.0



