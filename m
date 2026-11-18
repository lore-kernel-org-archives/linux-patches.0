Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045202;
	b=oTg0K0BE4KaYCOy0pAjPxd6ilHikmStPNNEoH7ljwwE2eipob+f+90gcdhlHu0vy5iC2
	 DunazPz7w3so1zUXbr//r5NjgBW6xEW8TvLkyo6s1ygjTMi9zvLIMDGzvSgtUGdb/yI2p
	 4i5SAHYdkTuwDHUH11yPBpCB/OAd8aCPIdK5UTqH4ekoZE+lZCteNleiDzim76GBRBCSz
	 7NzTGF1NLgjjkpSMNzI4ForHlj52tlfyWtRqt3AnBQwIFIvyHhECPAbBVnXT7sualUoKW
	 +v+h8v9WL0hhjQZlFnp6k1TdleewY3t431BBxmgaa9HQPRdpJRdb1x1GGQI6rTKP33g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2WApkyQPk891DI2cEAcPPQ3+q7f5lVUnKDRXmmhy+Lo=;
	b=cjbzSFmlpURTC01MnD/XiuPoSDl7xPcLmYGccv1b4Tlge3YyrL4KGGkluYotfSo+aQ/R
	 rEpn1k7a1lHaCzFabldWdJKa/ykuomX0C2l7X5CEZd57vkEGBu+qyCcb4K+mA4aiKIvVz
	 nyTXhnLIqc5oX7b2S8F7bJhb6ymblWN/4m3gQ1Uo6eKgWexc+Z4D3++bA5ZCGeFWThcwr
	 qepaIhSG4w+9uBXwIK/DDqhbFk20qOSqRkuh5loHlzNM+/6BgiwripR9IQUTLyjgWMN8/
	 JelGlkMcxia+CwCcURRvDjjvSssaWCOHZDZTLfMjxSvlNl7JSBX+JUddozUHadzEscw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0wiR25RA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3677A606A320;
	Wed, 18 Nov 2026 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0wiR25RA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A77F1F000C5;
	Wed, 18 Nov 2026 23:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045202;
	bh=2WApkyQPk891DI2cEAcPPQ3+q7f5lVUnKDRXmmhy+Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wiR25RAkSrCTxCxYI4QBTDz2U6Cf0TCPtgKX3l7KYxAzOheQIdWifkBNuX3NLEBF
	 e588tmdUCOvdrt1Z0FOt/HdQEAm9E4wDtOOcNpF8CzEOD7btXeJ2sNv7MZ3Uf0eqQo
	 /yzDXTjMTIqCsAMrAAAWUNHg7hoCVci+TXWKCRoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shehryar Ahmad <shehryar.amd@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0788/2857] iio: accel: adis16201: fix channel order for buffer mode
Date: Wed, 18 Nov 2026 15:30:22 +0100
Message-ID: <20261118150229.939103861@linuxfoundation.org>
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

From: Shehryar Ahmad <shehryar.amd@gmail.com>

[ Upstream commit a4b9f1137b76faab6891ce0bd3f5c02dda7c392d ]

Reshuffle adis16201_channels to ascending scan_index order to avoid data
corruption during IIO core demultiplexing since the ADIS driver builds
the buffer in channel array order, while the IIO core demultiplexes it
in scan_index order.

This changes the raw buffer byte layout for existing adis16201 users
reading buffered data directly.

Fixes: 591298e54cea ("Staging: iio: accel: adis16201: Move adis16201 driver out of staging")
Cc: stable@vger.kernel.org
Signed-off-by: Shehryar Ahmad <shehryar.amd@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adis16201.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/adis16201.c b/drivers/iio/accel/adis16201.c
index f063226a42f37..a41c861ff8c02 100644
--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -202,19 +202,19 @@ static int adis16201_write_raw(struct iio_dev *indio_dev,
 }
 
 static const struct iio_chan_spec adis16201_channels[] = {
-	ADIS_SUPPLY_CHAN(ADIS16201_SUPPLY_OUT_REG, ADIS16201_SCAN_SUPPLY, 0,
-			 12),
-	ADIS_TEMP_CHAN(ADIS16201_TEMP_OUT_REG, ADIS16201_SCAN_TEMP, 0, 12),
 	ADIS_ACCEL_CHAN(X, ADIS16201_XACCL_OUT_REG, ADIS16201_SCAN_ACC_X,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
 	ADIS_ACCEL_CHAN(Y, ADIS16201_YACCL_OUT_REG, ADIS16201_SCAN_ACC_Y,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
-	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
 	ADIS_INCLI_CHAN(X, ADIS16201_XINCL_OUT_REG, ADIS16201_SCAN_INCLI_X,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
 	ADIS_INCLI_CHAN(Y, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(7)
+	ADIS_SUPPLY_CHAN(ADIS16201_SUPPLY_OUT_REG, ADIS16201_SCAN_SUPPLY, 0,
+			 12),
+	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
+	ADIS_TEMP_CHAN(ADIS16201_TEMP_OUT_REG, ADIS16201_SCAN_TEMP, 0, 12),
+	IIO_CHAN_SOFT_TIMESTAMP(7),
 };
 
 static const struct iio_info adis16201_info = {
-- 
2.53.0



