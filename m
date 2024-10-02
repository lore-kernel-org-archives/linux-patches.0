Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB2D1D1F4E;
	Wed,  2 Oct 2024 14:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878256; cv=none; b=oHptHe+NBfXt2maNctFAi1CtpKQp139qAk0fmko0VUBFhjiNg8iFyuk0VyOq2GBbSa35tOKQ7HIxSMdJVSjzWiXPmQJqiizvLp0LVSmGgkBkFD0/cuMEia3rSMHfQzc5EuJtVJTTrLr6jkHxpbhBJaDk/TshnU+HIi6yGn7QeXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878256; c=relaxed/simple;
	bh=2//gNeVVE4yE7zUgTqNt90ny2NcPiuoOZtSGugwGUNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8AWOELbjSr+eXeOTNBaCpzvLqYMVsI9mAiwWaiUTBGlEvHXdzhVtfxI3/lcr5e4JR6OWHaWKALex5e4VfpphZsjlEPaQcn30bziBQhz6GTuODnfrTPbD/lzdNOSV9xiXYqB+/j72OossKthjAChs7rw6U8AEN6LIj98uEUW2WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKoXaDGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKoXaDGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C84C4CEC2;
	Wed,  2 Oct 2024 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878256;
	bh=2//gNeVVE4yE7zUgTqNt90ny2NcPiuoOZtSGugwGUNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKoXaDGAk18G4uvwXwxNdUcyVAx1ZQbb5KeiZ9GFn0GxjEi3ubZCzA45bFV16Bm8R
	 1Ji11hPAkp+iqARPmeazncb7t38li5tZ26yvSGpotkT65Dr7ucnfNDaAOgNKqx3hGl
	 isXFdJUClDhKYTdReFHAl9X2ebvVDWYeQaxg1JnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 352/634] media: mediatek: vcodec: Fix H264 multi stateless decoder smatch warning
Date: Wed,  2 Oct 2024 14:57:32 +0200
Message-ID: <20241002125824.992062847@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 9be85491619f1953b8a29590ca630be571941ffa ]

Fix a smatch static checker warning on vdec_h264_req_multi_if.c.
Which leads to a kernel crash when fb is NULL.

Fixes: 397edc703a10 ("media: mediatek: vcodec: add h264 decoder driver for mt8186")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vcodec/decoder/vdec/vdec_h264_req_multi_if.c         | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_multi_if.c b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_multi_if.c
index 2d4611e7fa0b2..1ed0ccec56655 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_multi_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_multi_if.c
@@ -724,11 +724,16 @@ static int vdec_h264_slice_single_decode(void *h_vdec, struct mtk_vcodec_mem *bs
 		return vpu_dec_reset(vpu);
 
 	fb = inst->ctx->dev->vdec_pdata->get_cap_buffer(inst->ctx);
+	if (!fb) {
+		mtk_vdec_err(inst->ctx, "fb buffer is NULL");
+		return -ENOMEM;
+	}
+
 	src_buf_info = container_of(bs, struct mtk_video_dec_buf, bs_buffer);
 	dst_buf_info = container_of(fb, struct mtk_video_dec_buf, frame_buffer);
 
-	y_fb_dma = fb ? (u64)fb->base_y.dma_addr : 0;
-	c_fb_dma = fb ? (u64)fb->base_c.dma_addr : 0;
+	y_fb_dma = fb->base_y.dma_addr;
+	c_fb_dma = fb->base_c.dma_addr;
 	mtk_vdec_debug(inst->ctx, "[h264-dec] [%d] y_dma=%llx c_dma=%llx",
 		       inst->ctx->decoded_frame_cnt, y_fb_dma, c_fb_dma);
 
-- 
2.43.0



