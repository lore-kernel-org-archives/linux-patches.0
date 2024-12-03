Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B3A33FE;
	Tue,  3 Dec 2024 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238309; cv=none; b=jvper7tm8cVVl2NZ1xQHonthT/l99TN7DRElcR1vt5vEitx0nm8wmASJteCDGIzESeLLRstMUksU4GUuKDJ4Eb7eIEFTY54R4Fp01xyhDhcyhmbeE66krTSPtWF4/D6YlhzIUOa1USPDwaubdZCpVsltzsu49fcKIs/dsXGmcAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238309; c=relaxed/simple;
	bh=5p34IGHjy3t6LXV7btZTxLBVMNxRa2zoTYkTICGpsp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9DO+mBriQ1Z+1ADJonsFqUP7EL+hnjhcb4gt9ODJUo6JdsfSVhKPxv/u9MI76oqyUOF9p1JPZRi8x8uxIgpvzclvnVmCkn+d9kGl/icCLAaA81aTzHWieou3RXV/+JIiy/4tRvd+6Pk34woMIBXWsLuVIZOuBAeFmKaoWu3qIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7XrKOk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7XrKOk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8E4C4CECF;
	Tue,  3 Dec 2024 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238309;
	bh=5p34IGHjy3t6LXV7btZTxLBVMNxRa2zoTYkTICGpsp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7XrKOk5AM+3Ztkw9hYGR5blxszgUs7jFYrm6qJFzvQoAr3PYmvw+QD5XrjnjLdDl
	 DeXP6hNjIHRtrHm/sTL2SlF6kYNvmLVDByXRo9ynRkxR8msXfgYoA5RAJsYKebphoF
	 92GgC7/tBbVNQbSLZwa8EOpx+vH0ts5vFpTqmxfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robh@kernel.org>,
	Chris Healy <cphealy@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 233/817] drm/imx: parallel-display: drop edid override support
Date: Tue,  3 Dec 2024 15:36:45 +0100
Message-ID: <20241203144004.844746235@linuxfoundation.org>
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

[ Upstream commit fe30fabf229f7542a10dd249079fdb83844a7dba ]

None of the in-kernel DT files ever used edid override with the
fsl-imx-drm driver. In case the EDID needs to be specified manually, DRM
core allows one to either override it via the debugfs or to load it via
request_firmware by using DRM_LOAD_EDID_FIRMWARE. In all other cases
EDID and/or modes are to be provided as a part of the panel driver.

Drop support for the edid property.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Rob Herring <robh@kernel.org>
Tested-by: Chris Healy <cphealy@gmail.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de> # on imx6q-nitrogen6x
Link: https://patchwork.freedesktop.org/patch/msgid/20240602-drm-imx-cleanup-v3-4-e549e2a43100@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: f673055a4678 ("drm/imx: Add missing DRM_BRIDGE_CONNECTOR dependency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/parallel-display.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/parallel-display.c b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
index 91d7808a2d8d3..4d17fb96e77c5 100644
--- a/drivers/gpu/drm/imx/ipuv3/parallel-display.c
+++ b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
@@ -16,7 +16,6 @@
 
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_bridge.h>
-#include <drm/drm_edid.h>
 #include <drm/drm_managed.h>
 #include <drm/drm_of.h>
 #include <drm/drm_panel.h>
@@ -34,7 +33,6 @@ struct imx_parallel_display_encoder {
 
 struct imx_parallel_display {
 	struct device *dev;
-	const struct drm_edid *drm_edid;
 	u32 bus_format;
 	u32 bus_flags;
 	struct drm_display_mode mode;
@@ -62,11 +60,6 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 	if (num_modes > 0)
 		return num_modes;
 
-	if (imxpd->drm_edid) {
-		drm_edid_connector_update(connector, imxpd->drm_edid);
-		num_modes = drm_edid_connector_add_modes(connector);
-	}
-
 	if (np) {
 		struct drm_display_mode *mode = drm_mode_create(connector->dev);
 		int ret;
@@ -312,9 +305,7 @@ static int imx_pd_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
-	const u8 *edidp;
 	struct imx_parallel_display *imxpd;
-	int edid_len;
 	int ret;
 	u32 bus_format = 0;
 	const char *fmt;
@@ -329,10 +320,6 @@ static int imx_pd_probe(struct platform_device *pdev)
 	if (ret && ret != -ENODEV)
 		return ret;
 
-	edidp = of_get_property(np, "edid", &edid_len);
-	if (edidp)
-		imxpd->drm_edid = drm_edid_alloc(edidp, edid_len);
-
 	ret = of_property_read_string(np, "interface-pix-fmt", &fmt);
 	if (!ret) {
 		if (!strcmp(fmt, "rgb24"))
@@ -355,11 +342,7 @@ static int imx_pd_probe(struct platform_device *pdev)
 
 static void imx_pd_remove(struct platform_device *pdev)
 {
-	struct imx_parallel_display *imxpd = platform_get_drvdata(pdev);
-
 	component_del(&pdev->dev, &imx_pd_ops);
-
-	drm_edid_free(imxpd->drm_edid);
 }
 
 static const struct of_device_id imx_pd_dt_ids[] = {
-- 
2.43.0



