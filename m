Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D071257AFC;
	Tue, 25 Mar 2025 12:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905841; cv=none; b=PjIUMfdMzyyEUsk0TR7qeZaC0N77lhRzY5cW5fmrvOJTw/7zZ0tVdSqXvvDbb9reD+oPyjJqz0TrdRhUTDXarlJCfdyXKun6a3beNYD2g2+VNzsdFmrP6saO49vM+84sPCZ8d9Nr07bSPnLW3fyDLjCsgLsK0/0aAViqCmx3D9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905841; c=relaxed/simple;
	bh=I1YAwbTvJKussG3oObpbFkFsq7jYPXHUWtQSC8RC+M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvWyl7o5GjY4KUtbyII1O4X5G7cAb6/5fcpTAgP0GT3Ggorn7i3EWuxJmktx2SAhF2mDDHcN4zDuSGIE4Q/awVuep8BVF5kigy/gZmXDVQrKGmIMsB+QUilN2/4DLI+xqxe+CPnWi598FMzZqgrA/vAcoDX7ouTxp3qu9GxGc3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDb8VXWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDb8VXWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A57C4CEE4;
	Tue, 25 Mar 2025 12:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905840;
	bh=I1YAwbTvJKussG3oObpbFkFsq7jYPXHUWtQSC8RC+M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDb8VXWyaRYwBdj/5niz1myhsPw5KhVjQhCKp7m7LLjEJUxOOnwZDfaYyJxdIE65m
	 nk/fhLYqPZRHa6RAK4zJ9pA3Vj34ukGxra9sARTCQh4na7FkrbM0TPTL9dylOXevZA
	 itwW9Hio+NeP8Nxm16CIHHkCFk7fD0exJRCy9F2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 192/198] media: mediatek: vcodec: Fix VP8 stateless decoder smatch warning
Date: Tue, 25 Mar 2025 08:22:34 -0400
Message-ID: <20250325122201.687601813@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunfei Dong <yunfei.dong@mediatek.com>

commit b113bc7c0e83b32f4dd2d291a2b6c4803e0a2c44 upstream.

Fix a smatch static checker warning on vdec_vp8_req_if.c.
Which leads to a kernel crash when fb is NULL.

Fixes: 7a7ae26fd458 ("media: mediatek: vcodec: support stateless VP8 decoding")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/vdec/vdec_vp8_req_if.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/mediatek/vcodec/vdec/vdec_vp8_req_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec/vdec_vp8_req_if.c
@@ -336,14 +336,18 @@ static int vdec_vp8_slice_decode(void *h
 	src_buf_info = container_of(bs, struct mtk_video_dec_buf, bs_buffer);
 
 	fb = inst->ctx->dev->vdec_pdata->get_cap_buffer(inst->ctx);
-	dst_buf_info = container_of(fb, struct mtk_video_dec_buf, frame_buffer);
+	if (!fb) {
+		mtk_vcodec_err(inst, "fb buffer is NULL");
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


