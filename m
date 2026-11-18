Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023852;
	b=LFBGuORhApl4jzk/K63pEaD8nszdg+tDRBaOLV7XHrH1bUEcce6f9nS3lQp+9IskXYcE
	 tFIx6YdYx9S/+/nCjjSLB0XnEpibTxb/DHYs7QZJ1/XcMq68z7Hram1SGDNYvA1CvOK5O
	 +dALZX/63khrlzt2qqdwMvymeOsx2JF1iLe1MPCZ5aqvb+/Od2GCfSANXjEnI5j0wgFI3
	 MC8p8dOQx2No/I0BSodeum3xf28acsdgHYLF3oDvb7c3fUE3rL/loBNooAnr2JzBmtoW+
	 azawgXon5RiFnTwM4jkP9Z4fh7Vk3icwDl6HrRfZT6MgyYoH5C4eJzHRTbzWuXGxBrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pr4ls8l+FfolhWupaNAguhgryugkAo7zChCGLLHTj2o=;
	b=WhJfFPly4WzOkWhdl+ahXfv4EPxo0IlyQYkE+YHKk3RpEBAxrI9rwAFPEdNBgtGOtaab
	 bbOHqPKp6popbvLnXDNx6H3Wz/5oP50mPFftTLyO/MzbIBqntVYNUB+Bm0xDe3JF4IYyu
	 O+MkHkONB95rLn03tkK6ViM2sdXnQonTAZL1kOAo+1oSjFa86Wn8+jhbAygCntWlYb2WR
	 aG2ONVrFnDuUmIwAnIqm4hkY6vHY7wLiRfnuF5WN5KPDLryXAVB2CQBA8SEX96k3b0qSM
	 KZ0l+idHk/hxm+LrIocTs5kK+YWbDicdrpyWpD1TSaFjp3FBwaGgq582fakXOrBsOVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S+xRWCLl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E23606A31C;
	Wed, 18 Nov 2026 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S+xRWCLl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B771F000C4;
	Wed, 18 Nov 2026 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023852;
	bh=pr4ls8l+FfolhWupaNAguhgryugkAo7zChCGLLHTj2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+xRWCLlzm2NHnCcYew/l+A/eQfeU0rvmfgwVQgRHA7J7i247IXx9fG4Q74ZP3YyU
	 yO8OYgs44Y9ciF9C/YSPv8CKQKQMf+qzJsCM37JTAJVo53P+baaMiN2Vk3AH74B9br
	 1Hr2CG6xnzBikEMCCq9BlFl3kssswOlGHEI6Owmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0476/2151] staging: iio: adc: ad7816: Fix DMA safety issues in SPI transfers
Date: Wed, 18 Nov 2026 15:36:51 +0100
Message-ID: <20261118150139.350552525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 172acf135f3bd..070621cb4fde5 100644
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



