Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999031F130D;
	Tue,  3 Dec 2024 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238312; cv=none; b=Fq/aAhjYYn/SXZh7M+4XjNOmSBMR8jF5h/7h7FKWYFjsTDkR7cy7SWzemVBv7blDGlC/1sDFXO3cs4wfwKZKBujIaXbKc9c23Xfsc7TSJ0AKE6og7TYf2cLqbq1gRMle9BPlml5nvqv0EcnynkCn6hWKWj8TawVUe153eqqvKsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238312; c=relaxed/simple;
	bh=QW52tLcsaMSWEzqWDWzI1u5iHSE/AC4h9Glvbifjgr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMt8n3eA6dpGiJwX7853TtiEQwHIIirmJe3Ir9KMLvS8HOY/llv+MZvcTswKjD/D2zFNmEkJZMoDUzL9IrW1gt+vZHB9q4uYLEVQ6D2mZRZcr5Ac37OwGnPhhNXkqdeVHjv85WeH5FJ15UyNFQ0KfKooINTPBVuk5Xtu2ZVeVpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Enx2zOup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Enx2zOup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260BFC4CECF;
	Tue,  3 Dec 2024 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238312;
	bh=QW52tLcsaMSWEzqWDWzI1u5iHSE/AC4h9Glvbifjgr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Enx2zOup1mpKk5dl2wZ95sBHtueu+phg6vWBgHeTWn4/GqMqM2TqWbQ7ZLth/jsyK
	 qb575qcbimykTIeEJyQEQIggSUunXeHcVyNz7NmnlYdqWU/m4MFlOsgh88rGqN/5aC
	 Ceg6Z9haNWIUog2NDdkTkJqTDGLrDjzKqmeZ1b9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Chris Healy <cphealy@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 234/817] drm/imx: ldb: drop custom EDID support
Date: Tue,  3 Dec 2024 15:36:46 +0100
Message-ID: <20241203144004.885089715@linuxfoundation.org>
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

[ Upstream commit aed7b500315004a917463d571fa9cd12e0e94370 ]

Bindings for the imx-ldb never allowed specifying the EDID in DT. None
of the existing DT files use it. Drop it now in favour of using debugfs
overrides or the drm.edid_firmware support.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Chris Healy <cphealy@gmail.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de> # on imx6q-nitrogen6x
Link: https://patchwork.freedesktop.org/patch/msgid/20240602-drm-imx-cleanup-v3-5-e549e2a43100@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: f673055a4678 ("drm/imx: Add missing DRM_BRIDGE_CONNECTOR dependency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/imx-ldb.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/imx-ldb.c b/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
index 793dfb1a3ed00..1924d8921c620 100644
--- a/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
+++ b/drivers/gpu/drm/imx/ipuv3/imx-ldb.c
@@ -72,7 +72,6 @@ struct imx_ldb_channel {
 	struct device_node *child;
 	struct i2c_adapter *ddc;
 	int chno;
-	const struct drm_edid *drm_edid;
 	struct drm_display_mode mode;
 	int mode_valid;
 	u32 bus_format;
@@ -142,14 +141,17 @@ static int imx_ldb_connector_get_modes(struct drm_connector *connector)
 	if (num_modes > 0)
 		return num_modes;
 
-	if (!imx_ldb_ch->drm_edid && imx_ldb_ch->ddc) {
-		imx_ldb_ch->drm_edid = drm_edid_read_ddc(connector,
-							 imx_ldb_ch->ddc);
-		drm_edid_connector_update(connector, imx_ldb_ch->drm_edid);
-	}
+	if (imx_ldb_ch->ddc) {
+		const struct drm_edid *edid = drm_edid_read_ddc(connector,
+								imx_ldb_ch->ddc);
 
-	if (imx_ldb_ch->drm_edid)
-		num_modes = drm_edid_connector_add_modes(connector);
+		if (edid) {
+			drm_edid_connector_update(connector, edid);
+			drm_edid_free(edid);
+
+			return drm_edid_connector_add_modes(connector);
+		}
+	}
 
 	if (imx_ldb_ch->mode_valid) {
 		struct drm_display_mode *mode;
@@ -566,18 +568,10 @@ static int imx_ldb_panel_ddc(struct device *dev,
 	}
 
 	if (!channel->ddc) {
-		const void *edidp;
-		int edid_len;
-
 		/* if no DDC available, fallback to hardcoded EDID */
 		dev_dbg(dev, "no ddc available\n");
 
-		edidp = of_get_property(child, "edid", &edid_len);
-		if (edidp) {
-			channel->drm_edid = drm_edid_alloc(edidp, edid_len);
-			if (!channel->drm_edid)
-				return -ENOMEM;
-		} else if (!channel->panel) {
+		if (!channel->panel) {
 			/* fallback to display-timings node */
 			ret = of_get_drm_display_mode(child,
 						      &channel->mode,
@@ -744,7 +738,6 @@ static void imx_ldb_remove(struct platform_device *pdev)
 	for (i = 0; i < 2; i++) {
 		struct imx_ldb_channel *channel = &imx_ldb->channel[i];
 
-		drm_edid_free(channel->drm_edid);
 		i2c_put_adapter(channel->ddc);
 	}
 
-- 
2.43.0



