Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064253;
	b=cS6ViNhv8rkt1xeozVPEL2cW0zKYu0655HuNHmD1iL9wkfTW26Qcwgt1X9QrjpikqPYz
	 6S+ALt28QyprfLvUd+y9GASXu6FqOzy7ndkZV1UfVPYXuOxroXhumXx1wr++ixEx6WDsS
	 Lihl5kxSqPuSWpqoJUq76YMTCW2undGCaPogC5JNPd+tpgjAAwm+XyPP8a8TFcAMw+NSb
	 5XI8vL+cPl28bnb0gGkClZCiSmDWbyCCWK4iOswlMhtpAOixDFaRENcRjOsRceETmW6tm
	 kDW7P41zkSFnTgyHC+YMdfXojsWeOUNxzISDaLuTbBAHj1v3AWB0/FXrIWM5luEF/1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zUniO1Q2hY+6h8mpj/s72WdWg4IY3v+DkuL6HJDjrX4=;
	b=ZSXDUlVzRZen4XJ5ltOqxx/2e3FaH/dfLl8aVFyxnjlcgHnRh4q0kDQ1vHeWUp6d1KBV
	 znjDuOuBx/tBODtYZ64erAmxn4+juZbT4QgohfkbyhByIveGkETBZrDo2Q/DxaDrOJQk8
	 wlcSZ5PSa0ajuKp5+poZ3fON7VJvs4yJrp3N4d+Sr9Q7qzTiai1jWv98m+SCBt+RjALD5
	 jPkcgZMJ1eJA5opaLsLt3AqzK2nKOAC5TEAVIEMxh2IgEZq8Jf/jFiWwuXupNp4DiCZL+
	 i0UWOD6WU8n/iv+qRJ6xgUvePARBVzyqAN+OJwrk2eb33CIQWn9rs085zqUpd74J7pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXmvUp+B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AEA606A9C6;
	Sat,  7 Nov 2026 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXmvUp+B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E611F0089F;
	Sat,  7 Nov 2026 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064253;
	bh=zUniO1Q2hY+6h8mpj/s72WdWg4IY3v+DkuL6HJDjrX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXmvUp+BIRCtx8bscZoofo+gs6JKVdSIK49fRMEK7gDyZvwGCRyK4ibvA6Z3dtXD2
	 UHRuj394BcBgQCbH0Zbv7ZS9UVCK3sJg9bxANXVqniJE7G5T26QZuqx+X3y9YGj+nc
	 ov1l0t4xZxz5+a4svhMzyMmuJwGUw/i178KRfjYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0337/1257] iio: adc: ad7192: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:53 -0500
Message-ID: <20261107134948.717420931@linuxfoundation.org>
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

[ Upstream commit 7f7a119a370ecf6c8d4ab9e9ee0a8cdd77afedd3 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

ad7192_probe() immediately dereferences the returned chip information
to initialize the IIO device, causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before using the chip information.

Fixes: c3708c829a06 ("iio: adc: ad7192: Convert from of specific to fwnode property handling")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index d8f5886fcf694..8bd8105463111 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1406,6 +1406,9 @@ static int ad7192_probe(struct spi_device *spi)
 	st->int_vref_mv = ret == -ENODEV ? avdd_mv : ret / MILLI;
 
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
+
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = st->chip_info->info;
-- 
2.53.0



