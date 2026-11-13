Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590547;
	b=uE86cT0Xa+v57Jo//8oZhlwTB5zvR77SiZF3ZiZZuwAR1bP5z+fq7N4ynMrf9qfKjz0D
	 ZqzbU3XO34LKcA56v90gJdOHsnLdZJZ1QXbjIryPGpl/nckdtarquUAquDNEdk/eos6c/
	 zYRLvhbjTP41hIG013IUnrwgcTYV02ssTKqWudWRkD/wjfy5gD8g3DymXPCPgPyYOLmh6
	 rRgq9I3c5ZtzLqfks9pnU8Rlt+X6Lg5W3ts6ucgWc+xj09Sfco2giRsAjsUJ0k60bJVR4
	 lxfbWluR+edEG3qJZMiunY0/hFUF5DXtART40VqkWJ6I06AIWlxiemKyOTU2Vj4jDyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xHjsDUBfML0cbnap/+dHOhEuxJp4OL6nK7iMYyepDWs=;
	b=dDLc1iYjziRC6v+w4k71WkTnzZqecVP3azGT1f8xUuK+SNSBUVpTCN3VOqeZCvnuXBna
	 fLnY8Ny23PMlbHSXwwA7OTxzwi81E+pe6iF8ly8RiYGF2BM7cBPXTOuXSD+2cWd6m1kMA
	 di/F1LIv8V7dyYAAeUDryGnx6/OjTz3d6aOL55yKtdIXJXDST2cv/qNSmdJiapQL9xw4A
	 WQxB7LlJMMQKxId4pLsDXv0UPC5vAYjpDNpvGn4bWhn+EM3LLdOafSMmXYekKQZc5cKFV
	 s1DiKOmNPpUKLIbfs11h6qqu19zCCHsRiMIlw/sYB7JOemZW4O0GDxFF5qm3Wc81t/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sefGxYwg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E71A6074B17;
	Fri, 13 Nov 2026 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sefGxYwg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1145B1F000C7;
	Fri, 13 Nov 2026 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590547;
	bh=xHjsDUBfML0cbnap/+dHOhEuxJp4OL6nK7iMYyepDWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sefGxYwghGWLZoPFTYoB6uVL9e+X0mQWCeSlCWwCkmy0ran9gcMPbPo7fhnMiMpY4
	 ePS0dt/eqdC/4F23thp+RxTqKSSTenlhAlae3Ld1oMuwHl+rQqKpViVtJGmuoUr969
	 5WkXdRjg0s+LK5yi7VYMnPPasPzfe+KCN/PJEjUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarang Raval <tarang.raval@siliconsignals.io>,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 485/686] media: i2c: imx219: Propagate errors from control range updates
Date: Fri, 13 Nov 2026 10:50:18 -0500
Message-ID: <20261113153837.390315281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tarang Raval <tarang.raval@siliconsignals.io>

[ Upstream commit dff10c7044e8777bd14bba99444ff8a69d9bb2fe ]

Propagate return values from __v4l2_ctrl_modify_range() and
__v4l2_ctrl_s_ctrl() in imx219_set_ctrl() and imx219_set_pad_format().
This ensures proper error handling instead of ignoring possible
failures. Also return the result of imx219_set_pad_format() from
imx219_init_state().

Signed-off-by: Tarang Raval <tarang.raval@siliconsignals.io>
Reviewed-by: Isaac Scott <isaac.scott@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: 47576c541e9b ("media: imx219: The horizontal blanking step is 8")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 61 +++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 00aec91e3d499..ffb04a56419ad 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -463,10 +463,14 @@ static int imx219_set_ctrl(struct v4l2_ctrl *ctrl)
 		exposure_max = format->height + ctrl->val - 4;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
 			exposure_max : IMX219_EXPOSURE_DEFAULT;
-		__v4l2_ctrl_modify_range(imx219->exposure,
-					 imx219->exposure->minimum,
-					 exposure_max, imx219->exposure->step,
-					 exposure_def);
+		ret = __v4l2_ctrl_modify_range(imx219->exposure,
+					       imx219->exposure->minimum,
+					       exposure_max,
+					       imx219->exposure->step,
+					       exposure_def);
+		if (ret)
+			return ret;
+
 	}
 
 	/*
@@ -858,6 +862,7 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 	struct v4l2_rect *crop;
 	u8 bin_h, bin_v, binning;
 	u32 prev_line_len;
+	int ret;
 
 	format = v4l2_subdev_state_get_format(state, 0);
 	prev_line_len = format->width + imx219->hblank->val;
@@ -893,19 +898,28 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 		int pixel_rate;
 
 		/* Update limits and set FPS to default */
-		__v4l2_ctrl_modify_range(imx219->vblank, IMX219_VBLANK_MIN,
-					 IMX219_FLL_MAX - mode->height, 1,
+		ret = __v4l2_ctrl_modify_range(imx219->vblank, IMX219_VBLANK_MIN,
+					       IMX219_FLL_MAX - mode->height, 1,
+					       mode->fll_def - mode->height);
+		if (ret)
+			return ret;
+
+		ret = __v4l2_ctrl_s_ctrl(imx219->vblank,
 					 mode->fll_def - mode->height);
-		__v4l2_ctrl_s_ctrl(imx219->vblank,
-				   mode->fll_def - mode->height);
+		if (ret)
+			return ret;
+
 		/* Update max exposure while meeting expected vblanking */
 		exposure_max = mode->fll_def - 4;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
 			exposure_max : IMX219_EXPOSURE_DEFAULT;
-		__v4l2_ctrl_modify_range(imx219->exposure,
-					 imx219->exposure->minimum,
-					 exposure_max, imx219->exposure->step,
-					 exposure_def);
+		ret = __v4l2_ctrl_modify_range(imx219->exposure,
+					       imx219->exposure->minimum,
+					       exposure_max,
+					       imx219->exposure->step,
+					       exposure_def);
+		if (ret)
+			return ret;
 
 		/*
 		 * With analog binning the default minimum line length of 3448
@@ -916,9 +930,12 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 		imx219_get_binning(state, &bin_h, &bin_v);
 		llp_min = (bin_h & bin_v) == IMX219_BINNING_X2_ANALOG ?
 				  IMX219_BINNED_LLP_MIN : IMX219_LLP_MIN;
-		__v4l2_ctrl_modify_range(imx219->hblank, llp_min - mode->width,
-					 IMX219_LLP_MAX - mode->width, 1,
-					 llp_min - mode->width);
+		ret = __v4l2_ctrl_modify_range(imx219->hblank,
+					       llp_min - mode->width,
+					       IMX219_LLP_MAX - mode->width, 1,
+					       llp_min - mode->width);
+		if (ret)
+			return ret;
 		/*
 		 * Retain PPL setting from previous mode so that the
 		 * line time does not change on a mode change.
@@ -927,13 +944,17 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 		 * mode width subtracted.
 		 */
 		hblank = prev_line_len - mode->width;
-		__v4l2_ctrl_s_ctrl(imx219->hblank, hblank);
+		ret = __v4l2_ctrl_s_ctrl(imx219->hblank, hblank);
+		if (ret)
+			return ret;
 
 		/* Scale the pixel rate based on the mode specific factor */
 		pixel_rate = imx219_get_pixel_rate(imx219) *
 			     imx219_get_rate_factor(state);
-		__v4l2_ctrl_modify_range(imx219->pixel_rate, pixel_rate,
-					 pixel_rate, 1, pixel_rate);
+		ret = __v4l2_ctrl_modify_range(imx219->pixel_rate, pixel_rate,
+					       pixel_rate, 1, pixel_rate);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -982,9 +1003,7 @@ static int imx219_init_state(struct v4l2_subdev *sd,
 		},
 	};
 
-	imx219_set_pad_format(sd, state, &fmt);
-
-	return 0;
+	return imx219_set_pad_format(sd, state, &fmt);
 }
 
 static const struct v4l2_subdev_video_ops imx219_video_ops = {
-- 
2.53.0



