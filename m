Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024685;
	b=iqQ7nrFCBBX/1n2DM1xrtrxeS8E02vEtJgxlBvvcW6a8neLXPPFKP5NpBTiaMF+7nPQ9
	 JUi/6EYkpyj3V4ljKtNtcSWFLJdloRWrZ2FsvxYQ/s18wxN2p3Erx9KLl+BMo8ISDNZDJ
	 ZDyX7AUkZZe/k/GOxxaNbUUAjJjE+bT3wFfN9JYrDVaM2j05/Ckg8nn8PQd4+r7T0e9WJ
	 WdiOL7itnxHwSZfjLgU+HvUIXCkdzHrnhYpt13X5pTgX1GGSnAcNe8m15KSCjps/TuT9e
	 TjeIAGZoJPv6UFJOQbfSg9z3hPKblkh9ZW0L3kIID5IrJQLZiZaWuDSGXlizv/JZHxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f8xWv2a345QAVbgt5t2DElhINUUGiDU5qMdDT6aMdnc=;
	b=SMUe/vPmd2qfFxaJC1VEZmWwEK9rANtkTOGx6g+N1N3z3n/sD0caO0jpCjGH5eNcGc/u
	 uT1jgLNoKgQFr3RhXVh7SehlUP6EN/x8Ty7TAsceOBFo45odFNMd0Z2olXtg/2/ab7CZc
	 vquLV+7/YWJZ7KjLF7V61yW6M3gioQKzihtDVikGRaXB8TooHIvZi/Xd3V/bqb8NGNrWF
	 9wzN6VWa3JOpPEJYVz8/SxJ39k3+HU+OwNHhDXvPOqjHgoaFkSnSpO7Wzwyu6stmjyoU+
	 Z5Jc7HuW8h799V3Exiqe7WKt5phrJRMJclQMBevcv2Wz08YCWY3mZIsTf2m58VmnSgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Omxpxe1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2789606A325;
	Wed, 18 Nov 2026 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Omxpxe1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505321F000C4;
	Wed, 18 Nov 2026 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024684;
	bh=f8xWv2a345QAVbgt5t2DElhINUUGiDU5qMdDT6aMdnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Omxpxe1BdKhgYpd8KVtE1t8eCc2zixRBJeMtez4g9Pcy+zJ0Obc0HTvjWAMEJbWPA
	 MiV9vGsODC72nJHwrzaV5s1KLgzSGL4SQbGrc+b82xv0u2qdSF4vNe4dcAf+AtqmVW
	 7L+7zDC3JAySVMNGFwX+hNJaQGOMPSZbfkug7C0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0812/2151] staging: iio: adc: ad7816: Protect sysfs attributes with mutex
Date: Wed, 18 Nov 2026 15:42:27 +0100
Message-ID: <20261118150151.616911604@linuxfoundation.org>
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
index 45ae9f101287a..2672630aaf76f 100644
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



