Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D246ADD;
	Wed,  5 Mar 2025 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197258; cv=none; b=m7/sSaxljQ17dhm6nGbQuFCYHSLviUP3PDc/LFCgYI8UkhXwMCWaeYeN4ndcUltuQh25xB90s8ZL9/qjK6QUSDLCL95tR7SMIyOj1shwTWd1blPYzTjCDgSyF2HYkfWJ4wVWb041V+tGW8Y3fdWsO2KaGpUYiUe0iuGcBeaUc5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197258; c=relaxed/simple;
	bh=QDG2pqcRZhXvylYSjf9SnM/Ypn9dAlVPXyQtz3gC5Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjNdvMNI+jOT6+v96fnFJimnbnxd4mYgtnODlx9sBDgFDIysBV5l2fGSnHHlT2uO9kJUT11t8Xtzeu3+P3JJNVHWRu/Mdg3oQWlCvMxJ00sYoN2VoOPNuqkcEmxLkoG5zF7zRSLor3XCRSpfrbz/RHLpWejxXgDw7Js63QvgyT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJ1kd/Jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJ1kd/Jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C90AC4CED1;
	Wed,  5 Mar 2025 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197256;
	bh=QDG2pqcRZhXvylYSjf9SnM/Ypn9dAlVPXyQtz3gC5Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJ1kd/JwE5xV+A+QbpscUJb0ryRA3iPUqxtScipeILSPP6SDbQeBg630vxxSfzeq3
	 FpdD+r99GUVyGbf7JGGt8xd+8mn4LlZ/CIj+qvcoJg5KFDYXx985d5e4Z+1PHV3Xds
	 eXeZOa4qHImazLwz0TjPZ2I3Hu96C/LLqVuthZ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.1 093/176] media: mediatek: vcodec: Fix H264 multi stateless decoder smatch warning
Date: Wed,  5 Mar 2025 18:47:42 +0100
Message-ID: <20250305174509.197761681@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

commit 9be85491619f1953b8a29590ca630be571941ffa upstream.

Fix a smatch static checker warning on vdec_h264_req_multi_if.c.
Which leads to a kernel crash when fb is NULL.

Fixes: 397edc703a10 ("media: mediatek: vcodec: add h264 decoder driver for mt8186")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[ drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_multi_if.c
  is renamed from drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
  since 0934d3759615 ("media: mediatek: vcodec: separate decoder and encoder").
  The path is changed accordingly to apply the patch on 6.1.y. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
@@ -729,11 +729,16 @@ static int vdec_h264_slice_single_decode
 		return vpu_dec_reset(vpu);
 
 	fb = inst->ctx->dev->vdec_pdata->get_cap_buffer(inst->ctx);
+	if (!fb) {
+		mtk_vcodec_err(inst, "fb buffer is NULL");
+		return -ENOMEM;
+	}
+
 	src_buf_info = container_of(bs, struct mtk_video_dec_buf, bs_buffer);
 	dst_buf_info = container_of(fb, struct mtk_video_dec_buf, frame_buffer);
 
-	y_fb_dma = fb ? (u64)fb->base_y.dma_addr : 0;
-	c_fb_dma = fb ? (u64)fb->base_c.dma_addr : 0;
+	y_fb_dma = fb->base_y.dma_addr;
+	c_fb_dma = fb->base_c.dma_addr;
 	mtk_vcodec_debug(inst, "[h264-dec] [%d] y_dma=%llx c_dma=%llx",
 			 inst->ctx->decoded_frame_cnt, y_fb_dma, c_fb_dma);
 


