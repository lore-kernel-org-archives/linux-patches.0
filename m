Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E487D1D2784;
	Wed,  6 Nov 2024 12:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896051; cv=none; b=ZTwVprAnTphd3Y7qEnM7mBfBcHTktqZcGG6wNdy+2oSIbNbaKFqHmEMIBnjTxuUWm9LbK77MeM1Bvfigf42ULJT7N3FGK5+IusfRjSE5SkeJnwBIU8hw06Z3KXklhx5OdsV4tiIt/fn9ISwnvgI2WqbcLu8Jwzq7g8gB0n6UIcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896051; c=relaxed/simple;
	bh=uLnWG7QAamuITbol5sadPK8dse3klJcFIo18gpCr1ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IohjnCYCe5c1BoZEA3sViT/OGi0cUj3rcya2XVAPrdmwXhKqomgDh8cA4F3qud1VFB88F9etYkklY/JDaTlJeO6jPk2cvToLicDWR3gTg/BFBtXjz8OE729NsIsdLLZ0kDUhqTXGZkhlWY5AjlI/Ho05oMbHgwziKFbZr6gu4zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJVj86pm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJVj86pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63320C4CED4;
	Wed,  6 Nov 2024 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896050;
	bh=uLnWG7QAamuITbol5sadPK8dse3klJcFIo18gpCr1ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJVj86pmjTVewfSgzuiOmnUcwrDNzTrmoKh6O+K8KY7pCfXrObBtox1hiyLfNPG25
	 yx+5ryhx9WeibXqw9aOa1PbgWoTm/VGAkfIcKRYW1Dep4fva5JxQuru4NFOc+7Xy0d
	 VeyShhSyMp7ThTwzJLNcbdzKK1+BEaUHwQzNE5CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Liankun Yang <liankun.yang@mediatek.com>,
	Fei Shao <fshao@chromium.org>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 072/245] drm/mediatek: Fix get efuse issue for MT8188 DPTX
Date: Wed,  6 Nov 2024 13:02:05 +0100
Message-ID: <20241106120320.978352869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Liankun Yang <liankun.yang@mediatek.com>

[ Upstream commit 3ded11b5c1b476f6d027d9017aa7deb8ab381ec1 ]

Update efuse data for MT8188 displayport.

The DP monitor can not display when DUT connected to USB-c to DP dongle.
Analysis view is invalid DP efuse data.

Fixes: 350c3fe907fb ("drm/mediatek: dp: Add support MT8188 dp/edp function")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Liankun Yang <liankun.yang@mediatek.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Tested-by: Fei Shao <fshao@chromium.org>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240923132521.22785-1-liankun.yang@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 85 ++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index d8796a904eca4..f2bee617f063a 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -145,6 +145,89 @@ struct mtk_dp_data {
 	u16 audio_m_div2_bit;
 };
 
+static const struct mtk_dp_efuse_fmt mt8188_dp_efuse_fmt[MTK_DP_CAL_MAX] = {
+	[MTK_DP_CAL_GLB_BIAS_TRIM] = {
+		.idx = 0,
+		.shift = 10,
+		.mask = 0x1f,
+		.min_val = 1,
+		.max_val = 0x1e,
+		.default_val = 0xf,
+	},
+	[MTK_DP_CAL_CLKTX_IMPSE] = {
+		.idx = 0,
+		.shift = 15,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+	[MTK_DP_CAL_LN_TX_IMPSEL_PMOS_0] = {
+		.idx = 1,
+		.shift = 0,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+	[MTK_DP_CAL_LN_TX_IMPSEL_PMOS_1] = {
+		.idx = 1,
+		.shift = 8,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+	[MTK_DP_CAL_LN_TX_IMPSEL_PMOS_2] = {
+		.idx = 1,
+		.shift = 16,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+	[MTK_DP_CAL_LN_TX_IMPSEL_PMOS_3] = {
+		.idx = 1,
+		.shift = 24,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+	[MTK_DP_CAL_LN_TX_IMPSEL_NMOS_0] = {
+		.idx = 1,
+		.shift = 4,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+	[MTK_DP_CAL_LN_TX_IMPSEL_NMOS_1] = {
+		.idx = 1,
+		.shift = 12,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+	[MTK_DP_CAL_LN_TX_IMPSEL_NMOS_2] = {
+		.idx = 1,
+		.shift = 20,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+	[MTK_DP_CAL_LN_TX_IMPSEL_NMOS_3] = {
+		.idx = 1,
+		.shift = 28,
+		.mask = 0xf,
+		.min_val = 1,
+		.max_val = 0xe,
+		.default_val = 0x8,
+	},
+};
+
 static const struct mtk_dp_efuse_fmt mt8195_edp_efuse_fmt[MTK_DP_CAL_MAX] = {
 	[MTK_DP_CAL_GLB_BIAS_TRIM] = {
 		.idx = 3,
@@ -2771,7 +2854,7 @@ static SIMPLE_DEV_PM_OPS(mtk_dp_pm_ops, mtk_dp_suspend, mtk_dp_resume);
 static const struct mtk_dp_data mt8188_dp_data = {
 	.bridge_type = DRM_MODE_CONNECTOR_DisplayPort,
 	.smc_cmd = MTK_DP_SIP_ATF_VIDEO_UNMUTE,
-	.efuse_fmt = mt8195_dp_efuse_fmt,
+	.efuse_fmt = mt8188_dp_efuse_fmt,
 	.audio_supported = true,
 	.audio_pkt_in_hblank_area = true,
 	.audio_m_div2_bit = MT8188_AUDIO_M_CODE_MULT_DIV_SEL_DP_ENC0_P0_DIV_2,
-- 
2.43.0



