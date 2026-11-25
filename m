Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618328;
	b=u+DoFgMH7Zgheelh92RMFegEdxwt/VV6Y3GxYoCB9aRRewjcR/OaR8x69uPyrSj1U2kG
	 XrPOPigTGHfMCAbXSclwGPGKU5d1IE94tK0NHuKPWhBo52HVtdcDgNY43rR7yv7jFg9C6
	 YORz50808VqGq5zsSRd4XDZbmOc32CesK06KZQXBVYQaWfwqU5jb2Jqh4+jBlRT2PQ6VD
	 URGETKgNugu6Bt3N1r5++YrE0p4LeNUONJ2j320jJE84HPrxTXylzdPrCnvT6kj2p/rFC
	 roceTD2kMbMb52tKXyfpayN8fVnLIYPdYt8u3j6kwSaJjkQ/ZPZXfsewMDK6XtfRtBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qDAJGhm4YSYjucd3H9QOTp2Y5PphzfvZCnZnEE4Vscw=;
	b=WSCIVaXsqhAILGP6uRM7kqlIFfQ1FSxZWYP0o7cVVguPSQ08YtCcH/GfYMESma9TAGN2
	 AK6Xh5XqKM58aTsvekfpwVrGl0TBPr0ZPH6XGD5rqbPg3dRdXoNYm+qroIir4lBU/AtPp
	 o8QMpszrwE2u6qC0NZgcnL1TXkDuicd0Y40RZaJuy8QbJEzjwDsYmAEU20dQhU+YKy3TP
	 IWONW92AXyDf7ipuDsx910yTVdPWh0Cujn8DQMfmwDKc9y1MjK+UrSPzLdiSAoeM6odsx
	 1FmYCDZhDeYaH7a2qnulVXont+udeN6gNKRCV9rqpH4SVMh9rVaDLQ8A4j/ZrMa/pPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUayEX2W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB81606A31E;
	Wed, 25 Nov 2026 14:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUayEX2W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1791F000CF;
	Wed, 25 Nov 2026 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618328;
	bh=qDAJGhm4YSYjucd3H9QOTp2Y5PphzfvZCnZnEE4Vscw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUayEX2WhyvmZkxzVUFZuSjvcX3u55gqVtahh/xzm9sx39x46G8Lsj0znbV4YtUb1
	 CdQCJOGRrsAuwV/DocLKOMnbNK5vO9jYWFUEVoBmqYyQnuEeIkJbNfxgZuBar7RaNS
	 I4o57rQ5JifY5kBAltdWjbk3QQUA4o7+f+ib1v/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0244/1005] virtio_blk: freeze the virtqueue layout at probe time
Date: Wed, 25 Nov 2026 15:26:22 +0100
Message-ID: <20261125143827.453872019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yunye Zhao <yunye.zhao@linux.alibaba.com>

[ Upstream commit d53c1a12ff1cfdb12770ddcfdf5603915d0ba0d8 ]

init_vq() reads the writable num_request_queues and poll_queues module
parameters both at probe and when recreating virtqueues after suspend
or reset. However, virtio-blk does not update the blk-mq hardware queue
count or queue maps on restore.

Increasing poll_queues can therefore remove the completion callback
from a virtqueue still used for interrupt-driven I/O, leaving requests
uncompleted. Reducing the effective request queue count through
num_request_queues can instead leave existing hardware contexts
indexing beyond the reallocated vblk->vqs array.

Determine the virtqueue count and the split between interrupt-driven
and polling queues once at probe, and reuse this layout when
recreating the virtqueues. Changes to these module parameters then
affect only subsequently probed devices.

Fixes: 0989c41bed96 ("virtio-blk: add num_request_queues module parameter")
Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Link: https://patch.msgid.link/20261102133740.88919-1-yunye.zhao@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 1efc1ca38928a..2b462005cdb68 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -965,16 +965,13 @@ static void virtblk_config_changed(struct virtio_device *vdev)
 	queue_work(virtblk_wq, &vblk->config_work);
 }
 
-static int init_vq(struct virtio_blk *vblk)
+/* Keep the queue layout unchanged for the lifetime of the tag set. */
+static int virtblk_init_queue_layout(struct virtio_blk *vblk)
 {
-	int err;
-	unsigned short i;
-	struct virtqueue_info *vqs_info;
-	struct virtqueue **vqs;
+	struct virtio_device *vdev = vblk->vdev;
 	unsigned short num_vqs;
 	unsigned short num_poll_vqs;
-	struct virtio_device *vdev = vblk->vdev;
-	struct irq_affinity desc = { 0, };
+	int err;
 
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
 				   struct virtio_blk_config, num_queues,
@@ -992,6 +989,7 @@ static int init_vq(struct virtio_blk *vblk)
 
 	num_poll_vqs = min_t(unsigned int, poll_queues, num_vqs - 1);
 
+	vblk->num_vqs = num_vqs;
 	vblk->io_queues[HCTX_TYPE_DEFAULT] = num_vqs - num_poll_vqs;
 	vblk->io_queues[HCTX_TYPE_READ] = 0;
 	vblk->io_queues[HCTX_TYPE_POLL] = num_poll_vqs;
@@ -1001,6 +999,20 @@ static int init_vq(struct virtio_blk *vblk)
 				vblk->io_queues[HCTX_TYPE_READ],
 				vblk->io_queues[HCTX_TYPE_POLL]);
 
+	return 0;
+}
+
+static int init_vq(struct virtio_blk *vblk)
+{
+	int err;
+	unsigned short i;
+	struct virtqueue_info *vqs_info;
+	struct virtqueue **vqs;
+	unsigned short num_vqs = vblk->num_vqs;
+	unsigned short num_poll_vqs = vblk->io_queues[HCTX_TYPE_POLL];
+	struct virtio_device *vdev = vblk->vdev;
+	struct irq_affinity desc = { 0, };
+
 	vblk->vqs = kmalloc_objs(*vblk->vqs, num_vqs);
 	if (!vblk->vqs)
 		return -ENOMEM;
@@ -1056,7 +1068,6 @@ static int init_vq(struct virtio_blk *vblk)
 		spin_lock_init(&vblk->vqs[i].lock);
 		vblk->vqs[i].vq = vqs[i];
 	}
-	vblk->num_vqs = num_vqs;
 
 out:
 	kfree(vqs);
@@ -1522,6 +1533,10 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
+	err = virtblk_init_queue_layout(vblk);
+	if (err)
+		goto out_free_vblk;
+
 	err = init_vq(vblk);
 	if (err)
 		goto out_free_vblk;
-- 
2.53.0



