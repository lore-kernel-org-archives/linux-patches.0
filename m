Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6AA36BCD0;
	Tue,  6 Jan 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722187; cv=none; b=FFDOZa5A0IC5U/O5yFTp/LvzhbmBYtBGiTM8cwiApUtgdnHKIrJuESJrWnAVwtqHxULw3leN03tHzERcnZHv6YdY4Rl02C4hZ4GXUtriHGDxngh2I4kjg31N3PlXDU29Enb05RgYfYkZW4wHYKANcdO28HOPvkaNPASLhhRrXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722187; c=relaxed/simple;
	bh=wqgfab9O/duJON2dUJo8HgTSnFGz48S1MqVksPKyPMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r05ryGHv2P7LGSMyR5G2vnUGH0PsJj8Mdmf7IQYm+dCom5opbfMYuxTx3szFOU62nhHXSA/Jpc7WoDAwFPwd7uVQLF8CNWHU+yes9Jg2UrglTSeSLL1P+z+wBob0qtmMnZpjGJmezN7XjAFm+cfpH48nh8+z4/eYMy/RLOzLTTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhmN8mOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhmN8mOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2309CC116C6;
	Tue,  6 Jan 2026 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722186;
	bh=wqgfab9O/duJON2dUJo8HgTSnFGz48S1MqVksPKyPMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhmN8mOEqG0NjjGBwhZ2rGM8PpiUb6sTX5q9nZQ6o0Yh+EImOtetGXF5VAP7eJYic
	 HRVcxhtvPHfR1XVcMKGkAXu+37SuFgN8dBsOCmWj6wyZX8OUkOPdefnJsEr9zC1Z1o
	 TjPNFJXR0kRo6tDwWgd6PzBijnDgEb3EApGXn4yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 189/312] media: i2c: imx219: Fix 1920x1080 mode to use 1:1 pixel aspect ratio
Date: Tue,  6 Jan 2026 18:04:23 +0100
Message-ID: <20260106170554.668064376@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

commit 9ef6e4db152c34580cc52792f32485c193945395 upstream.

Commit 0af46fbc333d ("media: i2c: imx219: Calculate crop rectangle
dynamically") meant that the 1920x1080 mode switched from using no
binning to using vertical binning but no horizontal binning, which
resulted in stretched pixels.

Until proper controls are available to independently select horizontal
and vertical binning, restore the original 1:1 pixel aspect ratio by
forcing binning to be uniform in both directions.

Cc: stable@vger.kernel.org
Fixes: 0af46fbc333d ("media: i2c: imx219: Calculate crop rectangle dynamically")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
[Add comment & reword commit message]
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -856,7 +856,7 @@ static int imx219_set_pad_format(struct
 	const struct imx219_mode *mode;
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
-	u8 bin_h, bin_v;
+	u8 bin_h, bin_v, binning;
 	u32 prev_line_len;
 
 	format = v4l2_subdev_state_get_format(state, 0);
@@ -877,9 +877,12 @@ static int imx219_set_pad_format(struct
 	bin_h = min(IMX219_PIXEL_ARRAY_WIDTH / format->width, 2U);
 	bin_v = min(IMX219_PIXEL_ARRAY_HEIGHT / format->height, 2U);
 
+	/* Ensure bin_h and bin_v are same to avoid 1:2 or 2:1 stretching */
+	binning = min(bin_h, bin_v);
+
 	crop = v4l2_subdev_state_get_crop(state, 0);
-	crop->width = format->width * bin_h;
-	crop->height = format->height * bin_v;
+	crop->width = format->width * binning;
+	crop->height = format->height * binning;
 	crop->left = (IMX219_NATIVE_WIDTH - crop->width) / 2;
 	crop->top = (IMX219_NATIVE_HEIGHT - crop->height) / 2;
 


