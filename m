Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048322;
	b=cqRfeL1j/LJd0zC+k1XC6+TbD/rF6QJDzFTXJVv7PzG8iwg/X/Tu9OC7APO00c89Fi9Y
	 oEud+I8vl1wYFcHDqYEoT95nQApS1SOcYFvIWKCwFsHmvbFbWKs47jcq/pHxC1vJ7tiba
	 KcLBgBXLYPhdm6lc27xdnEVwaEeW/Rm4mHIZMwXKePcyk4DN4IY7BJSv4MX7l3O+FhX6Z
	 6s3Tol0eILut1kKQrqL8ZwmQFUOTVYcQS6AWmjLpy2yAo6oO7ou3Xrs6g1hxaLxd/Llbl
	 8tVZtaq0FnZAKhgpKKSt5EpDtZqWmbTVEN/voErs6HV1C/DHciYQGra7OIXytGNjSpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DnbTz5BHebpIpQUpnxMRNgm577ya11kNSTU/Bse+7Sc=;
	b=uY1Y1Lq4LpQCHW479bQFl6E/OKZ787Qb3alw615A2+V+ZWphIdwsyH6mDFSwlGkR2B53
	 6U71JqB/5AzlDV6LWF2NDkvrES2Rq6Gd/MGrLyHZW45I47JFKZC6J7BJI6wmpEprzwNau
	 lVlsyREEcGZBYq5ASEBYx2sznAP2yhEWf7nOBlfPmY0fv94AhEYu2MtvHDTrgloH2gtv0
	 F1rjdbuuuRFdS0b6PpBe6SSJlz9dj1tNvK05phFg9UNEh/Tkxm45bAZ1xrjJCI0ItuIbp
	 NcBNHp430KkagG58MTLOy/pYHTX/39fSmvsRy5m6tCIlJYUdwwrO3hGkLdCoenouI4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iZo17D/q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7511606A320;
	Thu, 19 Nov 2026 00:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZo17D/q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB331F000C6;
	Thu, 19 Nov 2026 00:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048322;
	bh=DnbTz5BHebpIpQUpnxMRNgm577ya11kNSTU/Bse+7Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZo17D/qx56Tfq00UmCjMCVqSIH9k1iOSjFgz3ePaM4jmz4unZgrXKaK2NVrZ6xRS
	 cxDz8YQxzjmWLs+m6u4lCNzt7nZW8N63FmXO2GvdxP76s1VyYzqTCvmWuFvoH0AEH6
	 MAvKsS/5XfElEsw8SAIjs8VNkGdVoOG1AzOuHu90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1954/2857] staging: iio: adc: ad7816: Fix DMA safety issues in SPI transfers
Date: Wed, 18 Nov 2026 15:49:48 +0100
Message-ID: <20261118150311.769663398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>

[ Upstream commit 69fa76f0af3414cc189c3b0b807cb59e327ecc00 ]

The SPI operations in this driver are not DMA safe:
1. spi_read() uses a stack-allocated buffer.
2. spi_write() in ad7816_spi_read() uses a struct member that shares a
   cacheline with other variables.
3. spi_write() in ad7816_spi_write() passes a stack parameter by
   reference.

Fix these violations by replacing all spi_read() and spi_write() calls
with spi_write_then_read(). This safely handles DMA by internally
allocating a bounce buffer for the transfers, avoiding cacheline
sharing issues without needing dedicated aligned buffers.
This implicitly corrects the size argument in read to sizeof(buf).

Fixes: 7924425db04a ("staging: iio: adc: new driver for AD7816 devices")
Signed-off-by: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7816.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index 081b17f498638..a46ca0559b6a2 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -69,7 +69,7 @@ static int ad7816_spi_read(struct ad7816_chip_info *chip, u16 *data)
 
 	gpiod_set_value(chip->rdwr_pin, 1);
 	gpiod_set_value(chip->rdwr_pin, 0);
-	ret = spi_write(spi_dev, &chip->channel_id, sizeof(chip->channel_id));
+	ret = spi_write_then_read(spi_dev, &chip->channel_id, sizeof(chip->channel_id), NULL, 0);
 	if (ret < 0) {
 		dev_err(&spi_dev->dev, "SPI channel setting error\n");
 		return ret;
@@ -91,7 +91,7 @@ static int ad7816_spi_read(struct ad7816_chip_info *chip, u16 *data)
 
 	gpiod_set_value(chip->rdwr_pin, 0);
 	gpiod_set_value(chip->rdwr_pin, 1);
-	ret = spi_read(spi_dev, &buf, sizeof(*data));
+	ret = spi_write_then_read(spi_dev, NULL, 0, &buf, sizeof(buf));
 	if (ret < 0) {
 		dev_err(&spi_dev->dev, "SPI data read error\n");
 		return ret;
@@ -109,7 +109,7 @@ static int ad7816_spi_write(struct ad7816_chip_info *chip, u8 data)
 
 	gpiod_set_value(chip->rdwr_pin, 1);
 	gpiod_set_value(chip->rdwr_pin, 0);
-	ret = spi_write(spi_dev, &data, sizeof(data));
+	ret = spi_write_then_read(spi_dev, &data, sizeof(data), NULL, 0);
 	if (ret < 0)
 		dev_err(&spi_dev->dev, "SPI oti data write error\n");
 
-- 
2.53.0



