Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590566;
	b=dgMlK82oAdhr+k/xL9hYdbRHovndKz06MasK1U9qqVhyVEyQWW+WxT6WvqdSMAjsZxFh
	 8VEZbB8pCSDDvw76InqlOuT6Yk0mOED1wt25grRCjyd2YXUALFwmQZD7MT1qhJkulELvk
	 7Zwf40dGBUih0UhP31ThCro/WAY1nGSGjj7u/fh4hsohbMSNHJ+6BSmrIl9gDs5rotNBl
	 S48tUc9JvfVvekPVZwjVDrFmKX3wpIPW50mg78/efrYwSzZkop9y7lp32Qk5xaHF33ojQ
	 XVyvTLJDqUEFasIwp17LouX9PJLEmj4jX12SAwgsvJ90d0Iq+ZoKFD4cxN2CN+ahD1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IBWziDasOJSfKTsFJcUoOLMKvAzkB54lCoy/Q7xsmfI=;
	b=w0PdulQ0S9jQPs3+4Ku1Agp1hEaDb6pvU/qlZQrtue0ZgowB3qlajcIBuE0qfWBdqQMz
	 Ow7gKPnfRRwR/ZhJ1UlCBI2NYSkQ5OUplREemPA4nDylUKzGEsUmgiJJOVDdIS5k0GxaB
	 QwRwa/kyHm+IZj1YL1PWz9zUgkeDb909XsegzDeGvak3I51klcOZFTBdRVOi3MauTEm6b
	 m5aLODYfW1wLs/lMeuFr+eO+mSy1HFhznsMfXkYhWZW2QCAZ9duWAuFyDmHyPCNOXmyKQ
	 58HjB3lSXYeIBDmnkgGyR9kD+uXUc459OfX2bnkZKkAEH6lZaTnB0fRmAmh72g5N2Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OzXDMaGP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0202606BD1A;
	Fri, 13 Nov 2026 17:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OzXDMaGP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6841F000C4;
	Fri, 13 Nov 2026 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590566;
	bh=IBWziDasOJSfKTsFJcUoOLMKvAzkB54lCoy/Q7xsmfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OzXDMaGPm97xRNn+wZoSCdSaWJO3UQMa4P8ehHobRqludrIvsEMnyy9zpxOPugAat
	 2NII9kAxd7PdAZgjYHq9bVa+ii5vIcvoiWmDObFcGLCCoz/SNmjp2IbxFxJs8YBUqy
	 vXBKvGTlnrvB+mJJN0mzBDqbyQpiEKQsoj+VYiAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/686] media: imx219: Account rate_factor in setting upper exposure limit
Date: Fri, 13 Nov 2026 10:50:33 -0500
Message-ID: <20261113153837.856806320@linuxfoundation.org>
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
Stable-dep-of: 57043aef0a04 ("media: imx219: Account for rate_factor in control steps")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 4160a482fdce3..87c4d8942135c 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -462,7 +462,8 @@ static int imx219_set_ctrl(struct v4l2_ctrl *ctrl)
 		int exposure_max, exposure_def;
 
 		/* Update max exposure while meeting expected vblanking */
-		exposure_max = format->height + ctrl->val - IMX219_EXPOSURE_OFFSET;
+		exposure_max = format->height + ctrl->val -
+			IMX219_EXPOSURE_OFFSET * rate_factor;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
 				exposure_max : IMX219_EXPOSURE_DEFAULT;
 		ret = __v4l2_ctrl_modify_range(imx219->exposure,
@@ -895,6 +896,7 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 	crop->top = (IMX219_NATIVE_HEIGHT - crop->height) / 2;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		int rate_factor = imx219_get_rate_factor(state);
 		int exposure_max;
 		int exposure_def;
 		int hblank, llp_min;
@@ -913,7 +915,8 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
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



