Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621551;
	b=5iBLpHPPvMsfhjR9KP0/jcycqFWdyfVEFf5kfPmzSQJVdGsaiPAyLVLusRl71UYyOraR
	 fbJMGS/69j0+W3lkd9rb/ddUqjnR5AZtC2TieRKrDOj7IOOXUUtpadzHmWmLpLFf2l8S5
	 FPV5zhZbTCJxe1qF+DzhwlFlbSXFJRttCVeCl/x14pNdBNc3PeXhzwVZ/SI9tN4VQiiys
	 Z4ee7FLEL4bp4XPjGwrpw/GV0AHH/AVPD5bxe44wXS0i2vMVmDQxq1Yn3hlFxHbwZNTGD
	 uap1zMPeavT0Guyg3MYSeoBsUTtUaJBKp9TZKggxtdfqDK1D63grO1qKhGI5tm+Yseg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e0Giet3iLG3Q8i8lrA91RRlkA0P/gS6VHsOTkK+j7PM=;
	b=R/XnLIlTc8rugqrLn9Dd8bc8ydDddeIRdx/WoqTk11byVnHHclgb0yfJhsrwCI1iKeQb
	 FeG4b3VkVH2CytsJyqHGXvznEvkSzuuzkXzjK9plewcDo4FDNO/Kycmod+UvAF6nDpY9l
	 g0C/mqXEhRgBpaYB+LCvtGLep60ubj6dsQDcLIFVnkZlBSYRvT7GSUfm51sfSMmXIF0RE
	 MVgYgOCD40S9vzX4SZ7qC9iCeQLxzJhe2qqRhADKtm5oqzxv9J6u6VNqX2fK9AoeR90dQ
	 4Ep/1nmJbCWQTNd0tpRxEOaBHQt+4i+hbPMVWECMeHE/Bk658Idjrz/EB0JHk20dPBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bFH4zxn/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2706606A31E;
	Wed, 25 Nov 2026 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFH4zxn/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB51B1F000CA;
	Wed, 25 Nov 2026 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621550;
	bh=e0Giet3iLG3Q8i8lrA91RRlkA0P/gS6VHsOTkK+j7PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFH4zxn/Itblc6q5cx19tyfK4P9mNu9OJhraXVx+BSKeltlYCF+YUdj7E7s5aUJgE
	 PRiH8USgHOd/bWe7TTXE7qDKfHrUM7Qow5L8V6LM4TBDTi4ytg6evztH/Xv01mc2UA
	 B71wijF+gDWqjyqW8uYPLWJyXcKMXFBbtlyxjwwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/990] virtio-blk: Fix zone append sector reporting in batched completion
Date: Wed, 25 Nov 2026 15:26:22 +0100
Message-ID: <20261125143827.124791687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit 08a6572441a4e646c96c2b8d8ead9eea0e458332 ]

For zone append, the block layer copies req->__sector back into the
bio in blk_zone_append_update_request_bio(), so the driver must update
req->__sector with the sector reported by the device.
virtblk_request_done() does that, but the batched completion path used
by virtblk_poll() only unmaps and cleans up the requests before calling
blk_mq_end_request_batch().

A zone append completed through polling therefore keeps the sector that
was assigned at submission time, and the file system or application sees
the wrong LBA for the written data.

Move the sector update into a helper and call it from both completion
paths.

Fixes: 95bfec41bd3d ("virtio-blk: add support for zoned block devices")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/202610261955196384aSLGuy3_0MiTvlYXVdiC@zte.com.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 29317945a7c00..8ee96de512395 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -331,18 +331,25 @@ static inline u8 virtblk_vbr_status(struct virtblk_req *vbr)
 	return *((u8 *)&vbr->in_hdr + vbr->in_hdr_len - 1);
 }
 
+static inline void virtblk_update_zone_append_sector(struct request *req,
+						     struct virtblk_req *vbr)
+{
+	struct virtio_blk *vblk = req->mq_hctx->queue->queuedata;
+
+	if (req_op(req) == REQ_OP_ZONE_APPEND)
+		req->__sector = virtio64_to_cpu(vblk->vdev,
+						vbr->in_hdr.zone_append.sector);
+}
+
 static inline void virtblk_request_done(struct request *req)
 {
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	blk_status_t status = virtblk_result(virtblk_vbr_status(vbr));
-	struct virtio_blk *vblk = req->mq_hctx->queue->queuedata;
 
 	virtblk_unmap_data(req, vbr);
 	virtblk_cleanup_cmd(req);
 
-	if (req_op(req) == REQ_OP_ZONE_APPEND)
-		req->__sector = virtio64_to_cpu(vblk->vdev,
-						vbr->in_hdr.zone_append.sector);
+	virtblk_update_zone_append_sector(req, vbr);
 
 	blk_mq_end_request(req, status);
 }
@@ -1213,8 +1220,11 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
 	struct request *req;
 
 	rq_list_for_each(&iob->req_list, req) {
-		virtblk_unmap_data(req, blk_mq_rq_to_pdu(req));
+		struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+
+		virtblk_unmap_data(req, vbr);
 		virtblk_cleanup_cmd(req);
+		virtblk_update_zone_append_sector(req, vbr);
 	}
 	blk_mq_end_request_batch(iob);
 }
-- 
2.53.0



