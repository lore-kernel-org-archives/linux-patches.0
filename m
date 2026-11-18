Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039546;
	b=O+JGoh++ZAhUjgsolYhFZCQjdwkc0531xW1tfC49wUZ0dvhh9nrYf7dFAczn5WlH9N6W
	 pCFFJNkJrGU7w9UceU5JLSM1KUGnC2MxUPet4sP6G9qJRupaBZaEcdBkZQXv5fRuS8x5e
	 4qLuxyH3tAyxVhBYBSivhH/ESIdjFR9ppaC7ja46ZmzfOjg0I6z0Lqmn1y5/YRZfMuXX6
	 I4EYJnWHKXWLTumUyqHrA6fVt9aacOe13NhebfB1bYQdxjHDRCQ2sHSfUgYRD+ROuVp/4
	 Sl0pEZ7H6TBj8X3ZQsL5+HNvUbYXCX15F6+/hSSPrF1b+xM6o15LBHd3CKtRyyDMkAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eUhS2TuZ0OFxvFHCxMbhXtAF0hDxhbX59uKSLO4O8Rc=;
	b=47794Qw83v7TfTWjU0lpLubZ5Z3DvDSX55CmmOj0wf66ZHGS+am/wXqO2TIu/O8XDqW0
	 6KVjcLywoqXH1ZDDvH7OHYFtvTVZWYoA7HdGpSNF/ia5/UPRt/Wo5JuywDsk8pVux7WHG
	 U57nJ+D5cl6Y+kH4uXNuLkiEYV/DfHWwawNMhgij5yAQHpEOK/6UldghXVoJ7OrqAoZER
	 12to8w7k6E36qzEcwYCCaSe0UIhinwtD0bYhflc9mPQqV0P23GdeyF3Is7QQVfKlv0TdD
	 mVjYN+p3byXFIr9wu2+psqEzSbjzAVz0j0RKZqnRFmSJhVXTd9Lk7YE7ISR6Mn/Jnuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uioMfk1M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF7606A320;
	Wed, 18 Nov 2026 22:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uioMfk1M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BB41F000C4;
	Wed, 18 Nov 2026 22:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039546;
	bh=eUhS2TuZ0OFxvFHCxMbhXtAF0hDxhbX59uKSLO4O8Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uioMfk1MVxNVnfgo6S5Z6vhQF5xjiCxL02YLf+KZCTUMIHuXDCLEV3lNd7tlQDbqh
	 eHLgHiDqCLqK0g63r8hCjaSxLvLxNmGC5GopHzl0q36EPW0dwZGKkHeR82Q4SziI+E
	 J4RhbJBLJYqVjVsAM9rHDcpmXvTJHSTIejLp7bLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2137/3318] iio: imu: adis16400: Check return value of spi_setup()
Date: Wed, 18 Nov 2026 15:45:59 +0100
Message-ID: <20261118150426.173095047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit a7c07602e00596a45de8a4a700af96392953ed38 ]

In adis16400_initial_setup(), the return value of spi_setup() was ignored.
If SPI configuration fails, the driver would proceed with the
initialization anyway, leading to undefined behavior or silent failures
during device setup.

Check the return value of spi_setup() and return the error code immediately
if it fails.

Fixes: cd888a17f95f ("staging:iio:adis16400: Use adis library")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16400.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index eac7cfead5a78..962cb1b505123 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -443,7 +443,10 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
 	else
 		st->adis.spi->max_speed_hz = ADIS16400_SPI_FAST;
 	st->adis.spi->mode = SPI_MODE_3;
-	spi_setup(st->adis.spi);
+
+	ret = spi_setup(st->adis.spi);
+	if (ret)
+		return ret;
 
 	ret = __adis_initial_startup(&st->adis);
 	if (ret)
-- 
2.53.0



