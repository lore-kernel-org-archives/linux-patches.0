Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA11D097B;
	Wed,  2 Oct 2024 13:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876392; cv=none; b=EWt8t/znGESugSS3l5XqJUnoaOpjmXuybImp+Pv46xvvaGLzhZHIywLAum3AHVZGVUQlrts+Gvf88l+cZMKf2a/7xP5u4qRQ9QPsptq/MmghJJ2BiviuIHLuVQCFehHEZt4kIvoyOWa1CQVdzLFXJtiwo/PbWRcBg7PQa6tlTUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876392; c=relaxed/simple;
	bh=vGNvC1yQhhLvcNtXJ+b9q+YyG1a1Rt2vt2vLUp9IVN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzhLlPHa8wpq4YP/1M+9C5lI/uFjUQJmIuXrEC9z8J2u4I5s4Nuf+QAT75UvWDXS/eJStFFzKXP+ZoMUi5lL7+cpUpRuHicdWgco7wDJVSKb9zhQKQuTRQFDtUdcDaD/B9BBwZFN3ln+0a6w54+dkt/R9m39kzNwouViTBpNZaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm4PTpK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm4PTpK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B96C4CEC5;
	Wed,  2 Oct 2024 13:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876392;
	bh=vGNvC1yQhhLvcNtXJ+b9q+YyG1a1Rt2vt2vLUp9IVN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm4PTpK6BY+OZUnwYwG+2cYHP918fhOzb33UThDXFhd6nGhksuHygAXzpjqQGgh+f
	 KdQiuIQoSri83n9qaTDigwD4wakTQQCU8xJhx84AbMVZ29fU5LxhpKOaGf6L9RM4Wd
	 +r59n6q1U5TQHQ0tnryj1FN6I5kp86PtjN6hCX8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 387/695] media: mediatek: vcodec: Fix H264 multi stateless decoder smatch warning
Date: Wed,  2 Oct 2024 14:56:25 +0200
Message-ID: <20241002125837.902987456@linuxfoundation.org>
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



