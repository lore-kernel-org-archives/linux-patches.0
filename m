Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798CF198A1A;
	Wed,  2 Oct 2024 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880064; cv=none; b=k9qRZU2BKZeOdYQh7jwsgrdmCzK+Avqubovg/vSiYA9i1l6xDeLOxJGouA+/+WvBPBrnaFp2otlAUOYiyMu19Pa06YyKfv6YlULjlutr/toNdY+/p9mgRJEYNt+oSJCLdoztvupU0+SiPwqrVSMQr6iaMI+6VJUOBfqYec8VPsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880064; c=relaxed/simple;
	bh=pObm2nkDoeSo1Tchkjn4QQaZwu2vwowffcRzc4nviHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ituhpdJqkMuHjERqvmPjLbjjRrg3iaPwPTPgzohAbeg499j4h3hcw9hf30J4v+aY8nH+CVKh1m628ukQAoON6qLu/UtPsNW9b4H6nOMmD0wVAkWv/mu5chibDuPh1Z9E5jomm3gTak5Ej5nJU+plHSzAPeVTCdMosqK4nCGdL5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOp9grlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOp9grlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED889C4CEC2;
	Wed,  2 Oct 2024 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880064;
	bh=pObm2nkDoeSo1Tchkjn4QQaZwu2vwowffcRzc4nviHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOp9grlD5AByv1Sp1LaGNTGf2VvcqqYEj19vO+6l4mWI2ROpRYr4/GP2p0oSoPrYN
	 rn+MfMqS17Dki4EdOUmrHlz54cB0eH0ort0e6wZJN1wQPADplhZnPlU5NroPNQMPxl
	 Xs8jruacbGGSulLzcRwrQWzL+WIa40JeI0LdWOwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/538] media: mediatek: vcodec: Fix H264 stateless decoder smatch warning
Date: Wed,  2 Oct 2024 14:59:00 +0200
Message-ID: <20241002125804.297220696@linuxfoundation.org>
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

[ Upstream commit 7878d3a385efab560dce793b595447867fb163f2 ]

Fix a smatch static checker warning on vdec_h264_req_if.c.
Which leads to a kernel crash when fb is NULL.

Fixes: 06fa5f757dc5 ("media: mtk-vcodec: vdec: support stateless H.264 decoding")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/decoder/vdec/vdec_h264_req_if.c      | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_if.c b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_if.c
index 5600f1df653d2..b55fbd6a8a669 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_h264_req_if.c
@@ -347,11 +347,16 @@ static int vdec_h264_slice_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
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
 
 	mtk_vdec_debug(inst->ctx, "+ [%d] FB y_dma=%llx c_dma=%llx va=%p",
 		       inst->num_nalu, y_fb_dma, c_fb_dma, fb);
-- 
2.43.0



