Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D18C12A155;
	Tue, 23 Jan 2024 00:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971036; cv=none; b=KKgITF3r4Ej5VBiZH7UDcFXts5AkwQS2kbV6FlRvbhmZscHRqC0fnyV1DVoNVkJjkZxc4NiQCP3J9jrd4Vlb49tI5EYnvCBpiUcahkoIvwBChy4GeBk2a7LkX4mc0994Wt0+Oq/bpnV0X03FFFTip5zamqfAazWB/Sccc1MkY5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971036; c=relaxed/simple;
	bh=OV9+KbSCEItFRSZvKrp94vTWd5hYmF+k7F7MxsP3Tb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4sycxi3DckaylGulxIaW3d4NHQlPRBSakWHXYUMazqcOuGCzBF+BZrfS0fKtsYErVouVaBYsu80DXLtZO9ofJs7t/z8xlJ5NuSpAeSMoczxbVY5X1wNXezw1FaibL+U7Ug2NjZjg3USeycY6uGBfURRvxYE/XEbROQVwxgWpr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6XZRRxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6XZRRxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7D6C43390;
	Tue, 23 Jan 2024 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971036;
	bh=OV9+KbSCEItFRSZvKrp94vTWd5hYmF+k7F7MxsP3Tb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6XZRRxYYDFcGWJetZmTfMd4iYvdjBGsjrAmFBhJhXKDef09cWUar6O+LNOQgxZTJ
	 lmYHms94++ZvNcQL9PFqRCz9aL2vmnRlNN3dlORmxvOD3RnGVj1Rgqf/XMXjOee1Ax
	 XdwFR0q65F3QMPQoxU7ScsfQHeLzf9WERlORA89M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kyrie wu <kyrie.wu@mediatek.com>,
	irui wang <irui.wang@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/417] media: mtk-jpegdec: export jpeg decoder functions
Date: Mon, 22 Jan 2024 15:55:34 -0800
Message-ID: <20240122235757.591528705@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: kyrie wu <kyrie.wu@mediatek.com>

[ Upstream commit 08d530a8da706f157e9dcb4d9b7b4f0eff908ab9 ]

mtk jpeg decoder is built as a module, export some functions to make them
visible by other modules.

Signed-off-by: kyrie wu <kyrie.wu@mediatek.com>
Signed-off-by: irui wang <irui.wang@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: d8212c5c87c1 ("media: mtk-jpeg: Remove cancel worker in mtk_jpeg_remove to avoid the crash of multi-core JPEG devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_dec_hw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_dec_hw.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_dec_hw.c
index afbbfd5d02bc..6d200e23754e 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_dec_hw.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_dec_hw.c
@@ -188,6 +188,7 @@ int mtk_jpeg_dec_fill_param(struct mtk_jpeg_dec_param *param)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mtk_jpeg_dec_fill_param);
 
 u32 mtk_jpeg_dec_get_int_status(void __iomem *base)
 {
@@ -199,6 +200,7 @@ u32 mtk_jpeg_dec_get_int_status(void __iomem *base)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mtk_jpeg_dec_get_int_status);
 
 u32 mtk_jpeg_dec_enum_result(u32 irq_result)
 {
@@ -215,11 +217,13 @@ u32 mtk_jpeg_dec_enum_result(u32 irq_result)
 
 	return MTK_JPEG_DEC_RESULT_ERROR_UNKNOWN;
 }
+EXPORT_SYMBOL_GPL(mtk_jpeg_dec_enum_result);
 
 void mtk_jpeg_dec_start(void __iomem *base)
 {
 	writel(0, base + JPGDEC_REG_TRIG);
 }
+EXPORT_SYMBOL_GPL(mtk_jpeg_dec_start);
 
 static void mtk_jpeg_dec_soft_reset(void __iomem *base)
 {
@@ -239,6 +243,7 @@ void mtk_jpeg_dec_reset(void __iomem *base)
 	mtk_jpeg_dec_soft_reset(base);
 	mtk_jpeg_dec_hard_reset(base);
 }
+EXPORT_SYMBOL_GPL(mtk_jpeg_dec_reset);
 
 static void mtk_jpeg_dec_set_brz_factor(void __iomem *base, u8 yscale_w,
 					u8 yscale_h, u8 uvscale_w, u8 uvscale_h)
@@ -407,3 +412,4 @@ void mtk_jpeg_dec_set_config(void __iomem *base,
 				   config->dma_last_mcu);
 	mtk_jpeg_dec_set_pause_mcu_idx(base, config->total_mcu);
 }
+EXPORT_SYMBOL_GPL(mtk_jpeg_dec_set_config);
-- 
2.43.0



