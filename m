Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052163;
	b=Iuj7lcx58/qrEPZia5d6hCoVnXI3Sfu+QbuP4Rv2dsZ5kLK/zcHTf6abMNqzes8n1XeA
	 pHilOQWr8/s7O6zNTSLml8GxLO73c6eRQ5UhMM0+L1QmOawdMfcIRvujYQsgv8eJqLiju
	 09kVH25l43mPq7kaBJCb+g3WInuS4TKE5KfY1SrDWS1q4W8v177A2WlW9jVfaecx4nxpJ
	 xOG4OzUWtCWQ4IRb5r3zdpyTCLex9L1rc8hAYI1r1sCn9WVelQ4sr8HYLna+SrTl33qGW
	 /FXfvLeLU1X34VfVP9Rg6q4RL46TlVQanaxezgvWI+Pm5GUvtiQ9CqU2ZNcezUdFIww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=skPw9tp3meV3vFz1tKBD/EoF7aectNReUWH0fUys8t0=;
	b=Q0CTXTqeqr1PnbCHlI7QLRokZT0IOsPw0HAzy819NJUHkAGlCo5Xjb4Qm56xCzb2Ler+
	 vLsOsnuyaODO6FrxzyGaDGPSCIK2B8UWftz9Y9D5/iKvGGwVaeyYfYgiiG+N4tdfMyIQt
	 DhvQypBm3586Du/ixv0XNGdWsmeULDT4JHsX+kYLNmN4w4KQJSP5C2EaLt08DrZP78rA8
	 G5smVIGN7obwEPZAfa22LkQUrUCXLTuwNJwBhuBlWdgoLAaFmcInk2K1XBaN29RpfAyqy
	 ttcYY+2X3u4L1TRhN8WuKf94wsb/PQe6RgkZCYCcwNlG/0gMnXWvZrnKvAJjqXnJi+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVj8VY2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85BD606A31C;
	Thu, 19 Nov 2026 01:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVj8VY2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADDF1F000C4;
	Thu, 19 Nov 2026 01:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052163;
	bh=skPw9tp3meV3vFz1tKBD/EoF7aectNReUWH0fUys8t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVj8VY2KgQ9H29e7feD29K20koe4qIkVDmX6bXe/IHNEhSu/7579o4byyxIIVELRo
	 WsngP8K5adr2fxdFgnU6V6X9LuMQC73ifWBRaYjuMd4vxrnSMbI6AD7VRFsuZUuvs0
	 vg46IQNQ0+TTSDW1kfHzxngDKYxeVMQhMTNH6Lw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Younho Choi <gdool88@mju.ac.kr>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0464/2214] media: vim2m: keep transaction buffer count stable while streaming
Date: Wed, 18 Nov 2026 15:35:40 +0100
Message-ID: <20261118150029.772552364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Younho Choi <gdool88@mju.ac.kr>

[ Upstream commit 50f5fed44d8e24081e8feed5154746fe193f11b8 ]

V4L2_CID_TRANS_NUM_BUFS controls how many buffer pairs a vim2m
mem2mem job processes before the job is completed. The driver stores
the value in ctx->translen and device_work() uses it later to decide
whether the current transaction should continue.

Letting userspace change this control while streaming is active can
make a queued job observe a different transaction length than the one
it started with. That leaves the transaction state inconsistent with
the buffers currently queued for the job.

Grab the transaction buffer count control while either queue is
streaming, and release it only after both queues have stopped
streaming. The V4L2 control framework then rejects changes with
-EBUSY while the value is in use, while still allowing userspace to
configure the value before streaming starts.

Keep the control handler alive until after v4l2_m2m_ctx_release(),
since releasing the mem2mem context can call stop_streaming(), which
now ungrabs the control.

Fixes: 96d8eab5d0a1 ("V4L/DVB: [v5,2/2] v4l: Add a mem-to-mem videobuf framework test device")
Cc: stable@vger.kernel.org
Signed-off-by: Younho Choi <gdool88@mju.ac.kr>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vim2m.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/media/test-drivers/vim2m.c b/drivers/media/test-drivers/vim2m.c
index 48178d5150d7a..483e48ce1d0b9 100644
--- a/drivers/media/test-drivers/vim2m.c
+++ b/drivers/media/test-drivers/vim2m.c
@@ -205,6 +205,7 @@ struct vim2m_ctx {
 	struct vim2m_dev	*dev;
 
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl	*trans_num_bufs_ctrl;
 
 	/* Processed buffers in this transaction */
 	u8			num_processed;
@@ -1068,9 +1069,27 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned int count)
 		ctx->aborting = 0;
 
 	q_data->sequence = 0;
+	v4l2_ctrl_grab(ctx->trans_num_bufs_ctrl, true);
+
 	return 0;
 }
 
+static bool vim2m_other_queue_is_streaming(struct vim2m_ctx *ctx,
+					   struct vb2_queue *q)
+{
+	struct vb2_queue *other_vq;
+
+	if (!ctx->fh.m2m_ctx)
+		return false;
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		other_vq = v4l2_m2m_get_dst_vq(ctx->fh.m2m_ctx);
+	else
+		other_vq = v4l2_m2m_get_src_vq(ctx->fh.m2m_ctx);
+
+	return vb2_is_streaming(other_vq);
+}
+
 static void vim2m_stop_streaming(struct vb2_queue *q)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
@@ -1084,11 +1103,14 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 		else
 			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		if (!vbuf)
-			return;
+			break;
 		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
 					   &ctx->hdl);
 		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 	}
+
+	if (!vim2m_other_queue_is_streaming(ctx, q))
+		v4l2_ctrl_grab(ctx->trans_num_bufs_ctrl, false);
 }
 
 static void vim2m_buf_request_complete(struct vb2_buffer *vb)
@@ -1191,7 +1213,8 @@ static int vim2m_open(struct file *file)
 
 	vim2m_ctrl_trans_time_msec.def = default_transtime;
 	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec, NULL);
-	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_num_bufs, NULL);
+	ctx->trans_num_bufs_ctrl =
+		v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_num_bufs, NULL);
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
@@ -1245,10 +1268,10 @@ static int vim2m_release(struct file *file)
 
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-	v4l2_ctrl_handler_free(&ctx->hdl);
 	mutex_lock(&dev->dev_mutex);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	mutex_unlock(&dev->dev_mutex);
+	v4l2_ctrl_handler_free(&ctx->hdl);
 	kfree(ctx);
 
 	atomic_dec(&dev->num_inst);
-- 
2.53.0



