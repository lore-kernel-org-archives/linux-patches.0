Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D771A619B;
	Tue, 30 Jul 2024 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357613; cv=none; b=EYRWLKR8+mfFu7V4NmlhZydjOcGQaUiAZRAqN6EidL1fj+ipTwfGIolcRsUW8v9i+8cPTimrEmA1t7rNIqnBiLUZY+Z8QTDHW9r2OQJ/NWAdL/zpNIwBgg43SjKhlZlO92Ifbfxg3NdnN62+ZB+u+5Pm9E+VlVDFw32QMppp6QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357613; c=relaxed/simple;
	bh=tnmeEL9dn9JFMariPTOYyI39NiPBlxbcw+JawAP1fXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijUYZi2fmt9UzCNB9LU2kJUDVgN8GXWHSSbUxpEKxiLWMny5HM5uVjqKkbI+2gRNN7dnbUA8VlicHuGDWti42/LgPNcBVph1bo/XgblbZMX4sbLR8Zs+2ae3BKb2d0VpGuS0i1VhYVAsUQ9YhppxEg3XH5X1HOpYvhJmReHB0eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCiA+mhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCiA+mhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE226C32782;
	Tue, 30 Jul 2024 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357613;
	bh=tnmeEL9dn9JFMariPTOYyI39NiPBlxbcw+JawAP1fXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCiA+mhXnCq3CiiP/oNbSwpiLkwsP+brih/ci7FlHLyfgFOYH26s0cWxPXdCWsIFG
	 aL+txQ758VnvE8D7g0+STDWF6BDkGNeTY00+GCiChhW9IeYtrHf464coA77T5Y9ifn
	 hnAhkHPjrUYMOa3gy2c1hPhQdjsJQy2qGAio0J+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 272/809] drm/panel: lg-sw43408: add missing error handling
Date: Tue, 30 Jul 2024 17:42:28 +0200
Message-ID: <20240730151735.336316166@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 51f9183e4af8c7f00e81180cbb9ee4a98a0f0aa1 ]

Add missing error handling for the mipi_dsi_ functions that actually
return error code instead of silently ignoring it.

Fixes: 069a6c0e94f9 ("drm: panel: Add LG sw43408 panel driver")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240512-dsi-panels-upd-api-v2-1-e31ca14d102e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240512-dsi-panels-upd-api-v2-1-e31ca14d102e@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-lg-sw43408.c | 33 +++++++++++++++++++-----
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-lg-sw43408.c b/drivers/gpu/drm/panel/panel-lg-sw43408.c
index 2b3a73696dcec..67a98ac508f87 100644
--- a/drivers/gpu/drm/panel/panel-lg-sw43408.c
+++ b/drivers/gpu/drm/panel/panel-lg-sw43408.c
@@ -62,16 +62,25 @@ static int sw43408_program(struct drm_panel *panel)
 {
 	struct sw43408_panel *ctx = to_panel_info(panel);
 	struct drm_dsc_picture_parameter_set pps;
+	int ret;
 
 	mipi_dsi_dcs_write_seq(ctx->link, MIPI_DCS_SET_GAMMA_CURVE, 0x02);
 
-	mipi_dsi_dcs_set_tear_on(ctx->link, MIPI_DSI_DCS_TEAR_MODE_VBLANK);
+	ret = mipi_dsi_dcs_set_tear_on(ctx->link, MIPI_DSI_DCS_TEAR_MODE_VBLANK);
+	if (ret < 0) {
+		dev_err(panel->dev, "Failed to set tearing: %d\n", ret);
+		return ret;
+	}
 
 	mipi_dsi_dcs_write_seq(ctx->link, 0x53, 0x0c, 0x30);
 	mipi_dsi_dcs_write_seq(ctx->link, 0x55, 0x00, 0x70, 0xdf, 0x00, 0x70, 0xdf);
 	mipi_dsi_dcs_write_seq(ctx->link, 0xf7, 0x01, 0x49, 0x0c);
 
-	mipi_dsi_dcs_exit_sleep_mode(ctx->link);
+	ret = mipi_dsi_dcs_exit_sleep_mode(ctx->link);
+	if (ret < 0) {
+		dev_err(panel->dev, "Failed to exit sleep mode: %d\n", ret);
+		return ret;
+	}
 
 	msleep(135);
 
@@ -97,14 +106,22 @@ static int sw43408_program(struct drm_panel *panel)
 	mipi_dsi_dcs_write_seq(ctx->link, 0x55, 0x04, 0x61, 0xdb, 0x04, 0x70, 0xdb);
 	mipi_dsi_dcs_write_seq(ctx->link, 0xb0, 0xca);
 
-	mipi_dsi_dcs_set_display_on(ctx->link);
+	ret = mipi_dsi_dcs_set_display_on(ctx->link);
+	if (ret < 0) {
+		dev_err(panel->dev, "Failed to set display on: %d\n", ret);
+		return ret;
+	}
 
 	msleep(50);
 
 	ctx->link->mode_flags &= ~MIPI_DSI_MODE_LPM;
 
 	drm_dsc_pps_payload_pack(&pps, ctx->link->dsc);
-	mipi_dsi_picture_parameter_set(ctx->link, &pps);
+	ret = mipi_dsi_picture_parameter_set(ctx->link, &pps);
+	if (ret < 0) {
+		dev_err(panel->dev, "Failed to set PPS: %d\n", ret);
+		return ret;
+	}
 
 	ctx->link->mode_flags |= MIPI_DSI_MODE_LPM;
 
@@ -113,8 +130,12 @@ static int sw43408_program(struct drm_panel *panel)
 	 * PPS 1 if pps_identifier is 0
 	 * PPS 2 if pps_identifier is 1
 	 */
-	mipi_dsi_compression_mode_ext(ctx->link, true,
-				      MIPI_DSI_COMPRESSION_DSC, 1);
+	ret = mipi_dsi_compression_mode_ext(ctx->link, true,
+					    MIPI_DSI_COMPRESSION_DSC, 1);
+	if (ret < 0) {
+		dev_err(panel->dev, "Failed to set compression mode: %d\n", ret);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.43.0



