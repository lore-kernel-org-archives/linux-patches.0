Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062124;
	b=kcRmX2zijIPqUgPntJ71/9Hc5cL4ALor4q1qpKIiCZokXHMztMxrRxZkm4Ey2OENoce3
	 EDeqMXfKwBjDRcpN7ciAo0lcGvZtGNr+g1piU6MeyLUwANLEzdX28a6FOiHDJvQTCXyj7
	 vAuvWwS2ueiAcZMquXnIi7MuegfOSv4Ed7XJMbmH2M9gdBfBim3+e+O9Sct8RJ/2UP1Nc
	 kf64O/a/Zy2da+ED89q6Wd2ppiz8xudTzjxeJlodJ3BqVyUxINdavaR7XQZX7Cnox7LrV
	 sY26IdWOx+tuvLNR6kBuFVe7+btZdeERHS+/VTL7cPzUk61pfh+pPgoOo84Lm/vOv+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Be8xuCRdIXUmPduUQRReR2UyAGC+7hHHjHd+oD8SIQs=;
	b=qdPgoQlQFOqcmTuI6AUpF9EHcNbbuSv6b2r8nhIjuDNQRhVwFbw3o7HXyT2CtIwxsCEi
	 ubiK+dJbncAgx0jpavWepc8GIntgIUkuZ35XLhvNydpi94w+okV2zBXKiml0Cd8n6WnKk
	 epyAJpDO3DUFjSvNV909YMh+FUUQsimfAR8YPoh0CXCQv/aAZXw+ewGtGtd5sbzdCktQ9
	 4VKW85aCwl5LUiO+jMDDe0pN75SgMjeWiOtXOmVzS6YlBW5ObTNUypUwXlDiQ/lWdFAtH
	 xyT66EJhdswVuvihiNadH5DTZpRi3I50B94M30RFkTy4/XCGw/F88lSpiNZ0ABfuelA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fq1CEgoZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF7B606EEAB;
	Sat,  7 Nov 2026 14:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fq1CEgoZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE46E1F008A2;
	Sat,  7 Nov 2026 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062124;
	bh=Be8xuCRdIXUmPduUQRReR2UyAGC+7hHHjHd+oD8SIQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq1CEgoZa8LLs8oKoQlPT+idNSjee7n7uhuMj+CLkxNk/Nqze6xfEzB2BtaDnmCu0
	 xkx+vEvYCjM8VyPhy76C12J/Hn0zZ5f0Htqlhd369mv6QkKpPWpVrbPpVrcgo4U7Nt
	 jQ/4oRBal80qCgEZiz9Y+X5fUwUTa5UjFt8GTy4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1093/1536] iio: accel: adxl313: reject devices without match data
Date: Sat,  7 Nov 2026 08:51:49 -0500
Message-ID: <20261107135028.399698673@linuxfoundation.org>
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
index 6f8d73f6e5a93..09ca853949f02 100644
--- a/drivers/iio/accel/adxl313_spi.c
+++ b/drivers/iio/accel/adxl313_spi.c
@@ -73,6 +73,8 @@ static int adxl313_spi_probe(struct spi_device *spi)
 		return ret;
 
 	chip_data = spi_get_device_match_data(spi);
+	if (!chip_data)
+		return -ENODATA;
 
 	regmap = devm_regmap_init_spi(spi,
 				      &adxl31x_spi_regmap_config[chip_data->type]);
-- 
2.53.0



