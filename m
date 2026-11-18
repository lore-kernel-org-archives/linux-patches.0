Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040310;
	b=lsXWJDWU/YA1djYFbHd5WdLO79UqGWZgzUR5dzKUQdXENFFNSwAghNq73Loh/E/nlnrM
	 +sWbInW54ofuoJMvHUKKxMbAo2a2YXbUWacUew6jZD1aC1w+JE2lkL+vIHrnXV7Fr6EPS
	 AF6vEGIDQxvt5oDRVizzRcsTlZdN1UU58zgnaoRnjjsnIXrIsS8XAweJJ1g7rL7hK8MLV
	 NZwDV3fialV8KHPwX8Go7JduxLU1vUULLwcuYEjwUlFoHH/RMK6jLDAxm5xHkzS2ZfAFu
	 kHrNZbJeQWoo0ZtEM5HyoNiI6SQlaDhYuAyCRhjYZoO375yWMlZdY5+H6UOHMfOVnVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BoEz5t1Nfsc/a9W5kOE1QPpYjPMosi8sH3fTlDSs6bA=;
	b=C5kzBLga0quxUFEgk/zeUVmnBh4DcPEPMyZFMdUSB/iBmOtuQL15gW5w32H15LnYghNF
	 K90siPvMiPxhb6fF1Tz7L+eGNtWDMUQDJ/8PxGT7dt0ryxnXOd7d92bogQJuoJxqJrQ2L
	 Vt9cqyg+PwHQqHdQw8tx85k8DSm7tqJ4Uv/en09pZb4m+tcSY8kcu8j5VDwNNOnYq4Yso
	 wZf64rEdMA2Y2hgyoc4EDjMxrYIpo1GDWjj8mlFzMfYEH4jHF3zXxpyGPkrBHrZUVroHy
	 bwch472d3iScQ5yIwMFbR9pp9zfKJbTAMlRorNtbbOTzhGvmuujPf6RGV/ZpKZaBmYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxn3u01C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0042606A31C;
	Wed, 18 Nov 2026 22:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxn3u01C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4052E1F000C4;
	Wed, 18 Nov 2026 22:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040309;
	bh=BoEz5t1Nfsc/a9W5kOE1QPpYjPMosi8sH3fTlDSs6bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxn3u01CzahehcMwhmhk7KY2zh3RRSe1v19QfIL5HRnlI9OPCG0rkXQaYXn7km2US
	 k3S6fTq8n57eQlkbTgpmymtqZP1WPRk4tipd78nTQKkhRUdtxvAPrZi0yxZ1IlD9h8
	 ssmfu52IFwhmHZUkPAtLrQjXmG8CWHkFOEbO+drI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2412/3318] staging: iio: adc: ad7816: Protect sysfs attributes with mutex
Date: Wed, 18 Nov 2026 15:50:34 +0100
Message-ID: <20261118150433.851978484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>

[ Upstream commit b96187644664d10b641dddeb7ca2eeef97a77c41 ]

The sysfs store functions modify driver state that is critical during
SPI transactions. ad7816_store_mode toggles hardware GPIO pins, while
ad7816_store_channel updates the internal software state
(chip->channel_id).

If these are modified concurrently by userspace while an SPI transfer
is in progress, it could corrupt the hardware transaction or cause the
driver to communicate with the wrong channel.

Add the existing chip->lock guard to these functions to serialize
access and prevent these race conditions.

Fixes: 7924425db04a ("staging: iio: adc: new driver for AD7816 devices")
Suggested-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7816.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index ade1b8db197d4..aac3de84e0a87 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -143,6 +143,8 @@ static ssize_t ad7816_store_mode(struct device *dev,
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ad7816_chip_info *chip = iio_priv(indio_dev);
 
+	guard(mutex)(&chip->lock);
+
 	if (strcmp(buf, "full") == 0) {
 		gpiod_set_value(chip->rdwr_pin, 1);
 		chip->mode = AD7816_FULL;
@@ -207,6 +209,8 @@ static ssize_t ad7816_store_channel(struct device *dev,
 		return -EINVAL;
 	}
 
+	guard(mutex)(&chip->lock);
+
 	chip->channel_id = data;
 
 	return len;
-- 
2.53.0



