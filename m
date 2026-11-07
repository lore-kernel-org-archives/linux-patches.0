Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064283;
	b=3ckz1AMkVBJJyCbfqkKO5JArMMSqKx9auTOHPWQfNdNn1m/+L1rv9zDp5+C1tW1XVwqa
	 UBM4os/jJ4lH19FGDn/9kqpl2BNOzxHlSfeLvv0BvmCmbxABivJfTCTOXpvQlBdDOtBL7
	 wQGyULOEjUL7russyrVz4WxTcKxx4ZOQFErW3zVi8Io0PrYPjtfhAv+uIsDrvA28BBt9e
	 I1Es3YF9/hgrPb4tnapTPO5mg9OLvxNft1LiAy4Up1BN6S3FUvOWPJKUZ05p+6Y2Bc4zp
	 +GNGFBT4ZhHKfW2vrUKvhyS25WMNfBKDUk6uvDKhl1rObYoX/ozt2rwHyxhxFVzxT6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mQ6zgfphrONjo5Iq6K2PcD8gT40kljuYnBt2U4ehSvI=;
	b=EC670sTnnMqRgOZGGfJoM0maZteJnxxqJcrfyF8K5V8F/hhIi+eFD+g3BY1iqMLJiZz5
	 68TncCmuO7PXjS9faXRDvF7o1S88aVjHeb1zb5IDflnjcyc9NrUQnzndBW0YEOAf+8hTE
	 IfEDosE8/UhzvyPgY98kdcxLcJqjMF0g9zR3nmz3pYHJnO4s5EtEnihII1esp83kHeXZG
	 f6Fx3RVkvBFYr3X8xKw8eaw5VjVHDkNnbW5N7PaH0uzsVTMwzqD3siSHjLyXHQree8rNM
	 c0a81fwHvzwTYlEXIhaPZeegV7uFjOJ7PP5o1AApSTxLmNj12nN18E8hVQHQQ+7bC9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xq+/lW6X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C149606C006;
	Sat,  7 Nov 2026 15:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xq+/lW6X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3C41F008A1;
	Sat,  7 Nov 2026 15:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064283;
	bh=mQ6zgfphrONjo5Iq6K2PcD8gT40kljuYnBt2U4ehSvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xq+/lW6XEjHBNZXW9R/fwAs9maCWE6eFKRNh1gn9xV86TUaNGkvPFeCRGhanx9bYV
	 4xNz2B9Klr7LRF7WgpwkNBKvS6j9Aadr/xHsqy1oA2cPNk/mOQG9slgVyEcSINfQLp
	 nCCjKgrDSRkZSVXUvtRLWO96wGVtfTtNlgTNqbLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0340/1257] iio: adc: max11205: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:56 -0500
Message-ID: <20261107134948.794557369@linuxfoundation.org>
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
index 63b6561dcf475..53ac2f4f383e9 100644
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



