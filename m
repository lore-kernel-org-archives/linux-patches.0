Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023484;
	b=q+isDDQQxs//BoWk9pdiSgTbIavGAStIa5KpMRh2kBHLl1sqHvzkrG42620gi3bD8mgU
	 esxOfS+yAWSbLXVq7bJpo44/ZZPrIVCjsyI9W5VlVNGxGnEEVLm5I0pcwdMq4tqe3C6rP
	 PpQK+XB3jzZC37IZPuiFsY5nVuO8q/juZAd0J147Bnc3SJ+OYETXRkpKZ1c+d+CGcHuOc
	 jOC2cNN86mSFfYyVXQX07d79KM1euMECV4mH8QinHL+fW3eRX+tcRBgcxsB4pIP/7X9aC
	 Nsa3bA17f3bUnTu6Zcqll+opjNkdeLTriBokpomY/4/KSqooRC6f257fwprzrqXV6+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6/PWUlfgfzIZ2+7/JTr2lMWLiFPp8VLmYuKkF5scJL0=;
	b=warCukKnXxqOzGgMcpp755IJgIcWAslbjDiist4mg3bGId2RU6tophx99TOwt2aUA5uO
	 jQNpGqNnErH8sG3Cs3RxpU4/CsH81Cv7S/JMijKB+xC16hVpmTQcRmQfI34dSqdaOQPln
	 dzXr3Y9vD0cYGrdjFaujUJC14selG/6eTjZF9bsXZ+SpXx5JinopbtxxTw4Mt3nvKtMQ5
	 fYrkJhPdK5PiTX4BKcvmaAXjkUg63sWYZNViEXdnBhX+PM/UR+EFG7+tmKVei9iJ2ye6/
	 JUJMQjpuB5YXk3xSC0oF5/MTlzKDlLrjhvQvhPtfb3SNEA63jP68ivBQR+TZrAj8/Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpMzkW+7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF26606A31C;
	Wed, 18 Nov 2026 17:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpMzkW+7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8D61F000C7;
	Wed, 18 Nov 2026 17:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023484;
	bh=6/PWUlfgfzIZ2+7/JTr2lMWLiFPp8VLmYuKkF5scJL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpMzkW+7p/qUfmoEAtMer9fZRfiKMs4m7cUGnCo8+vOKwEv7QB14fBDjxG5fO+6fD
	 8EFFobb4rkPJRMjZc9MPR35niGSOyRO4QDwtXbtc6xHLs4sKn1zoL/FuxSI+tsZvny
	 vZSAJVi4M4iEaAzH9DEUij3TumrmT2iHAPGEUpLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0345/2151] iio: imu: adis16400: Check return value of spi_setup()
Date: Wed, 18 Nov 2026 15:34:40 +0100
Message-ID: <20261118150134.671320813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 9f8721c196a95..4b83f199c8e1b 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -420,7 +420,10 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
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



