Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BEB17CA12;
	Mon, 10 Mar 2025 17:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628997; cv=none; b=jEQDhoEClEMMg1Y5Z9jR3ZJQAoSWQkaJ+jGvCpLdxjB1MWUNDMVpEVIqhnf/UHZ58BLLPyS2HmVcEcOZ757qpqS7yUPtLurY/xT6iepD6D5QhImhI2/3k8XzSlyQ1l4uFk7KZF2OPm/6qv7c2gbkn2abu8kFfmolsSKkYp7WcvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628997; c=relaxed/simple;
	bh=aXVvi1Q3ONdw/VzOGKR70f1slLxkxParKiXEAiaDjvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+jFbCENNg6JZ1eEmKQS+F1IWMj6Mxfq0D44rrz+H7EhtnkJOaoDvP78pjGrfHcm7UKQh9f6ucbkv9sYHUfdKs2X5O92574khYRuGEn4zy3QUKsR1LJY6/Yx+nhLypO4UaAc1uqFM9T+gDdTj82dVnkBj8eZZEe1nlqNYiBhybk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huu8WyZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huu8WyZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0A8C4CEE5;
	Mon, 10 Mar 2025 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628997;
	bh=aXVvi1Q3ONdw/VzOGKR70f1slLxkxParKiXEAiaDjvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huu8WyZggIMN30HBTT7Vw8jQsbTVYFrxme8Ey34GiETkyrtQXfL0ShQhzr6rSbDR3
	 Bpv35RpvthAo6eMwkAT/pzV7JgrjglOJdpFas/uyQmSNgDQ1nxe+YbTaeMw74WpjCP
	 7QTr9MCBTC9B8LuDp2dBjLMagS4v3Y9IPTZTvn7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/620] media: i2c: imx412: Add missing newline to prints
Date: Mon, 10 Mar 2025 17:59:46 +0100
Message-ID: <20250310170551.124865713@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 33f4a7fba7229232e294f4794503283e44cd03f2 ]

Add trailing \n to dev_dbg and dev_err prints where missing.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Fixes: 9214e86c0cc1 ("media: i2c: Add imx412 camera sensor driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx412.c | 42 +++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/imx412.c b/drivers/media/i2c/imx412.c
index 3d4d813923918..5e7ccbc8dfecd 100644
--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -540,7 +540,7 @@ static int imx412_update_exp_gain(struct imx412 *imx412, u32 exposure, u32 gain)
 
 	lpfr = imx412->vblank + imx412->cur_mode->height;
 
-	dev_dbg(imx412->dev, "Set exp %u, analog gain %u, lpfr %u",
+	dev_dbg(imx412->dev, "Set exp %u, analog gain %u, lpfr %u\n",
 		exposure, gain, lpfr);
 
 	ret = imx412_write_reg(imx412, IMX412_REG_HOLD, 1, 1);
@@ -587,7 +587,7 @@ static int imx412_set_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_VBLANK:
 		imx412->vblank = imx412->vblank_ctrl->val;
 
-		dev_dbg(imx412->dev, "Received vblank %u, new lpfr %u",
+		dev_dbg(imx412->dev, "Received vblank %u, new lpfr %u\n",
 			imx412->vblank,
 			imx412->vblank + imx412->cur_mode->height);
 
@@ -606,7 +606,7 @@ static int imx412_set_ctrl(struct v4l2_ctrl *ctrl)
 		exposure = ctrl->val;
 		analog_gain = imx412->again_ctrl->val;
 
-		dev_dbg(imx412->dev, "Received exp %u, analog gain %u",
+		dev_dbg(imx412->dev, "Received exp %u, analog gain %u\n",
 			exposure, analog_gain);
 
 		ret = imx412_update_exp_gain(imx412, exposure, analog_gain);
@@ -615,7 +615,7 @@ static int imx412_set_ctrl(struct v4l2_ctrl *ctrl)
 
 		break;
 	default:
-		dev_err(imx412->dev, "Invalid control %d", ctrl->id);
+		dev_err(imx412->dev, "Invalid control %d\n", ctrl->id);
 		ret = -EINVAL;
 	}
 
@@ -796,14 +796,14 @@ static int imx412_start_streaming(struct imx412 *imx412)
 	ret = imx412_write_regs(imx412, reg_list->regs,
 				reg_list->num_of_regs);
 	if (ret) {
-		dev_err(imx412->dev, "fail to write initial registers");
+		dev_err(imx412->dev, "fail to write initial registers\n");
 		return ret;
 	}
 
 	/* Setup handler will write actual exposure and gain */
 	ret =  __v4l2_ctrl_handler_setup(imx412->sd.ctrl_handler);
 	if (ret) {
-		dev_err(imx412->dev, "fail to setup handler");
+		dev_err(imx412->dev, "fail to setup handler\n");
 		return ret;
 	}
 
@@ -814,7 +814,7 @@ static int imx412_start_streaming(struct imx412 *imx412)
 	ret = imx412_write_reg(imx412, IMX412_REG_MODE_SELECT,
 			       1, IMX412_MODE_STREAMING);
 	if (ret) {
-		dev_err(imx412->dev, "fail to start streaming");
+		dev_err(imx412->dev, "fail to start streaming\n");
 		return ret;
 	}
 
@@ -895,7 +895,7 @@ static int imx412_detect(struct imx412 *imx412)
 		return ret;
 
 	if (val != IMX412_ID) {
-		dev_err(imx412->dev, "chip id mismatch: %x!=%x",
+		dev_err(imx412->dev, "chip id mismatch: %x!=%x\n",
 			IMX412_ID, val);
 		return -ENXIO;
 	}
@@ -927,7 +927,7 @@ static int imx412_parse_hw_config(struct imx412 *imx412)
 	imx412->reset_gpio = devm_gpiod_get_optional(imx412->dev, "reset",
 						     GPIOD_OUT_LOW);
 	if (IS_ERR(imx412->reset_gpio)) {
-		dev_err(imx412->dev, "failed to get reset gpio %ld",
+		dev_err(imx412->dev, "failed to get reset gpio %ld\n",
 			PTR_ERR(imx412->reset_gpio));
 		return PTR_ERR(imx412->reset_gpio);
 	}
@@ -935,13 +935,13 @@ static int imx412_parse_hw_config(struct imx412 *imx412)
 	/* Get sensor input clock */
 	imx412->inclk = devm_clk_get(imx412->dev, NULL);
 	if (IS_ERR(imx412->inclk)) {
-		dev_err(imx412->dev, "could not get inclk");
+		dev_err(imx412->dev, "could not get inclk\n");
 		return PTR_ERR(imx412->inclk);
 	}
 
 	rate = clk_get_rate(imx412->inclk);
 	if (rate != IMX412_INCLK_RATE) {
-		dev_err(imx412->dev, "inclk frequency mismatch");
+		dev_err(imx412->dev, "inclk frequency mismatch\n");
 		return -EINVAL;
 	}
 
@@ -956,14 +956,14 @@ static int imx412_parse_hw_config(struct imx412 *imx412)
 
 	if (bus_cfg.bus.mipi_csi2.num_data_lanes != IMX412_NUM_DATA_LANES) {
 		dev_err(imx412->dev,
-			"number of CSI2 data lanes %d is not supported",
+			"number of CSI2 data lanes %d is not supported\n",
 			bus_cfg.bus.mipi_csi2.num_data_lanes);
 		ret = -EINVAL;
 		goto done_endpoint_free;
 	}
 
 	if (!bus_cfg.nr_of_link_frequencies) {
-		dev_err(imx412->dev, "no link frequencies defined");
+		dev_err(imx412->dev, "no link frequencies defined\n");
 		ret = -EINVAL;
 		goto done_endpoint_free;
 	}
@@ -1014,7 +1014,7 @@ static int imx412_power_on(struct device *dev)
 
 	ret = clk_prepare_enable(imx412->inclk);
 	if (ret) {
-		dev_err(imx412->dev, "fail to enable inclk");
+		dev_err(imx412->dev, "fail to enable inclk\n");
 		goto error_reset;
 	}
 
@@ -1120,7 +1120,7 @@ static int imx412_init_controls(struct imx412 *imx412)
 		imx412->hblank_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	if (ctrl_hdlr->error) {
-		dev_err(imx412->dev, "control init failed: %d",
+		dev_err(imx412->dev, "control init failed: %d\n",
 			ctrl_hdlr->error);
 		v4l2_ctrl_handler_free(ctrl_hdlr);
 		return ctrl_hdlr->error;
@@ -1153,7 +1153,7 @@ static int imx412_probe(struct i2c_client *client)
 
 	ret = imx412_parse_hw_config(imx412);
 	if (ret) {
-		dev_err(imx412->dev, "HW configuration is not supported");
+		dev_err(imx412->dev, "HW configuration is not supported\n");
 		return ret;
 	}
 
@@ -1161,14 +1161,14 @@ static int imx412_probe(struct i2c_client *client)
 
 	ret = imx412_power_on(imx412->dev);
 	if (ret) {
-		dev_err(imx412->dev, "failed to power-on the sensor");
+		dev_err(imx412->dev, "failed to power-on the sensor\n");
 		goto error_mutex_destroy;
 	}
 
 	/* Check module identity */
 	ret = imx412_detect(imx412);
 	if (ret) {
-		dev_err(imx412->dev, "failed to find sensor: %d", ret);
+		dev_err(imx412->dev, "failed to find sensor: %d\n", ret);
 		goto error_power_off;
 	}
 
@@ -1178,7 +1178,7 @@ static int imx412_probe(struct i2c_client *client)
 
 	ret = imx412_init_controls(imx412);
 	if (ret) {
-		dev_err(imx412->dev, "failed to init controls: %d", ret);
+		dev_err(imx412->dev, "failed to init controls: %d\n", ret);
 		goto error_power_off;
 	}
 
@@ -1190,14 +1190,14 @@ static int imx412_probe(struct i2c_client *client)
 	imx412->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&imx412->sd.entity, 1, &imx412->pad);
 	if (ret) {
-		dev_err(imx412->dev, "failed to init entity pads: %d", ret);
+		dev_err(imx412->dev, "failed to init entity pads: %d\n", ret);
 		goto error_handler_free;
 	}
 
 	ret = v4l2_async_register_subdev_sensor(&imx412->sd);
 	if (ret < 0) {
 		dev_err(imx412->dev,
-			"failed to register async subdev: %d", ret);
+			"failed to register async subdev: %d\n", ret);
 		goto error_media_entity;
 	}
 
-- 
2.39.5



