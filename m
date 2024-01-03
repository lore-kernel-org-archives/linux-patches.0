Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C261C28A;
	Wed,  3 Jan 2024 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ticyLU6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1F0C433C8;
	Wed,  3 Jan 2024 17:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301638;
	bh=82gjV+xEuowcGTLupufgZLjtYWsQwIgyLIZWnZ/rQoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ticyLU6sO2SH0O1qQ2o9K2KNhUSVJPiQl+kH/xvsiKgD8sUANizwBD6vNnMdvSSZp
	 3b5bi1mBFkfvt7A6+LCxFrwv3SetZ3Laj4ehfaBiMGasf9uay+mzSX/wD0vWU1EAYK
	 LUfgJLtW/vnRZiSHdxyMHsOAHx1BC3ug8ixmC4Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 82/95] iio: imu: adis16475: add spi_device_id table
Date: Wed,  3 Jan 2024 17:55:30 +0100
Message-ID: <20240103164906.353530852@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit ee4d79055aeea27f1b8c42233cc0c90d0a8b5355 ]

This prevents the warning message "SPI driver has no spi_device_id for..."
when registering the driver. More importantly, it makes sure that
module autoloading works as spi relies on spi: modaliases and not of.

While at it, move the of_device_id table to it's natural place.

Fixes: fff7352bf7a3c ("iio: imu: Add support for adis16475")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20231102125258.3284830-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16475.c | 117 ++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 45 deletions(-)

diff --git a/drivers/iio/imu/adis16475.c b/drivers/iio/imu/adis16475.c
index 9d28534db3b08..a3b9745dd1760 100644
--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -1273,50 +1273,6 @@ static int adis16475_config_irq_pin(struct adis16475 *st)
 	return 0;
 }
 
-static const struct of_device_id adis16475_of_match[] = {
-	{ .compatible = "adi,adis16470",
-		.data = &adis16475_chip_info[ADIS16470] },
-	{ .compatible = "adi,adis16475-1",
-		.data = &adis16475_chip_info[ADIS16475_1] },
-	{ .compatible = "adi,adis16475-2",
-		.data = &adis16475_chip_info[ADIS16475_2] },
-	{ .compatible = "adi,adis16475-3",
-		.data = &adis16475_chip_info[ADIS16475_3] },
-	{ .compatible = "adi,adis16477-1",
-		.data = &adis16475_chip_info[ADIS16477_1] },
-	{ .compatible = "adi,adis16477-2",
-		.data = &adis16475_chip_info[ADIS16477_2] },
-	{ .compatible = "adi,adis16477-3",
-		.data = &adis16475_chip_info[ADIS16477_3] },
-	{ .compatible = "adi,adis16465-1",
-		.data = &adis16475_chip_info[ADIS16465_1] },
-	{ .compatible = "adi,adis16465-2",
-		.data = &adis16475_chip_info[ADIS16465_2] },
-	{ .compatible = "adi,adis16465-3",
-		.data = &adis16475_chip_info[ADIS16465_3] },
-	{ .compatible = "adi,adis16467-1",
-		.data = &adis16475_chip_info[ADIS16467_1] },
-	{ .compatible = "adi,adis16467-2",
-		.data = &adis16475_chip_info[ADIS16467_2] },
-	{ .compatible = "adi,adis16467-3",
-		.data = &adis16475_chip_info[ADIS16467_3] },
-	{ .compatible = "adi,adis16500",
-		.data = &adis16475_chip_info[ADIS16500] },
-	{ .compatible = "adi,adis16505-1",
-		.data = &adis16475_chip_info[ADIS16505_1] },
-	{ .compatible = "adi,adis16505-2",
-		.data = &adis16475_chip_info[ADIS16505_2] },
-	{ .compatible = "adi,adis16505-3",
-		.data = &adis16475_chip_info[ADIS16505_3] },
-	{ .compatible = "adi,adis16507-1",
-		.data = &adis16475_chip_info[ADIS16507_1] },
-	{ .compatible = "adi,adis16507-2",
-		.data = &adis16475_chip_info[ADIS16507_2] },
-	{ .compatible = "adi,adis16507-3",
-		.data = &adis16475_chip_info[ADIS16507_3] },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, adis16475_of_match);
 
 static int adis16475_probe(struct spi_device *spi)
 {
@@ -1330,7 +1286,7 @@ static int adis16475_probe(struct spi_device *spi)
 
 	st = iio_priv(indio_dev);
 
-	st->info = device_get_match_data(&spi->dev);
+	st->info = spi_get_device_match_data(spi);
 	if (!st->info)
 		return -EINVAL;
 
@@ -1370,12 +1326,83 @@ static int adis16475_probe(struct spi_device *spi)
 	return 0;
 }
 
+static const struct of_device_id adis16475_of_match[] = {
+	{ .compatible = "adi,adis16470",
+		.data = &adis16475_chip_info[ADIS16470] },
+	{ .compatible = "adi,adis16475-1",
+		.data = &adis16475_chip_info[ADIS16475_1] },
+	{ .compatible = "adi,adis16475-2",
+		.data = &adis16475_chip_info[ADIS16475_2] },
+	{ .compatible = "adi,adis16475-3",
+		.data = &adis16475_chip_info[ADIS16475_3] },
+	{ .compatible = "adi,adis16477-1",
+		.data = &adis16475_chip_info[ADIS16477_1] },
+	{ .compatible = "adi,adis16477-2",
+		.data = &adis16475_chip_info[ADIS16477_2] },
+	{ .compatible = "adi,adis16477-3",
+		.data = &adis16475_chip_info[ADIS16477_3] },
+	{ .compatible = "adi,adis16465-1",
+		.data = &adis16475_chip_info[ADIS16465_1] },
+	{ .compatible = "adi,adis16465-2",
+		.data = &adis16475_chip_info[ADIS16465_2] },
+	{ .compatible = "adi,adis16465-3",
+		.data = &adis16475_chip_info[ADIS16465_3] },
+	{ .compatible = "adi,adis16467-1",
+		.data = &adis16475_chip_info[ADIS16467_1] },
+	{ .compatible = "adi,adis16467-2",
+		.data = &adis16475_chip_info[ADIS16467_2] },
+	{ .compatible = "adi,adis16467-3",
+		.data = &adis16475_chip_info[ADIS16467_3] },
+	{ .compatible = "adi,adis16500",
+		.data = &adis16475_chip_info[ADIS16500] },
+	{ .compatible = "adi,adis16505-1",
+		.data = &adis16475_chip_info[ADIS16505_1] },
+	{ .compatible = "adi,adis16505-2",
+		.data = &adis16475_chip_info[ADIS16505_2] },
+	{ .compatible = "adi,adis16505-3",
+		.data = &adis16475_chip_info[ADIS16505_3] },
+	{ .compatible = "adi,adis16507-1",
+		.data = &adis16475_chip_info[ADIS16507_1] },
+	{ .compatible = "adi,adis16507-2",
+		.data = &adis16475_chip_info[ADIS16507_2] },
+	{ .compatible = "adi,adis16507-3",
+		.data = &adis16475_chip_info[ADIS16507_3] },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, adis16475_of_match);
+
+static const struct spi_device_id adis16475_ids[] = {
+	{ "adis16470", (kernel_ulong_t)&adis16475_chip_info[ADIS16470] },
+	{ "adis16475-1", (kernel_ulong_t)&adis16475_chip_info[ADIS16475_1] },
+	{ "adis16475-2", (kernel_ulong_t)&adis16475_chip_info[ADIS16475_2] },
+	{ "adis16475-3", (kernel_ulong_t)&adis16475_chip_info[ADIS16475_3] },
+	{ "adis16477-1", (kernel_ulong_t)&adis16475_chip_info[ADIS16477_1] },
+	{ "adis16477-2", (kernel_ulong_t)&adis16475_chip_info[ADIS16477_2] },
+	{ "adis16477-3", (kernel_ulong_t)&adis16475_chip_info[ADIS16477_3] },
+	{ "adis16465-1", (kernel_ulong_t)&adis16475_chip_info[ADIS16465_1] },
+	{ "adis16465-2", (kernel_ulong_t)&adis16475_chip_info[ADIS16465_2] },
+	{ "adis16465-3", (kernel_ulong_t)&adis16475_chip_info[ADIS16465_3] },
+	{ "adis16467-1", (kernel_ulong_t)&adis16475_chip_info[ADIS16467_1] },
+	{ "adis16467-2", (kernel_ulong_t)&adis16475_chip_info[ADIS16467_2] },
+	{ "adis16467-3", (kernel_ulong_t)&adis16475_chip_info[ADIS16467_3] },
+	{ "adis16500", (kernel_ulong_t)&adis16475_chip_info[ADIS16500] },
+	{ "adis16505-1", (kernel_ulong_t)&adis16475_chip_info[ADIS16505_1] },
+	{ "adis16505-2", (kernel_ulong_t)&adis16475_chip_info[ADIS16505_2] },
+	{ "adis16505-3", (kernel_ulong_t)&adis16475_chip_info[ADIS16505_3] },
+	{ "adis16507-1", (kernel_ulong_t)&adis16475_chip_info[ADIS16507_1] },
+	{ "adis16507-2", (kernel_ulong_t)&adis16475_chip_info[ADIS16507_2] },
+	{ "adis16507-3", (kernel_ulong_t)&adis16475_chip_info[ADIS16507_3] },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, adis16475_ids);
+
 static struct spi_driver adis16475_driver = {
 	.driver = {
 		.name = "adis16475",
 		.of_match_table = adis16475_of_match,
 	},
 	.probe = adis16475_probe,
+	.id_table = adis16475_ids,
 };
 module_spi_driver(adis16475_driver);
 
-- 
2.43.0



