Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016969;
	b=b6Jo/GAJHJTo6V/7MfWwNzJy6lY0q+DgNNSpAGnlAfsvDVzNLoTPvsK6ctat2ZsjGTzV
	 PrzLCqZmTXnU5yVhoUVaFQ7k5Q1xs90VojPMBqIkD5HB6xXqfUkpTSCe1qB6TCG/71Tqx
	 1O9egDKr825CBAU71jBUviNb1wJ2GNtxkVxmmhG9SDhz0C1NtOnjpAUeMe6GMrtvJpjDH
	 VF9FXaeDJPXAYJaO3ci13kvvy3u9aus31t4+jywcgndn5iyBk/BTNu5ckZ9JN5UrWJ9rk
	 rucrqH11qc/9rxjsiphxHldCq78BiafcjOvA8v0iKiSkWL1+v3SH2DSJzK21711W6UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vVij2pnexmOloTE4dACf+hSt8ZJeGQo7E7c/4+6zZbA=;
	b=YsPghOGr/Gcqb1K8DQRKxR9loemYVVLpIa/+yP89GFkaZ0E7mGkDxdR+eEtZHNR5tHlI
	 2C0H4P64Kunfr9gRflKxazPepiRCipEyTkR07Wgsc3zwWo25E1Mh4UGErS+TePqi6KzuX
	 9FOzLWb0oGOcJ5zwY+lDmVDCw4EKSqnQmjswIJRnRel9jrS/2N0xUDnovrAyKg0tPeRfU
	 a0tCAddaQXHpWNAfEpWVbfyHAmK2mNleOV5CtAltJgJMHG3MU7/wQrU+1DnzqzhPjv+9z
	 H2ZObQiIqygu9C0bceqZZsxTuLXsCkO2hdUwVvpfddypFyFYBZpImESbI3sUMa+5Oug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2fC/Gjz0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B5B606A31C;
	Wed, 18 Nov 2026 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2fC/Gjz0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE951F000C4;
	Wed, 18 Nov 2026 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016968;
	bh=vVij2pnexmOloTE4dACf+hSt8ZJeGQo7E7c/4+6zZbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fC/Gjz01uDmSS3+vuWVkh5l74hNY4M6jZK353e4DWNGLhldzvDQco5Jtw+4kUlUa
	 /FwSo1X5MMYZS6KcDojctjJfoez1MJVzruXwhr4XWCdqD5kEfzuCpo4HVDUK75+s4g
	 QLUdds4IJJ+O17lN0QuslXEai3Pjpa2DWVOJ9gR8=
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
Subject: [PATCH 7.3 0717/2651] swim: Convert to blocking queue
Date: Wed, 18 Nov 2026 15:32:37 +0100
Message-ID: <20261118150313.691246593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 53a54a96feef1..c3fbcf377d1ff 100644
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



