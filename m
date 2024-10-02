Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE51198A1A;
	Wed,  2 Oct 2024 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880061; cv=none; b=ET8deWOUwah8hT4TiGd+lHYQGlnFJE0RsSOWdpHMC4QoZwfBGKIkdG22Q0WdWan3u+wfR+AwtZDzbk+SpVY0Iw8YIzK+arqTfQMwTn1BUrGFbEh/oobvGLASjAn+kkIhkW4Dj5ZK3e3lXcx7kPyR6nQ79Kt0bVSPQGTzd+eRcbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880061; c=relaxed/simple;
	bh=UeV7fbUZEwdp/oNhN3AnDZdQQRK61njS4K5iN+ccoe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePPDqZPJRtGAPghyyEtPn1kFd/lk6wiwG4Grs1Fp/jXXAdUzZw1dNJCRJz2ZTvkQ/pkY91Z1uf5eNmIqII5M3ujRXdiUQAfFFTTK6jqoggtmFoQaEwH6VPJampDXctmdlzFUnxZgSruEhys9VzZMI26Hq70PqiJvN2slUHNPTLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dlt6TDvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dlt6TDvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08677C4CEC2;
	Wed,  2 Oct 2024 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880061;
	bh=UeV7fbUZEwdp/oNhN3AnDZdQQRK61njS4K5iN+ccoe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dlt6TDvqbGbVbrfo73BtDlUWZ29G+nPHPaL7zFMAidazp32ID0gA/aUAAJmqHm6BI
	 41SMwplSUAiTrhoIZUOSmHiBeIjFILVhsZdazeqFrO6PM1zjC73oJPa9ySpj7y1Qjq
	 zwSGJ1Gau8/y2d36LHYWho9S6kj8uTM5uR3BOn7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/538] media: mediatek: vcodec: Fix VP8 stateless decoder smatch warning
Date: Wed,  2 Oct 2024 14:58:59 +0200
Message-ID: <20241002125804.256391369@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit b113bc7c0e83b32f4dd2d291a2b6c4803e0a2c44 ]

Fix a smatch static checker warning on vdec_vp8_req_if.c.
Which leads to a kernel crash when fb is NULL.

Fixes: 7a7ae26fd458 ("media: mediatek: vcodec: support stateless VP8 decoding")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/decoder/vdec/vdec_vp8_req_if.c     | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp8_req_if.c b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp8_req_if.c
index f64b21c071696..86b93055f1633 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp8_req_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp8_req_if.c
@@ -335,14 +335,18 @@ static int vdec_vp8_slice_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 	src_buf_info = container_of(bs, struct mtk_video_dec_buf, bs_buffer);
 
 	fb = inst->ctx->dev->vdec_pdata->get_cap_buffer(inst->ctx);
-	dst_buf_info = container_of(fb, struct mtk_video_dec_buf, frame_buffer);
+	if (!fb) {
+		mtk_vdec_err(inst->ctx, "fb buffer is NULL");
+		return -ENOMEM;
+	}
 
-	y_fb_dma = fb ? (u64)fb->base_y.dma_addr : 0;
+	dst_buf_info = container_of(fb, struct mtk_video_dec_buf, frame_buffer);
+	y_fb_dma = fb->base_y.dma_addr;
 	if (inst->ctx->q_data[MTK_Q_DATA_DST].fmt->num_planes == 1)
 		c_fb_dma = y_fb_dma +
 			inst->ctx->picinfo.buf_w * inst->ctx->picinfo.buf_h;
 	else
-		c_fb_dma = fb ? (u64)fb->base_c.dma_addr : 0;
+		c_fb_dma = fb->base_c.dma_addr;
 
 	inst->vsi->dec.bs_dma = (u64)bs->dma_addr;
 	inst->vsi->dec.bs_sz = bs->size;
-- 
2.43.0



