Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016390;
	b=hilo6khDT3uKqn4XvAUJxl8rtJbJFv+aFlwCazMgF9o2wJrTj0q1B8eREhBPt+nLRMgR
	 Vo0XdoHfAyjTN2tfyqtOEnh9FH0oniSZG55A+M/GMfy9XTPRc80BgT4Sq9jwquWVfzOYd
	 reZhODkp+1ElkpJehu1MgqLMl7vz62ZPy59hbjkwmmwybaL74zrWD7k736vmt9zoouYzQ
	 qrUCamY7/B8bMyJzPQTXvBnMh0SsPVIaDOZ6t/d/iEKEP6eqwC6AYbs3y95yt21vYUA6y
	 fspO5pWxJt/6uKXXbHzRaC0gTcizEcSvHPeOXkAmMsu5RejbC2sqLhhggU1C1rev6OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sLvdlWngHoKoXuo64OGAeS1vrUjsaqvfXfZIrzPbbP4=;
	b=deYPiKSgM4KMqOjmpPt3Nwr2/EdcTUzUie9EGWaSLfRkrvvFr3m7KwY9Cu8yETb23RJn
	 jgtLK5d1HPEdqqSObxbZeKQFwJUkANR1VUKd13kmcbTgowH1KkUFss7jBJQCEvbfkwpBs
	 xSEyidcio80Z2t/32WiuWNf0Zxz7QzvWHEQ2f5u2Zdqwz23basmxLdAjqoZo0iv+wvfK0
	 inOU13prhpiWVxKzYE8J3EE5JVQ3Ut66/L+4xYvRorY4eGB7QJxYQ9zCQjqXwXWplSnZk
	 btFagYwn1UFJcGSwKZLUT9vM5I4MWxHYt0BB7VHKyHUF9rhq7nqhRJ5n/gruqWyfWjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AWsf4jL/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3A660A2606;
	Wed, 18 Nov 2026 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AWsf4jL/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3ED1F000C5;
	Wed, 18 Nov 2026 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016390;
	bh=sLvdlWngHoKoXuo64OGAeS1vrUjsaqvfXfZIrzPbbP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWsf4jL/3TegF24mqOMttr16t5pODlfxOU7ubOd5FjCN36WmGhMptU8Uckak6YzBl
	 KzSpH3If3oMqF237g3TS6A9KxOvyzA49WB2d+Xbiz47b4/3DId86BTLqG3OxWcgNsp
	 850ZwQqN1vcAqBJoe57iuERoDKjtTLPS0eDgnDek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0510/2651] staging: iio: adc: ad7816: Fix DMA safety issues in SPI transfers
Date: Wed, 18 Nov 2026 15:29:10 +0100
Message-ID: <20261118150306.113684073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 30644d2d7c549..0633617642e64 100644
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



