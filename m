Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061935;
	b=tXmoFhVIn2/8zk9wB38Q7HjDF6I+ENVuE3EiLbc4swDGI6/CpUbUygI8e8dsiV8j/MIm
	 vzFhDWS38jWQv1DF0Z2sK1AW31xPomlCdPTDB5Yjw4AIidlO9tiBC12gsFKWcIpoy/iKU
	 IIIJMT8Ha5WsIj0+BntYElEIZBgWmLmauEswMUZ8WPQ3TgjFCn/GnqfQhbYtEjoXmlRPf
	 /xAlpqU/yTFRrmYQVMV7eHj+kCUJKpZdzZzMZ25sGAulfCQ7t+13Gdn7iZn9x9t9hSRDe
	 u2+eix4p/67SqW+1d8hOcZGYeLXy5i/Th2qiwoPwmt7Gt3awqN8WbNSWf1oVqFH5m5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OWe8KnLEo68xEQwclZ6VX7IuQadl21zNqh68Mq833gM=;
	b=dJdAqkjnzW3IGYzwzGqG0djiYDKxP5o4uNj81BWG7UC+EBHGAXh9vkykvY6lD/awUCMM
	 0CiFOLuSuQrFUzX+aTnoBiy9+QXZq0fesNl95Jm5B3oc+/41wdTKut7nrm3ps/39KXIBw
	 xH81u0igIxBA9e0VjkPtotA+SlCdDJAmOU+utmU5v3D/tTD5bPe8JWnzzWlT+hdhhKdW4
	 bD+lwGJQVD4lh6bsrg73ZEsxPu9Dhs1l3KfOz7ssW3wACvEHUG1mdz2lfY4s2GlYTc9Fc
	 Wct+gBWNQZeIHlLWIcvouAkAryhGv5UCSp3p3aysdF6Xxuu2ej+UUFdi4W68+1vAZ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wjSrss/p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1AC606A32D;
	Sat,  7 Nov 2026 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjSrss/p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ECC1F0089F;
	Sat,  7 Nov 2026 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061935;
	bh=OWe8KnLEo68xEQwclZ6VX7IuQadl21zNqh68Mq833gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjSrss/pbwL+YudlDi825OTNAKoGbGGpXwqJYjZgzVHrc+W8KVSGN3QeCBCLKZD/S
	 iH1Q1d0b4OSbNZ0nVYOOVhLEufO9DUkhhy/wDsJFBvrXfIdrZCjc4I/5TR5OwDPxw7
	 GXGab0kfwdZmoZ2X4nkC5gysHB2z/5q51qJlBCVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Younho Choi <gdool88@mju.ac.kr>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0938/1536] media: vim2m: keep transaction buffer count stable while streaming
Date: Sat,  7 Nov 2026 08:49:14 -0500
Message-ID: <20261107135023.996384993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8ca6459286ba6..b686ebcfa7428 100644
--- a/drivers/media/test-drivers/vim2m.c
+++ b/drivers/media/test-drivers/vim2m.c
@@ -200,6 +200,7 @@ struct vim2m_ctx {
 	struct vim2m_dev	*dev;
 
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl	*trans_num_bufs_ctrl;
 
 	/* Processed buffers in this transaction */
 	u8			num_processed;
@@ -1063,9 +1064,27 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned int count)
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
@@ -1079,11 +1098,14 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
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
@@ -1186,7 +1208,8 @@ static int vim2m_open(struct file *file)
 
 	vim2m_ctrl_trans_time_msec.def = default_transtime;
 	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec, NULL);
-	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_num_bufs, NULL);
+	ctx->trans_num_bufs_ctrl =
+		v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_num_bufs, NULL);
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
@@ -1240,10 +1263,10 @@ static int vim2m_release(struct file *file)
 
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



