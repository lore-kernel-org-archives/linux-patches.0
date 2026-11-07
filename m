Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064015;
	b=0IWN6kIgUBbACshJTj8LxN3KRjFIctMs5ws+ZagjfLNNOD2n2rsRwByN50NhdIDGvMDC
	 W7dR5KBB+B1huMkXxQes1d4iISTk4khihjFjBObf4Bs1ZlnjAq9LP0NtraDCyQyMnKVeC
	 67l15K5FBJgxgAWS2j9XdKnWq6M4dGDphYRx7h7Q1s+Ok7z9Rhb+YS++jgK/gDFPhbnYt
	 dfmR1YDrlqcrZVf+InNC4qE8+w9QVdRTZ3eC4AmZlkNquOlBfjoRzHOH7nHu4u2fqCbMh
	 U2caGtaAcvjx10u1z7M3yi23ayj6q7krRf8Kv7kWh2ZiKGbN6F6VLEKnvCMXjhVTclg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6aMS/ca+vTBvcr+VR5jSkiJyVJ9ZvgeMXTM449mDXpQ=;
	b=QrBfJI7Xp4z5ESY4IMAgqvIOZR4bS/VvHU5MU+zJhN1WkImAfRVhUeYydSUSx8bEIrMv
	 MrO3h29HAKIzuLJr/JUwn9dMNVbXgCsbJN440HfgrH987TaHXtCzc+/YKpaVOdYiplkGA
	 eZU537UuLD2apbnDMD9e0G1NvgBVIDQhNjylrbsBKZNJ3jZQUrFYbiZPzrSJimOsWUkds
	 Y8bD8mlM7TTDMXEw7G/BcA7aRh1k54xP0VJEw/+92iOPqV4W1gkDBP5Biu+Z2z4zt//v9
	 Ju6eN9/ikyR/fLq+eRaBN4vmN1JnPJOz5nqUBcF/f/pHO8FgNsDUmA3jOuS0X1g7RFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7zsqpOY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CA8606A334;
	Sat,  7 Nov 2026 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7zsqpOY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0632F1F0089F;
	Sat,  7 Nov 2026 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064015;
	bh=6aMS/ca+vTBvcr+VR5jSkiJyVJ9ZvgeMXTM449mDXpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7zsqpOY4jF9sNbBLERYsfKtVXta0bkSawOWGa/jQRGO77wXWDkrrNnJBmjJlh9PM
	 HguzsgEnikcWiFzaT/3t9Gde9wKDfDRh/U6wzvByEWevxb9BZf1OeBVulLv0pKhzBA
	 Y8+dEeldejVwqEoFoR3S0ETzoG6cJAuf2Zsh2J0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0193/1257] media: imx219: Account for rate_factor in control steps
Date: Sat,  7 Nov 2026 08:41:29 -0500
Message-ID: <20261107134944.787848353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 57043aef0a04bd96d97881422590e71c1e4c45b1 ]

The controls that are divided by the rate_factor before writing them to
the registers have the step of the value of the rate_factor. Take this
into account when the control's range is modified. The controls are
created in a configuration where rate_factor is always 1, hence there's no
need to change the code adding new controls.

Fixes: f513997119f4 ("media: i2c: imx219: Scale the pixel rate for analog binning")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 5184523de8bed..b1f29037af742 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -340,13 +340,13 @@ static const struct imx219_mode supported_modes[] = {
 		/* 2x2 binned 60fps mode */
 		.width = 1640,
 		.height = 1232,
-		.fll_def = 1707,
+		.fll_def = 1706,
 	},
 	{
 		/* 640x480 60fps mode */
 		.width = 640,
 		.height = 480,
-		.fll_def = 1707,
+		.fll_def = 1706,
 	},
 };
 
@@ -473,8 +473,7 @@ static int imx219_set_ctrl(struct v4l2_ctrl *ctrl)
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
 					       imx219->exposure->minimum,
 					       exposure_max,
-					       imx219->exposure->step,
-					       exposure_def);
+					       rate_factor, exposure_def);
 		if (ret)
 			return ret;
 
@@ -902,7 +901,8 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 
 		/* Update limits and set FPS to default */
 		ret = __v4l2_ctrl_modify_range(imx219->vblank, IMX219_VBLANK_MIN,
-					       IMX219_FLL_MAX - mode->height, 1,
+					       IMX219_FLL_MAX - mode->height,
+					       rate_factor,
 					       mode->fll_def - mode->height);
 		if (ret)
 			return ret;
@@ -920,8 +920,7 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
 					       imx219->exposure->minimum,
 					       exposure_max,
-					       imx219->exposure->step,
-					       exposure_def);
+					       rate_factor, exposure_def);
 		if (ret)
 			return ret;
 
@@ -946,8 +945,7 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 			return ret;
 
 		/* Scale the pixel rate based on the mode specific factor */
-		pixel_rate = imx219_get_pixel_rate(imx219) *
-			     imx219_get_rate_factor(state);
+		pixel_rate = imx219_get_pixel_rate(imx219) * rate_factor;
 		ret = __v4l2_ctrl_modify_range(imx219->pixel_rate, pixel_rate,
 					       pixel_rate, 1, pixel_rate);
 		if (ret)
-- 
2.53.0



