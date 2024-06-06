Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9D019E7CA;
	Thu,  6 Jun 2024 14:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683518; cv=none; b=MVSqd5KvvJ6QFxezG18952AM1KHz136zeF5wg0D9a01dlQnT6nrv9bQy99EKZOUHI7y0KI7u38ILrz1EEKYKwgoP9xxvBZlm8bUjMOv7Bgj33TaSPUpLG5Bfj25l3RwVfVvSQ+G47g62OTbZtTTnD25GwQitnhg7aqTdmaPvJ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683518; c=relaxed/simple;
	bh=BxSASIVusnqBgBk/YxsYH2FL8QuWGMEsq8qwNAJG7vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii0uP0YdLyYO+49pvBNC79y5VmzoODFCGsteuVl+lwxz2Jb2SMFM2TqGOER6FiPyXsJU8e2mUmOEVNLaRo+x253cfAjvIg6rr2XVBcnHR19atTsI0d/DkuXag6fteRvPuZriDIrL9nhbEu/nKrXAX8/pj8tx9noZQV6I9PWFUwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tv3SPyRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tv3SPyRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19867C32781;
	Thu,  6 Jun 2024 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683518;
	bh=BxSASIVusnqBgBk/YxsYH2FL8QuWGMEsq8qwNAJG7vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tv3SPyRpekL8+S6u9iUwjr2lZwJFp50EwI2cm3mZQRCMUGKJDIGRsrsg9zhdMyI3U
	 UEkWX+rd0Thux53lvk6NXmhBOOs+E5znhBw59ztwQWxuszP6YEVEKknGRdq2l7Ve9C
	 aNWbcXQfI/tVZz6v0xoz8NUcK56Dyr0/9DSkYrkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 370/473] drm/mediatek: dp: Move PHY registration to new function
Date: Thu,  6 Jun 2024 16:04:59 +0200
Message-ID: <20240606131712.127568939@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 18ccc237cf646f93e25b802e5cca0788f4f48b39 ]

In preparation for adding support for eDP, move the PHY registration
code to a new mtk_dp_register_phy() function for better readability.

This commit brings no functional changes.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20230725073234.55892-9-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Stable-dep-of: 8431fff9e0f3 ("drm/mediatek: dp: Fix mtk_dp_aux_transfer return value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 43 +++++++++++++++++++------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index 519e23a2a017c..326a536e677cd 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2490,6 +2490,29 @@ static int mtk_dp_register_audio_driver(struct device *dev)
 	return PTR_ERR_OR_ZERO(mtk_dp->audio_pdev);
 }
 
+static int mtk_dp_register_phy(struct mtk_dp *mtk_dp)
+{
+	struct device *dev = mtk_dp->dev;
+
+	mtk_dp->phy_dev = platform_device_register_data(dev, "mediatek-dp-phy",
+							PLATFORM_DEVID_AUTO,
+							&mtk_dp->regs,
+							sizeof(struct regmap *));
+	if (IS_ERR(mtk_dp->phy_dev))
+		return dev_err_probe(dev, PTR_ERR(mtk_dp->phy_dev),
+				     "Failed to create device mediatek-dp-phy\n");
+
+	mtk_dp_get_calibration_data(mtk_dp);
+
+	mtk_dp->phy = devm_phy_get(&mtk_dp->phy_dev->dev, "dp");
+	if (IS_ERR(mtk_dp->phy)) {
+		platform_device_unregister(mtk_dp->phy_dev);
+		return dev_err_probe(dev, PTR_ERR(mtk_dp->phy), "Failed to get phy\n");
+	}
+
+	return 0;
+}
+
 static int mtk_dp_probe(struct platform_device *pdev)
 {
 	struct mtk_dp *mtk_dp;
@@ -2547,23 +2570,9 @@ static int mtk_dp_probe(struct platform_device *pdev)
 		}
 	}
 
-	mtk_dp->phy_dev = platform_device_register_data(dev, "mediatek-dp-phy",
-							PLATFORM_DEVID_AUTO,
-							&mtk_dp->regs,
-							sizeof(struct regmap *));
-	if (IS_ERR(mtk_dp->phy_dev))
-		return dev_err_probe(dev, PTR_ERR(mtk_dp->phy_dev),
-				     "Failed to create device mediatek-dp-phy\n");
-
-	mtk_dp_get_calibration_data(mtk_dp);
-
-	mtk_dp->phy = devm_phy_get(&mtk_dp->phy_dev->dev, "dp");
-
-	if (IS_ERR(mtk_dp->phy)) {
-		platform_device_unregister(mtk_dp->phy_dev);
-		return dev_err_probe(dev, PTR_ERR(mtk_dp->phy),
-				     "Failed to get phy\n");
-	}
+	ret = mtk_dp_register_phy(mtk_dp);
+	if (ret)
+		return ret;
 
 	mtk_dp->bridge.funcs = &mtk_dp_bridge_funcs;
 	mtk_dp->bridge.of_node = dev->of_node;
-- 
2.43.0



