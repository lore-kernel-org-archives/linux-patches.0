Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024682;
	b=OFLIw1GcONF4Y1coXdoqqAdOTrSLpF92nqJNqO0bIl1h+9q2tUlwrGZ1h0xzu/uKi61Z
	 RX1VjvygogOCob9sKTL7MjAp2avgAAMQQzRkM5j+R4K0VEd5DG8yPnmW7RRJO5aJLWbMm
	 hQ6tIWudzjTdzKZ9i6ztlH6rGyfswcPiQHH91ogxc2/o31hnWZrApQjT5roNImsiy6quL
	 tr6Bm1E+nycSPbpIrikpmG7zVxSPTlxC5kEOj7BmiYPwXYbj8DEE2NsVnVWOyuQhpRnwq
	 ur7HecOGqlQRmzuWnn/sH7A9TnIhHu53cU3udwjs8PTgYcZZQ079XErg/IkV4IHcOvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PHZkH3KYvZmcB9CgMcEOekDKJNT5qjRkCuV1347YCTo=;
	b=Exk+KSUYC4LSKbdFwt5/iTCxtyU6Wa43alPCZxRF07gxZ8HXUmXnPVdME/hK50PINuf3
	 5RFixQSPHFFOg16Nd9JNTPH89H22aZbglq4IxVuNfxW0y61/tpQ669MWMYk2THQO5QLeJ
	 inRCyl84VXNObTO9G+4L13QWg3xyk9VwZUEXlNlG8mcbuwUTkkyI/AEP46zh2Q5d0AeAO
	 MvrwUXeA11OviWhsPsx35e8Bw1/28y2J8To50m03/qy/HBT0uQOWGLh5xanoC5HUPSyqj
	 Gzgw11SNs4V4J+K+pNbptd2jt8GyyskmE+mup3Kov82gImnU9SrvTUPnREHjd1fVaNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oStliXOk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E98B606A31C;
	Wed, 18 Nov 2026 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oStliXOk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7561F1F000C4;
	Wed, 18 Nov 2026 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024682;
	bh=PHZkH3KYvZmcB9CgMcEOekDKJNT5qjRkCuV1347YCTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oStliXOkMjKcO9PBAtriiB4C+cByhIQMjY81YL3N4LOgwAtYpn9h9yrawpSmO1vzV
	 mup9RmgqE1v/6JPCbJxSO2u7H+bhM1f+PH5TrDGBXXpMGyraZWVcJv8SA9p+OAtvsY
	 3aLDBFOIifCg5bw/BB/AYyOObIM35JBDCQuPnoMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Maxwell Doose <maxwell@maxwelld.cc>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0811/2151] staging: iio: adc: ad7816: Serialize SPI operations
Date: Wed, 18 Nov 2026 15:42:26 +0100
Message-ID: <20261118150151.583806406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index c7f507916726f..45ae9f101287a 100644
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
@@ -360,6 +367,10 @@ static int ad7816_probe(struct spi_device *spi_dev)
 		return -ENOMEM;
 	chip = iio_priv(indio_dev);
 
+	ret = devm_mutex_init(&spi_dev->dev, &chip->lock);
+	if (ret)
+		return ret;
+
 	chip->spi_dev = spi_dev;
 	for (i = 0; i <= AD7816_CS_MAX; i++)
 		chip->oti_data[i] = 203;
-- 
2.53.0



