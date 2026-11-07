Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064245;
	b=uL61pIt7rN3QZn/r0449ISfqwJ5q+RkIKi+RNh/wEKiwJBvGXaA9G1JTK90qacH/g0nY
	 8pZ2nhS5IaVGvSQTTJuPWCFW4AVBDysyOEoQfd6lrB2XD2COCL+iouVzIOO2zSM2gLmrm
	 Q2vkSlchmPBfWv6tpD4bShnQ77+IaaUGvXi/OH899EApmpXQW94pxNRn4mqMVeVUXP0sI
	 A4fjY0wyFWt5xj0jTTHtDZtSY3SdqU/A0OGfZbEPRqGn+dQ6x6utKixKTmD5LIwus991w
	 2P63zi019yzK4Pv3ELUDuBGr47IYXM/+W0YAyB0j+WzfOrS5Ea/iL1lszSQxjVtDMzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GuKVTa38+1g6b7OQp1kTJX4eCfJ+jGGceg1CXz2xf8M=;
	b=0fDNx/jMq/HNGPl6PU6tWe2Gfw1bTX9nxhvlYVXAscwj1hRqcgM3lbd5QLin1XTGwr1e
	 aFT8iLgl98sJzJp42oMgeGDabKc6cWcRo6aWCobJZFDzw/cQyVR2DQHyfkuEhOXbSLjnZ
	 1RYs1iw+NWTD8LpHKq3IO764aGWck9g6zgTyqRlrhlYxFb6da00dpV+WmCy985ZxJpwBY
	 vRKks5YpfAY9zLZIuIUveIuQAamDVYyjXaBX5WhtSLqHpDzyyYhvo/L5w05s0Vg/aCpxY
	 rjJE2IkingrrbAUAgemRxj9B3PuvU/SP6zo3QvHEclFGI7+9O9ykluzInghOHK4h1QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+TcED70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC927606A332;
	Sat,  7 Nov 2026 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+TcED70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7611F008A1;
	Sat,  7 Nov 2026 15:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064244;
	bh=GuKVTa38+1g6b7OQp1kTJX4eCfJ+jGGceg1CXz2xf8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+TcED70USpp7A9SeM6vOtYlZKU3T46Zb/ptaE4AFgGkin2Syai5ZKTzJKeRpv7nr
	 q7YqaIfg98Sb7h+HIQYEA1m4UrWXz4Z5kNK5ri5iEgofwkPEqpZGq3pXmDowROIGjo
	 OjxtVvoChEqKSKOmFs62Zz/OfoE4QoZR+E7v/HEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0348/1257] iio: accel: adxl380: reject devices without match data
Date: Sat,  7 Nov 2026 08:44:04 -0500
Message-ID: <20261107134949.008465027@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 9f6d174e9fa5b265e7a0a6caa0c5b579bf899702 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

adxl380_spi_probe() passes the result to adxl380_probe(), which
dereferences chip_info to set the IIO device name and operations,
causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data in the SPI frontend.

Fixes: df36de13677a ("iio: accel: add ADXL380 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl380_spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/adxl380_spi.c b/drivers/iio/accel/adxl380_spi.c
index ae8467f4e6c01..8ffb3a8690a63 100644
--- a/drivers/iio/accel/adxl380_spi.c
+++ b/drivers/iio/accel/adxl380_spi.c
@@ -25,6 +25,8 @@ static int adxl380_spi_probe(struct spi_device *spi)
 	struct regmap *regmap;
 
 	chip_data = spi_get_device_match_data(spi);
+	if (!chip_data)
+		return -ENODATA;
 
 	regmap = devm_regmap_init_spi(spi, &adxl380_spi_regmap_config);
 	if (IS_ERR(regmap))
-- 
2.53.0



