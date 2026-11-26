Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704875;
	b=4e4zi3KP9rJGbQntXI0Hr50tkYkEPAr8Fb3s3xv+9NvvK3dTzQHIA0B2VhKbNW886T0F
	 Ah8QPJ95YmfXNUMxvJ0hJN4Fn96Ywhc2cvr1tUHvYJXt589x1PxQYVSuMvkc46RmbZ7EN
	 GB4BoIyO6ktOIvPr6BvJe080yZXRZoOqdLaZIDiA/QxgOjdCVPeJjFvrDR3qjLJsR9Cl9
	 O4D0FSlqkVpT4C5n0VRgDmttcydjJWzWBYjFuMe3WYLxV79FDCXoXpbb+JjmE6Fzt+r70
	 kCFkQR1SwCRdFm+oByzQp5Jo3aQiJ+hJuIiZCYQJxtM5YVfhVHp9eqPM4ZyPMcYGdfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBd1XolBmQVb+kGsdAaAh8QzlkqHF5SY2J7O5GA2aX4=;
	b=c9wRtxalu4bM7Qfa9TM6Fv8V0RUeetYUKzmSwdrFdDyreLi4yEfg5XRHrDNaVnovmEdA
	 SeUHWbPSEO/P4Cs+7HGRWQPCSN3/dT6E0AapE2HOzmOAjUogNy72GQeuSfQrYmKWC8M1a
	 Rj0Scgevb+Eg/vC9Kv8lif8pw8yNO4K2yH1JUsfKT+/B1Yjf5vA2PSLEnhk/8e6mq7eXH
	 JfBHYhttgzXddIujVQXNkKp814nHYSfYJX7CucemSpKpNbWtEyaM9QaHgR16gY4o5x0a/
	 YTgc9szUsyT5PhSe0Foe12RrtDyZyj35K436nu078XpuR+DIxu2AoSnXP2fU5EBPDyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="An/vbzox";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B407606A31C;
	Thu, 26 Nov 2026 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=An/vbzox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08401F000C4;
	Thu, 26 Nov 2026 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704874;
	bh=hBd1XolBmQVb+kGsdAaAh8QzlkqHF5SY2J7O5GA2aX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=An/vbzoxSFfK4XA37aq/X8xipCZC70Rk9imXiIlR2WpQO2nBOr6YFnqzmLCDf2WCz
	 YZMqy520MtzZ9QrZklWxpnonAFl4gl+iN/5WqC/20dSwCYpN5HxN9ev9WmK3e8wIHF
	 04VQMcCWmyWYOV2M0oBxj1NIDd3TiInopHhmnzCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Matt Ranostay <matt@ranostay.sg>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 244/265] iio: atlas-ezo: Fix humidity channel read support
Date: Thu, 26 Nov 2026 15:39:34 +0100
Message-ID: <20261126143622.316906074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit 0cb3fc8987038a26ac0f581bfa26b16daf6ca6a7 upstream.

The atlas_ezo_read_raw() function rejects channels that are not of
type IIO_CONCENTRATION, preventing the relative humidity channel
from reading raw and scale values.

Remove the early channel type check to allow both concentration
and relative humidity channels to reach the mask-specific handling.

Fixes: dc3ebfcaa51f ("iio: chemical: atlas-ezo-sensor: add humidity sensor support")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Matt Ranostay <matt@ranostay.sg>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/atlas-ezo-sensor.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/iio/chemical/atlas-ezo-sensor.c
+++ b/drivers/iio/chemical/atlas-ezo-sensor.c
@@ -115,9 +115,6 @@ static int atlas_ezo_read_raw(struct iio
 	struct atlas_ezo_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
 
-	if (chan->type != IIO_CONCENTRATION)
-		return -EINVAL;
-
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW: {
 		int ret;


