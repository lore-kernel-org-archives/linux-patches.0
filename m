Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4414F390C;
	Thu, 17 Sep 2026 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660887; cv=none; b=qUN/ZOES89vvlozOVGUAPy3R2DpjOiivkwFf+UtJ3Y4g8J1MIeQHvjdm06nlQdxE3277jSZR3kHT/2UNZ/eDvBFGiiHz+iPdHmX3M1eZ+7hO4MaUVC8ot2i0aC8IIYm7uiTmq5gRY/fJNe7cp0BfG5NR/zQzBjiwcW+GSgbk32U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660887; c=relaxed/simple;
	bh=IF42xKeass/FiF13JaauV/dTPWa8ER+JnDjzQXmGFUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZjtPNBgnRl5GBruGhqoXhWr35vNHHLej13DEjz1lMnYUgksENG8ZFYfqjAO1c5i8+UnAzOOqI9VGQeW7TLf1ziqU+VLLRn6WFGwAU65FfWPBbvLtwz+WOWYJbUBKUXBFcKWGPttJj81P80lYqWoBJ0GnJYznflHM1JYgB0X9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g91FoRhG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g91FoRhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA1E1F000FF;
	Thu, 17 Sep 2026 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660885;
	bh=uR4elCL+8J44bcnOIk2uO1eRSUI6d7sklSZV/UNbSS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g91FoRhGkLd5TmXRPrYHxeqCStFd6BGai7MWE4hW4mPx5czfzUX/lrJ1qGOXUopuQ
	 brcKdpgdmj2UydKBSYYcB/IMST2EcbkwuKjdlJHIviVh5UWqmrGhg/AyCkag66SUz7
	 6GSl7C/W8eCzvafCfLq/y9El1scnqPjMsXeriZdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 699/733] media: remove conditional return with no effect
Date: Thu, 17 Sep 2026 16:16:47 +0100
Message-ID: <20260917151410.267057610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 9508676ad8562368bb1aa7d1991fbd50611ddacb ]

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: f87d7eda07fc ("media: qcom: iris: fix runtime PM reference leaks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/mt9p031.c                              |    6 +-----
 drivers/media/platform/microchip/microchip-sama7g5-isc.c |    7 +------
 drivers/media/platform/qcom/iris/iris_resources.c        |    6 +-----
 drivers/media/platform/qcom/venus/pm_helpers.c           |    7 +------
 drivers/media/platform/renesas/rcar-csi2.c               |    6 +-----
 drivers/media/platform/samsung/s3c-camif/camif-core.c    |    7 +------
 drivers/media/usb/dvb-usb-v2/mxl111sf.c                  |   12 ++----------
 drivers/media/usb/gspca/jl2005bcd.c                      |    7 +------
 8 files changed, 9 insertions(+), 49 deletions(-)

--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -452,11 +452,7 @@ static int mt9p031_set_params(struct mt9
 	ret = mt9p031_write(client, MT9P031_HORIZONTAL_BLANK, hblank - 1);
 	if (ret < 0)
 		return ret;
-	ret = mt9p031_write(client, MT9P031_VERTICAL_BLANK, vblank - 1);
-	if (ret < 0)
-		return ret;
-
-	return ret;
+	return mt9p031_write(client, MT9P031_VERTICAL_BLANK, vblank - 1);
 }
 
 static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -598,13 +598,8 @@ static int __maybe_unused xisc_runtime_s
 static int __maybe_unused xisc_runtime_resume(struct device *dev)
 {
 	struct isc_device *isc = dev_get_drvdata(dev);
-	int ret;
 
-	ret = clk_prepare_enable(isc->hclock);
-	if (ret)
-		return ret;
-
-	return ret;
+	return clk_prepare_enable(isc->hclock);
 }
 
 static const struct dev_pm_ops microchip_xisc_dev_pm_ops = {
--- a/drivers/media/platform/qcom/iris/iris_resources.c
+++ b/drivers/media/platform/qcom/iris/iris_resources.c
@@ -78,11 +78,7 @@ int iris_enable_power_domains(struct iri
 	if (ret)
 		return ret;
 
-	ret = pm_runtime_get_sync(pd_dev);
-	if (ret < 0)
-		return ret;
-
-	return ret;
+	return pm_runtime_get_sync(pd_dev);
 }
 
 int iris_disable_power_domains(struct iris_core *core, struct device *pd_dev)
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -781,7 +781,6 @@ static int decide_core(struct venus_inst
 	unsigned long max_freq = ULONG_MAX;
 	struct device *dev = core->dev;
 	struct dev_pm_opp *opp;
-	int ret = 0;
 
 	if (legacy_binding) {
 		if (inst->session_type == VIDC_SESSION_TYPE_DEC)
@@ -829,11 +828,7 @@ static int decide_core(struct venus_inst
 	}
 
 done:
-	ret = hfi_session_set_property(inst, ptype, &cu);
-	if (ret)
-		return ret;
-
-	return ret;
+	return hfi_session_set_property(inst, ptype, &cu);
 }
 
 static int acquire_core(struct venus_inst *inst)
--- a/drivers/media/platform/renesas/rcar-csi2.c
+++ b/drivers/media/platform/renesas/rcar-csi2.c
@@ -2273,11 +2273,7 @@ static int rcsi2_init_phtw_v3u(struct rc
 			return ret;
 	}
 
-	ret = rcsi2_phtw_write_array(priv, step4, ARRAY_SIZE(step4));
-	if (ret)
-		return ret;
-
-	return ret;
+	return rcsi2_phtw_write_array(priv, step4, ARRAY_SIZE(step4));
 }
 
 /* -----------------------------------------------------------------------------
--- a/drivers/media/platform/samsung/s3c-camif/camif-core.c
+++ b/drivers/media/platform/samsung/s3c-camif/camif-core.c
@@ -302,7 +302,6 @@ static int camif_media_dev_init(struct c
 	struct media_device *md = &camif->media_dev;
 	struct v4l2_device *v4l2_dev = &camif->v4l2_dev;
 	unsigned int ip_rev = camif->variant->ip_revision;
-	int ret;
 
 	memset(md, 0, sizeof(*md));
 	snprintf(md->model, sizeof(md->model), "Samsung S3C%s CAMIF",
@@ -317,11 +316,7 @@ static int camif_media_dev_init(struct c
 
 	media_device_init(md);
 
-	ret = v4l2_device_register(camif->dev, v4l2_dev);
-	if (ret < 0)
-		return ret;
-
-	return ret;
+	return v4l2_device_register(camif->dev, v4l2_dev);
 }
 
 static void camif_clk_put(struct camif_dev *camif)
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -987,11 +987,7 @@ static int mxl111sf_frontend_attach_atsc
 	if (ret < 0)
 		return ret;
 
-	ret = mxl111sf_lg2160_frontend_attach(adap, 2);
-	if (ret < 0)
-		return ret;
-
-	return ret;
+	return mxl111sf_lg2160_frontend_attach(adap, 2);
 }
 
 static int mxl111sf_frontend_attach_mercury(struct dvb_usb_adapter *adap)
@@ -1007,11 +1003,7 @@ static int mxl111sf_frontend_attach_merc
 	if (ret < 0)
 		return ret;
 
-	ret = mxl111sf_lg2161_ep6_frontend_attach(adap, 2);
-	if (ret < 0)
-		return ret;
-
-	return ret;
+	return mxl111sf_lg2161_ep6_frontend_attach(adap, 2);
 }
 
 static int mxl111sf_frontend_attach_mercury_mh(struct dvb_usb_adapter *adap)
--- a/drivers/media/usb/gspca/jl2005bcd.c
+++ b/drivers/media/usb/gspca/jl2005bcd.c
@@ -148,17 +148,12 @@ static int jl2005c_start_new_frame(struc
 static int jl2005c_write_reg(struct gspca_dev *gspca_dev, unsigned char reg,
 						    unsigned char value)
 {
-	int retval;
 	u8 instruction[2];
 
 	instruction[0] = reg;
 	instruction[1] = value;
 
-	retval = jl2005c_write2(gspca_dev, instruction);
-	if (retval < 0)
-			return retval;
-
-	return retval;
+	return jl2005c_write2(gspca_dev, instruction);
 }
 
 static int jl2005c_get_firmware_id(struct gspca_dev *gspca_dev)


