Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064445;
	b=froHWstNaUauUcG0lLlYu2QyLul1oX39uNRVo6/vGsQppaSooYQxnC/dANstkfzp28d2
	 VPEdOFeo11gPovMVo7Pwh4VhZtdakfVapyf8oba19cd/0gFXWSoKpdyrnxhEiDFWVyZAw
	 0I2DM8hrJERb/Un5WZmhMal8BLigS8WyXOEvaxyXtxf+JoHCeYekO7sqF+cFUKBi0+JWm
	 kfzBklRNGV417C8rUbyrItMpE+zyyuXeMgOgByKIRf8TaQzkyraTPW0+buZm4x4OBzYcf
	 MrSkNx8ix/ov/q9Yyr9qq6ZgIgwqwhVLZeo9wh5Yie4eupnsLhG97Hg1YhZ1E9yonBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ilzLuWLR4dhPjk7wP29zVK5t6JH4DGP4vtY4zWkAo7M=;
	b=gKFTcqS2Mc8bzIp2+QQV5imWNKhaGZ1IcaQlNxp9XIOUsG7PGex/ZeTlaG6B9V8slWb3
	 ewBCPbf56TAgYJW1LtCJbOovFq0QeqmO9/n+B6i+cz4Bqkky2qd2KzvW2pZC9Qn997sz+
	 twvMrdZFH4VWMYydYO0DnXO+MMc+Vr78cFQK06sf6KjHr3Mvd2ONrtW+okWQFB1iC+GEr
	 qV1mhwi9BId0twsf+wZHNmMudvD3p4Dqipmkxr2SxmE2dqFxzA0EmaWTtFLsjhCODV/ah
	 P+pLIP3URhID0fnqQoCWUyWUdjCIHETuZ4JzlhXzanVPO0X8JspjYkuEXGStBxSZBiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BB+Aio9n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F026606C000;
	Sat,  7 Nov 2026 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BB+Aio9n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1301F0089F;
	Sat,  7 Nov 2026 15:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064445;
	bh=ilzLuWLR4dhPjk7wP29zVK5t6JH4DGP4vtY4zWkAo7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BB+Aio9nLQnBTmMX6q26mVXC1cEd9rOpN69qTIYyda4RElhhCVH/OcKqQSffwmuJR
	 /KQDIizXNqx3KEP9/xlRCqkquKkK1PbuhIJaYbxQqa9IZPZQ6Wht7BWVyxV7DfIppl
	 Sqf/zw2ZLywO3A+qfPJScuj2DaYIGZDdY0Bg2yK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0463/1257] media: verisilicon: rockchip: Fix leaks in init
Date: Sat,  7 Nov 2026 08:45:59 -0500
Message-ID: <20261107134952.250748571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 00aa566a4ccdb..2a145433e6d17 100644
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



