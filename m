Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9CE1D04AD;
	Wed,  2 Oct 2024 13:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876295; cv=none; b=Uqe9QTLEJb5nOzUUH5tPE8iafAfnXiUa7tDUA32aYZCYPTnKeDRNEtaaK8VFcvuyEyr+sV+e5MbvTHy5YzAHkBxaSPJ9NooEFWwLlQJq8Z06kqs6yrgK68dpgH3qwrvYcXHkwsQi8Z/IoWhf/AgMHNE9DeI9BvRv27+TpR9Cr14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876295; c=relaxed/simple;
	bh=AKRkH7563Ozcqx/Y8F7FvcHM52hzOwjyOduQs/19X94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDBvNa3b/d/3b07zmolnJIhjSX8lZdfcdTDm8Xhyhlhn+shtD+w8DDIq9sWXYbPd7VGx7giNl+iYEqkYbl1qBdrEQ7maWYx7zr2n9DZr9kgx5b41toVO7z82HQmEn2oGjiJxW7Qsq56bDVbcPUNjkipw+aBe+H9Wu6UCs9kDPOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5xXtNSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5xXtNSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5893AC4CEC5;
	Wed,  2 Oct 2024 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876295;
	bh=AKRkH7563Ozcqx/Y8F7FvcHM52hzOwjyOduQs/19X94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5xXtNSC0lmtzMXztd1iHhRTOCnsGNO6c9peib1qkPwiF4sv6YI0JGk0oxqe9L6gz
	 mrdcCn5ayyItmx0v0ZrmOc7RnN/m8hBK68eLUiurfz/+A5BJEc9VKpp31iG/Z4C8ku
	 WvbctU20vmXDuW8AhmVLYlS36lY33FD6eedx+Jkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 388/695] media: mediatek: vcodec: Fix VP8 stateless decoder smatch warning
Date: Wed,  2 Oct 2024 14:56:26 +0200
Message-ID: <20241002125837.941246771@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index e27e728f392e6..232ef3bd246a3 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp8_req_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp8_req_if.c
@@ -334,14 +334,18 @@ static int vdec_vp8_slice_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
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



