Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618310;
	b=4Ia1wzItFQ+abe3oeegxS91ClGgbyrWaOgnmKgnqRp3lkn6vM4V9xI3+mBOhA8m52stx
	 m5MulE31gbhu1Vv3vHieoewLr5dDrpR7WkAdNPFARfDXvSQ7L+dj6HBHS0G7j9S3GL6L+
	 pRH+PaTsRGvfxtC/AiJLu6nAXW0/CmyfXfOlV2GWl0dNCeC5oNSoEVllFGcP8S2YnUyil
	 h7jTxXty8JTq1IKyP91OL806FTa/+PeDVp9Gb+ha0szwfwAYp2lKiGHI894MZH0MxIO62
	 ePGCD/zvgCMPTwP176DUSNqXtvZs/7+r6yQroIquK8qO3uhhfo+6bifYn8l5txCqeIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fuy+8oofftaPQ2bqhlNufSCXYB82u68bxTFS2Zb7FLs=;
	b=wEihKXXNLxndpIRSgcebX1tlqXAipxXJplOgtNVgwUsCYnXlUBx/g+wkhmZvZCWdtAaQ
	 DuPM2sNL9UOViyJsDALHdwB4KB6Z41BOrOXj2Mbz0olTmW9R31CttAqeptgGIGaj4Kv2K
	 vV5k4XyNvoiZ+1rIU5WfDvVUnMPIVdjRata4Lvnwum0YBkmlg3l+v35XxX1XRQn/1OCPj
	 YgAyIPK6jHoxRyv2ihc3fTWRDIJ+Cd4Yi+14Xm+SqYY0SQ36CxGoPJQ99FAnApaD62Glj
	 7d0pitlmjr2YxwTz6vG8LkZuTToaOeKLHsw0+kDeYj0m3NRlOFURg7WMKXMCMdEG6aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGYQfoEK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060DF606A31E;
	Wed, 25 Nov 2026 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGYQfoEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81511F000C0;
	Wed, 25 Nov 2026 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618309;
	bh=Fuy+8oofftaPQ2bqhlNufSCXYB82u68bxTFS2Zb7FLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGYQfoEKrA+9hpTOpw3LaNjAuBaubtsru6JOZMdvNgWl6aJZGZ808KWTRY9t3ygXu
	 m62WClJEQIJtGpD3+tNJbhD2eEejGMVbZEMjzogZ/6z9jQEelzDTJv+slGpveUVUAH
	 7mF77FSPl35FQA/K8HUEIGlLK1vqd6MbOvcrFGD8=
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
Subject: [PATCH 7.3 0239/1005] virtio-blk: Fix zone append sector reporting in batched completion
Date: Wed, 25 Nov 2026 15:26:17 +0100
Message-ID: <20261125143827.336724150@linuxfoundation.org>
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
index f97799b5154f2..1efc1ca38928a 100644
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
@@ -1220,8 +1227,11 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
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



