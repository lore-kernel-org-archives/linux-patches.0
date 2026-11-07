Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063068;
	b=eFA9JAjEQCVi0n2rYQmxHLjOToO5X/LzVFRsPT3Bd4Acjjfh1ykjAmfotgeS2aQBrTga
	 F2vnJUVWUNuuVavYoChs6pIbPREGNtIf2VQpOCP0I2U7gti4ASbbFx8f8dE3EzmIoUSRi
	 UFJKYv40WwmHfAq2NAVhdXbpM4C7Y+MphjS//uaxlnoZiW0wWH6RzMjWYTktmBs0aTkG8
	 DIOvPz0r9xbZZ7ny9jLOQ/KeEAuPKcpWQigvnELrlt00FtXAvhJCOABNKKDS3i1tht2Aj
	 fNb8RoYjMOGa/yXIKK8mWS9ql17CjslYIJdphfB5Ob4uwbxMgXSM/y6ZEoXugKAVpxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w1lIVpswErODzGvLzlmwdAA07A460Tkj60E+IHw33Rs=;
	b=EXygPqxA0TtWc2NRB1esHVJUE7NMc8y4gVn49kXVlc824JpbeEfAHpcNZP5Y2qZFnWAd
	 IKAt2stUU3Dkn1Ckauh0H4mXKR9wUFv4VLa/9u5uF7Y+7uvgz7hu/obaqgxVI/V6RMXPk
	 QbQ8abcuwF1b8iIJI9HfiINHFFFTXyqwtUwCxKo/Sa0hYYtShHOmIef9U2clwhc5132S9
	 2I2Zyej4IIXhtmxG8txskobZDS0IkdcZ3QgpbO1roCFDNMLbG4/ZXLKYW5T+bYQCVxB9K
	 hs80xdV58wi8tney/oQNgV90/4g1Vmh3e0OUoV209ghXTSbEggm0+hdnXPnrzV4/Nng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1uPMlRS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5AF606D825;
	Sat,  7 Nov 2026 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1uPMlRS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB171F0089F;
	Sat,  7 Nov 2026 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063067;
	bh=w1lIVpswErODzGvLzlmwdAA07A460Tkj60E+IHw33Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1uPMlRSbZ6Td/C2dzrNuXqQ3tmd+SGW9zEwtHkZKoDRQfLmMrxGQqSLEnJZlTyeI
	 ugIMnsrOFUjadiS6rs55kKzApgFGOsGPz5wWnpJQpIBYGRDGrvvzMVeEwd8PO5BmM0
	 ADM1uv8bfggvtBM1f3ooZqerx4uS3ynF96hRzym4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 272/869] iio: adc: ad7606: reject devices without match data
Date: Sat,  7 Nov 2026 08:49:14 -0500
Message-ID: <20261107134900.898237871@linuxfoundation.org>
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

[ Upstream commit 7830650d5293a0f412a869225262ca51b661e49f ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

ad7606_spi_probe() dereferences the returned bus information to pass
the chip information and bus operations to the core, causing a NULL
pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before entering the core.

Fixes: bc69e9fffde4 ("iio: adc: ad7606: Add compatibility to fw_nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606_spi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7606_spi.c b/drivers/iio/adc/ad7606_spi.c
index f28e4ca377076..bec3f656406bf 100644
--- a/drivers/iio/adc/ad7606_spi.c
+++ b/drivers/iio/adc/ad7606_spi.c
@@ -456,7 +456,11 @@ static const struct ad7606_bus_info ad7616_bus_info = {
 
 static int ad7606_spi_probe(struct spi_device *spi)
 {
-	const struct ad7606_bus_info *bus_info = spi_get_device_match_data(spi);
+	const struct ad7606_bus_info *bus_info;
+
+	bus_info = spi_get_device_match_data(spi);
+	if (!bus_info)
+		return -ENODATA;
 
 	return ad7606_probe(&spi->dev, spi->irq, NULL,
 			    bus_info->chip_info, bus_info->bops);
-- 
2.53.0



