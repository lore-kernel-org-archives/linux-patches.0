Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053604;
	b=xRWKer0XhiZ2/D/3W9L1imnMuWS6rrk6dK5+Az5Zl8iwyNoeiCTzECwJCGIyuGugFvVC
	 3qwGqUynSZq5CJCdxZsncmyMaQdt4Op73M2QdG3e5pBU2XPPfolit9cDW+XX1/5FIp2Ma
	 5Ep7neRnQ8RGRa8rmzt7+I5Liydo3FKAD3UVx7bgdI0axujaEuY0Fx8YAaCTWrF+UCFoj
	 RqAaVXvT1oUes8Z3zPjC0uwi64ONjZEJxtJo+UbYxydLrMd77HcYRWYnH2QqERC3PVQIs
	 aemV6yztvhPzm7LAgxoDNxP6YL0Lnz4Gpv7Ol+sBysHzrLou2g8CeB3g/dUe/zZ8BRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c16NuBl2w48aOcHmEcvttehluGSCP02KfrLlxnfHaG0=;
	b=wvXWaL+xRnon1J0iJVR/wxKAPfJdMqLMspIT6Delzzq1aIh3YCtMyPFNEocpJciSCSL7
	 UGkZkluUkaXLSOclcUONewkUyd8y4J68gwY3cotxR0OJ7rBZwjc9x88qLvsQOKCA7R826
	 qQMRScIsEC+YwA/cT0T4rtz25WJioMMf68FinhpYVIQXcSqXWsnFTqihZ2VZGZDJXqkPf
	 qB7JJ/PiT1PQ6+jrH1ZRm0Wo15yFovhG8rBsw3zKZXqlDBDOxNE+LcCse1+k+vDrT8VYq
	 Ac1xJjzjkAfpEzIdjAbbQgO2VMAvYzr9KGFJcqKCuTuquoxUUjab5cjIxXu+/hQ/4Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZaxRdIEh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395C8606A325;
	Thu, 19 Nov 2026 02:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZaxRdIEh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1921F000C4;
	Thu, 19 Nov 2026 02:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053604;
	bh=c16NuBl2w48aOcHmEcvttehluGSCP02KfrLlxnfHaG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaxRdIEhHklRaqO40dMz8aW29huHoN8xKBnglEgtcOKZ5ESdyHFxhYtp+ZwLMjo8p
	 e67BQuAQDUf/CYGpCu7yBieUdZoiVrvDccQv1d3M+8lNpKWCGpxVcYoOQVGC2cs93v
	 V+oetBqzu0xHs8WUnZmNvF7lp5ozhGqZpHT9SgHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0976/2214] media: imx-jpeg: finish the job on device_run() error paths
Date: Wed, 18 Nov 2026 15:44:12 +0100
Message-ID: <20261118150051.303450585@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 30b35fd2b999e1b8c26f8191d974d20c8848d2d6 ]

mxc_jpeg_device_run() returns early through a shared "end" label on several
error paths (no free slot, mxc_jpeg_alloc_slot_data() failure, or missing
buffers or queue data), and none of them calls v4l2_m2m_job_finish().
Since the delayed work is queued only after the hardware is started, those
paths neither finish the job directly nor queue timeout work that could
finish it later. The job is left with TRANS_RUNNING set, so the
wait_event() in v4l2_m2m_cancel_job() (reached from v4l2_m2m_ctx_release()
at close) waits indefinitely and the close hangs.

mxc_jpeg_alloc_slot_data() uses dma_alloc_coherent(), so the failure path
is reachable under memory pressure.

Return the src/dst buffers with VB2_BUF_STATE_ERROR and call
v4l2_m2m_job_finish() on those paths: paths that have buffers use a
"buf_finish" label; the no-buffer path uses "job_finish" directly. This
mirrors the existing jpeg_parse_error path.

This bug was found by static analysis.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Adjusted mxc_jpeg_device_run() context to account for missing timeout work scheduling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 2ab03444f742a..45097405bdc9f 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -999,15 +999,15 @@ static void mxc_jpeg_device_run(void *priv)
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	if (!src_buf || !dst_buf) {
 		dev_err(dev, "Null src or dst buf\n");
-		goto end;
+		goto job_finish;
 	}
 
 	q_data_cap = mxc_jpeg_get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (!q_data_cap)
-		goto end;
+		goto buf_finish;
 	q_data_out = mxc_jpeg_get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (!q_data_out)
-		goto end;
+		goto buf_finish;
 	src_buf->sequence = q_data_out->sequence++;
 	dst_buf->sequence = q_data_cap->sequence++;
 
@@ -1050,11 +1050,11 @@ static void mxc_jpeg_device_run(void *priv)
 	ctx->slot = mxc_get_free_slot(jpeg->slot_data, MXC_MAX_SLOTS);
 	if (ctx->slot >= MXC_MAX_SLOTS) {
 		dev_err(dev, "No more free slots\n");
-		goto end;
+		goto buf_finish;
 	}
 	if (!mxc_jpeg_alloc_slot_data(jpeg, ctx->slot)) {
 		dev_err(dev, "Cannot allocate slot data\n");
-		goto end;
+		goto buf_finish;
 	}
 
 	mxc_jpeg_enable_slot(reg, ctx->slot);
@@ -1073,8 +1073,17 @@ static void mxc_jpeg_device_run(void *priv)
 					 &src_buf->vb2_buf, &dst_buf->vb2_buf);
 		mxc_jpeg_dec_mode_go(dev, reg);
 	}
-end:
+
 	spin_unlock_irqrestore(&ctx->mxc_jpeg->hw_lock, flags);
+	return;
+buf_finish:
+	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
+	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
+job_finish:
+	spin_unlock_irqrestore(&ctx->mxc_jpeg->hw_lock, flags);
+	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
 }
 
 static int mxc_jpeg_decoder_cmd(struct file *file, void *priv,
-- 
2.53.0



