Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064014;
	b=QO22KaktQgUV3C9aqiAt9Ii/l5Thdi3E8cXLH03fx7tKf0HVkiCC7I2D/SHvzZ0TXq3G
	 NmzstT8jKj5a4OTt3ZgUaqz4fsZIIA0IUfd4AhgObzxlfw2Y6Zn/MwuXLH+79tnhN/2FT
	 ouCuqOpPS9l5sk7alZT5FQR94bmRe/h668au7TqSS0vkP9Clw0sUpn+JTX7twHnujRyiH
	 JjEDQQF9xm9st3H7FUXdvaCnTFpvFcwwTfJrDIDN/MFiCp8n/yDMiDCXL1PIwJIL+9mJ6
	 LvuFvwnchgeZ3jEq8WQG4W4CZIB/JAnvNVRtIF29mLZ+MCOikTVu7JwLUaAp3y+zREg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6C1Kp8y7W8wKjK5aPuI0X/dUuveXqMZjEuanX6W28d4=;
	b=X82DVqSy/3h/d7S7JUqWfFJdrSp9/qROJoR0+hCeAEadCiX9ujPP0bcz2BPadxzekvGL
	 PFnNsFEjMIgWzQr89pBge0fu1RM47vP8kSdnNBmblMGYlj5az9RzeYrD9HGho7bs9wTTr
	 gV7tC8I+J55bjXnha/r59BA5y5NQfrR0WBD2iJZiD1KYT4JE4sXn4RwIXel/TfGTasSbq
	 RjnjTTxfWbDDj8mJjG/LwDIIDxfwYrrDrkJcmo1ziXgTvkC7/R4oNAytRBLZDy8YtDqm5
	 jeolY1/uAMBecIK+HGIJEyNG6vHp7ScillDt+7a9CjioFRLBsUkG382Y0Osnx/qHcpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yh2hB2+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD0A606A334;
	Sat,  7 Nov 2026 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yh2hB2+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0E01F008A2;
	Sat,  7 Nov 2026 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064014;
	bh=6C1Kp8y7W8wKjK5aPuI0X/dUuveXqMZjEuanX6W28d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yh2hB2+3coqmkUL2oIWFD7HtQr7LwooH9YkMemZNrgu9F2Fnwi7nq1IZLZrXU6pR1
	 fzN3yjaKr1wN/vmizfdt5pvALIGwTya8WKWwyRox6imdiRRDEQiXV0ezOuYIVl1j81
	 b3ILzn9Tq2F4M7kt+Gq/7c+X7DEc20fL9kJmZ92k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0192/1257] media: imx219: Account rate_factor in setting upper exposure limit
Date: Sat,  7 Nov 2026 08:41:28 -0500
Message-ID: <20261107134944.762344614@linuxfoundation.org>
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

[ Upstream commit db111b66f2db7f3f79d9359f4a9762e832d6fde9 ]

The rate_factor multiplier is used to multiply a few values in the
sensor's timing configuration and the exposure time is one of them. This
also needs to be taken into account in exposure time margin: multiply it
by rate_factor so that sensor's exposure time margin is respected.

Fixes: f513997119f4 ("media: i2c: imx219: Scale the pixel rate for analog binning")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 9571f3622d2d4..5184523de8bed 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -466,7 +466,8 @@ static int imx219_set_ctrl(struct v4l2_ctrl *ctrl)
 		int exposure_max, exposure_def;
 
 		/* Update max exposure while meeting expected vblanking */
-		exposure_max = format->height + ctrl->val - IMX219_EXPOSURE_OFFSET;
+		exposure_max = format->height + ctrl->val -
+			IMX219_EXPOSURE_OFFSET * rate_factor;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
 				exposure_max : IMX219_EXPOSURE_DEFAULT;
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
@@ -893,6 +894,7 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 	crop->top = (IMX219_NATIVE_HEIGHT - crop->height) / 2;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		int rate_factor = imx219_get_rate_factor(state);
 		int exposure_max;
 		int exposure_def;
 		int llp_min;
@@ -911,7 +913,8 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 			return ret;
 
 		/* Update max exposure while meeting expected vblanking */
-		exposure_max = mode->fll_def - IMX219_EXPOSURE_OFFSET;
+		exposure_max = mode->fll_def -
+			IMX219_EXPOSURE_OFFSET * rate_factor;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
 				exposure_max : IMX219_EXPOSURE_DEFAULT;
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
-- 
2.53.0



