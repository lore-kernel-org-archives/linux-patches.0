Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024358;
	b=gyzB0b3wN0wRVO9p5gMC2hf57lxitBcCwy72z/9tq8sbH7upD1UypDZzxD7Lue3OVGme
	 fVxRacaqy6MXo7VywVJeQeRz3Owg7Y0DeIk4S+ciXtoR/JhJSllZKb5uEEizGhirXyiTt
	 a+l4yiUL/YksqhRKNR/0S8aICdWwfYLUBwSHxXtGFUDNSejiT3qgY+X8C/Z02VEFS/ruC
	 rSQ7WWdip5SOwr4eRpm4ZPiPbFv3FmJ5hxpTqqdnqsyuqggwyFQn0qOqYDFUDIpgRFFiP
	 NWoALXCyKqfNOf5kbwCyobax/FlHUWkm3U1cp6sF/mehmpuVcQ8iaKt/2iD/yWpwOOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q9KsRBEsguLIiQX28ot+LOnhYZc05yp1I+P6S10/oh0=;
	b=JOlBAobysXTevCBWMF2wvPOooGUeVwiQAsOP14E8HsMTLg6JSymZxroR4kQOqKbfTUtf
	 ZHE8rE9X/YLsFIO7PBJL9iafh15g2dvURo+Nps4ZqQgqHs3C3F/p19vcLCoC+Y6YB4iiH
	 ogc1pm3xeVfGujIlX8Y1JQ6PPjZ8LUEpx8PzALjta0ZevUzmYJf7oDMxUCJjUnwqqO1Up
	 j/WyS90Nl+dqR3ULySwzzHqpWW9ueDdaWTR+dpzWBVmBJTgVeuWnk5fFm52dtn6TxrAYt
	 BZIehRZkI3xkLgXlndVATkQ+JciED3ItypfhUKJ4VHwKvjlp08d2tzqD7vKd0apsneQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftVKhUYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF49606A331;
	Wed, 18 Nov 2026 17:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftVKhUYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DB11F000CA;
	Wed, 18 Nov 2026 17:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024358;
	bh=Q9KsRBEsguLIiQX28ot+LOnhYZc05yp1I+P6S10/oh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftVKhUYs4PfFH1FDC8wuiDMLdVPSmhmhL7KWSRmAZT5/e4NE2uLtav2l7Zz/wgsaO
	 ymoidgk919Wueek7qSmnl/m4BNBeMpQBUEClV7wEklm/Mn3nIdpFlosnaMR6ZJvX1G
	 w6dk9eYPtF0D9OCMAyhQd3IZU3xeVW+zM962ERfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0646/2151] swim: Convert to blocking queue
Date: Wed, 18 Nov 2026 15:39:41 +0100
Message-ID: <20261118150145.388413862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 92353a04763726f70fea6be90957c50fc18215e0 ]

These drives are slow: completing a request can take hundreds of
milliseconds. Delays are managed by disabling interrupts judiciously and
sleeping opportunistically.

As of commit e3896d77b702 ("swim: convert to blk-mq"), a spinlock is
taken in irq mode as soon as a request is issued. That lock is held for
the duration of the request. Hence the driver sleeps while holding the
lock which is forbidden.

Adopt BLK_MQ_F_BLOCKING and remove the spinlock. Use a mutex to serialize
requests from the two request queues. (The chip cannot simultaneously
process requests on both internal and external drive.)

Cc: Omar Sandoval <osandov@fb.com>
Fixes: e3896d77b702 ("swim: convert to blk-mq")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/d06b19132ec678d6168d158e10cd63e10da45607.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index ebba9506e78d0..cbf564dc23323 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -211,7 +211,6 @@ enum head {
 
 struct swim_priv {
 	struct swim __iomem *base;
-	spinlock_t lock;
 	int floppy_count;
 	struct floppy_state unit[FD_MAX_UNIT];
 };
@@ -537,12 +536,10 @@ static blk_status_t swim_queue_rq(struct blk_mq_hw_ctx *hctx,
 				  const struct blk_mq_queue_data *bd)
 {
 	struct floppy_state *fs = hctx->queue->queuedata;
-	struct swim_priv *swd = fs->swd;
 	struct request *req = bd->rq;
 	blk_status_t err;
 
-	if (!spin_trylock_irq(&swd->lock))
-		return BLK_STS_DEV_RESOURCE;
+	mutex_lock(&swim_mutex);
 
 	blk_mq_start_request(req);
 
@@ -560,7 +557,7 @@ static blk_status_t swim_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	err = BLK_STS_OK;
 out:
-	spin_unlock_irq(&swd->lock);
+	mutex_unlock(&swim_mutex);
 	return err;
 
 }
@@ -842,11 +839,9 @@ static int swim_floppy_init(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
-	spin_lock_init(&swd->lock);
-
 	for (drive = 0; drive < swd->floppy_count; drive++) {
 		err = blk_mq_alloc_sq_tag_set(&swd->unit[drive].tag_set,
-				&swim_mq_ops, 2, 0);
+				&swim_mq_ops, 2, BLK_MQ_F_BLOCKING);
 		if (err)
 			goto exit_put_disks;
 
-- 
2.53.0



