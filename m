Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058227;
	b=nCoBm4biUieUmoeZhxgf6x8dPzCQl/QAP38LxrRhZTuJWFBKea8PCysUexJjFyuYFubs
	 yAIKdy+99KHdckqDafqqNSDHC5RT4srPwSkUTCPdt5dq989pF711LNV5x0DP8E5kmnFg6
	 jVnC+P+KfaOshNPlIhdk9ZyS3tOWpCmEHaFMGhDFWaz4gdMhLfCpvV4mBGNWlXdO1k4/h
	 lsJVGUEzXwa8Lp8sWci33XX9CqlNZpEFlEM/shXtEhfDgMXX0ShS72Hn7PN+Ny9tkGvN3
	 YKhsfkim4pDGTkVQ4pZYuABjhnamMuEtC8e94miBKmiAhkUzDf1W4Y4FeeL8r9J2eew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mzkLo6E9bz9KfBzmb1cUHrgILIksDRODWN1K2EotuVI=;
	b=TrgzQj8fHTV4Baor1yzqwcsSGUI+8hbFMTChStLFW4m9ZfuMYQBHZNATVNdmz+EFos9A
	 vPqbwQ5Xi6IvePPshMJxsl/jbsBOmrObKgbJShFxrxVusbHwuA95B9lP+wbZt8YLJrFHl
	 U91RkbXjEvfUYaNpAAuuwA990p5YXhnRaTezii0M77TT1XOrw/w+JxcQ7oxsvAn9pXrmn
	 +Ks4fheKO2Yu4YusxxYlwJgEcRN09eRUZlZgrywzC4LEXC5VzoxW3ikDnRqXnN7H0/N0a
	 85IUPCF+YYFfXtEkt23Jy3HFWOhYEvn8iQ+FzlhPf/Xsr+4AEn0OhmBvA5kPQbVV0BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6be7+RN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781AE606A31C;
	Thu, 19 Nov 2026 03:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6be7+RN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE31F000C5;
	Thu, 19 Nov 2026 03:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058227;
	bh=mzkLo6E9bz9KfBzmb1cUHrgILIksDRODWN1K2EotuVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6be7+RNKTZzHQF92MUov0mErzGGPMssMjrSy8rS+DTJVjZ6K0nZf0iiwfwvEMajN
	 f5zGNHJYnwYIdOgJklG7Em1nby7ZTJ87JcLgt/n18qnfpelwOWjpUKHzB+U33Re+ZE
	 e9IFI6fMSDkbkyvfyKix/+J1VpUq3Qlk9snbktrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shehryar Ahmad <shehryar.amd@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0412/1848] iio: accel: adis16201: fix channel order for buffer mode
Date: Wed, 18 Nov 2026 15:40:50 +0100
Message-ID: <20261118145931.165064277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9b60ac5dadf02..6b7e87fe3f202 100644
--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -205,19 +205,19 @@ static int adis16201_write_raw(struct iio_dev *indio_dev,
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



