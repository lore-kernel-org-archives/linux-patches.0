Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1F36BFAC;
	Tue, 14 May 2024 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683789; cv=none; b=acyBFxA+YoySUMvE7NMTffq+oC0LEohKY2Cp06jQthTiYALHMcQMxdDLkZXI0Oh7kldHaJzTZSBBqv8g8VBLSmKLzyWgnC1QJzjcH+CmDg/byC98QWWSQ9dp7vsEvpxbVsMOvRCk7YsSDa0W2yssTWUwctegS+NPJK9E3YJ4xyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683789; c=relaxed/simple;
	bh=FOvOwitziqFIUowY8Sd26d0Y87URNKgU4JVfORak0Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q427uOh7Gk+Wu087v+dfjs3FSXRGVp850fh/seWiYWd4TLMcN1j3Bdy6SnZpCisdXv6uNenjKEa6KWB67iRGpP6VgEDnlI6qjElZKH7thoRBZs7PzsW3vFRyKzc2sOkD4Gc4Y2Kdf9AOBDyStQ9fKQzryUlxlkJ4RNf+iNVNVw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzm89Ufc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzm89Ufc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF28C2BD10;
	Tue, 14 May 2024 10:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683789;
	bh=FOvOwitziqFIUowY8Sd26d0Y87URNKgU4JVfORak0Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzm89Ufcxlis5AZelGeBZqbi1aTyXCuhavKo458ovnGfHuN+6hmZ8uAzQBbQncCZP
	 DtclQM7tXXJfu6uU60zvtLSfAlQ4A+Ir+c2vsI4fHlqrz2f1hZYhayNeyTXydMms/s
	 IWKl5F2Md75HjYGKG+ujj1DxIqNVXi0zTfI95NkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.8 274/336] iio: pressure: Fixes BME280 SPI driver data
Date: Tue, 14 May 2024 12:17:58 +0200
Message-ID: <20240514101048.966870902@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit 546a4f4b5f4d930ea57f5510e109acf08eca5e87 upstream.

Use bme280_chip_info structure instead of bmp280_chip_info
in SPI support for the BME280 sensor.

Fixes: 0b0b772637cd ("iio: pressure: bmp280: Use chip_info pointers for each chip as driver data")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240316110743.1998400-2-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/pressure/bmp280-spi.c
+++ b/drivers/iio/pressure/bmp280-spi.c
@@ -127,7 +127,7 @@ static const struct of_device_id bmp280_
 	{ .compatible = "bosch,bmp180", .data = &bmp180_chip_info },
 	{ .compatible = "bosch,bmp181", .data = &bmp180_chip_info },
 	{ .compatible = "bosch,bmp280", .data = &bmp280_chip_info },
-	{ .compatible = "bosch,bme280", .data = &bmp280_chip_info },
+	{ .compatible = "bosch,bme280", .data = &bme280_chip_info },
 	{ .compatible = "bosch,bmp380", .data = &bmp380_chip_info },
 	{ .compatible = "bosch,bmp580", .data = &bmp580_chip_info },
 	{ },
@@ -139,7 +139,7 @@ static const struct spi_device_id bmp280
 	{ "bmp180", (kernel_ulong_t)&bmp180_chip_info },
 	{ "bmp181", (kernel_ulong_t)&bmp180_chip_info },
 	{ "bmp280", (kernel_ulong_t)&bmp280_chip_info },
-	{ "bme280", (kernel_ulong_t)&bmp280_chip_info },
+	{ "bme280", (kernel_ulong_t)&bme280_chip_info },
 	{ "bmp380", (kernel_ulong_t)&bmp380_chip_info },
 	{ "bmp580", (kernel_ulong_t)&bmp580_chip_info },
 	{ }


