Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590573;
	b=G58X1eXMFS40i7wa08goBMvaN5vjoJb2uGkFCK3LMxvjZB6tcm08/khSUvWGVPkpP/Vc
	 z7aQAJJXkG1JrMBCA1VHQEqV2PKTpIHoipdI73qRQIpRrsx1OsM1DKrn1nZqG3ocGytrK
	 R5eQa5mCXZ2AZI5YjO37Jbs0i7XD8Dmdr/1X4T2vMdQKCsNmbYlNObr0RZeO66C7TLb9w
	 FGiGkEHWo6P4Vs8mZhJxoM32X2qq5esKeqRQ5RMbZneDWgoQ/v3hE5SVdnFIZMO8EPZ7/
	 eBHFwyjgW4gszrykd3Sjl2TkekoOoiRUNJE1s+7x/1t3LK83fGi54LZo8dRZcjqNTqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mUT/tdUQs/ooLHW/1ybbI8wAdBPGsEtI+wVIT/b6B6g=;
	b=xgk2X8PlOfkN/cMxoJC5Kn+mqnHaLOcj3SeM2lKDRIGOtU7LJIJki2YqhbpDoakpkWtV
	 cKQfsScIddBFSYA5NaoElLCGIgM/hrvTxJ7/chuWK8eaxt7hzQu0iwWCsmi2STnRNka7a
	 dEPk3xpevdIz/J1VyOBOOSaxCd0nmtBpza3JwfI34h7I5ZTuvtstB1glCnc6wmm0rMOYr
	 WJZ0gOg6570YEQbum6+K7pJhfWMtpl4lyVJQjbEWka6AQsnPj01NzsOsqWpgIrKM8r0NZ
	 eS8cfQswWo78wHGjhqtSgHZUgJPfvNXjMwexpLIzvNH4SNc4nVbvoliCwRKndoWvI/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nZYNMLjY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20743606BD23;
	Fri, 13 Nov 2026 17:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nZYNMLjY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1941F000C4;
	Fri, 13 Nov 2026 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590573;
	bh=mUT/tdUQs/ooLHW/1ybbI8wAdBPGsEtI+wVIT/b6B6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZYNMLjYeUaK/UkgpfFvsyBpFwWHJWnY6nDJSqUu6XtMRtN4ZygvtQqgZIX9rG6s3
	 tPtVxIWcWZ5n4DVAem9nuHc+LF6mhPerZq0k/zAAxbCqbcwHs4T3phkqRhSCppOtwa
	 ukFkaXEezUjuiXqONl0b2nbl/A94r4+ejXS5zRJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 504/686] iio: adc: ad7192: reject devices without match data
Date: Fri, 13 Nov 2026 10:50:37 -0500
Message-ID: <20261113153837.985069139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 8b1664f6b102c..394137a127abb 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1402,6 +1402,9 @@ static int ad7192_probe(struct spi_device *spi)
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



