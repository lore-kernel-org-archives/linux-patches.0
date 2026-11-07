Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063075;
	b=T5qM4HG6tuQkfrFAxhnhiuyzU/e8CXvan+Qfe4h+g5U2YQJQhVhL6YvBiMOK9CiBMYXx
	 ptE73PD3w21vMYqeBJXgb7gVkD5CkYnaN1HYecxOF5QJmJ/0pILimcmevqjo8JgBQnnfB
	 02NQFGVcOOMAk4Ah/BgkzYBoJtFATbQ79O3NHgpaTuffL2jqBrRIEwMDJi9p0lfqwDRcu
	 ysSpGtmHV4cGOU0zjfFgk47DzQo5QM4lTjK/4jHQ2UnFmUIlhEszn7HYd9VaB8+xbacrB
	 f0O7UPVcdrX5yJ2gFIjVEFhBJ68hQlx1SMirqa9jWBFLKNXHN6JISFaghycfEN1XBcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9A/IfY5yKGIkE1pGUp5eZLS6Z4fKnh0I3UabUZE3yQg=;
	b=39ORY5HbYD9Mj8av8r9PLOhHXQFt/HOxZekkEXFIS3+HeOqDAqDtmDuTLPZ0jdyNIrOJ
	 wWVfBtsvQZRakU25J5ncXh3F4ehiW8FAcf066FJOBcKUb1vNEXRLj8dxmkG4anP18frtZ
	 mlQofl9ztVfAz0dOdV6xBt9JBiMGVUNOyATpETPsKbSv2FdICwjHERay6+nWvqU9AgF/b
	 x7KQBrFPtZLY7cPPkqJ9Ep6s4Dl+YGGsYxDzJ6WvSH8XmgQ2t9KnmaCkXt9xzZsN9BDjz
	 7ZeT9qQOnrzOXGaL1tGNKePRlCJ2dcv+Orltl577GBMxpP9cyEP1wEn0urqmC4RWqOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNEHwbBM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD1C606D802;
	Sat,  7 Nov 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNEHwbBM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090521F0089F;
	Sat,  7 Nov 2026 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063075;
	bh=9A/IfY5yKGIkE1pGUp5eZLS6Z4fKnh0I3UabUZE3yQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNEHwbBMrGRmn9v3VLqtbS2jLlBEzproVsT08Fn3b6kFIH+hcgaiexMDEF/LiebcW
	 B4TNluYbEpIbZIhItJqSVdRfNu7i/rBIbKpYt7nslFDzvEiziPU8BQ3kIQokBfIc4m
	 A2aYYUy7YyY5wtp9RtO/NSobJKT4sf6oKcmkb/tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 277/869] iio: accel: adxl380: reject devices without match data
Date: Sat,  7 Nov 2026 08:49:19 -0500
Message-ID: <20261107134901.066460998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 6edd0d211ffad..b51edc021b267 100644
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



