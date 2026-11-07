Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064243;
	b=oC1YbTpnwfUronBckB1GYpUQITqGrZajyLUG9hqW2oThdjIiOVfywXM9WYR6Sx6XfBi8
	 b7vSstuUHBujbGk1AHGKCmLBEoMHCVeu+j8HVH2c12oqurrPOjIai5s59Pj2V1fqaSlOX
	 x+Ss1xgnB9HHARg51qjZDCromnZo1wDfWUaX0rao2sKOq4Jz3sp6uqw3KWzjKIoFLTP1+
	 hJ3qLuIFV371RP0cZsWQ1w6xMdXDWkojm5GLc+kyfJZBDjVWu/W4UCJ2jIcw03tYELi50
	 6Rb60CyIH+7NCb+vSNS7syeOob2sgUCqv9eqaDkgjHukCP2ha8WdQzWUlL269sz6qew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+iYM6UNbzLOTGR/lWc1pXyV8hwcLlLk4+dqeQuLH84c=;
	b=OGcCCbwevdEjkIx48KaMGZMBXN0ZWjgG24nN+H4bQT9+Y4xnLEJTh9xw9cwMG3YD8X/0
	 hnnR61uwSZT3VKsGAG+adP70aRaPi1jfOJ/7VlRvSnsAjzZAfD1p0c0S+c4BBSSrywOdG
	 ZQACf8+PUalT6k0vP6aH+F2/PXYQYAbsCb8+I2yj2atHoSG9oRHuFidTRWT749uhkbCAG
	 NsmwUI4WMgCDtE12B3VwVkacAxqYVC/h/22Pzzbi/h883fKoxmxCc8TF8UFQOyuVylve8
	 sJr/Io9NwsUArqQQ15eqMbKCT2h06oZH7uIR9Ckmvh1YMOYuXClykftdbj7PJwIrjoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLLi6BZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BC4606A332;
	Sat,  7 Nov 2026 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLLi6BZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A70C1F008A3;
	Sat,  7 Nov 2026 15:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064242;
	bh=+iYM6UNbzLOTGR/lWc1pXyV8hwcLlLk4+dqeQuLH84c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLLi6BZBfOls+i/so7WqWSOELwIT/lFfXN6dBEf3JVb8rdXpapw02QI/RVn9VvaI6
	 E31C7KF0Roy5trIy0iQtEiztux9112z5SYWJlfiCfgsqRQRREvxxUcbZIbIsUFSwL6
	 WYxGq/jp9kQd50t+LD0iiW01zQ6PAkHcgcCV0MzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0346/1257] iio: accel: adxl313: reject devices without match data
Date: Sat,  7 Nov 2026 08:44:02 -0500
Message-ID: <20261107134948.952174803@linuxfoundation.org>
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

[ Upstream commit defd4c0b29f1cd17caa5feebac33fc5fdf4e1916 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

adxl313_spi_probe() dereferences chip_data to select the regmap
configuration, causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before selecting the configuration.

Fixes: d6e3ee74d16f ("iio: accel: adxl313: simplify with spi_get_device_match_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl313_spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/adxl313_spi.c b/drivers/iio/accel/adxl313_spi.c
index a61295de104f6..0f0da44461f74 100644
--- a/drivers/iio/accel/adxl313_spi.c
+++ b/drivers/iio/accel/adxl313_spi.c
@@ -79,6 +79,8 @@ static int adxl313_spi_probe(struct spi_device *spi)
 		return ret;
 
 	chip_data = spi_get_device_match_data(spi);
+	if (!chip_data)
+		return -ENODATA;
 
 	regmap = devm_regmap_init_spi(spi,
 				      &adxl31x_spi_regmap_config[chip_data->type]);
-- 
2.53.0



