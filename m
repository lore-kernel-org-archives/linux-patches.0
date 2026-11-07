Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061891;
	b=xbkR/SPYsLsutXssZUWOJEHMJldUymoo/AeUL79D+ucM2MsVNDSD9yHHmtZVVTJi1Y5i
	 RJG1gtW8ZRMYq43ufWLsmdBHOVhTByim06DeY3zU/t38bInKxfhOB123P2DU7vp/PuvsC
	 DuodcRl9Cr7Ojx23+TqpffKt+O7HQwlOZd4hH4WKc95dbga8hYYb0kN+HQPIHbtYIkg9w
	 kTWWpHv5+izyqxxH9fRS20X8N8UHBblEOVZ44C1AZJO/TjVx9DUQ/GW/vR+wSaqPjPzfa
	 uHSj0LZva044seNhLf1341o+WENcofGKj+dVERfKJEuZr1mTpNhFGWZDckrTAhaYkUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BZA6jnvvgv4VGQRfSktYSGcjNUzY7mnNY1SGitFh0Xc=;
	b=0kDdZvPcFcifwXEKEcGwOGTSzwpsaZfa+5qYojLwf1X9aXPEFDC1yW0GWDQZZK7HJgV3
	 AOWfDJGEcNqmE2bHwc3ZwBu3h3OW+4sKT1pYDUZ9iNBjbgK/CedZ2kA+345jtEu+z22Kv
	 zYOm8Ow/AOz9gbta9cqb69loHnmNQ50mvnLoh7CPxj4atTRwe5Rai25PS4C2T3NqgZCHv
	 prH6QMcrAE0zhOl1dZwZdIh1bVyI9R+EoMkeD1/zTSfLL9B8LBo2CSRAvr0mxdXHmTN61
	 TqQJsMObE05Vi/EdSms9b53IFtqNiIuZga4opZ01PjRU6ElohRaOyjn1KfLCeVTgPUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3RI9KoS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D6D606A326;
	Sat,  7 Nov 2026 14:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3RI9KoS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863491F0089F;
	Sat,  7 Nov 2026 14:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061890;
	bh=BZA6jnvvgv4VGQRfSktYSGcjNUzY7mnNY1SGitFh0Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3RI9KoSbrmj1trrW9K2UYKrqR1brzOApxNdBesZTCLVGlfNOdnWWCppNoq1nv3HQ
	 A9kiDXEXLtAqxdkbORMzNaITSQ6m23SyO1ogYHQAXZLmpcefGWME8gL6jKiHJ0aBH6
	 5t+zSI25PsTO/72US3BbRa8+xXZwZX9tCck1f1Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0901/1536] media: imx-jpeg: finish the job on device_run() error paths
Date: Sat,  7 Nov 2026 08:48:37 -0500
Message-ID: <20261107135022.939792980@linuxfoundation.org>
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
index 097934cd2ee37..f28ae4080fff0 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1450,15 +1450,15 @@ static void mxc_jpeg_device_run(void *priv)
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
 
@@ -1496,11 +1496,11 @@ static void mxc_jpeg_device_run(void *priv)
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
@@ -1522,8 +1522,17 @@ static void mxc_jpeg_device_run(void *priv)
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



