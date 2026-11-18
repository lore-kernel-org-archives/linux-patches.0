Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054907;
	b=uvnM/9yjVC7srzFTVu+juLg8dX8rnCvPvIy0N2teLcwsZXq1kBhRbMlDqvZA/eL1hiZI
	 2pNXQfV7uXJDamWLFczORmfPS9eVVCuJqADtDmxMJpJFogZ/hw/cAcJRBgYZdltFXmS4Y
	 58NngniG4wT21t4HHZ4irAZEaKmW6+dlFcdeEinMK/M2dKwGoR8He8XxGs1OJ2ti60lAB
	 /be2GFMVChtHyHJ/7R/SFxM8adJRE/AqlFIasZ8wLMR7LdffPe+BA400Ub3UMRDDrgY5H
	 a4Tmw0m3oZ3Wsqb97Of8gQGU/MLpPpoDm/YHIWQYKSzg99qyf7uU76AWagtbw+ulyXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yaHKwhVX7KLHip1V1704FBxpt6LqfQZaPDVvXExPCvw=;
	b=MDcUCFQmBcMU/MqYyTveqKfvlOIwy+dVoGS+fMx0bSxaIyTiWypgHlDZM5VCsWI1Vmp7
	 eskbqCElFXJjwHaON+9InfJ+aaYoy0YR1hQ308w6vvx8Xn93psdkTSRraLyAXegIYDNu1
	 Q1qAkhVU9DcsaXSHTpqAyuqJEPhbpRUdSUzhEmGUIoCPnOiTyAzq6K370k2YF+zuv7H1w
	 rU6npZd0QgGwt5n3e5UldH6ih1RzkDyQWWxO9UVlRK5bRHH9rykRUfzr69VEpBVq7zFj3
	 iEx+SN+GKNBnTAjUVNBggo2/Y6RPcx7mxa6+QQlFhVJK/70D6kFZiBKiJxvpBFnoPjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zX0UKbfI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99512606A31C;
	Thu, 19 Nov 2026 02:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zX0UKbfI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27261F000C5;
	Thu, 19 Nov 2026 02:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054907;
	bh=yaHKwhVX7KLHip1V1704FBxpt6LqfQZaPDVvXExPCvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zX0UKbfIdeEc61WF9dnEXCk4+gCP1KsUnHgepEChZCTlAidYeCwQcqjdN4cxJIYTi
	 0AYPBe1eGPFCNpB8vS200FHuNBuvbPe4gRAqd467KBfBMF7wXTvTtA/n8OZ5oIhZ82
	 TCta+IHmQbTUpJCuiAa5Kb1KiBKWH2P9ly+L3RsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1442/2214] iio: imu: adis16400: Check return value of spi_setup()
Date: Wed, 18 Nov 2026 15:51:58 +0100
Message-ID: <20261118150108.818939672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5b5eca0663c87..253acc39656bf 100644
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



