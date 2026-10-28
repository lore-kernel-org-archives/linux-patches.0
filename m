Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213889;
	b=GdRMw601R0Aq8cYl+RLj5TFFAI3LDMOa3f1kwzpbvQ6Jk+xLz4XCgyXaozlBg6vW99od
	 GMfvOmFzO6vpEjl+ywjZuC2E/wKFF+qGGAe8AD030p6AXzzaCkLCY0Xdijjc0+fA850Tj
	 SERgbx2/d09ldVJNLrFMIxvmogWtn2mlgs1JG5kTZfNDue4uyTirU8OYJF90HgkYYRBqV
	 AInVUci+unW9SQaVMMHP4Gk4LaTAhsH+GfVjtnwi+CQcvYZmgpRZgvgyN7APx1fIsb1v1
	 OcyJ20aZKLz5KAKeGYRSvr3xeu/3EZveYuhA+bt0oPn7mt5pulUlVyh4bpevbdW4xBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kPtEoF+4tKFS4CfwqmkjC9R6YDQMnfLDO7Dwoc2El+s=;
	b=ulrBKtnvCctWAlOi3Vz10lju8H9qI38Wpb4u79I1zZo90Ixyf7DRDaZtp99bp+12KJ4R
	 XEw2iI8wjzNfJa9sJ5w66SpvZeecvLGIMfIIrR4q9NfVmtJhjnfhcWgoHLJfrpqK9/6hq
	 85avqzCHq+FBcNN3iOmgk6hQaWZqSgtGJlgq9NZ6CvBi3P1R5S+Lbq2jmXCsXGV2UURJA
	 kEcvIJYNhCRMJDnyebdG4i3eTEaIijdCreBLHCgrra1AJLAKYf/2VRQscjyufTTFIHcAt
	 +WVwp7WA4woK5GSUyQ6ALJVySBpTETo2b87EBP3eTvaMrYCcq/NWfHaT1RLs59N0MtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TvLaHTD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC76606A31A;
	Wed, 28 Oct 2026 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TvLaHTD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B661F01825;
	Wed, 28 Oct 2026 18:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213889;
	bh=kPtEoF+4tKFS4CfwqmkjC9R6YDQMnfLDO7Dwoc2El+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TvLaHTDd1VFgKnoWeXxA9TA3oN2Rc/dQGQXm6k8b/dJzZbg0uux/oKH9PscKqeCT
	 LNUIuK/BrpVYmaO+TMsFRye92rLryjy0JaHPgUDk+6hd2tJZXZvxk9RxumI9KLkbn0
	 gqPKT6EN3S6eesCCIxjdLaBzbmH0GHNPmkhjYocw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0663/1887] media: mediatek: vcodec: Fix H264 stateless decoder smatch warning
Date: Wed, 28 Oct 2026 17:45:59 +0100
Message-ID: <20261028170514.499285257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 .../platform/mediatek/vcodec/vdec/vdec_h264_req_if.c     | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_if.c b/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_if.c
index 4bc05ab5afea0..d6fa1e249dc70 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_if.c
@@ -352,11 +352,16 @@ static int vdec_h264_slice_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
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
 
 	mtk_vcodec_debug(inst, "+ [%d] FB y_dma=%llx c_dma=%llx va=%p",
 			 inst->num_nalu, y_fb_dma, c_fb_dma, fb);
-- 
2.53.0



