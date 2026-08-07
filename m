Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CEE31327A;
	Fri,  7 Aug 2026 15:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116440; cv=none; b=mKlYCdgTtOCOlKIospv5UZLlW9PmEWZvGd05wpO1mvxduzZ8s8ivzQZRF1HMUoHcG9XK9THMsARuBtS+QRNshax6G0eqDQlT6sCKrV8ZJaWpev8TgXcB9rdGBNg1mVK5Y8ZilIsNqD+s4P/Wm0AEBGi+phpoC2M0QFM567xFrz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116440; c=relaxed/simple;
	bh=DsqCN3yvF/uKOIFyJExSidAz1h+8WqHuAL/Odc5xpDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGcyPtIa2YsWUV44oGqLHDZoSwNcUOhnR/N8NXhY3AB/o/uDBAsX/JsyJ96GheCm8SGmKfPvDflB3klX80ZHEUaQPIiLwd/rcRlCivaMUGU4qa7pAEDpEHqjKJNk36o/nHCjqPsKkuKHa1pHSRoe3b1jJtUKAO4n0bp/yva6zu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvELqBQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvELqBQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCBF1F000E9;
	Fri,  7 Aug 2026 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116439;
	bh=vuMehk0qIuJdoxWpczyIIscUywX6isg2uS70erVIxGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvELqBQA2AWppdDH6HLlZZzJht/VZ8AbiIS3hllAW3Vq5W16W1pco5TeYLOHKwX8/
	 Sl80jyhZ8EUjYy6DvcR7Gs5NhRUivv7lQBGvCxIIIvGom9e+6IN61SSKTaOgogy6Rd
	 Ncui+GRRrhGZ/eGfkn34oy8Ni40Bmxfk41EthHLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/261] media: i2c: imx219: Rename VTS to FRM_LENGTH
Date: Fri,  7 Aug 2026 16:39:49 +0200
Message-ID: <20260807143420.381865435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <jai.luthra@ideasonboard.com>

[ Upstream commit 04f78503f99ae7e9887c7fe5e4bc54a7cfb10fe0 ]

The IMX219 datasheet refers to the vertical length + blanking as
FRM_LENGTH instead of VTS.

Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: 2c4f1ba73543 ("media: imx219: Fix maximum frame length in lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -71,9 +71,8 @@
 #define IMX219_EXPOSURE_MAX		65535
 
 /* V_TIMING internal */
-#define IMX219_REG_VTS			CCI_REG16(0x0160)
-#define IMX219_VTS_MAX			0xffff
-
+#define IMX219_REG_FRM_LENGTH_A		CCI_REG16(0x0160)
+#define IMX219_FLL_MAX			0xffff
 #define IMX219_VBLANK_MIN		32
 
 /* HBLANK control - read only */
@@ -163,7 +162,7 @@ struct imx219_mode {
 	unsigned int height;
 
 	/* V-timing */
-	unsigned int vts_def;
+	unsigned int fll_def;
 
 	/* Default register values */
 	struct imx219_reg_list reg_list;
@@ -363,7 +362,7 @@ static const struct imx219_mode supporte
 		/* 8MPix 15fps mode */
 		.width = 3280,
 		.height = 2464,
-		.vts_def = 3526,
+		.fll_def = 3526,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_3280x2464_regs),
 			.regs = mode_3280x2464_regs,
@@ -374,7 +373,7 @@ static const struct imx219_mode supporte
 		/* 1080P 30fps cropped */
 		.width = 1920,
 		.height = 1080,
-		.vts_def = 1763,
+		.fll_def = 1763,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_1920_1080_regs),
 			.regs = mode_1920_1080_regs,
@@ -385,7 +384,7 @@ static const struct imx219_mode supporte
 		/* 2x2 binned 30fps mode */
 		.width = 1640,
 		.height = 1232,
-		.vts_def = 1763,
+		.fll_def = 1763,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_1640_1232_regs),
 			.regs = mode_1640_1232_regs,
@@ -396,7 +395,7 @@ static const struct imx219_mode supporte
 		/* 640x480 30fps mode */
 		.width = 640,
 		.height = 480,
-		.vts_def = 1763,
+		.fll_def = 1763,
 		.reg_list = {
 			.num_of_regs = ARRAY_SIZE(mode_640_480_regs),
 			.regs = mode_640_480_regs,
@@ -518,7 +517,7 @@ static int imx219_set_ctrl(struct v4l2_c
 			  imx219->hflip->val | imx219->vflip->val << 1, &ret);
 		break;
 	case V4L2_CID_VBLANK:
-		cci_write(imx219->regmap, IMX219_REG_VTS,
+		cci_write(imx219->regmap, IMX219_REG_FRM_LENGTH_A,
 			  format->height + ctrl->val, &ret);
 		break;
 	case V4L2_CID_TEST_PATTERN_RED:
@@ -593,15 +592,15 @@ static int imx219_init_controls(struct i
 	/* Initial vblank/hblank/exposure parameters based on current mode */
 	imx219->vblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
 					   V4L2_CID_VBLANK, IMX219_VBLANK_MIN,
-					   IMX219_VTS_MAX - mode->height, 1,
-					   mode->vts_def - mode->height);
+					   IMX219_FLL_MAX - mode->height, 1,
+					   mode->fll_def - mode->height);
 	hblank = IMX219_PPL_DEFAULT - mode->width;
 	imx219->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
 					   V4L2_CID_HBLANK, hblank, hblank,
 					   1, hblank);
 	if (imx219->hblank)
 		imx219->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
-	exposure_max = mode->vts_def - 4;
+	exposure_max = mode->fll_def - 4;
 	exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
 		exposure_max : IMX219_EXPOSURE_DEFAULT;
 	imx219->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
@@ -969,12 +968,12 @@ static int imx219_set_pad_format(struct
 		imx219->mode = mode;
 		/* Update limits and set FPS to default */
 		__v4l2_ctrl_modify_range(imx219->vblank, IMX219_VBLANK_MIN,
-					 IMX219_VTS_MAX - mode->height, 1,
-					 mode->vts_def - mode->height);
+					 IMX219_FLL_MAX - mode->height, 1,
+					 mode->fll_def - mode->height);
 		__v4l2_ctrl_s_ctrl(imx219->vblank,
-				   mode->vts_def - mode->height);
+				   mode->fll_def - mode->height);
 		/* Update max exposure while meeting expected vblanking */
-		exposure_max = mode->vts_def - 4;
+		exposure_max = mode->fll_def - 4;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
 			exposure_max : IMX219_EXPOSURE_DEFAULT;
 		__v4l2_ctrl_modify_range(imx219->exposure,


