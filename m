Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621F22F2379;
	Tue, 17 Jun 2025 15:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175092; cv=none; b=g56cuBrh6A4nzzInExEpXg0jUATyRHjOhfCMTL0VeXs6B/BttOErxVE0EDh/fh1sr6zH2N0S6f8c8BcX1XuHGZ9onsh1LxOsPFk+Uy+VdadMYH/u3E9Lunn9hBcylOZpxfx4BoxDGdfQgtjuomXgx+c8iyZzOy2WzGHZpxXtLOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175092; c=relaxed/simple;
	bh=dnihI/WzpqUJB8BLB8mm3Q0kQB4XcOCuq+KnVYNFVzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP8C8Au0DJotpGqR8EXug6GDwHBWNBUNGDCySuH/teUJKOttJ9+iGxq5p7fZXiG/VhuatWPNIjgAHWRVHwO68YAco0TJVSBs5AyajGQnKWMkx7cFsgt24Tgd+N7RW0JBnvjEH8TghMb4l7pJ808QjhvPT9IWHobDJu8Sb+KVdZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfl9rnQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfl9rnQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1D7C4CEE7;
	Tue, 17 Jun 2025 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175091;
	bh=dnihI/WzpqUJB8BLB8mm3Q0kQB4XcOCuq+KnVYNFVzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfl9rnQLULDGWmcd163gTW5pdyngSYWQAavK659E03PGbHE6NagKHClnCwA9TDsJT
	 eq7152GdEY1gE3H4L09x5XrrzCDvYItbee66RvF6ER+d0uwCnCp6ouH7oreuQrWstT
	 WCVlYkKb6Jy1cjpKom3yYWcsVwN7eTwSHeh3kjdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/512] drm/panel: samsung-sofef00: Drop s6e3fc2x01 support
Date: Tue, 17 Jun 2025 17:20:42 +0200
Message-ID: <20250617152422.664797254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit e1eb7293ab4107e9e19fa609835e657fe30dfec7 ]

We never properly supported this panel and always used the wrong init
sequence. Drop support so we can move it to it's own proper driver.

Fixes: 5933baa36e26 ("drm/panel/samsung-sofef00: Add panel for OnePlus 6/T devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250419-drop-s6e3fc2x01-support-v1-1-05edfe0d27aa@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-samsung-sofef00.c | 34 ++-----------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-samsung-sofef00.c b/drivers/gpu/drm/panel/panel-samsung-sofef00.c
index 04ce925b3d9db..49cfa84b34f0c 100644
--- a/drivers/gpu/drm/panel/panel-samsung-sofef00.c
+++ b/drivers/gpu/drm/panel/panel-samsung-sofef00.c
@@ -22,7 +22,6 @@ struct sofef00_panel {
 	struct mipi_dsi_device *dsi;
 	struct regulator *supply;
 	struct gpio_desc *reset_gpio;
-	const struct drm_display_mode *mode;
 };
 
 static inline
@@ -159,26 +158,11 @@ static const struct drm_display_mode enchilada_panel_mode = {
 	.height_mm = 145,
 };
 
-static const struct drm_display_mode fajita_panel_mode = {
-	.clock = (1080 + 72 + 16 + 36) * (2340 + 32 + 4 + 18) * 60 / 1000,
-	.hdisplay = 1080,
-	.hsync_start = 1080 + 72,
-	.hsync_end = 1080 + 72 + 16,
-	.htotal = 1080 + 72 + 16 + 36,
-	.vdisplay = 2340,
-	.vsync_start = 2340 + 32,
-	.vsync_end = 2340 + 32 + 4,
-	.vtotal = 2340 + 32 + 4 + 18,
-	.width_mm = 68,
-	.height_mm = 145,
-};
-
 static int sofef00_panel_get_modes(struct drm_panel *panel, struct drm_connector *connector)
 {
 	struct drm_display_mode *mode;
-	struct sofef00_panel *ctx = to_sofef00_panel(panel);
 
-	mode = drm_mode_duplicate(connector->dev, ctx->mode);
+	mode = drm_mode_duplicate(connector->dev, &enchilada_panel_mode);
 	if (!mode)
 		return -ENOMEM;
 
@@ -239,13 +223,6 @@ static int sofef00_panel_probe(struct mipi_dsi_device *dsi)
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->mode = of_device_get_match_data(dev);
-
-	if (!ctx->mode) {
-		dev_err(dev, "Missing device mode\n");
-		return -ENODEV;
-	}
-
 	ctx->supply = devm_regulator_get(dev, "vddio");
 	if (IS_ERR(ctx->supply))
 		return dev_err_probe(dev, PTR_ERR(ctx->supply),
@@ -295,14 +272,7 @@ static void sofef00_panel_remove(struct mipi_dsi_device *dsi)
 }
 
 static const struct of_device_id sofef00_panel_of_match[] = {
-	{ // OnePlus 6 / enchilada
-		.compatible = "samsung,sofef00",
-		.data = &enchilada_panel_mode,
-	},
-	{ // OnePlus 6T / fajita
-		.compatible = "samsung,s6e3fc2x01",
-		.data = &fajita_panel_mode,
-	},
+	{ .compatible = "samsung,sofef00" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, sofef00_panel_of_match);
-- 
2.39.5



