Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623662;
	b=OiObcmCAapBptsah81U/SZpvs25ED8f2e/GDqVR+06cteWRhra3CeMYTWG2N3+04MLcK
	 4nw8VR/3wBcU+kEJ09YXXHfi5wkn8O5reBmbnzC1LE3Dr5k9umdIz1DjoZ5F9fsH+z4V6
	 fuQIehOyCDk7YPTYRkqSdAgu34BPAYMZ1lg8wbgJGQdCninxB6Bm3bY8vDlrMk0A7/Onj
	 yfMNsSO8+551KFJJdTb+dakzXXnnOo6i8dEJ6+wznueqI7f2hRPI1GE2FddE2/oytAAAC
	 RJ3ZObxR4JK272QMc2YKGdNWvWURMzMPbc9qCB+uVWSwgXV1fVquWfi+VesMeZKw1zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Tr76rWKGhSWrpwhvRMW8QBztxq5VVNlaFCSUPmpPt4g=;
	b=zTuWBYznjH+Pc/+Ha15rVzipz2a/eEycPXl5l6nYuHQyTzi0EKd2jCXsZOlhMtLa9E53
	 MiM2d/aFKy5RadrUqgaDvHVA1cdqEb6RfjE48KdtuCf4c7O7Hz8UAEE65gqVZ1q8NNky1
	 j65RqcsRlR/wVTtfzoyK3w5cfVen462xitw7p0fle9WMbYKX7hdCwBbdiQTMuqyoZyHEl
	 4rxQLLOtvQypVvj0IKfXpPIrTqCKsQnVXqM1iMhQn6q154xG+ahwxjY2imdlOF/46/iVH
	 8wtNfQplOZdulqlpTqhSIcUyDl7k3yUy8XhWl9hB3luQk1klLnqz7yvRAuIPhVLy4lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18BFJmes;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E964D60A2611;
	Wed, 25 Nov 2026 16:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18BFJmes
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A841F01807;
	Wed, 25 Nov 2026 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623661;
	bh=Tr76rWKGhSWrpwhvRMW8QBztxq5VVNlaFCSUPmpPt4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18BFJmesWxXOqHEkE00B3GDGjpNxogW5J4XSkEfXCEs/16OIen68fK/9NQSDMEvgz
	 jYZTkBll8TDxp7ltgyFUy13ymejnqimIkgimn9zEcrCL7PV8BEISMNiG8oTqvcT9oS
	 NyemFtaanRj4f+IsLYi5IZrDs/9eG2gIATHHmJCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 887/990] iio: adc: check the result of ad_sd_init()
Date: Wed, 25 Nov 2026 15:37:34 +0100
Message-ID: <20261125143842.788937887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 905b5d93b795b0e2311a8c855c1cdd97c9cc2989 upstream.

ad_sd_init() asks for the optional "rdy" GPIO and returns the error if
that fails, for instance -EPROBE_DEFER. The binding of the AD7780
describes such a GPIO.

ad7780, ad7791, ad7793 and max11205 ignore the result. The function has
then returned before it set the driver data of the IIO device, which
devm_ad_sd_setup_buffer_and_trigger() dereferences a few lines further
down in these probe functions, and sigma_delta->rdy_gpiod holds an
ERR_PTR() which ad_sigma_delta_clear_pending_event() takes for a GPIO.

Return the error, as the other users of the library do.

Fixes: a87ef09b1fdf ("iio: adc: ad_sigma_delta: Add support for reading irq status using a GPIO")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7780.c   |    4 +++-
 drivers/iio/adc/ad7791.c   |    4 +++-
 drivers/iio/adc/ad7793.c   |    4 +++-
 drivers/iio/adc/max11205.c |    4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -318,7 +318,9 @@ static int ad7780_probe(struct spi_devic
 	st = iio_priv(indio_dev);
 	st->gain = 1;
 
-	ad_sd_init(&st->sd, indio_dev, spi, &ad7780_sigma_delta_info);
+	ret = ad_sd_init(&st->sd, indio_dev, spi, &ad7780_sigma_delta_info);
+	if (ret)
+		return ret;
 
 	st->chip_info =
 		&ad7780_chip_info_tbl[spi_get_device_id(spi)->driver_data];
--- a/drivers/iio/adc/ad7791.c
+++ b/drivers/iio/adc/ad7791.c
@@ -436,7 +436,9 @@ static int ad7791_probe(struct spi_devic
 		return ret;
 
 	st->info = &ad7791_chip_infos[spi_get_device_id(spi)->driver_data];
-	ad_sd_init(&st->sd, indio_dev, spi, &ad7791_sigma_delta_info);
+	ret = ad_sd_init(&st->sd, indio_dev, spi, &ad7791_sigma_delta_info);
+	if (ret)
+		return ret;
 
 	indio_dev->name = spi_get_device_id(spi)->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
--- a/drivers/iio/adc/ad7793.c
+++ b/drivers/iio/adc/ad7793.c
@@ -796,7 +796,9 @@ static int ad7793_probe(struct spi_devic
 
 	st = iio_priv(indio_dev);
 
-	ad_sd_init(&st->sd, indio_dev, spi, &ad7793_sigma_delta_info);
+	ret = ad_sd_init(&st->sd, indio_dev, spi, &ad7793_sigma_delta_info);
+	if (ret)
+		return ret;
 
 	if (pdata->refsel != AD7793_REFSEL_INTERNAL) {
 		ret = devm_regulator_get_enable_read_voltage(&spi->dev, "refin");
--- a/drivers/iio/adc/max11205.c
+++ b/drivers/iio/adc/max11205.c
@@ -114,7 +114,9 @@ static int max11205_probe(struct spi_dev
 
 	st = iio_priv(indio_dev);
 
-	ad_sd_init(&st->sd, indio_dev, spi, &max11205_sigma_delta_info);
+	ret = ad_sd_init(&st->sd, indio_dev, spi, &max11205_sigma_delta_info);
+	if (ret)
+		return ret;
 
 	st->chip_info = spi_get_device_match_data(spi);
 	if (!st->chip_info)


