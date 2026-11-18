Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043854;
	b=u+qXuNFcedj5ROMBFGagfoyKBCj2mCjH8upInWSTCTBokEEOGXj5Sqe+7ye5/36R7RON
	 sj/cf3Sc0gCLtXklPNEqOAWU0VsU7NJja0hgjeLdQt7ZU08ziyEILM9twTZMGyqvMHwdf
	 lD/vKxPZAEgqnxD/W1NZWIEHjCOtegbNL/4IiNVywaMV1I5YZIDhRLOJ7LND6kTqc520C
	 GrXh3PZB3havSp8juT6Pvr8VKwXUZqaQ4B3Th8HKhGQB7L8XuWai8ZfNgTh+35T2S4VGZ
	 k4l38plb8ulzP27TYJ4Apc8vWBNacwUZWqvDVN6v8uzL8xtV2qGfSj8zjSwH/jkOLZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2b3kd/sKK2NmeWwGKn6S6Zp7xOlUzM1KHdUb4WcidM4=;
	b=xclR5Q5QHK+e8KspdcQYwd/w0jKOBQ7Ep/FIT7clEFQNTuxR0nuRlt/vtP9iHhMeb3YF
	 EqNert+zzrkAGEFMn4a/FzrRVR6yfO6TEp4hZV+bvtC1PiG7ZPl/7jAUiiC9RTUgHUaf6
	 h0yzB6vSpWRorGOywBbQXw+jAIUaQotCBfYI6ft7YT3Rj/9GQbPrlS4tAjNtXfoM/XU/F
	 jADWBonGFAg7GFPLQ/hvquttKru0T9nTzmH5zD55TeRKtobb1m8ioY2lOfIXODi4yWUJB
	 ncxIHrYq28/FD+1A70LC/KIe0H7FJyI0s+cvtJ50uxawtUQmQVfuJcl6mdUKxH0KCxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibi3ivAO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FD5606A32F;
	Wed, 18 Nov 2026 23:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibi3ivAO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A68F1F000C7;
	Wed, 18 Nov 2026 23:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043853;
	bh=2b3kd/sKK2NmeWwGKn6S6Zp7xOlUzM1KHdUb4WcidM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibi3ivAOQqLaII2IUxtPZdPOJt42lDTLyLhSH2ZLHd9X1pLDXf5HxlGcf+7Mz2j5d
	 137l04leLztLBg7P/2xKjzRTuAVRv1DmSoFmGnnyfoaefNAIXPCxh2cxZzj/UNliQM
	 LgzOfwoonCketCkqzY5XYbWoxqOWbWPn7AnX/+7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0358/2857] block: set QUEUE_FLAG_DYING unconditionally in blk_mark_disk_dead()
Date: Wed, 18 Nov 2026 15:23:12 +0100
Message-ID: <20261118150214.330004788@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 胡连勤 <hulianqin@vivo.com>

[ Upstream commit 7e9a46004b471eaf69b082c473d865316a4158e0 ]

Disks created via blk_mq_alloc_disk_for_queue() (e.g. SCSI SD disks)
do not have GD_OWNS_QUEUE set.  Currently __blk_mark_disk_dead() only
sets QUEUE_FLAG_DYING when GD_OWNS_QUEUE is set, so for such disks
blk_queue_enter() and __bio_queue_enter() cannot detect the dying
state via blk_queue_dying() and remain blocked waiting for I/O that
will never complete after surprise removal.

blk_mark_disk_dead() is the explicit "surprise removal" API -- the
caller has already decided the disk is dead.  Setting QUEUE_FLAG_DYING
unconditionally here is appropriate: any in-flight I/O from other
threads should get -ENODEV immediately from blk_queue_enter()
regardless of GD_OWNS_QUEUE ownership.

For disks that already have GD_OWNS_QUEUE set, __blk_mark_disk_dead()
will set the flag again which is harmless.

Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/PUZPR06MB62247E82E66A3ED46CC3E6C7D2DC2@PUZPR06MB6224.apcprd06.prod.outlook.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Added the QUEUE_FLAG_DYING set as the first line of the older inline blk_mark_disk_dead(), since the upstream helper __blk_mark_disk_dead() doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/genhd.c b/block/genhd.c
index bf59b9131d27c..ee6dc7feccc6f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -592,6 +592,7 @@ EXPORT_SYMBOL(device_add_disk);
  */
 void blk_mark_disk_dead(struct gendisk *disk)
 {
+	blk_queue_flag_set(QUEUE_FLAG_DYING, disk->queue);
 	set_bit(GD_DEAD, &disk->state);
 	blk_queue_start_drain(disk->queue);
 }
-- 
2.53.0



