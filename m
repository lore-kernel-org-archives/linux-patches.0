Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029523;
	b=G8Djz3uoN+2mHNMEOVm6ZV870ITpgeMx308aQcq/NgikYlo4QMaykPJdPs3PJaYW5Rtd
	 CJGeK0ez1pYaLu5nfOnf8+ijqVCXE/NnBW+d2E7ewDttWQgvzUmm878VixU+k0vl+aGMu
	 mek1QQgutmON8a+VzAgmY8/dx8M42x8LtdRhWw8bjpxiCm/QURMNTcaBNmDAfW7iQdIn8
	 q6soMXmAyvrD317MJU3IqOj3x3zBlwXXwwCTebhBCmobXwqAEhjN0+2dEOiCO6kTmJ2m3
	 c07uDCXe7p9nKSuBLV/btZr6rKzJ9cDgd3az/LrWHwUWkBO9aITyfP4Yeg3F4Fjw/LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iU2DfWf6bOARQKdE6U+4vdKA7nkTr07bSUQ1zE/5EPs=;
	b=A2vCy18qQxd86+iyXKp9TOwsSlfZH7dEHVoc8WRxQ5KEtztCRQWuEoMzVnSm8Xyx9M7i
	 fX69wzliE28N1n2B9ewjh8VVLIw38yK1pIjjrNplXIqzNgLBWE/eBRywXiF9g/8sS6esX
	 JafrQcMIRw1B0+w1kgP1mXUV6FRinMRWq+1j7G8DQU6h1aWcMYGD+NoMcGSvvW7crYud/
	 Dc38gBQdyWLmUv/bDIJBYIUzZpozQezHzhP8nmGjSwcB9gex1k7GRvlIl2EuVQxHCP5y1
	 Li2ANgAYOc9Afz49/aNEz4tSBAwbLw/LC+5zAN/uMz9P+4AkoALONkHxtDml6PYaPQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NE+zMrzX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AC8606A31C;
	Wed, 18 Nov 2026 19:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NE+zMrzX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B221F000C4;
	Wed, 18 Nov 2026 19:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029522;
	bh=iU2DfWf6bOARQKdE6U+4vdKA7nkTr07bSUQ1zE/5EPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NE+zMrzXDnDd49NO96KCzlHSRhVHZSPSJK9jvZTVOZgEX7MJU9W33t3y7yhFXj6jj
	 Rn4/qTKady8lso/AGdAZFp7uNLPgnb8i55GSJmZmFcBBaZ2aNxkkmfSW7/wv9I3+lz
	 mb30dTm8T7WHqRIW56CX9kWqmcf1c0MnJL49FPIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0319/1756] iio: imu: adis16400: Check return value of spi_setup()
Date: Wed, 18 Nov 2026 15:40:46 +0100
Message-ID: <20261118150021.004952380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 2c291f6920f44..7c658122b6305 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -433,7 +433,10 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
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



