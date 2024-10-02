Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087911D0164;
	Wed,  2 Oct 2024 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876328; cv=none; b=bWQWJwDN3bMOuNUjFuMRyUA5+E5FY0IIMOdEtcsmmC5EKyJ8slnvHYIVIZ2+N/fqm4u+LO2JBFFrucqiK+lx4T2bZjveMhvnV5ggHUQ9B3KZgKVeEmwJ473YFwfsLMJqvvbz/nBFa+jUe8CBNk62cIPtGuIWSqbpjAtj9BnWeiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876328; c=relaxed/simple;
	bh=Fh9RsQerJk2U5kOOHe1ecxsVkkGz1o1M048vKfwTiDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJMP1qqk9tUvJDJDTznDM1IZg5T9q46+grB5Tv35QJqKcxLEEd3lsQdV2hkPsGX91FW+D74pYEsdhXX/7EZvoaIGC5seyvMGbXhHRkOjt4dx51cQELWyyO1TqrkmIPe5gTPPqXHkZsEuWhAfp072Pmp6e9fh2Aei4OGJiO6kbi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfHOxhmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfHOxhmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E47C4CEC5;
	Wed,  2 Oct 2024 13:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876327;
	bh=Fh9RsQerJk2U5kOOHe1ecxsVkkGz1o1M048vKfwTiDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfHOxhmzD7AKIxhSzWBwjLHuS6rQVOxPAIJUkFxHWsuwU9yHXxQt7SqqBjDhntd0Q
	 baA0831qxw1JQgroPYmVa8USIJV4boTFbVmB3Vp1OByjTtxV7aEIFopnu646MRWYQu
	 DlihHYpB69wdvFBwR4HruifxKhRn6oaZoduQjEVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 389/695] media: mediatek: vcodec: Fix H264 stateless decoder smatch warning
Date: Wed,  2 Oct 2024 14:56:27 +0200
Message-ID: <20241002125837.982551376@linuxfoundation.org>
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
index 73d5cef33b2ab..1e1b32faac77b 100644
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



