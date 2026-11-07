Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062125;
	b=5pTF1szNwzFy+v3ndhKzATzgAzVB3gwsiBPic9edngme6cyTbPp8GoiEDxusP6oYrWjh
	 +FJ7UAZUbynXyFFIy6YMNCBm03dp4J5OJ9YEj5+O7h2Ymj6z4qDbIhvetDCTvDwM9fQgI
	 H6Ajvg7bmFmDR94w1/g+F7ez16DU1eDOHU8r+lA9kal5cz+D3kpSEVsbpeXOgVGu/MaSb
	 /r0N8lBfCwxsk/2oqVJhuU9KvUFGqvIFSjRtJnXf46WYyncjCfEp/ngbNrRnVys1RfJsK
	 5hLzEn9NVPMpfo3vhbZCXQY6Fj3ynl9Vnwd9vUlV3JYA/sQnbh8fPjCjyRRRzso0Bsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bXUkItJ35itdi278/X6Fl8LMaU0K7LuPrBl1T3MAVw4=;
	b=gHqJSkqnhL6FQ9KUVuOhAYo06I6aIhQ10CW3AHXQHGwt5To9Z/nckcXv360aZ0jz5zS0
	 +cceCrnVmqN9zVgPWz+DnID7PHFpMCzkwjlq0AXDEek8RpPXJYaJefQIqwHonYrZxp0l0
	 m4xsz77WT8HhyeG6NQmz8S5oRfjeXUy0KiMjAjfVV6cSjGY3FFeTQBvmSc6Uw69i+Ngzy
	 Lzr8W5dCS6r1Bqhs/l4WAkTkmzBr4RVlWA8z1NUx1ziM6RFF+MWEW8VgNb/w8UzJPbYwZ
	 jCS9cLCOm8Tiy7CutyfDmKJhuOQ0tGoBr5KQ0JlRgfhudgn8ftDsKSTDXhS3531S4ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iq4yrc8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBB7606EEAB;
	Sat,  7 Nov 2026 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iq4yrc8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D82E1F008A2;
	Sat,  7 Nov 2026 14:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062125;
	bh=bXUkItJ35itdi278/X6Fl8LMaU0K7LuPrBl1T3MAVw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iq4yrc8QolH+zhhtqgAmMsIb9cyXiErTJybMsTPVGDJVkZayl6VTGcT8RhL8E2MO4
	 WYZi/ffwv/AnnF6OkR+8kqPY4+a3l2JsCWhwhHGxI+KQjNEynf/ZsfhQXTij/Jy0pt
	 63W2c7+4MDEaa+6o1L0oco2HL4R9llXGNFK3CQEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1094/1536] iio: accel: adxl380: reject devices without match data
Date: Sat,  7 Nov 2026 08:51:50 -0500
Message-ID: <20261107135028.426251705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e7b5778cb6cfe..3a014fdae02de 100644
--- a/drivers/iio/accel/adxl380_spi.c
+++ b/drivers/iio/accel/adxl380_spi.c
@@ -26,6 +26,8 @@ static int adxl380_spi_probe(struct spi_device *spi)
 	struct regmap *regmap;
 
 	chip_data = spi_get_device_match_data(spi);
+	if (!chip_data)
+		return -ENODATA;
 
 	regmap = devm_regmap_init_spi(spi, &adxl380_spi_regmap_config);
 	if (IS_ERR(regmap))
-- 
2.53.0



