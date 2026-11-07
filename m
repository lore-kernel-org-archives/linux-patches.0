Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064267;
	b=1zmHlCX6dSa5hGaAHkrAW0mtp0Cr4dt1EDM8VUWSYN2DP3GnzdK2vF+jV6EQmrDyHY8J
	 hqHECvP4Wwqd5TRfhqrwof05cG1vTklKKeuUO7b7pay+YA2+YagUXIFXrRBSnr3hZqtYm
	 3MqHBTTgPvgqrnZ+v6ggMMgrCA2aHE9Xvie9b2dQbB9nLhWoR9MyD0Jxm7TziWIijATWK
	 GJClL83/gh4+6F4oMpH/75fVL+n5m5ku3WxYUEJ9lNeCyV91xFgdHxnoPSU8fp1GHZxPt
	 MPd40c7m6aRVhlcDbmpRvvFIVNREcN1jQc2mJ/7VJO/5919k0e04A6JVkCoqVvx+RtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/B5zbC1jWfQsvRa+GfSg7hhqlTHCiLDmYiT7XaQuDUg=;
	b=wtzkB2V4kRiIq8RJaLenujnFkkiB+IffzVUC9ub6GFVNNxt2G97Mgq0T3idqm0m7vuoe
	 nhRmuAmxSs4xRy/H6j1IVbCaBc/NHDFmCf4JFFOUfWSOw5wrs91f+le2O8/3e046OIWwN
	 pW3HKvB2olOcIptq3as58c9GBEpltwZQd/ASAVRczTfRMU4EUhUxwlnMZYaF1OLZuYyz5
	 0ECzH+9+2tNryaOgeOcJ5DL5ZUMVo0VPY6T5dG5jUyBArcwXgQdVIJIog0bz1Zm+VvS94
	 JtrKJ6RLD0hhlEknObG8vrRdPJQLLNPafwbZNuaZ5bMLqOBtxGFLDtbFb082RoBItGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Q0G3Dg9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD88B606A334;
	Sat,  7 Nov 2026 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Q0G3Dg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8A51F0089F;
	Sat,  7 Nov 2026 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064266;
	bh=/B5zbC1jWfQsvRa+GfSg7hhqlTHCiLDmYiT7XaQuDUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Q0G3Dg9ha9KXdp0J7oIIYvTeEFeeodkSSmjCSTEK11+u8YJ1R4wyW6X3Tnt0u2Sb
	 vDg85DuNwB1xIDoNxYcaZMJorQZ8R/KPsn1bYB8RC4VIvhk/cGslhrcS1mmC95bHD2
	 fFfXtr+jKhzKiUuazFTuFt2cWuo35CjSDzwILMyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0338/1257] iio: adc: ad7606: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:54 -0500
Message-ID: <20261107134948.741962215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 1ebdfb8580ab5..8c479fa50a237 100644
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



