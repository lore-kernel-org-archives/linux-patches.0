Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF8533A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301899; cv=none; b=ffTmQmA0d60pylDPNSMdmRVjSjTHJA0Rqzk/AlELAZb8iytdsWczFIrUKym1HOBho2F5nVn+07dLB6tBLPHdlej368ceBM1EU5HWDyJTLHWrB8o8aAb3yRI+tYygI7ftZf0akqioeJZQioFVS44ClH2dES6lGTlbfUKqxetQmgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301899; c=relaxed/simple;
	bh=il3/lsWtvw8duNSlZt6yDUyJae4RyzNyC7hFnB8Z2Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=en2BI3/dlTFGzWwPhGiZTSH9g0zgxtfduuW8HFRkA1X9+oc6fEURipmJtBcztiZ05EhWbaB2JZfsuvrMefJD1bO4jE/wfSR2WTcwlikveUiS7R6+9o6Bzdrz7xQatOuQ5CiVxNBgzJX/Y8MHkxPIrJhwolZNCeNz+NYvcRNSjEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mP/pDmCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mP/pDmCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE117C116D0;
	Sat, 28 Feb 2026 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301899;
	bh=il3/lsWtvw8duNSlZt6yDUyJae4RyzNyC7hFnB8Z2Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mP/pDmCjKBMv+A2P/PncJCN03ah2mvq+MEGgQBHmezeaVrcSm1ErR8aRtsqy3JnKh
	 T62lw4SI76ahWkjL//mPS/lT40heKUKgR8f+4/LSLucGQCXOO1fGv8p28x3PFSLx4C
	 RFe+Exh4fjAQVNB2LlWslM8exx5uXYFaHiUC62AD73lDzmyqDJbkR7jHPxiSHsrDeJ
	 yWrnQFoQCPVPK/iiJhhdS8MFjZolStz9kRsq2Bi8mAyTz8DNMMdb2C5KJH3RSum+TE
	 GJecdgAub80WTHVqcGL5MjXzuLNpmPzwuE38DyDb/LS0KcJ0gtJ2n0pimkevx9ojmF
	 Y6mgqBfMH/TVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/385] iio: pressure: mprls0025pa: fix SPI CS delay violation
Date: Sat, 28 Feb 2026 12:59:10 -0500
Message-ID: <20260228180011.1568201-328-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 583fa86ca581595b1f534a8de6d49ba8b3bf7196 ]

Based on the sensor datasheet in chapter 7.6 SPI timing, Table 20,
during the SPI transfer there is a minimum time interval requirement
between the CS being asserted and the first clock edge (tHDSS).
This minimum interval of 2.5us is being violated if two consecutive SPI
transfers are queued up.

Fixes: a0858f0cd28e ("iio: pressure: mprls0025pa add SPI driver")
Datasheet: https://prod-edam.honeywell.com/content/dam/honeywell-edam/sps/siot/en-us/products/sensors/pressure-sensors/board-mount-pressure-sensors/micropressure-mpr-series/documents/sps-siot-mpr-series-datasheet-32332628-ciid-172626.pdf?download=false
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa_spi.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/pressure/mprls0025pa_spi.c b/drivers/iio/pressure/mprls0025pa_spi.c
index f4807dac61e0f..241ad36f6501a 100644
--- a/drivers/iio/pressure/mprls0025pa_spi.c
+++ b/drivers/iio/pressure/mprls0025pa_spi.c
@@ -8,6 +8,7 @@
  *  https://prod-edam.honeywell.com/content/dam/honeywell-edam/sps/siot/en-us/products/sensors/pressure-sensors/board-mount-pressure-sensors/micropressure-mpr-series/documents/sps-siot-mpr-series-datasheet-32332628-ciid-172626.pdf
  */
 
+#include <linux/array_size.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
@@ -40,17 +41,25 @@ static int mpr_spi_xfer(struct mpr_data *data, const u8 cmd, const u8 pkt_len)
 {
 	struct spi_device *spi = to_spi_device(data->dev);
 	struct mpr_spi_buf *buf = spi_get_drvdata(spi);
-	struct spi_transfer xfer = { };
+	struct spi_transfer xfers[2] = { };
 
 	if (pkt_len > MPR_MEASUREMENT_RD_SIZE)
 		return -EOVERFLOW;
 
 	buf->tx[0] = cmd;
-	xfer.tx_buf = buf->tx;
-	xfer.rx_buf = data->buffer;
-	xfer.len = pkt_len;
 
-	return spi_sync_transfer(spi, &xfer, 1);
+	/*
+	 * Dummy transfer with no data, just cause a 2.5us+ delay between the CS assert
+	 * and the first clock edge as per the datasheet tHDSS timing requirement.
+	 */
+	xfers[0].delay.value = 2500;
+	xfers[0].delay.unit = SPI_DELAY_UNIT_NSECS;
+
+	xfers[1].tx_buf = buf->tx;
+	xfers[1].rx_buf = data->buffer;
+	xfers[1].len = pkt_len;
+
+	return spi_sync_transfer(spi, xfers, ARRAY_SIZE(xfers));
 }
 
 static const struct mpr_ops mpr_spi_ops = {
-- 
2.51.0

