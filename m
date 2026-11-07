Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064189;
	b=DL40P/YuQVgTq8i6rttRgirMBYw5OUzjRF7/hVnW7dYnXxgUmXBckB1XneHU5etDk9N4
	 vCFfsE0n8H8T6yCloiGCOi5wM/Kf1lzr4DQ8g1HhlT+9iasOVc5l+GdIUcCQB1V52tlJH
	 g0bb7oxm0LreoSCE9Bt/9XFVBpBYM690N1aTrbm2izMuB/RxPScoHDNIrPjGwJc7VH7qH
	 o5KgybcrW4GVetp7Tj+6472JmzHlSA1FgT+UttOpmDtKdWuQFWan/78cCE8POGWH5q/vW
	 SzzShz6H8m3Sj8sYNlXZqpRQOprQI3Ih5uWGZpJERwnh2N62+5svji8Mb2MXb2wR3vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yni+G9xr7stMG64+bddj5NqDCKhxe5SUKTo9W4K2hbE=;
	b=OFVyqqReMY4O7qj4B5XzM5Cp90URNdmWoUIt5GHAWGGhXhcIjJh7UP05cMaK+qQG+7gi
	 GCoq/FjM/PS4WLNVqu4mIbqnMWkEFjvmwWX5NRQdfeu2pRSaH2+TMREt3ruH1Zk893BbK
	 EZMzvvBiQrv79le+zlItbVA3IZ88ko/g5P0HYzshohcDoWfss6vY+J7L7CaPSgtLQHVxS
	 +eAwwUNXJhmm0nSLqyJmnJ7wD75HY+xyLDfmSSj0/Vr5G02XqrrMOkOl4cESi+WlfFLZQ
	 FFSc812wzVhsF0F7nComDnviAYO2XlJH645SMaW9uV/nyEe6AtNjAK6Xgb2jMO9NbXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dC0BdsA4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA4606E8EF;
	Sat,  7 Nov 2026 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dC0BdsA4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CFF1F0089F;
	Sat,  7 Nov 2026 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064188;
	bh=Yni+G9xr7stMG64+bddj5NqDCKhxe5SUKTo9W4K2hbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dC0BdsA4G+uY6WbMZQmiH9c/uyQ/py+jegZNIde/y1qAaTsdLiDWh5kdCL8KbQwke
	 1jXX3Hvsge7Y2jspG4ECztcu1P5UjIlZ8HGRH1o+pMUMfSEN892Br1jDjJ+clbIM9q
	 ytlg5/aBtpCvLE8G8wTavwjtxwY6ibPQUiOrEnww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0330/1257] iio: amplifiers: ad8366: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:46 -0500
Message-ID: <20261107134948.534463663@linuxfoundation.org>
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

[ Upstream commit a3f438368c596040efbc44aa8a65e4e5ef2f3847 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but ad8366_probe() later dereferences the result while setting up the
IIO device.

Reject devices without match data before using the chip information.

Fixes: d5e02d0d00b9 ("iio: amplifiers: ad8366: add device tree support")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/amplifiers/ad8366.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/amplifiers/ad8366.c b/drivers/iio/amplifiers/ad8366.c
index e12f8604f59f4..9adff120de1ab 100644
--- a/drivers/iio/amplifiers/ad8366.c
+++ b/drivers/iio/amplifiers/ad8366.c
@@ -326,6 +326,8 @@ static int ad8366_probe(struct spi_device *spi)
 
 	st->spi = spi;
 	st->info = spi_get_device_match_data(spi);
+	if (!st->info)
+		return -ENODATA;
 
 	enable_gpio = devm_gpiod_get_optional(dev, "enable", GPIOD_OUT_HIGH);
 	if (IS_ERR(enable_gpio))
-- 
2.53.0



