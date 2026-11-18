Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017775;
	b=nvKJrSG0VKohnER7HdFTxVifCFZB5/mKBvuZ4U3Yh9rlcsrJwSulTAimFYi2yud3LLW8
	 Ew6UPhoZpu9L191EW70IgCypIDHbzr7z1/5ea0dzb3jJOWIjVGcSxT+TVTQI/YSyadOOS
	 +dTV4rqZHPxgLkdkksWmJ2g7fga6VurMPRI/BGnurA26OoUy0X8kdRR0yFhvLAr/38Xzd
	 wXpIDAoBclkUYPo2c5xP0ikdHGSJFA/EJUcQzi+p8Ys1CiKo2L7iFmK8yTC2azEyA7HoX
	 vmdpsXHEbdeGFPnBNtlyfKLRBz12+PHl3LznGJIGioao2+B/WLHWawKg674FKcWR0Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RtFI9cPWdOJCrTqiCRA55lxo+vd4gdOa1oESYcaTG9s=;
	b=hwjHnwm0Yll/8uqnm0pkWhtvfudnCLwGxdl/PWzAUHIwGY/Gef4zu2XdLwETzRnIsE/2
	 54lWVJgWXhiD/hYF6ZhmWaMr7RtFFW2RG0gN3Mze7ajP0idalO4x0DfmU5Ic1yA9eTv7/
	 zdvwn53q9jNe0T1B2RhNlTy9Lzs0BT5dCa/nWoJRaEr+1unS5+ClzNg3HXre8DqtaZ5Sp
	 Wv3Q91u6F7tHQY32Am0SsDyfDiJ5c4vuvhP+bgCDzVEApLf0lJGx1p2Kzu0qxzbOFp90k
	 nKVlfjDCmHXRJL7X/WafHL21dNGLeLG0Dr1pZqIZoIFofpSXkeRRVcqezf3wE5htdHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibysF+XR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CDA606A33A;
	Wed, 18 Nov 2026 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibysF+XR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4B11F000C9;
	Wed, 18 Nov 2026 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017774;
	bh=RtFI9cPWdOJCrTqiCRA55lxo+vd4gdOa1oESYcaTG9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibysF+XRe4Qr27Yt3lnKicd7KR5NwVBJ64lEgof3LSrLHJTPFwNhY2sXaHKB8c8iV
	 Vqrhk0AybbnEH2dr9gV9eEbL0zUk/W8cfeceKJpDwWDAtLDL249y4WShMW/nXBU7R5
	 OdZ9zpKVS2NKC2iakkDG1O60ctx4fJGCyOio6GIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0954/2651] staging: iio: adc: ad7816: Protect sysfs attributes with mutex
Date: Wed, 18 Nov 2026 15:36:34 +0100
Message-ID: <20261118150322.246281392@linuxfoundation.org>
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
index f76f0215119ae..2a15d7598abb7 100644
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



