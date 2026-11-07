Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064285;
	b=thpkEnWCOqzlPpxOaFdSb8YCrOWo+ecd38INGX7qW+kWpzU0FfEcJGuvjCtVv9f3/mMf
	 1vZxedX/SQ/Kxi4mrkZXqr6D6K98n0FEdxQM57JuuggagY+xB+eBzAGnBQ0L86jCk+sP4
	 ZRABpQ5gP3y1sXwmQ7oC35hIV8r+twJtDUtS5oJIqVoKTgj4ZGQBclKaOQ4fFyEjTNtvL
	 4GDTbskjrGxnuem+9PFdd6b68advKWSdQKaWXDM2O905GXt3T+6RQ2lNgjjKnIeOgugoC
	 hhGS78On9S0HagNcAUAUhhvuFsqJHJX39690Mo7m2rgMWZKV0VhvtqWGfokSdsJN+Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/+1CVgmMHpm8PMnFbTW9zboMDd7JMf0Q1zeJjauGc60=;
	b=hA6ei5IU42EUHuP1Wp7Fq4ZKyLD1bN1wI2fQDH2x6PXmpuO13QUWFDUVHcL88VgJWfEv
	 lIRBjUKvtgED338Xro6QZwcBtLp6Vhl9vcHZBnLAf6+57oL5E/9/FeSLjlHjMHb9GQ4YR
	 DRXMlNmsbrFylOQYl9g97JQOQjlhluzG/BdWIAG0npSyu+msVNt+x93aUubGKisDwRMhR
	 /pcAokHUjtLGpWvzpMvo20fUW6vCMTEaI4YnoJ3bPj4XcrTUghDdsBGezo2Qz0PIzk/uq
	 AL4OMVOmOzehf+68ilkoxgOwwqajjnU3ynLIxDggc8uA5d8R/MW/J4R+yrreL4Mszdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uKboclDB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3AF606A9E5;
	Sat,  7 Nov 2026 15:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uKboclDB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EB21F0089F;
	Sat,  7 Nov 2026 15:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064285;
	bh=/+1CVgmMHpm8PMnFbTW9zboMDd7JMf0Q1zeJjauGc60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKboclDBRgrOAw5h+sUfu2rl/JJRXVd0Sm9Q5Trks7+92WGQ3OSksb8EgOSCfF7x1
	 cLauDoQ3hmQNIXCO229O2Hf9MpKmxccRvnbguC49NpZhvIIDsHVgyVNgGDiAmguvCz
	 5LTGapM2xuxmH3b40uaVglFsaUBt69hxzxcUdgYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0342/1257] iio: adc: ti-adc128s052: validate SPI match data
Date: Sat,  7 Nov 2026 08:43:58 -0500
Message-ID: <20261107134948.847151370@linuxfoundation.org>
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

[ Upstream commit 4ac257f2fd2a9cac00e748486fa003b4e1cc453e ]

SPI driver_override allows a device to bind to this driver without
matching either the firmware tables or SPI device ID table. In that
case, spi_get_device_match_data() returns NULL.

adc128_probe() also obtains the IIO device name by dereferencing the
result of spi_get_device_id(), which is NULL on the same override path.
The probe can therefore crash before it reaches the match data access.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data and use the always available SPI
modalias for the IIO device name.

Fixes: d5f0da0c6972 ("iio: adc: ti-adc128s052: Switch to use spi_get_device_match_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-adc128s052.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti-adc128s052.c b/drivers/iio/adc/ti-adc128s052.c
index 1899813c1aee3..f9a995ff403e0 100644
--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -195,12 +195,14 @@ static int adc128_probe(struct spi_device *spi)
 	adc = iio_priv(indio_dev);
 	adc->spi = spi;
 
-	indio_dev->name = spi_get_device_id(spi)->name;
+	config = spi_get_device_match_data(spi);
+	if (!config)
+		return -ENODATA;
+
+	indio_dev->name = spi->modalias;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &adc128_info;
 
-	config = spi_get_device_match_data(spi);
-
 	indio_dev->channels = config->channels;
 	indio_dev->num_channels = config->num_channels;
 
-- 
2.53.0



