Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705740;
	b=bcdT4YPbvX4/2I0Ay4XXFNLFoU05veKt0tHxgRP8XuyQ5nBiT9HQWlimZNV5Qce+s7I4
	 /DYyb3wryBHV5o8Ms4wjkmPHe8uFl+3qDZWPbGoE53GeWkw56XngvuyoWffx0XPhfd9Sc
	 19lsDEpyPwWDcVg0MWAyFltqIUVSLPqkiPjxdRQFem2nE7dP3DlXPR4vgCjzEHiB6Nn80
	 6EVK+EGxFfRJ8sGMQczZsNZRpEGEGW1spN0alud0kvCqsHTp9+A6drx1WaUbseDql0qWA
	 ElQDJ+KK8PgvKThqsK5x00ODSOUveGGL23P2ahRrineotw2TYSGvvPDk2SytFjBDrMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OboHfM29ij43Z5Xs56DeBOJOoAnkAaF8Bg4Laa3nrwo=;
	b=tYlygVPUbUCIFgPjYkUuehEx2C8XEOGL9/c3vjrnQQszzibQc5Ox4IE4WR7lvPzkiu3i
	 f/zfBOSrD7PXM9D5HzJEvva6Q6P3U50yoRdOk8F2O7z0NumLb+8I3Go6ng8hvp4MsYn5Q
	 DBoaVEuk3G3Bk2yvWGRl1VgQxCwJYjZzV2Fp+1aV86Ah84T7XPq+/fD/ORcexZ66bYeh2
	 e4cBkL4o0Vw0NlGHGCeXm8fABpdr1RUWMtmEvVcslX4p/f59K1QMOtc/CklKp5j51Spg+
	 oOnURpH7/1AyL5IF2f1ANFbhJzWI+yswwjF6kU9VrB12XHdsihlOoYed7KX6/O1b7Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvhAV8Hd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387E4606A32D;
	Thu, 26 Nov 2026 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvhAV8Hd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7842D1F000EC;
	Thu, 26 Nov 2026 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705739;
	bh=OboHfM29ij43Z5Xs56DeBOJOoAnkAaF8Bg4Laa3nrwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvhAV8Hd0jTwqglZ+9lfdy9ZSHmnHYXuQqUXMrDQfzoZ24xPVoGMsKGS0CdnCzzMA
	 d0R2KCbhDSSWXpMtho6fOLe+VunF37KQkwca16CC0W5SPEdySOCM3uvy30UABJAItD
	 HF5FQzLvUL3UQxwNyaRPEQQuW5Zh9RyX8lMPuyes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Matt Ranostay <matt@ranostay.sg>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 298/319] iio: atlas-ezo: Fix humidity channel read support
Date: Thu, 26 Nov 2026 15:41:06 +0100
Message-ID: <20261126144013.484704522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit 0cb3fc8987038a26ac0f581bfa26b16daf6ca6a7 upstream.

The atlas_ezo_read_raw() function rejects channels that are not of
type IIO_CONCENTRATION, preventing the relative humidity channel
from reading raw and scale values.

Remove the early channel type check to allow both concentration
and relative humidity channels to reach the mask-specific handling.

Fixes: dc3ebfcaa51f ("iio: chemical: atlas-ezo-sensor: add humidity sensor support")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Matt Ranostay <matt@ranostay.sg>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/atlas-ezo-sensor.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/iio/chemical/atlas-ezo-sensor.c
+++ b/drivers/iio/chemical/atlas-ezo-sensor.c
@@ -115,9 +115,6 @@ static int atlas_ezo_read_raw(struct iio
 	struct atlas_ezo_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
 
-	if (chan->type != IIO_CONCENTRATION)
-		return -EINVAL;
-
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW: {
 		int ret;


