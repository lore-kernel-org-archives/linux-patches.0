Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3987D1F6696;
	Tue,  3 Dec 2024 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238436; cv=none; b=raXHjxg37tmxRmPDuO9c5vSvKGd1KM7s0NwbRvUj7WKvE+rGMM3LKEIqg+iSz6ai1wZoGDzHowZ2EZPP4XhLf55dPG/fth0fr4WFX7B1Z34EaGw0WM3o3dTDvjY8/lIBCCURsC8fK4wljhBfmwlZDpNOvaLcoHBLVRxVEu91ASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238436; c=relaxed/simple;
	bh=CbeNjIpIEhNF9LtjpwICx7eo348Af4ViQR9V8ycQ39Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGHR73bUCilqoFHZNs2I5w8YaZydAc6UetcIIoiLlJlKXWhjfYbWCDWCg3jR4hGhSQjUBtfZC5HLRZgSlQmMMgf1isMD68cs+4wzVaL7Xp2P2W4wUcGA9bsEs4bFUSjU5GrE5k+sIqTVEBwrUIgABJFJnbaljtfUJZrAu2lKS8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eN/S9yoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eN/S9yoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00E5C4CECF;
	Tue,  3 Dec 2024 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238436;
	bh=CbeNjIpIEhNF9LtjpwICx7eo348Af4ViQR9V8ycQ39Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eN/S9yoGWF54rhxJV8O9WsLg82S3o9WZKRMeDFm4yIxECTCGeJC6NVzbTvpuriF6H
	 KMUe7RAe387mCeoudyfAYpdPMb2lce5VTIsDI4bpbwQ25ureMRiHMspcEVaf/U/AW1
	 NypAXI5Kkfki1w9c28NChy/FM/LmvqZPw9bBlekQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Chris Healy <cphealy@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 235/817] drm/imx: ldb: drop custom DDC bus support
Date: Tue,  3 Dec 2024 15:36:47 +0100
Message-ID: <20241203144004.925450944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b2f3418b516e3485a14f10bfc09f20211dedc156 ]

None of the boards ever supported by the upstream kernel used the custom
DDC bus support with the LDB connector. If a need arises to do so, one
should use panel-simple and its DDC bus code. Drop ddc-i2c-bus support
from the imx-ldb driver.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Chris Healy <cphealy@gmail.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de> # on imx6q-nitrogen6x
Link: https://patchwork.freedesktop.org/patch/msgid/20240602-drm-imx-cleanup-v3-6-e549e2a43100@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: f673055a4678 ("drm/imx: Add missing DRM_BRIDGE_CONNECTOR dependency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/imx-ldb.c | 73 ++++-------------------------
 1 file changed, 10 insertions(+), 63 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/imx-ldb.c b/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
index 1924d8921c620..3f669604377e7 100644
--- a/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
+++ b/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
@@ -25,7 +25,6 @@
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_bridge.h>
-#include <drm/drm_edid.h>
 #include <drm/drm_managed.h>
 #include <drm/drm_of.h>
 #include <drm/drm_panel.h>
@@ -70,7 +69,6 @@ struct imx_ldb_channel {
 	struct drm_bridge *bridge;
 
 	struct device_node *child;
-	struct i2c_adapter *ddc;
 	int chno;
 	struct drm_display_mode mode;
 	int mode_valid;
@@ -141,18 +139,6 @@ static int imx_ldb_connector_get_modes(struct drm_connector *connector)
 	if (num_modes > 0)
 		return num_modes;
 
-	if (imx_ldb_ch->ddc) {
-		const struct drm_edid *edid = drm_edid_read_ddc(connector,
-								imx_ldb_ch->ddc);
-
-		if (edid) {
-			drm_edid_connector_update(connector, edid);
-			drm_edid_free(edid);
-
-			return drm_edid_connector_add_modes(connector);
-		}
-	}
-
 	if (imx_ldb_ch->mode_valid) {
 		struct drm_display_mode *mode;
 
@@ -481,10 +467,9 @@ static int imx_ldb_register(struct drm_device *drm,
 		 */
 		drm_connector_helper_add(connector,
 					 &imx_ldb_connector_helper_funcs);
-		drm_connector_init_with_ddc(drm, connector,
-					    &imx_ldb_connector_funcs,
-					    DRM_MODE_CONNECTOR_LVDS,
-					    imx_ldb_ch->ddc);
+		drm_connector_init(drm, connector,
+				   &imx_ldb_connector_funcs,
+				   DRM_MODE_CONNECTOR_LVDS);
 		drm_connector_attach_encoder(connector, encoder);
 	}
 
@@ -551,39 +536,6 @@ static const struct of_device_id imx_ldb_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, imx_ldb_dt_ids);
 
-static int imx_ldb_panel_ddc(struct device *dev,
-		struct imx_ldb_channel *channel, struct device_node *child)
-{
-	struct device_node *ddc_node;
-	int ret;
-
-	ddc_node = of_parse_phandle(child, "ddc-i2c-bus", 0);
-	if (ddc_node) {
-		channel->ddc = of_find_i2c_adapter_by_node(ddc_node);
-		of_node_put(ddc_node);
-		if (!channel->ddc) {
-			dev_warn(dev, "failed to get ddc i2c adapter\n");
-			return -EPROBE_DEFER;
-		}
-	}
-
-	if (!channel->ddc) {
-		/* if no DDC available, fallback to hardcoded EDID */
-		dev_dbg(dev, "no ddc available\n");
-
-		if (!channel->panel) {
-			/* fallback to display-timings node */
-			ret = of_get_drm_display_mode(child,
-						      &channel->mode,
-						      &channel->bus_flags,
-						      OF_USE_NATIVE_MODE);
-			if (!ret)
-				channel->mode_valid = 1;
-		}
-	}
-	return 0;
-}
-
 static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 {
 	struct drm_device *drm = data;
@@ -694,11 +646,15 @@ static int imx_ldb_probe(struct platform_device *pdev)
 		if (ret && ret != -ENODEV)
 			goto free_child;
 
-		/* panel ddc only if there is no bridge */
-		if (!channel->bridge) {
-			ret = imx_ldb_panel_ddc(dev, channel, child);
+		if (!channel->bridge && !channel->panel) {
+			ret = of_get_drm_display_mode(child,
+						      &channel->mode,
+						      &channel->bus_flags,
+						      OF_USE_NATIVE_MODE);
 			if (ret)
 				goto free_child;
+
+			channel->mode_valid = 1;
 		}
 
 		bus_format = of_get_bus_format(dev, child);
@@ -732,15 +688,6 @@ static int imx_ldb_probe(struct platform_device *pdev)
 
 static void imx_ldb_remove(struct platform_device *pdev)
 {
-	struct imx_ldb *imx_ldb = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < 2; i++) {
-		struct imx_ldb_channel *channel = &imx_ldb->channel[i];
-
-		i2c_put_adapter(channel->ddc);
-	}
-
 	component_del(&pdev->dev, &imx_ldb_ops);
 }
 
-- 
2.43.0



