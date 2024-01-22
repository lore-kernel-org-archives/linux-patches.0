Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDC366B3C;
	Tue, 23 Jan 2024 02:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975323; cv=none; b=gMA3RIsVVYTDyHP1OKxroQvfQYLkIXO6Jnps/jgfTR/NNIo/9puiOgTaN4Z4nkZ2XvqErSSisLSiPXfQs64utaGPrYjuFfvjRhsyOKjv/M8hdLtj8YX/C5HXbVqLoFLGSb6dOQEpmXku1J2dxus+Z7p9HifnG0z5hsJ5g+h1Ujo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975323; c=relaxed/simple;
	bh=Qbgne7BT6uT5aUIU584P0HrFU80ueunn+DumU2/x5Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksVAV+NYoks/p8ZPW/OZn2oju1sBgWoaYv1H+kCcBsrPtNCC9XlnaVPuiy9Pc4nJmdbMBq+4W+6NI9P0dTHlfAhKinFvM+MADc7pEshaQBMDfUyqbXdywYRk8qiAgksE6gm0jBUtQA7l1Tfq3y7gGTJDdJ93V+OGbu9smJACAvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zh4JVp95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zh4JVp95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2355C433C7;
	Tue, 23 Jan 2024 02:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975323;
	bh=Qbgne7BT6uT5aUIU584P0HrFU80ueunn+DumU2/x5Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zh4JVp95IcXJMW3kyGd7rYnNoZhkho9xR+cUXyw3gp8bz+inSpZnskchHjohm27wN
	 vZA/DWdNmzLtIL9sBcQlJOLm8TBP5vmqKuETjF2hUPI7e564oG23IuI9AtFWE7fLsb
	 lmfnVXesfvgP2P21Xenx1xNafOBHtbdu4RClHm0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/583] drm/mediatek: Remove the redundant driver data for DPI
Date: Mon, 22 Jan 2024 15:55:37 -0800
Message-ID: <20240122235820.757411585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 8ac6935e5689a491f0bec78fec732722b3dad094 ]

DPI input is in 1T2P mode on both MT8195 and MT8188.
Remove the redundant driver data to align the settings, or
the screen will glitch.

Fixes: 2847cd7e6403 ("drm/mediatek: Add mt8188 dpi compatibles and platform data")

Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20231214055847.4936-22-shawn.sung@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index 2f931e4e2b60..bc073a6b367e 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -957,20 +957,6 @@ static const struct mtk_dpi_conf mt8186_conf = {
 	.csc_enable_bit = CSC_ENABLE,
 };
 
-static const struct mtk_dpi_conf mt8188_dpintf_conf = {
-	.cal_factor = mt8195_dpintf_calculate_factor,
-	.max_clock_khz = 600000,
-	.output_fmts = mt8195_output_fmts,
-	.num_output_fmts = ARRAY_SIZE(mt8195_output_fmts),
-	.pixels_per_iter = 4,
-	.input_2pixel = false,
-	.dimension_mask = DPINTF_HPW_MASK,
-	.hvsize_mask = DPINTF_HSIZE_MASK,
-	.channel_swap_shift = DPINTF_CH_SWAP,
-	.yuv422_en_bit = DPINTF_YUV422_EN,
-	.csc_enable_bit = DPINTF_CSC_ENABLE,
-};
-
 static const struct mtk_dpi_conf mt8192_conf = {
 	.cal_factor = mt8183_calculate_factor,
 	.reg_h_fre_con = 0xe0,
@@ -1094,7 +1080,7 @@ static const struct of_device_id mtk_dpi_of_ids[] = {
 	{ .compatible = "mediatek,mt8173-dpi", .data = &mt8173_conf },
 	{ .compatible = "mediatek,mt8183-dpi", .data = &mt8183_conf },
 	{ .compatible = "mediatek,mt8186-dpi", .data = &mt8186_conf },
-	{ .compatible = "mediatek,mt8188-dp-intf", .data = &mt8188_dpintf_conf },
+	{ .compatible = "mediatek,mt8188-dp-intf", .data = &mt8195_dpintf_conf },
 	{ .compatible = "mediatek,mt8192-dpi", .data = &mt8192_conf },
 	{ .compatible = "mediatek,mt8195-dp-intf", .data = &mt8195_dpintf_conf },
 	{ /* sentinel */ },
-- 
2.43.0



