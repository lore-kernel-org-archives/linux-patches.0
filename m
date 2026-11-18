Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048185;
	b=Ho/ggizfQfxrU8iooRp4NTeIMeslDRCzsFtXZLEEALTemMvHmj39vp/+Wi4UVs61Hd1H
	 oCqVPcpQ64CcIT12HmvxpE2nQh2W34gg6zPMayuGflI4gYaTBBmYJh0japJLiJqGmtQ33
	 GIj3qNHX4DHLdmnHZ/fIStxm9gkvXLxSCqz9d4tVpOp63U0U1VsIFx7rjAtIXTHmGTacJ
	 elDTil3sFEXyKxFYtGjFluGJ84GnjxJwwvYza9idQBnRxG6IjftnWSuD0ZO3rV8CoRzlI
	 AtZaOFqETBDMyqFBftIHOWDRQStZ89bEkrvaYTncV9fg1pUvuPqqiM6gVXprUtTJt/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2uLCkYVDv2HeV0A06EZnyBU78mWdwhavu1rzzPAoNs=;
	b=oUPKsNw+2S2i6Ude0icNfQh2yGRM8wXCwGnsNFoJPmY0jDmCuZUQjv0R2ETDWV2SblYW
	 DWlZEnDFpH4afTlw4AnriU41NeyiyovI/ySKx7abd7EkK7mS4mnlsvHF8L1tWdGf4ceJK
	 rJYo+A/ti5vcqZ+qv97RhQTpFg3zXYPNe6MFDs2fcdApT9jQvU0wXqX3VNHkoUvnI3qhz
	 Iw2DTyJdQ3wxxw2sAXLznFg7C053a6/pl2Spedh6M09b21BhpvfdcesYTALno0DbG0anU
	 RjMpCQt1ugHIKxYyjd8DU8oKdTd8PslkiAJxv/c2obUv6nG5qpF3AUw6OhjP518R5dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1mO2uRx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EB3606A31C;
	Thu, 19 Nov 2026 00:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1mO2uRx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A9D1F000C4;
	Thu, 19 Nov 2026 00:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048185;
	bh=s2uLCkYVDv2HeV0A06EZnyBU78mWdwhavu1rzzPAoNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1mO2uRxxafyJ3t4uD8Ny7vO+CgLa0mBLWdquhk8tSdMCTBMEaRm2zUnYxomla+mC
	 p5wz/ZcTa12cwXaWKiHrZ7yxvM/XvLy4NfQycq1dteWAcg1veSH09uwc8On7wIIRpp
	 Dw5PfJj3OQGtMFMc7omLYoFsS+jDM0mEypPiDVh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1865/2857] iio: imu: adis16400: Check return value of spi_setup()
Date: Wed, 18 Nov 2026 15:48:19 +0100
Message-ID: <20261118150308.384843509@linuxfoundation.org>
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
index f31d568efbc81..e4910d289a1df 100644
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
 
 	ret = adis_initial_startup(&st->adis);
 	if (ret)
-- 
2.53.0



