Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620366;
	b=ekdnmu2OKcolUUm7ETO4Bfb2Y0t3Fn5RM+tI+FBtnVeVWe1J42rPpqM7kEwh12fxxYj/
	 EttcB/D2uXMrI/KBVj2TLIFVD6t/M5BurhtYSg9qxx3+bDmnPXotZLN4/TncryAMWW+dW
	 pMkxnXpmT2js1Ud1ncmAz+kIuqL4uBsOX4XUF2yObXmZ5WIuh33VuoS5PKyWmMH/UVCZg
	 e2E5P91H6XXmYqnLHO3AVj4nmdZP/JbHyxA/+ka0Vx6t47+y4yxAbY9cd+hjU9MNeUVpK
	 9uzwt4tn89V+1KJFIpb3jZ+M7vP4JaaPO3fRh9mQnsV9cgQvP+SfOFiGNgbcUruZ7EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qfPPiI6ZQx9YEypeSmMMCtl7Aw7Yy0uQNKfy9AGdEmk=;
	b=cevdI5LSPTlyzEnCK/hfPo6VwUX8LPBypD6VWJl+fR4eSU8Gqs+dXAsxq+zbh3ImJc4H
	 ls84/Loc9iMWPTEvX2AowAeB9OYk4Aj9eMzus9/AUrQy9O3pZPmYK5zbevxt8Zf+2iEdJ
	 bmk9klJKY57jIOmDfn+jz+z9bZfW8ykpiSChaiuycluuNJrDWKWVlJIYqNN4MNxhnGiju
	 Y0huZMVxHK1Ah+4u7w6cVyOyApdvb/14tXC5JmNLPaGF5VgKTl/EWLg7x5jw8MicjwEiN
	 5YFr3NK2AK/e8gfyplSMJXaMk0Fs9rzxLeP+zlIwIiwH+68sGmGaiPXVzbkWvh8V+Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wWW5eY7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC3A606A321;
	Wed, 25 Nov 2026 15:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wWW5eY7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8731F000D0;
	Wed, 25 Nov 2026 15:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620365;
	bh=qfPPiI6ZQx9YEypeSmMMCtl7Aw7Yy0uQNKfy9AGdEmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wWW5eY7S9nsBOBGO42j6xtjkcVf/xYiseRjYDRIwcpj28zsu2NQ7mToheAqOfUKg
	 vfnRWG2hVXG2IYrEQUyk5w2a1xtwJKlDvncAy9RTu9DhHVJ7pgfyp3Y5uYaFifr6go
	 L4O6p6F3DNgDUP+3laq9GGci8EGGDaTkkVaX4/IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0894/1005] iio: adc: check the result of ad_sd_init()
Date: Wed, 25 Nov 2026 15:37:12 +0100
Message-ID: <20261125143842.637713734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -311,7 +311,9 @@ static int ad7780_probe(struct spi_devic
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
@@ -435,7 +435,9 @@ static int ad7791_probe(struct spi_devic
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
 		ret = devm_regulator_get_enable_read_voltage(dev, "refin");
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


