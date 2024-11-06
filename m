Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E701DEFF4;
	Wed,  6 Nov 2024 12:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894812; cv=none; b=lxm7JwrdJpJiM+nv2HKTQL8V3f+66959LUw4yjShbGHo/uebD5VO6OAoGu4Vbr/AFjf41gTGzJZTcML44CeKLMct34hKnyl65Gnc2TfQroTgMSSGgYxdpK3m1DTbiNeGz2IVZ6kdYRBbGI7p0tr7HcxqDlAEnLDA4C9HlIdxMVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894812; c=relaxed/simple;
	bh=HOgOvCWXAACyuS2iSxOS3wm+74GE3vSf7jTlqppDZpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huGk2szS4li+eaiYeVLILfx1V469UvwcuybcwkN1SC0ZNOSDlrNNMW1o3gvwrEvKniCaUinZ2rDy9wsbnt0Gm1c4xuoUbAS7cgknZzT4ALstVJcFsq/G6mXD2lOYW6Wxoozi16v56Y7zuuAflfs25RlsnGpbDcTYKt9/uJ0FERk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJ8m6Fgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJ8m6Fgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27D3C4CECD;
	Wed,  6 Nov 2024 12:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894812;
	bh=HOgOvCWXAACyuS2iSxOS3wm+74GE3vSf7jTlqppDZpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJ8m6Fgl415x0Z+pD1qWMZr2//dAkWqng2TMYW11AuKcmenZi6d/QJfJvfui46jRt
	 ID1O6jRXzqN8nZ4rw0grH1hwxbHl+UxIpVtS5Q1wOPNRxyF0yR2wpThfiEZ4g/oXDU
	 JV0gFXrRmZMbkwMoiRG3Pt7xav/BrX8kwlS65dPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beniamin Bia <beniamin.bia@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/350] staging: iio: frequency: ad9833: Get frequency value statically
Date: Wed,  6 Nov 2024 12:58:49 +0100
Message-ID: <20241106120320.904133443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beniamin Bia <biabeniamin@gmail.com>

[ Upstream commit 80109c32348d7b2e85def9efc3f9524fb166569d ]

The values from platform data were replaced by statically values.
This was just a intermediate step of taking this driver out of staging and
load data from device tree.

Signed-off-by: Beniamin Bia <beniamin.bia@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: b48aa9917589 ("staging: iio: frequency: ad9834: Validate frequency parameter value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/frequency/ad9834.c | 21 +++++++------------
 drivers/staging/iio/frequency/ad9834.h | 28 --------------------------
 2 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/iio/frequency/ad9834.c b/drivers/staging/iio/frequency/ad9834.c
index 4c6d4043903e..f6b36eedd48e 100644
--- a/drivers/staging/iio/frequency/ad9834.c
+++ b/drivers/staging/iio/frequency/ad9834.c
@@ -389,16 +389,11 @@ static const struct iio_info ad9833_info = {
 
 static int ad9834_probe(struct spi_device *spi)
 {
-	struct ad9834_platform_data *pdata = dev_get_platdata(&spi->dev);
 	struct ad9834_state *st;
 	struct iio_dev *indio_dev;
 	struct regulator *reg;
 	int ret;
 
-	if (!pdata) {
-		dev_dbg(&spi->dev, "no platform data?\n");
-		return -ENODEV;
-	}
 
 	reg = devm_regulator_get(&spi->dev, "avdd");
 	if (IS_ERR(reg))
@@ -418,7 +413,7 @@ static int ad9834_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 	st = iio_priv(indio_dev);
 	mutex_init(&st->lock);
-	st->mclk = pdata->mclk;
+	st->mclk = 25000000;
 	st->spi = spi;
 	st->devid = spi_get_device_id(spi)->driver_data;
 	st->reg = reg;
@@ -454,11 +449,9 @@ static int ad9834_probe(struct spi_device *spi)
 	spi_message_add_tail(&st->freq_xfer[1], &st->freq_msg);
 
 	st->control = AD9834_B28 | AD9834_RESET;
+	st->control |= AD9834_DIV2;
 
-	if (!pdata->en_div2)
-		st->control |= AD9834_DIV2;
-
-	if (!pdata->en_signbit_msb_out && (st->devid == ID_AD9834))
+	if (st->devid == ID_AD9834)
 		st->control |= AD9834_SIGN_PIB;
 
 	st->data = cpu_to_be16(AD9834_REG_CMD | st->control);
@@ -468,19 +461,19 @@ static int ad9834_probe(struct spi_device *spi)
 		goto error_disable_reg;
 	}
 
-	ret = ad9834_write_frequency(st, AD9834_REG_FREQ0, pdata->freq0);
+	ret = ad9834_write_frequency(st, AD9834_REG_FREQ0, 1000000);
 	if (ret)
 		goto error_disable_reg;
 
-	ret = ad9834_write_frequency(st, AD9834_REG_FREQ1, pdata->freq1);
+	ret = ad9834_write_frequency(st, AD9834_REG_FREQ1, 5000000);
 	if (ret)
 		goto error_disable_reg;
 
-	ret = ad9834_write_phase(st, AD9834_REG_PHASE0, pdata->phase0);
+	ret = ad9834_write_phase(st, AD9834_REG_PHASE0, 512);
 	if (ret)
 		goto error_disable_reg;
 
-	ret = ad9834_write_phase(st, AD9834_REG_PHASE1, pdata->phase1);
+	ret = ad9834_write_phase(st, AD9834_REG_PHASE1, 1024);
 	if (ret)
 		goto error_disable_reg;
 
diff --git a/drivers/staging/iio/frequency/ad9834.h b/drivers/staging/iio/frequency/ad9834.h
index ae620f38eb49..da7e83ceedad 100644
--- a/drivers/staging/iio/frequency/ad9834.h
+++ b/drivers/staging/iio/frequency/ad9834.h
@@ -8,32 +8,4 @@
 #ifndef IIO_DDS_AD9834_H_
 #define IIO_DDS_AD9834_H_
 
-/*
- * TODO: struct ad7887_platform_data needs to go into include/linux/iio
- */
-
-/**
- * struct ad9834_platform_data - platform specific information
- * @mclk:		master clock in Hz
- * @freq0:		power up freq0 tuning word in Hz
- * @freq1:		power up freq1 tuning word in Hz
- * @phase0:		power up phase0 value [0..4095] correlates with 0..2PI
- * @phase1:		power up phase1 value [0..4095] correlates with 0..2PI
- * @en_div2:		digital output/2 is passed to the SIGN BIT OUT pin
- * @en_signbit_msb_out:	the MSB (or MSB/2) of the DAC data is connected to the
- *			SIGN BIT OUT pin. en_div2 controls whether it is the MSB
- *			or MSB/2 that is output. if en_signbit_msb_out=false,
- *			the on-board comparator is connected to SIGN BIT OUT
- */
-
-struct ad9834_platform_data {
-	unsigned int		mclk;
-	unsigned int		freq0;
-	unsigned int		freq1;
-	unsigned short		phase0;
-	unsigned short		phase1;
-	bool			en_div2;
-	bool			en_signbit_msb_out;
-};
-
 #endif /* IIO_DDS_AD9834_H_ */
-- 
2.43.0



