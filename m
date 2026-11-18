Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044857;
	b=DvE/aAXsdEqwejZKmEDmlDoOpfscve6U9Hgfz6pFYQzct0gzdwEQpEgP5oQcQYywlz0H
	 gPAVOMzpZLJ+jZ78HmsYDhB3N6IkDRo7akur+f7wNaG36S5Q0F6As0SIQ9/XzR7/5TKV3
	 4LzXJpfBi370B8QEqhEEv7m6lq0vTOKTaUVHcgIXruPEdbeY3hRymQZIAMU0YMhnTi+B0
	 Kn7KiZNUGRuDOaMldl+IY8jHaiDicjj0cKP4UGlYZT3yntsgbUFb1s3EcUt+kSY7eagXe
	 hfD4RK5ppw/awtxWbeBjNr/XBsm99Lmd0GJZHzsRb8NSf1uIVSGI0dg4jHxqDQbr0Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hH28so9qm6xrJN5/OD4X1J8LdDmjrwu9KU6t4hUuYCI=;
	b=ybH/J+OFc3vK/GVMpFrzBbgVmIjJDcfug0Ur9sQjUyTM5C7Il9Mso1d/TKekDJSnnMAK
	 CMFubkjlQCFJutEv6Qe4eTdXFm4IGc0DLZb5cZ62/RE3D/wk9s6jqg8gu8kSbU5UesOux
	 APGk9o/QcTK7ITGgX3KEYpZaOhDaU0gIE7Ol18mFbeAN5c2h3hcNfTuRYd/epQzyLJO8u
	 swk1bFR5W21PqgSyOYU6ntO9DhEdmCnaUf2aVl2YFxkNcqicUZzZGyQJeg3yy5oeSWMdB
	 5Cxi7gbF+UcxXNLiErrhsM/tEguGS3HlmIvXoWJtGa6qBXCp/C8eaexbKy7HWZgqytQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llRvK+uZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3D2606A9D5;
	Wed, 18 Nov 2026 23:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llRvK+uZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE021F000C4;
	Wed, 18 Nov 2026 23:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044857;
	bh=hH28so9qm6xrJN5/OD4X1J8LdDmjrwu9KU6t4hUuYCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llRvK+uZMVTiUuKwxecnfDen2mo7ugWpEiXI6VlFk/yRvLjhZ6YUJJ/F3uGbhgekS
	 ufECGIzAA/I7EqceuTLh2hp/yl6O8MWrOvqatIdSNGsZ9gnCQb707zt8wP7vnn1tsv
	 Kbaq3VPL0G4/X825aHGdf9ohXgdV5ZdmyxeFEbAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0715/2857] media: imx-jpeg: finish the job on device_run() error paths
Date: Wed, 18 Nov 2026 15:29:09 +0100
Message-ID: <20261118150227.291737337@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 25f2223901269..6e2a8ccaac0ce 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1055,15 +1055,15 @@ static void mxc_jpeg_device_run(void *priv)
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
 
@@ -1101,11 +1101,11 @@ static void mxc_jpeg_device_run(void *priv)
 	ctx->slot = mxc_get_free_slot(&jpeg->slot_data);
 	if (ctx->slot < 0) {
 		dev_err(dev, "No more free slots\n");
-		goto end;
+		goto buf_finish;
 	}
 	if (!mxc_jpeg_alloc_slot_data(jpeg)) {
 		dev_err(dev, "Cannot allocate slot data\n");
-		goto end;
+		goto buf_finish;
 	}
 
 	mxc_jpeg_enable_slot(reg, ctx->slot);
@@ -1125,8 +1125,17 @@ static void mxc_jpeg_device_run(void *priv)
 		mxc_jpeg_dec_mode_go(dev, reg);
 	}
 	schedule_delayed_work(&ctx->task_timer, msecs_to_jiffies(hw_timeout));
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



