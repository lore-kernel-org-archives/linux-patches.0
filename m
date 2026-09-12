Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C00534D915;
	Sat, 12 Sep 2026 09:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206110; cv=none; b=HasECWgpctfucownQBS4ghjyJreSMee9Z78Gsyq8XSXiVThcN2mPIOClpwf8fsEyEqHCr58vNop0vMol1XbE6Tmo692KX5j16HyHst+ZqsOB4a0T/mhxooJLpqQYmI4x2Gq9IQDu6YMazVQpnJ7W4DOtI3ZMEOS1Wroa/nwqzVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206110; c=relaxed/simple;
	bh=0bLmTDTDkllji+Gt0C8oawgECZ8llaAJr6DRbcu6unc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmTT/8O3gATlUiQYfa7wxiu0xy6/BIINSxB56gnqRZ7a6W2ASuIQkIkXKD0l2b9t0FEzlfgnE++SEN0MmcO7hI2HU2H5cWgWptxE1Udd+L1oZbnqfAMuqsqVn5Wp95/4rFekAzs9UzcUhiyM03vY8CpaWUngsY9MaU5qslFLzJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sljFjT72; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sljFjT72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA801F000FF;
	Sat, 12 Sep 2026 09:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206109;
	bh=hMKxt+wWwjMv4A93zas2JQM06NdmAauhM0l6VmD1lwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sljFjT72kgM8r2wqVKCl43wwmW9hUZkRzKvMBIlqD25I69Ybst9KHmYqcwdq5MKsC
	 Sh4ST9y6EQGH7eGbAE5Vw2yw1xKMrYCWcBvqB+UY5KfZliIEZh4rDWulPErMNDOnP1
	 b5kQ+cVoXPWOPEgR90LRb4pidnZ0l1Cl18ddMTr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0096/1518] drm/bridge: synopsys: dw-dp: Set pixel mode by platform data
Date: Sat, 12 Sep 2026 08:37:45 +0200
Message-ID: <20260912065625.649277171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 77ae37018a2705f5abe8cc428e3496651258901d ]

In the implementation and integration of the SoC, the DW DisplayPort
hardware block can be configured to work in single, dual, quad pixel
mode on differnt platforms, so make the pixel mode set by plat_data
to support the upcoming rk3576 variant.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260206010421.443605-3-andyshrk@163.com
Stable-dep-of: cc6d7aca2f37 ("drm/rockchip: dw_dp: Release core resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-dp.c   |  8 +-------
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c | 19 +++++++++++++++----
 include/drm/bridge/dw_dp.h                |  7 +++++++
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-dp.c b/drivers/gpu/drm/bridge/synopsys/dw-dp.c
index 70f64eb89998f..901bdec4a76ca 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-dp.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-dp.c
@@ -352,12 +352,6 @@ enum {
 	DW_DP_YCBCR420_16BIT,
 };
 
-enum {
-	DW_DP_MP_SINGLE_PIXEL,
-	DW_DP_MP_DUAL_PIXEL,
-	DW_DP_MP_QUAD_PIXEL,
-};
-
 enum {
 	DW_DP_SDP_VERTICAL_INTERVAL = BIT(0),
 	DW_DP_SDP_HORIZONTAL_INTERVAL = BIT(1),
@@ -1984,7 +1978,7 @@ struct dw_dp *dw_dp_bind(struct device *dev, struct drm_encoder *encoder,
 		return ERR_CAST(dp);
 
 	dp->dev = dev;
-	dp->pixel_mode = DW_DP_MP_QUAD_PIXEL;
+	dp->pixel_mode = plat_data->pixel_mode;
 
 	dp->plat_data.max_link_rate = plat_data->max_link_rate;
 	bridge = &dp->bridge;
diff --git a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
index 6d57e1c746273..80aa8d11b49cb 100644
--- a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
@@ -76,7 +76,7 @@ static const struct drm_encoder_helper_funcs dw_dp_encoder_helper_funcs = {
 static int dw_dp_rockchip_bind(struct device *dev, struct device *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct dw_dp_plat_data plat_data;
+	const struct dw_dp_plat_data *plat_data;
 	struct drm_device *drm_dev = data;
 	struct rockchip_dw_dp *dp;
 	struct drm_encoder *encoder;
@@ -90,7 +90,10 @@ static int dw_dp_rockchip_bind(struct device *dev, struct device *master, void *
 	dp->dev = dev;
 	platform_set_drvdata(pdev, dp);
 
-	plat_data.max_link_rate = 810000;
+	plat_data = of_device_get_match_data(dev);
+	if (!plat_data)
+		return -ENODEV;
+
 	encoder = &dp->encoder.encoder;
 	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm_dev, dev->of_node);
 	rockchip_drm_encoder_set_crtc_endpoint_id(&dp->encoder, dev->of_node, 0, 0);
@@ -100,7 +103,7 @@ static int dw_dp_rockchip_bind(struct device *dev, struct device *master, void *
 		return ret;
 	drm_encoder_helper_add(encoder, &dw_dp_encoder_helper_funcs);
 
-	dp->base = dw_dp_bind(dev, encoder, &plat_data);
+	dp->base = dw_dp_bind(dev, encoder, plat_data);
 	if (IS_ERR(dp->base)) {
 		ret = PTR_ERR(dp->base);
 		return ret;
@@ -133,8 +136,16 @@ static void dw_dp_remove(struct platform_device *pdev)
 	component_del(&pdev->dev, &dw_dp_rockchip_component_ops);
 }
 
+static const struct dw_dp_plat_data rk3588_dp_plat_data = {
+	.max_link_rate = 810000,
+	.pixel_mode = DW_DP_MP_QUAD_PIXEL,
+};
+
 static const struct of_device_id dw_dp_of_match[] = {
-	{ .compatible = "rockchip,rk3588-dp", },
+	{
+		.compatible = "rockchip,rk3588-dp",
+		.data = &rk3588_dp_plat_data,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, dw_dp_of_match);
diff --git a/include/drm/bridge/dw_dp.h b/include/drm/bridge/dw_dp.h
index ab5c0a9b01aeb..22105c3e8e4d6 100644
--- a/include/drm/bridge/dw_dp.h
+++ b/include/drm/bridge/dw_dp.h
@@ -11,8 +11,15 @@
 struct drm_encoder;
 struct dw_dp;
 
+enum {
+	DW_DP_MP_SINGLE_PIXEL,
+	DW_DP_MP_DUAL_PIXEL,
+	DW_DP_MP_QUAD_PIXEL,
+};
+
 struct dw_dp_plat_data {
 	u32 max_link_rate;
+	u8 pixel_mode;
 };
 
 struct dw_dp *dw_dp_bind(struct device *dev, struct drm_encoder *encoder,
-- 
2.53.0



