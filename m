Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060745;
	b=MG2ZlSD0Xl8xryfrhNoWcABLZl8bPwQBfthY2H50KcI0uS5/TL5C2kDSSQzXoRIaqK6f
	 3JF1CLMTmXopPeRfVgxymu+mA62W4TH1hnk+XqW8xhADqQhociNnyx0Qbqg0b+eR9XFIQ
	 YoM16QKvDAjcZF8DhSgFKO2DH7pBFdsd8qlbR7j4TvBge9fpa5vyVP1OIX8F51K5WtltL
	 TGxyVDf56Qnbcbs6muNFmk3NyKuKpZngCZhz3Kojm6Od2JfzC8VUiQ3rWnZsahn+l+6Pc
	 I71zfgfkaDAMcDjNJ5rmTG+G3PqLpIojymXur9+z9fK4sMEP/WT9fP6dU19u0I/MQJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QvQ2Hs4YbVrFFlYhea8DZJ4VD1wWaePDEsPN2UfSOnA=;
	b=CDEz9RqWpb/AETRCb2ryPU25znTyCKO5xRCxZeYOHFLvRlx1JQCiJNxHGyAg/rb6KMR3
	 X3FvmxuZ/IvCaZTRqealEfSuKOpShuiuW1OjGBeaJvMbRq5TAw5+HVvjYmxhgDgDrX6+g
	 Lv2Wq+IDnZ1bmbymEZVxyxoyxAGZqgtdzB5H4L5Ycg0QR3oM9DxzznY243QpbGQilJiTj
	 dEZnJRlUneTusMjQk59wuSNARVd58sPSeL134tBj0wmZkbTBj/zAvSvKTBRzhsBlE1dnu
	 /OQglPp6qR7yNkdpcKrPR0QKGqiraL0eOi4uj7N3LUPmvaNHlwPokfTCO8gIZcqd5aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrhEmx56;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E69606A320;
	Thu, 19 Nov 2026 03:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrhEmx56
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6C31F000C4;
	Thu, 19 Nov 2026 03:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060744;
	bh=QvQ2Hs4YbVrFFlYhea8DZJ4VD1wWaePDEsPN2UfSOnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrhEmx56OqvPYCT15SnRKeeEEsx6bhy7Xms/1Z6EsZ08H67fJ8pXTZ+d+5zO9o63O
	 gxtQ7BzVWWtRDFcr7gfL1qWocr9dSVW261yFHMfUsldTxBopUcat9I1bMOKRG2VO7v
	 C1Hb+63ZAjNhdQihT6Z1zKEG4FUFOQ3o/RiK2P74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1309/1848] swim: add helper for disk cleanup
Date: Wed, 18 Nov 2026 15:55:47 +0100
Message-ID: <20261118150014.273610966@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 4e9abe72530a2baf5f80d60e8d0bcdb84964d2e4 ]

Disk cleanup can be shared between exit and bringup. Use a
helper to do the work required. The only functional change at
this point is we're being overly paraoid on exit to check for
a null disk as well now, and this should be safe.

We'll later expand on this, this change just makes subsequent
changes easier to read.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210927220302.1073499-9-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 994a778d9665 ("swim: Configure parameter memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 34a63fda9c9f1..d10cabe464319 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -794,6 +794,17 @@ static const struct blk_mq_ops swim_mq_ops = {
 	.queue_rq = swim_queue_rq,
 };
 
+static void swim_cleanup_floppy_disk(struct floppy_state *fs)
+{
+	struct gendisk *disk = fs->disk;
+
+	if (!disk)
+		return;
+
+	blk_cleanup_disk(disk);
+	blk_mq_free_tag_set(&fs->tag_set);
+}
+
 static int swim_floppy_init(struct swim_priv *swd)
 {
 	int err;
@@ -862,12 +873,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 exit_put_disks:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 	do {
-		struct gendisk *disk = swd->unit[drive].disk;
-
-		if (!disk)
-			continue;
-		blk_cleanup_disk(disk);
-		blk_mq_free_tag_set(&swd->unit[drive].tag_set);
+		swim_cleanup_floppy_disk(&swd->unit[drive]);
 	} while (drive--);
 	return err;
 }
@@ -940,8 +946,7 @@ static int swim_remove(struct platform_device *dev)
 
 	for (drive = 0; drive < swd->floppy_count; drive++) {
 		del_gendisk(swd->unit[drive].disk);
-		blk_cleanup_disk(swd->unit[drive].disk);
-		blk_mq_free_tag_set(&swd->unit[drive].tag_set);
+		swim_cleanup_floppy_disk(&swd->unit[drive]);
 	}
 
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
-- 
2.53.0



