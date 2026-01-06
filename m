Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D49357A43;
	Tue,  6 Jan 2026 17:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721536; cv=none; b=UGxI3sehJxl2f+Q70p7iksjpx16aFgP5zsqvhCP3m6su0yr//Bm5LVapzoxKzNqTi+MTyZfdTnZSVRQzUzT5lhr+TZBSnSstfC7hL7SJZffLyDyxdrZaBVYupth+cqsFEarvAj5KJYyifZ5YjNPN24sEjoEAG2MLpUBdhv0lnN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721536; c=relaxed/simple;
	bh=3Oz+5bJei+IDh4rKU+hxWH+SdcHUmd/KRt/dZMyqHyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCihX9bq8Ve20heJmNezIrP8LDqMjboawMrE2TfSl0FJ+pfDDGDChDj8G8t6YT3spyRb8dImnUb4sir7TzdQUn7B7mfinvXlGZ4k2Z7B26AFwciKsiKyBcDdfxxBdrhm7B6DEYOY79xZL5Qnov5m46/QdGtaTNEHTpTIfSfv1cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUoqjpxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUoqjpxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16072C16AAE;
	Tue,  6 Jan 2026 17:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721536;
	bh=3Oz+5bJei+IDh4rKU+hxWH+SdcHUmd/KRt/dZMyqHyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUoqjpxMf43sWhOUAHEp+AGt4tiPvr8TSnooRmLFFqNAjES4KLXO4/DBAKWWVP0KN
	 DnMS4z4PJ+F6GlHYu3Q05SE8kWAHz9sbjg8BBgq1IZnymHPXb9s9rsZNiMwhCQ6mxk
	 aP71zDeWmos4Sz1spLpKu/u/zAYa+85/NcNSFP1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Jai Luthra <jai.luthra@ideasonboard.com>
Subject: [PATCH 6.12 533/567] media: i2c: imx219: Fix 1920x1080 mode to use 1:1 pixel aspect ratio
Date: Tue,  6 Jan 2026 18:05:15 +0100
Message-ID: <20260106170511.113096065@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -843,7 +843,7 @@ static int imx219_set_pad_format(struct
 	const struct imx219_mode *mode;
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
-	unsigned int bin_h, bin_v;
+	unsigned int bin_h, bin_v, binning;
 
 	mode = v4l2_find_nearest_size(supported_modes,
 				      ARRAY_SIZE(supported_modes),
@@ -862,9 +862,12 @@ static int imx219_set_pad_format(struct
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
 


