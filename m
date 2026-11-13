Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590565;
	b=myQsXdFe/4U0vNB12jK7C5jtYEWA8DXPzCuV1cPJdu9RIfHvAthQpZ5wDtpCb9OjcAev
	 3rF4cd9T84+BQZXai3WDgCjcUpKYpYrMnFm6ScTyEHeGCjUEUkKfgzpOTwkxcfHtZYusb
	 4937lSUv6ry5+zZ1xr0D+i5gIXpBTBgAx3FP2IIMtDUUqRxGatf8X4IpMonquM5zuGN/q
	 Enrazb964Go1/lu2FRgrpSt3caMbyNvn29d64mIrUmos1g0wI60i7H1SXiFZBMj29kWd6
	 COKpspi5K2QlmLBgFsvs7P5aAAW4CL3c9kpSyz0Hpxq1z5e6nZ+NHNMwNggvYMWJqCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9uXZEyt0SIsJ4WoHOz/LvuCrsqHHVJ6NByOASj1rJwo=;
	b=V1nvTheyV1RqnJo6mzlwlSRM19W+1SibsJaD6nAKxLTacVEtzs3D6I8ZzdljuBicnUgi
	 1zBkU7EZ/EFALqcwFrjzT0nVXIlzETnpFT4QySsb8MKdsayvv/cWEEOXCx9/fZIzI/KG8
	 Ta7mGYG0L082x5+oI2qq2w+W29j1MSypheYvIHpKQckehzGnoWrq9lbw+nX9qgr17CCqy
	 kI9o53piZF9dYnJwj0o5U3kpzpdcv33P23SWvMMoBlLp6D3lTehvgLP3b0crMiXVeD5g4
	 7XGNVZ5JrLh5lx6dqN4dcUS/isEvQK5i3FnDQHwuC6hPIRWiKgzSG84p6n7fcpcB5CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3OfRvSK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C74606BD06;
	Fri, 13 Nov 2026 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3OfRvSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556941F000C4;
	Fri, 13 Nov 2026 17:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590565;
	bh=9uXZEyt0SIsJ4WoHOz/LvuCrsqHHVJ6NByOASj1rJwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3OfRvSKd552Q/yqzU2Eaw1WD9JglzaEjf7g7NS6j3DiX80BojzmnAIZDfwyNylyj
	 FMTuEQ79lidAn7x26JzvMnYaDinAi/lpaJ4Ui/NZR6X2oChrBojVjnqHMj38zXZ70h
	 os63vyqQrQk7Cs84qUrXehOqQqtvqnxwXI+MczVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarang Raval <tarang.raval@siliconsignals.io>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 499/686] media: i2c: imx219: Replace exposure magic value with named constant
Date: Fri, 13 Nov 2026 10:50:32 -0500
Message-ID: <20261113153837.826324474@linuxfoundation.org>
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

[ Upstream commit 9a9ba098e7ba6b89efaddeabf0716a84a0f54c99 ]

Introduce IMX219_EXPOSURE_OFFSET (4) and use it instead of the literal
'4' when computing the maximum coarse exposure. The IMX219 datasheet
specifies the maximum storage time as frame_length_lines - 4.
(Ref: Datasheet section 5-7-1)

Also fix one indentation issue for consistency.

Signed-off-by: Tarang Raval <tarang.raval@siliconsignals.io>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: 57043aef0a04 ("media: imx219: Account for rate_factor in control steps")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 76e65cedbb32f..4160a482fdce3 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -68,6 +68,7 @@
 #define IMX219_EXPOSURE_STEP		1
 #define IMX219_EXPOSURE_DEFAULT		0x640
 #define IMX219_EXPOSURE_MAX		65535
+#define IMX219_EXPOSURE_OFFSET			4
 
 /* V_TIMING internal */
 #define IMX219_REG_FRM_LENGTH_A		CCI_REG16(0x0160)
@@ -461,9 +462,9 @@ static int imx219_set_ctrl(struct v4l2_ctrl *ctrl)
 		int exposure_max, exposure_def;
 
 		/* Update max exposure while meeting expected vblanking */
-		exposure_max = format->height + ctrl->val - 4;
+		exposure_max = format->height + ctrl->val - IMX219_EXPOSURE_OFFSET;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
-			exposure_max : IMX219_EXPOSURE_DEFAULT;
+				exposure_max : IMX219_EXPOSURE_DEFAULT;
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
 					       imx219->exposure->minimum,
 					       exposure_max,
@@ -591,9 +592,9 @@ static int imx219_init_controls(struct imx219 *imx219)
 					   IMX219_LLP_MAX - mode->width,
 					   IMX219_LLP_STEP,
 					   IMX219_LLP_MIN - mode->width);
-	exposure_max = mode->fll_def - 4;
+	exposure_max = mode->fll_def - IMX219_EXPOSURE_OFFSET;
 	exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
-		exposure_max : IMX219_EXPOSURE_DEFAULT;
+			exposure_max : IMX219_EXPOSURE_DEFAULT;
 	imx219->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
 					     V4L2_CID_EXPOSURE,
 					     IMX219_EXPOSURE_MIN, exposure_max,
@@ -912,9 +913,9 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 			return ret;
 
 		/* Update max exposure while meeting expected vblanking */
-		exposure_max = mode->fll_def - 4;
+		exposure_max = mode->fll_def - IMX219_EXPOSURE_OFFSET;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
-			exposure_max : IMX219_EXPOSURE_DEFAULT;
+				exposure_max : IMX219_EXPOSURE_DEFAULT;
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
 					       imx219->exposure->minimum,
 					       exposure_max,
-- 
2.53.0



