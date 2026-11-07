Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062194;
	b=ECurmjSh5IooHXHfzpFHjEKg3OwqXsAvRQ1rSnjE/qjf8/HNma0hgHCPOaqqVhY/cXw8
	 2qT1omcw+lerrVShTI76WyX2uXRSnIUBz0LhbMJlVV31/2CXFsB2YpPV3+6R5Dd7CBfx8
	 5BLBb/MIXPh8D8ODMx3Un7YvAzlBgZULtOeOone5CtNDi3U0mkDc4hlCTN5vZeUOgs07h
	 lBowQyJVN0e5u8O7DouV3JWGaMZ5Dgt9PP3lSDFgXzdCZ4ky8fWNcsAn9JzSLkiCWVfIk
	 pzhoeaKmiQuAMquH6BfZS1GFandNWWgfSd+CqJ4NHe4Mqgkh9KDIdd2v3JvxK63pqAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z7S+lv5+l4Aa9YEa8QPqaZ5SMvyxjKaMqCfnA8AA3+w=;
	b=K4G830MkXbWoS9pmeCutlhTOWbv7bewfL2orj64CCg58WC/kTqRlo5Zl/fY5Ax+a3L6g
	 2CsfMOUztoYHOi9HkSBlVCxJ/dOqZ0X/yUhSRTt9KfqkUBhX02SdLIyVfUNR+duy4UEEy
	 hq25oefwiddSVzHzN2I5RaC0xAHA8MAfHlppLdpK3Vz2nedMBTmyJARUiL4qiXyXhjOpm
	 WkRaFBI1WdHVdlBET8itTzGTUkckdNXrV22AySu4KrCPlkwHnggmlcRv9t04suFJxrzsj
	 ZEZ+DwItx44q8NkO87n25IZ+jea/T8dNANLXrzZtTz1HPiuYcA/ptJBDVQ5fB366zVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EaIlyRCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745E8606A326;
	Sat,  7 Nov 2026 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EaIlyRCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226141F008A3;
	Sat,  7 Nov 2026 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062194;
	bh=z7S+lv5+l4Aa9YEa8QPqaZ5SMvyxjKaMqCfnA8AA3+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaIlyRCQ1+VOZQdE132AGLpkG8uG4a3aKSh+FAu7PYIQRD52qkclqbCWYIH9amiLg
	 Wsvj+ykCZitLvfB7YpavPX9hHAVZwHUNuar+c4TLtB9aEQuMkCgz9ucwUbj/R+LDzP
	 Zc0c3yue9ULiKI9J3jqOJor+x8Y9H8Q1WQg/+yVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1150/1536] media: verisilicon: rockchip: Fix leaks in init
Date: Sat,  7 Nov 2026 08:52:46 -0500
Message-ID: <20261107135030.025073459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 96f6b5e2295996a9e2dd1e2382d3872f98cbb554 ]

If one of the dma_alloc_coherent in the init function fails then
the previously allocated ones leak.

Fix by freeing them in the error path.

Fixes: 727a400686a2 ("media: verisilicon: Add Rockchip AV1 decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c  | 68 +++++++++++++++----
 1 file changed, 55 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
index 0c661747dcd67..0a6f611fa53a5 100644
--- a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
+++ b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
@@ -369,6 +369,7 @@ void rockchip_vpu981_av1_dec_exit(struct hantro_ctx *ctx)
 
 int rockchip_vpu981_av1_dec_init(struct hantro_ctx *ctx)
 {
+	int ret = 0;
 	struct hantro_dev *vpu = ctx->dev;
 	struct hantro_av1_dec_hw_ctx *av1_dec = &ctx->av1_dec;
 
@@ -377,39 +378,54 @@ int rockchip_vpu981_av1_dec_init(struct hantro_ctx *ctx)
 	av1_dec->global_model.cpu = dma_alloc_coherent(vpu->dev, GLOBAL_MODEL_SIZE,
 						       &av1_dec->global_model.dma,
 						       GFP_KERNEL);
-	if (!av1_dec->global_model.cpu)
-		return -ENOMEM;
+	if (!av1_dec->global_model.cpu) {
+		ret = -ENOMEM;
+		goto global_model_cpu_err;
+	}
+
 	av1_dec->global_model.size = GLOBAL_MODEL_SIZE;
 
 	av1_dec->tile_info.cpu = dma_alloc_coherent(vpu->dev, AV1_TILE_INFO_SIZE,
 						    &av1_dec->tile_info.dma,
 						    GFP_KERNEL);
-	if (!av1_dec->tile_info.cpu)
-		return -ENOMEM;
+	if (!av1_dec->tile_info.cpu) {
+		ret = -ENOMEM;
+		goto tile_info_cpu_err;
+	}
+
 	av1_dec->tile_info.size = AV1_TILE_INFO_SIZE;
 
 	av1_dec->film_grain.cpu = dma_alloc_coherent(vpu->dev,
 						     ALIGN(sizeof(struct rockchip_av1_film_grain), 2048),
 						     &av1_dec->film_grain.dma,
 						     GFP_KERNEL);
-	if (!av1_dec->film_grain.cpu)
-		return -ENOMEM;
+	if (!av1_dec->film_grain.cpu) {
+		ret = -ENOMEM;
+		goto film_grain_cpu_err;
+	}
+
 	av1_dec->film_grain.size = ALIGN(sizeof(struct rockchip_av1_film_grain), 2048);
 
 	av1_dec->prob_tbl.cpu = dma_alloc_coherent(vpu->dev,
 						   ALIGN(sizeof(struct av1cdfs), 2048),
 						   &av1_dec->prob_tbl.dma,
 						   GFP_KERNEL);
-	if (!av1_dec->prob_tbl.cpu)
-		return -ENOMEM;
+	if (!av1_dec->prob_tbl.cpu) {
+		ret = -ENOMEM;
+		goto prob_tbl_cpu_err;
+	}
+
 	av1_dec->prob_tbl.size = ALIGN(sizeof(struct av1cdfs), 2048);
 
 	av1_dec->prob_tbl_out.cpu = dma_alloc_coherent(vpu->dev,
 						       ALIGN(sizeof(struct av1cdfs), 2048),
 						       &av1_dec->prob_tbl_out.dma,
 						       GFP_KERNEL);
-	if (!av1_dec->prob_tbl_out.cpu)
-		return -ENOMEM;
+	if (!av1_dec->prob_tbl_out.cpu) {
+		ret = -ENOMEM;
+		goto prob_tbl_out_cpu_err;
+	}
+
 	av1_dec->prob_tbl_out.size = ALIGN(sizeof(struct av1cdfs), 2048);
 	av1_dec->cdfs = &av1_dec->default_cdfs;
 	av1_dec->cdfs_ndvc = &av1_dec->default_cdfs_ndvc;
@@ -420,11 +436,37 @@ int rockchip_vpu981_av1_dec_init(struct hantro_ctx *ctx)
 						   AV1_TILE_SIZE,
 						   &av1_dec->tile_buf.dma,
 						   GFP_KERNEL);
-	if (!av1_dec->tile_buf.cpu)
-		return -ENOMEM;
+	if (!av1_dec->tile_buf.cpu) {
+		ret = -ENOMEM;
+		goto tile_buf_cpu_err;
+	}
+
 	av1_dec->tile_buf.size = AV1_TILE_SIZE;
 
-	return 0;
+	return ret;
+
+tile_buf_cpu_err:
+	dma_free_coherent(vpu->dev, av1_dec->prob_tbl_out.size,
+			  av1_dec->prob_tbl_out.cpu,
+			  av1_dec->prob_tbl_out.dma);
+prob_tbl_out_cpu_err:
+	dma_free_coherent(vpu->dev, av1_dec->prob_tbl.size,
+			  av1_dec->prob_tbl.cpu,
+			  av1_dec->prob_tbl.dma);
+prob_tbl_cpu_err:
+	dma_free_coherent(vpu->dev, av1_dec->film_grain.size,
+			  av1_dec->film_grain.cpu,
+			  av1_dec->film_grain.dma);
+film_grain_cpu_err:
+	dma_free_coherent(vpu->dev, av1_dec->tile_info.size,
+			  av1_dec->tile_info.cpu,
+			  av1_dec->tile_info.dma);
+tile_info_cpu_err:
+	dma_free_coherent(vpu->dev, av1_dec->global_model.size,
+			  av1_dec->global_model.cpu,
+			  av1_dec->global_model.dma);
+global_model_cpu_err:
+	return ret;
 }
 
 static int rockchip_vpu981_av1_dec_prepare_run(struct hantro_ctx *ctx)
-- 
2.53.0



