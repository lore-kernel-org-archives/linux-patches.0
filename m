Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062120;
	b=VqHcfRos0LuJF7lG+tWpCLMfo0EzZhq4pyL4qwLCEMAR2mfWG8q+Frptdf79kczHuv/E
	 utHznZZQZOEtz9nfvOOqoZwRz5PeVCZZ74zQCjPqCHKKCbioSASMhyLWUOESqpOjqs+8/
	 dmpOjH4IVhcn1wl/bJuWy1ouAdTz2EMQvi0dWwTlsCusvdqdlm1PwMrgIWjyqehU3UHHO
	 dsDenQZa/NUFXFRKZAfkecXD5idFx7pYSKTZhWKpPJZjY2sXafhwDgs6Xh49TTCLn4Bss
	 JHPtrvzeGiU4H8nxyUuPOzW2MB5JQGHgBmiGU1MBzxB5NY968ZP9kNbgc6Wl54V6+GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UJB6qlKGQs/JMNLTceC3BDgfuAZ9BBMssLUrmrH/FSw=;
	b=TwUlAA1gMN+yMduZvMSEsgVtgsvjZMhMhNE4cmk65lkmqRHlniH+lk+z+LsydAFkgk5d
	 0B3io6T8kygl4kUfUrizyzH+swsNrbR4KGcRWVMSMWnVAD32Az5CXnlpB66szVRRYE+RO
	 E16RQYT+MyLdMrFoLiIyEx+IpgN97R8S5IJywWx+rBPrh6hH8cHCC1ep7LmBGjjJkOLJj
	 6XjhJDirzv0fOvonim5PBvUE7amOAcaWvTZuTdI8bSWHEoLuTtyyvqagbFeFKTDpUJifZ
	 lmbtbz+7kPnah1IUB1djxR/1qJkT2wfwX4KGWFlVr6bMC47uei74XkPd5MbpMjYw1lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPyuERs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98914606EE90;
	Sat,  7 Nov 2026 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPyuERs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C591F008A3;
	Sat,  7 Nov 2026 14:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062120;
	bh=UJB6qlKGQs/JMNLTceC3BDgfuAZ9BBMssLUrmrH/FSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPyuERs3ZVO+zwmrNqd1HzNDyKNiWa8H16WbKg4sjdP6qjbpovXXnJFezgpOTpWfN
	 94r7B4oUuVxQO8OH48DTivWL8Lt7CYc7zo9y+oA5TKfVKk0KpTmtVChAUI/QpFxbRG
	 iInwmz0GThiIMhO60qieM4CZ2hbLyrwXWXQ8sC7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1090/1536] iio: adc: max11205: reject devices without match data
Date: Sat,  7 Nov 2026 08:51:46 -0500
Message-ID: <20261107135028.314762976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit a07b5db685b2a3084240f9b4a9ee44f3b478c6e3 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

max11205_probe() immediately dereferences the returned chip information
to set the IIO device name, causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before using the chip information.

Fixes: bf3c855be801 ("iio: adc: max11205: simplify with spi_get_device_match_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max11205.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/max11205.c b/drivers/iio/adc/max11205.c
index 9d8bc0b154dd3..c14ad055b452d 100644
--- a/drivers/iio/adc/max11205.c
+++ b/drivers/iio/adc/max11205.c
@@ -117,6 +117,8 @@ static int max11205_probe(struct spi_device *spi)
 	ad_sd_init(&st->sd, indio_dev, spi, &max11205_sigma_delta_info);
 
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
 
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
-- 
2.53.0



