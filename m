Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2601E3DF9;
	Tue,  3 Dec 2024 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238307; cv=none; b=SDuqvMCn3qyywJcPL0hLs0kPIEWIHPIze2+48pqI21j13aOcukSZLuQT/PRxrn9/A3fjyKnoJ8uY+FKAfR7ZbP683JlfooDM56CnF9AZxsYuiXI3m7bIL6tSxRVd++PhVBWwAUu95UVS0SdOgYRU7BXP7TjYEkF6UWxnsdXGwys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238307; c=relaxed/simple;
	bh=kj51eXIINTWsR+LMXBM3+65zTvomt5Pm5KnZAL0I/W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiswLmWCXJ+gHHj2BYrmGum/+9P125YyMuYw/glzpkNVn8KDWemkyqQK1vdswArwnmo8XyTMRLEuTvkWYXUMcDKHHHaneMKC8nITXDVk/ToLV58Dc0b9HfM3T+vMxygwPsIckOfjWNcqyaeT7litvIJcnlk/r8hWVpdNnNUoeQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7q9teH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7q9teH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C080C4CED6;
	Tue,  3 Dec 2024 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238306;
	bh=kj51eXIINTWsR+LMXBM3+65zTvomt5Pm5KnZAL0I/W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7q9teH3HGhSi6/vv31qshVSvQ90JxwKB9vfuXhcER7pN2Gwf31xwbaOTNikiajqp
	 9xOufFYF71iGz1cdXmFeXNUXq6GjIcqZXK0Pau1TgEOsWGUR5FqEWxzx2tIbLtjzP5
	 Too1fWLFw2tviiSNNM5BfJhNXum/ALb7VGRyZ31I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 232/817] drm/ipuv3/parallel: convert to struct drm_edid
Date: Tue,  3 Dec 2024 15:36:44 +0100
Message-ID: <20241203144004.805068111@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 42e08287a3185409a7a1923374a557e04fc36e48 ]

Prefer the struct drm_edid based functions for storing the EDID and
updating the connector.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/a1698044d556072e79041d69b8702099fd17bd90.1724348429.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: f673055a4678 ("drm/imx: Add missing DRM_BRIDGE_CONNECTOR dependency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/parallel-display.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/parallel-display.c b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
index 55dedd73f528c..91d7808a2d8d3 100644
--- a/drivers/gpu/drm/imx/ipuv3/parallel-display.c
+++ b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
@@ -34,7 +34,7 @@ struct imx_parallel_display_encoder {
 
 struct imx_parallel_display {
 	struct device *dev;
-	void *edid;
+	const struct drm_edid *drm_edid;
 	u32 bus_format;
 	u32 bus_flags;
 	struct drm_display_mode mode;
@@ -62,9 +62,9 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 	if (num_modes > 0)
 		return num_modes;
 
-	if (imxpd->edid) {
-		drm_connector_update_edid_property(connector, imxpd->edid);
-		num_modes = drm_add_edid_modes(connector, imxpd->edid);
+	if (imxpd->drm_edid) {
+		drm_edid_connector_update(connector, imxpd->drm_edid);
+		num_modes = drm_edid_connector_add_modes(connector);
 	}
 
 	if (np) {
@@ -331,7 +331,7 @@ static int imx_pd_probe(struct platform_device *pdev)
 
 	edidp = of_get_property(np, "edid", &edid_len);
 	if (edidp)
-		imxpd->edid = devm_kmemdup(dev, edidp, edid_len, GFP_KERNEL);
+		imxpd->drm_edid = drm_edid_alloc(edidp, edid_len);
 
 	ret = of_property_read_string(np, "interface-pix-fmt", &fmt);
 	if (!ret) {
@@ -355,7 +355,11 @@ static int imx_pd_probe(struct platform_device *pdev)
 
 static void imx_pd_remove(struct platform_device *pdev)
 {
+	struct imx_parallel_display *imxpd = platform_get_drvdata(pdev);
+
 	component_del(&pdev->dev, &imx_pd_ops);
+
+	drm_edid_free(imxpd->drm_edid);
 }
 
 static const struct of_device_id imx_pd_dt_ids[] = {
-- 
2.43.0



