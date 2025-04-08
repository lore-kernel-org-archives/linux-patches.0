Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959E9268C61;
	Tue,  8 Apr 2025 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111485; cv=none; b=LZdSBbqgw2TBgInEuxpntfG8mk1DKrK5odq1wPe2cvXoSsvrPxSB4C+RRNU2NFcr5rBL5JIPxIeeBWmSHCh7g75CgLs9SoGnEZb7gK5yIObz3pMSXa3I6V3YWDbduWUMutX0jLeF42emOp0kRlsdq0VNLU4kcW3MXv9pTMFfZLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111485; c=relaxed/simple;
	bh=Yly19dBUiA31UeBEVLppCQfSImB3ThC0fyhHGVXtnXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhrlaS2rsnmKTWTzPDIc9xIL/UJ9AyF5rNtNoL6uCl+00Ac9638eVCiD5HdG4SmuFKnnYXe+lbtTrefUyxgAYIZfT49vU2lD5zs3yBRczsYqn2AjusawjyqvcExtUKF96Bcfu2258REPUX9rrA3I/aZalzy6XkJIC4XQ3yxmfq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkQQ4Xkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkQQ4Xkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F45C4CEE5;
	Tue,  8 Apr 2025 11:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111485;
	bh=Yly19dBUiA31UeBEVLppCQfSImB3ThC0fyhHGVXtnXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkQQ4Xkr3uIg92ulWcD02GXbo4XxJrfNOdz5w2ASfXtR+H5gNkMIfy3q9+XgZKEar
	 rc/a9cUb6x+9VE9xuCvgxi8kE+mdcLNvjTJTafEYU4bD88tOwzNZcAEOo4XEJmH6CS
	 1zshP8Ba2dlt6I+PXLGhtvPksNb3hQUIEi3PTc9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 448/731] iio: gts-helper: export iio_gts_get_total_gain()
Date: Tue,  8 Apr 2025 12:45:45 +0200
Message-ID: <20250408104924.697380115@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit dbd2e08ff09fd6bd51215b44474899cc1b7b7a16 ]

Export this function in preparation for the fix in veml6030.c, where the
total gain can be used to ease the calculation of the processed value of
the IIO_LIGHT channel compared to acquiring the scale in NANO.

Suggested-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20250127-veml6030-scale-v3-1-4f32ba03df94@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 22eaca4283b2 ("iio: light: veml6030: fix scale to conform to ABI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-gts-helper.c | 11 ++++++++++-
 include/linux/iio/iio-gts-helper.h    |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-gts-helper.c b/drivers/iio/industrialio-gts-helper.c
index d70ebe3bf7742..d14f3507f34ea 100644
--- a/drivers/iio/industrialio-gts-helper.c
+++ b/drivers/iio/industrialio-gts-helper.c
@@ -950,7 +950,15 @@ int iio_gts_find_gain_time_sel_for_scale(struct iio_gts *gts, int scale_int,
 }
 EXPORT_SYMBOL_NS_GPL(iio_gts_find_gain_time_sel_for_scale, "IIO_GTS_HELPER");
 
-static int iio_gts_get_total_gain(struct iio_gts *gts, int gain, int time)
+/**
+ * iio_gts_get_total_gain - Fetch total gain for given HW-gain and time
+ * @gts:	Gain time scale descriptor
+ * @gain:	HW-gain for which the total gain is searched for
+ * @time:	Integration time for which the total gain is searched for
+ *
+ * Return: total gain on success and -EINVAL on error.
+ */
+int iio_gts_get_total_gain(struct iio_gts *gts, int gain, int time)
 {
 	const struct iio_itime_sel_mul *itime;
 
@@ -966,6 +974,7 @@ static int iio_gts_get_total_gain(struct iio_gts *gts, int gain, int time)
 
 	return gain * itime->mul;
 }
+EXPORT_SYMBOL_NS_GPL(iio_gts_get_total_gain, "IIO_GTS_HELPER");
 
 static int iio_gts_get_scale_linear(struct iio_gts *gts, int gain, int time,
 				    u64 *scale)
diff --git a/include/linux/iio/iio-gts-helper.h b/include/linux/iio/iio-gts-helper.h
index e5de7a124bad6..66f830ab9b49b 100644
--- a/include/linux/iio/iio-gts-helper.h
+++ b/include/linux/iio/iio-gts-helper.h
@@ -208,5 +208,6 @@ int iio_gts_all_avail_scales(struct iio_gts *gts, const int **vals, int *type,
 			     int *length);
 int iio_gts_avail_scales_for_time(struct iio_gts *gts, int time,
 				  const int **vals, int *type, int *length);
+int iio_gts_get_total_gain(struct iio_gts *gts, int gain, int time);
 
 #endif
-- 
2.39.5



