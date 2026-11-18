Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048722;
	b=NOE84nbcQGBLl/ZPKnT5tR3t2iZRMGLNebrWLqb9yuwegz6adYVgUo/V8j74N9mBpJ7a
	 61U8s4d2T2yslAQIE/osVuCEBnoVE+uwpGVzLknb1pCV8jTgau9mUCpfPB91gOnC861gU
	 M8MD1dTPAL/uUE9O8IEggigQNIZqIjnLuiRRG1TjnQWXwyUrObXQWk3bKxYBRdQ3HVIZK
	 9yMuGIRS/zp1ZB4mcrkGVjov/v50t9Wm5cG6Y8ZNih4uHB1QEWbNtn4xPrrfpLjIT2z2A
	 ujXZzC6l1MAF1eC97Sq/BtjP03r5aJPvjUxhtz/5ENp9fEdQ4yetKpZRTlQ9WFrISDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iT3hxfCK3B3Rh7VJgBqhVJoRax3smYrcCExivIdeBZI=;
	b=sDUxcmC/Dy6RIXbbZoJ4jtDf4JnO2MpRGgHN7ahBYGJC5NoKumJXYhICtadCyvOXdC/+
	 7tXKKYEjXu1mfYdbWBPtfqcyXGsU/FWmMvAlUgK8tqzEK/e+gIfYQiA5p3tLXZfVcdh6L
	 5xRFJi/SpRV2MLrpuYX2Bd6/4yVq5CAfAZCzV7/M73rjoOPR57Mcv0F/OaaLUlMEfigiI
	 7T63v2ocsCUJFWVKbo5Us26iXxu5z7Vcd/6MkPd3EHhOMtOM0aOjbLsOEDzc4pWL+IUAA
	 XT633b7zlSwD9TVySLVUmO7QiogAPxV4iZlPrwc9wu6zb4OpWc/nJtdIM8oOBd3IymQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mmqLeIl4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F68606A320;
	Thu, 19 Nov 2026 00:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mmqLeIl4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ED71F000C4;
	Thu, 19 Nov 2026 00:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048722;
	bh=iT3hxfCK3B3Rh7VJgBqhVJoRax3smYrcCExivIdeBZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmqLeIl4m718gCWvV99Mr8agRW88BxCAcK6w5tDivmC+xhYiA3WgorVfzPLH2RjIy
	 5tMfnjW5t25Xn9ZxB0aJVT/lyFDj2Z35j8GVm7DDKr54wS5VAHlrHEoXy2FrH7ILsp
	 E99plbssj6sJhHMMaY2Q1PUaNUJ+DbETf7CLjMIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2096/2857] staging: iio: adc: ad7816: Protect sysfs attributes with mutex
Date: Wed, 18 Nov 2026 15:52:10 +0100
Message-ID: <20261118150316.875852081@linuxfoundation.org>
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



