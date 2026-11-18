Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040424;
	b=B+R+RKvZ9HNpKsGMmEVyglWkXhvO2VTQiciQJAZ0EwpjgGI7ukmeDUm3wEQ/7KKuHdsl
	 2NYwD+cV6YKQMX3fieWBjS2Ji+n6fwWmy3OcC6LEiFJHyNZmfwwPYWc5VGkVynEqc+AeH
	 WD4GsUVu6/RRCUrNA2TQNtOvqJ1w8JXuXvISyZguu4HQmFepqm1aDo+zTGIyGyDlAmmdb
	 UbloNIpxnigELdw8Nm8JCDs3Js81B52fdd81jVckRrVul1qRyvStrnwU4J/aAtFfx21BN
	 YxhXj+5x3smmNd6fr9L/0KXY7TqPcAX/qe2ulIY70p026wcwP4UVsdEIAdrEVJc1E8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YV+KWTmki4uNBPwVc3Dnc8A9uyuIOqq/8Puq2q/6tT8=;
	b=QrDLWzcbmoI37fEImHdPrubDJ6wPtALjUvCfrggBBb6DVePzsCYASNUt0PK/a/CIq0RW
	 GWC1Bg6Qb+UBW2dqv61xLqfG431LLEpNjiI5gZyKmTsW6pZydFK/E8ZCc8pkH1EsXjJRQ
	 7cpdzHd5NI9WybiqkJvE2HHBX7la/qi4RS91IK+G7O4RZmmZ3osW93jG0tMzYCZ2G1OkM
	 kCFfDCYtNDpWybwABjpHMD3hNePJefm4mboIYto8k/yP2Jn+6grnLCj+6+3vYZjNzQaDH
	 wLhCO4RNSlxk5TXTkaN3SkQDkY2nWRbt/22Kl6yzFiUVmnsBukRDnbMS1swnhfkvd+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZovOGh9R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB4F606A320;
	Wed, 18 Nov 2026 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZovOGh9R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202211F000C4;
	Wed, 18 Nov 2026 22:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040424;
	bh=YV+KWTmki4uNBPwVc3Dnc8A9uyuIOqq/8Puq2q/6tT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZovOGh9R+/HvS395DAYfCYOHlbsp9iuxQfC8vrDvBNj4OmcK+u/rV/v34IywaktIX
	 x/ikpQfgc71A2D+tiW01DSvxU4TXA16BRXLDQjlPkOfn0tTL9EIOEgTkmiSadlc0gl
	 w5L9R+EFeF9e13lvDxUBY62avtyykU+Xfg6GZeLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Maxwell Doose <maxwell@maxwelld.cc>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2411/3318] staging: iio: adc: ad7816: Serialize SPI operations
Date: Wed, 18 Nov 2026 15:50:33 +0100
Message-ID: <20261118150433.822965622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>

[ Upstream commit 8f99c766605a484663764b52da56a0b160f9d9c3 ]

The ad7816_spi_read() and ad7816_spi_write() functions perform a
sequence of GPIO state changes followed by an SPI transfer. If multiple
operations occur simultaneously, the GPIO state could be changed by one
thread while another is in the middle of a transfer, leading to a race
condition.

Introduce a mutex to serialize the operations, ensuring that the GPIO
toggling and the SPI transfer are treated as a single atomic operation.
The mutex is placed right after the pointers in the device state
structure to avoid padding holes.

Signed-off-by: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
Reviewed-by: Maxwell Doose <maxwell@maxwelld.cc>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Stable-dep-of: b96187644664 ("staging: iio: adc: ad7816: Protect sysfs attributes with mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7816.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index 6a402e8877605..ade1b8db197d4 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -5,12 +5,14 @@
  * Copyright 2010 Analog Devices Inc.
  */
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 #include <linux/sysfs.h>
@@ -47,6 +49,7 @@ struct ad7816_chip_info {
 	struct gpio_desc *rdwr_pin;
 	struct gpio_desc *convert_pin;
 	struct gpio_desc *busy_pin;
+	struct mutex lock; /* protect device state during SPI transfers */
 	u8  oti_data[AD7816_CS_MAX + 1];
 	u8  channel_id;	/* 0 always be temperature */
 	u8  mode;
@@ -67,6 +70,8 @@ static int ad7816_spi_read(struct ad7816_chip_info *chip, u16 *data)
 	int ret;
 	__be16 buf;
 
+	guard(mutex)(&chip->lock);
+
 	gpiod_set_value(chip->rdwr_pin, 1);
 	gpiod_set_value(chip->rdwr_pin, 0);
 	ret = spi_write_then_read(spi_dev, &chip->channel_id, sizeof(chip->channel_id), NULL, 0);
@@ -107,6 +112,8 @@ static int ad7816_spi_write(struct ad7816_chip_info *chip, u8 data)
 	struct spi_device *spi_dev = chip->spi_dev;
 	int ret;
 
+	guard(mutex)(&chip->lock);
+
 	gpiod_set_value(chip->rdwr_pin, 1);
 	gpiod_set_value(chip->rdwr_pin, 0);
 	ret = spi_write_then_read(spi_dev, &data, sizeof(data), NULL, 0);
@@ -362,6 +369,10 @@ static int ad7816_probe(struct spi_device *spi_dev)
 	/* this is only used for device removal purposes */
 	dev_set_drvdata(&spi_dev->dev, indio_dev);
 
+	ret = devm_mutex_init(&spi_dev->dev, &chip->lock);
+	if (ret)
+		return ret;
+
 	chip->spi_dev = spi_dev;
 	for (i = 0; i <= AD7816_CS_MAX; i++)
 		chip->oti_data[i] = 203;
-- 
2.53.0



