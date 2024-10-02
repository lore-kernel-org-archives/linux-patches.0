Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1351D0F58;
	Wed,  2 Oct 2024 14:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880050; cv=none; b=glMCSREvimBIqeNv50JEIr/g4WhKVIVvVgfU4wIivdQK+7NT7SHOWk/EXyZTtvocDVRsxYST/vgd2ntiA+qbWC5mKPuHku0KRyNzDVqvAg4I+L5UOmQX+IFqHzrCahzmY6g09ScDh4ZSO62yvpQ0XD9bDuTetM7lRLQL9W4FXUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880050; c=relaxed/simple;
	bh=P88pi96Ln9L591ZGpWYMaLOv9QmeE80SrBw0rVCawIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpuqKqKlWLZ5piqJNCEsGge1XhdS43fA6ckLQPT6QFNn/fLZDRbUQbgRVsCMlkn9THBXo/ElbCZG1Q7BoUofneeW85cdlDBZd8kTOuBgAJmvWzcn6ScC8+eqNV+yyWwLAoVkf3TdbygWHGC6R9yJrUT0wEDxVskRN/gvIuityuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+5xIe+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+5xIe+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751B4C4CEC2;
	Wed,  2 Oct 2024 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880049;
	bh=P88pi96Ln9L591ZGpWYMaLOv9QmeE80SrBw0rVCawIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+5xIe+92mlX8eVXOYDTa4hbXuUGGPgMAeRf0BUy/q0d8nndpCSv/defwR2gKg/7N
	 mUX0ijeYFtDVlVI9zbnwXbl9jtWqlCZJTNEpR/JAYsuTL8Rsz+711IDj9XVqGtGgHp
	 4BOUcq2k+W8Zfd/ussfTOnrV5MPFPDdct4IAPkZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/538] media: mediatek: vcodec: Fix H264 multi stateless decoder smatch warning
Date: Wed,  2 Oct 2024 14:58:58 +0200
Message-ID: <20241002125804.217036461@linuxfoundation.org>
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
index 0e741e0dc8bac..bb0ad93c6b789 100644
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



